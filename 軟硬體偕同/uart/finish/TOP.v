`timescale 1ns / 1ps
module TOP(
    input clk,
    input rst_n,
    input rx,
	 output [3:0] oDEC,
	 output [7:0] oRXdata,
	 output [7:0] ot7seg
);
wire [7:0] oRx_data;
assign oRXdata = oRx_data;
uart_rx U0(
	.clk(clk),
	.rst_n(rst_n),
	.rx(rx),
	.data_out(oRx_data)
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