`timescale 1ns/1ps

module tb_demux1to8;

  reg d;
  reg [2:0] sel;
  wire [7:0] y;

  demux1to8 uut (
    .d(d),
    .sel(sel),
    .y(y)
  );

  initial begin
    $display("Time\td sel | y");
    $display("-------------------------------------");
    $monitor("%0dns\t%b  %b  | %b", $time, d, sel, y);

    d = 0; sel = 3'b000; #10;
    d = 1; sel = 3'b000; #10;
    d = 1; sel = 3'b001; #10;
    d = 1; sel = 3'b010; #10;
    d = 1; sel = 3'b011; #10;
    d = 1; sel = 3'b100; #10;
    d = 1; sel = 3'b101; #10;
    d = 1; sel = 3'b110; #10;
    d = 1; sel = 3'b111; #10;

    $finish;
  end

endmodule
