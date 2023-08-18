module STI_DAC(clk ,reset, load, pi_data, pi_length, pi_fill, pi_msb, pi_low, pi_end,
	       so_data, so_valid,
	       oem_finish, oem_dataout, oem_addr,
	       odd1_wr, odd2_wr, odd3_wr, odd4_wr, even1_wr, even2_wr, even3_wr, even4_wr);

input		clk, reset;
input		load, pi_msb, pi_low, pi_end; 
input	[15:0]	pi_data;
input	[1:0]	pi_length;
input		pi_fill;
output		so_data, so_valid;

output  oem_finish, odd1_wr, odd2_wr, odd3_wr, odd4_wr, even1_wr, even2_wr, even3_wr, even4_wr;
output [4:0] oem_addr;
output [7:0] oem_dataout;

//==============================================================================
reg so_data, so_valid;
reg oem_finish, odd1_wr, odd2_wr, odd3_wr, odd4_wr, even1_wr, even2_wr, even3_wr, even4_wr;
reg [4:0] oem_addr;
wire [7:0] oem_dataout;

reg [2:0] current_state,next_state;
parameter IDLE = 3'd0;
parameter LOAD = 3'd1;
parameter SERIAL_OUT = 3'd2;
parameter FINISH = 3'd3;

reg [31:0] data_buffer;
reg [4:0] serial_counter,pi_length_bit;
//state switch
always@(posedge clk or posedge reset)
begin
	if(reset) current_state <= IDLE;
	else current_state <= next_state;
end

