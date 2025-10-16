
module mux_2to1(
    input a,        
    input b,        
    input sel,      
    output y        
);
    assign y = (sel) ? b : a;
endmodule

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

module piso_register #(
    parameter n = 8
)(
    input clk,
    input rst,
    input shift_load,           
    input serial_in,            
    input [n-1:0] parallel_in,  
    output serial_out,          
    output [n-1:0] q            
);
    wire [n-1:0] d_in; 

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : bit_slice
            wire shift_source;

            if (i == 0)
                assign shift_source = serial_in;     
            else
                assign shift_source = q[i-1];        

            mux_2to1 u_mux (
                .a(parallel_in[i]),
                .b(shift_source),
                .sel(shift_load),
                .y(d_in[i])
            );

            dflipflops u_dff (
                .clk(clk),
                .rst(rst),
                .d(d_in[i]),
                .q(q[i])
            );
        end
    endgenerate

    assign serial_out = q[n-1];

endmodule
