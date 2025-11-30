`timescale 1ns / 1ps
module decoder3to8_tb;

  reg  [2:0] a;      // in
  wire [7:0] y;      // out

  decoder3to8 uut (
    .a(a),
    .y(y)
  );

  initial begin
    $display("Time | a   | y");
    $monitor("%4t | %b | %b", $time, a, y);

    a = 3'b000; #10;
    a = 3'b001; #10;
    a = 3'b010; #10;
    a = 3'b011; #10;
    a = 3'b100; #10;
    a = 3'b101; #10;
    a = 3'b110; #10;
    a = 3'b111; #10;

    $finish;
  end

endmodule
