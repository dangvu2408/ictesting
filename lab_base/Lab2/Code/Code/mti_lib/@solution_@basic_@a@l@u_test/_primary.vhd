library verilog;
use verilog.vl_types.all;
entity Solution_Basic_ALU_test is
    generic(
        reg_wd          : integer := 32;
        ADD             : integer := 1;
        SUB             : integer := 2;
        \NOT\           : integer := 3;
        \AND\           : integer := 4;
        \OR\            : integer := 5;
        \XOR\           : integer := 6
    );
end Solution_Basic_ALU_test;
