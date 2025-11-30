module dflipflops(
    input clk,
    input rst,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule


module sipo_register #(
    parameter n = 8      
)(
    input clk,
    input rst,
    input serial_in,     
    output [n-1:0] q     
);

    wire [n-1:0] d;      

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : sipo_bits
            if (i == 0) begin
                dflipflops dff (
                    .clk(clk),
                    .rst(rst),
                    .d(serial_in),
                    .q(d[i])
                );
            end else begin
                dflipflops dff (
                    .clk(clk),
                    .rst(rst),
                    .d(d[i-1]),
                    .q(d[i])
                );
            end
        end
    endgenerate

    assign q = d; 

endmodule
