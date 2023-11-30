module top (
  input wire clk,
  input wire rst_n,
  input wire RXD,
  output  [7:0] data
);

wire [7:0]data_out;
wire wr_en;
 uart_rx_t uart_inst (
    .clk(clk),
    .rst_n(rst_n),
    .RXD(RXD),
    .data_out(data_out),
    .wr_en(wr_en)
  );


 fifo fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_out),
    .wr_en(wr_en),
    .data(data)
  );

endmodule
