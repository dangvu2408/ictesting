`timescale 1ns / 100fs   

module adder4bit_tb;

  reg [8:0] stim;       
  wire [3:0] S;         
  wire C4;              

  adder4bits adder4bit_DUT (
      .a(stim[8:5]),
      .b(stim[4:1]),
      .ci(stim[0]),
      .s(S),
      .co(C4)
  );

  reg [4:0] expected;  

  initial begin
      stim = 9'b0000_0000_0;  
      #10 stim = 9'b1111_0000_1; 
      #10 stim = 9'b0000_1111_1; 
      #10 stim = 9'b1111_0001_0; 
      #10 stim = 9'b0001_1111_0; 
      #10 $stop;   
  end

  initial
    $monitor("%t | a=%d b=%d ci=%b | s=%d co=%b",
             $time, stim[8:5], stim[4:1], stim[0], S, C4);

  always @(stim or S or C4) begin
      expected = stim[8:5] + stim[4:1] + stim[0]; 
      #1;  

      if ({C4, S} !== expected) begin
          $display("[ERROR @ %0t ns] a=%b b=%b ci=%b → DUT={co,s}=%b%b, expected=%b",
                   $time, stim[8:5], stim[4:1], stim[0], C4, S, expected);
      end
      else begin
          $display("[PASS  @ %0t ns] a=%b b=%b ci=%b → result OK (%b%b)",
                   $time, stim[8:5], stim[4:1], stim[0], C4, S);
      end
  end

endmodule
