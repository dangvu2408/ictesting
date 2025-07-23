library verilog;
use verilog.vl_types.all;
entity Basic_ALU_interface is
    generic(
        reg_wd          : integer := 32
    );
    port(
        clock           : in     vl_logic
    );
end Basic_ALU_interface;
