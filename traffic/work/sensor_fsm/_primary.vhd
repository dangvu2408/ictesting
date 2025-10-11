library verilog;
use verilog.vl_types.all;
entity sensor_fsm is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sensor          : in     vl_logic;
        car             : out    vl_logic
    );
end sensor_fsm;
