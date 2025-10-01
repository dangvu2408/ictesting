module mux21 #parameter (bitwidth = 32) (
	input [bitwidth-1:0] in0, // in0, in1 là tín hiệu 32 bit không cần quan tâm đến ý nghĩa vật lý/thông tin
	input [bitwidth-1:0] in1, 
	input select, // select là tín hiệu điều khiển đưa đầu vào in0 hay in1 ra y
	output reg [bitwidth-1:0] y, // đầu ra 32 bit
	);
	
	// dùng mô hình dòng dữ liệu để mô tả biểu thức quan hệ vào - ra 
	// trong verilog là phép gán liên tục (continuous assignment)
	// assign y = (select == 0)?in0:in1;
	// Phép gán liên tục có nghĩa là nó mô tả hoạt động xảy ra liên tục bất cứ khi nào select, in0, in1 thay 
	// đổi thì y sẽ được tính toán lại (bằng mạch/bằng phần mềm mô phỏng) để lấy giá trị mới
	
	// dùng mô hình hành vi để mô tả cách tính đầu ra từ đầu vào 
	// trong verilog là dùng khối lệnh always 
	always @(select or in0 or in1)
	begin
		if (select == 0)
			y = in0;
		else
			y = in1;
	end 
endmodule 

module bin2_7seg
(
	input [3:0] bin;
	output reg [6:0] seg;
)
	always @(bin)
	begin
		case (bin)
		0: seg = 7'b1111110;
		1: seg = 7'b
		2: 
		3:
		4:
		5:
		6:
		7:
		8:
		9:
		10:
		11:
		12:
		13:
		14:
		15:
		default:
		endcase 
	end 
endmodule 

module testmux21 ()

	// khai báo các biến mà sẽ được gán giá trị trong khối initial hoặc always 
	// -> dùng kiểu reg
	reg [7:0] in0_8bit, in1_8bit, y_8bit;  
	// khai báo các biến mà sẽ được gán giá trị trong câu lệnh assign 
	// -> dùng kiểu biến wire
	// các dây dẫn dùng để nối các khối -> dùng biến kiểu wire
	wire [63:0] in0_64bit, in1_64bit, y_64bit;
	reg select;
	
	mux21 #(bitwidth = 8) dut8bit (.in0(in0_8bit),.in1(in1_8bit),.y(y_8bit),.select(select));
	mux21 #(bitwidth = 64) dut64bit (.in0(),.in1(),

	initial // đây là khối lệnh không được tổng hợp -> chỉ dùng trong testbench 
	// -> được thực hiện 1 lần duy nhất khi mô phỏng thiết kế 
	begin
		in0_8bit = 16; // dùng các câu lệnh gán blocking trong khối initial 
		in1_8bit = 15; 
		select = 1;
	end 
endmodule 


module cpu (
	input clk,
	output [31:0] pc,
	output read_ins,
	input [31:0] ins,
	input [31:0] d_v
	);
	
module memory (
	input clk, 
	output [31:0] do,
	output data_valid,
	input [31:0] addr,
	input addr_valid
	);
	
module cpu_memory (
);
	// mô hình cấu trúc để mô tả sơ đồ khối của hệ thống/mạch
	wire [31:0] pc2addr;
	wire [31:0] do2ins;
	cpu core1 (.clk(clk)
				.pc(pc2addr),
				.read_ins
				.ins(do2ins),
				.d_v 
				);
				
	memory mem (.clk(clk),
				.do (do2ins),
				.data_valid
				.addr (pc2addr)
				addr_valid 
				);

endmodule 

module counter(
		input clk, 
		input rst_n, 
		input up, down, 
		output [4:0] counter
		output eq_7);
	reg [4:0] counter;
	wire eq_7;
	
	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n == 0)
			counter <= 0; // non-blocking assignment 
		else 
			counter <= counter + 1;
	end 
	assign eq_7 = (counter == 7);
	
	// bai tap mo rong thanh bo dem up/down/giu nguyen gia tri
	// mo rong thanh bo dem n bit va dem den max la 1 parameter max_val
endmodule 

module fsm (
	input clk,
	input rst_n,
	input x,
	output y)
	
	// mã hóa trạng thái
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	
	reg [1:0] next_v, v;
	
	always @(v or x)
	begin
		case (v)
		s0: if (x == 0) next_v = s0;
			else next_v = s1;
		
		s1: if (x == 0) next_v = s1;
			else next_v = s2;
			
		s2: if (x == 1) next_v = s2;
			else next_v = s0;
			
		default: next_v = v;
		endcase
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if (rst_n == 0)
			v <= s0;
		else
			v <= next_v;
		end
	end 
	
	always @(v or x)
	begin 
		if ((v==s2) && (x==0)) y = 1;
		else y = 0;
	end 
	
