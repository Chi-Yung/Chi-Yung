`timescale 1ns / 1ps
module uart_rx_tb;
 
	// Inputs
	reg clk;
	reg rst_n;
	reg rx;
 
	// Outputs
	wire [3:0] data_out;
	wire [7:0] data;
	wire [7:0] ot7seg;
	// Instantiate the Unit Under Test (UUT)
	TOP ttop (
		.clk(clk), 
		.rst_n(rst_n), 
		.rx(rx), 
		.oDEC(data_out),
		.oRXdata(data),
		.ot7seg(ot7seg)
	);
always #1 clk = ~clk;
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
        #50 rx = 1'b0;
        // 8 data bits
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        #100 rx = 1'b1;
        #100 rx = 1'b0;
        #100 rx = 1'b1;
        #100 rx = 1'b1;
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        // Generate Stop bit
        #100 rx = 1'b1;

		  #20;       
		// Add stimulus here

        // Generate Start bit
        #50 rx = 1'b0;
        // 8 data bits
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        #100 rx = 1'b1;
        #100 rx = 1'b1;
        #100 rx = 1'b1;
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        // Generate Stop bit
        #100 rx = 1'b1;
		  #20;
		  // Generate Start bit
        #50 rx = 1'b0;
        // 8 data bits
        #100 rx = 1'b0;
        #100 rx = 1'b1;
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        #100 rx = 1'b1;
        #100 rx = 1'b1;
        #100 rx = 1'b0;
        #100 rx = 1'b0;
        // Generate Stop bit
        #100 rx = 1'b1;
		  #500 $finish;
	end
      
endmodule
 