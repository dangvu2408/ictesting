`timescale 1ns/1ps

module tb_sipo_register;
    parameter n = 8;

    reg clk;
    reg rst;
    reg serial_in;
    wire [n-1:0] q;

    sipo_register #(.n(n)) uut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   
    end

    initial begin
        rst = 1;
        serial_in = 0;
        #12;
        rst = 0;

        #10 serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 0;

        #40;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | serial_in=%b | q=%b", $time, serial_in, q);
    end
endmodule