endmodule 

// Bai tap: viet verilog cho thanh ghi dịch, cho bộ biến đổi nối tiêp - song song 
// Viết verilog cho bộ nhận dạng chuỗi bit 1011, 1010, 0111, ...
// Viết verilog cho khối điều khiển đèn giao thông

// code testbench

module testbench()

	fsm fsm_uv(
		.clk(clk1),
		.rst_n(rst_n1),
		.x(x1),
		.y(y1)
		);
	reg clk1, x1, y1, rst_n;
	reg [1:0] v; 
	// mã hóa trạng thái
	localparam s0 = 2'b00;
	localparam s1 = 2'b01;
	localparam s2 = 2'b10;
	
	initial begin
		clk1 = 1;
		forever #5 clk1 = ~clk1;
	end 
	
	// initial $monitor("t=%t, x=%d, y=%d\n",$time, x1, y1);
	
	
	initial 
	begin
		rst_n = 1;
		int delay = random();
		#delay rst_n = 0;
		#3 rst_n = 1;
	end 
	// generate input
	always @(posedge clk1)
	begin
		x1 <= random();
	end 
	
	// tao lai mach trong testbench de tinh golden_output 
	always @(posedge clk1 or negedge rst_n1)
	begin
		if (~rst_n1)
			v <= s0;
		else 
		begin
		case (v)
		s0: if (x == 0) v <= s0;
			else v <= s1;
		
		s1: if (x == 0) v <= s1;
			else v <= s2;
			
		s2: if (x == 1) v <= s2;
			else v <= s0;
			
		default: v <= v;
		endcase
		end
	end
	// sinh ra golden output 
	assign golden_y = ((v==s2) && (x==0));
	// so sanh va bao loi
	always @(golden_y or y1)
	begin
		if (golden_y != y1)
			$display("FAIL @ %t: x1=%d, v=%d, y1=%d, golden_y = %d\n", 
				$time, x1, v, y1, golden_y);
	end 
	
endmodule 

module testbench;
  
  initial 
    begin
      fork
        // khoi lenh 1
        begin
          #40 $display("[%0t] khoi lenh 1", $time);
        end
        // khoi lenh 2
        begin
          #20 $display("[%0t] khoi lenh 2-lenh1", $time);
          #50 $display("[%0t] khoi lenh 2-lenh2", $time);
        end
        // khoi lenh 3
        begin
          #60 $display("[%0t] khoi lenh 3", $time);
        end
      join 
      $display("[%0t] fork join exit", $time);
    end
endmodule 

interface cpu2mem (input clk, input rst_n);
  logic [31:0] addr;
  logic read;
  logic [31:0] data;
  logic valid;
  modport cpu_port(input clk, rst_n, data, valid, output addr, read);
  modport mem_port(input clk, rst_n, addr, read, output data, valid);
endinterface

module cpu (cpu2mem cpuIf);
  reg [31:0] pc;
  reg [31:0] ins;
  
  always @(posedge cpuIf.clk or negedge cpuIf.rst_n)
  begin
    if (!cpuIf.rst_n)
      begin
  		pc <= 0;
        cpuIf.read <= 1;
      end
    else if (cpuIf.valid) begin
      cpuIf.addr <= pc+4;
      pc <= pc+4;
      ins <= cpuIf.data;
      cpuIf.read <= 1;    
    end 
    else begin
      cpuIf.addr <= pc;
      pc <= pc;
      cpuIf.read <= 0;
    end
    
  end 
endmodule 

module mem(cpu2mem memIf);
  reg [31:0] mem [0:100];
  int i;
  always @(posedge memIf.clk or negedge memIf.rst_n)
  begin
    if (!memIf.rst_n)
      begin
        for (i=0;i<100;i++) mem[i] <= $random;
        memIf.valid <= 0;
      end
    else if (memIf.read) begin
      memIf.data <= mem[memIf.addr];
      memIf.valid <= 1;
    end 
    else
    begin
      memIf.data <= 0;
      memIf.valid <= 0;
    end
  end 
endmodule 

module tb;
  bit clk, rst_n;
  cpu2mem top_if(clk, rst_n);
  cpu cpu1(top_if.cpu_port);
  mem mem1(top_if.mem_port);
  initial 
    begin
      clk <= 0;
      forever #10 clk = ~clk;
    end 
  
  initial begin
    rst_n <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    
    repeat (20) @(posedge clk);
    $finish;
  end 
  initial begin 
      // Dump waves
    $dumpvars(0, tb);
    $dumpfile("dump.vcd");
  end

endmodule