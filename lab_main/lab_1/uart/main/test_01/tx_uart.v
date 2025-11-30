module tx_uart #(parameter word_size = 8)(
    input clk_tx,
    input rst_n,
    input [word_size-1:0] data_in,
    input load_tx_datareg,       // tín hiệu từ bên ngoài vào
    input ready,
    input di_rdy,
    input parity,
    output txd
);
    wire load_tx_shift;
    wire start, shift, clear;
    wire bit_cnt_max;
    wire [2:0] state_debug;

    wire load_tx_datareg_out;   // output từ CU

    Control_Unit_TX M0 (
        .load_tx_datareg_out(load_tx_datareg_out),
        .load_tx_shift(load_tx_shift),
        .start(start),
        .shift(shift),
        .clear(clear),
        .state_debug(state_debug),
        .load_tx_datareg_in(load_tx_datareg), // input
        .ready(ready),
        .di_rdy(di_rdy),
        .bit_cnt_max(bit_cnt_max),
        .clk_tx(clk_tx),
        .rst_n(rst_n)
    );

    Datapath_Unit_TX M1 (
        .txd(txd),
        .bit_cnt_max(bit_cnt_max),
        .data_in(data_in),
        .load_tx_datareg(load_tx_datareg_out),
        .load_tx_shift(load_tx_shift),
        .start(start),
        .shift(shift),
        .clear(clear),
        .clk_tx(clk_tx),
        .rst_n(rst_n),
        .parity(parity)
    );

endmodule

module Control_Unit_TX #(parameter one_hot_count = 3, state_count = one_hot_count, size_bit_count = 3, 
                         IDLE = 3'b000, WAITING = 3'b010, SENDING = 3'b100)(
    output reg load_tx_datareg_out,
    output reg load_tx_shift,
    output reg start,
    output reg shift,
    output reg clear,

    output [state_count-1:0] state_debug, // debug state

    input load_tx_datareg_in,
    input ready,
    input di_rdy,
    input bit_cnt_max,
    input clk_tx,
    input rst_n
);
    reg [state_count-1:0] state, next_state;
    assign state_debug = state;
    always @(state or load_tx_datareg_in or ready or di_rdy or bit_cnt_max) begin 
        load_tx_datareg_out = 0;
        load_tx_shift       = 0;
        start               = 0;
        shift               = 0;
        clear               = 0;
        
        next_state = IDLE;

        case(state)
            IDLE:
                if (load_tx_datareg_in == 1'b1) begin 
                    load_tx_datareg_out = 1;
                    next_state = IDLE;

                end else if (ready == 1'b1) begin
                    load_tx_shift = 1;
                    next_state = WAITING;
                end

            WAITING:
                if (di_rdy == 1) begin 
                    start = 1;
                    next_state = SENDING;
                end else next_state = WAITING;

            SENDING:
                if (bit_cnt_max) begin
                    shift = 1;
                    next_state = SENDING;
                end else begin
                    clear = 1;
                    next_state = IDLE;
                end
        endcase
    end

    always @(posedge clk_tx, negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else state <= next_state;
    end

    

endmodule

module Datapath_Unit_TX #(parameter word_size = 8, size_bit_count = 4)(
    output txd,
    output bit_cnt_max,
    input [word_size-1:0] data_in,
    input load_tx_datareg, 
    input load_tx_shift,
    input start,
    input shift,
    input clear,
    input clk_tx,
    input rst_n,
    input parity
);

    reg [word_size-1:0] tx_datareg;

    reg [word_size+2:0] tx_shift;
    reg [size_bit_count:0] bit_count;

    wire parity_bit_calc;

    assign txd = tx_shift[0];

    assign bit_cnt_max = (bit_count < word_size + 3);

    assign parity_bit_calc = parity ? ~(^tx_datareg) : (^tx_datareg);

    always @ (posedge clk_tx, negedge rst_n) begin 
        if (!rst_n) begin 
            tx_shift <= {(word_size+3){1'b1}};
            bit_count <= 0;
        end else begin 
            if (load_tx_datareg)
                tx_datareg <= data_in;

            if (load_tx_shift)
                tx_shift <= {1'b1, parity_bit_calc, tx_datareg, 1'b0}; // đã gán tx_shift = 0

            if (start)
                tx_shift[0] <= 0;

            if (clear)
                bit_count <= 0;

            if (shift) begin
                tx_shift <= {1'b1, tx_shift[word_size+2:1]};
                bit_count <= bit_count + 1;
            end
        end
    end
endmodule
