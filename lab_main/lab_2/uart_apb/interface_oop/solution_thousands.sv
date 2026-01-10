class Imp1;
    rand bit       x;
    rand bit [1:0] y;

    constraint c_xy { (x == 0) -> y == 0; }
endclass

module tb_Imp1;
    initial begin 
        Imp1 imp1 = new;
        int count[8] = '{default:0};

        for (int i = 0; i < 10001; i++) begin 
            imp1.randomize();
            count[{imp1.x, imp1.y}]++;
            $display("imp1.x = %0d, imp2.y = %0d", imp1.x, imp1.y);
        end

        foreach (count[i]) 
            $display("Solution %c: %0d", 8'h41 + i, count[i]);
    end
endmodule

// gen 10000 giá trị x, y, điền vào bảng
