module design_ex (input clk, reqA, reqB, in);

    always @(posedge clk) begin
        assert (reqA || reqB) else $error("Assertion failed!");
        assert (in == 0) else $warning("Assertion warning for in == 0!");
    end
endmodule