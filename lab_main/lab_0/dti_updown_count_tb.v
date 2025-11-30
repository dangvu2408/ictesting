`timescale 1ns/1ps

module tb_dti_updown_count;
    parameter COUNT_WIDTH = 8;

    reg clk;
    reg reset_n;
    reg [COUNT_WIDTH-1:0] count_to;
    reg count_inc;
    reg count_dec;
    wire flag_count_max;
    wire flag_count_min;
    wire [COUNT_WIDTH-1:0] count;

    dti_updown_count #(
        .COUNT_WIDTH(COUNT_WIDTH)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .count_to(count_to),
        .count_inc(count_inc),
        .count_dec(count_dec),
        .flag_count_max(flag_count_max),
        .flag_count_min(flag_count_min),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    always @(posedge clk) begin
        $display("Time=%0t ns | count=%0d | inc=%b | dec=%b | max=%b | min=%b | count_to=%0d",
                 $time, count, count_inc, count_dec, flag_count_max, flag_count_min, count_to);
    end

    initial begin
        $dumpfile("updown_counter.vcd");
        $dumpvars(0, tb_dti_updown_count);

        reset_n = 0;
        count_inc = 0;
        count_dec = 0;
        count_to  = 8'd10;
        #20;
        reset_n = 1;  
        #10;

        $display("=== TEST 1: COUNT UP ===");
        count_inc = 1;
        repeat (12) @(posedge clk);
        count_inc = 0;
        #20;

        $display("=== TEST 2: COUNT DOWN ===");
        count_dec = 1;
        repeat (5) @(posedge clk);
        count_dec = 0;
        #20;

        $display("=== TEST 3: INC + DEC ACTIVE ===");
        count_inc = 1;
        count_dec = 1;
        repeat (5) @(posedge clk);
        count_inc = 0;
        count_dec = 0;
        #20;

        $display("=== TEST 4: RESET MID-RUN ===");
        count_inc = 1;
        repeat (5) @(posedge clk);
        reset_n = 0; #10;
        reset_n = 1; #10;
        count_inc = 0;

        #50;
        $display("Simulation finished at %0t ns", $time);
        $finish;
    end
endmodule
