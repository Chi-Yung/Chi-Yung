`timescale 1ns / 1ps
//=============================================================================
// Testbench for usb_pd module
// Auto-generated from usb_pd module interface
//=============================================================================

module tb_usb_pd;

    //-------------------------------------------------------------------------
    // Clock & Reset
    //-------------------------------------------------------------------------
    reg         clk_apb;
    reg         rst_n;

    //-------------------------------------------------------------------------
    // APB Interface
    //-------------------------------------------------------------------------
    wire [31:0] prdata_o;           // APB read data
    reg         psel_i;             // APB select, active high
    reg         penable_i;          // APB enable, active high
    reg         pwrite_i;           // APB transfer direction, '0'=read, '1'=write
    reg  [11:0] paddr_i;            // APB address
    reg  [31:0] pwdata_i;           // APB write data

    //-------------------------------------------------------------------------
    // BMC Signals
    //-------------------------------------------------------------------------
    wire        bmc_txen_o;         // usb_pd bmc_tx enable
    wire        bmc_out_o;          // usb_pd BMC output
    reg         bmc_in_i;           // usb_pd BMC input

    //-------------------------------------------------------------------------
    // Interrupt & Setting
    //-------------------------------------------------------------------------
    wire        usb_pd_int_o;       // usb_pd interrupt
    wire        reg_usb_pd_en_o;    // usb_pd enable

    //-------------------------------------------------------------------------
    // CC Bus
    //-------------------------------------------------------------------------
    reg         cc_idle_cmp_i;      // CC status from idle comparator
                                    // for transmitting auto-GoodCRC, without de-bounce

    //-------------------------------------------------------------------------
    // Timing Signals @ clk_apb domain
    //-------------------------------------------------------------------------
    reg         time_8u_p_i;        // 1T pulse @ clk_apb per 8us
    reg         time_2m_p_i;        // 1T pulse @ clk_apb per 2.048ms

    //-------------------------------------------------------------------------
    // BMC TX DMA Signals @ clk_apb domain
    //-------------------------------------------------------------------------
    wire        bmc_tx_dma_req_o;   // usb_pd bmc_tx DMA request
    reg         bmc_tx_dma_ack_i;   // usb_pd bmc_tx DMA acknowledge
    reg  [31:0] bmc_tx_buf_i;       // usb_pd bmc_tx DMA data input

    //-------------------------------------------------------------------------
    // BMC RX DMA Signals @ clk_apb domain
    //-------------------------------------------------------------------------
    wire        bmc_rx_dma_req_o;   // usb_pd bmc_rx DMA request
    wire [31:0] bmc_rx_buf_o;       // usb_pd bmc_rx DMA data output
    reg         bmc_rx_dma_ack_i;   // usb_pd bmc_rx DMA acknowledge

    //-------------------------------------------------------------------------
    // DFT Port
    //-------------------------------------------------------------------------
    reg         scan_en_i;          // scan enable

`ifdef FPGA
    //-------------------------------------------------------------------------
    // Debug Pins (FPGA only)
    //-------------------------------------------------------------------------
    wire [7:0]  dbg_usb_pd;         // debug pin
    wire [7:0]  dbg_usb_pd_tx;      // debug pin
    wire [7:0]  dbg_usb_pd_rx;      // debug pin
`endif

    //=========================================================================
    // DUT Instantiation
    //=========================================================================
    usb_pd u_usb_pd (
`ifdef FPGA
        .dbg_usb_pd         (dbg_usb_pd),
        .dbg_usb_pd_tx      (dbg_usb_pd_tx),
        .dbg_usb_pd_rx      (dbg_usb_pd_rx),
