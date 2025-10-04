module test_casex();
  reg [1:0] code;
  reg [7:0] control;

  always @(code) begin
    casex (code) // case expression
      2'b0?: control = 1;  // case item1
      2'b?1: control = 2;  // case item2
      2'b11: control = 3;  // case item3
    endcase
  end

  initial $monitor("%t: code = %b, control = %d", $time, code, control);

  initial begin
    #0  code = 2'b00;
    #5  code = 2'b01;
    #5  code = 2'b10;
    #5  code = 2'b11;
    #5  code = 2'b1x;
    #5  code = 2'b0x;
  end
endmodule
