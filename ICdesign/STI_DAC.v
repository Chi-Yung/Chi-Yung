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
//STI
//state logic
reg [2:0]current_state;
reg [2:0]next_state;
reg so_valid;
reg [31:0]data_buffer;
reg [4:0]serial_counter;
reg [4:0]index;
reg so_data;
parameter IDLE = 3'd0;
parameter LOAD = 3'd1;
parameter start= 3'd2;
parameter finish= 3'd3;
always@(posedge clk or posedge reset) begin
	if(reset)begin
		current_state <= IDLE;
	end
	else current_state <= next_state;
end
always@(*) begin 
	case(current_state)
	IDLE:                       
		begin
		next_state = LOAD;
		end
	LOAD:                       //load
		begin
		if(load)next_state = LOAD;
		else next_state = start;	
		end
	start:                      //serial start transmission
		begin
		if(serial_counter == 5'd0&&pi_end==1'd1)next_state <= finish;	//serial transmission finish
		else if(serial_counter == 5'd0)begin  //testbench 
			next_state = IDLE;
		end
		else begin
			next_state = start;  //serial transmission 
		end				
		end
	finish:
		begin
		next_state = finish;
		end
	default: next_state = IDLE;
	endcase		
end

//data transform
always@(*)
begin
	case(pi_length)  //input pi_length  00:pi_low ,10 11:pi_fill
	2'b00:
	begin
		if(pi_low) 
		begin
			data_buffer[31:24] = pi_data[15:8];
			data_buffer[23:0] = 24'd0;
		end
		else
		begin
			data_buffer[31:24] = pi_data[7:0];
			data_buffer[23:0] = 24'd0;
		end
	end
	2'b01: //16bit
	begin
		data_buffer[31:16] = pi_data[15:0];
		data_buffer[15:0] = 16'd0;
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
			data_buffer[7:0] = 8'd0;
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
//data_buffer_index for so_data and pi_msb
//////////////************************************//////////////////////
always@(posedge clk or posedge reset) begin
	if(reset) index <= 5'd0;
	else if(next_state==LOAD)begin
		if(pi_msb)index <= 5'd31;				
		else begin	
			case(pi_length)
				2'b00: index <= 5'd24;
				2'b01: index <= 5'd16; 
				2'b10: index <= 5'd8;
				2'b11: index <= 5'd0;
			endcase 
		end
	end
	else if(next_state == start)begin
		if(pi_msb)index <= index-5'd1;
		else index <= index+5'd1;
	end
	else index <= index;
end

//////////////************************************//////////////////////
//so_valid
always@(posedge clk or posedge reset) begin
	if(reset) so_valid <= 1'd0;
	else if(next_state == start) so_valid <= 1'd1;
	else so_valid <= 1'd0;
end
//so_data
always@(posedge clk or posedge reset) begin
	if(reset) so_data <= 1'd0;
	else so_data <= data_buffer[index];
end
//serial_counter 
always@(posedge clk or posedge reset) begin
	if(reset) serial_counter <= 5'd31;
	else if(next_state == LOAD) begin
		case(pi_length)
			2'b00: serial_counter <= 5'd7;
			2'b01: serial_counter <= 5'd15; 
			2'b10: serial_counter <= 5'd23;
			2'b11: serial_counter <= 5'd31;
		endcase
	end
	else if(current_state == start)serial_counter <= serial_counter - 5'd1;
	else if(current_state == finish)serial_counter <= 5'd0;
	else serial_counter <= serial_counter;
end
//
///
////
/////
//////
///////////////////////////////////////////////////DAC/////////////////////////////////////
reg [7:0] DAC_buffer;
reg[4:0] oem_addr;
reg[4:0] delay_counter;
reg [3:0] mem_counter;
reg [7:0] mem_address_counter;
reg  odd_EN;
reg  even_EN;
reg [3:0] mem_address_counter_16bits;
reg oem_finish, odd1_wr, odd2_wr, odd3_wr, odd4_wr, even1_wr, even2_wr, even3_wr, even4_wr;
//DAC_buffer
always@(posedge clk or posedge reset) begin
	if(reset) DAC_buffer <= 8'd0;
	else if(so_valid)begin
		DAC_buffer <= DAC_buffer << 8'd1;
		DAC_buffer[0] <= so_data; 
	end
	else if(pi_end)DAC_buffer <= 8'd0;
	else DAC_buffer <= DAC_buffer;
end
//oem_dataout
assign oem_dataout = DAC_buffer;

//oem_addr
always@(posedge clk or posedge reset) begin
	if(reset) delay_counter <= 5'd0;
	else if(mem_counter == 4'd15)delay_counter <= delay_counter + 5'd1;
	else delay_counter <= delay_counter;
end
always@(posedge clk or posedge reset) begin
	if(reset) oem_addr <= 5'd0;
	else oem_addr <= delay_counter;
end

//mem_counter
always@(posedge clk or posedge reset) begin
	if(reset) mem_counter <= 4'd0;
	else if(so_valid) begin
		mem_counter <= mem_counter + 4'd1;
	end
	else if(pi_end == 1'd1 && current_state == finish) mem_counter <= mem_counter + 4'd1;
	else mem_counter <= mem_counter;
end
//mem address counter
always@(posedge clk or posedge reset) begin
	if(reset) mem_address_counter <= 8'd0;
	else if(mem_counter == 4'd7 || mem_counter == 4'd15) begin
		mem_address_counter <= mem_address_counter + 8'd1;
	end
	else mem_address_counter <= mem_address_counter;
end
//mem address counter 16bits
always@(posedge clk or posedge reset) begin
	if(reset) mem_address_counter_16bits <= 4'd0;
	else if(mem_counter == 4'd7 || mem_counter == 4'd15) begin
		mem_address_counter_16bits <= mem_address_counter_16bits + 4'd1;
	end
	else mem_address_counter_16bits <= mem_address_counter_16bits;
end
//odd_even_enable
/*always@(posedge clk or posedge reset) begin
	if(reset) begin 
		odd_EN <= 1'd0;
		even_EN <=1'd0;
	end
	else if(mem_counter == 7)begin
		even_EN <= 1'd1;
	end
	else if(mem_counter == 15)begin
		odd_EN <= 1'd1;
	end
	else begin
		odd_EN <= 1'd0;
		even_EN <=1'd0;
	end
end*/
//odd1 and even1 wr
always@(posedge clk or posedge reset) begin
	if(reset)  begin 
		odd1_wr <= 1'd0;
		even1_wr <= 1'd0;
	end
	else if(mem_address_counter <= 8'd63 && mem_address_counter_16bits <= 4'd7)begin 
		if(mem_counter == 7)odd1_wr <= 1'd1;
		else if(mem_counter == 15)even1_wr <= 1'd1;
		else begin
		odd1_wr <= 1'd0;
		even1_wr <= 1'd0;	
		end
	end
	else if(mem_address_counter <= 8'd63 && mem_address_counter_16bits > 4'd7 && mem_address_counter_16bits <= 4'd15)begin
		if(mem_counter == 15)odd1_wr <= 1'd1;
		else if(mem_counter == 7)even1_wr <= 1'd1;
		else begin
		odd1_wr <= 1'd0;
		even1_wr <= 1'd0;	
		end
	end	
	else begin
		odd1_wr <= 1'd0;
		even1_wr <= 1'd0;	
	end
end
//odd2 and even2 wr
always@(posedge clk or posedge reset) begin
	if(reset)  begin 
		odd2_wr <= 1'd0;
		even2_wr <= 1'd0;
	end
	else if(mem_address_counter > 8'd63 && mem_address_counter <= 8'd127 && mem_address_counter_16bits <= 4'd7)begin 
		if(mem_counter == 7)odd2_wr <= 1'd1;
		else if(mem_counter == 15)even2_wr <= 1'd1;
		else begin
		odd2_wr <= 1'd0;
		even2_wr <= 1'd0;	
		end
	end
	else if(mem_address_counter > 8'd63 && mem_address_counter <= 8'd127 && mem_address_counter_16bits > 4'd7 && mem_address_counter_16bits <= 4'd15)begin
		if(mem_counter == 15)odd2_wr <= 1'd1;
		else if(mem_counter == 7)even2_wr <= 1'd1;
		else begin
		odd2_wr <= 1'd0;
		even2_wr <= 1'd0;	
		end
	end	
	else begin
		odd2_wr <= 1'd0;
		even2_wr <= 1'd0;	
	end
end
//odd3 and even3 wr
always@(posedge clk or posedge reset) begin
	if(reset)  begin 
		odd3_wr <= 1'd0;
		even3_wr <= 1'd0;
	end
	else if(mem_address_counter > 8'd127 && mem_address_counter <= 8'd191 && mem_address_counter_16bits <= 4'd7)begin 
		if(mem_counter == 7)odd3_wr <= 1'd1;
		else if(mem_counter == 15)even3_wr <= 1'd1;
		else begin
		odd3_wr <= 1'd0;
		even3_wr <= 1'd0;	
		end
	end
	else if(mem_address_counter > 8'd127 && mem_address_counter <= 8'd191 && mem_address_counter_16bits > 4'd7 && mem_address_counter_16bits <= 4'd15)begin
		if(mem_counter == 15)odd3_wr <= 1'd1;
		else if(mem_counter == 7)even3_wr <= 1'd1;
		else begin
		odd3_wr <= 1'd0;
		even3_wr <= 1'd0;	
		end
	end	
	else begin
		odd3_wr <= 1'd0;
		even3_wr <= 1'd0;	
	end
end
//odd4 and even4 wr
always@(posedge clk or posedge reset) begin
	if(reset)  begin 
		odd4_wr <= 1'd0;
		even4_wr <= 1'd0;
	end
	else if(mem_address_counter > 8'd191 && mem_address_counter <= 8'd255 && mem_address_counter_16bits <= 4'd7)begin 
		if(mem_counter == 7)odd4_wr <= 1'd1;
		else if(mem_counter == 15)even4_wr <= 1'd1;
		else begin
		odd4_wr <= 1'd0;
		even4_wr <= 1'd0;	
		end
	end
	else if(mem_address_counter > 8'd191 && mem_address_counter <= 8'd255 && mem_address_counter_16bits > 4'd7 && mem_address_counter_16bits <= 4'd15)begin
		if(mem_counter == 15)odd4_wr <= 1'd1;
		else if(mem_counter == 7)even4_wr <= 1'd1;
		else begin
		odd4_wr <= 1'd0;
		even4_wr <= 1'd0;	
		end
	end	
	else begin
		odd4_wr <= 1'd0;
		even4_wr <= 1'd0;	
	end
end

//oem_finish
always@(posedge clk or posedge reset) begin
	if(reset) oem_finish <= 1'd0;
	else if(pi_end == 1'd1 && mem_address_counter == 8'd0)oem_finish <= 1'd1;
	else oem_finish <= oem_finish;
end
endmodule