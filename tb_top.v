`timescale 1ns/1ps

module tb_top;

  // 定義常數
  reg clk, rst_n, RXD;
  wire [7:0] data;


  // 實例化被測試的 top 模組
  top dut (
    .clk(clk),
    .rst_n(rst_n),
    .RXD(RXD),
    .data(data)
  );

  // 定義時鐘
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // 初始化測試環境
  initial begin
    // 初始化輸入信號
    rst_n = 0;
    RXD = 1; // 假設 RXD 初始為高電平

    // 啟動時鐘
    #10;

    // 施加重置信號
    rst_n = 1;
	 #10;
    // 模擬 RXD 輸入 0 並逐漸遞增到 15
      RXD = 0;
	 #10;
	 RXD = 1;
	 	 #10;
	 RXD = 1;

	 	 #10;
	 RXD = 0;

	 	 #10;
	 RXD = 0;

	 	 #10;
	 RXD = 1;

	 	 #10;
	 RXD = 0;

	 	 #10;
	 RXD = 1;

	 	 #10;
	 RXD = 1;
	 	 	 #10;
	 RXD = 0;




    // 等待一些時間以觀察結果
    #100;

    // 停止模擬
    $stop;
  end

endmodule
