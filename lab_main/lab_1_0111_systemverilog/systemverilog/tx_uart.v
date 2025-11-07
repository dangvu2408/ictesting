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

    reg [7:0] data_reg;
    reg parity_bit;
    reg [13:0] cnt_tbaud;
    reg [3:0] cnt_symbol;
    reg start_frame;

    always @(posedge clk or negedge rst_n)
        begin 
            if (!rst_n) begin 
                start_frame <= 0;
                data_reg <= 0;
                parity_bit <= 0;
            end // chưa có phần xử lý reset
            else begin 
                if (di_rdy) begin
                    start_frame <= 1;
                    data_reg <= data_in;
                    parity_bit <= parity ? ^data_in : 0;   // tính parity TRƯỚC khi shift
                end
                else if ((cnt_tbaud == baud_cycle) && (cnt_symbol != 0)) begin 
                    // parity_bit <= parity_bit ^ data_reg[0]; // đoạn này chuyển lên dòng 40
                    data_reg <= {1'b1, data_reg[7:1]};
                end
                else if (send_e) begin              
                    start_frame <= 0;
                end
            end
        end

    always @(posedge clk or negedge rst_n)
        begin 
            if (!rst_n) begin 
                cnt_tbaud <= 0;
                cnt_symbol <= 0;
                send_e <= 0;
            end // chưa có phần xử lý reset
            else begin 
                if (start_frame) begin
                    cnt_tbaud <= 0;
                    cnt_symbol <= 0;
                    send_e <= 0;
                    // start_frame <= 0;
                    // cnt_tbaud <= 0;
                    // cnt_symbol <= 0;
                end
                else begin
                    if (cnt_tbaud < baud_cycle) 
                        cnt_tbaud <= cnt_tbaud + 1;
                    else begin
                        cnt_tbaud <= 0;
                        if ((cnt_symbol == 8 && !parity) || (cnt_symbol == 9 &&  parity)) begin
                            cnt_symbol <= 0;
                            send_e <= 1;
                        end 
                        else begin
                            cnt_symbol <= cnt_symbol + 1;
                        end
                        // if (cnt_symbol == 8) & (parity == 0)
                        //     begin 
                        //         cnt_symbol <= 0;
                        //         send_e <= 1;
                        //     end
                        // else if (cnt_symbol == 9) && (parity == 1)
                        //     begin 
                        //         cnt_symbol <= 0;
                        //         send_e <= 1;
                        //     end
                        // else begin
                        //     cnt_symbol <= cnt_symbol + 1;
                        // end
                    end 
                end
            end
        end


    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n) 
                txd <= 1;// chưa có phần xử lý reset
            else begin
                case (cnt_symbol)
                    4'd0: txd <= 0;                          // START
                    4'd1,4'd2,4'd3,4'd4,
                    4'd5,4'd6,4'd7,4'd8: txd <= data_reg[0]; // DATA
                    4'd9: txd <= parity ? parity_bit : 1;    // PARITY or STOP
                    4'd10: txd <= 1;                         // STOP
                    default: txd <= 1;
                endcase
                // if (cnt_symbol == 0) txd <= 0;
                // else if (cnt_symbol < 8) txd <= data_reg[0];
                // else if (cnt_symbol == 8) begin 
                //     if (parity == 0) txd <= 1;
                //     else txd <= parity_bit;
                // end
                // else if (cnt_symbol == 9) & (parity) txd <= 1;
                // else txd <= 1;
            end
        end
endmodule