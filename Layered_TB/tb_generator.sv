

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
   
// --------------------------------------------------------------

task seq1();
    int i = 0;
      repeat(10)
      begin
        trans = new(8'h01);
        trans.randomize();    
        gen_2_drv_mb.put(trans);
        i++;
        //$display("Trans: seq1: %0d inputed into mailbox",i); 
      end
    $display("seq1- tr_count: %0d inputed into mailbox",i); 
endtask


task seq2();
    int i = 0;
      repeat(10)
      begin
        trans = new(8'h02);
        trans.randomize();
        trans.set_opcode(4'd5);   
        gen_2_drv_mb.put(trans);
        i++;
        //$display("Trans: seq2: %0d inputed into mailbox",i); 
      end
    $display("seq2- tr_count: %0d inputed into mailbox",i); 
    
endtask






task main();
  seq1();
  seq2();
  -> trans_rdy;
endtask  
// --------------------------------------------------------------
  // task main();
  //   int i = 0;
  //     repeat(repeat_tests)
  //     begin
  //       trans = new();
  //       trans.randomize();    
  //       gen_2_drv_mb.put(trans);
  //       i++;
  //     end
  //   $display("Trans: count: %0d inputed into mailbox",i); 
  //   -> trans_rdy;
  // endtask  
endclass
