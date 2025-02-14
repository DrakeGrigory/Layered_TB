//----------------------------------------------------------
class transaction;
       bit signed [7:0]  data_out;
  rand bit signed [7:0]  data_in;  
  rand bit        [3:0]  opcode;  
       bit               cy; 
  rand bit               acc_ce; 


  constraint constr_opcode_def  { 
     opcode  inside {[4'h8 : 4'hE]};
     }

  constraint constr_CE_1  { 
     acc_ce  inside {1'b1};
     }
  constraint constr_CE_0  { 
     acc_ce  inside {1'b0};
     }
//   constraint constr_seq2  { 
//      acc_ce  inside {1'b1};
//      data_in inside {8'd30};
//      opcode  inside {4'd2}; 
//   }

  function new(bit [7:0] constraint_mask = 8'h00); //it exist because it can exist and I am learning
    this.constr_CE_1.constraint_mode(constraint_mask[0]);
    this.constr_CE_0.constraint_mode(constraint_mask[1]);
  endfunction


  function set_opcode (bit[3:0] opcode); //it exist because it can exist and I am learning
     this.opcode = opcode;
  endfunction
endclass
