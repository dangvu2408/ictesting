module rx_uart #(parameter fclk = 5000000)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rxd,       
    input  wire [2:0] baud,
    input  wire       parity,
    output reg  [7:0] data_out,
    output reg        do_rdy
);

    reg [13:0] baud_cycle;
    always @(baud) begin
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
               PARITY= 3,
               STOP  = 4;

    reg [2:0] state = IDLE;
    reg [13:0] cnt_baud = 0;
    reg [2:0] bit_idx = 0;
    reg [7:0] data_reg = 0;
    reg parity_calc = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            cnt_baud  <= 0;
            bit_idx   <= 0;
            do_rdy    <= 0;
        end else begin
            case (state)
                IDLE: begin
                    do_rdy <= 0;
                    if (rxd == 0) begin      
                        state <= START;
                        cnt_baud <= 0;
                    end
                end

                START: begin
                    if (cnt_baud == baud_cycle/2) begin
                        if (rxd == 0) begin  
                            state <= DATA;
                            bit_idx <= 0;
                            parity_calc <= 0;
                        end else begin
                            state <= IDLE;   
                        end
                        cnt_baud <= 0;
                    end else
                        cnt_baud <= cnt_baud + 1;
                end

                DATA: begin
                    if (cnt_baud == baud_cycle) begin
                        cnt_baud <= 0;
                        data_reg <= {rxd, data_reg[7:1]}; 
                        parity_calc <= parity_calc ^ rxd;
                        bit_idx <= bit_idx + 1;
                        if (bit_idx == 7)
                            state <= parity ? PARITY : STOP;
                    end else
                        cnt_baud <= cnt_baud + 1;
                end

                PARITY: begin
                    if (cnt_baud == baud_cycle) begin
                        cnt_baud <= 0;
                        if (parity_calc == rxd)   
                            state <= STOP;
                        else
                            state <= IDLE;    
                    end else
                        cnt_baud <= cnt_baud + 1;
                end

                STOP: begin
                    if (cnt_baud == baud_cycle) begin
                        data_out <= data_reg;
                        do_rdy <= 1;
                        state <= IDLE;
                    end else
                        cnt_baud <= cnt_baud + 1;
                end
            endcase
        end
    end

endmodule
