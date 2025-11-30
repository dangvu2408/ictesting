`timescale 1ns / 1ps

module Baud_gen_tb;

    parameter fclk = 5000000; 
    parameter tclk = 1000000000 / fclk;

    localparam BAUD_4800   = 4800;
    localparam BAUD_9600   = 9600;
    localparam BAUD_19200  = 19200;
    localparam BAUD_38400  = 38400;
    localparam BAUD_57600  = 57600;
    localparam BAUD_115200 = 115200;

    reg clk;
    reg rst_n;
    reg [2:0] sel_baud_rate;
    
    wire clk_tx;
    wire clk_rx;

    // calculate
    integer current_baud;
    integer bit_time_cycles;
    integer rx_count_per_phase;
    real EXPECTED_RX_PERIOD;
    real EXPECTED_TX_PERIOD;
    
    localparam TOLERANCE = 1;

    Baud_gen #(.fclk(fclk)) uut_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .sel_baud_rate(sel_baud_rate),
        .clk_tx(clk_tx),
        .clk_rx(clk_rx)
    );
    
    initial begin
        clk = 1'b0;
        forever #(tclk/2) clk = ~clk; 
    end

    initial begin

        rst_n = 1'b0;
        sel_baud_rate = 3'b000;
        # (tclk * 2);

        rst_n = 1'b1; 
        sel_baud_rate = 3'b001;

        case (sel_baud_rate)
            3'b000: current_baud = BAUD_4800;
            3'b001: current_baud = BAUD_9600;
            3'b010: current_baud = BAUD_19200;
            3'b011: current_baud = BAUD_38400;
            3'b100: current_baud = BAUD_57600;
            3'b101: current_baud = BAUD_115200;
            default: current_baud = BAUD_9600;
        endcase

        bit_time_cycles = $floor(fclk * 1.0 / current_baud); 
        
        rx_count_per_phase = (bit_time_cycles / 8) / 2;
        
        EXPECTED_RX_PERIOD = 2 * rx_count_per_phase * tclk;
        EXPECTED_TX_PERIOD = 8 * rx_count_per_phase * tclk; 

        $display("--- Baud Rate Cal %0d ---", current_baud);
        $display("Tclk = %0d ns. fclk/Baud = %0d cycles.", tclk, bit_time_cycles);
        $display("Expected clk_rx period = %0t ns", $realtime + EXPECTED_RX_PERIOD); 
        $display("Expected clk_tx period = %0t ns", $realtime + EXPECTED_TX_PERIOD);
        
        rst_n = 1'b1; 
        
        #10000000;
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
        $finish;
    end

    real t1_rx, t2_rx;
    real t1_tx, t2_tx;
    reg [8*4:1] rx_status;
    reg [8*4:1] tx_status;

    initial begin
        

        @(posedge rst_n);

        @(posedge clk_rx); 
        @(posedge clk_rx); t1_rx = $realtime;
        @(posedge clk_rx); t2_rx = $realtime;
        
        $display("--- CLK_RX ---");
        $display("Simulated clk_rx period = %0t ns", t2_rx - t1_rx);

        if ($abs(t2_rx - t1_rx - EXPECTED_RX_PERIOD) <= TOLERANCE) begin
            rx_status = "PASS";
        end else begin
            rx_status = "FAIL";
        end
        $display("CLK_RX CHECK: %s (Offset: %0t ns)", rx_status, $abs(t2_rx - t1_rx - EXPECTED_RX_PERIOD));

        @(posedge clk_tx); 
        @(posedge clk_tx); t1_tx = $realtime;
        @(posedge clk_tx); t2_tx = $realtime;
        
        $display("--- CLK_TX ---");
        $display("Simulated clk_tx period = %0t ns", t2_tx - t1_tx);

        if ($abs(t2_tx - t1_tx - EXPECTED_TX_PERIOD) <= TOLERANCE) begin
            tx_status = "PASS";
        end else begin
            tx_status = "FAIL";
        end
        $display("CLK_TX CHECK: %s (Offset: %0t ns)", tx_status, $abs(t2_tx - t1_tx - EXPECTED_TX_PERIOD));
        $display("------------------------------------");
    end

endmodule