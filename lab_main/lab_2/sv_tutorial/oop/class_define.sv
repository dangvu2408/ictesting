class packet;
    bit [2:0] addr;
    bit [7:0] data;
    int tag;
    static int pktcnt;

    function new (bit [2:0] addr, bit [7:0] data);
        this.addr = addr;
        this.data = data;
        pktcnt++;
        tag = pktcnt;
    endfunction

    function display();
        $display("Address = 0x%0h Data = %0h, Count = %0d",
                addr, data, pktcnt);
    endfunction
endclass

module tb_2;
    packet p1, p2;
    initial begin
        p1 = new(3'd1,8'd11);
        p2 = new(3'd2,8'd22);
        p1.display();
        p2.display();
    end
endmodule

/*

# Header = 0x3 Encode = 0, Mode = 0x5, Stop = 1
# pktcnt = 0
# pktcnt = 0
# pktcnt = 0

*/

    // function new();
    //     pktcnt++;
    // endfunction




    // packet p1, p2, p3;
    // initial begin
    //     packet::get_pktcnt();  // stattic call
    //     p1 = new;
    //     p2 = new;
    //     p3 = new;
    //     packet::get_pktcnt();  // static call
    //     p3.get_pktcnt();       // normal call
    // end



    // function new (bit [2:0] pheader = 3'h1, bit [2:0] pmode = 3'h5); 
    //     header = pheader;  
    //     encode = 0;
    //     mode   = pmode;
    //     stop   = 1;
    // endfunction



    // static int pktcnt;

    // static function get_pktcnt();
    //     $display("pktcnt = %0d", pktcnt);
    // endfunction