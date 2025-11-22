`include "typedef_uart.sv"
module rx_uart #(parameter fclk = 50000000)(
    input clk,
    input rst,
    input rx_tx,
    input [1:0] baud,
    input parity_sel,
    output reg [7:0] data_out,
    output reg data_valid,
    output reg parity_out
);

reg [13:0] number_cycle;
reg [13:0] count_overlap;
reg [3:0] count_symbol;
reg [7:0] reg_rx;
reg parity_bit;
reg [2:0] state;

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
        state <= IDLE;
        count_overlap <= 0;
        count_symbol <= 0;
        reg_rx <= 0;
        parity_bit <= 0;
        data_valid <= 0;
        data_out <= 0;
        parity_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_valid <= 0;
                if (rx_tx == 0) begin
                    count_overlap <= 0;
                    state <= START;
                end
            end

            START: begin
                if (count_overlap < (number_cycle >> 1))
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    count_symbol <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
               
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    reg_rx <= {rx_tx, reg_rx[7:1]};
                    count_overlap <= 0;
                    
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
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    parity_bit <= rx_tx;
                    state <= STOP;
                end
            end

            STOP: begin
                if (count_overlap < number_cycle - 1)
                    count_overlap <= count_overlap + 1;
                else begin
                    count_overlap <= 0;
                    data_out <= reg_rx;
                    data_valid <= 1;
                    state <= IDLE;
                    parity_out <= parity_bit;
                end
            end
        endcase
    end
end

endmodule

