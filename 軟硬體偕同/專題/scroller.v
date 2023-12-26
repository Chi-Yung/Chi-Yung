module scroller(
	input clk,
	input rst,
	input i_start, //enable
	input [3:0]DEC,
	input wr_en,
	output [11:0]DECO
);

reg [3:0] seg1,seg2,seg3;
reg [2:0] counter;
reg [11:0] rDECO;
assign DECO = rDECO;
parameter blk = 4'b1111;

always@(*) begin
	if(!rst) counter <= 3'd0;
	else if(i_start) counter <= counter + 1;
	else if(!i_start) counter <= 3'd0;
	else if(counter == 3'd6) counter <= 0 ;
	else counter <= counter; 
end
		
always@(posedge clk)begin
	if(wr_en)begin
		case(counter)
			3'd0:seg1 <= DEC;
			3'd1:seg2 <= DEC;
			3'd2:seg3 <= DEC;
		endcase	
	end
	else begin
		seg1 <= seg1;
		seg2 <= seg2;
		seg3 <= seg3;
	end
end
always@(*) begin
	if(!rst) rDECO <= {blk,blk,blk};
	else begin	
		case(counter)
			3'd0:rDECO = {blk,blk,blk};
			3'd1:rDECO = {blk,blk,seg1};
			3'd2:rDECO = {blk,seg1,seg2};
			3'd3:rDECO = {seg1,seg2,seg3};
			3'd4:rDECO = {seg2,seg3,blk};
			3'd5:rDECO = {seg3,blk,blk};
			3'd6:rDECO = {blk,blk,blk};
			default:rDECO = {blk,blk,blk};
		endcase
	end
end

endmodule