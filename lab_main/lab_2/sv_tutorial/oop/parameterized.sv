class packet #(parameter type T = int);
    int addr;
    local T data;
    local T mem [0:255];

    function new(int addr, T data);
        this.addr = addr;
        this.data = data;
    endfunction

    function void get_data(int addr);
        $display("addr = %0d data = 0x%0h", addr, mem[addr]);
    endfunction
endclass

module tb_4;
    packet intpkt;

    initial begin
        intpkt = new(10, 32'h1234);
        intpkt.get_data(10);
    end

endmodule

/*

# addr = 10 data = 0x0

*/
