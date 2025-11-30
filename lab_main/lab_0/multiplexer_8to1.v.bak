module mux8to1 (
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
