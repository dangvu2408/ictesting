module rx_uart #(parameter word_size = 8, half_word = word_size / 2)(
    output [word_size-1:0] RCV_datareg,
    output                  read_not_ready_out, Error1, Error2,
    input                   Serial_in, read_not_ready_in, Sample_clk, rst_b
);
    Control_Unit_RX M0 (
        read_not_ready_out,
        Error1, Error2,
        clr_Sample_counter,
        inc_Sample_counter,
        clr_Bit_counter,
        inc_Bit_counter,
        shift,
        load,
        read_not_ready_in,
        Ser_in_0,
        SC_eq_3,
        SC_lt_7,
        BC_eq_8,
        Sample_clk,
        rst_b
    );
    Datapath_Unit_RX M1 (
        RCV_datareg,
        Ser_in_0,
        SC_eq_3,
        SC_lt_7,
        BC_eq_8,
        Serial_in,
        clr_Sample_counter,
        inc_Sample_counter,
        clr_Bit_counter,
        inc_Bit_counter,
        shift,
        load,
        Sample_clk,
        rst_b
    );
endmodule

module Control_Unit_RX #(parameter word_size = 8, half_word = word_size / 2, Num_state_bits = 2, idle = 2'b00, starting = 2'b01, receiving = 2'b10)(
    output reg read_not_ready_out,
    output reg Error1, Error2,
    output reg clr_Sample_counter,
    output reg inc_Sample_counter,
    output reg clr_Bit_counter,
    output reg inc_Bit_counter,
    output reg shift,
    output reg load,
    input read_not_ready_in,
    input Ser_in_0,
    input SC_eq_3,
    input SC_lt_7,
    input BC_eq_8,
    input Sample_clk,
    input rst_b
);

    reg [word_size-1 : 0]      RCV_shftreg;
    reg [Num_state_bits-1 : 0] state, next_state;
    always @ (posedge Sample_clk)
        if (rst_b == 1'b0) state <= idle;
        else state <= next_state;
    always @(state, Ser_in_0, SC_eq_3, SC_lt_7, read_not_ready_in) begin
        read_not_ready_out = 0;
        clr_Sample_counter = 0;
        clr_Bit_counter = 0;
        inc_Sample_counter = 0;
        inc_Bit_counter = 0;
        shift = 0;
        Error1 = 0;
        Error2 = 0;
        load = 0;
        next_state = idle;
        case (state)
            idle: 
                if (Ser_in_0 == 1'b1) next_state = starting;
                else next_state = idle;

            starting: 
                if (Ser_in_0 == 1'b0) begin
                    next_state = idle;
                    clr_Sample_counter = 1;
                end else if (SC_eq_3 == 1'b1) begin
                    next_state = receiving;
                    clr_Sample_counter = 1;
                end else begin 
                    inc_Sample_counter = 1; 
                    next_state = starting; 
                end

            receiving: 
                if (SC_lt_7 == 1'b1) begin
                    inc_Sample_counter = 1;
                    next_state = receiving;
                end else begin
                    clr_Sample_counter = 1;
                    if (!BC_eq_8) begin
                        shift = 1;
                        inc_Bit_counter = 1;
                        next_state = receiving;
                    end else begin
                        next_state = idle;
                        read_not_ready_out = 1;
                        clr_Bit_counter = 1;
                        if (read_not_ready_in == 1'b1) Error1 = 1;
                        else if (Ser_in_0 == 1'b1) Error2 = 1;
                        else load = 1;
                    end
                end

            default: next_state = idle;
        endcase
    end
endmodule

module Datapath_Unit_RX #(parameter word_size = 8, half_word = word_size / 2, Num_counter_bits = 4)(
    output reg [word_size-1:0] RCV_datareg,
    output Ser_in_0, SC_eq_3, SC_lt_7, BC_eq_8,
    input Serial_in, 
    input clr_Sample_counter,
    input inc_Sample_counter,
    input clr_Bit_counter,
    input inc_Bit_counter,
    input shift,
    input load,
    input Sample_clk,
    input rst_b
);

    reg [word_size-1:0]        RCV_shftreg;
    reg [Num_counter_bits-1:0] Sample_counter;
    reg [Num_counter_bits:0]   Bit_counter;

    assign Ser_in_0 = (Serial_in == 1'b0);
    assign BC_eq_8  = (Bit_counter == word_size);
    assign SC_lt_7  = (Sample_counter < word_size - 1);
    assign SC_eq_3  = (Sample_counter == half_word - 1);

    always @(posedge Sample_clk) begin
        if (rst_b == 1'b0) begin 
            Sample_counter <= 0;
            Bit_counter <= 0;
            RCV_datareg <= 0;
            RCV_shftreg <= 0;
        end else begin
            if (clr_Sample_counter == 1) Sample_counter <= 0;
            else if (inc_Sample_counter == 1) Sample_counter <= Sample_counter + 1;
            if (clr_Bit_counter == 1) Bit_counter <= 0;
            else if (inc_Bit_counter == 1) Bit_counter <= Bit_counter + 1;
            if (shift == 1) RCV_shftreg <= {Serial_in, RCV_shftreg[word_size-1:1]};
            if (load == 1) RCV_datareg <= RCV_shftreg;
        end
    end
endmodule