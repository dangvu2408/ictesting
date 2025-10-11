library verilog;
use verilog.vl_types.all;
entity traffic_controller is
    generic(
        green_timeout   : integer := 10;
        yellow_timeout  : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        car_sensor      : in     vl_logic;
        highway_light   : out    vl_logic_vector(2 downto 0);
        country_light   : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of green_timeout : constant is 1;
    attribute mti_svvh_generic_type of yellow_timeout : constant is 1;
end traffic_controller;
