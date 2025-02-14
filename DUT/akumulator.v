/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: akumulator
// 21.10.2024
/////////////////////////////////////
`include "definy.v"

module accu #(parameter data_width = `data_width)(
input clk,
input ce,
input rst,
input signed [data_width-1:0] data_in,
input cy_i,
output reg cy_o,
output reg signed [data_width-1:0]  data_out
);

always @(posedge clk, negedge rst) begin
  if(!rst) begin 
    data_out <= {data_width{1'b0}}; 
    cy_o <= 1'b0;
  end
  else if(ce) begin
    data_out <= data_in;
    cy_o <= cy_i;
  end
end
endmodule


