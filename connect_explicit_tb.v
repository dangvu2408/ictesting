`timescale 1ns/1ps

module tb_connect_explicit();

  reg clk, d, rst, pre;
  wire q;

  connect_explicit uut (
    .clk(clk),
    .d(d),
    .rst(rst),
    .pre(pre),
    .q(q)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    d = 0; rst = 0; pre = 0;

    rst = 1; #12; 
    rst = 0;

    pre = 1; #12;
    pre = 0;

    d = 1; #20;
    d = 0; #20;
    d = 1; #20;

    #50 $finish;
  end

  initial begin
    $monitor("T=%0t | clk=%b rst=%b pre=%b d=%b -> q=%b", 
              $time, clk, rst, pre, d, q);
  end

endmodule
