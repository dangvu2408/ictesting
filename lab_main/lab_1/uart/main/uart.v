module uart #(parameter word_size = 8)(
    input clk,
    input rst_b,
    input [2:0] Sel_Baud_Rate,
    input [word_size-1:0] tx_data,
    input tx_load,
    input tx_byte_ready,
    input tx_T_byte,
    input serial_in,
    output serial_out,
    output [word_size-1:0] rx_data,
    output rx_ready,
    output rx_error1,
    output rx_error2
);

    wire Clock, Sample_clk;

    wire Load_XMT_DR, Load_XMT_shftreg, start, shift, clear;
    wire BC_lt_BCmax;

    wire Ser_in_0, SC_eq_3, SC_lt_7, BC_eq_8;
    wire clr_Sample_counter, inc_Sample_counter;
    wire clr_Bit_counter, inc_Bit_counter;
    wire shift_rx, load_rx;

    baud_gen baud_inst (
        .Clock(Clock),
        .Sample_clk(Sample_clk),
        .Sel_Baud_Rate(Sel_Baud_Rate),
        .clk(clk),
        .rst_b(rst_b)
    );

    tx_uart #(word_size) tx_inst (
        .Serial_out(serial_out),
        .Data_Bus(tx_data),
        .Load_XMT_datareg(tx_load),
        .Byte_ready(tx_byte_ready),
        .T_byte(tx_T_byte),
        .Clock(Clock),
        .rst_b(rst_b)
    );

    rx_uart #(word_size) rx_inst (
        .RCV_datareg(rx_data),
        .read_not_ready_out(rx_ready),
        .Error1(rx_error1),
        .Error2(rx_error2),
        .Serial_in(serial_in),
        .read_not_ready_in(rx_ready),
        .Sample_clk(Sample_clk),
        .rst_b(rst_b)
    );

endmodule