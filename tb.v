`timescale 1ns / 1ps
//=============================================================================
// Testbench for usb_pd module
// - clk_apb  : 24 MHz
// - clk_bmca : external BMC clock (600 kHz, half-period = BMC bit period)
//   BMC encoding follows bmca_send_packet style:
//     Each bit period = 1 clk_bmca cycle
//     Every bit  : toggle cca_out at posedge clk_bmca (mandatory mid-point)
//     Bit '1'    : additional toggle at next posedge clk_bmca
//     Bit '0'    : no additional toggle
// - Input: "bmc_input.txt" - 190 chars of '0'/'1' (4b5b encoded bitstream)
//=============================================================================

module tb_usb_pd;

    //=========================================================================
    // Parameters
    //=========================================================================
    localparam real    CLK_APB_PERIOD_NS  = 41.667; // 24 MHz
    localparam real    CLK_BMCA_PERIOD_NS = 1666.667; // 600 kHz (300Kbps BMC)
    localparam integer PULSE_8U_CNT       = 192;    // 8 us  @ 24 MHz
    localparam integer PULSE_2M_CNT       = 49152;  // 2.048 ms @ 24 MHz
    localparam integer BITSTREAM_LEN      = 190;

    //=========================================================================
    // DUT Ports
    //=========================================================================
    reg         clk_apb;
    reg         rst_n;

    // APB
    wire [31:0] prdata_o;
    reg         psel_i;
    reg         penable_i;
    reg         pwrite_i;
    reg  [11:0] paddr_i;
    reg  [31:0] pwdata_i;

    // BMC
    wire        bmc_txen_o;
    wire        bmc_out_o;
    reg         bmc_in_i;           // driven by inject task via cca_out_o -> bmc_in_i

    // Interrupt & setting
    wire        usb_pd_int_o;
    wire        reg_usb_pd_en_o;

    // CC bus
    reg         cc_idle_cmp_i;

    // Timing signals
    reg         time_8u_p_i;
    reg         time_2m_p_i;

    // BMC TX DMA
    wire        bmc_tx_dma_req_o;
    reg         bmc_tx_dma_ack_i;
    reg  [31:0] bmc_tx_buf_i;

    // BMC RX DMA
    wire        bmc_rx_dma_req_o;
    wire [31:0] bmc_rx_buf_o;
    reg         bmc_rx_dma_ack_i;

    // DFT
    reg         scan_en_i;

`ifdef FPGA
    wire [7:0]  dbg_usb_pd;
    wire [7:0]  dbg_usb_pd_tx;
    wire [7:0]  dbg_usb_pd_rx;
`endif

    //=========================================================================
    // BMC clock  (600 kHz)
    //=========================================================================
    reg clk_bmca;
    initial clk_bmca = 0;
    always #(CLK_BMCA_PERIOD_NS / 2.0) clk_bmca = ~clk_bmca;

    //=========================================================================
    // DUT Instantiation
    //=========================================================================
    usb_pd u_usb_pd (
`ifdef FPGA
        .dbg_usb_pd         (dbg_usb_pd),
        .dbg_usb_pd_tx      (dbg_usb_pd_tx),
        .dbg_usb_pd_rx      (dbg_usb_pd_rx),
