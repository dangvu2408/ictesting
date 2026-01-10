class ABCABCABCABC;
    rand bit [3:0] darray [];
    rand bit [3:0] queue [$];
    constraint c_qsize { queue.size() == 5; }
    constraint c_array { foreach (darray[i]) darray[i] == i;
                         foreach (queue[i]) queue[i] == i + 1; }
    
    function new();
        darray = new[5];
    endfunction
endclass

module tb_cons_6;
    ABCABCABCABC abc;
    initial begin
        abc = new;
        $display("array = %p queue = %p", abc.darray, abc.queue);
    end
endmodule