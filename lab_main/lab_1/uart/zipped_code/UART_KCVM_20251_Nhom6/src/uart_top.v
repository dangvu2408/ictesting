module uart_top #(parameter fclk = 5000000, word_size = 8)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [2:0] sel_baud_rate,
    input  wire [word_size - 1:0] data_in,
    input  wire       di_rdy,
    input  wire       parity,
    input  wire       rxd,
    input  wire       not_rdy_in,
    input  wire       load_tx_datareg,
    input  wire       ready,

    output wire       txd,
    output wire [word_size - 1:0] data_out,
    output wire       do_rdy,
    output wire       parity_error,
    output wire       ready_error
);
    wire clk_tx;
    wire clk_rx;

    Baud_gen #(.fclk(fclk)) baud_gen_01 (
        .clk(clk),
        .rst_n(rst_n),
        .sel_baud_rate(sel_baud_rate),
        .clk_tx(clk_tx),
        .clk_rx(clk_rx)
    );

    tx_uart #(.word_size(word_size)) tx_uart_01 (
        .clk_tx(clk_tx),
        .rst_n(rst_n),
        .data_in(data_in),
        .load_tx_datareg(load_tx_datareg),
        .ready(ready),
        .di_rdy(di_rdy),
        .parity(parity),
        .txd(txd)
    );

    rx_uart #(.word_size(word_size)) rx_uart_01 (
        .clk_rx(clk_rx),
        .rst_n(rst_n),
        .rxd(rxd),
        .not_rdy_in(not_rdy_in),
        .parity(parity),
        .data_out(data_out),
        .do_rdy(do_rdy),
        .parity_error(parity_error),
        .ready_error(ready_error)
    );


endmodule