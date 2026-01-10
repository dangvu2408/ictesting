module asertion_12;
    bit a;
    logic clk = 0;
    always #5 clk = ~clk;

    sequence s_a;
        @(posedge clk) $stable(a);
    endsequence

    assert property(s_a);

    
endmodule