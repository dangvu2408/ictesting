`timescale 1ns/1ps

module dti_seq_dect_fsm (
    input        clk,
    input        rst,   
    input        s_in,      
    input        load_en,   
    input  [3:0] ref_patt,  
    output reg   detect
);

    localparam S0 = 3'd0; 
    localparam S1 = 3'd1; 
    localparam S2 = 3'd2; 
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] ref_reg; 

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state   <= S0;
            ref_reg <= 4'b0000;
            detect <= 1'b0;
        end
        else begin
            if (load_en) begin
                ref_reg <= ref_patt;
            end

            case (state)
                S0: begin
                    if (s_in == ref_reg[3]) next_state = S1; else next_state = S0;
                    detect <= 1'b0;
                end

                S1: begin
                    if (s_in == ref_reg[2]) next_state = S2;
                    else if (s_in == ref_reg[3]) next_state = S1;
                    else next_state = S0;
                    detect <= 1'b0;
                end

                S2: begin
                    if (s_in == ref_reg[1]) next_state = S3;
                    else if (s_in == ref_reg[3]) next_state = S1;
                    else next_state = S0;
                    detect <= 1'b0;
                end

                S3: begin
                    if (s_in == ref_reg[0]) next_state = S4;
                    else if (s_in == ref_reg[3]) next_state = S1;
                    else next_state = S0;
                    detect <= 1'b0;
                end

                S4: begin
                    detect <= 1'b1;
                    if (s_in == ref_reg[3]) next_state = S1;
                    else next_state = S0;
                end

                default: begin
                    next_state = S0;
                    detect <= 1'b0;
                end
            endcase

            state <= next_state;
        end
    end

endmodule
