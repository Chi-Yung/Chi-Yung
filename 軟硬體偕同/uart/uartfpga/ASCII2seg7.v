module ASCII2seg7 (
    rst,
    ASCII,
    seg7_out
    );

input rst;
input [7:0] ASCII;
reg [7:0] seg7;
output [7:0] seg7_out;
always@( posedge rst )
begin
//if ( rst ) begin
    case (ASCII)
        8'b0011_0000:
            seg7=~(8'b00000011);
        8'b0011_0001:
            seg7=~(8'b10011111);
        8'b0011_0010:
            seg7=~(8'b00100101);
        8'b0011_0011:
            seg7=~(8'b00001101);
        8'b0011_0100:
            seg7=~(8'b10011001);
        8'b0011_0101:
            seg7=~(8'b01001001);
        8'b0011_0110:
            seg7=~(8'b01000001);
        8'b0011_0111:
            seg7=~(8'b00011111);
        8'b0011_1000:
            seg7=~(8'b00000001);
        8'b0011_1001:
            seg7=~(8'b00001001);
        8'b0100_0001:
            seg7=~(8'b00010001);
        8'b0100_0010:
            seg7=~(8'b11000001);
        8'b0100_0011:
            seg7=~(8'b11100101);
        8'b0100_0100:
            seg7=~(8'b10000101);
        8'b0100_0101:
            seg7=~(8'b01100001);
        8'b0100_0110:
            seg7=~(8'b01110001);
        default:
            seg7=~(8'b01100001);
    endcase
    //end
    //else seg7=7'b1111111;
end
assign seg7_out=seg7;
endmodule
