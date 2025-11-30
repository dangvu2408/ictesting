module Baud_gen #(parameter fclk = 5000000) ( 
    input       clk,
    input       rst_n,
    input [2:0] sel_baud_rate,
    output wire clk_tx,
    output wire clk_rx
);
    
    localparam baud_4800   = fclk/4800;
    localparam baud_9600   = fclk/9600;
    localparam baud_19200  = fclk/19200;
    localparam baud_38400  = fclk/38400;
    localparam baud_57600  = fclk/57600;
    localparam baud_115200 = fclk/115200;

    reg [15:0] bit_time;
    reg [11:0] clk_rx_period;
    reg [6:0] rx_counter;
    reg [1:0] tx_clk_rx_counter;
    
    reg clk_tx_reg;
    reg clk_rx_reg;

    assign clk_tx = clk_tx_reg;
    assign clk_rx = clk_rx_reg;

    always @(sel_baud_rate) begin 
        case (sel_baud_rate)
            3'b000: bit_time = baud_4800;
            3'b001: bit_time = baud_9600;
            3'b010: bit_time = baud_19200;
            3'b011: bit_time = baud_38400;
            3'b100: bit_time = baud_57600;
            3'b101: bit_time = baud_115200;
            default: bit_time = baud_9600;
        endcase

        if (bit_time < 16)
            clk_rx_period = 2; 
        else
            clk_rx_period = bit_time / 8; 
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_counter <= 7'd0;
            clk_rx_reg <= 1'b0;
        end else begin
            if (rx_counter == (clk_rx_period >> 1) - 1) begin
                clk_rx_reg <= ~clk_rx_reg; 
                rx_counter <= 7'd0; 
            end else begin
                rx_counter <= rx_counter + 1'b1;
            end
        end
    end

    always @(posedge clk_rx or negedge rst_n) begin
        if (!rst_n) begin
            tx_clk_rx_counter <= 2'd0;
            clk_tx_reg <= 1'b0;
        end else begin
            if (tx_clk_rx_counter == 2'd3) begin 
                clk_tx_reg <= ~clk_tx_reg;
                tx_clk_rx_counter <= 2'd0;
            end else begin
                tx_clk_rx_counter <= tx_clk_rx_counter + 1'b1;
            end
        end
    end

endmodule