class MemoryBlock;
    bit [31:0] m_ram_start;
    bit [31:0] m_ram_end;

    rand bit [31:0] m_start_addr;
    rand bit [31:0] m_end_addr;
    rand int m_block_size;

    constraint c_addr {
        m_start_addr >= m_ram_start;
        m_start_addr < m_ram_end;
        m_start_addr % 4 == 0;
        m_end_addr == m_start_addr + m_block_size - 1;
    };

    constraint c_blk_size {
        m_block_size inside { 64, 128, 512 };
    }

    function void display();
        $display("---Memory Block---");
        $display("RAM StartAddr   = 0x%0h", m_ram_start);
        $display("RAM EndAddr     = 0x%0h", m_ram_end);
        $display("Block StartAddr = 0x%0h", m_start_addr);
        $display("Block EndAddr   = 0x%0h", m_end_addr);
        $display("Block Size      = %0d bytes", m_block_size);
    endfunction

endclass

module tbMemBlock;
    initial begin 
        MemoryBlock mb = new;
        mb.m_ram_start = 32'h0;
        mb.m_ram_end   = 32'h7FF;
        mb.randomize();
        mb.display();
    end
endmodule