`timescale 1ns/1ps

module rx_uart_tb;

    localparam FCLK = 5000000;
    
    reg clk;
    reg rst_n;
    reg rxd;
    reg [2:0] baud;
    reg parity; 
    integer uart_bit_time;

    wire [7:0] data_out;
    wire do_rdy;
    integer test_data;

    rx_uart #( .fclk(FCLK) ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(rxd),
        .baud(baud),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy)
    );

    always begin
        #100 clk = ~clk;
    end

    task uart_send_byte(input [7:0] byte_in);
        integer i;
        begin
            $display("[%0t] TB: Send Byte %h...", $time, byte_in);

            @(posedge uut.tick_pulse);

            for (i = 0; i < 8; i = i + 1) begin
                rxd = byte_in[i];
                @(posedge uut.tick_pulse);
            end

            if (parity == 1) begin
                rxd = ^byte_in;
                @(posedge uut.tick_pulse);
            end

            rxd = 1;
            @(negedge uut.tick_pulse);
             
        end
    endtask

    initial begin
        baud = 5; 
        parity = 1;
        uart_bit_time = 1e9 / 115200;
    end

    initial begin
        clk = 0;
        rxd = 1; 
        rst_n = 0;
        
        #500;
        rst_n = 1;
        
        $display("[%0t] ------ UART RX TEST START (Baud 115200) ------", $time);
        
        test_data = 8'h55; 
        rxd = 0;
        uart_send_byte(test_data);
        wait (do_rdy == 1'b1);
        $display("[%0t] >> Byte 1: Receive = %h, Expect = %h | Result: %s", $time, data_out, test_data, 
                 (data_out == test_data) ? "PASS" : "FAIL");
        wait (do_rdy == 1'b0); 

        test_data = 8'hA3;
        rxd = 0;
        uart_send_byte(test_data);
        wait (do_rdy == 1'b1);
        $display("[%0t] >> Byte 2: Receive = %h, Expect = %h | Result: %s", $time, data_out, test_data, 
                 (data_out == test_data) ? "PASS" : "FAIL");
        wait (do_rdy == 1'b0);

        test_data = 8'h7E;
        rxd = 0;
        uart_send_byte(test_data);
        wait (do_rdy == 1'b1);
        $display("[%0t] >> Byte 2: Receive = %h, Expect = %h | Result: %s", $time, data_out, test_data, 
                 (data_out == test_data) ? "PASS" : "FAIL");
        wait (do_rdy == 1'b0);

        $display("[%0t] ------ UART RX TEST DONE -------", $time);
        $stop;
    end

endmodule