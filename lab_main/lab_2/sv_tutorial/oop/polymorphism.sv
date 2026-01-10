package polymorphism_pkg;
    virtual class packet;
        int addr;

        function new(int addr);
            this.addr = addr;
        endfunction

        pure virtual function void display();
    endclass

    class ext_packet extends packet;
        int data;

        function new(int addr, int data);
            super.new(addr);
            this.data = data;
        endfunction

        function void display();
            $display("[Child] addr=0x%0h data=0x%0h", addr, data);
        endfunction
    endclass

endpackage

module tb;
    import polymorphism_pkg::*;

    packet     pkt1;
    ext_packet extpkt1;
    ext_packet epkt2;

    initial begin
        extpkt1 = new(8'h55, 8'hFE);

        pkt1 = extpkt1;   // base handle → child object
        pkt1.display();  // polymorphism

        $cast(epkt2, pkt1);
        epkt2.display();
    end
endmodule

/*

# [Child] addr=0x55 data=0xfe
# [Child] addr=0x55 data=0xfe

*/
