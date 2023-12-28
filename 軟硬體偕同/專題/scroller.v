module scroller(
	input clk,
	input iDIV_clk,
	input rst,
	//input i_start, //enable
	input [3:0]DEC,
	//input wr_en,
	input  iRD,
	output reg [11:0]DECO
);

reg [3:0] seg1,seg2,seg3;
reg [1:0] counter;
reg [2:0] scroller_counter;
reg wr_en,start;

parameter blk = 4'b1111;

always@(posedge clk) begin
	wr_en <= iRD;
end

always@(posedge clk) begin //reset control
	if(!rst) begin
		DECO <= {blk,blk,blk};
		counter <= 3'd0;
		scroller_counter <= 3'd0;
		wr_en <= 0;
		start <= 0;
	end
	else DECO <= DECO;
end
	
always@(posedge clk) begin //counter control
	if(wr_en)begin
		counter <= counter + 1;
	end
	else counter <= 0; 
end
always@(posedge iDIV_clk) begin //counter control
	if(scroller_counter == 3'd6)begin
		scroller_counter <= 0;
	end
	else if(start) scroller_counter <= scroller_counter + 1 ; 
end	
always@(posedge clk)begin //reg read data from ASCII2DEC
	if(wr_en)begin
		case(counter)
			3'd0:seg1 <= DEC;
			3'd1:seg2 <= DEC;
			3'd2:begin 
				seg3  <= DEC;
				start <= 1;
				end
		endcase	
	end
	else begin
		seg1 <= seg1;
		seg2 <= seg2;
		seg3 <= seg3;
	end
end

always@(*) begin //ouput
	
	case(scroller_counter)
		3'd0:DECO = {blk,blk,blk};
		3'd1:DECO = {blk,blk,seg1};
		3'd2:DECO = {blk,seg1,seg2};
		3'd3:DECO = {seg1,seg2,seg3};
		3'd4:DECO = {seg2,seg3,blk};
		3'd5:DECO = {seg3,blk,blk};
		3'd6:DECO = {blk,blk,blk};
		default:DECO = {blk,blk,blk};
	endcase
end

endmodule