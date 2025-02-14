
`include "tb_generator.sv"
`include "tb_monitor.sv"
`include "tb_scoreboard.sv"
`include "tb_driver.sv"


class environment;
  generator gen;
  driver    driv;
  monitor   mon;
  scoreboard scb;
  mailbox   gen_2_drv_mb;
  mailbox   mon_2_scb_mb;
  mailbox drv_2_mon_sync_mb;
  event gen_ended;
  virtual DUT_intf DUT_virt_intf;
  
  //constructor
  function new(virtual DUT_intf DUT_virt_intf); //constructor does not get the argumnet in tb_test.sv
    this.DUT_virt_intf = DUT_virt_intf;
    gen_2_drv_mb = new();
    mon_2_scb_mb = new();
    drv_2_mon_sync_mb= new();
    gen = new(gen_2_drv_mb, gen_ended);
    driv = new(DUT_virt_intf, gen_2_drv_mb,drv_2_mon_sync_mb);
    mon  = new(DUT_virt_intf, mon_2_scb_mb,drv_2_mon_sync_mb);
    scb  = new(mon_2_scb_mb);
  endfunction

  //
  task pre_test();
    driv.reset();
  endtask
  
  //
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_tests == driv.trans_cnt);
    wait(mon.trans_cnt == scb.trans_cnt);
  endtask  
  
  task run;
    pre_test();
    test();
    post_test();
    #10 $finish;
  endtask
  
endclass
