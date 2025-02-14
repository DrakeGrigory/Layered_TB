
`timescale 1ps/1ps

module testbench_top;
  bit clk;
  bit aresetn;
  
  reg [7:0] data_out;
  always #5 clk = ~clk;
  

  initial
  begin
 	 clk = 0;
	  aresetn = 0;
    #7 aresetn = 1;
  end
  
  DUT_intf intf(clk, aresetn);

  test test1(intf);
  
	UUT dut1(
    .clk(intf.clk), 
    .rst(intf.aresetn),
    .opcode(intf.opcode),
    .data_in(intf.data_in),
    .acc_ce(intf.acc_ce),
    .cy(intf.cy),
    .data_out(intf.data_out)
  );

endmodule
