library verilog;
use verilog.vl_types.all;
entity Test_Execute is
    generic(
        instr_wd        : integer := 32;
        reg_wd          : integer := 32;
        imm_wd          : integer := 16
    );
end Test_Execute;
