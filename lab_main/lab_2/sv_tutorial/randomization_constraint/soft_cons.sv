class ABC;
    rand bit [3:0] data;
    constraint c_data { soft data >= 4; data <= 12; }
    
endclass

module tb_cons_3;
    ABC abc;
    initial begin
        abc = new;
        for (int i = 0; i < 5; i++) begin
            abc.randomize() with { data == 2; };
            $display("abc = 0x%0h", abc.data);
        end
    end
endmodule