module TOP(
		clk, 
		reset, 
		RX, 
		oRate,
		owSTART,
		owData,
		owClk1s,
		oWRen,
		oFIFO_FULL
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
wire [1:0]wRate;
wire wSTART;
wire [7:0] oRXDATA; 
wire [7:0] wData;
wire wClk1s;
wire wFIFO_FULL;
//wire [3:0] wDEC;
wire woWRen;
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
.rd_en(0), 
.wr_data(wData), 
.rd_data(), 
.fifo_full(wFIFO_FULL), 
.fifo_empty()
);
/*scroller U3(
.clk(wClk1s),
.rst(reset),
.i_start(wSTART), //enable
.DEC(wDEC),
.wr_en(),
.DECO()
);
asc_to_dec U4(
.iASC(wData),
.oDec(wDEC)
);*/
endmodule
