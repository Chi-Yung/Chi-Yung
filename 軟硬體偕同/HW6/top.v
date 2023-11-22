`timescale 1ns/100ps

module top(
		input clk_in,
		input rst_n,
		output [3:0] counter_up
		);

        wire clk_1Hz;
		clk_1s u_clk_1s(.clk(clk_in), .rst_n(rst_n), .clkout_1s(clk_1Hz));
		counter_up u_counter_up(.clk(clk_1Hz), .rst_n(rst_n), .counter_out(counter_up));

endmodule