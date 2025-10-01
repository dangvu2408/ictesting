library verilog;
use verilog.vl_types.all;
entity Orig_Basic_ALU_test is
    generic(
        reg_wd          : integer := 32;
        ADD             : integer := 1;
        SUB             : integer := 2;
        \NOT\           : integer := 3;
        \AND\           : integer := 4;
        \OR\            : integer := 5;
        \XOR\           : integer := 6
    );
end Orig_Basic_ALU_test;
