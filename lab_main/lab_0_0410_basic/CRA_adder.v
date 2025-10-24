module full_adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module CRA_adder #(
parameter N = 4
)(
input wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire Cin,
    output wire [N-1:0] Sum,
    output wire Cout
);
    wire [N:0] C;
    assign C[0] = Cin;
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : full_adder_stage
            full_adder FA (
                .a (A[i]),
                .b (B[i]),
                .cin (C[i]),
                .sum (Sum[i]),
                .cout(C[i+1])
            );
        end
    endgenerate
    assign Cout = C[N]; 
endmodule
