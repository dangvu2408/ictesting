`timescale 1ns/1ps
module tb_pattern_1011_shift;
    reg clk, rst, bit_in;
    wire detect;

    pattern_1011_shift uut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .detect(detect)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        bit_in = 0;

        #10 rst = 0;

        #10 bit_in = 1;
        #10 bit_in = 1;
        #10 bit_in = 0;
        #10 bit_in = 1; 
        #10 bit_in = 0;
        #10 bit_in = 1;
        #10 bit_in = 1;
        #10 bit_in = 0;
        #10 bit_in = 1; 
        #10 bit_in = 1; 
        #10 bit_in = 0; 
        #10 bit_in = 1; 
        #10 bit_in = 0; 
        #10 bit_in = 1; 
        #10 bit_in = 1; 
        #10 bit_in = 0; 

        #20 $finish;
    end
endmodule
