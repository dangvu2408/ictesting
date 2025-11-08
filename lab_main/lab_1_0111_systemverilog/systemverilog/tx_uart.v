module tx_uart #(parameter fclk = 5000000) (
    input        clk,
    input        rst_n,
    input  [7:0] data_in,
    input        di_rdy,
    input  [2:0] baud,
    input        parity,
    output reg   txd,
    output reg   send_e
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
                default: baud_cycle = fclk/9600;
            endcase
        end

    localparam IDLE  = 0,
               START = 1,
               DATA  = 2,
               PAR   = 3,
               STOP  = 4;

    reg [2:0] state;

    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;
    reg parity_bit;
    reg [15:0] baud_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            txd       <= 1'b1;
            send_e    <= 1'b0;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    txd <= 1;        
                    send_e <= 0;
                    if (di_rdy) begin
                        txd <= 0;
                        shift_reg  <= data_in;
                        parity_bit <= ^data_in;   
                        bit_cnt    <= 0;
                        baud_cnt   <= 0;
                        state      <= START;
                    end
                end

                START: begin
                    if (baud_cnt < baud_cycle - 1) baud_cnt <= baud_cnt + 1;
                    else begin
                        baud_cnt <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    txd <= shift_reg[0];
                    if (baud_cnt < baud_cycle - 1) baud_cnt <= baud_cnt + 1;
                    else begin
                        baud_cnt  <= 0;
                        shift_reg <= shift_reg >> 1;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7)
                            state <= (parity ? PAR : STOP);
                    end
                end

                PAR: begin
                    txd <= parity_bit;
                    if (baud_cnt < baud_cycle-1) baud_cnt <= baud_cnt + 1;
                    else begin
                        baud_cnt <= 0;
                        state <= STOP;
                    end
                end

                STOP: begin
                    txd <= 1;
                    if (baud_cnt < baud_cycle-1) baud_cnt <= baud_cnt + 1;
                    else begin
                        send_e <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule


    // always @(posedge clk or negedge rst_n) begin 
    //     if (!rst_n) begin 
    //         // cai gi do
    //     end else begin 
    //         if (di_rdy) begin
    //             start_frame <= 1;
    //             data_reg <= data_in;
    //             parity_bit <= 0;

    //             while (cnt_tbaud < baud_cycle) begin 
    //                 txd <= 0;
    //                 cnt_tbaud <= cnt_tbaud + 1;
    //             end

    //             cnt_symbol <= cnt_symbol + 1;
    //             cnt_tbaud <= 0;

    //             while (cnt_symbol < 8) begin 
    //                 tdx <= data_reg[0];
    //                 while (cnt_tbaud < baud_cycle) begin 
    //                     cnt_tbaud <= cnt_tbaud + 1;
    //                     txd <= data_reg[0];
    //                 end
    //                 cnt_symbol <= cnt_symbol + 1;
    //                 parity_bit <= parity_bit ^ data_reg[0];   
    //                 data_reg <= {1'b1, data_reg[7:1]};
    //             end

    //             if (parity == 1) begin 
    //                 txd <= parity_bit;
    //                 cnt_tbaud <= 0;
    //                 while (cnt_tbaud < baud_cycle) begin 
    //                     cnt_tbaud <= cnt_tbaud + 1;
    //                     txd <= 1;
    //                 end
    //                 send_e <= 1;
    //             end else begin 
    //                 txd <= 1;
    //                 cnt_tbaud <= 0;
    //                 while (cnt_tbaud < baud_cycle) begin 
    //                     cnt_tbaud <= cnt_tbaud + 1;
    //                     txd <= 1;
    //                 end
    //                 send_e <= 1;
    //             end
    //         end
    //     end

    // end

