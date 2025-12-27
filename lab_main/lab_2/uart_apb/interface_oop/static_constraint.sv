class ABC3;
    rand bit [3:0]      a;

    constraint c1 { a > 5; }
    constraint c2 { a < 12; }
endclass

module tb_ABC_3;
    initial begin
        ABC3 obj1 = new;
        ABC3 obj2 = new;
        for (int i = 0; i < 5; i++) begin 
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end
endmodule