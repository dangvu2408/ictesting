module tx_uart #(parameter word_size = 8)(
    output Serial_out,
    input [word_size-1:0] Data_Bus,
    input Load_XMT_datareg,
    input Byte_ready,
    input T_byte,
    input Clock,
    input rst_b
);
    Control_Unit_TX M0 (
        Load_XMT_DR,
        Load_XMT_shftreg,
        start,
        shift,
        clear,
        Load_XMT_datareg,
        Byte_ready,
        T_byte,
        BC_lt_BCmax,
        Clock,
        rst_b
    );
    Datapath_Unit_TX M1 (
        Serial_out,
        BC_lt_BCmax,
        Data_Bus,
        Load_XMT_DR,
        Load_XMT_shftreg,
        start,
        shift,
        clear,
        Clock,
        rst_b
    );
endmodule

module Control_Unit_TX #(parameter one_hot_count = 3, state_count = one_hot_count, size_bit_count = 3, idle = 3'b000, waiting = 3'b010, sending = 3'b100, all_ones = 9'b111111111)(
    output reg Load_XMT_DR,
    output reg Load_XMT_shftreg,
    output reg start,
    output reg shift,
    output reg clear,
    input Load_XMT_datareg,
    input Byte_ready,
    input T_byte,
    input BC_lt_BCmax,
    input Clock,
    input rst_b
);
    reg [state_count-1:0] state, next_state;
    always @ (state, Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax) begin 
        Load_XMT_DR = 0;
        Load_XMT_shftreg = 0;
        start = 0;
        shift = 0;
        clear = 0;
        next_state = idle;
        case(state)
            idle:
                if (Load_XMT_datareg == 1'b1) begin 
                    Load_XMT_DR = 1;
                    next_state = idle;
                end else if (Byte_ready == 1'b1) begin 
                    Load_XMT_shftreg = 1;
                    next_state = waiting;
                end

            waiting:
                if (T_byte == 1) begin 
                    start = 1;
                    next_state = sending;
                end else next_state = waiting;

            sending:
                if (BC_lt_BCmax) begin
                    shift = 1;
                    next_state = sending;
                end else begin
                    clear = 1;
                    next_state = idle;
                end
            
            default: next_state = idle;
        endcase
    end

    always @ (posedge Clock, negedge rst_b) begin
        if (rst_b == 1'b0) state = idle;
        else state <= next_state;
    end

endmodule

module Datapath_Unit_TX #(parameter word_size = 8, size_bit_count = 3, all_ones = {(word_size + 1){1'b1}})(
    output Serial_out,
    output BC_lt_BCmax,
    input [word_size-1:0] Data_Bus,
    input Load_XMT_DR, 
    input Load_XMT_shftreg,
    input start,
    input shift,
    input clear,
    input Clock,
    input rst_b
);
    reg [word_size-1:0] XMT_datareg;
    reg [word_size:0] XMT_shftreg;
    reg [size_bit_count:0] bit_count;

    assign Serial_out = XMT_shftreg[0];
    assign BC_lt_BCmax = (bit_count < word_size + 1);
    always @ (posedge Clock, negedge rst_b) begin 
        if (rst_b == 0) begin 
            XMT_shftreg <= all_ones;
            bit_count <= 0;
        end else begin 
            if (Load_XMT_DR == 1'b1) XMT_datareg <= Data_Bus;
            if (Load_XMT_shftreg == 1'b1) XMT_shftreg <= {XMT_datareg, 1'b1};
            if (start == 1'b1) XMT_shftreg[0] <= 0;
            if (clear == 1'b1) bit_count <= 0;
            if (shift == 1'b1) begin
                XMT_shftreg <= {1'b1, XMT_shftreg[word_size:1]};
                bit_count <= bit_count + 1;
            end
        end
    end
endmodule