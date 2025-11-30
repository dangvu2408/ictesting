module uart_top #(parameter fclk = 5000000)(
    input  wire       clk,
    input  wire       rst_n,
    // TX side
    input  wire [7:0] data_in,
    input  wire       di_rdy,
    output wire       txd, // as rxd
    output wire       send_e,
    // RX side
    output wire [7:0] data_out,
    output wire       do_rdy,
    input  wire [2:0] baud,
    input  wire       parity
);

    wire tick_pulse;
    wire fsm_trigger_pulse;

    wire tx_idle;
    wire rx_idle;
    reg  is_idle_sync;

    baud_gen_uart #(.fclk(fclk)) baud_inst (
        .clk(clk),
        .rst_n(rst_n),
        .baud(baud),
        .is_idle(is_idle_sync),
        .tick_pulse(tick_pulse),
        .fsm_trigger_pulse(fsm_trigger_pulse)
    );

    tx_uart #(.fclk(fclk)) tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .di_rdy(di_rdy),
        .baud(baud),
        .parity(parity),
        .tick_pulse(tick_pulse),
        .fsm_trigger_pulse(fsm_trigger_pulse),
        .txd(txd),
        .send_e(send_e),
        .tx_idle(tx_idle)
    );

    rx_uart #(.fclk(fclk)) rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rxd(txd),
        .baud(baud),
        .parity(parity),
        .tick_pulse(tick_pulse),
        .fsm_trigger_pulse(fsm_trigger_pulse),
        .data_out(data_out),
        .do_rdy(do_rdy),
        .rx_idle(rx_idle)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            is_idle_sync <= 1'b1;
        else
            is_idle_sync <= tx_idle & rx_idle;
    end
endmodule