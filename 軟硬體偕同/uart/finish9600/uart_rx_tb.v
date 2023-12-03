`timescale 1ns / 1ps
`define clk_period 20
`define bit_time (1 / 9600)
module uart_rx_tb;
 
	// Inputs
	reg clk;
	reg rst_n;
	reg rx;
 
	// Outputs
	wire [3:0] data_out;
	wire [7:0] data;
	wire [7:0] ot7seg;
	wire otbaud_clk;
	wire [12:0]otbaud_cnt;
	// Instantiate the Unit Under Test (UUT)
	TOP ttop (
		.clk(clk), 
		.rst_n(rst_n), 
		.rx(rx), 
		.oDEC(data_out),
		.oRXdata(data),
		.ot7seg(ot7seg),
		.otbaud_clk(otbaud_clk),
		.otbaud_cnt(otbaud_cnt)
	);
initial clk = 1;

always #(`clk_period/2) clk = ~clk;
//always #1 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		rx = 1;
 
		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
        rst_n = 1;
        
        #20;
        // Generate Start bit
        #`bit_time rx = 1'b0;
        // 8 data bits
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        // Generate Stop bit
        #`bit_time rx = 1'b1;

		  #20;       
		// Add stimulus here

        // Generate Start bit
        #`bit_time rx = 1'b0;
        // 8 data bits
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        // Generate Stop bit
        #`bit_time rx = 1'b1;
		  #20;
		  // Generate Start bit
        #`bit_time rx = 1'b0;
        // 8 data bits
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b1;
        #`bit_time rx = 1'b0;
        #`bit_time rx = 1'b0;
        // Generate Stop bit
        #`bit_time rx = 1'b1;
		  #500 $finish;
	end
      
endmodule
 