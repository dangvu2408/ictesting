`timescale 1ns / 1ps

module rx_uart_tb;

    
    reg clk;
    reg rst_n; 
    reg rxd;
    reg not_rdy_in;
    reg parity;

    wire [7:0] data_out; 
    wire do_rdy;
    wire parity_error;
    wire ready_error;

    wire clk_tx;
    wire clk_rx;
    reg  [2:0] sel_baud_rate;

    localparam tclk = 20;

    Baud_gen #(.fclk(50000000)) baud_gen_inst (
        .clk(clk),
        .rst_n(rst_n),
        .sel_baud_rate(sel_baud_rate),
        .clk_tx(clk_tx),
        .clk_rx(clk_rx)
    );

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
        clk = 1'b0;
        forever #(tclk/2) clk = ~clk;
    end

    reg [7:0] testcase_byte        [0:10];
    reg [7:0] testcase_byte_sec    [0:10];
    reg [7:0] testcase_byte_random [0:10];
    integer i;

    initial begin 
        testcase_byte[0]  = 8'h4A;
        testcase_byte[1]  = 8'h55;
        testcase_byte[2]  = 8'h97;
        testcase_byte[3]  = 8'h1F;
        testcase_byte[4]  = 8'h3B;
        testcase_byte[5]  = 8'h62;
        testcase_byte[6]  = 8'h9D;
        testcase_byte[7]  = 8'hAE;
        testcase_byte[8]  = 8'h00;
        testcase_byte[9]  = 8'hFF;
        testcase_byte[10] = 8'hA5;
    end // tạo dữ liệu

    initial begin
        testcase_byte_sec[0]  = 8'h11;
        testcase_byte_sec[1]  = 8'h22;
        testcase_byte_sec[2]  = 8'h33;
        testcase_byte_sec[3]  = 8'h44;
        testcase_byte_sec[4]  = 8'h55;
        testcase_byte_sec[5]  = 8'h66;
        testcase_byte_sec[6]  = 8'h77;
        testcase_byte_sec[7]  = 8'h88;
        testcase_byte_sec[8]  = 8'h99;
        testcase_byte_sec[9]  = 8'hAA;
        testcase_byte_sec[10] = 8'hBB;
    end

    initial begin
        for (i = 0; i < 11; i = i + 1) begin
            testcase_byte_random[i] = $urandom_range(0, 255);
            $display("Random[%0d] = 0x%02h", i, testcase_byte_random[i]);
        end
    end

    task send_bit(input din);
        begin
            rxd = din;
            repeat (16) @(posedge clk_rx);
        end
    endtask

    task send_uart_frame(input [7:0] data);
        integer i;
        begin
            send_bit(1'b0);

            for (i = 0; i < 8; i = i + 1)
                send_bit(data[i]);

            send_bit(1'b1);
        end
    endtask



    initial begin
        rst_n = 1'b0;
        rxd = 1'b1;
        not_rdy_in = 1'b0; 
        sel_baud_rate = 3'b101;
        parity = 0;
        # (tclk * 4);

        rst_n = 1'b1; 
        # (tclk * 16);

        // Guide: If you want to test a specific testcase, simply uncomment that testcase.

    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 3 - TESTCASE 1: Receive separate datasets ==========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

        for (i = 0; i < 11; i = i + 1) begin
            send_uart_frame(testcase_byte[i]);
        end

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 3 - TESTCASE 2: Receive consecutive datasets ==========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

        for (i = 0; i < 11; i = i + 1) begin
            send_uart_frame(testcase_byte[i]);
        end
        for (i = 0; i < 11; i = i + 1) begin
            send_uart_frame(testcase_byte_sec[i]);
        end

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 3 - TESTCASE 3: Receive random datasets ==========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

        for (i = 0; i < 12; i = i + 1) begin
            send_uart_frame(testcase_byte_random[i]);
        end

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/


    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 3 - TESTCASE 4: Transmit boundary data sets =========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

        send_uart_frame(8'h00); 
        send_uart_frame(8'hFF); 
        send_uart_frame(8'h01); 
        send_uart_frame(8'h80); 
        send_uart_frame(8'h7F); 
        send_uart_frame(8'hFE); 

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/

    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 3 - TESTCASE 5: Change the data width ===============================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

            // Change the parameter

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/


        
        # (tclk * 16);

        $display("--- end ---");
        $finish;
    end
    
endmodule