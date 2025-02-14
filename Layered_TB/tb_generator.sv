`define EN_ON  8'h01
`define EN_OFF 8'h02
`define SEQ_REP 50

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

// task seq1();
//     int i = 0;
//       repeat(10)
//       begin
//         trans = new(8'h01);
//         trans.randomize();    
//         gen_2_drv_mb.put(trans);
//         i++;
//         //$display("Trans: seq1: %0d inputed into mailbox",i); 
//       end
//     $display("seq1- tr_count: %0d inputed into mailbox",i); 
// endtask

task seq(string name,byte rep, byte mask, bit [3:0] opcode = 4'd8);
    int i = 0;
      repeat(rep)
      begin
        trans = new(mask);
        trans.randomize();
        if(opcode <= 4'd7) trans.set_opcode(opcode);
        gen_2_drv_mb.put(trans);
        i++;
        //$display("Trans: %0s: %0d inputed into mailbox",name,i); 
      end
    $display("%0s - tr_count: %0d inputed into mailbox",name,i); 
    
endtask

//Checks ADD operation and overflow case of Black Box.
task seq_test1(byte seq_rep);
  $display("\nTEST_1 ---")
  seq("ADD_en1",seq_rep,`EN_ON ,4'd2);
  seq("ADD_en0",seq_rep,`EN_OFF,4'd2);
endtask

//Checks SUB operation and underflow case of Black Box.
task seq_test2(byte seq_rep);
  seq("SUB_en1",seq_rep,`EN_ON ,4'd3);
  seq("SUB_en0",seq_rep,`EN_OFF,4'd3);
endtask

//Checks LD, ST, NOP, default operations of Black Box.
task seq_test3(byte seq_rep);
  seq("LD_en1" ,seq_rep,`EN_ON ,4'd0);
  seq("LD_en0" ,seq_rep,`EN_OFF,4'd0);
  seq("ST_en1" ,seq_rep,`EN_ON ,4'd1);
  seq("ST_en0" ,seq_rep,`EN_OFF,4'd1);
  seq("NOP_en1",seq_rep,`EN_ON ,4'hF);
  seq("NOP_en0",seq_rep,`EN_OFF,4'hF);
  seq("def_en1",seq_rep,`EN_ON );
  seq("def_en0",seq_rep,`EN_OFF);  
endtask

//Checks AND, OR, XOR, NOT operations of Black Box.
task seq_test4(byte seq_rep);
  seq("AND_en1",seq_rep,`EN_ON ,4'd4);
  seq("AND_en0",seq_rep,`EN_OFF,4'd4);
  seq("OR_en1" ,seq_rep,`EN_ON ,4'd5);
  seq("OR_en0" ,seq_rep,`EN_OFF,4'd5);
  seq("XOR_en1",seq_rep,`EN_ON ,4'h6);
  seq("XOR_en0",seq_rep,`EN_OFF,4'h6);
  seq("NOT_en1",seq_rep,`EN_ON ,4'h7);
  seq("NOT_en0",seq_rep,`EN_OFF,4'h7);  
endtask


task main();
  seq_test1(`SEQ_REP);
  seq_test2(`SEQ_REP);
  seq_test3(`SEQ_REP);
  seq_test4(`SEQ_REP);
  -> trans_rdy;
endtask  
// --------------------------------------------------------------

endclass
