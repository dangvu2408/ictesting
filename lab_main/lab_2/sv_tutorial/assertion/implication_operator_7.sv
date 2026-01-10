`timescale 1ns/1ps
module asertion_ex07;
    logic a, b;
    logic clk = 0;
    always #5 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(negedge clk);
            a = $random();
            b = $random();
        end
    end

    property p;
        @(posedge clk) a |-> b[=3]; // here
    endproperty

    a_1: assert property(p);

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        #500000; $finish;
    end
endmodule
