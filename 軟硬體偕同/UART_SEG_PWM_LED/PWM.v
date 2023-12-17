module PWM_example
(
	input clk,
	input reset_n,
	output oPWM0,
	output oPWM1,
	output oPWM2,
	output oPWM3,
	output oPWM4,
	//output reg [1:0]counter，reg想要模擬波型的話要拉到output port
);
reg [1:0]counter;

	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			counter	<=	0;
		end else begin
			if(counter >= 3)begin
				counter	<=	0;
			end else begin
				counter	<=	counter + 1;
			end
		end
	end
assign oPWM0 = (counter < 0) ? 1'b1 : 1'b0;
assign oPWM1 = (counter < 1) ? 1'b1 : 1'b0;
assign oPWM2 = (counter < 2) ? 1'b1 : 1'b0;
assign oPWM3 = (counter < 3) ? 1'b1 : 1'b0;
assign oPWM4 = (counter < 4) ? 1'b1 : 1'b0;


endmodule
