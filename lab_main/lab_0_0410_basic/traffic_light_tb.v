`timescale 1ns/1ps
module tb_traffic_light;
    reg clk, rst;
    wire [2:0] light_h1, light_h2;

    traffic_light uut (
        .clk(clk),
        .rst(rst),
        .light_h1(light_h1),
        .light_h2(light_h2)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0; 
        rst = 1;
        #5 rst = 0;

        #200 $finish;
    end

    reg [2:0] last_h1, last_h2;
    initial begin
        $display("TIME\tH1\tH2");
        $display("--------------------");
        last_h1 = 3'bxxx;
        last_h2 = 3'bxxx;
        forever begin
            #1;
            if (light_h1 !== last_h1 || light_h2 !== last_h2) begin
                $display("%4dns\t%s\t%s", 
                    $time, 
                    decode_light(light_h1), 
                    decode_light(light_h2)
                );
                last_h1 = light_h1;
                last_h2 = light_h2;
            end
        end
    end

    function [31*8:1] decode_light(input [2:0] light);
        begin
            case (light)
                3'b100: decode_light = "RED   ";
                3'b010: decode_light = "YELLOW";
                3'b001: decode_light = "GREEN ";
                default: decode_light = "OFF   ";
            endcase
        end
    endfunction

endmodule