`endif
        .prdata_o           (prdata_o),
        .psel_i             (psel_i),
        .penable_i          (penable_i),
        .pwrite_i           (pwrite_i),
        .paddr_i            (paddr_i),
        .pwdata_i           (pwdata_i),
        .bmc_txen_o         (bmc_txen_o),
        .bmc_out_o          (bmc_out_o),
        .bmc_in_i           (bmc_in_i),
        .usb_pd_int_o       (usb_pd_int_o),
        .reg_usb_pd_en_o    (reg_usb_pd_en_o),
        .cc_idle_cmp_i      (cc_idle_cmp_i),
        .time_8u_p_i        (time_8u_p_i),
        .time_2m_p_i        (time_2m_p_i),
        .bmc_tx_dma_req_o   (bmc_tx_dma_req_o),
        .bmc_tx_dma_ack_i   (bmc_tx_dma_ack_i),
        .bmc_tx_buf_i       (bmc_tx_buf_i),
        .bmc_rx_dma_req_o   (bmc_rx_dma_req_o),
        .bmc_rx_buf_o       (bmc_rx_buf_o),
        .bmc_rx_dma_ack_i   (bmc_rx_dma_ack_i),
        .scan_en_i          (scan_en_i),
        .clk_apb            (clk_apb),
        .rst_n              (rst_n)
    );

    //=========================================================================
    // APB clock  24 MHz
    //=========================================================================
    initial clk_apb = 0;
    always #(CLK_APB_PERIOD_NS / 2.0) clk_apb = ~clk_apb;

    //=========================================================================
    // Timing Pulses
    //=========================================================================
    integer cnt_8u = 0;
    integer cnt_2m = 0;

    always @(posedge clk_apb or negedge rst_n) begin
        if (!rst_n) begin cnt_8u <= 0; time_8u_p_i <= 0; end
        else if (cnt_8u == PULSE_8U_CNT-1) begin cnt_8u <= 0; time_8u_p_i <= 1; end
        else begin cnt_8u <= cnt_8u+1; time_8u_p_i <= 0; end
    end

    always @(posedge clk_apb or negedge rst_n) begin
        if (!rst_n) begin cnt_2m <= 0; time_2m_p_i <= 0; end
        else if (cnt_2m == PULSE_2M_CNT-1) begin cnt_2m <= 0; time_2m_p_i <= 1; end
        else begin cnt_2m <= cnt_2m+1; time_2m_p_i <= 0; end
    end

    //=========================================================================
    // APB Tasks
    //=========================================================================
    task apb_write;
        input [11:0] addr;
        input [31:0] data;
        begin
            @(posedge clk_apb); #1;
            psel_i=1; pwrite_i=1; paddr_i=addr; pwdata_i=data; penable_i=0;
            @(posedge clk_apb); #1; penable_i=1;
            @(posedge clk_apb); #1; psel_i=0; penable_i=0; pwrite_i=0;
        end
    endtask

    task apb_read;
        input  [11:0] addr;
        output [31:0] rdata;
        begin
            @(posedge clk_apb); #1;
            psel_i=1; pwrite_i=0; paddr_i=addr; penable_i=0;
            @(posedge clk_apb); #1; penable_i=1;
            @(posedge clk_apb); rdata=prdata_o; #1;
            psel_i=0; penable_i=0;
        end
    endtask

    //=========================================================================
    // BMC Encoding  (mirrors bmca_send_packet logic from reference code)
    //
    // Reference logic (per bit, MSB-first from code[len-1] downto code[0]):
    //
    //   // mandatory toggle at posedge clk_bmca  (= half-bit transition)
    //   cca_out_o = ~cca_out_o;
    //   @(posedge clk_bmca) #0.1;
    //
    //   // if bit == '1': one more toggle  (= full-bit transition for '1')
    //   if (code[len-1-ia] == 1'b1)
    //     cca_out_o = ~cca_out_o;
    //   @(posedge clk_bmca) #0.1;
    //
    // Here we drive bmc_in_i instead of cca_out_o.
    // Bitstream is stored LSB-first in bitstream[0..len-1],
    // so we send bitstream[len-1] first (MSB of the original code).
    //=========================================================================

    reg bmc_inject_done;
    reg [0:BITSTREAM_LEN-1] bitstream;

    task inject_bmc_stream;
        integer fd, ret, bit_cnt, ia;
        begin
            // ---- load file ----
            fd = $fopen("bmc_input.txt", "r");
            if (fd == 0) begin
                $display("[ERROR] Cannot open bmc_input.txt");
                $finish;
            end
            bit_cnt = 0;
            while (!$feof(fd) && bit_cnt < BITSTREAM_LEN) begin
                ret = $fgetc(fd);
                if      (ret == "1") begin bitstream[bit_cnt] = 1'b1; bit_cnt = bit_cnt + 1; end
                else if (ret == "0") begin bitstream[bit_cnt] = 1'b0; bit_cnt = bit_cnt + 1; end
            end
            $fclose(fd);
            $display("[%0t] Loaded %0d bits from bmc_input.txt", $time, bit_cnt);
            if (bit_cnt != BITSTREAM_LEN)
                $display("[WARN] Expected %0d bits, got %0d", BITSTREAM_LEN, bit_cnt);

            // ---- pre-amble: idle low for 5 us then assert CC output enable ----
            bmc_in_i = 1'b0;
            #5000;
            // (cca_oen equivalent: nothing to drive here, just start sending)
            @(posedge clk_bmca); #0.1;

            $display("[%0t] BMC TX start -> %0d bits @ 300 Kbps", $time, bit_cnt);

            // ---- send bits MSB-first: bitstream[bit_cnt-1] .. bitstream[0] ----
            for (ia = 0; ia < bit_cnt; ia = ia + 1) begin

                // mandatory toggle at posedge clk_bmca
                bmc_in_i = ~bmc_in_i;
                @(posedge clk_bmca); #0.1;

                // extra toggle for bit '1'
                if (bitstream[bit_cnt - 1 - ia] == 1'b1) begin
                    bmc_in_i = ~bmc_in_i;
                end
                @(posedge clk_bmca); #0.1;
            end

            // ---- end-of-packet: drive low, disable output ----
            bmc_in_i = 1'b0;
            @(posedge clk_bmca);
            #1000;                  // 1 us hold (mirrors #1000 in reference)
            bmc_in_i = 1'b1;        // mirrors cca_out_o = 1'b1 after disable

`ifdef DEBUG_MSG
            @(negedge clk_bmca);
            $display("[%0t] BMC inject done, code = %b", $time, bitstream);
