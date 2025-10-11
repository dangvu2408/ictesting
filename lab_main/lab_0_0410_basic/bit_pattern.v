module bit_pattern (
    input wire clk,
    input wire rst,
    input wire x,
    output reg y
);
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @(state or x or rst) begin
        if (rst)
            next_state = S0;
        else begin
            case (state)
                S0: if (x) next_state = S1; else next_state = S0;
                S1: if (x) next_state = S1; else next_state = S2;
                S2: if (x) next_state = S3; else next_state = S0;
                S3: if (x) next_state = S4; else next_state = S2;
                S4: if (x) next_state = S1; else next_state = S0;
                default: next_state = S0;
            endcase
        end
    end

    // (Moore)
    always @(posedge clk or posedge rst) begin
        if (rst)
            y <= 0;
        else
            y <= (state == S4);
    end
endmodule
