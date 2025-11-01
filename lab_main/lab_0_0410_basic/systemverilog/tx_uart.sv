module tx_uart #(parameter fclk = 5000000) (
    input txd,
    input clk,
    input rst_n,
    input [7:0] data_in,
    input di_rdy,
    input [2:0] baud,
    input parity
);

reg [13:0] baud_cycle;
always @(baud)
    begin 
        case (baud)
            0: baud_cycle = fclk/4800;
            1: baud_cycle = fclk/9600;
            2: baud_cycle = fclk/19200;
            3: baud_cycle = fclk/38400;
            4: baud_cycle = fclk/57600;
            5: baud_cycle = fclk/115200;
        endcase
    end

reg [7:0] start_frame;
reg [3:0] cnt_symbol;
reg [13:0] cnt_tbaud;

always @(posedge cls or negedge rst_n)
    begin 
        if (!rst_n)
        else begin 
            if (di_rdy) begin
                start_frame <= 1;
                data_reg <= data_in;
                parity_bit <= 0;
            end
            else if (cnt_tbaud == baud_cycle) & (cnt_symbol <> 0) begin 
                parity_bit <= parity_bit ^ data_reg[0];
                data_reg <= {1, data_reg[7:1]};
            end
        end
    end
always @(posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        else begin 
            if (start_frame) begin
                cnt_tbaud <= 0;
                cnt_symbol <= 0;
            end
            else begin
                if (cnt_tbaud < baud_cycle) cnt_tbaud <= cnt_tbaud + 1;
                else begin
                    cnt_tbaud <= 0;
                    if (cnt_symbol == 8) & (parity == 0)
                        begin 
                            cnt_symbol <= 0;
                            send_e <= 1;
                        end
                    else if (cnt_symbol == 9) && (parity == 1)
                        begin 
                            cnt_symbol <= 0;
                            send_e <= 1;
                        end
                    else begin
                        cnt_symbol <= cnt_symbol + 1;
                    end
                end 
            end
        end
    end


always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        else
            begin
                if (cnt_symbol == 0) txd <= 0;
                else if (cnt_symbol < 8) txd <= data_reg[0];
                else if (cnt_symbol == 8) begin 
                    if (parity == 0) txd <= 1;
                    else txd <= parity_bit;
                end
                else if (cnt_symbol == 9) & (parity) txd <= 1;
                else txd <= 1;

            end
    end

always @(posedge cls or negedge rst_n)
    begin 
        if (!rst_n)
        else begin 
            delayed_rxd <= rxd;
            start_frame = delayed_rxd & (~rxd);
        end
    end

endmodule