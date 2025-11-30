module rx_uart #(parameter word_size = 8) (
    input wire clk_rx,
    input wire rst_n,
    input wire rxd, 
    input wire not_rdy_in, 
    input wire parity,

    output wire [word_size-1:0] data_out,
    output wire do_rdy,
    output wire parity_error,
    output wire ready_error 
);

    wire serial_in_0;
    wire sample_cnt_3;
    wire sample_cnt_7;
    wire bit_cnt_8;
    wire bit_cnt_9;  
    wire parity_check;

    wire inc_sample_cnt;
    wire clr_sample_cnt;
    wire inc_bit_cnt;
    wire clr_bit_cnt;
    wire shift;
    wire load;

    Control_Unit_RX C0 (
        .clk_rx(clk_rx),
        .rst_n(rst_n),
        .serial_in_0(serial_in_0),
        .sample_cnt_3(sample_cnt_3),
        .sample_cnt_7(sample_cnt_7),
        .bit_cnt_8(bit_cnt_8),
        .bit_cnt_9(bit_cnt_9),
        .parity_check(parity_check),
        .not_rdy_in(not_rdy_in),
        .inc_sample_cnt(inc_sample_cnt),
        .clr_sample_cnt(clr_sample_cnt),
        .inc_bit_cnt(inc_bit_cnt),
        .clr_bit_cnt(clr_bit_cnt),
        .shift(shift),
        .load(load),
        .do_rdy(do_rdy),
        .parity_error(parity_error),
        .ready_error(ready_error)
    );

    Datapath_Unit_RX #(word_size) D0 (
        .clk_rx(clk_rx),
        .rst_n(rst_n),
        .rxd(rxd),
        .parity(parity), 
        .inc_sample_cnt(inc_sample_cnt),
        .clr_sample_cnt(clr_sample_cnt),
        .inc_bit_cnt(inc_bit_cnt),
        .clr_bit_cnt(clr_bit_cnt),
        .shift(shift),
        .load(load),
        .serial_in_0(serial_in_0),
        .sample_cnt_3(sample_cnt_3),
        .sample_cnt_7(sample_cnt_7),
        .bit_cnt_8(bit_cnt_8),
        .bit_cnt_9(bit_cnt_9),
        .parity_check(parity_check),
        .data_out(data_out)
    );

endmodule

module Control_Unit_RX (
    input wire clk_rx,
    input wire rst_n,
    input wire serial_in_0,
    input wire sample_cnt_3,
    input wire sample_cnt_7,
    input wire bit_cnt_8,
    input wire bit_cnt_9,
    input wire parity_check,
    input wire not_rdy_in,

    output reg inc_sample_cnt,
    output reg clr_sample_cnt,
    output reg inc_bit_cnt,
    output reg clr_bit_cnt,
    output reg shift,
    output reg load,
    output reg do_rdy,
    output reg parity_error,
    output reg ready_error
);

    parameter [1:0] IDLE      = 2'b00;
    parameter [1:0] STARTING  = 2'b01;
    parameter [1:0] RECEIVING = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk_rx or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(state, serial_in_0, sample_cnt_3, sample_cnt_7, bit_cnt_8, bit_cnt_9, not_rdy_in, parity_check) begin
        next_state = state;
        inc_sample_cnt = 0; clr_sample_cnt = 0;
        inc_bit_cnt = 0;    clr_bit_cnt = 0;
        shift = 0;          load = 0;
        do_rdy = 0;         ready_error = 0;
        parity_error = 0;

        case (state)
            IDLE: begin
                if (serial_in_0) begin
                    next_state = STARTING;
                    clr_sample_cnt = 1;
                end
            end

            STARTING: begin
                if (!serial_in_0) begin
                    next_state = IDLE;
                    clr_sample_cnt = 1;
                end else if (sample_cnt_3) begin
                    next_state = RECEIVING;
                    clr_sample_cnt = 1;
                    clr_bit_cnt = 1;
                end else begin
                    inc_sample_cnt = 1;
                end
            end

            RECEIVING: begin
                if (sample_cnt_7) begin 
                    clr_sample_cnt = 1;

                    if (/*!bit_cnt_8 &&*/ !bit_cnt_9) begin
                        shift = 1;      
                        inc_bit_cnt = 1;
                        next_state = RECEIVING;
                    end
                    else if (bit_cnt_8) begin
                        inc_bit_cnt = 1;
                        next_state = RECEIVING;
                    end
                    else begin 
                        next_state = IDLE;

                        if (not_rdy_in) begin
                            ready_error = 1;
                        end else begin
                            if (parity_check) begin
                                parity_error = 1;
                            end
                            
                            load = 1;
                            do_rdy = 1;
                        end
                    end
                end else begin
                    inc_sample_cnt = 1;
                    next_state = RECEIVING;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule


module Datapath_Unit_RX #(parameter word_size = 8) (
    input wire clk_rx,
    input wire rst_n,
    input wire rxd,
    input wire parity, 
    
    input wire inc_sample_cnt, clr_sample_cnt,
    input wire inc_bit_cnt, clr_bit_cnt,
    input wire shift, load,

    output wire serial_in_0,
    output wire sample_cnt_3,
    output wire sample_cnt_7,
    output wire bit_cnt_8,
    output wire bit_cnt_9,   
    output wire parity_check,
    output reg [word_size-1:0] data_out
);

    reg [word_size-1:0] rx_shiftreg; 
    reg [3:0] sample_counter;       
    reg [3:0] bit_counter;      

    assign serial_in_0  = (rxd == 1'b0); // bị dịch... 
    assign sample_cnt_3 = (sample_counter == 3);
    assign sample_cnt_7 = (sample_counter == 7);
    
    assign bit_cnt_8 = (bit_counter == word_size); 
    assign bit_cnt_9 = (bit_counter == word_size + 1);

    wire calculated_parity;
    assign calculated_parity = ^rx_shiftreg; 

    assign parity_check = (calculated_parity ^ rxd) ^ parity;

    always @(posedge clk_rx or negedge rst_n) begin
        if (!rst_n) begin
            sample_counter <= 0;
            bit_counter <= 0;
            rx_shiftreg <= 0;
            data_out <= 0;
        end else begin
            if (clr_sample_cnt) begin
                sample_counter <= 0;
            end else if (inc_sample_cnt) begin
                sample_counter <= sample_counter + 1;
            end else begin
                sample_counter <= sample_counter; 
            end

            if (clr_bit_cnt) begin
                bit_counter <= 0;
            end else if (inc_bit_cnt) begin
                bit_counter <= bit_counter + 1;
            end else begin
                bit_counter <= bit_counter;
            end

            if (shift) begin
                // rx_shiftreg <= {rx_shiftreg[word_size-2:0], rxd};
                rx_shiftreg <= {rxd, rx_shiftreg[word_size-1:1]};
            end else begin
                rx_shiftreg <= rx_shiftreg; // Giữ nguyên
            end

            // 4. Xử lý Data Out Register
            if (load) begin
                data_out <= rx_shiftreg;
            end else begin
                data_out <= data_out; // Giữ nguyên
            end
        end
    end

endmodule