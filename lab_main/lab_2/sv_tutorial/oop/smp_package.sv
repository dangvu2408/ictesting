package smp_package;
    typedef enum bit [1:0] { RED, YELLOW, GREEN, RSVD } e_signal;
    typedef struct { bit [3:0] signal_id;
                     bit       active;
                     bit [1:0] timeout;
    } e_sig_param;

    function common();
        $display("Called from somewhere");
    endfunction
endpackage

import smp_package::*;

class imp_package;
    e_signal my_sig;
endclass

module tb_5;
    imp_package cls;
    initial begin
        cls = new();
        cls.my_sig = GREEN;
        $display("my_sig = %s", cls.my_sig.name());
        common();
    end
endmodule

/*

# my_sig = GREEN
# Called from somewhere

*/