`endif
            $display("[%0t] BMC TX done", $time);
            bmc_inject_done = 1;
        end
    endtask

    //=========================================================================
    // RX DMA auto-ack (always block, stops when bmc_inject_done = 1)
    //=========================================================================
    always @(posedge clk_apb) begin
        if (!bmc_inject_done && bmc_rx_dma_req_o) begin
            @(posedge clk_apb); #1;
            bmc_rx_dma_ack_i = 1;
            @(posedge clk_apb); #1;
            bmc_rx_dma_ack_i = 0;
        end
    end

    //=========================================================================
    // TX DMA response task
    //=========================================================================
    task bmc_tx_dma_respond;
        input [31:0] tx_data;
        begin
            wait (bmc_tx_dma_req_o == 1);
            @(posedge clk_apb); #1;
            bmc_tx_buf_i     = tx_data;
            bmc_tx_dma_ack_i = 1;
            @(posedge clk_apb); #1;
            bmc_tx_dma_ack_i = 0;
        end
    endtask

    //=========================================================================
    // Main Stimulus
    //=========================================================================
    reg [31:0] rd_data;

    initial begin
        // Init
        rst_n=0; psel_i=0; penable_i=0; pwrite_i=0;
        paddr_i=0; pwdata_i=0; bmc_in_i=0; cc_idle_cmp_i=0;
        bmc_tx_dma_ack_i=0; bmc_tx_buf_i=0; bmc_rx_dma_ack_i=0;
        scan_en_i=0; bmc_inject_done=0;

        // Reset
        repeat(10) @(posedge clk_apb);
        rst_n = 1;
        repeat(5) @(posedge clk_apb);

        // Test 1: APB sanity
        $display("[%0t] === Test 1: APB Write/Read ===", $time);
        apb_write(12'h00, 32'hA5A5_5A5A);
        apb_read (12'h00, rd_data);
        $display("[%0t]   read back = 0x%08X", $time, rd_data);

        // Test 2: Enable USB PD
        $display("[%0t] === Test 2: Enable USB PD ===", $time);
        apb_write(12'h04, 32'h0000_0001); // bit[0] = usb_pd_en (adjust per reg map)
        repeat(10) @(posedge clk_apb);
        $display("[%0t]   reg_usb_pd_en_o = %b", $time, reg_usb_pd_en_o);

        // Test 3: BMC RX injection
        $display("[%0t] === Test 3: BMC RX - inject bmc_input.txt ===", $time);
        inject_bmc_stream;

        // Test 4: Interrupt
        $display("[%0t] === Test 4: Interrupt ===", $time);
        repeat(20) @(posedge clk_apb);
        $display("[%0t]   usb_pd_int_o = %b", $time, usb_pd_int_o);
        apb_write(12'h08, 32'hFFFF_FFFF); // clear interrupt (adjust addr per reg map)
        repeat(5) @(posedge clk_apb);
        $display("[%0t]   after clear  = %b", $time, usb_pd_int_o);

        $display("[%0t] === All Tests Done ===", $time);
        repeat(20) @(posedge clk_apb);
        $finish;
    end

    //=========================================================================
    // Waveform Dump
    //=========================================================================
    initial begin
        $dumpfile("tb_usb_pd.vcd");
        $dumpvars(0, tb_usb_pd);
    end

    //=========================================================================
    // Timeout Watchdog  (100 ms)
    //=========================================================================
    initial begin
        #100_000_000;
        $display("[%0t] TIMEOUT", $time);
        $finish;
    end

endmodule