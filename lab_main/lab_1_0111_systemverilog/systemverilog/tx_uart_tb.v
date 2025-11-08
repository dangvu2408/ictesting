`timescale 1ns/1ps

module tx_uart_tb;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  data_in;
    reg         di_rdy;
    reg  [2:0]  baud;
    reg         parity;
    wire        txd;
    wire        send_e;

    tx_uart #(.fclk(5000000)) uut (
        .clk     (clk),
        .rst_n   (rst_n),
        .data_in (data_in),
        .di_rdy  (di_rdy),
        .baud    (baud),
        .parity  (parity),
        .txd     (txd),
        .send_e  (send_e)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    task send_byte(input [7:0] value);
    begin
        @(posedge clk);
        data_in = value;
        di_rdy  = 1'b1;

        @(posedge clk);
        di_rdy = 1'b0;

        $display("[%0t ns] -> TX REQUEST | Send byte = 0x%0h (%b)", $time, value, value);
        
        wait(send_e == 1'b1);
        $display("[%0t ns] -> FRAME SENT DONE", $time);
    end
    endtask

    initial begin
        rst_n   = 0;
        di_rdy  = 0;
        baud    = 3'd5;   // 115200 baud 
        parity  = 1'b1;   // parity 

        #100 rst_n = 1; // reset
        $display("------ UART TX TEST START ------");

        send_byte(8'h55);

        $display("------ UART TX TEST DONE ------");
        #5000;
        $finish;
    end

endmodule
