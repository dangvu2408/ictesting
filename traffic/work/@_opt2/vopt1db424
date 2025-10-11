library verilog;
use verilog.vl_types.all;
entity timer_fsm is
    generic(
        green_timeout   : integer := 10;
        yellow_timeout  : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        start           : in     vl_logic;
        \Timeout\       : out    vl_logic;
        timeout         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of green_timeout : constant is 1;
    attribute mti_svvh_generic_type of yellow_timeout : constant is 1;
end timer_fsm;
