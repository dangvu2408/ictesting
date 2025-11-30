`timescale 1ns/1ps

module tx_rx_uart_tb;

    localparam FCLK = 5000000;   // 5 MHz

    reg clk;
    reg rst_n;

    reg  [7:0] data_in;
    reg        di_rdy;

    wire [7:0] data_out;
    wire       do_rdy;

    reg  [2:0] baud;
    reg        parity;

    wire txd_to_rxd;

    tx_uart #( .fclk(FCLK) ) tx_u (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .baud(baud),
        .parity(parity),
        .txd(txd_to_rxd),
        .send_e()
    );

    rx_uart #( .fclk(FCLK) ) rx_u (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(txd_to_rxd),  
        .baud(baud),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy)
    );

    always #100 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        di_rdy = 0;
        baud = 5;      
        parity = 1;     

        #1000;
        rst_n = 1;

        #1000;

        send_byte(8'h55);

        send_byte(8'hA3);

        send_byte(8'h7E);

        #5000;
        $finish;
    end


    task send_byte(input [7:0] b);
        begin
            @(posedge clk);
            data_in = b;
            di_rdy  = 1;

            @(posedge clk);
            di_rdy = 0;

            wait(do_rdy == 1);
            $display("[%0t] sent = %h, received = %h %s",
                $time, b, data_out,
                (data_out == b) ? "PASS" : "FAIL");

            wait(do_rdy == 0);
        end
    endtask

endmodule
