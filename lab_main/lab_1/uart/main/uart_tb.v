`timescale 1ns/1ps

module uart_tb;

parameter word_size = 8;

reg clk;
reg rst_b;

reg [2:0] Sel_Baud_Rate;

reg [word_size-1:0] tx_data;
reg tx_load;
reg tx_byte_ready;
reg tx_T_byte;

wire serial_out;
reg serial_in;

wire [word_size-1:0] rx_data;
wire rx_ready;
wire rx_error1, rx_error2;

uart #(word_size) uut (
    .clk(clk),
    .rst_b(rst_b),
    .Sel_Baud_Rate(Sel_Baud_Rate),
    .tx_data(tx_data),
    .tx_load(tx_load),
    .tx_byte_ready(tx_byte_ready),
    .tx_T_byte(tx_T_byte),
    .serial_in(serial_in),
    .serial_out(serial_out),
    .rx_data(rx_data),
    .rx_ready(rx_ready),
    .rx_error1(rx_error1),
    .rx_error2(rx_error2)
);

initial clk = 0;
always #10 clk = ~clk;

reg [word_size-1:0] data_array [0:4];
integer i;

initial begin
    rst_b = 0;
    Sel_Baud_Rate = 3'b001; // 9600 baud
    tx_data = 0;
    tx_load = 0;
    tx_byte_ready = 0;
    tx_T_byte = 0;
    serial_in = 1'b1;
    data_array[0] = 8'h55;
    data_array[1] = 8'hA3;
    data_array[2] = 8'h0F;
    data_array[3] = 8'hC1;
    data_array[4] = 8'h7E;

    #100;
    rst_b = 1;

    for (i = 0; i < 5; i = i + 1) begin
        @(posedge clk);
        tx_data = data_array[i];
        tx_load = 1;
        tx_byte_ready = 1;
        tx_T_byte = 1;
        @(posedge clk);
        tx_load = 0;
        tx_byte_ready = 0;
        tx_T_byte = 0;

        wait(uut.tx_inst.BC_lt_BCmax == 0);
        repeat(20) @(posedge clk);
    end

    #5000;
    $stop;
end

always @(serial_out) serial_in = serial_out;

initial begin
    $monitor("Time=%0t | RX_data=%h | rx_ready=%b | rx_error1=%b | rx_error2=%b", 
             $time, rx_data, rx_ready, rx_error1, rx_error2);
end

endmodule