//----------------------------------------------------------
class monitor;
  virtual DUT_intf DUT_virt_intf;
  mailbox mon_2_scb_mb;
  int trans_cnt=0; 
  
  //constructor
  function new(virtual DUT_intf DUT_virt_intf, mailbox mon_2_scb_mb);
    this.DUT_virt_intf = DUT_virt_intf;
    this.mon_2_scb_mb = mon_2_scb_mb;
  endfunction
  
  //++
  task main;
    forever
    begin
      transaction trans;
      trans = new();

      @(posedge DUT_virt_intf.clk);
      
        trans.data_in  = DUT_virt_intf.data_in;
        trans.opcode   = DUT_virt_intf.opcode;
        trans.cy       = DUT_virt_intf.cy;
        trans.data_out = DUT_virt_intf.data_out;
        trans.acc_ce   = DUT_virt_intf.acc_ce;    
      
      $display("[MONITOR] transfer at time: %0.t \ndata_in: %0d, \nalu_op: %0h, \ndata_out: %0d, \ncarry_out: %0b", $time, trans.data_in, trans.opcode,  trans.data_out, trans.cy);
      
      mon_2_scb_mb.put(trans);
      trans_cnt ++;
    end
  endtask
  
endclass
