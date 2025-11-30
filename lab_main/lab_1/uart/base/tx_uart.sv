`include "typedef_uart.sv"
module tx_uart #(parameter fclk = 50000000)(
    input clk,
    input rst,
    input [7:0] data_in,
    input ready_trans,
    input [1:0] baud,
    output reg tx_rx,         
    input parity_sel
);

reg [13:0] number_cycle;
reg [7:0]  reg_tx;
reg        parity_bit;
reg [13:0] count_overlap;
reg [3:0]  count_symbol;
reg [2:0]  state;

always @(baud) begin
    case (baud)
        2'b00: number_cycle = fclk / 4800;
        2'b01: number_cycle = fclk / 9600;
        2'b10: number_cycle = fclk / 19200;
        2'b11: number_cycle = fclk / 38400;
        default: number_cycle = fclk / 9600;
    endcase
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        reg_tx <= 8'b0;
        count_overlap <= 0;
        count_symbol <= 0;
        tx_rx <= 1'b1;
        parity_bit <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                tx_rx <= 1'b1;
                if (ready_trans) begin
                    reg_tx <= data_in;
                    parity_bit <= ^data_in;
                    count_overlap <= 0;
                    count_symbol <= 0;
                    state <= START;
                end
            end

            START: begin
                tx_rx <= 1'b0;
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
                tx_rx <= reg_tx[0];
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    
                    reg_tx <= reg_tx >> 1;
                    count_symbol <= count_symbol + 1;
                    if (count_symbol == 7) begin
                        if (parity_sel)
                            state <= PARITY;
                        else
                            state <= STOP;
                    end
                end
            end

            PARITY: begin
                tx_rx <= parity_bit;
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    state <= STOP;
                end
            end

            STOP: begin
                tx_rx <= 1'b1;
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
