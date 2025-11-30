`timescale 1ns/1ps

module delay_1810;
  
  reg  b, c; 
  reg  d, e; 
  reg  a, f;    // đổi sang reg để gán trong always

  always @(b or c) begin
    a <= #1 (b & c);
    f <= #1 (b & c);

    $display("@t=%0t: always triggered (b=%b, c=%b)", $time, b, c);
    
    d = #3 b & c;
    $display("@t=%0t: ... 'd' delayed 3ns", $time);
    
    #3 e = b & c;
    $display("@t=%0t: ... 'e' delayed another 3ns", $time);
  end

  initial begin
    $display("=== Delay Simulation Start ===");
    $monitor("Time=%0t | b=%b c=%b | a=%b f=%b | d=%b e=%b",
             $time, b, c, a, f, d, e);

    b = 0; c = 0; d = 0; e = 0;

    #5;
    $display("@t=%0t: -> b = 1", $time);
    b = 1;

    #5;
    $display("@t=%0t: -> c = 1", $time);
    c = 1;

    #5;
    $display("@t=%0t: -> b = 0", $time);
    b = 0;

    #15;
    $display("@t=%0t: --- Simulation End ---", $time);
    $finish;
  end

endmodule