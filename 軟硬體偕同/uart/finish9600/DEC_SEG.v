module DEC_SEG(
input [3:0] iDecimal,
output reg [7:0] o7seg
);
always@(*)begin
		case(iDecimal)
			4'b0000:o7seg = 8'b00000011;//0
			4'b0001:o7seg = 8'b10011111;//1
			4'b0010:o7seg = 8'b00100101;//2
			4'b0011:o7seg = 8'b00001101;//3
			4'b0100:o7seg = 8'b10011001;//4
			4'b0101:o7seg = 8'b01001001;//5
			4'b0110:o7seg = 8'b01000001;//6
			4'b0111:o7seg = 8'b00011111;//7
			4'b1000:o7seg = 8'b00000001;//8
			4'b1001:o7seg = 8'b00001001;//9
		default:o7seg = 8'b10010001;
		endcase
end
endmodule