`timescale 1ns / 1ps
`define clk_period 10
module uart_rx_tb;
 
	// Inputs
	reg clk;
	reg rst_n;
	reg rx;
 
	// Outputs
	//wire [3:0] data_out;

	//wire otbaud_clk;
	//wire [12:0]otbaud_cnt;
	// Instantiate the Unit Under Test (UUT)
	
	TOP ttop (
		.clk(clk), 
		.reset(rst_n), 
		.RX(rx)
		//.oDEC(data_out),
		
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
		  #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
        // Generate Start bit
        #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;

		  		  
		  
		  
		  #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;      
		// Add stimulus here

        // Generate Start bit
        #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
		  #20;
		  // Generate Start bit
        #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
		  #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
		  

		  #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		  #20;
		  
		  #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;   
		  #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
        // Generate Start bit
        #104166 rx = 1'b0;
        // 8 data bits
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        #104166 rx = 1'b1;
        #104166 rx = 1'b1;
        #104166 rx = 1'b0;
        #104166 rx = 1'b0;
        // Generate Stop bit
        #104166 rx = 1'b1;
   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  #104166
		   #104166
		  #104166
		  		  
		  
		  
		     
		// Add stimulus here
		  
		  #104166 $finish;
	end
      
endmodule
 