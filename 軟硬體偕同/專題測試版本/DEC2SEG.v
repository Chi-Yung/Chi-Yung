module DEC2SEG(
	input clk,
	input rst,
	input [3:0]iDEC,
	output [7:0]seg
);
reg [7:0] rSEG;

assign seg = rSEG;

always@(*) begin
	if(!rst) begin
		rSEG <= 8'b00000000;
	end else begin
		case(iDEC)
			4'b0000:rSEG = 8'b00000011; //0
			4'b0001:rSEG = 8'b10011111; //1
			4'b0010:rSEG = 8'b00100101; //2
			4'b0011:rSEG = 8'b00001101; //3
			4'b0100:rSEG = 8'b10011001; //4
			4'b0101:rSEG = 8'b01001001; //5
			4'b0110:rSEG = 8'b01000001; //6
			4'b0111:rSEG = 8'b00011111; //7
			4'b1000:rSEG = 8'b00000001; //8
			4'b1001:rSEG = 8'b00001001; //9
			default:rSEG = 8'b00000000; //dark
		endcase
	end
	
end

endmodule