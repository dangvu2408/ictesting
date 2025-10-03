`timescale 1ns/1ps
module tb_parity;

  reg a, b, c, d;
  wire y;

  parity uut (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .y(y)
  );

  always @(*) begin
    $display("Time=%0t | a=%b b=%b c=%b d=%b | y=%b", $time, a, b, c, d, y);
  end

  initial begin
    a=0; b=0; c=0; d=0; #5;
    a=0; b=0; c=0; d=1; #5;
    a=0; b=0; c=1; d=0; #5;
    a=0; b=0; c=1; d=1; #5;
    a=0; b=1; c=0; d=0; #5;
    a=0; b=1; c=0; d=1; #5;
    a=0; b=1; c=1; d=0; #5;
    a=0; b=1; c=1; d=1; #5;
    a=1; b=0; c=0; d=0; #5;
    a=1; b=0; c=0; d=1; #5;
    a=1; b=0; c=1; d=0; #5;
    a=1; b=0; c=1; d=1; #5;
    a=1; b=1; c=0; d=0; #5;
    a=1; b=1; c=0; d=1; #5;
    a=1; b=1; c=1; d=0; #5;
    a=1; b=1; c=1; d=1; #5;

    $finish;
  end

endmodule
