`timescale 1ns/1ps

module tb_addbit1;

  reg a;
  reg b;
  reg ci;
  wire sum;
  wire co;

  addbit1 uut (
    .a(a),
    .b(b),
    .ci(ci),
    .sum(sum),
    .co(co)
  );

  initial begin
    $display("Time\ta b ci | sum co");
    $monitor("%0dns\t%b %b %b | %b   %b", $time, a, b, ci, sum, co);

    a = 0; b = 0; ci = 0; #10;
    a = 0; b = 0; ci = 1; #10;
    a = 0; b = 1; ci = 0; #10;
    a = 0; b = 1; ci = 1; #10;
    a = 1; b = 0; ci = 0; #10;
    a = 1; b = 0; ci = 1; #10;
    a = 1; b = 1; ci = 0; #10;
    a = 1; b = 1; ci = 1; #10;

    $finish;
  end

endmodule


