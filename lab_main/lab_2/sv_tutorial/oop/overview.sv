class memory;
    logic [7:0] mem [0:255];                // class property

    extern task write_mem(                  // class method 
        logic [7:0] addr,
        logic [7:0] data
    );

    extern function logic [7:0] read_mem(   // class method
        logic [7:0] addr
    );
endclass

task memory::write_mem(      // external method declaration
    logic [7:0] addr,
    logic [7:0] data
);
    mem[addr] = data;
endtask

function logic [7:0] memory::read_mem(   // external method declaration
    logic [7:0] addr
);
    return mem[addr];
endfunction

module tb_1;
    memory mem1;       // handle
    
    initial begin 
        mem1 = new;        // instance
        mem1.mem[8'h10] = 8'hFF;
        $display("mem1[%h] = %h", 8'h10, mem1.mem[8'h10]);
    end                // direct access

    memory mem2 = new; // handle and instance
    initial begin 
        mem2.write_mem(8'h11, 8'hEE);
        $display("mem2[%h] = %h", 8'h11, mem2.read_mem(8'h11));
    end                // method access
    
endmodule

/*

# mem1[10] = ff
# mem2[11] = ee

*/