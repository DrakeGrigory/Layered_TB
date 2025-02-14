//----------------------------------------------------------
class transaction;
       bit [7:0]  data_out;
  rand bit [7:0]  data_in;  
  rand bit [3:0]  opcode;  
       bit        cy; 
  rand bit        acc_ce; 


  constraint constr_data_in  { data_in  == 8'h0F;    }
  constraint constr_opcode   { opcode   == 4'b0101;  }
  constraint constr_acc_ce   { acc_ce   == 1'b1;     }


endclass
