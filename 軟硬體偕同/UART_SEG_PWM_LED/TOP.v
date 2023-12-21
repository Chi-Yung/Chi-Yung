module TOP(clk,reset);
input clk;
input reset;
input RX;
  output [20:0] SEG
  output [7:0] LED
wire [1:0]wRate;
MODE_CONTROL(
.clk(clk),
.reset(reset),
.idata(),
.oSTART(),
.orate_control(wRate)
);
DIV_Clk(
.iClk(clk),   /* 100 Mhz clock */
.iRSt_n(reset),
.iRate_control(wRate),/* 重置訊號 低準位(0)動作 */
.oClk1s(),       /* 1Hz pulse */
);

endmodule
