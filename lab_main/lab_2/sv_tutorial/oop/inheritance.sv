class packet;
    int addr;

    function new(int addr);
        this.addr = addr;
    endfunction

    function void display();
        $display("[Base] addr = 0x%0h", addr);
    endfunction
endclass


class ext_packet extends packet;
    int data;
    protected static int parity;

    function new(int addr, int data);
        super.new(addr);
        this.data = data;
    endfunction
endclass


class errpacket extends ext_packet;
    protected static int errcount;

    function new(int addr, int data);
        super.new(addr, data);
    endfunction

    function void add_error();
        parity = ~parity;
        errcount++;
    endfunction

    static function int geterr();
        return errcount;
    endfunction
endclass


module tb_3;
    int num_err;
    errpacket pkt;

    initial begin
        pkt = new(8'h10, 8'hAA);
        pkt.add_error();
        num_err = errpacket::geterr();
        $display("num_err = %0d", num_err);
    end
endmodule

/*

# num_err = 1

*/
