module DIV_Clk(
        iClk,   /* 100 Mhz clock */
        iRSt_n,
		  iRate_control,/* 重置訊號 低準位(0)動作 */
        oClk1s,       /* 1Hz pulse */
);
input              iClk;  /* 100 Mhz clock */
input              iRSt_n;
input        [1:0] iRate_control;     /* 重置訊號 低準位(0)動作 */
output             oClk1s;     /* 1Hz clock */

parameter   CLOCKFREQ = 100_000_000; /* clock = 100Mhz*/
parameter   ExpectClk1 = 10000;  /* 1Hz *//////////////////////////////////////////////////////////////
parameter   ExpectClk5 = 8000;  /* 5Hz */
parameter   ExpectClk10 = 10;  /* 10Hz */
reg              rClkHz ;
reg    [31:0]    rDivCounter;

assign oClk1s = rClkHz ;
always@(posedge iClk or negedge iRSt_n) begin
    if(!iRSt_n) begin /* 初始暫存器 */
         rDivCounter<= 0; /* 計數器歸0 */
         rClkHz <= 0; /* o1sPulse歸0 */
    end else if(iRate_control == 2'b00)begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk1 * 2))-1)) begin
            rDivCounter<= 0; /* 計數器歸0 */ 
            rClkHz <= ~rClkHz ;  /* 反向 */
        end else begin
            rDivCounter<= rDivCounter+ 1; /* 計數器歸0 */ 
            rClkHz <= rClkHz ;  /* r1sPulse 保持訊號 */
        end
    end else if(iRate_control == 2'b01)begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk5 * 2))-1)) begin
            rDivCounter<= 0; /* 計數器歸0 */ 
            rClkHz <= ~rClkHz ;  /* 反向 */
        end else begin
            rDivCounter<= rDivCounter+ 1; /* 計數器歸0 */ 
            rClkHz <= rClkHz ;  /* r1sPulse 保持訊號 */
        end
    end else if(iRate_control == 2'b10)begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk10 * 2))-1)) begin
            rDivCounter<= 0; /* 計數器歸0 */ 
            rClkHz <= ~rClkHz ;  /* 反向 */
        end else begin
            rDivCounter<= rDivCounter+ 1; /* 計數器歸0 */ 
            rClkHz <= rClkHz ;  /* r1sPulse 保持訊號 */
        end
    end
	 else rClkHz <= 0;
end

endmodule
