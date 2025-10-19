module full_adder (
    input a, b, ci;
    output s, co;
);
    assign s = a ^ b ^ ci;
    assign co = (a & ci) | (b & ci) | (a & b);
endmodule

module adder4bits (
    input [3:0] a, b;
    input ci;
    output [3:0] s;
    output co
);


    wire c0, c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]), .co(c0));
    full_adder fa1 (.a(a[1]), .b(b[1]), .ci(c0), .s(s[1]), .co(c1));
    full_adder fa2 (.a(a[2]), .b(b[2]), .ci(c1), .s(s[2]), .co(c2));
    full_adder fa3 (.a(a[3]), .b(b[3]), .ci(c2), .s(s[3]), .co(c3));
    assign co = c3;


endmodule