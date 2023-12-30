module UART_TX_BAUD_GEN(
clk,
reset,
iTX_en,
oTX_BAUD_clk,
otX_FIFO_en
);
input clk;
input reset;
input iTX_en;
output oTX_BAUD_clk;
output otX_FIFO_en;
parameter BAUD_MAX  = 10416;
parameter bitwidth  = 10;
reg [13:0] BAUD_COUNTER;
reg [3:0] bit_counter;
always@(posedge clk or negedge reset)begin
	if(!reset)BAUD_COUNTER <= 14'd0;
	else if(iTX_en)begin
		if(BAUD_COUNTER == BAUD_MAX)BAUD_COUNTER <= 14'd0;
		else BAUD_COUNTER <= BAUD_COUNTER + 1'd1;
	end else BAUD_COUNTER <= 14'd0;		
end
always@(posedge clk or negedge reset)begin
	if(!reset)bit_counter <= 4'd0;
	else if(BAUD_COUNTER == BAUD_MAX)begin
		if(bit_counter == bitwidth)bit_counter <= 4'd0;
		else bit_counter <= bit_counter + 1'd1;
	end else bit_counter <= bit_counter;		
end

assign oTX_BAUD_clk = (BAUD_COUNTER == 14'd1) ? 1'b1 : 1'b0 ;
assign otX_FIFO_en = (bit_counter == 4'd1) ? 1'b1 : 1'b0 ;
endmodule