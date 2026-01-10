module _assertion;
    bit a, b, c, d;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 20; i++) begin
            {a, b, c, d} = $random;
            $display("%0t a=%0d b=%0d c=%0d d=%0d", $time, a, b, c, d);
            @(posedge clk);
        end
        #10 $finish;
    end

    sequence s_ab;
        a ##1 b;
    endsequence

    sequence s_cd;
        c ##2 d;
    endsequence

    property p_expr;
        @(posedge clk) s_ab ##1 s_cd;
    endproperty

    assert property (p_expr);

endmodule


/*
# 0 a=0 b=1 c=0 d=0
# 10 a=0 b=0 c=0 d=1
# ** Error: Assertion error.
#    Time: 10 ns Started: 10 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 30 a=1 b=0 c=0 d=1
# ** Error: Assertion error.
#    Time: 30 ns Started: 30 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 50 a=0 b=0 c=1 d=1
# 70 a=1 b=1 c=0 d=1
# ** Error: Assertion error.
#    Time: 70 ns Started: 70 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Error: Assertion error.
#    Time: 70 ns Started: 50 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 90 a=1 b=1 c=0 d=1
# 110 a=0 b=1 c=0 d=1
# 130 a=0 b=0 c=1 d=0
# ** Error: Assertion error.
#    Time: 130 ns Started: 130 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Error: Assertion error.
#    Time: 130 ns Started: 90 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 150 a=0 b=0 c=0 d=1
# ** Error: Assertion error.
#    Time: 150 ns Started: 150 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 170 a=1 b=1 c=0 d=1
# ** Error: Assertion error.
#    Time: 170 ns Started: 170 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 190 a=0 b=1 c=1 d=0
# 210 a=1 b=1 c=0 d=1
# ** Error: Assertion error.
#    Time: 210 ns Started: 210 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 230 a=1 b=1 c=0 d=1
# ** Error: Assertion error.
#    Time: 230 ns Started: 190 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 250 a=1 b=1 c=0 d=0
# 270 a=1 b=0 c=0 d=1
# ** Error: Assertion error.
#    Time: 270 ns Started: 230 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 290 a=0 b=1 c=1 d=0
# ** Error: Assertion error.
#    Time: 290 ns Started: 270 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Error: Assertion error.
#    Time: 290 ns Started: 250 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 310 a=0 b=1 c=0 d=1
# ** Error: Assertion error.
#    Time: 310 ns Started: 310 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 330 a=1 b=0 c=1 d=0
# ** Error: Assertion error.
#    Time: 330 ns Started: 330 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Error: Assertion error.
#    Time: 330 ns Started: 290 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# 350 a=0 b=1 c=0 d=1
# 370 a=0 b=1 c=1 d=1
# ** Error: Assertion error.
#    Time: 370 ns Started: 370 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Error: Assertion error.
#    Time: 390 ns Started: 390 ns  Scope: _assertion File: D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv Line: 28
# ** Note: $finish    : D:/backup_later/ET4356/QuestaSim/lab_main/lab_2/uart_apb/sv_assertion/assertion.sv(13)
#    Time: 400 ns  Iteration: 0  Instance: /_assertion
*/