module baud_gen (
    output reg   Clock,
    output reg   Sample_clk,
    input  [2:0] Sel_Baud_Rate,
    input        clk, 
    input        rst_b
);

    reg [15:0] div_16x;

    always @(Sel_Baud_Rate) begin
        case (Sel_Baud_Rate)
            3'b000:  div_16x = 5000000 / (4800   * 16);  
            3'b001:  div_16x = 5000000 / (9600   * 16);
            3'b010:  div_16x = 5000000 / (19200  * 16);
            3'b011:  div_16x = 5000000 / (38400  * 16);
            3'b100:  div_16x = 5000000 / (57600  * 16);
            3'b101:  div_16x = 5000000 / (115200 * 16);
            default: div_16x = 5000000 / (9600   * 16);
        endcase
    end

    reg [15:0] cnt_16x;

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            cnt_16x     <= 0;
            Sample_clk  <= 0;
        end else begin
            if (cnt_16x == div_16x - 1) begin
                cnt_16x    <= 0;
                Sample_clk <= 1;
            end else begin
                cnt_16x    <= cnt_16x + 1;
                Sample_clk <= 0;
            end
        end
    end

    reg [3:0] sample_cnt;

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            sample_cnt <= 0;
            Clock      <= 0;
        end else begin
            if (Sample_clk) begin
                if (sample_cnt == 15) begin
                    sample_cnt <= 0;
                    Clock      <= 1; 
                end else begin
                    sample_cnt <= sample_cnt + 1;
                    Clock      <= 0;
                end
            end else begin
                Clock <= 0;
            end
        end
    end

endmodule
