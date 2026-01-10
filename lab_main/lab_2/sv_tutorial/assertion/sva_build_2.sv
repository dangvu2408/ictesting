module asertion_11;
    bit a;
    logic clk = 0;
    always #5 clk = ~clk;

    sequence s_a;
        @(posedge clk) $fell(a);
    endsequence

    assert property(s_a);

    
endmodule