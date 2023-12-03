`timescale 1ns / 1ps
module uart_rx(
    input clk,
    input rst_n,
    input rx,
    output reg [7:0] data_out
    );
 
 
    // State Machine Defination
    parameter IDLE = 2'b01;
    parameter SAMP = 2'b10;
    reg [3:0] data_in;
    // UART Configure Defination
	 parameter BAUD_MAX   = 50;////////////////////////////////////////////////////////////////////////////////
		reg [5:0] baud_cnt;
		parameter START_BIT = 1;
		parameter DATA_BIT  = 8;
		parameter STOP_BIT  = 1;
		parameter PARI_BIT  = 0;
		parameter RECV_BIT  = START_BIT + DATA_BIT + STOP_BIT + PARI_BIT;
		parameter BAUD_CNT_H = (BAUD_MAX / 2);////////////////////////////////////////////////////////////////////////////////
		wire baud_clk = (baud_cnt == BAUD_CNT_H) ? (1'b1) : (1'b0);////////////////////////////////////////////////////////////////////////////////
		wire rx_neg = data_in[3] & data_in[2] & (~data_in[1]) & (~data_in[0]);
		reg sample_finish;
		reg [1:0] current_state, next_state;
// Negedge Detection Filter
always @ (posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        data_in[0] <= 1'b0;
        data_in[1] <= 1'b0;
        data_in[2] <= 1'b0;
        data_in[3] <= 1'b0;
    end
    else begin
        data_in[0] <= rx;
        data_in[1] <= data_in[0];
        data_in[2] <= data_in[1];
        data_in[3] <= data_in[2];
    end
 end
    // Current State To Next State
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end 
    // State
always @ (current_state or sample_finish or rx_neg)begin
        next_state = 2'bx;
        case(current_state)
            IDLE : begin
						if (rx_neg) next_state = SAMP;
						else        next_state = IDLE;
            end
            SAMP : begin
						if (sample_finish) next_state = IDLE;
						else               next_state = SAMP;
            end
						default : next_state = IDLE;
        endcase
end

reg [3:0] recv_cnt;
reg sample_en;
reg [RECV_BIT - 1 : 0] data_temp;
always @ (posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        data_out  <= 8'bx;
        data_temp <= 10'bx;
        sample_finish <= 1'b0;
        sample_en <= 1'b0;
        recv_cnt <= 4'b0;
    end
    else begin
        case (next_state)
            IDLE : begin
                //data_out  <= 10'bx;
                data_temp <= 10'bx;
                sample_finish <= 1'b0;
                sample_en <= 1'b0;
                recv_cnt <= 4'b0;
            end
            SAMP : begin
						if (recv_cnt == RECV_BIT) begin
                    data_out  <= data_temp[8:1];
                    data_temp <= 10'bx;
                    sample_finish <= 1'b1;
                    sample_en <= 1'b0;
                    recv_cnt  <= 4'b0;
						end
						else begin
                    sample_en <= 1'b1;
                    if (baud_clk) begin
                        data_out <= data_out;
                        data_temp[recv_cnt] <= rx;
                        sample_finish <= 1'b0;
                        recv_cnt <= recv_cnt + 1'b1;
                    end
                    else begin
                        data_out <= data_out;
                        data_temp <= data_temp;
                        sample_finish <= sample_finish;
                        recv_cnt <= recv_cnt;
                    end
                end
            end
            default: begin
                data_out <= 10'bx;
                sample_finish <= 1'b0;
                sample_en <= 1'b0;
            end
        endcase
    end
 end      
// Sample Counter Signal Generator

always @ (posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        baud_cnt <= 6'd0;
    end
    else begin
        if (sample_en) begin
            if (baud_cnt == BAUD_MAX - 1) baud_cnt <= 6'd0;
            else baud_cnt <= baud_cnt + 1'b1;
        end
        else baud_cnt <= 6'd0;
    end
end
// Sample Clock Signal Generator

endmodule