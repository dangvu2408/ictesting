// Burst [ 0 -> 1 byte, 1 -> 2 bytes, 2 -> 3 bytes, 3 -> 4 bytes]
// Length -> tối đa 8 giao dịch mỗi đợt burst
// Giao thức mong đợi chỉ gửi địa chỉ đầu tiên, Slave tự tính các địa chỉ tiếp theo

class BusTransaction;
    rand int        m_addr;   // Địa chỉ (address)
    rand bit [31:0] m_data;   // Dữ liệu (data)
    rand bit [1:0]  m_burst;  // Kích thước mỗi giao dịch (1-4 bytes)
    rand bit [2:0]  m_length; // Tổng số giao dịch (1-8)

    // Ràng buộc địa chỉ luôn chia hết cho 4 (4-byte boundary)
    constraint c_addr { m_addr % 4 == 0; } 

    function void display(int idx = 0);
        $display("------ Transaction %0d------", idx);
        $display(" Addr   = 0x%0h", m_addr);
        $display(" Data   = 0x%0h", m_data);
        $display(" Burst  = %0d bytes/xfr", m_burst + 1);
        $display(" Length = %0d", m_length + 1);
    endfunction
endclass

module tbBusTrans;
    int            slave_start; // Địa chỉ bắt đầu của slave
    int            slave_end;   // Địa chỉ kết thúc của slave
    BusTransaction bt;          // Đối tượng giao dịch bus

    initial begin
        slave_start = 32'h200; 
        slave_end   = 32'h800; 
        bt = new(); 

        // Randomize với ràng buộc nội dòng (inline constraints)
        bt.randomize() with { 
            m_addr >= slave_start;
            m_addr < slave_end;
            // Đảm bảo toàn bộ độ dài burst không vượt quá giới hạn của slave
            (m_burst + 1) * (m_length + 1) + m_addr < slave_end;
        }; 
        
        bt.display(); 
    end
endmodule