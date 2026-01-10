module asertion_13;
    bit a, b, c;
    bit clk;
    bit reset;

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        a = 0; b = 0; c = 0;
        #10 a = 1; b = 1;
        #10 b = 1; reset = 1;
        #10 b = 0;
        #10 b = 1;
        #10 b = 0;
        #10 b = 1;
        #10 c = 0;
        $finish;
    end

    property p_go_to;
        @(posedge clk) a |-> ##1 b[->3] ##1 c;
    endproperty

    a_1: assert property(p_go_to);

    initial begin
        $dumpfile("go_to.vcd");
        $dumpvars;
    end
endmodule