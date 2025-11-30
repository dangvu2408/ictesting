module bit_pattern_tb;
    reg clk, rst, x;
    wire y;

    bit_pattern uut(clk, rst, x, y);

    // Clock 10ns
    always #5 clk = ~clk;

    initial begin
        $display("time | x | state | y");

        clk = 0; rst = 1; x = 0;
        #10 rst = 0;

        // bit: 1 0 1 1 0 1 0 1 1
        #10 x=1;
        #10 x=0;
        #10 x=1;
        #10 x=1;
        #10 x=0;
        #10 x=1;
        #10 x=0;
        #10 x=1;
        #10 x=1;
        #20 $finish;
    end

    always @(posedge clk)
        $display("%4t | %b | %b | %b", $time, x, uut.state, y);
endmodule
