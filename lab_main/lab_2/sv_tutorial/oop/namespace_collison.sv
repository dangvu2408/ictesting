package pcka;
    typedef enum bit { READ, WRITE } e_rd_wr;
endpackage

import pcka::*;

typedef enum bit { WRITE, READ } e_wr_rd;

module tb_6;
    initial begin
        e_wr_rd opc1 = READ;
        // e_rd_wr opc2 = READ;
        e_rd_wr opc3 = pcka::READ;
        // $display("READ1 = %0d READ2 = %0d", opc1, opc2);
        $display("READ1 = %0d READ2 = %0d", opc1, opc3);
    end
endmodule

/*

# READ1 = 1 READ2 = 0

*/