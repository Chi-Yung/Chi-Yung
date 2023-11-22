
module test_tb;
 	 	reg tb_clk, tb_rst_n;
		wire clkout;
		wire [3:0] counter_4bit;
	
		initial begin
			$dumpfile("test.vcd");
			$dumpvars;
		end


		initial begin
			tb_clk = 1'b1;
			tb_rst_n = 1'b0;
			#10 tb_rst_n = 1'b1;
			#5_000_000  $finish;	
 	 	end
		
		 always #1 tb_clk = ~tb_clk;
	

		top u_top(.clk_in(tb_clk), .rst_n(tb_rst_n), .counter_up(counter_4bit));


endmodule

