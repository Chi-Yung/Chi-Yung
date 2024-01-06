module UART_TX(
clk,
reset,
iTX_BAUD_clk,
iTX_FIFO_DATA,
iFINISH,
oTX_DATA
);
input clk;
input reset;
input iTX_BAUD_clk;
input [7:0] iTX_FIFO_DATA;
input iFINISH;
output oTX_DATA;

reg[3:0] rSTATE;
reg rTX_DATA;

assign oTX_DATA = rTX_DATA;

always@(posedge iFINISH or posedge iTX_BAUD_clk or negedge reset)begin
	if(!reset)begin
		rSTATE <= 4'd0;
		rTX_DATA <= 1'd1;
	end 
	else if(iFINISH)begin
		rSTATE <= 4'd0;
		rTX_DATA <= 1'd1;
	end
	else if(iTX_BAUD_clk)begin
		case(rSTATE)
			4'd0:
			begin
				rTX_DATA <= 1'd0;
				rSTATE <= rSTATE + 1'd1;
			end
			4'd1:
			begin
				rTX_DATA <= iTX_FIFO_DATA[0];       
				rSTATE <= rSTATE + 1'd1;
         end 
			4'd2:
			begin
				rTX_DATA <= iTX_FIFO_DATA[1];
				rSTATE <= rSTATE + 1'd1;
			end
			4'd3:
			begin
				rTX_DATA <= iTX_FIFO_DATA[2];
				rSTATE <= rSTATE + 1'd1;
			end
			4'd4:
			begin
				rTX_DATA <= iTX_FIFO_DATA[3];
				rSTATE <= rSTATE + 1'd1;
			end 
			4'd5:
			begin
				rTX_DATA <= iTX_FIFO_DATA[4];
				rSTATE <= rSTATE + 1'd1;
			end
			4'd6:
			begin
				rTX_DATA <= iTX_FIFO_DATA[5];
				rSTATE <= rSTATE + 1'd1;
			end
			4'd7:
			begin
				rTX_DATA <= iTX_FIFO_DATA[6];
				rSTATE <= rSTATE + 1'd1;
			end
			4'd8:
			begin
				rTX_DATA <= iTX_FIFO_DATA[7];
				rSTATE <= rSTATE + 1'd1;
			end 
			4'd9:
			begin
				rTX_DATA <= 1'd1;
				rSTATE <= 4'd0;
			end
			default :begin 
				rSTATE <= 4'd0;
				rTX_DATA <= 1'd1;
			end
			endcase 
	end else begin
		rTX_DATA <= 1'd1;
		rSTATE <= 4'd0;
	end
end
endmodule