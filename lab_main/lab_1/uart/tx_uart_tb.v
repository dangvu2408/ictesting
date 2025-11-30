`timescale 1ns/1ps

module tx_uart_tb;

    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg di_rdy;
    reg [2:0] baud;
    reg parity;

    wire txd;
    wire send_e;
    wire tick_pulse;

    tx_uart #( .fclk(5000000) ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .baud(baud),
        .parity(parity),
        .txd(txd),
        .send_e(send_e)
    );

    always #5 clk = ~clk;

    reg [7:0] data_list [0:4];
    integer i;

    initial begin
        clk = 0;
        rst_n = 0;
        di_rdy = 0;
        baud = 1;      
        parity = 1;    

        data_list[0] = 8'h55;
        data_list[1] = 8'hA3;
        data_list[2] = 8'h0F;
        data_list[3] = 8'hC1;
        data_list[4] = 8'h7E;

        #50 rst_n = 1;

        for (i = 0; i < 5; i = i + 1) begin
            
            @(posedge clk);

            data_in <= data_list[i];
            di_rdy  <= 1'b1;
            @(posedge clk);
            di_rdy  <= 0;

            $display("=== Sending Byte %0d: %h ===", i, data_list[i]);

            wait (send_e == 1'b1);
            wait (send_e == 1'b0);
            @(posedge clk);
        end

        $display("\n=== All data sent ===");
        #100 $stop;
    end

endmodule
