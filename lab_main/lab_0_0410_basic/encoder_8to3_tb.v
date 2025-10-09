`timescale 1ns / 1ps
module encoder8to3_tb;

  reg  [7:0] d;
  wire [2:0] y;

  encoder8to3 uut (
    .d(d),
    .y(y)
  );

  initial begin
    $display("Time | d         | y");
    $monitor("%4t | %b | %b", $time, d, y);

    d = 8'b0000_0001; #10;
    d = 8'b0000_0010; #10;
    d = 8'b0000_0100; #10;
    d = 8'b0000_1000; #10;
    d = 8'b0001_0000; #10;
    d = 8'b0010_0000; #10;
    d = 8'b0100_0000; #10;
    d = 8'b1000_0000; #10;

    d = 8'b0000_0011; #10;
    d = 8'b0000_0000; #10;

    $finish;
  end

endmodule
