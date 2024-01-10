module led( 
	input clk,
	input rst,
	input [2:0]ipwm,
	output oled
)

parameter dlk=3'd0,bt1=3'd1,bt2=3'd2,bt3=3'd3,bt4=3'd4;
reg [3:0]counter;

always@(clk) begin
	if(!rst) oled <= 0;
	else oled <= oled;
end

always@(clk) begin
	if(counter < 4) counter <= counter + 1;
	else counter <= counter ;	
end

always@(*) begin
	case(ipwm)
		dlk: oled = (counter < 0)?1'b1:1'b0; 
		bt1: oled = (counter < 1)?1'b1:1'b0; 
		bt2: oled = (counter < 2)?1'b1:1'b0; 
		bt3: oled = (counter < 3)?1'b1:1'b0; 
		bt4: oled = (counter < 4)?1'b1:1'b0; 
	endcase
end