`timescale 1ns / 1ps

module rx_uart_tb;

    parameter fclk = 5000000; 
    parameter tclk = 1000000000 / fclk;
    

    reg clk_rx; 
    reg rst_n; 
    reg rxd;
    reg not_rdy_in;
    reg parity;

    wire [7:0] data_out; 
    wire do_rdy;
    wire parity_error;
    wire ready_error;

    rx_uart #(.word_size(8)) uut_rx (
        .clk_rx(clk_rx),
        .rst_n(rst_n),
        .rxd(rxd),
        .not_rdy_in(not_rdy_in), 
        .parity(parity),
        .data_out(data_out), 
        .do_rdy(do_rdy),
        .parity_error(parity_error), 
        .ready_error(ready_error)
    );
    
    initial begin
        clk_rx = 1'b0;
        forever #(tclk/2) clk_rx = ~clk_rx; 
    end

    reg testcase_byte [0:10]; // được init từ trước
    reg testcase_byte_random [0:10]; // được tạo ngẫu nhiên bằng hàm
    integer i;

    initial begin 
        testcase_byte[0] = 1'b0;
        testcase_byte[1] = 1'b1;
        testcase_byte[2] = 1'b0;
        testcase_byte[3] = 1'b1;
        testcase_byte[4] = 1'b0;
        testcase_byte[5] = 1'b1;
        testcase_byte[6] = 1'b0;
        testcase_byte[7] = 1'b1;
        testcase_byte[8] = 1'b0;
        testcase_byte[9] = 1'b0;
        testcase_byte[10] = 1'b1;
    end // tạo dữ liệu

    initial begin
        for (i = 0; i < 12; i = i + 1) begin
            testcase_byte_random[i] = $urandom_range(0, 1);
            $display("Random[%0d] = %h", i, testcase_byte_random[i]);
        end
    end // tạo ngẫu nhiên dữ liệu

    task send_byte(input din);
        begin
            rxd = din;
            # (tclk * 8); 
        end
    endtask


    initial begin
        rst_n = 1'b0;
        rxd = 1'b1;
        not_rdy_in = 1'b0; 
        parity = 0;
        # (tclk * 4);

        rst_n = 1'b1; 
        # (tclk * 16);

        for (i = 0; i < 12; i = i + 1) begin
            send_byte(testcase_byte[i]);
        end
        
        # (tclk * 16);

        $display("--- end ---");
        $finish;
    end
    
endmodule