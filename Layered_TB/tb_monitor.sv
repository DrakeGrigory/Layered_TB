//----------------------------------------------------------
class monitor;
  virtual DUT_intf DUT_virt_intf;
  mailbox mon_2_scb_mb;
  int trans_cnt=0; 
  int trans_cnt_driver = 0;
  mailbox drv_2_mon_sync_mb;
  //constructor
  function new(virtual DUT_intf DUT_virt_intf, mailbox mon_2_scb_mb, mailbox drv_2_mon_sync_mb);
    this.DUT_virt_intf = DUT_virt_intf;
    this.mon_2_scb_mb = mon_2_scb_mb;
    this.drv_2_mon_sync_mb = drv_2_mon_sync_mb;
  endfunction
  
  //++
  task main();
    
    forever begin
      transaction trans;
      trans = new();

      drv_2_mon_sync_mb.get(trans_cnt_driver);
      wait((trans_cnt_driver)>trans_cnt);
      $display("\n DRV: %0d    MON: %0d",trans_cnt_driver,trans_cnt);


      @(posedge DUT_virt_intf.clk);
      
        trans.data_in  = DUT_virt_intf.data_in;
        trans.opcode   = DUT_virt_intf.opcode;
        trans.cy       = DUT_virt_intf.cy;
        trans.data_out = DUT_virt_intf.data_out;
        trans.acc_ce   = DUT_virt_intf.acc_ce;    
      

      $display("tr_%0d @%0.t [MONITOR] CE: %0b   OPCODE: %0h   DATA_IN: %0d (0x%0h)   DATA_OUT: %0d (0x%0h)   CY: %0b", 
       trans_cnt, $time, trans.acc_ce, trans.opcode, trans.data_in, trans.data_in,  trans.data_out,trans.data_out, trans.cy);
      
      
      mon_2_scb_mb.put(trans);
      trans_cnt ++;
    end
  endtask
  
endclass
