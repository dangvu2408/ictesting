class ABC3;
    rand bit [3:0]      a;

    constraint c1 { a > 5; }
    static constraint c2 { a < 12; }
endclass

module tb_cons_8;
    initial begin
        ABC3 obj1 = new;
        ABC3 obj2 = new;

        obj1.c1.constraint_mode(0);
        // obj1.c2.constraint_mode(0);

        for (int i = 0; i < 5; i++) begin 
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end
endmodule