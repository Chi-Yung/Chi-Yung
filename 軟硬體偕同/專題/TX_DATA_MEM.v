module TX_DATA_MEM(
clk,
reset,
iTX_RATE_STATE,
oTX_DATA_MEM
);
input clk;
input reset;
input iTX_RATE_STATE;
output [7:0]oTX_DATA_MEM;

integer i;
reg rTX_FIFO_WR;
reg [7:0] rTX_DATA;
reg [7:0] rTX_DATA_MEM[25:0];
reg [4:0] rmem_counter;
assign oTX_DATA_MEM = rTX_DATA;

always@(posedge iTX_RATE_STATE or negedge reset)begin
	if(!reset)begin
		for(i = 0; i < 26; i = i + 1)rTX_DATA_MEM[i] <= 0;
		rmem_counter <= 5'd0;
	end
	else if(iTX_RATE_STATE)begin
	case (rmem_counter)
        5'd0: rTX_DATA <= 8'b0110_0011; 		// c
        5'd1: rTX_DATA <= 8'b0111_0101; 		// u
        5'd2: rTX_DATA <= 8'b0111_0010; 		// r
        5'd3: rTX_DATA <= 8'b0111_0010; 		// r
        5'd4: rTX_DATA <= 8'b0110_0101; 		// e
        5'd5: rTX_DATA <= 8'b0111_0100; 		// n
        5'd6: rTX_DATA <= 8'b0010_0000; 		// t
        5'd7: rTX_DATA <= 8'b0010_0000; 		// 
        5'd8: rTX_DATA <= 8'b0111_0011; 		// s
        5'd9: rTX_DATA <= 8'b0111_0100; 		// t
        5'd10: rTX_DATA <= 8'b0110_0001;		// a
        5'd11: rTX_DATA <= 8'b0111_0100;		// t
        5'd12: rTX_DATA <= 8'b0110_0101;		// e
        5'd13: rTX_DATA <= 8'b0011_1010;		// :
        5'd14: rTX_DATA <= 8'b0111_0010;		// r
        5'd15: rTX_DATA <= 8'b0110_0001;		// a
        5'd16: rTX_DATA <= 8'b0111_0100;		// t
        5'd17: rTX_DATA <= 8'b0110_0101;		// e
        5'd18: rTX_DATA <= 8'b0010_0000;		// 
        5'd19: rTX_DATA <= 8'b0110_0011; 	// c
        5'd20: rTX_DATA <= 8'b0110_1111; 	// o
        5'd21: rTX_DATA <= 8'b0110_1110; 	// n
        5'd22: rTX_DATA <= 8'b0111_0100; 	// t
        5'd23: rTX_DATA <= 8'b0111_0010; 	// r
        5'd24: rTX_DATA <= 8'b0110_1111; 	// o
        5'd25: rTX_DATA <= 8'b0110_1100; 		// l
        default: rTX_DATA <= 8'b0000_0000; // 如果没有匹配，设置为默认值
      endcase
		rmem_counter <= rmem_counter +5'd1;
	end
	else rTX_DATA <= rTX_DATA;
end





endmodule