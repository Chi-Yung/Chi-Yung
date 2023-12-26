module MODE_CONTROL(clk,reset,idata,oSTART,orate_control,oData);
input clk,reset;
input [7:0] idata;
output [7:0] oData;
output reg oSTART;
output [1:0]orate_control;

parameter IDLE = 2'd0;
parameter START_CONTROL = 2'd1;
parameter NORMAL = 2'd2;

reg [2:0] current_state,next_state;
reg [1:0] rate_control;
reg [7:0] data_buffer;
reg [7:0] Data;
assign orate_control = rate_control;
assign oData = Data;
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
					else if(idata != 8'b01001101 && idata != 8'b01101101 && idata != 8'b00000000 && idata != 8'b01000110 && idata != 8'b01100110)begin
						next_state = NORMAL;
					end
					else begin
						next_state = IDLE;
					end
            end
            START_CONTROL : begin
					if(idata == 8'b01000110 || idata == 8'b01100110)next_state = IDLE;//f or F					
					else begin
					next_state = START_CONTROL;
					end
            end
				NORMAL:begin
					if(idata == 8'b01001101 || idata == 8'b01101101)next_state = START_CONTROL;//m or M
					else begin
					next_state = IDLE;
					end
				end
				default : next_state = IDLE;
        endcase
end
always@(*)begin
	if(!reset)begin
		data_buffer <= 8'b0;
	end
	else if(current_state == IDLE)begin
		if(idata == 8'b01001101 || idata == 8'b01101101 || idata == 8'b00000000 || idata == 8'b01000110 || idata == 8'b01100110)begin
			data_buffer <= data_buffer;
		end
		else data_buffer <= idata;
	end
	else if(current_state == NORMAL)begin
		if(idata == 8'b01001101 || idata == 8'b01101101)begin
			data_buffer = data_buffer;
		end
		else Data <= data_buffer;
	end
end
always@(*)begin
	if(!reset)begin
		oSTART <= 1'b0;
		rate_control <= 2'd0;
	end
	else if(next_state == START_CONTROL)begin
		oSTART <= 1'b0;
		case(idata)
			8'b00110001:rate_control <= 2'b00; //1
			8'b00110101:rate_control <= 2'b01; //5
			8'b01000001:rate_control <= 2'b10; //A
		default: rate_control <= 2'b11;
		endcase
	end
	else begin 
		rate_control <= rate_control;
		oSTART <= 1'b1;
	end
end
endmodule
