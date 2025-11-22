`timescale 1ns/1ps

module tx_rx_uart_tb;

    localparam FCLK = 5000000;

    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg di_rdy;
    reg [2:0] baud;
    reg parity;

    wire txd;
    wire send_e;

    wire [7:0] data_out;
    wire do_rdy;
    reg rxd;

    tx_uart #(.fclk(FCLK)) tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .baud(baud),
        .parity(parity),
        .txd(txd),
        .send_e(send_e)
    );

    rx_uart #(.fclk(FCLK)) rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(rxd),
        .baud(baud),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy)
    );

    always @(posedge clk) rxd = txd;

    initial clk = 0;
    always #0.1 clk = ~clk; 

    reg [7:0] data_list [0:4];
    integer i;

    initial begin
        rst_n = 0;
        di_rdy = 0;
        baud = 5;
        parity = 0;

        data_list[0] = 8'h55;
        data_list[1] = 8'hA3;
        data_list[2] = 8'h0F;
        data_list[3] = 8'hC1;
        data_list[4] = 8'h7E;

        #50 rst_n = 1;

        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            data_in <= data_list[i];
            di_rdy  <= 1;
            @(posedge clk);
            di_rdy  <= 0;

            $display("[%0t] Sending Byte %0d: %h", $time, i, data_list[i]);

            wait(send_e == 1);
            wait(send_e == 0);

            wait(do_rdy == 1);
            $display("[%0t] Received Byte: %h | Expect: %h | Result: %s", 
                     $time, data_out, data_list[i], (data_out==data_list[i])?"PASS":"FAIL");
            wait(do_rdy == 0);
        end

        $display("\n=== All bytes sent and received ===");
        #100 $stop;
    end

endmodule
