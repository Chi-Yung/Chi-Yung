module DIV_Clk(
        iClk,   /* 100 Mhz clock */
        iRSt_n,      /* 重置訊號 低準位(0)動作 */

        oClk1s       /* 1Hz pulse */
);
input              iClk;  /* 100 Mhz clock */
input              iRst_n;     /* 重置訊號 低準位(0)動作 */
output             oClk1s;     /* 1Hz clock */

parameter   CLOCKFREQ = 100_000_000; /* clock = 100Mhz*/
parameter   ExpectClk = 1;  /* 1Hz */
reg              rClk1Hz ;
reg    [31:0]    rDivCounter;

/* 產生1Hz有正負半周的時脈 */
assign oClk1s = rClk1Hz ;
always@(posedge iClk or negedge iRSt_n) begin
    if(!iRst_n) begin /* 初始暫存器 */
         rDivCounter<= 0; /* 計數器歸0 */
         rClk1Hz <= 0; /* o1sPulse歸0 */
    end else begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk * 2)-1)) begin
            rDivCounter<= 0; /* 計數器歸0 */ 
            rClk1Hz <= ~rClk1Hz ;  /* 反向 */
        end else begin
            rDivCounter<= rDivCounter+ 1; /* 計數器歸0 */ 
            rClk1Hz <= rClk1Hz ;  /* r1sPulse 保持訊號 */
        end
    end
end

endmodule
