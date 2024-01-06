module MODE_CONTROL(clk,reset,idata,orate_control,oData,oWRen,oTX_RATE_STATE,oCLEAN,oFINISH);
input clk,reset;
input [7:0] idata;
output [7:0] oData;
output [1:0]orate_control;
output oWRen;
output oTX_RATE_STATE;
output oCLEAN;
output oFINISH;

parameter IDLE = 3'd0;
parameter START_CONTROL = 3'd1;
parameter CLEAN = 3'd2;
parameter NORMAL = 3'd3;
parameter FINISH_CONTROL = 3'd4;

reg [2:0] current_state,next_state;
reg [1:0] rate_control;
reg [7:0] data_buffer;
reg [7:0] Data;
reg roWRen;
reg rTX_RATE_STATE;
reg rCLEAN;
reg rFINISH;
assign oWRen = roWRen;
assign orate_control = rate_control;
assign oData = Data;
assign oTX_RATE_STATE = rTX_RATE_STATE;
assign oCLEAN = rCLEAN;
assign oFINISH = rFINISH;
always @ (posedge clk or negedge reset)begin
    if(!reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end 
always @ (*)begin
        case(current_state)
            IDLE : begin
					if(!reset)next_state = IDLE;
					else if(idata == 8'b01001101 || idata == 8'b01101101)next_state = START_CONTROL;//m or M
					else if(idata != 8'b01001101 && idata != 8'b01101101 && idata != 8'b00000000 && idata != 8'b01000110 && idata != 8'b01100110 && idata != 8'b01000011 && idata != 8'b01100011)begin
						next_state = NORMAL;
					end
					else if(idata == 8'b01000011 || idata == 8'b01100011)next_state = CLEAN;//c or C
					else begin
						next_state = IDLE;
					end
            end
            START_CONTROL : begin
					if(idata == 8'b01000110 || idata == 8'b01100110)next_state = FINISH_CONTROL;//f or F					
					else begin
					next_state = START_CONTROL;
					end
            end
				CLEAN : begin
					next_state = IDLE;
            end
				NORMAL:begin
					if(idata == 8'b01001101 || idata == 8'b01101101)next_state = START_CONTROL;//m or M
					else begin
					next_state = IDLE;
					end
				end
				FINISH_CONTROL:begin
					next_state = IDLE;
				end
				default : next_state = IDLE;
        endcase
end
always@(*)begin
	if(!reset)begin
		data_buffer <= 8'bx;
		Data <= 8'bx;
	end
	else if(current_state == IDLE)begin
		roWRen <= 1'b0;
		Data <= 8'bx;
		if(idata == 8'b01001101 || idata == 8'b01101101 || idata == 8'b01000110 || idata == 8'b01100110 || idata == 8'b01000011 || idata == 8'b01100011)data_buffer <= 8'bx;
		else data_buffer <= idata;
	end
	else if(current_state == NORMAL)begin
		Data <= data_buffer;
		roWRen <= 1;
	end 
	else if(current_state == START_CONTROL)begin
		roWRen <= 0;
		Data <= 8'bx;
		//rTX_RATE_STATE <= 1'b1;
	end
end
always@(*)begin
	if(!reset)begin
		rate_control <= 2'b00;
		rTX_RATE_STATE <= 1'b0;
		rCLEAN <= 1'b0;
		rFINISH <= 1'b0;
	end
	else if(next_state == START_CONTROL)begin // START_CONTROL
		rTX_RATE_STATE <= 1'b1;
		rCLEAN <= 1'b0;
		rFINISH <= 1'b0;
		case(idata)
			8'b00110001:rate_control <= 2'b00; //1
			8'b00110101:rate_control <= 2'b01; //5
			8'b01000001:rate_control <= 2'b11; //A
		default: rate_control <= rate_control;
		endcase
	end
	else if(next_state == CLEAN)begin // CLEAN
		rTX_RATE_STATE <= 1'b0;
		rCLEAN <= 1'b1;
		rate_control <= 2'b00;
		rFINISH <= 1'b0;
	end
	else if(next_state == FINISH_CONTROL)begin // FINISH_CONTROL
		rTX_RATE_STATE <= 1'b0;
		rCLEAN <= 1'b0;
		rate_control <= rate_control;
		rFINISH <= 1'b1;
	end
	else begin 
		rate_control <= rate_control;
		rTX_RATE_STATE <= 1'b0;
		rCLEAN <= 1'b0;
		rFINISH <= 1'b0;
	end
end
endmodule
