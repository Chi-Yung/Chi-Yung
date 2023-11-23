module uart_rx (
  input wire clk,
  input wire rst_n,
  input wire RXD,
  output reg [7:0] data,
  output reg wr_en
);

  parameter t = 5208;
  
  reg [14:0] cnt;
  reg flag;
  reg rxd_r, rxd_rr;
  wire rx_en;
  reg [3:0] num;
  reg [7:0] data_r;

  always @(posedge clk) rxd_r <= RXD;
  always @(posedge clk) rxd_rr <= rxd_r;
  
  assign rx_en = (~rxd_r) & rxd_rr;

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
    else if (rx_en)
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

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
      data_r <= 8'd0;
      data <= 8'd0;
    end
    else if (cnt == t / 2 - 1)
      case (num)
        4'd0  :  ;
        4'd1  :  data_r[0] <= rxd_rr;
        4'd2  :  data_r[1] <= rxd_rr;
        4'd3  :  data_r[2] <= rxd_rr;
        4'd4  :  data_r[3] <= rxd_rr;
        4'd5  :  data_r[4] <= rxd_rr;
        4'd6  :  data_r[5] <= rxd_rr;
        4'd7  :  data_r[6] <= rxd_rr;
        4'd8  :  data_r[7] <= rxd_rr;
        4'd9  :  data <= data_r;
        default  :  data <= data;
      endcase
  end

  always @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      wr_en <= 1'b0;
    else if (num == 4'd10)
      wr_en <= 1'b1;
    else
      wr_en <= 1'b0;
  end

endmodule
