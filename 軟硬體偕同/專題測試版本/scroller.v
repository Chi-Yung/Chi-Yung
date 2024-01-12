module scroller(
	input clk,
	input iDIV_clk,
	input rst,
	//input i_start, //enable
	input [3:0]DEC,
	//input wr_en,
	input  iRD,
	input iCLEAN,
	output [11:0]DECO,
	output oSTART
);

reg [3:0] seg1,seg2,seg3;
reg [3:0] initial_seg1,initial_seg2,initial_seg3;
reg [1:0] counter;
reg [2:0] scroller_counter;
reg wr_en,start;
reg [11:0] rDECO;
parameter blk = 4'b1111;

assign DECO = rDECO;
assign oSTART = start;

always@(posedge clk or negedge rst) begin
	if(!rst) wr_en <= 0;
	else wr_en <= iRD;
end

always@(posedge clk or negedge rst) begin //counter control
	if(!rst) begin
		counter <= 3'd0;
	end
	else if(wr_en)begin
		counter <= counter + 1;
	end
	else counter <= 0; 
end
always@(posedge iDIV_clk or negedge rst) begin //counter control
	if(!rst) begin
		scroller_counter <= 3'd0;
	end
	else if(scroller_counter == 3'd6 || iCLEAN == 1'b1)begin
		scroller_counter <= 0;
	end
	else if(start) scroller_counter <= scroller_counter + 1 ;
	else if(!start) scroller_counter <= scroller_counter + 1 ;
end	
always@(posedge clk or negedge rst)begin //reg read data from ASCII2DEC
	if(!rst) begin
		start <= 0;
		initial_seg1 <= 4'b0001;
		initial_seg2 <= 4'b0010;
		initial_seg3 <= 4'b0011;
	end
	else if(wr_en)begin
		case(counter)
			3'd0:seg1 <= DEC;
			3'd1:seg2 <= DEC;
			3'd2:begin 
				seg3  <= DEC;
				start <= 1;
				end
		endcase	
	end
	else if(iCLEAN)begin
		seg1 <= initial_seg1;
		seg2 <= initial_seg2;
		seg3 <= initial_seg3;
		start <= 0;
	end
	else begin
		seg1 <= seg1;
		seg2 <= seg2;
		seg3 <= seg3;
	end
end

always@(*) begin //ouput
	if(!rst) begin
		rDECO <= {blk,blk,blk};
	end
	else if(!start) begin 
		case(scroller_counter)
			3'd0:rDECO = {blk,blk,blk};
			3'd1:rDECO = {blk,blk,initial_seg1};
			3'd2:rDECO = {blk,initial_seg1,initial_seg2};
			3'd3:rDECO = {initial_seg1,initial_seg2,initial_seg3};
			3'd4:rDECO = {initial_seg2,initial_seg3,blk};
			3'd5:rDECO = {initial_seg3,blk,blk};
			3'd6:rDECO = {blk,blk,blk};
			default:rDECO = {blk,blk,blk};
		endcase
	end
	else  begin 
		case(scroller_counter)
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