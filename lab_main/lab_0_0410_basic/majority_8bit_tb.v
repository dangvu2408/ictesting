`timescale 1ns/1ps

module majority_8bit_tb;
  reg [7:0] a;
  wire y;

  majority_8bit uut (
    .a(a),
    .y(y)
  );

  integer i;
  integer count_ones;

  initial begin
    $display("Time\t a\t\t y\t (Expected)");
    $display("-------------------------------------");

    for (i = 0; i < 256; i = i + 1) begin
      a = i;
      #10
      count_ones = a[0] + a[1] + a[2] + a[3] + a[4] + a[5] + a[6] + a[7];
      $display("%4t\t%b\t %b\t (%b)", $time, a, y, (count_ones >= 4));

    end

    $finish;
  end
endmodule
