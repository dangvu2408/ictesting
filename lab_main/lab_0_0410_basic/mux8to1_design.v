module mux8to1_design (
  input  [7:0] d,    // input data 8 bits
  input  [2:0] sel,  // input select 3 bits
  output y           // output 1 bit
);

  assign y = (sel == 3'b000) ? d[0] :
             (sel == 3'b001) ? d[1] :
             (sel == 3'b010) ? d[2] :
             (sel == 3'b011) ? d[3] :
             (sel == 3'b100) ? d[4] :
             (sel == 3'b101) ? d[5] :
             (sel == 3'b110) ? d[6] :
                               d[7];
endmodule

`timescale 1ns/1ps

module tb_mux8to1_design;

  reg [7:0] d;
  reg [2:0] sel;
  wire y;

  mux8to1_design uut (
    .d(d),
    .sel(sel),
    .y(y)
  );

  initial begin
    $display("Time\t sel   d         | y");
    $display("-------------------------------");
    $monitor("%0dns\t%b   %b | %b", $time, sel, d, y);

    // Test
    d = 8'b1010_1101;  
    sel = 3'b000; #10;
    sel = 3'b001; #10;
    sel = 3'b010; #10;
    sel = 3'b011; #10;
    sel = 3'b100; #10;
    sel = 3'b101; #10;
    sel = 3'b110; #10;
    sel = 3'b111; #10;

    $finish;
  end

endmodule

