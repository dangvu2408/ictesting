module asertion_14;
    bit a, b, c, d, e;
    bit clk;
    bit reset;

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        a <= 0; b <= 0; c <= 0; d <= 0; e <= 0;
        reset <= 1;
        @(posedge clk);
        a <= 1; b <= 1;
        @(posedge clk);
        c <= 1; 
        a <= 0; b <= 0;
        @(posedge clk);
        c <= 0;
        repeat(2) @(posedge clk);
        d <= 1; 
        repeat(4) @(posedge clk);
        e <= 1; 
        d <= 0;
        @(posedge clk);
        e <= 0;
        #20 $finish;
    end

    sequence seq_1;
        (a && b) ##1 c;
    endsequence

    sequence seq_2;
        d ##[4:6] e;
    endsequence

    property p;
        @(posedge clk) disable iff (reset) 
        seq_1.ended |-> ##2 seq_2.ended;
    endproperty

    a_1: assert property(p) $display("Assertion Passed at %t", $time);
         else $error("Assertion Failed at %t", $time);

    initial begin
        $dumpfile("ended_iff.vcd");
        $dumpvars(0, asertion_14);
    end
endmodule