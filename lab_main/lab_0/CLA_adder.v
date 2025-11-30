module bit_adder_cla (
    input  a,
    input  b,
    input  cin,
    output p,
    output g, 
    output s 
);
    assign p = a ^ b;
    assign g = a & b;
    assign s = p ^ cin;
endmodule

module cla_logic (
    input  [3:0] p,
    input  [3:0] g,
    input        cin,
    output [4:1] c 
);
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) |
                  (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
endmodule

module CLA_adder #(parameter N = 4)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    input           cin,
    output [N-1:0] sum,
    output          cout
);
    wire [N-1:0] p, g;
    wire [N:1]   c;

    cla_logic CLA_LOGIC (
        .p(p),
        .g(g),
        .cin(cin),
        .c(c)
    );

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_block
            if (i == 0)
                bit_adder_cla ADD (.a(a[i]), .b(b[i]), .cin(cin),  .p(p[i]), .g(g[i]), .s(sum[i]));
            else
                bit_adder_cla ADD (.a(a[i]), .b(b[i]), .cin(c[i]), .p(p[i]), .g(g[i]), .s(sum[i]));
        end
    endgenerate

    assign cout = c[N];
endmodule