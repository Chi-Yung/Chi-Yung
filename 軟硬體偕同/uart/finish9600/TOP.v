`timescale 1ns / 1ps
module TOP(
    input clk,
    input rst_n,
    input rx,
	 //output [3:0] oDEC,
	 output [7:0] oRXdata,
	 output [7:0] ot7seg
	 //output otbaud_clk,
	 //output [12:0]otbaud_cnt
);
wire [7:0] oRx_data;
wire clkout_1s;
assign oRXdata = oRx_data;
/*clk_1s U3(
		.clk(clk),
		.rst_n(rst_n),
		.clkout_1s(clkout_1s)
		);*/
uart_rx U0(
	.clk(clk),
	.rst_n(rst_n),
	.rx(rx),
	.data_out(oRx_data),
	.obaud_clk(otbaud_clk),
	.obaud_cnt(otbaud_cnt)
    );
asc_to_dec U1(
	.iASC(oRx_data),
	.oDec(oDEC)
);
DEC_SEG U2(
	.iDecimal(oDEC),
	.o7seg(ot7seg)
);
endmodule