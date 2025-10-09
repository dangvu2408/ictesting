module majority_8bit (
  input  [7:0] a,
  output reg y
);
  integer count;

  always @(a[0] or a[1] or a[2] or a[3] or a[4] or a[5] or a[6] or a[7]) begin
    count = a[0] + a[1] + a[2] + a[3] + a[4] + a[5] + a[6] + a[7];
    y = (count >= 4);
  end
endmodule

