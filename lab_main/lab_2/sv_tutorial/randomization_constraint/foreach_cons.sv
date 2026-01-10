class ABCABCABC;
    rand bit [3:0] array [5];
    constraint c_mode { foreach (array[i]) {
            array[i] == i;
        } 
    }
    
endclass

module tb_cons_5;
    ABCABCABC abc;
    initial begin
        abc = new;
        $display("array = %p", abc.array);
    end
endmodule