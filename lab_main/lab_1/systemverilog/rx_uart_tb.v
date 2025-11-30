`timescale 1ns/1ps

module rx_uart_tb;

    reg clk;
    reg rst_n;
    reg rxd;
    reg [2:0] baud;
    reg parity;
    integer uart_bit_time;

    wire [7:0] data_out;
    wire do_rdy;

    rx_uart #(5000000) uut (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(rxd),
        .baud(baud),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy)
    );

    initial begin
        clk = 0;
        forever #100 clk = ~clk;
    end

    task uart_send_byte(input [7:0] byte);
        integer i;
        begin
            rxd = 0;
            #(uart_bit_time);

            for (i = 0; i < 8; i = i + 1) begin
                rxd = byte[i];
                #(uart_bit_time);
            end

            if (parity == 1) begin
                rxd = ^byte;    
                #(uart_bit_time);
            end

            rxd = 1;
            #(uart_bit_time);
        end
    endtask

    

    initial begin
        baud = 5;        // baud = 115200
        parity = 1;      // parity
    end

    initial begin
        uart_bit_time = (1000000000 / 115200);   

        rxd = 1;
        rst_n = 0;
        #500;
        rst_n = 1;

        $display("------ UART RX TEST START ------");

        uart_send_byte(8'h55);

        $display(">> Received byte = %h, do_rdy = %b", data_out, do_rdy);
        $display("------ UART RX TEST DONE -------");
        #5000;
        $stop;
    end

endmodule
