// Equal partitions of memory

class MemoryBlock2;
    bit [31:0] m_ram_start;
    bit [31:0] m_ram_end;

    rand int m_num_part;
    rand bit [31:0] m_part_start[];
    rand int m_part_size;

    constraint c_parts {
        m_num_part > 4;
        m_num_part < 10;
    }

    constraint c_size {
        (m_ram_end - m_ram_start + 1) % m_num_part == 0;
        m_part_size == (m_ram_end - m_ram_start + 1) / m_num_part;
    }

    constraint c_part {
        m_part_start.size() == m_num_part;

        foreach (m_part_start[i]) {
            if (i == 0)
                m_part_start[i] == m_ram_start;
            else
                m_part_start[i] == m_part_start[i - 1] + m_part_size;
        }
    }

    function void display();
        $display("---Memory Block---");
        $display("RAM StartAddr   = 0x%0h", m_ram_start);
        $display("RAM EndAddr     = 0x%0h", m_ram_end);
        $display("Partitions      = %0d", m_num_part);
        $display("Partition Size  = %0d bytes", m_part_size);
        foreach (m_part_start[i])
            $display("Partition %0d start = 0x%0h", i, m_part_start[i]);
    endfunction
endclass


module tb_cons_10;
    MemoryBlock2 mb;

    initial begin
        mb = new();
        mb.m_ram_start = 32'h0;
        mb.m_ram_end   = 32'h7FF;

        if (!mb.randomize())
            $fatal("Randomization failed");

        mb.display();
    end
endmodule
