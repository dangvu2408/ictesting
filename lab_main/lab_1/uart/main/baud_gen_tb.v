`timescale 1ns/1ps

module baud_gen_tb;

    reg         clk;
    reg         rst_b;
    reg  [2:0]  Sel_Baud_Rate;
    wire        Clock;
    wire        Sample_clk;

    baud_gen uut (
        .Clock(Clock),
        .Sample_clk(Sample_clk),
        .Sel_Baud_Rate(Sel_Baud_Rate),
        .clk(clk),
        .rst_b(rst_b)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin

        rst_b = 0;
        Sel_Baud_Rate = 3'b001;
        #100;

        rst_b = 1;
        $display("[%0t] Release reset", $time);

        repeat (7) begin
            #50000; 
            Sel_Baud_Rate = Sel_Baud_Rate + 1;
            $display("[%0t] Change baud rate to %b", $time, Sel_Baud_Rate);
        end

        #50000;
        $finish;
    end

    initial begin
        $display("Time\t\tSel Baud\tSample_clk\tClock");
        forever begin
            @(posedge Sample_clk);
            $display("[%0t]\t%b\t\t1\t%d", $time, Sel_Baud_Rate, Clock);
        end
    end

endmodule