`endif
        // APB interface
        .prdata_o           (prdata_o),
        .psel_i             (psel_i),
        .penable_i          (penable_i),
        .pwrite_i           (pwrite_i),
        .paddr_i            (paddr_i),
        .pwdata_i           (pwdata_i),

        // BMC signals
        .bmc_txen_o         (bmc_txen_o),
        .bmc_out_o          (bmc_out_o),
        .bmc_in_i           (bmc_in_i),

        // Interrupt & setting
        .usb_pd_int_o       (usb_pd_int_o),
        .reg_usb_pd_en_o    (reg_usb_pd_en_o),

        // CC bus
        .cc_idle_cmp_i      (cc_idle_cmp_i),

        // Timing signals
        .time_8u_p_i        (time_8u_p_i),
        .time_2m_p_i        (time_2m_p_i),

        // BMC TX DMA signals
        .bmc_tx_dma_req_o   (bmc_tx_dma_req_o),
        .bmc_tx_dma_ack_i   (bmc_tx_dma_ack_i),
        .bmc_tx_buf_i       (bmc_tx_buf_i),

        // BMC RX DMA signals
        .bmc_rx_dma_req_o   (bmc_rx_dma_req_o),
        .bmc_rx_buf_o       (bmc_rx_buf_o),
        .bmc_rx_dma_ack_i   (bmc_rx_dma_ack_i),

        // DFT
        .scan_en_i          (scan_en_i),

        // Clock & reset
        .clk_apb            (clk_apb),
        .rst_n              (rst_n)
    );

    //=========================================================================
    // Clock Generation
    // Assume APB clock = 50 MHz → period = 20 ns
    //=========================================================================
    localparam CLK_PERIOD = 20; // ns

    initial clk_apb = 0;
    always #(CLK_PERIOD/2) clk_apb = ~clk_apb;

    //=========================================================================
    // Timing Pulse Generation
    // time_8u_p_i  : 1 pulse every 8 us  = 400 clk cycles @ 50MHz
    // time_2m_p_i  : 1 pulse every 2.048ms = 102400 clk cycles @ 50MHz
    //=========================================================================
    localparam PULSE_8U_CNT  = 400;
    localparam PULSE_2M_CNT  = 102400;

    integer cnt_8u  = 0;
    integer cnt_2m  = 0;

    always @(posedge clk_apb or negedge rst_n) begin
        if (!rst_n) begin
            cnt_8u      <= 0;
            time_8u_p_i <= 0;
        end else begin
            if (cnt_8u == PULSE_8U_CNT - 1) begin
                cnt_8u      <= 0;
                time_8u_p_i <= 1;
            end else begin
                cnt_8u      <= cnt_8u + 1;
                time_8u_p_i <= 0;
            end
        end
    end

    always @(posedge clk_apb or negedge rst_n) begin
        if (!rst_n) begin
            cnt_2m      <= 0;
            time_2m_p_i <= 0;
        end else begin
            if (cnt_2m == PULSE_2M_CNT - 1) begin
                cnt_2m      <= 0;
                time_2m_p_i <= 1;
            end else begin
                cnt_2m      <= cnt_2m + 1;
                time_2m_p_i <= 0;
            end
        end
    end

    //=========================================================================
    // APB Task
    //=========================================================================

    // APB Write
    task apb_write;
        input [11:0] addr;
        input [31:0] data;
        begin
            @(posedge clk_apb);
            #1;
            psel_i    = 1;
            pwrite_i  = 1;
            paddr_i   = addr;
            pwdata_i  = data;
            penable_i = 0;

            @(posedge clk_apb);
            #1;
            penable_i = 1;

            @(posedge clk_apb);
            #1;
            psel_i    = 0;
            penable_i = 0;
            pwrite_i  = 0;
        end
    endtask

    // APB Read
    task apb_read;
        input  [11:0] addr;
        output [31:0] rdata;
        begin
            @(posedge clk_apb);
            #1;
            psel_i    = 1;
            pwrite_i  = 0;
            paddr_i   = addr;
            penable_i = 0;

            @(posedge clk_apb);
            #1;
            penable_i = 1;

            @(posedge clk_apb);
            rdata     = prdata_o;
            #1;
            psel_i    = 0;
            penable_i = 0;
        end
    endtask

    //=========================================================================
    // DMA Response Task (BMC TX)
    //=========================================================================
    task bmc_tx_dma_respond;
        input [31:0] tx_data;
        begin
            wait (bmc_tx_dma_req_o == 1);
            @(posedge clk_apb);
            #1;
            bmc_tx_buf_i      = tx_data;
            bmc_tx_dma_ack_i  = 1;
            @(posedge clk_apb);
            #1;
            bmc_tx_dma_ack_i  = 0;
        end
    endtask

    //=========================================================================
    // DMA Response Task (BMC RX)
    //=========================================================================
    task bmc_rx_dma_respond;
        begin
            wait (bmc_rx_dma_req_o == 1);
            @(posedge clk_apb);
            #1;
            bmc_rx_dma_ack_i = 1;
            @(posedge clk_apb);
            #1;
            bmc_rx_dma_ack_i = 0;
        end
    endtask

    //=========================================================================
    // Main Test Sequence
    //=========================================================================
    reg [31:0] rd_data;

    initial begin
        // ----- Initialise all inputs -----
        rst_n            = 0;
        psel_i           = 0;
        penable_i        = 0;
        pwrite_i         = 0;
        paddr_i          = 12'h0;
        pwdata_i         = 32'h0;
        bmc_in_i         = 0;
        cc_idle_cmp_i    = 0;
        bmc_tx_dma_ack_i = 0;
        bmc_tx_buf_i     = 32'h0;
        bmc_rx_dma_ack_i = 0;
        scan_en_i        = 0;

        // ----- Reset sequence -----
        repeat(10) @(posedge clk_apb);
        rst_n = 1;
        repeat(5)  @(posedge clk_apb);

        $display("[%0t] === Test 1: APB Register Write/Read ===", $time);
        apb_write(12'h00, 32'hA5A5_5A5A);
        apb_read (12'h00, rd_data);
        $display("[%0t] APB addr=0x00 write=0xA5A55A5A read=0x%08X", $time, rd_data);

        $display("[%0t] === Test 2: Enable USB PD via APB ===", $time);
        apb_write(12'h04, 32'h0000_0001); // assume bit[0] = usb_pd_en
        repeat(10) @(posedge clk_apb);
        $display("[%0t] reg_usb_pd_en_o = %b", $time, reg_usb_pd_en_o);

        $display("[%0t] === Test 3: CC Idle Comparator Toggle ===", $time);
        repeat(5) @(posedge clk_apb);
        cc_idle_cmp_i = 1;
        repeat(20) @(posedge clk_apb);
        cc_idle_cmp_i = 0;
        repeat(5) @(posedge clk_apb);

        $display("[%0t] === Test 4: BMC TX DMA Handshake ===", $time);
        fork
            bmc_tx_dma_respond(32'hDEAD_BEEF);
        join
        repeat(10) @(posedge clk_apb);

        $display("[%0t] === Test 5: BMC RX DMA Handshake ===", $time);
        // Simulate incoming BMC data
        bmc_in_i = 1;
        repeat(5) @(posedge clk_apb);
        bmc_in_i = 0;
        fork
            bmc_rx_dma_respond();
        join
        repeat(10) @(posedge clk_apb);

        $display("[%0t] === Test 6: Interrupt Check ===", $time);
        repeat(20) @(posedge clk_apb);
        $display("[%0t] usb_pd_int_o = %b", $time, usb_pd_int_o);
        // Clear interrupt via APB (address depends on actual register map)
        apb_write(12'h08, 32'hFFFF_FFFF);
        repeat(5) @(posedge clk_apb);
        $display("[%0t] usb_pd_int_o after clear = %b", $time, usb_pd_int_o);

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
    // Timeout Watchdog (10 ms simulation limit)
    //=========================================================================
    initial begin
        #10_000_000;
        $display("[%0t] TIMEOUT: simulation exceeded limit", $time);
        $finish;
    end

endmodule