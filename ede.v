module EDE3(
input clk,
input reset,
input [9:0] iDEL,
output oWF);

reg [3:0] C [14:0];
integer k;
reg [11:0] counter;
reg [15:0] sum;
reg [9:0] data [2399:0];

always@(*) begin
	if(reset)begin
		counter <= 12'd0;
		sum <= 16'd0;
		for(k = 0; k < 15; k = k + 1)begin
			if(k<8)
				C[k] <= k + 1;
			else
				C[k] <= 15 - k;
		end
	end
end

always@(*)begin
	if(counter < 7)begin
		for(k = 0; k < 8 - counter; k = k + 1)
			sum <= sum + iDEL[0]*C[k];
		end
	    for(k = 8 - counter; k < 15; k = k+1)
			sum <= sum +data[counter + k - 7]* C[k]; 
		end
	end
	else if(6 < counter < 2393) begin
		for(k = 0; k < 15; k = k + 1) begin
			sum = sum + data[counter + k -7]* C[k];
		end
	end
	else if(counter > 2392)begin
		for(k = 14; k < 2406 - counter; counter = counter - 1) begin
			sum = sum + data[2399]*C[k];
		end
		for(k = 0; k < 2407 - counter; k = k + 1) begin
			sum = sum + data[counter + k -7] * C[k];
		end
	end
	
	counter = counter + 1;
			
end
