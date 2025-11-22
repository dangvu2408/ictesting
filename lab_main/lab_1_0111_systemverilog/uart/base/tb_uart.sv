`timescale 1ns/1ps
`include "tx_uart.sv"
`include "rx_uart.sv"
module tb_uart_full_duplex;

  reg clk, rst;
  reg [7:0] data1_in, data2_in;
  reg ready1_trans, ready2_trans;
  reg [1:0] baud;
  reg parity_sel;
  wire tx1, tx2;
  wire [7:0] data1_out, data2_out;
  wire valid1, valid2;
  wire parity_out1, parity_out2;

  
  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  
  tx_uart tx1_inst (
    .clk(clk), .rst(rst),
    .data_in(data1_in),
    .ready_trans(ready1_trans),
    .baud(baud),
    .parity_sel(parity_sel),
    .tx_rx(tx1)
  );

  tx_uart tx2_inst (
    .clk(clk), .rst(rst),
    .data_in(data2_in),
    .ready_trans(ready2_trans),
    .baud(baud),
    .parity_sel(parity_sel),
    .tx_rx(tx2)
  );

  rx_uart rx1_inst (
    .clk(clk), .rst(rst),
    .rx_tx(tx2),
    .baud(baud),
    .parity_sel(parity_sel),
    .data_out(data1_out),
    .data_valid(valid1),
    .parity_out(parity_out1)
  );

  rx_uart rx2_inst (
    .clk(clk), .rst(rst),
    .rx_tx(tx1),
    .baud(baud),
    .parity_sel(parity_sel),
    .data_out(data2_out),
    .data_valid(valid2),
    .parity_out(parity_out2)
  );

  
  initial begin
    $display("===== START SIMULATION =====");
    $monitor("T=%0t | data1_in=%h data2_in=%h | data1_out=%h v1=%b | data2_out=%h v2=%b",
             $time, data1_in, data2_in, data1_out, valid1, data2_out, valid2);
  end

 
  initial begin
    rst = 0;
    baud = 2'b01;
    parity_sel = 1;
    ready1_trans = 0;
    ready2_trans = 0;
    data1_in = 8'h00;
    data2_in = 8'h00;

    #100 rst = 1;

    
    #1000 data1_in = 8'h55; ready1_trans = 1;
    #20 ready1_trans = 0;

    #2000 data2_in = 8'hF0; ready2_trans = 1;
    #20 ready2_trans = 0;

    #10000000 data1_in = 8'hA5; ready1_trans = 1;
    #20 ready1_trans = 0;

    #50 data2_in = 8'h8B; ready2_trans = 1;
    #20 ready2_trans = 0;

    #1000000000;
    $display("===== END SIMULATION =====");
    $finish;
  end

endmodule

