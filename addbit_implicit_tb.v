`timescale 1ns/1ps

module tb_adder_implicit;

  // Khai báo tín hiệu
  reg  [3:0] r1;
  reg  [3:0] r2;
  reg        ci;
  wire [3:0] result;
  wire       carry;

  // Gọi DUT (Design Under Test)
  adder_implicit uut (
    .result(result),
    .carry(carry),
    .r1(r1),
    .r2(r2),
    .ci(ci)
  );

  // Test các trường hợp
  initial begin
    $display("Time |   r1   r2  ci | carry result");
    $display("-----------------------------------");

    // thử vài case
    r1 = 4'b0000; r2 = 4'b0000; ci = 0; #10;
    $display("%4t | %b %b  %b |   %b     %b",$time,r1,r2,ci,carry,result);

    r1 = 4'b0011; r2 = 4'b0101; ci = 0; #10;
    $display("%4t | %b %b  %b |   %b     %b",$time,r1,r2,ci,carry,result);

    r1 = 4'b1111; r2 = 4'b0001; ci = 0; #10;
    $display("%4t | %b %b  %b |   %b     %b",$time,r1,r2,ci,carry,result);

    r1 = 4'b1010; r2 = 4'b0101; ci = 1; #10;
    $display("%4t | %b %b  %b |   %b     %b",$time,r1,r2,ci,carry,result);

    r1 = 4'b1111; r2 = 4'b1111; ci = 1; #10;
    $display("%4t | %b %b  %b |   %b     %b",$time,r1,r2,ci,carry,result);

    $finish;
  end

endmodule

