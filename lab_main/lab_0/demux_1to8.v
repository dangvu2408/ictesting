module demux_1to8 (
  input       d,         // input data
  input [2:0] sel,       // input select
  output [7:0] y         // 8 bits output
);

  assign y[0] = (sel == 3'b000) ? d : 1'b0;
  assign y[1] = (sel == 3'b001) ? d : 1'b0;
  assign y[2] = (sel == 3'b010) ? d : 1'b0;
  assign y[3] = (sel == 3'b011) ? d : 1'b0;
  assign y[4] = (sel == 3'b100) ? d : 1'b0;
  assign y[5] = (sel == 3'b101) ? d : 1'b0;
  assign y[6] = (sel == 3'b110) ? d : 1'b0;
  assign y[7] = (sel == 3'b111) ? d : 1'b0;

endmodule
