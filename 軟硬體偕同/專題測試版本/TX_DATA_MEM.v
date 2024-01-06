module TX_DATA_MEM(
clk,
reset,
iTX_RATE_STATE,
iRATE,
iTX_INITIAL,
iTX_NORMAL,
iTX_START_CONTROL,
oTX_DATA_MEM,
iFINISH
);
input clk;
input reset;
input iTX_RATE_STATE;
input [7:0]iRATE;
input iTX_INITIAL;
input iTX_NORMAL;
input iTX_START_CONTROL;
input iFINISH;
output [7:0]oTX_DATA_MEM;

reg [7:0] rTX_DATA;
reg [7:0] rTX_DATA_MEM_ENGLISH[25:0];
reg [7:0] rTX_DATA_MEM_NUMBER[9:0];
reg [7:0] rTX_DATA_MEM_RATE;
reg [5:0] rmem_counter;
assign oTX_DATA_MEM = rTX_DATA;



always@(negedge reset)begin
	if(!reset)begin
		rTX_DATA_MEM_ENGLISH[0] 	<= 	8'b01100001;//a
		rTX_DATA_MEM_ENGLISH[1] 	<= 	8'b01100010;//b
		rTX_DATA_MEM_ENGLISH[2] 	<= 	8'b01100011;//c
		rTX_DATA_MEM_ENGLISH[3] 	<= 	8'b01100100;//d
		rTX_DATA_MEM_ENGLISH[4] 	<= 	8'b01100101;//e
		rTX_DATA_MEM_ENGLISH[5] 	<= 	8'b01100110;//f
		rTX_DATA_MEM_ENGLISH[6] 	<= 	8'b01100111;//g
		rTX_DATA_MEM_ENGLISH[7] 	<= 	8'b01101000;//h
		rTX_DATA_MEM_ENGLISH[8] 	<= 	8'b01101001;//i
		rTX_DATA_MEM_ENGLISH[9] 	<= 	8'b01101010;//j
		rTX_DATA_MEM_ENGLISH[10] 	<= 	8'b01101011;//k
		rTX_DATA_MEM_ENGLISH[11] 	<= 	8'b01101100;//l
		rTX_DATA_MEM_ENGLISH[12] 	<= 	8'b01101101;//m
		rTX_DATA_MEM_ENGLISH[13] 	<= 	8'b01101110;//n
		rTX_DATA_MEM_ENGLISH[14] 	<= 	8'b01101111;//o
		rTX_DATA_MEM_ENGLISH[15] 	<= 	8'b01110000;//p
		rTX_DATA_MEM_ENGLISH[16] 	<= 	8'b01110001;//q
		rTX_DATA_MEM_ENGLISH[17] 	<= 	8'b01110010;//r
		rTX_DATA_MEM_ENGLISH[18] 	<= 	8'b01110011;//s
		rTX_DATA_MEM_ENGLISH[19] 	<= 	8'b01110100;//t
		rTX_DATA_MEM_ENGLISH[20] 	<= 	8'b01110101;//u
		rTX_DATA_MEM_ENGLISH[21] 	<= 	8'b01110110;//v
		rTX_DATA_MEM_ENGLISH[22] 	<= 	8'b01110111;//w
		rTX_DATA_MEM_ENGLISH[23] 	<= 	8'b01111000;//x
		rTX_DATA_MEM_ENGLISH[24] 	<= 	8'b01111001;//y
		rTX_DATA_MEM_ENGLISH[25] 	<= 	8'b01111010;//z
		/***************************************************/
		rTX_DATA_MEM_NUMBER[0] 	<= 	8'b00110000;//0
		rTX_DATA_MEM_NUMBER[1]	<= 	8'b00110001;//1
		rTX_DATA_MEM_NUMBER[2]	<= 	8'b00110010;//2
		rTX_DATA_MEM_NUMBER[3]	<= 	8'b00110011;//3
		rTX_DATA_MEM_NUMBER[4]	<= 	8'b00110100;//4
		rTX_DATA_MEM_NUMBER[5]	<= 	8'b00110101;//5
		rTX_DATA_MEM_NUMBER[6]	<= 	8'b00110110;//6
		rTX_DATA_MEM_NUMBER[7]	<= 	8'b00110111;//7
		rTX_DATA_MEM_NUMBER[8]	<= 	8'b00111000;//8
		rTX_DATA_MEM_NUMBER[9]	<= 	8'b00111001;//9
	end
