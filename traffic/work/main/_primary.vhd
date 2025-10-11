library verilog;
use verilog.vl_types.all;
entity main is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        car_sensor      : in     vl_logic;
        highway_light   : out    vl_logic_vector(2 downto 0);
        country_light   : out    vl_logic_vector(2 downto 0)
    );
end main;
