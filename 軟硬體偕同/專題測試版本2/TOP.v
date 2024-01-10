module TOP(
		clk, 
		reset, 
		RX, 
		/*seg1,
		seg2,
		seg3,*/
		oTXDATA
	);
input clk;
input reset;
input RX;

//output [6:0] seg1,seg2,seg3;
output oTXDATA;

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
wire wTX_BAUD_clk;
wire wtX_FIFO_en;
wire wTX_RATE_STATE;
wire [7:0]wTX_DATA;
wire wCLEAN;
wire [7:0] wTX_rate;
wire wTX_INITIAL;
wire wTX_NORMAL;
wire wTX_START_CONTROL;

MODE_CONTROL U0(
.clk(clk),
.reset(reset),
.idata(oRXDATA),
.orate_control(wRate),
.oData(wData),
.oWRen(woWRen),
.oCLEAN(wCLEAN)
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
.iCLEAN(wCLEAN),
//.i_start(), //enable
.DEC(wDEC),
.iRD(wren),
.DECO({wDECo3,wDECo2,wDECo1}),
.oSTART(wSTART)
);
DEC2SEG U6(
.clk(clk),
.rst(reset),
.iDEC(wDECo1),
.seg(seg1)
);
DEC2SEG U7(
.clk(clk),
.rst(reset),
.iDEC(wDECo2),
.seg(seg2)
);
DEC2SEG U8(
.clk(clk),
.rst(reset),
.iDEC(wDECo3),
.seg(seg3)
);
UART_TX_BAUD_GEN U9(
.clk(clk),
.reset(reset),
.oTX_BAUD_clk(wTX_BAUD_clk),
.otX_FIFO_en(wtX_FIFO_en)
);
UART_TX U10(
.clk(clk),
.reset(reset),
.iTX_BAUD_clk(wTX_BAUD_clk),
.iTX_FIFO_DATA(wTX_DATA),
.oTX_DATA(oTXDATA)
);

TX_DATA_MEM U11(
.clk(clk),
.reset(reset),
.iTX_RATE_STATE(wtX_FIFO_en),
.iRATE(wTX_rate),
.iTX_INITIAL(wTX_INITIAL),
.iTX_NORMAL(wTX_NORMAL),
.iTX_START_CONTROL(wTX_START_CONTROL),
.oTX_DATA_MEM(wTX_DATA)
);

UART_TX_FSM U12(
.clk(clk),
.reset(reset),
.idata(oRXDATA),
.iSTART(wSTART),
.oTX_rate(wTX_rate),
.oTX_INITIAL(wTX_INITIAL),
.oTX_NORMAL(wTX_NORMAL),
.oTX_START_CONTROL(wTX_START_CONTROL)
);
endmodule
