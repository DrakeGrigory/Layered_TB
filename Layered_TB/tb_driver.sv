
class driver;
  int trans_cnt=0; //number of transactions
  virtual DUT_intf DUT_virt_intf;
  mailbox gen_2_drv_mb;
    
  //constructor
  function new(virtual DUT_intf DUT_virt_intf, mailbox gen_2_drv_mb);
    this.DUT_virt_intf = DUT_virt_intf;
    this.gen_2_drv_mb = gen_2_drv_mb;
  endfunction
  
  
  //Reset task
  task reset;
    wait(DUT_virt_intf.aresetn);
    $display("[DRIVER] reset");
    DUT_virt_intf.data_in <= 0;
    DUT_virt_intf.opcode <= 0;
    DUT_virt_intf.acc_ce <= 0;
  endtask
  
  //++
  task main;
    forever
    begin
      transaction trans;

      gen_2_drv_mb.get(trans);
      @(posedge DUT_virt_intf.clk);
      DUT_virt_intf.data_in <= trans.data_in;
      DUT_virt_intf.opcode <= trans.opcode;
      DUT_virt_intf.acc_ce <= trans.acc_ce;

      $display("tr_%0d @%0.t  [DRIVER] CE: %0b   OPCODE: %0d   DATA_IN: %0d (0x%0h)", trans_cnt, $time, trans.acc_ce, trans.opcode, trans.data_in, trans.data_in);
      
      
      trans_cnt++;
    end
  endtask
         
endclass
