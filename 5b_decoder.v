// ============================================================
// 4B5B Decoder Testbench
// 讀取 input.txt，將每行的 5B 碼解碼成 4B（十六進位），
// 結果寫入 output.txt
//
// 輸入格式：<0|1> <5b>_<5b>_<5b>...
//   0 = RX, 1 = TX
//
// 注意：5b 碼為 LSB first，解碼前先 bit-reverse
//   例如 10010 → 反轉 → 01001 → 查表 → 0x1
//
// 模擬工具：ModelSim / QuestaSim / Icarus Verilog (iverilog)
// ============================================================

`timescale 1ns/1ps

module decode_4b5b_tb;

    // --------------------------------------------------------
    // 檔案 handle
    // --------------------------------------------------------
    integer fin, fout;

    // --------------------------------------------------------
    // 暫存變數
    // --------------------------------------------------------
    reg [7:0]  line_buf [0:255];   // 每行最多256字元
    reg [4:0]  code5b;             // 目前讀到的5b碼
    reg [3:0]  nibble;             // 解碼後的4b
    integer    char_idx;           // 行內字元位置
    integer    nibble_count;       // 本行已解碼幾個nibble
    integer    c;                  // 目前讀到的字元
    reg        direction;          // 0=RX, 1=TX
    integer    line_num;
    integer    bit_cnt;            // 目前5b碼收集了幾個bit
    reg        valid;
    reg        is_control;

    // 用來組hex字串輸出（最多64個nibble/行）
    reg [3:0]  nibble_arr [0:63];

    // --------------------------------------------------------
    // 4B5B 解碼 function
    //   回傳 8'hFF 表示控制符號
    //   回傳 8'hFE 表示無效碼
    // --------------------------------------------------------
    function [7:0] decode5b;
        input [4:0] code;
        case (code)
            5'b11110: decode5b = 8'h00;
            5'b01001: decode5b = 8'h01;
            5'b10100: decode5b = 8'h02;
            5'b10101: decode5b = 8'h03;
            5'b01010: decode5b = 8'h04;
            5'b01011: decode5b = 8'h05;
            5'b01110: decode5b = 8'h06;
            5'b01111: decode5b = 8'h07;
            5'b10010: decode5b = 8'h08;
            5'b10011: decode5b = 8'h09;
            5'b10110: decode5b = 8'h0A;
            5'b10111: decode5b = 8'h0B;
            5'b11010: decode5b = 8'h0C;
            5'b11011: decode5b = 8'h0D;
            5'b11100: decode5b = 8'h0E;
            5'b11101: decode5b = 8'h0F;
            // 控制符號
            5'b11111: decode5b = 8'hFF; // IDLE
            5'b11000: decode5b = 8'hFF; // SSD J
            5'b10001: decode5b = 8'hFF; // SSD K
            5'b00111: decode5b = 8'hFF; // ESD T
            5'b00010: decode5b = 8'hFF; // ESD R
            5'b00100: decode5b = 8'hFF; // HALT
            5'b00001: decode5b = 8'hFF; // SSD S
            default:  decode5b = 8'hFE; // 無效
        endcase
    endfunction

    // --------------------------------------------------------
    // hex nibble 轉 ASCII 字元
    // --------------------------------------------------------
    function [7:0] nibble_to_ascii;
        input [3:0] n;
        if (n < 10)
            nibble_to_ascii = 8'h30 + n;       // '0'~'9'
        else
            nibble_to_ascii = 8'h41 + (n - 10); // 'A'~'F'
    endfunction

    // --------------------------------------------------------
    // 主流程
    // --------------------------------------------------------
    initial begin
        // 開啟檔案
        fin  = $fopen("input.txt",  "r");
        fout = $fopen("output.txt", "w");

        if (fin == 0) begin
            $display("ERROR: 無法開啟 input.txt");
            $finish;
        end
        if (fout == 0) begin
            $display("ERROR: 無法開啟 output.txt");
            $finish;
        end

        $fwrite(fout, "============================================================\n");
        $fwrite(fout, "4B5B 解碼結果\n");
        $fwrite(fout, "============================================================\n\n");

        line_num = 0;

        // ---- 逐行讀取 ----
        while (!$feof(fin)) begin

            // 清空行緩衝
            for (char_idx = 0; char_idx < 256; char_idx = char_idx + 1)
                line_buf[char_idx] = 0;
            char_idx = 0;

            // 讀一行直到換行或EOF
            c = $fgetc(fin);
            while ((c != "\n") && (c != -1)) begin
                line_buf[char_idx] = c[7:0];
                char_idx = char_idx + 1;
                c = $fgetc(fin);
            end

            // 跳過空行
            if (char_idx == 0) disable parse_line;

            line_num = line_num + 1;
            $fwrite(fout, "[第%0d行] ", line_num);

            // ---- 解析方向位元（第0個字元）----
            if (line_buf[0] == "1") begin
                direction = 1;
                $fwrite(fout, "TX\n");
            end else begin
                direction = 0;
                $fwrite(fout, "RX\n");
            end

            // ---- 印出原始5b串 ----
            $fwrite(fout, "  5B原始  : ");
            for (char_idx = 2; char_idx < 256; char_idx = char_idx + 1) begin
                if (line_buf[char_idx] != 0)
                    $fwrite(fout, "%c", line_buf[char_idx]);
            end
            $fwrite(fout, "\n");

            // ---- 解碼5b碼 ----
            nibble_count = 0;
            bit_cnt      = 0;
            code5b       = 0;

            for (char_idx = 2; char_idx < 256; char_idx = char_idx + 1) begin
                c = line_buf[char_idx];

                if (c == "0" || c == "1") begin
                    // 收集bit進5b碼（LSB first：第一個收到的bit放在最低位）
                    code5b = {(c == "1") ? 1'b1 : 1'b0, code5b[4:1]};
                    bit_cnt = bit_cnt + 1;

                    if (bit_cnt == 5) begin
                        // 解碼
                        begin : decode_block
                            reg [7:0] result;
                            result = decode5b(code5b);

                            if (result == 8'hFE) begin
                                // 無效碼，跳過
                                $display("警告 第%0d行：無效5b碼 %b", line_num, code5b);
                            end else if (result == 8'hFF) begin
                                // 控制符號，跳過不計入資料
                            end else begin
                                nibble_arr[nibble_count] = result[3:0];
                                nibble_count = nibble_count + 1;
                            end
                        end
                        bit_cnt = 0;
                        code5b  = 0;
                    end
                end
                // '_' 和其他分隔符直接忽略，繼續收集
            end

            // ---- 輸出 HEX（每兩個nibble加空格）----
            $fwrite(fout, "  HEX     : ");
            begin : print_hex
                integer i;
                for (i = 0; i < nibble_count; i = i + 1) begin
                    $fwrite(fout, "%c", nibble_to_ascii(nibble_arr[i]));
                    // 每兩個nibble後加空格（除了最後）
                    if ((i % 2 == 1) && (i != nibble_count - 1))
                        $fwrite(fout, " ");
                end
            end
            $fwrite(fout, "\n");

            // ---- 輸出 HEX（連續，加0x前綴）----
            $fwrite(fout, "  HEX(0x) : 0x");
            begin : print_hex_cont
                integer i;
                for (i = 0; i < nibble_count; i = i + 1)
                    $fwrite(fout, "%c", nibble_to_ascii(nibble_arr[i]));
            end
            $fwrite(fout, "\n\n");

            // parse_line disable 出口
            begin : parse_line
            end

        end // while

        $fwrite(fout, "============================================================\n");
        $fwrite(fout, "共處理 %0d 行\n", line_num);
        $fwrite(fout, "============================================================\n");

        $fclose(fin);
        $fclose(fout);

        $display("完成！結果寫入 output.txt，共 %0d 行", line_num);
        $finish;
    end

endmodule