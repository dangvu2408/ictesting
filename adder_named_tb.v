`timescale 1ns/1ps

module tb_adder_named;

  reg  [3:0] r1, r2;
  reg        ci;
  wire [3:0] result;
  wire       carry;

  // DUT
  adder_named dut (
    .result(result),
    .carry (carry),
    .r1    (r1),
    .r2    (r2),
    .ci    (ci)
  );

  initial begin
    // Case 1
    r1 = 4'b0011; r2 = 4'b0101; ci = 0;
    #10 $display("r1=%b r2=%b ci=%b -> result=%b carry=%b", r1, r2, ci, result, carry);

    // Case 2
    r1 = 4'b1111; r2 = 4'b0001; ci = 0;
    #10 $display("r1=%b r2=%b ci=%b -> result=%b carry=%b", r1, r2, ci, result, carry);

    // Case 3
    r1 = 4'b1010; r2 = 4'b0101; ci = 1;
    #10 $display("r1=%b r2=%b ci=%b -> result=%b carry=%b", r1, r2, ci, result, carry);

    #10 $finish;
  end

endmodule

