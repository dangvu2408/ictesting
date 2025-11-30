`timescale 1ns/1ps

module uart_top_tb;

    localparam WORD_SIZE = 8;


    reg clk;

    reg rst_n;

    reg  [2:0] sel_baud_rate;
    reg  [WORD_SIZE - 1:0] data_in ;
    reg        di_rdy;
    reg        parity;
    reg        not_rdy_in;
    reg        load_tx_datareg;
    reg        ready;

    wire txd;
    wire rxd = txd;

    wire [WORD_SIZE - 1:0] data_out;
    wire do_rdy;
    wire parity_error;
    wire ready_error;

    integer i;

    uart_top #(.fclk(5000000), .word_size(WORD_SIZE)) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .sel_baud_rate(sel_baud_rate),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .parity(parity),
        .rxd(rxd),
        .not_rdy_in(not_rdy_in),
        .load_tx_datareg(load_tx_datareg),
        .ready(ready),
        .txd(txd),
        .data_out(data_out),
        .do_rdy(do_rdy),
        .parity_error(parity_error),
        .ready_error(ready_error)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    reg [WORD_SIZE - 1:0] testcase_byte [0:9];

    initial begin 
        testcase_byte[0] = 7'h55;
        testcase_byte[1] = 7'hA3;
        testcase_byte[2] = 7'hF0;
        testcase_byte[3] = 7'h00;
        testcase_byte[4] = 7'hDE;
        testcase_byte[5] = 7'hAD;
        testcase_byte[6] = 7'hBE;
        testcase_byte[7] = 7'hEF;
        testcase_byte[8] = 7'h11;
        testcase_byte[9] = 7'h22;
    end // tạo dữ liệu

    task send_byte_uart(input [WORD_SIZE - 1:0] din);
        begin
            data_in = din;
            @ (posedge DUT.clk_tx);
            load_tx_datareg = 1;
            @ (posedge DUT.clk_tx);
            load_tx_datareg = 0;

            ready = 1;
            @ (posedge DUT.clk_tx);
            ready = 0;

            di_rdy = 1;
            @ (posedge DUT.clk_tx);
            di_rdy = 0;
            @ (posedge DUT.clk_tx);

        end
    endtask

    task send_continuous_uart(input [WORD_SIZE - 1:0] din);
        begin
            data_in = din;
            @ (posedge DUT.clk_tx);
            load_tx_datareg = 1;
            @(posedge DUT.clk_tx); 
            load_tx_datareg = 0;

            ready = 1;
            @(posedge DUT.clk_tx);
            ready = 0;

            di_rdy = 1;
            @(posedge DUT.clk_tx);
            di_rdy = 0;
        end
    endtask


    initial begin
        $display("=== UART TOP TESTBENCH START ===");

        rst_n = 0;
        load_tx_datareg = 0;
        ready = 0;
        di_rdy = 0;
        data_in = 0;
        parity = 0;
        not_rdy_in = 0;

        sel_baud_rate = 3'b001;

        #10;
        rst_n = 1;
        
        send_continuous_uart(testcase_byte[0]);
        for (i = 1; i < 10; i = i + 1) begin
            @(negedge DUT.tx_uart_01.clear);  
            if (i < 5) begin 
                parity = 0;
            end else begin 
                parity = 1;
            end
            send_continuous_uart(testcase_byte[i]);
        end

        repeat(25) @(posedge DUT.clk_tx);

        #200;
        $stop;
    end

endmodule
