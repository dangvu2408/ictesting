module test_compare;
    logic [3:0] sig1 = 4'b0101;
    logic [3:0] sig2 = 4'b01XZ;

    initial begin
        $display("sig1 = %b, sig2 = %b", sig1, sig2);

        // 1. So sánh bình thường (==)
        if (sig1 == sig2)
            $display("// true"); 
        else 
            $display("// false"); // 1

        // 2. So sánh với don't-care (===?)
        if (sig1 ===? sig2)
            $display("// true"); 
        else 
            $display("// false"); // 2

        // 3. So sánh với hằng số don't-care
        if (sig1 ===? 4'b?1?1)
            $display("// true"); 
        else 
            $display("// false"); // 3

        // 4. So sánh strict equality (===)
        if (sig1 === sig2)
            $display("// true"); 
        else 
            $display("// false"); // 4

        // 5. So sánh khác với don't-care (!=?)
        if (sig1 !=? sig2)
            $display("// true"); 
        else 
            $display("// false"); // 5
    end
endmodule
