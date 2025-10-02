`timescale 1ns/1ps

module tb_1dff;

  // reg cho input
  reg d;
  reg cl$k;
  reg \reset* ;  // escape name (có khoảng trắng sau *)

  // wire cho output
  wire q;
  wire \q~ ;     // escape name (có khoảng trắng sau ~)

  // Instance module \1dff
  \1dff uut (
    .d(d),
    .cl$k(cl$k),
    .\reset* (\reset* ),  // phải có khoảng trắng
    .q(q),
    .\q~ (\q~ )
  );

  // Tạo clock
  initial begin
    cl$k = 0;
    forever #5 cl$k = ~cl$k;  // chu kỳ 10ns
  end

  // Kịch bản mô phỏng
  initial begin
    d = 0;
    \reset* = 1;   // reset không kích hoạt
    #12;

    \reset* = 0; #10;
    \reset* = 1; #10;

    d = 1; #20;
    d = 0; #20;
    d = 1; #20;

    $finish;
  end

  // In kết quả
  initial begin
    $display("Time | reset d clk | q q~");
    $monitor("%4t |   %b    %b   %b  | %b %b", 
             $time, \reset* , d, cl$k, q, \q~ );
  end

endmodule