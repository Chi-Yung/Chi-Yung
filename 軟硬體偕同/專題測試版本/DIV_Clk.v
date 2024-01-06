module DIV_Clk(
        iClk,   // 100 Mhz clock
        iRSt_n,
		  iRate_control,
        oClk1s,
);
input              iClk;  // 100 Mhz clock 
input              iRSt_n;
input        [1:0] iRate_control;
output             oClk1s;

parameter   CLOCKFREQ = 100_000_000; /* clock = 100Mhz*/
parameter   ExpectClk1 = 1000;  /* 1Hz *//////////////////////////////////////////////////////////////
parameter   ExpectClk5 = 5000;  /* 5Hz *///////////////////////////////////////////////////////////////
parameter   ExpectClk10 = 10;  /* 10Hz */
reg              rClkHz ;
reg    [31:0]    rDivCounter;

assign oClk1s = rClkHz ;
always@(posedge iClk or negedge iRSt_n) begin
    if(!iRSt_n) begin
         rDivCounter<= 0;
         rClkHz <= 0;
    end else begin
	 case(iRate_control)
	 2'b00:begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk1 * 2))-1)) begin
            rDivCounter<= 0;
            rClkHz <= ~rClkHz ;
        end else begin
            rDivCounter<= rDivCounter+ 1;
            rClkHz <= rClkHz ;
        end
    end 
	 2'b01:begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk5 * 2))-1)) begin
            rDivCounter<= 0;
            rClkHz <= ~rClkHz ;
        end else begin
            rDivCounter<= rDivCounter+ 1;
            rClkHz <= rClkHz ;
        end
    end 
	 2'b11:begin
        if(rDivCounter >= ((CLOCKFREQ/(ExpectClk10 * 2))-1)) begin
            rDivCounter<= 0;
            rClkHz <= ~rClkHz ;
        end else begin
            rDivCounter<= rDivCounter+ 1;
            rClkHz <= rClkHz ;
        end
    end
	 default: rClkHz <= 0;
	 endcase
	 end
end

endmodule
