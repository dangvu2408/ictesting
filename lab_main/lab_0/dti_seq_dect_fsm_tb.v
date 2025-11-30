`timescale 1ns/1ps

module tb_dti_seq_dect_fsm;
    reg clk, rst;
    reg s_in;
    reg load_en;
    reg [3:0] ref_patt;
    wire detect;

    dti_seq_dect_fsm uut (
        .clk(clk),
        .rst(rst),
        .s_in(s_in),
        .load_en(load_en),
        .ref_patt(ref_patt),
        .detect(detect)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    always @(posedge clk) begin
        $display("Time=%0t ns | s_in=%b | detected=%b | ref_patt=%b | load_en=%b | reset_n=%b",
                 $time, s_in, detect, ref_patt, load_en, rst);
        if (detect)
            $display(">>> Pattern detected at time %0t ns!", $time);
    end

    initial begin
        $display("=== Simulation Start ===");

        rst = 0;
        s_in = 0;
        load_en = 0;
        ref_patt = 4'b0000;
        #10;

        rst = 1;  

        load_en = 1;
        ref_patt = 4'b1011;
        #10;
        load_en = 0;

        s_in = 1; #10;
        s_in = 0; #10;
        s_in = 1; #10;
        s_in = 1; #10;   
        s_in = 0; #10;
        s_in = 1; #10;
        s_in = 1; #10;   
        s_in = 0; #10;
        s_in = 1; #10;
        s_in = 1; #10;   
        s_in = 0; #10;
        s_in = 0; #10;
        s_in = 1; #10;

        load_en = 1;
        ref_patt = 4'b1101;
        #10;
        load_en = 0;

        s_in = 1; #10;
        s_in = 1; #10;
        s_in = 0; #10;
        s_in = 1; #10;   
        s_in = 1; #10;
        s_in = 1; #10;   
        s_in = 0; #10;
        s_in = 1; #10;
        s_in = 1; #10;   
        s_in = 0; #10;
        s_in = 0; #10;
        s_in = 1; #10;
        
        #20;
        $display("=== Simulation finished at %0t ns ===", $time);
        $finish;
    end
endmodule
