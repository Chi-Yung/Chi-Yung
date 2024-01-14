module UART_TX_FSM(clk,reset,idata,iSTART,oTX_rate,oTX_INITIAL,oTX_NORMAL,oTX_START_CONTROL);
input clk,reset;
input [7:0] idata;
input iSTART;
output oTX_INITIAL;
output oTX_NORMAL;
output oTX_START_CONTROL;
output [7:0] oTX_rate;

reg rTX_INITIAL;
reg rTX_NORMAL;
reg rTX_START_CONTROL;
reg [7:0] rTX_rate;
parameter IDLE = 2'd0;
parameter NORMAL = 2'd1;
parameter START_CONTROL = 2'd2;

assign oTX_INITIAL = rTX_INITIAL;
assign oTX_NORMAL = rTX_NORMAL;
assign oTX_START_CONTROL = rTX_START_CONTROL;
assign oTX_rate = rTX_rate;
reg [1:0] current_state,next_state;

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
					else if(iSTART)begin
						next_state = NORMAL;
					end
					else begin
						next_state = IDLE;
					end
            end
            START_CONTROL : begin
					if(idata == 8'b01000110 || idata == 8'b01100110)next_state = NORMAL;//f or F					
					else begin
					next_state = START_CONTROL;
					end
            end
				NORMAL:begin
					if(idata == 8'b01001101 || idata == 8'b01101101)next_state = START_CONTROL;//m or M
					else if(idata == 8'b01000011 || idata == 8'b01100011)next_state = IDLE;
					else begin
					next_state = NORMAL;
					end
				end
				default : next_state = NORMAL;
        endcase
end

always@(*)begin
	if(!reset)begin
		rTX_INITIAL <= 0;
		rTX_NORMAL <= 0;
		rTX_START_CONTROL <= 0;
		rTX_rate <= 8'b00110001;
	end
	else if(next_state == IDLE)begin
		rTX_INITIAL <= 1;
		rTX_NORMAL <= 0;
		rTX_START_CONTROL <= 0;
		rTX_rate <= 8'b00110001;
	end
	else if(next_state == START_CONTROL)begin // START_CONTROL
		rTX_INITIAL <= 0;
		rTX_NORMAL <= 0;
		rTX_START_CONTROL <= 1;
		case(idata)
			8'b00110001:rTX_rate <= 8'b00110001; //1
			8'b00110101:rTX_rate <= 8'b00110101; //5
			8'b01000001:rTX_rate <= 8'b01000001; //A
		default: rTX_rate <= rTX_rate;
		endcase
	end
	else if(next_state == NORMAL)begin // NORMAL
		rTX_INITIAL <= 0;
		rTX_NORMAL <= 1;
		rTX_START_CONTROL <= 0;
		rTX_rate <= rTX_rate;
	end
	else begin 
		rTX_INITIAL <= 0;
		rTX_NORMAL <= 0;
		rTX_START_CONTROL <= 0;
		rTX_rate <= rTX_rate;
	end
end
endmodule
