
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

      $display("[DRIVER] transfer %0d generated data in: %0h, alu operation value: %0h, ce: %b ", trans_cnt, trans.data_in, /*trans.alu_code.name(),*/ trans.opcode, trans.acc_ce);
      
      
      trans_cnt++;

    end
  endtask
         
endclass
