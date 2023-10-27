module decimal_7seg(
input Reset_n,
input [3:0] iDecimal,
output reg [7:0] o7seg
);
always@(*)begin
	if(Reset_n)begin
		case(iDecimal)
			4'd0:o7seg = 8'b00000011;
			4'd1:o7seg = 8'b10011111;
			4'd2:o7seg = 8'b00100101;
			4'd3:o7seg = 8'b00001101;
			4'd4:o7seg = 8'b10011001;
			4'd5:o7seg = 8'b01001001;
			4'd6:o7seg = 8'b01000001;
			4'd7:o7seg = 8'b00011111;
			4'd8:o7seg = 8'b00000001;
			4'd9:o7seg = 8'b00001001;
			4'd10:o7seg = 8'b00010001;
			4'd11:o7seg = 8'b11000001;
			4'd12:o7seg = 8'b11100101;
			4'd13:o7seg = 8'b10000101;
			4'd14:o7seg = 8'b01100001;
			4'd15:o7seg = 8'b01110001;
		endcase
	end else o7seg = 8'b10010001;
end
endmodule