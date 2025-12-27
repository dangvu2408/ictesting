class ABC1;
    rand bit [3:0] arr [5];

    constraint c_array { foreach (arr[i]) {
            arr[i] == i;
        }
    }
endclass

module tb_ABC_1;
    initial begin
        ABC1 abc1 = new;
        abc1.randomize();
        $display("array = %p", abc1.arr);
    end
endmodule