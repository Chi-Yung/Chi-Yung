`timescale 1ns / 1ps
module rx_top(
    input clk,
    input rst,
    input rx_pin_in,
    output [7:0] seg7,
	 output tclk_bps
    //output [7: 0] rx_data,
    //output rx_done_sig
    ) ;
    wire rx_pin_H2L;
	 assign tclk_bps = clk_bps;
    H2L_detect rx_in_detect(
        .clk( clk ),
        .rst( rst ),
        .pin_in( rx_pin_in ),
        .sig_H2L( rx_pin_H2L )
    );
    wire rx_band_sig;
    wire clk_bps;
    rx_band_gen rx_band_gen(
        .clk( clk ),
        .rst( rst ),
        .band_sig( rx_band_sig ),
        .clk_bps( clk_bps )
    );
    wire [7:0] rx_data;
    rx_ctl rx_ctl(
        .clk( clk ),
        .rst( rst ),
        .rx_pin_in( rx_pin_in ),
        .rx_pin_H2L( rx_pin_H2L ),
        .rx_band_sig( rx_band_sig ),
        .rx_clk_bps( clk_bps ),
        .rx_data( rx_data ),
        .rx_done_sig( rx_done_sig )
    );
    ASCII2seg7 u_ASCII2seg7(
        .rst( rx_done_sig ),
        .ASCII( rx_data ),
        .seg7_out(seg7)
    );
endmodule