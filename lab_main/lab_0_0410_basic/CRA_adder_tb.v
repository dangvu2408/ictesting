module CRA_adder_tb;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] Sum;
    wire  Cout;
    CRA_adder #(4) uut (
        .A(A), .B(B), .Cin(Cin),
        .Sum(Sum), .Cout(Cout)
    );
    initial begin
        $display("Time | A | B | Cin | Sum | Cout");
        $monitor("%4t | %b | %b |  %b  | %b  |  %b", $time, A, B, Cin, Sum, Cout);
        A=4'b0001; B=4'b0011; Cin=0; #10;  // 1 + 3 = 4
        A=4'b1010; B=4'b0111; Cin=0; #10;  // 10 + 7 = 17
        A=4'b1111; B=4'b0001; Cin=0; #10;  // 15 + 1 = 16
        A=4'b1001; B=4'b1001; Cin=1; #10;  // 9 + 9 + 1 = 19
        $finish;
    end
endmodule
