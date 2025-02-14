//----------------------------------------------------------
interface DUT_intf(
  input logic clk,
  input logic aresetn
);

  logic [7:0]  data_in;    
  logic [7:0]  data_out;  
  logic        cy;
  logic        acc_ce;
  logic [3:0]  opcode;

  //modport drv (output data_in, ci, ce, alu_code input clk, aresetn);

  //modport mon (input data_out, co);
  
endinterface
