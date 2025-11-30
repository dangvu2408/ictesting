module dti_updown_count #(
    parameter COUNT_WIDTH = 8
)(
    input                        clk,
    input                        reset_n,
    input  [COUNT_WIDTH-1:0]     count_to,
    input                        count_inc,
    input                        count_dec,
    output                       flag_count_max,
    output                       flag_count_min,
    output reg [COUNT_WIDTH-1:0] count
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end
        else begin
            case ({count_inc, count_dec})
                2'b00: count <= count;
                2'b01: if (count > 0) count <= count - 1;
                2'b10: if (count < count_to) count <= count + 1;
                2'b11: count <= count;
            endcase
        end
    end

    assign flag_count_min = (count == 0);
    assign flag_count_max = (count == count_to);

endmodule