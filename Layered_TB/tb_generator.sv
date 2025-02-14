
`include "tb_transaction.sv"

class generator; 
  rand transaction trans;
  mailbox gen_2_drv_mb;
  event trans_rdy;
  int  repeat_tests;  
  
  function new(mailbox gen_2_drv_mb, event trans_rdy);
    this.gen_2_drv_mb = gen_2_drv_mb;
    this.trans_rdy = trans_rdy;
  endfunction
  
  task main();
    repeat(repeat_tests)
    begin
      trans = new();
      trans.randomize();    
      gen_2_drv_mb.put(trans);
    end
   -> trans_rdy; 
  endtask  
endclass
