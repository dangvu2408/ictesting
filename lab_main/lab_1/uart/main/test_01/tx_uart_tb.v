`timescale 1ns/1ps

module tb_tx_uart;

    reg clk_tx;
    reg rst_n;
    reg load_tx_datareg;
    reg ready;
    reg di_rdy;
    reg [7:0] data_in;
    reg parity;

    wire txd;

    tx_uart #(.word_size(7)) DUT (
        .txd(txd),
        .data_in(data_in),
        .load_tx_datareg(load_tx_datareg),
        .ready(ready),
        .di_rdy(di_rdy),
        .clk_tx(clk_tx),
        .rst_n(rst_n),
        .parity(parity)
    );

    initial begin
        clk_tx = 0;
        forever #5 clk_tx = ~clk_tx; 
    end

    // bộ dữ liệu kiểm thử
    reg [7:0] testcase_byte [0:9]; // được init từ trước
    reg [7:0] testcase_byte_random [0:9]; // được tạo ngẫu nhiên bằng hàm
    integer i;

    initial begin 
        testcase_byte[0] = 8'h55;
        testcase_byte[1] = 8'hA3;
        testcase_byte[2] = 8'hF0;
        testcase_byte[3] = 8'h00;
        testcase_byte[4] = 8'hDE;
        testcase_byte[5] = 8'hAD;
        testcase_byte[6] = 8'hBE;
        testcase_byte[7] = 8'hEF;
        testcase_byte[8] = 8'h11;
        testcase_byte[9] = 8'h22;
    end // tạo dữ liệu

    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            testcase_byte_random[i] = $urandom_range(0, 255);
            $display("Random[%0d] = %h", i, testcase_byte_random[i]);
        end
    end // tạo ngẫu nhiên dữ liệu


    // task mô phỏng testcase truyền các bit rời rạc (CHECKED)
    task send_byte(input [7:0] din);
        begin
            data_in = din;

            load_tx_datareg = 1;
            #10;
            load_tx_datareg = 0;

            ready = 1;
            #10;
            ready = 0;

            di_rdy = 1;
            #10;
            di_rdy = 0;

            #150;
        end
    endtask

    // task mô phỏng testcase truyền các bit liên tục (CHECKED)
    // sử dụng sườn của các tín hiệu load_tx_datareg và clear
    task send_continuous(input [7:0] din);
        begin
            data_in = din;
            load_tx_datareg = 1;
            @(posedge clk_tx); 
            load_tx_datareg = 0;

            ready = 1;
            @(posedge clk_tx);
            ready = 0;

            di_rdy = 1;
            @(posedge clk_tx);
            di_rdy = 0;
        end
    endtask


    initial begin
        rst_n = 0;
        load_tx_datareg = 0;
        ready = 0;
        di_rdy = 0;
        data_in = 0;
        parity = 0;

        
        
        #30;
        rst_n = 1;
/*
        // CASE 1: EVEN parity, gửi 0x55
        parity = 0;
        send_byte(testcase_byte[0]);

        // CASE 2: EVEN parity, gửi 0xA3
        send_byte(testcase_byte[1]);

        // CASE 3: ODD parity, gửi 0xF0
        parity = 1;    // ODD
        send_byte(testcase_byte[2]);

        // CASE 4: ODD parity, gửi 0x00
        send_byte(testcase_byte[3]);

        #300;
*/
/*
        // CASE 5: truyền liên tiếp
        
        parity = 1;
        send_continuous(testcase_byte[0]);
        for (i = 1; i < 10; i = i + 1) begin
            @(negedge DUT.M1.clear);  
            if (i < 5) begin 
                parity = 1;
            end else begin 
                parity = 0;
            end
            
            send_continuous(testcase_byte[i]);
        end
*/
        // CASE 6: truyền liên tiếp dữ liệu ngẫu nhiên
        parity = 1;
        send_continuous(testcase_byte_random[0]);
        for (i = 1; i < 10; i = i + 1) begin
            @(negedge DUT.M1.clear);  
            if (i < 5) begin 
                parity = 1;
            end else begin 
                parity = 0;
            end
            
            send_continuous(testcase_byte_random[i]);
        end

//    // case 5: word size khác nhau
//         // -----------------------------
//         $display("=== Testcase 1: word size khác nhau ===");
//         parity = 0; // EVEN
//         send_byte(8'h1F);  // 5-bit value
//         send_byte(8'h6D);  // 7-bit value
//         send_byte(8'hFF);  // 8-bit value

//         // -----------------------------
//        // case 6: dữ liệu biên
//         // -----------------------------
//         $display("=== Testcase 5: dữ liệu biên ===");
//         send_byte(8'h00);
//         send_byte(8'hFF);
//         send_byte(8'h80);
//         send_byte(8'h01);

//         // -----------------------------
//         //case 7: reset giữa quá trình truyền
//         // -----------------------------
//         $display("=== Testcase 6: reset giữa truyền ===");
//         data_in = 8'hAA;
//         load_tx_datareg = 1;
//         #5;
//         load_tx_datareg = 0;
//         ready = 1;
//         #5;
//         ready = 0;
//         di_rdy = 1;
//         #5;
//         // reset giữa truyền
//         rst_n = 0;
//         #10;
//         rst_n = 1;
//         di_rdy = 0;

        $display("=== Kết thúc tất cả testcase ===");
        $stop;
    end
endmodule
