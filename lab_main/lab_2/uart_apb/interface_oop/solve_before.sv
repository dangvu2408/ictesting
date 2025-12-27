class ABC2;
    rand bit       a;
    rand bit [1:0] b;

    constraint c_ab { 
        a -> b == 3'h3;
        solve b before a;
    }
endclass

module tb_ABC_2;
    initial begin
        ABC2 abc2 = new;
        for (int i = 0; i < 10; i++) begin 
            abc2.randomize();
            $display("a = %0d, b = %0d", abc2.a, abc2.b);
        end
    end
endmodule