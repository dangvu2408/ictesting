module tx_uart #(parameter fclk = 5000000) (
    input       clk,
    input       rst_n,
    input [7:0] data_in,
    input       di_rdy,
    input [2:0] baud,
    input       parity,
    output reg  txd,
    output reg  send_e
);
    reg [2:0]  state;
    localparam IDLE = 0, 
               START = 1, 
               DATA = 2, 
               PAR = 3, 
               STOP = 4;
    
    reg [7:0] tx_shift;
    reg [3:0] bit_cnt; 
    reg       parity_bit;
    reg [7:0] pending_data;
    reg       pending_req;

    reg [11:0] clk_cnt;
    reg [3:0] tick_cnt; 
    
    wire fsm_trigger_pulse; 
    wire tick_pulse;

    baud_gen_uart #(.fclk(fclk)) baud_tx (
        .clk(clk),
        .rst_n(rst_n),
        .baud(baud),
        .is_idle(state == IDLE),   
        .tick_pulse(tick_pulse),
        .fsm_trigger_pulse(fsm_trigger_pulse)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pending_req  <= 1'b0;
            pending_data <= 8'h00;
        end else begin
            if (di_rdy) begin
                pending_req  <= 1'b1;
                pending_data <= data_in;
            end else if (state == IDLE && pending_req) begin
                pending_req <= 1'b0; 
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            txd      <= 1'b1;
            send_e   <= 1'b0;
            bit_cnt  <= 0;
            tx_shift <= 8'h00;
        end else begin
            send_e <= 1'b0; 

            case (state)
                IDLE: begin 
                    txd <= 1'b1;
                    if (pending_req) begin 
                        tx_shift   <= pending_data;
                        parity_bit <= ^pending_data;
                        txd        <= 1'b0; 
                        state      <= START;
                        bit_cnt    <= 0;
                    end
                end

                START: begin
                    txd <= 1'b0; 
                    if (fsm_trigger_pulse) state <= DATA; 
                    else state <= START;
                end

                DATA: begin
                    txd <= tx_shift[0];
                    if (fsm_trigger_pulse) begin
                        tx_shift <= tx_shift >> 1; 

                        if (bit_cnt == 7) begin
                            state <= (parity ? PAR : STOP);
                        end else begin
                            bit_cnt <= bit_cnt + 1;
                        end
                    end
                end

                PAR: begin
                    txd <= parity_bit;
                    if (fsm_trigger_pulse) state <= STOP;
                    else state <= PAR;
                end

                STOP: begin
                    txd <= 1'b1;
                    if (fsm_trigger_pulse) begin
                        state <= IDLE; 
                        send_e <= 1'b1; 
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule