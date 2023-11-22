`timescale 1ns/100ps

// 4bit up_counter 
module counter_up(
		input clk,
		input rst_n,
		output reg [3:0] counter_out = 0
		);

		parameter COUNTER_NUMBER = 16;
		
		always@(posedge clk or negedge rst_n) begin
			if(!rst_n)
				counter_out <= 0;
			else begin	
				if (counter_out == (COUNTER_NUMBER - 1))
					counter_out <= 0;
				else
					counter_out <= counter_out + 1;
			end
		end
		
endmodule