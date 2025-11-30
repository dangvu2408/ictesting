`timescale 1ns/1ps
module pattern_1011_shift (
    input clk,
    input rst,
    input bit_in,
    output reg detect
);
    reg [3:0] shift_reg; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
        shift_reg <= 4'b0000;
            detect <= 1'b0;
        end
        else begin
            shift_reg <= {shift_reg[2:0], bit_in};
            if (shift_reg == 4'b1011)
                detect <= 1'b1;
            else
                detect <= 1'b0;
        end
    end
endmodule
