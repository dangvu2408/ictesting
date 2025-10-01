library verilog;
use verilog.vl_types.all;
entity ALU_interface is
    generic(
        reg_wd          : integer := 32
    );
    port(
        clock           : in     vl_logic
    );
end ALU_interface;
