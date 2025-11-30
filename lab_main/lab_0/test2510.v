
module test2510 (
    input  wire        clk,
    input  wire [3:0]  C,
    input  wire [3:0]  D,
    output wire [3:0]  E
);

    reg [3:0] A, B;

    always @(posedge clk) begin
        A <= C & D;   
        B <= C | D;  
    end

    assign E = A + B;

endmodule
