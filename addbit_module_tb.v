`timescale 1ns/1ps

module tb_addbit_module;

  reg a, b, ci;
  wire sum, co;

  addbit_module uut (
    .a(a),
    .b(b),
    .ci(ci),
    .sum(sum),
    .co(co)
  );

  initial begin
    $display("a b ci | co sum");
    $display("---------------");

    a=0; b=0; ci=0; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=0; b=0; ci=1; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=0; b=1; ci=0; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=0; b=1; ci=1; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=1; b=0; ci=0; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=1; b=0; ci=1; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=1; b=1; ci=0; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);
    a=1; b=1; ci=1; #10 $display("%b %b  %b |  %b   %b", a,b,ci,co,sum);

    $finish;
  end

endmodule

