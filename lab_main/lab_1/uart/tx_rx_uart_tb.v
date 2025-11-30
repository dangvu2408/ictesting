`timescale 1ns/1ps

module tx_rx_uart_tb;

    localparam FCLK = 5000000;

    reg clk;
    reg rst_n;

    reg [7:0] data_in;
    reg di_rdy;
    wire txd;
    wire send_e;
    wire [7:0] data_out;
    wire do_rdy;

    reg [2:0] baud;
    reg parity;

    uart_top #(.fclk(FCLK)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .txd(txd),
        .send_e(send_e),
        .data_out(data_out),
        .do_rdy(do_rdy),
        .baud(baud),
        .parity(parity)
    );

    initial clk = 0;
    always #100 clk = ~clk;

    integer i;
    reg [7:0] data_list [0:4];

    initial begin
        rst_n = 0;
        di_rdy = 0;
        baud = 5; 
        parity = 1;

        data_list[0] = 8'h55;
        data_list[1] = 8'hA3;
        data_list[2] = 8'h0F;
        data_list[3] = 8'hC1;
        data_list[4] = 8'h7E;

        #500;
        rst_n = 1;

        #1000;

        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            data_in <= data_list[i];
            di_rdy  <= 1'b1;
            @(posedge clk);
            di_rdy  <= 1'b0;

            $display("[%0t] TB: Sent %0d -> %h", $time, i, data_list[i]);

            wait(send_e == 1);
            wait(send_e == 0);

            wait(do_rdy == 1);
            $display("[%0t] TB: Rx = %h, Expect = %h --> %s", $time, data_out, data_list[i], (data_out==data_list[i])?"PASS":"FAIL");
            wait(do_rdy == 0);

            #2000; 
        end

        $display("[%0t] ALL DONE", $time);
        #500 $stop;
    end

endmodule