//next state logic
always@(*)
begin
	case(current_state)
	IDLE:
	begin
		if(load) next_state = LOAD;
		else next_state = IDLE;
	end
	LOAD:
	begin
		next_state = SERIAL_OUT;
	end
	SERIAL_OUT:
	begin
		if(serial_counter == 4'd0 && pi_end == 1'd1) next_state = FINISH;
		else if(serial_counter == 4'd0) next_state = IDLE;
		else next_state = SERIAL_OUT;
	end
	FINISH:
	begin
		next_state = FINISH;
	end
	default: next_state = IDLE;
	endcase
end

//pi_length_bit
always@(*)
begin
	case(pi_length)
	2'b00: pi_length_bit = 5'd7;
	2'b01: pi_length_bit = 5'd15; 
	2'b10: pi_length_bit = 5'd23;
	2'b11: pi_length_bit = 5'd31;
	default: pi_length_bit = 5'd0;
	endcase
end

//data_buffer 31 is MSB , 0 is LSB
always@(*)
begin
	case(pi_length)
	2'b00: //8bit
	begin
		if(pi_low) 
		begin
			data_buffer[31:24] = pi_data[15:8];
			data_buffer[23:0] = 24'd0; //prevent latch
		end
		else
		begin
			data_buffer[31:24] = pi_data[7:0];
			data_buffer[23:0] = 24'd0; //prevent latch
		end
	end
	2'b01: //16bit
	begin
		data_buffer[31:16] = pi_data[15:0];
		data_buffer[15:0] = 16'd0; //prevent latch
	end
	2'b10: //24bit
	begin
		if(pi_fill)
		begin
			data_buffer[31:16] = pi_data[15:0];
			data_buffer[15:0] = 16'd0;
		end
		else 
		begin
			data_buffer[31:24] = 8'd0;
			data_buffer[23:8] = pi_data[15:0];
			data_buffer[7:0] = 8'd0; //prevent latch
		end
	end
	2'b11: //32bit
	begin
		if(pi_fill)
		begin
			data_buffer[31:16] = pi_data[15:0];
			data_buffer[15:0] = 16'd0;
		end
		else
		begin
			data_buffer[31:16] = 16'd0;
			data_buffer[15:0] = pi_data[15:0];
		end
	end
	default: data_buffer = 32'd0;
	endcase
end

//serial_counter
always@(posedge clk or posedge reset)
begin
	if(reset) serial_counter <= 5'd31;
	else if(next_state == LOAD)
	begin
		case(pi_length)
		2'b00: serial_counter <= 5'd7;
		2'b01: serial_counter <= 5'd15; 
		2'b10: serial_counter <= 5'd23;
		2'b11: serial_counter <= 5'd31;
		endcase
	end
	else if(current_state == SERIAL_OUT) serial_counter <= serial_counter - 4'd1;
end

//so_valid
always@(posedge clk or posedge reset)
begin
	if(reset) so_valid <= 1'd0;
	else if(next_state == SERIAL_OUT) so_valid <= 1'd1;
	else so_valid <= 1'd0;
end

//data_buffer_index
reg [4:0] data_buffer_index;
always@(posedge clk or posedge reset)
begin
	if(reset) data_buffer_index <= 5'd0;
	else if(next_state == LOAD)
	begin
		if(pi_msb) data_buffer_index <= 5'd31;
		else
		begin
			case(pi_length)
			2'b00: data_buffer_index <= 5'd24;
			2'b01: data_buffer_index <= 5'd16; 
			2'b10: data_buffer_index <= 5'd8;
			2'b11: data_buffer_index <= 5'd0;
			endcase
		end
	end
	else if(next_state == SERIAL_OUT)
	begin
		if(pi_msb) data_buffer_index <= data_buffer_index - 5'd1;
		else data_buffer_index <= data_buffer_index + 5'd1;
	end
	
	
end

//so_data
always@(posedge clk or posedge reset)
begin
	if(reset) so_data <= 1'd0;
	else so_data <= data_buffer[data_buffer_index];
end

//////////DAC////////
reg [7:0] DAC_buffer;  
reg [3:0] counter_16bit;
reg [3:0] counter_16bit_delay_1clk;
reg [7:0] mem_counter;
reg odd_even;

//odd_even
always@(posedge clk or posedge reset)
begin
	if(reset) odd_even <= 1'd0;
	else if(mem_counter[3:0] == 4'd8) odd_even <= 1'd1;//odd
	else if(mem_counter[3:0] == 4'd0) odd_even <= 1'd0;//even

end


always@(posedge clk or posedge reset)
begin
	if(reset) DAC_buffer <= 8'd0;
	else if(so_valid)
	begin
		DAC_buffer <= DAC_buffer << 8'd1;
		DAC_buffer[0] <= so_data; 
	end
	else if(pi_end)
	begin
		DAC_buffer <= 8'd0;
	end
end

//cout 16bit
always@(posedge clk or posedge reset)
begin
	if(reset) counter_16bit <= 4'd0;
	else if(so_valid) counter_16bit <= counter_16bit + 4'd1;
	else if(pi_end && current_state == FINISH) counter_16bit <= counter_16bit + 4'd1;
end

//mem_counter
always@(posedge clk or posedge reset)
begin
	if(reset) mem_counter <= 8'd0;
	else if(counter_16bit == 4'd7 || counter_16bit == 4'd15) mem_counter <= mem_counter + 8'd1;
end

reg [4:0] delay_buffer;
//oem_addr
always@(posedge clk or posedge reset)
begin
	if(reset) delay_buffer <= 5'd0;
	else if(counter_16bit == 4'd15) delay_buffer <= delay_buffer + 5'd1;
end

always@(posedge clk or posedge reset)
begin
	if(reset) oem_addr <= 5'd0;
	else oem_addr <= delay_buffer;
end

//oem_dataout
assign oem_dataout = DAC_buffer;

//ome_finish
always@(posedge clk or posedge reset)
begin
	if(reset) oem_finish <= 1'd0;
	else if(mem_counter == 8'd0 && counter_16bit == 4'd0 && pi_end == 1'd1) oem_finish <= 1'd1;
end

//wr
///////////////////////11111111111111111///////////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset) odd1_wr <= 1'd0;
	else if(mem_counter <= 8'd63 && counter_16bit == 4'd7 && odd_even == 1'd0) odd1_wr <= 1'd1;
	else if(mem_counter <= 8'd63 && counter_16bit == 4'd15 && odd_even == 1'd1) odd1_wr <= 1'd1;
	else odd1_wr <= 1'd0;
end

always@(posedge clk or posedge reset)
begin
	if(reset) even1_wr <= 1'd0;
	else if(mem_counter <= 8'd63 && counter_16bit == 4'd15 && odd_even == 1'd0) even1_wr <= 1'd1;
	else if(mem_counter <= 8'd63 && counter_16bit == 4'd7 && odd_even == 1'd1) even1_wr <= 1'd1;
	else even1_wr <= 1'd0;
end
///////////////////////22222222222222222///////////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset) odd2_wr <= 1'd0;
	else if(mem_counter > 8'd63 && mem_counter<=8'd127 && counter_16bit == 4'd7 && odd_even == 1'd0)
	begin
		odd2_wr <= 1'd1;
	end
	else if(mem_counter > 8'd63 && mem_counter<=8'd127 && counter_16bit == 4'd15 && odd_even == 1'd1)
	begin
		odd2_wr <= 1'd1;
	end
	else odd2_wr <= 1'd0;
end

always@(posedge clk or posedge reset)
begin
	if(reset) even2_wr <= 1'd0;
	else if(mem_counter > 8'd63 && mem_counter<=8'd127 && counter_16bit == 4'd15 && odd_even == 1'd0)
	begin
		even2_wr <= 1'd1;
	end
	else if(mem_counter > 8'd63 && mem_counter<=8'd127 && counter_16bit == 4'd7 && odd_even == 1'd1)
	begin
		even2_wr <= 1'd1;
	end
	else even2_wr <= 1'd0;
end
///////////////////////33333333333333333///////////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset) odd3_wr <= 1'd0;
	else if(mem_counter > 8'd127 && mem_counter<=8'd191 && counter_16bit == 4'd7 && odd_even == 1'd0)
	begin
		odd3_wr <= 1'd1;
	end
	else if(mem_counter > 8'd127 && mem_counter<=8'd191 && counter_16bit == 4'd15 && odd_even == 1'd1)
	begin
		odd3_wr <= 1'd1;
	end
	else odd3_wr <= 1'd0;
end

always@(posedge clk or posedge reset)
begin
	if(reset) even3_wr <= 1'd0;
	else if(mem_counter > 8'd127 && mem_counter<=8'd191 && counter_16bit == 4'd15 && odd_even == 1'd0)
	begin
		even3_wr <= 1'd1;
	end
	else if(mem_counter > 8'd127 && mem_counter<=8'd191 && counter_16bit == 4'd7 && odd_even == 1'd1)
	begin
		even3_wr <= 1'd1;
	end
	else even3_wr <= 1'd0;
end
///////////////////////44444444444444444///////////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset) odd4_wr <= 1'd0;
	else if(mem_counter > 8'd191 && mem_counter<=8'd255 && counter_16bit == 4'd7 && odd_even == 1'd0)
	begin
		odd4_wr <= 1'd1;
	end
	else if(mem_counter > 8'd191 && mem_counter<=8'd255 && counter_16bit == 4'd15 && odd_even == 1'd1)
	begin
		odd4_wr <= 1'd1;
	end
	else odd4_wr <= 1'd0;
end

always@(posedge clk or posedge reset)
begin
	if(reset) even4_wr <= 1'd0;
	else if(mem_counter > 8'd191 && mem_counter<=8'd255 && counter_16bit == 4'd15 && odd_even == 1'd0)
	begin
		even4_wr <= 1'd1;
	end
	else if(mem_counter > 8'd191 && mem_counter<=8'd255 && counter_16bit == 4'd7 && odd_even == 1'd1 )
	begin
		even4_wr <= 1'd1;
	end
	else even4_wr <= 1'd0;
end

endmodule