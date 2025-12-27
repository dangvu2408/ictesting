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

    tx_uart #(.word_size(8)) DUT (
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
    // clk from initial, not from Baud_gen

    // test dataset 
    reg [7:0] testcase_byte [0:9];        // manually generated dataset
    reg [7:0] testcase_byte_random [0:9]; // randomly generated dataset
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
    end // init manually dataset

    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            testcase_byte_random[i] = $urandom_range(0, 255);
            $display("Random[%0d] = %h", i, testcase_byte_random[i]);
        end
    end // init randomly dataset


    // Task: Simulate a test case for transmitting discrete data
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

    // Task: simulate a test case of transmitting consecutive bits
    // Use the edges of the load_tx_datareg and clear signals
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

    // Guide: If you want to test a specific testcase, simply uncomment that testcase.

    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 1: Transmit separate datasets ==========================================  */
    /*  --------------------------------------------------------------------------------------------------*/

        // even parity
        /*           // REMOVE THE COMMENT HERE
        parity = 0;
        send_byte(testcase_byte[0]);
        send_byte(testcase_byte[1]);
        send_byte(testcase_byte[2]);
        send_byte(testcase_byte[3]);
        send_byte(testcase_byte[4]);
        send_byte(testcase_byte[5]);
        send_byte(testcase_byte[6]);
        send_byte(testcase_byte[7]);
        send_byte(testcase_byte[8]);
        send_byte(testcase_byte[9]);

        // even parity
        parity = 1;
        send_byte(testcase_byte[0]);
        send_byte(testcase_byte[1]);
        send_byte(testcase_byte[2]);
        send_byte(testcase_byte[3]);
        send_byte(testcase_byte[4]);
        send_byte(testcase_byte[5]);
        send_byte(testcase_byte[6]);
        send_byte(testcase_byte[7]);
        send_byte(testcase_byte[8]);
        send_byte(testcase_byte[9]);

        #300;
        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 2: Transmit consecutive datasets =======================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

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

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 3: Transmit consecutive random datasets ================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

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

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 4: Transmit boundary data sets =========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

        // even parity
        parity = 1;
        send_byte(8'h80);
        send_byte(8'h40);
        send_byte(8'h20);
        send_byte(8'h10);
        send_byte(8'h08);
        send_byte(8'h04);
        send_byte(8'h02);
        send_byte(8'h01);
        
        // odd parity
        parity = 0;
        send_byte(8'h80);
        send_byte(8'h40);
        send_byte(8'h20);
        send_byte(8'h10);
        send_byte(8'h08);
        send_byte(8'h04);
        send_byte(8'h02);
        send_byte(8'h01);
        #300;

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 5: Change the data width ===============================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

            // Change the parameter

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/



    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 6: Reset during transmission ===========================================  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

            data_in = 8'hAA;
            load_tx_datareg = 1;
            #5;
            load_tx_datareg = 0;
            ready = 1;
            #5;
            ready = 0;
            di_rdy = 1;
            #5;
            // reset 
            rst_n = 0;
            #10;
            rst_n = 1;
            di_rdy = 0;

        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/
    


    /*  --------------------------------------------------------------------------------------------------*/
    /*  SUBFEATURE 2 - TESTCASE 7: The ready, di_rdy, and load_tx_datareg signals are longer/faster. ===  */
    /*  --------------------------------------------------------------------------------------------------*/
        /*           // REMOVE THE COMMENT HERE

            data_in = 8'h55;

            load_tx_datareg = 1;
            #20;
            load_tx_datareg = 0;

            ready = 1;
            #10;
            ready = 0;

            di_rdy = 1;
            #10;
            di_rdy = 0;

            #150;
        */           // REMOVE THE COMMENT HERE
    /*  --------------------------------------------------------------------------------------------------*/
    /*  ================================================================================================  */
    /*  --------------------------------------------------------------------------------------------------*/
    
        $display("=== End all subfeature testcase ===");
        $stop;
    end
endmodule
