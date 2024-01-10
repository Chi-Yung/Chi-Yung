module ledseq(
	input clk,
	input rst,
	output [23:0]oPWM,
)

reg [3:0] counter0;

parameter dlk=3'd0,bt1=3'd1,bt2=3'd2,bt3=3'd3,bt4=3'd4;

always@(clk) begin
	if(!rst)begin
		counter	 	<=	0;
		counter1	<=	0;
	end
	else begin
		counter		<=	counter;
		counter1	<= 	counter1;
	end
end		

always@(clk) //counter
	if(counter < 8 ) 	counter <= counter + 1;
	else counter <= 0;
end

always@(*)
	case(counter) begin
		3'd0:oPWM	=	{dlk,dlk,dlk,dlk,dlk,dlk,dlk,bt1};
		3'd0:oPWM	=	{dlk,dlk,dlk,dlk,dlk,dlk,bt1,bt2};
		3'd0:oPWM	=	{dlk,dlk,dlk,dlk,dlk,bt1,bt2,bt3};
		3'd0:oPWM	=	{dlk,dlk,dlk,dlk,bt1,bt2,bt3,bt4};
		3'd0:oPWM	=	{dlk,dlk,dlk,bt1,bt2,bt3,bt4,bt3};
		3'd0:oPWM	=	{dlk,dlk,bt1,bt2,bt3,bt4,bt3,bt2};
		3'd0:oPWM	=	{dlk,bt1,bt2,bt3,bt4,bt3,bt2,bt1};
		3'd0:oPWM	=	{bt1,bt2,bt3,bt4,bt3,bt2,bt1,dlk};
	endcase
end


endmodule
	
	
	
	
	
	
	
	
	
	