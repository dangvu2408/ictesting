module rx_uart #(parameter fclk = 5000000)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rxd,       
    input  wire [2:0] baud,
    input  wire       parity,
    input  wire       tick_pulse,
    input  wire       fsm_trigger_pulse,
    output reg  [7:0] data_out,
    output reg        do_rdy,
    output reg        rx_idle
);

    reg [2:0] state;
    localparam IDLE  = 0,
               START = 1,
               DATA  = 2,
               PAR   = 3,
               STOP  = 4;

    reg [7:0] rx_shift;
    reg [3:0] bit_cnt;
    reg       calculated_parity;

    // wire tick_pulse;
    // wire fsm_trigger_pulse;

    // baud_gen_uart #(.fclk(fclk)) baud_rx (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .baud(baud),
    //     .is_idle(state == IDLE),  
    //     .tick_pulse(tick_pulse),
    //     .fsm_trigger_pulse(fsm_trigger_pulse)
    // );


    // gen tick_pulse
    // reg [11:0] clk_cnt;
    // wire tick_pulse = (clk_cnt == clk_per_tick - 1); 
    // reg [3:0] tick_cnt; 
    // reg tick_clk = 0;

    // always @(posedge clk or negedge rst_n) begin 
    //     if (!rst_n) begin 
    //         clk_cnt <= 0; 
    //         tick_cnt <= 0; 
    //         tick_clk <= 0; 
    //     end else begin 
    //         if (clk_cnt == clk_per_tick - 1) begin 
    //             clk_cnt <= 0; 
    //             tick_cnt <= tick_cnt + 1; 
    //             if (tick_cnt == 7) 
    //                 tick_clk <= 1; 
    //             else if (tick_cnt == 15) begin 
    //                 tick_clk <= 0; 
    //                 tick_cnt <= 0; 
    //             end 
    //         end else begin 
    //             clk_cnt <= clk_cnt + 1; 
    //         end 
    //     end 
    // end 

    // wire tick_negedge = (tick_cnt == 15);
    // wire tick_posedge = (tick_cnt == 7);

    // detect when the rxd fall

    reg [1:0] rxd_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rxd_sync <= 2'b11;
        else rxd_sync <= {rxd_sync[0], rxd};
    end
    wire rxd_fall = rxd_sync[1] & ~rxd_sync[0];
    wire sampled_rxd = rxd_sync[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            do_rdy   <= 0;
            bit_cnt  <= 0;
            rx_shift <= 8'h00;
            data_out <= 8'h00;
        end else begin
            do_rdy <= 1'b0;

            case (state)
                IDLE: begin
                    if (rxd_fall) begin 
                        state <= START;
                        bit_cnt <= 0;
                    end
                end

                START: begin
                    if (fsm_trigger_pulse) begin 
                        if (rxd == 1'b0) begin
                            state <= DATA; 
                            bit_cnt <= 0;
                            calculated_parity <= 1'b0;
                            rx_shift <= 8'h00;
                        end else 
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (fsm_trigger_pulse) begin 
                        rx_shift <= {sampled_rxd, rx_shift[7:1]};
                        calculated_parity <= ^sampled_rxd;
                        if (bit_cnt == 7) begin
                            if (parity)
                                state <= PAR;
                            else
                                state <= STOP;
                        end else begin
                            bit_cnt <= bit_cnt + 1;
                        end
                    end
                end

                PAR: begin
                    if (fsm_trigger_pulse) begin 
                        if (sampled_rxd == calculated_parity)
                            state <= STOP;
                        else
                        state <= PAR;
                    end
                end

                STOP: begin
                    if (fsm_trigger_pulse) begin 
                        if (sampled_rxd == 1'b1) begin 
                            data_out <= rx_shift;
                            do_rdy <= 1;
                        end
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
