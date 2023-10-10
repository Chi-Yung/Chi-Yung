module BCD(BCD_i,Reset_n,Preset,Dec_o);
input [3:0] BCD_i;
input Reset_n,Preset;
output reg[9:0] Dec_o;
always@(BCD_i or Reset_n or Preset,Dec_o)begin
	if(Reset_n == 1'd0)Dec_o = 10'b0000000000;
	else if(Reset_n == 1'd1 && Preset == 1'd0)begin
			case(BCD_i)
				4'b0000:Dec_o = 10'b1111111110;
				4'b0001:Dec_o = 10'b1111111101;
				4'b0010:Dec_o = 10'b1111111011;
				4'b0011:Dec_o = 10'b1111110111;
				4'b0100:Dec_o = 10'b1111101111;
				4'b0101:Dec_o = 10'b1111011111;
				4'b0110:Dec_o = 10'b1110111111;
				4'b0111:Dec_o = 10'b1101111111;
				4'b1000:Dec_o = 10'b1011111111;
				4'b1001:Dec_o = 10'b0111111111;
				4'b1010:Dec_o = 10'b1111111111;
				default Dec_o = 10'b1111111111;
				endcase
	end else if(Reset_n == 1'd1 && Preset == 1'd1)Dec_o = 10'b0000001111;
end
endmodule

