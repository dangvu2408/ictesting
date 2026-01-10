module asertion_10;
    bit a;
    logic clk = 0;
    always #5 clk = ~clk;

    sequence s_a;
        @(posedge clk) $rose(a);
    endsequence

    assert property(s_a);


endmodule