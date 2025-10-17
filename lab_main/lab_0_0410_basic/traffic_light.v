`timescale 1ns/1ps
module traffic_light (
    input clk,
    input rst,
    output reg [2:0] light_h1, // {Red, Yellow, Green}
    output reg [2:0] light_h2  // {Red, Yellow, Green}
);

    localparam H1_GREEN  = 2'b00;
    localparam H1_YELLOW = 2'b01;
    localparam H2_GREEN  = 2'b10;
    localparam H2_YELLOW = 2'b11;

    localparam GREEN_TIME  = 20;
    localparam YELLOW_TIME = 3;

    reg [1:0] state;
    reg [5:0] counter; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= H1_GREEN;
            counter <= GREEN_TIME;
            light_h1 <= 3'b001; // H1 green
            light_h2 <= 3'b100; // H2 red
        end 
        else begin
            if (counter > 0)
                counter <= counter - 1;
            else begin
                case (state)
                    H1_GREEN: begin
                        state   <= H1_YELLOW;
                        counter <= YELLOW_TIME;
                        light_h1 <= 3'b010; // yellow
                        light_h2 <= 3'b100; // red
                    end

                    H1_YELLOW: begin
                        state   <= H2_GREEN;
                        counter <= GREEN_TIME;
                        light_h1 <= 3'b100; // red
                        light_h2 <= 3'b001; // green
                    end

                    H2_GREEN: begin
                        state   <= H2_YELLOW;
                        counter <= YELLOW_TIME;
                        light_h1 <= 3'b100; // red
                        light_h2 <= 3'b010; // yellow
                    end

                    H2_YELLOW: begin
                        state   <= H1_GREEN;
                        counter <= GREEN_TIME;
                        light_h1 <= 3'b001; // green
                        light_h2 <= 3'b100; // red
                    end

                    default: begin
                        state   <= H1_GREEN;
                        counter <= GREEN_TIME;
                        light_h1 <= 3'b001;
                        light_h2 <= 3'b100;
                    end
                endcase
            end
        end
    end

endmodule
