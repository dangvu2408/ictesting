// Variable memory partitions with space in between

class MemoryBlock4;
    bit [31:0] m_ram_start;
    bit [31:0] m_ram_end;

    rand bit m_num_part;
    rand bit [31:0] m_part_start[];
    rand int m_part_size[];
    rand int m_space[];
    rand int m_tmp;

    constraint c_parts {
        m_num_part > 4;
        m_num_part < 10;
    };

    constraint c_size {
        m_part_size.size() == m_num_part;
        m_space.size() == m_num_part - 1;
        m_space.sum() + m_part_size.sum() == m_ram_end - m_ram_start + 1;
        foreach (m_part_size[i]) {
            m_part_size[i] inside { 16, 32, 64, 128, 512, 1024 };
            if (i < m_space.size())
                m_space[i] inside { 0, 16, 32, 64, 128, 512, 1024 };
        }
    }

    constraint c_part {
        m_part_start.size() == m_num_part;
        foreach (m_part_start[i]) {
            if (i) m_part_start[i] == m_part_start[i - 1] + m_part_size[i - 1] + m_space[i - 1];
            else m_part_start[i] == m_ram_start;
        }
    }

    function void display();
        $display("---Memory Block---");
        $display("RAM StartAddr   = 0x%0h", m_ram_start);
        $display("RAM EndAddr     = 0x%0h", m_ram_end);
        $display("Partitions      = %0d", m_num_part);
        $display("--- Partitions ---");
        foreach (m_part_start[i]) 
            $display("Partitions %0d start = 0x%0h, size = %0d bytes, space = %0d bytes", i, m_part_start[i], m_part_size[i], m_space[i]);
    endfunction

endclass

module tb_cons_12;
    initial begin 
        MemoryBlock4 mb = new;
        mb.m_ram_start = 32'h0;
        mb.m_ram_end   = 32'h7FF;
        mb.randomize();
        mb.display();
    end
endmodule