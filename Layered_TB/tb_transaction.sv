//----------------------------------------------------------
class transaction;
       bit signed [7:0]  data_out;
  rand bit signed [7:0]  data_in;  
  rand bit [3:0]  opcode;  
       bit        cy; 
  rand bit        acc_ce; 




  constraint constr_seq1  { 
     acc_ce  inside {1'b1};
     data_in inside {8'd25};
     opcode  inside {4'd3}; 
     }

  constraint constr_seq2  { 
     acc_ce  inside {1'b1};
     data_in inside {8'd30};
     opcode  inside {4'd2}; 
  }
  //constraint constr_data_in2  { data_in inside {[8'd50 : 8'd70]}; }
  //constraint constr_opcode   { opcode   == 4'b0011;  }
  //constraint constr_acc_ce   { acc_ce   == 1'b1;     }

  function new(bit [7:0] constraint_mask = 8'h00);
    this.constr_seq1.constraint_mode(constraint_mask[0]);
    this.constr_seq2.constraint_mode(constraint_mask[1]);
  endfunction

endclass
