`timescale 1ns/1ps

module alu_32bit_tb;
  reg  [31:0] src1, src2;
  reg  [2:0]  alu_op;
  wire [31:0] res;
  wire        overflow;

  alu_32bit uut (
    .src1(src1),
    .src2(src2),
    .alu_op(alu_op),
    .res(res),
    .overflow(overflow)
  );

  localparam OP_ADD = 3'b000;
  localparam OP_AND = 3'b001;
  localparam OP_OR  = 3'b010;
  localparam OP_XOR = 3'b011;
  localparam OP_SUB = 3'b100;
  localparam OP_MUL = 3'b101;
  localparam OP_SLL = 3'b110;
  localparam OP_SRL = 3'b111;

  initial begin
    $dumpfile("alu_32bit_tb.vcd");
    $dumpvars(0, alu_32bit_tb);
    $wlfdumpvars;

    $display("Time\t alu_op\t src1\t\t src2\t\t res\t\t overflow");
    $display("-------------------------------------------------------------------");

    alu_op = 3'b000; src1 = 0; src2 = 0;
    #10;

    // ADD
    alu_op = OP_ADD; src1 = 32'd10; src2 = 32'd20; #10;
    $display("%4t\t ADD \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    alu_op = OP_ADD; src1 = 32'h7FFFFFFF; src2 = 32'd1; #10;
    $display("%4t\t ADD \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    // SUB
    alu_op = OP_SUB; src1 = 32'd50; src2 = 32'd20; #10;
    $display("%4t\t SUB \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    alu_op = OP_SUB; src1 = 32'h80000000; src2 = 32'd1; #10;
    $display("%4t\t SUB \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    // AND
    alu_op = OP_AND; src1 = 32'hF0F0F0F0; src2 = 32'h0FF00FF0; #10;
    $display("%4t\t AND \t %h\t %h\t %h\t %b", $time, src1, src2, res, overflow);

    // OR
    alu_op = OP_OR;  src1 = 32'hAAAA5555; src2 = 32'h0F0F0F0F; #10;
    $display("%4t\t OR  \t %h\t %h\t %h\t %b", $time, src1, src2, res, overflow);

    // XOR
    alu_op = OP_XOR; src1 = 32'h12345678; src2 = 32'h87654321; #10;
    $display("%4t\t XOR \t %h\t %h\t %h\t %b", $time, src1, src2, res, overflow);

    // MUL
    alu_op = OP_MUL; src1 = 32'd1000; src2 = 32'd2000; #15;
    $display("%4t\t MUL \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    alu_op = OP_MUL; src1 = 32'h40000000; src2 = 32'd4; #15;
    $display("%4t\t MUL \t %d\t %d\t %d\t %b", $time, src1, src2, res, overflow);

    // SHIFT LEFT
    alu_op = OP_SLL; src1 = 32'h00000001; src2 = 32'd8; #10;
    $display("%4t\t SLL \t %h\t %d\t %h\t %b", $time, src1, src2, res, overflow);

    // SHIFT RIGHT
    alu_op = OP_SRL; src1 = 32'h80000000; src2 = 32'd4; #10;
    $display("%4t\t SRL \t %h\t %d\t %h\t %b", $time, src1, src2, res, overflow);

    #20;
    $finish;
  end
endmodule
