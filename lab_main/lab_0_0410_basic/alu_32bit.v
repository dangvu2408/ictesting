module alu_32bit (
  input  wire [31:0] src1,
  input  wire [31:0] src2,
  input  wire [2:0]  alu_op,
  output wire [31:0] res,
  output wire        overflow
);

  localparam OP_ADD  = 3'b000;
  localparam OP_AND  = 3'b001;
  localparam OP_OR   = 3'b010;
  localparam OP_XOR  = 3'b011;
  localparam OP_SUB  = 3'b100;
  localparam OP_MUL  = 3'b101;
  localparam OP_SLL  = 3'b110; 
  localparam OP_SRL  = 3'b111; 

  wire [31:0] add_res  = src1 + src2;
  wire [31:0] sub_res  = src1 - src2;
  wire [63:0] mul_res  = $signed(src1) * $signed(src2);
  wire [31:0] and_res  = src1 & src2;
  wire [31:0] or_res   = src1 | src2;
  wire [31:0] xor_res  = src1 ^ src2;
  wire [31:0] sll_res  = src1 << src2[4:0];
  wire [31:0] srl_res  = src1 >> src2[4:0];

  wire add_ovf = (src1[31] & src2[31] & ~add_res[31]) |
                 (~src1[31] & ~src2[31] & add_res[31]);

  wire sub_ovf = (src1[31] & ~src2[31] & ~sub_res[31]) |
                 (~src1[31] & src2[31] & sub_res[31]);

  wire mul_ovf = (mul_res[63:32] != {32{mul_res[31]}});

  assign res = (alu_op == OP_ADD) ? add_res  :
               (alu_op == OP_AND) ? and_res  :
               (alu_op == OP_OR)  ? or_res   :
               (alu_op == OP_XOR) ? xor_res  :
               (alu_op == OP_SUB) ? sub_res  :
               (alu_op == OP_MUL) ? mul_res[31:0] :
               (alu_op == OP_SLL) ? sll_res  :
               (alu_op == OP_SRL) ? srl_res  :
                                    32'b0;

  assign overflow = (alu_op == OP_ADD) ? add_ovf :
                    (alu_op == OP_SUB) ? sub_ovf :
                    (alu_op == OP_MUL) ? mul_ovf :
                    1'b0;

endmodule