end

always@(posedge iFINISH or posedge iTX_RATE_STATE or negedge reset)begin
	if(!reset)begin
		rmem_counter <= 6'd0;
		rTX_DATA <= 8'b11111111;
	end
	else if(iFINISH)begin
		rmem_counter <= 6'd0;
		rTX_DATA <= 8'b11111111;
	end
	else if((iTX_START_CONTROL == 1'd1) && (iTX_RATE_STATE == 1'd1))begin	
		if(rmem_counter == 6'd35)rmem_counter <= 6'd0;
		else begin
			case (rmem_counter)
				6'd0: rTX_DATA <= rTX_DATA_MEM_ENGLISH[2]; 		// c
				6'd1: rTX_DATA <= rTX_DATA_MEM_ENGLISH[20]; 		// u
				6'd2: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd3: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17]; 		// r
				6'd4: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4]; 		// e
				6'd5: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13]; 		// n
				6'd6: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd7: rTX_DATA <= 8'b0010_0000; 						// 
				6'd8: rTX_DATA <= rTX_DATA_MEM_ENGLISH[18]; 		// s
				6'd9: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd10: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd11: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd12: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd13: rTX_DATA <= 8'b0011_1010;						// :
				6'd14: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd15: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd16: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd17: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd18: rTX_DATA <= 8'b0010_0000;						// 
				6'd19: rTX_DATA <= rTX_DATA_MEM_ENGLISH[2]; 		// c
				6'd20: rTX_DATA <= rTX_DATA_MEM_ENGLISH[14]; 	// o
				6'd21: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13]; 	// n
				6'd22: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 	// t
				6'd23: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17]; 	// r
				6'd24: rTX_DATA <= rTX_DATA_MEM_ENGLISH[14]; 	// o
				6'd25: rTX_DATA <= rTX_DATA_MEM_ENGLISH[11]; 	// l
				/*********************************************************/
				6'd26: rTX_DATA <= 8'b0010_0000;						// 
				6'd27: rTX_DATA <= 8'b0010_0000;						// 
				6'd28: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd29: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd30: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd31: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd32: rTX_DATA <= 8'b0011_1010;						// :
				6'd33: rTX_DATA <= iRATE;				// HZ
				6'd34: rTX_DATA <= 8'b00001010; //換行
			default: rTX_DATA <= 8'b11111111; // 如果没有匹配，设置为默认值
			endcase
			rmem_counter <= rmem_counter +6'd1;
		end	
	end
	else if((iTX_INITIAL == 1'd1) && (iTX_RATE_STATE == 1'd1))begin	
		if(rmem_counter == 6'd35)rmem_counter <= 6'd0;
		else begin
			case (rmem_counter)
				6'd0: rTX_DATA <= rTX_DATA_MEM_ENGLISH[2]; 		// c
				6'd1: rTX_DATA <= rTX_DATA_MEM_ENGLISH[20]; 		// u
				6'd2: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd3: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17]; 		// r
				6'd4: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4]; 		// e
				6'd5: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13]; 		// n
				6'd6: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd7: rTX_DATA <= 8'b0010_0000; 						// 
				6'd8: rTX_DATA <= rTX_DATA_MEM_ENGLISH[18]; 		// s
				6'd9: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd10: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd11: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd12: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd13: rTX_DATA <= 8'b0011_1010;						// :
				6'd14: rTX_DATA <= rTX_DATA_MEM_ENGLISH[8];		// i
				6'd15: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13];		// n
				6'd16: rTX_DATA <= rTX_DATA_MEM_ENGLISH[8];		// i
				6'd17: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd18: rTX_DATA <= rTX_DATA_MEM_ENGLISH[8];		// i
				6'd19: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0]; 		// a
				6'd20: rTX_DATA <= rTX_DATA_MEM_ENGLISH[11]; 	// l
				6'd21: rTX_DATA <= 8'b0010_0000; 					// 
				6'd22: rTX_DATA <= 8'b0010_0000; 					// 
				6'd23: rTX_DATA <= 8'b0010_0000; 					// 
				6'd24: rTX_DATA <= 8'b0010_0000; 					// 
				6'd25: rTX_DATA <= 8'b0010_0000; 					// 
				/*********************************************************/
				6'd26: rTX_DATA <= 8'b0010_0000;						// 
				6'd27: rTX_DATA <= 8'b0010_0000;						// 
				6'd28: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd29: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd30: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd31: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd32: rTX_DATA <= 8'b0011_1010;						// :
				6'd33: rTX_DATA <= iRATE;				// HZ
				6'd34: rTX_DATA <= 8'b00001010; //換行
			default: rTX_DATA <= 8'b11111111; //
			endcase
			rmem_counter <= rmem_counter +6'd1;
		end	
	end
	else if((iTX_NORMAL == 1'd1) && (iTX_RATE_STATE == 1'd1))begin	
		if(rmem_counter == 6'd35)rmem_counter <= 6'd0;
		else begin
			case (rmem_counter)
				6'd0: rTX_DATA <= rTX_DATA_MEM_ENGLISH[2]; 		// c
				6'd1: rTX_DATA <= rTX_DATA_MEM_ENGLISH[20]; 		// u
				6'd2: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd3: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17]; 		// r
				6'd4: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4]; 		// e
				6'd5: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13]; 		// n
				6'd6: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd7: rTX_DATA <= 8'b0010_0000; 						// 
				6'd8: rTX_DATA <= rTX_DATA_MEM_ENGLISH[18]; 		// s
				6'd9: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19]; 		// t
				6'd10: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd11: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd12: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd13: rTX_DATA <= 8'b0011_1010;						// :
				6'd14: rTX_DATA <= rTX_DATA_MEM_ENGLISH[13];		// n
				6'd15: rTX_DATA <= rTX_DATA_MEM_ENGLISH[14];		// o
				6'd16: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd17: rTX_DATA <= rTX_DATA_MEM_ENGLISH[12];		// m
				6'd18: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd19: rTX_DATA <= rTX_DATA_MEM_ENGLISH[11]; 	// l
				6'd20: rTX_DATA <= 8'b0010_0000;  					// 
				6'd21: rTX_DATA <= 8'b0010_0000;  					// 
				6'd22: rTX_DATA <= 8'b0010_0000;  					// 
				6'd23: rTX_DATA <= 8'b0010_0000;  					// 
				6'd24: rTX_DATA <= 8'b0010_0000;  					// 
				6'd25: rTX_DATA <= 8'b0010_0000;  					// 
				/*********************************************************/
				6'd26: rTX_DATA <= 8'b0010_0000;						// 
				6'd27: rTX_DATA <= 8'b0010_0000;						// 
				6'd28: rTX_DATA <= rTX_DATA_MEM_ENGLISH[17];		// r
				6'd29: rTX_DATA <= rTX_DATA_MEM_ENGLISH[0];		// a
				6'd30: rTX_DATA <= rTX_DATA_MEM_ENGLISH[19];		// t
				6'd31: rTX_DATA <= rTX_DATA_MEM_ENGLISH[4];		// e
				6'd32: rTX_DATA <= 8'b0011_1010;						// :
				6'd33: rTX_DATA <= iRATE;				// HZ
				6'd34: rTX_DATA <= 8'b00001010; //換行
			default: rTX_DATA <= 8'b11111111; // 如果没有匹配，设置为默认值
			endcase
			rmem_counter <= rmem_counter +6'd1;
		end	
	end
	else rTX_DATA <= 8'b11111111;
end

endmodule