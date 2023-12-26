module TOP(
		clk, 
		reset, 
		RX, 
		oRate,
		owSTART,
		owData,
		owClk1s
	);
input clk;
input reset;
input RX;
output [1:0]oRate;
output owSTART;
output [7:0]owData;
output owClk1s;

wire [1:0]wRate;
wire wSTART;
wire [7:0] oRXDATA;
wire [7:0] wData;
wire wClk1s;

assign oRate = wRate;
assign owSTART = wSTART;
assign owData = wData;
assign owClk1s = wClk1s;

MODE_CONTROL U0(
.clk(clk),
.reset(reset),
.idata(oRXDATA),
.oSTART(wSTART),
.orate_control(wRate),
.oData(wData)
);
uart_rx U1(
.clk(clk),
.rst_n(reset),
.rx(RX),
.data_out(oRXDATA)
);
 
DIV_Clk U2(
.iClk(clk),   /* 100 Mhz clock */
.iRSt_n(reset),
.iRate_control(wRate),/* 重置訊號 低準位(0)動作 */
.oClk1s(wClk1s)    /* 1Hz pulse */
);

endmodule
