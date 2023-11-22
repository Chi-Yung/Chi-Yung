`timescale 1ns/100ps

//  clk generator feq=1Hz
module clk_1s(
		input clk,
		input rst_n,
		output reg clkout_1s = 0
		);
		
		parameter DIV_NUMBER =125_000_000;
		parameter DIV_NUMBER_DIV2 = 62_500_000;

		
		reg [26:0] counter = 0;
		
		always@(posedge clk or negedge rst_n) begin
			if(!rst_n) 
				counter <= 0;
			else begin
				if (counter == (DIV_NUMBER - 1))
					counter <= 0;
				else
					counter <= counter + 1;
			end				
		end
		
		
		always@(posedge clk or negedge rst_n) begin
			if(!rst_n)
				clkout_1s <= 1'b0;
			else begin
				if (counter < DIV_NUMBER_DIV2)
					clkout_1s <= 1'b0;
				else
					clkout_1s <= 1'b1;
			end
		end
								
endmodule