module asc_to_dec (
  input [7:0] iASC,
  output reg [3:0] oDec
);

always@(iASC) begin
  case (iASC)
    8'b00110000: oDec = 4'b0000; // '0'
    8'b00110001: oDec = 4'b0001; // '1'
    8'b00110010: oDec = 4'b0010; // '2'
    8'b00110011: oDec = 4'b0011; // '3'
    8'b00110100: oDec = 4'b0100; // '4'
    8'b00110101: oDec = 4'b0101; // '5'
    8'b00110110: oDec = 4'b0110; // '6'
    8'b00110111: oDec = 4'b0111; // '7'
    8'b00111000: oDec = 4'b1000; // '8'
    8'b00111001: oDec = 4'b1001; // '9'
    default: oDec = 4'b0000; //
  endcase
end

endmodule
