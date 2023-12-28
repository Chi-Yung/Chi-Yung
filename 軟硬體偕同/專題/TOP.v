module TOP(
		clk, 
		reset, 
		RX, 
		oRate,
		owSTART,
		owData,
		owClk1s,
		oWRen,
		oFIFO_FULL,
		seg1,
		seg2,
		seg3
	);
input clk;
input reset;
input RX;
output [1:0]oRate;
output owSTART;
output [7:0]owData;
output owClk1s;
output oWRen;
output oFIFO_FULL;
output [6:0] seg1,seg2,seg3;
wire [1:0]wRate;
wire wSTART;
wire [7:0] oRXDATA; 
wire [7:0] wData;
wire wClk1s;
wire wFIFO_FULL;
wire wFIFO_EMPTY;
wire [7:0]wrDATA;
wire wren;
wire [3:0] wDEC;
wire woWRen;
wire [3:0] wDECo1,wDECo2,wDECo3;
assign oRate = wRate;
assign owSTART = wSTART;
assign owData = wData;
assign owClk1s = wClk1s;
assign oWRen = woWRen;
assign oFIFO_FULL = wFIFO_FULL;
MODE_CONTROL U0(
.clk(clk),
.reset(reset),
.idata(oRXDATA),
.oSTART(wSTART),
.orate_control(wRate),
.oData(wData),
.oWRen(woWRen)
);
uart_rx U1(
.clk(clk),
.rst_n(reset),
.rx(RX),
.data_out(oRXDATA)
);
 
DIV_Clk U2(
.iClk(clk),
.iRSt_n(reset),
.iRate_control(wRate),
.oClk1s(wClk1s)
);
fifo U3(
.clk(clk), 
.rstn(reset), 
.wr_en(woWRen), 
.rd_en(wren), 
.wr_data(wData), 
.rd_data(wrDATA), 
.fifo_full(wFIFO_FULL), 
.fifo_empty(wFIFO_EMPTY)
);
asc_to_dec U4(
.iASC(wrDATA),
.iFIFO_FULL(wFIFO_FULL),
.iFIFO_EMPTY(wFIFO_EMPTY),
.oFIFO_RD(wren),
.oDec(wDEC)
);
scroller U5(
.clk(clk),
.iDIV_clk(wClk1s),
.rst(reset),
//.i_start(), //enable
.DEC(wDEC),
.iRD(wren),
.DECO({wDECo3,wDECo2,wDECo1})
);
DEC2SEG U6(
.clk(clk),
.rst(rst),
.iDEC(wDECo1),
.seg(seg1)
);
DEC2SEG U7(
.clk(clk),
.rst(rst),
.iDEC(wDECo2),
.seg(seg2)
);
DEC2SEG U8(
.clk(clk),
.rst(rst),
.iDEC(wDECo3),
.seg(seg3)
);
endmodule
