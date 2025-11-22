module baud_gen_uart #(parameter fclk = 5000000) (  
    input       clk,
    input       rst_n,
    input [2:0] baud,
    input       is_idle,
    output wire tick_pulse,
    output wire fsm_trigger_pulse

);
    reg [15:0]  baud_cycle;
    reg [11:0]  clk_per_tick;

    always @(baud or rst_n) begin 
        case (baud)
            0: baud_cycle = fclk/4800;
            1: baud_cycle = fclk/9600;
            2: baud_cycle = fclk/19200;
            3: baud_cycle = fclk/38400;
            4: baud_cycle = fclk/57600;
            5: baud_cycle = fclk/115200;
            default: baud_cycle = fclk/9600;
        endcase

        if (baud_cycle < 16)
            clk_per_tick = 1; 
        else
            clk_per_tick = baud_cycle / 16;
    end

    reg [11:0] clk_cnt;
    wire fine_tick_pulse = (clk_cnt == clk_per_tick - 1); 
    reg [3:0] tick_cnt; 

    assign   fsm_trigger_pulse = (tick_cnt == 4'd7 && fine_tick_pulse); 
    assign   tick_pulse = (tick_cnt < 4'd8);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt  <= 0;
            tick_cnt <= 0;
        end else if (is_idle) begin
            clk_cnt  <= 0;
            tick_cnt <= 0;
        end else if (fine_tick_pulse) begin
            clk_cnt  <= 0;
            tick_cnt <= tick_cnt + 1;
        end else begin
            clk_cnt <= clk_cnt + 1;
        end
    end
endmodule