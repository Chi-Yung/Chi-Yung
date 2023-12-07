`timescale 1ns / 1ps
module rx_top_tb();
  reg            clk;	
  reg            rst;	
  reg            uart_rx;
  
  //wire [7:0]     rx_data;
  //wire           rx_done_sig;
  wire [7:0]     seg7;
  wire tclk_bps;
  integer         i;
  reg [7:0]      data_test=8'b0;
  rx_top u_rx_top(
    .clk(clk),
    .rst(rst), 
    .rx_pin_in(uart_rx), 
    .seg7(seg7),
	 .tclk_bps(tclk_bps)
    //.rx_data(rx_data),
    //.rx_done_sig(rx_done_sig)
    );	
  initial begin
    clk=0;
    //for (i=0;i<256;i=i+1) begin
        rst=1;  
        #15 rst=0;uart_rx=1;

        #10416 uart_rx=0;

      /*  #10416 uart_rx = data_test[0];
        #10416 uart_rx = data_test[1];
        #10416 uart_rx = data_test[2];
        #10416 uart_rx = data_test[3];
        #10416 uart_rx = data_test[4];
        #10416 uart_rx = data_test[5];
        #10416 uart_rx = data_test[6];
        #10416 uart_rx = data_test[7];*/

        #10416 uart_rx=0; 
        #10416 uart_rx=0;
        #10416 uart_rx=1;
        #10416 uart_rx=1;
        #10416 uart_rx=0;
        #10416 uart_rx=1;
        #10416 uart_rx=1;
		  #10416 uart_rx=1;
		  #10416 uart_rx=1;
		  #104166
		  #104166 $finish;
        //data_test = data_test + 1;
   // end
  end
  
  always #10 clk=~clk;
endmodule