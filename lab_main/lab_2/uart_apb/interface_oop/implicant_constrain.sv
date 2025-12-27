class ABC;
    rand bit [2:0] mode;
    rand bit [3:0] len;

    constraint c_mode { mode == 2 -> len > 10; }
endclass

module tb_ABC;
    initial begin
        ABC abc = new;
        for (int i = 0; i < 10; i++) begin
            abc.randomize();
            $display("mode = %0d, len = %0d", abc.mode, abc.len);
        end
    end
endmodule