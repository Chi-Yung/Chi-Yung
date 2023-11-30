module fifo (
  input wire clk,
  input wire rst_n,
  input wire [7:0] data_in,
  input wire wr_en,
  output reg [7:0] data
);

  reg [7:0] fifo; // 8個8位元組的 FIFO
  reg [2:0] write_ptr; // FIFO 寫入指標
  reg [2:0] read_ptr;  // FIFO 讀取指標

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
      // 在重置時初始化 FIFO
      write_ptr <= 3'b0;
      read_ptr <= 3'b0;
      data <= 8'd0;
    end
    else
    begin
      // 在接收到完整的位元組時將資料存儲到 FIFO
      if (wr_en == 1'b1)
      begin
        fifo[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
        if (write_ptr == 3'b111)
          write_ptr <= 3'b0;
      end

      data <= fifo[read_ptr];

      if (wr_en == 1'b1)
        read_ptr <= read_ptr + 1;
    end
  end

endmodule
