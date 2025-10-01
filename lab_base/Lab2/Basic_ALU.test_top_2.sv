/************************************************************/
/*															*/
/*	AUTHOR: Meeta Yadav										*/									
/*															*/
/*  DESCRIPTION: LAB2 for ECE745							*/
/*															*/
/*	DATE: September 10, 2009								*/
/*															*/
/*	OTHER FILES: DUT: Basic_ALU.v, 							*/
/*				 INTERFACE: Basic_ALU.if.sv					*/
/*				 TESTBENCH: Basic_ALU.tb.sv					*/
/*				 TOP:Basic_ALU.test_top.sv					*/
/************************************************************/
module Basic_ALU_test_top;
	parameter simulation_cycle = 10;

	reg  SysClock;
	Basic_ALU_interface top_io(SysClock);
	Basic_ALU_test test(top_io);   
	Basic_ALU dut(
		.clock	(top_io.clock), 
		.reset	(top_io.reset), 
		.enable (top_io.enable),
		.aluin1(top_io.aluin1),   
		.aluin2(top_io.aluin2),
		.aluoperation(top_io.aluoperation),
		.aluopselect(top_io.aluoperation),
		.aluout	(top_io.aluout)
	);

	initial 
	begin
		SysClock = 0;
		forever 
		begin
			#(simulation_cycle/2)
			SysClock = ~SysClock;
		end
	end
endmodule
