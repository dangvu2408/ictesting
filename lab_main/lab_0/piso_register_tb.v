`timescale 1ns/1ps

module piso_register_tb;

    parameter n = 8;

    reg clk;
    reg rst;
    reg shift_load;
    reg serial_in;
    reg [n-1:0] parallel_in;
    wire serial_out;
    wire [n-1:0] q;

    piso_register #(.n(n)) uut (
        .clk(clk),
        .rst(rst),
        .shift_load(shift_load),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .serial_out(serial_out),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // T = 10 ns
    end

    initial begin
        rst = 1;
        shift_load = 0;
        serial_in = 0;
        parallel_in = 8'b00000000;
        #15;

        rst = 0;

        parallel_in = 8'b11010110;  
        shift_load = 0;             
        #10;                        

        shift_load = 1;             
        serial_in = 1'b0;           
        #100;                      

        $finish;
    end

    initial begin
        $monitor("Time=%0t | shift_load=%b | q=%b | serial_out=%b",
                  $time, shift_load, q, serial_out);
    end

endmodule
