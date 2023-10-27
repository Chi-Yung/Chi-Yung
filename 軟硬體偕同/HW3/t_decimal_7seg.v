module t_decimal_7seg;
	reg [3:0] iDecimal;
   wire [7:0] o7seg;
   reg Reset_n;
   integer i;
initial begin       
		  $dumpfile("test.vcd");
          Reset_n = 0;
          $monitor("reset_n = %b  ,iDecimal = %d o7seg = %d ", Reset_n, iDecimal, o7seg);
          #50;
          Reset_n = 1;
          #50;
			 for(i = 0;i < 16;i = i+1)
        begin
            iDecimal = i; 
            #50;
        end 
			#50 $finish;		  
    end 
decimal_7seg tdecimal_7seg(.iDecimal(iDecimal),.o7seg(o7seg),.Reset_n(Reset_n));	 
endmodule