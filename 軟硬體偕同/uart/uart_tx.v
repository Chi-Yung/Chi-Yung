module uart_tx (
  input wire clk,
  input wire rst_n,
  input wire empty,
  input wire [7:0] data,
  output wire rd_en,
  output reg TXD
);

  parameter t = 5208;

  reg [14:0] cnt;
  reg flag;
  reg [3:0] num;

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      cnt <= 15'd0;
    else if (flag)
    begin
      if (cnt == t - 1)
        cnt <= 15'd0;
      else
        cnt <= cnt + 1'b1;
    end
    else
      cnt <= 15'd0;
  end

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      flag <= 1'b0;
    else if (empty == 1'b0)
      flag <= 1'b1;
    else if (num == 4'd10)
      flag <= 1'b0;
    else
      flag <= flag;
  end

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      num <= 4'd0;
    else if (cnt == t / 2 - 1)
      num <= num + 1'b1;
    else if (num == 4'd10)
      num <= 4'd0;
    else
      num <= num;
  end

  assign rd_en = (num == 4'd0 && cnt == 15'd1) ? 1'b1 : 1'b0;

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      TXD <= 1'b1;
    else if (cnt == t / 2 - 1)
      case (num)
        4'd0  :  TXD <= 1'b0;
        4'd1  :  TXD <= data[0];
        4'd2  :  TXD <= data[1];
        4'd3  :  TXD <= data[2];
        4'd4  :  TXD <= data[3];
        4'd5  :  TXD <= data[4];
        4'd6  :  TXD <= data[5];
        4'd7  :  TXD <= data[6];
        4'd8  :  TXD <= data[7];
        4'd9  :  TXD <= 1'b1;
        default  :  TXD <= 1'b1;
      endcase
  end

endmodule
