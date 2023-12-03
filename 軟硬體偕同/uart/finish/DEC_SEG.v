module DEC_SEG(
input [3:0] iDecimal,
output reg [7:0] o7seg
);
always@(*)begin
		case(iDecimal)
			4'd0:o7seg = 8'b00000011;//0
			4'd1:o7seg = 8'b10011111;//1
			4'd2:o7seg = 8'b00100101;//2
			4'd3:o7seg = 8'b00001101;//3
			4'd4:o7seg = 8'b10011001;//4
			4'd5:o7seg = 8'b01001001;//5
			4'd6:o7seg = 8'b01000001;//6
			4'd7:o7seg = 8'b00011111;//7
			4'd8:o7seg = 8'b00000001;//8
			4'd9:o7seg = 8'b00001001;//9
		default:o7seg = 8'b10010001;
		endcase
end
endmodule