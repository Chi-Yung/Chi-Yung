module ede(clk,reset,iDEL,oWF);
		input clk;
		input reset;
		input [9:0] iDEL;
		output [15:0] oWF;
		reg [3:0] C [14:0];
		integer k;
		integer n;
		reg [11:0] counter;
		reg [11:0] DATA_Counter;
		reg [15:0] sum;
		reg [9:0] data [2399:0]; 
		assign oWF = sum;
always@(*) begin
			if(reset) DATA_Counter <= 12'd0;      
			else DATA_Counter = DATA_Counter + 1;
end
always@(*) begin
			data[DATA_Counter] = iDEL;
end
always@(*) begin
			if(reset) begin
           C[k] <= 15'b0;
			end else begin
           for(k = 0; k <= 14; k = k + 1) begin
					if(k < 8)C[k] <= k + 1;
					else if (k >= 8 && k <= 14)C[k] <= 15 - k;
				end
        end
end
reg [3:0] NKcounter;
always@(*) begin
				if(reset) NKcounter <= 4'd0; 
				else if(NKcounter == 4'd15)NKcounter <= 4'd0;
				else NKcounter = NKcounter + 4'd1;
end
always@(*) begin
			if(reset) counter <= 12'd0;      
			else if(NKcounter == 4'd15) counter = counter + 12'd1;
			else counter <= counter;
end


always@(*) begin
	 		if(reset) sum <= 16'd0;    
			else if (counter >= 0 && counter <= 6) begin
            /*for (k = 0; k <= 7 - counter; k = k + 1) begin
                sum = sum + data[0] * C[k];
            end
            for (k = 8 - counter; k <= 14; k = k + 1) begin
                sum = sum + data[counter + k - 7] * C[k];
            end*/
				for (n = 0; n <= 14; n = n + 1) begin
                if(n <= 7 - counter)sum = sum + data[0] * C[n];
					 else sum = sum + data[counter + n - 7] * C[n];
            end			
        end else if (counter >= 7 && counter <= 2392) begin
            for (n = 0; n < 15; n = n + 1) begin
                sum = sum + data[counter + n - 7] * C[n];
            end
        end else if (counter >= 2393) begin
            /*for (k = 14; k >= 2406 - counter; k = k - 1) begin
                sum = sum + data[2399] * C[k];
            end
            for (k = 0; k < 2407 - counter; k = k + 1) begin
                sum = sum + data[counter + k - 7] * C[k];
            end*/
				 for (n = 0; n <= 14; n = n + 1) begin
                if(n >= 2406 - counter)sum = sum + data[2399] * C[n];
					 else sum = sum + data[counter + n - 7] * C[n];
            end			
        end
end
endmodule