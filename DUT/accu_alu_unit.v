`include "definy.v"

module UUT#(
parameter data_width = `data_width,
parameter op_code_width = `op_code_width
)(
input clk,
input rst,
input [op_code_width-1:0] opcode,
input acc_ce,
input [data_width-1:0] data_in,
output reg [data_width-1:0] data_out,
output cy);

    wire cy_alu_accu;
    wire [data_width-1:0] allu_to_accu_data;
    wire [data_width-1:0] accu_to_alu_data;

    accu #() accu_inst(
    .clk(clk),
    .ce(acc_ce),
    .rst(rst),
    .cy_i(cy_alu_accu),
    .cy_o(cy),
    .data_in(allu_to_accu_data),
    .data_out(accu_to_alu_data)
    );

    Alu #()alu_inst(
    .OP(opcode),
    .data_in(data_in),
    .cr_in(accu_to_alu_data),
    .cy(cy_alu_accu),
    .data_out(allu_to_accu_data)
    );

always @(*) begin
    data_out = accu_to_alu_data;
end

endmodule