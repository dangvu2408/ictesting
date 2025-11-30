module shift_register_piso #(
    parameter n = 8         
)(
    input clk,              
    input rst,              
    input shift_load,       
    input serial_in,        
    input [n-1:0] parallel_in, 
    output reg serial_out,  
    output reg [n-1:0] q    
);

    integer i;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0;
            serial_out <= 0;
        end 
        else begin
            if (shift_load == 1'b0) begin
                q <= parallel_in;
            end 
            else begin
                serial_out <= q[n-1];  
                for (i = n-1; i > 0; i = i - 1) begin
                    q[i] <= q[i-1];
                end
                q[0] <= serial_in;
            end
        end
    end

endmodule
