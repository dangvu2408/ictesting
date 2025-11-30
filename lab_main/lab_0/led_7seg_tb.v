`timescale 1ns / 1ps

module tb_led_7seg;

    reg [3:0] bcd;
    wire [6:0] seg;

    led_7seg uut (
        .bcd(bcd),
        .seg(seg)
    );

    initial begin
        $display("=== Testbench for LED 7-segment (Common Cathode) ===");
        $display("Time\tBCD\tSeg(a-g)");

        bcd = 4'b0000;
        repeat (16) begin
            #10;
            $display("%0t\t%b\t%b", $time, bcd, seg);
            bcd = bcd + 1;
        end

        #10;
        $display("=== Test finished ===");
        $finish;
    end

endmodule
