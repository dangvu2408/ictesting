`timescale 1ns/1ps

module tx_rx_uart_tb;

    localparam FCLK = 5000000;

    reg clk;
    reg rst_n;

    reg [2:0] baud;
    reg is_idle;
    wire tick_pulse;
    wire fsm_trigger_pulse;

    reg [7:0] data_in;
    reg di_rdy;
    reg parity;

    wire txd;
    wire send_e;

    wire [7:0] data_out;
    wire do_rdy;
    wire rxd;

    initial clk = 0;
    always #0.1 clk = ~clk; 

    baud_gen_uart #(.fclk(FCLK)) baud_inst (
        .clk(clk),
        .rst_n(rst_n),
        .baud(baud),
        .is_idle(is_idle),
        .tick_pulse(tick_pulse),
        .fsm_trigger_pulse(fsm_trigger_pulse)
    );

    tx_uart tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .baud(baud),
        .parity(parity),
        .txd(txd),
        .send_e(send_e)
    );

    rx_uart rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(txd),
        .baud(baud),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy)
    );

    always @(posedge clk or negedge rst_n) begin
        is_idle = (tx_inst.state == 0); 
    end

    reg [7:0] data_list [0:4];
    integer i;

    initial begin
        rst_n = 0;
        baud = 5;
        parity = 1;
        di_rdy = 0;

        data_list[0] = 8'h55;
        data_list[1] = 8'hA3;
        data_list[2] = 8'h0F;
        data_list[3] = 8'hC1;
        data_list[4] = 8'h7E;

        #100 rst_n = 1;

        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            data_in <= data_list[i];
            di_rdy  <= 1;
            @(posedge clk);
            di_rdy  <= 0;

            $display("[%0t] Sending %h...", $time, data_list[i]);

            wait(send_e == 1);
            wait(send_e == 0);

            wait(do_rdy == 1);

            $display("[%0t] RX = %h | Expect = %h | %s",
                $time, data_out, data_list[i],
                (data_out == data_list[i]) ? "PASS" : "FAIL");

            wait(do_rdy == 0);
        end

        #200 $stop;
    end

endmodule
