module asertion_variable_delay;
    bit clk, a, b;
    int cfg_delay;

    initial clk = 0;
    always #5 clk = ~clk; 
    initial begin
        cfg_delay = 4;
        a = 1; b = 0;
        #15 a = 0; b = 1;
        #10 a = 1;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10;
        $finish;
    end

    sequence delay_seq(v_delay);
        int delay;
        (1, delay = v_delay) ##0
        first_match((1, delay = delay - 1)[*0:$]) ##0
        delay <= 0;
    endsequence

    a_1: assert property (@(posedge clk) a |-> delay_seq(cfg_delay) |-> b);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
