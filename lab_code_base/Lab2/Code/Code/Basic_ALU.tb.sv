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



//------------------------------------------------------------
// PROGRAM DECLARATION
//------------------------------------------------------------

program Basic_ALU_test	(Basic_ALU_interface.TB ALU_Interface);

	parameter reg_wd=32;
	parameter	[0:3] 
				ADD	= 8'b001,
				SUB	= 8'b010,
				NOT	= 8'b011,
				AND	= 8'b100,
				OR	= 8'b101,
				XOR	= 8'b110;
	
//-------------------------------------------------------------
//	CLASS  DECLARATION
//-------------------------------------------------------------
	
	class Instruction;
		rand reg	[reg_wd-1:0] 		src1;		 
		rand reg	[reg_wd-1:0] 	src2;		 
		rand reg	[2:0] 	alu_operation;	
		int count;
		
	constraint Limit {
		src1 inside	{[0:65534]};
		src2 inside	{[0:65534]};
		alu_operation inside{[1:5]};
	}
		
	endclass

//------------------------------------------------------------------
//	CLASS HANDLE DECLARATION AND ALLOCATION and variable declaration
//------------------------------------------------------------------
	
	Instruction inst2send=new();
	Instruction inst_sent=new();
	Instruction inst2cmp=new();
	
	Instruction GenInstructions[];
	Instruction Inputs[$];
	
	logic [reg_wd:0]	aluout2cmp;
	logic [reg_wd:0]	aluout_q[$];
	
	int count=0;
	int run_n_times;
	int number_instructions=0;
	int instructions_sent;
	int instruction_created=0, instruction_rcvd=0;
	int i,j;
	
	logic [reg_wd-1:0] aluin2, aluin1;
	logic [reg_wd:0]aluout_cmp, aluout_q_val;
	 
	
	
//-------------------------------------------------------------
//	INITIAL  BLOCK
//-------------------------------------------------------------
	
	initial begin
		reset();
		repeat(5) begin
			$display($time, "ns: Creating Another Instruction");
			gen();
			fork
				send();
				recv();
			join
			check();
		end
		repeat(5)@(ALU_Interface.cb);
	end

//------------------RESET TASK----------------------------------

	task reset();
		$display ($time, "ns: RESET START");
		ALU_Interface.reset 		<= 1'b1; 
	  	ALU_Interface.cb.enable 	<= 1'b0; 
		repeat(5) @(ALU_Interface.cb);
		ALU_Interface.cb.enable 	<= 1'b1;
		ALU_Interface.reset 		<= 1'b0;
		$display ($time, "ns: RESET END");
	endtask

//------------------GENERATE TASK---------------------------------	

	task gen();
		number_instructions=10;
		GenInstructions=new[number_instructions];
		$display($time,"ns: ~~~[GENERATE] GENERATE STARTED CREATING INSTRUCTIONS~~~");
		
		for (i=0; i<number_instructions; i++) begin
			GenInstructions[i]=new();
		end
		
		for (i=0; i<number_instructions; i++) begin
			if(!inst2send.randomize()) begin
				$display("randomization failed");
			end
			GenInstructions[i].src1=inst2send.src1;
			GenInstructions[i].src2=inst2send.src2;
			GenInstructions[i].alu_operation=inst2send.alu_operation;
			
			//-----------------display statements--------------------
			$display("[GENERATE] Instruction Number Created: %d", instruction_created);
			$display("Instruction ALU OPERATION: %d",
			inst2send.alu_operation);
			$display("Instruction SRC1: %d", inst2send.src1);
			$display("Instruction SRC2: %d", inst2send.src2);

			//--------------------------------------------------------
			
			instruction_created=instruction_created+1;
		end
		$display($time,"ns: ***[GENERATE] GENERATE FINISHED CREATING INSTRUCTIONS***");
	endtask
	
//------------------SEND TASK----------------------------------------

	task send();
		send_payload();
	endtask
	
//------------------SENDPAYLOAD TASK---------------------------------
	task send_payload();
		$display($time,"ns: ~~~[DRIVER] START SENDING PAYLOAD~~~");
		instructions_sent=0;
		foreach(GenInstructions[i]) begin
			inst2send=GenInstructions[i];
			ALU_Interface.cb.aluin1<=inst2send.src1;
			ALU_Interface.cb.aluin2<=inst2send.src2;
			ALU_Interface.cb.aluoperation<=inst2send.alu_operation;
			
			$display($time,"ns [SEND]Instruction Number Sent:%d", instructions_sent);
			$display("Instruction ALU OPERATION: %d",inst2send.alu_operation);
			$display("Instruction SRC1: %d", inst2send.src1);
			$display("Instruction SRC2: %d", inst2send.src2);
			
			Inputs.push_back(inst2send);
			
			instructions_sent++;
			@(ALU_Interface.cb);		
		end
		GenInstructions.delete();
		$display($time,"ns: ***[DRIVER] SENDING INSTRUCTIONS ENDS***");
	endtask
	
//------------------RECEIVE TASK---------------------------------------
	task recv();
		$display($time,"ns: ~~~[RECEIVER] RECEIVING PAYLOAD BEGINS~~~");
		@(ALU_Interface.cb);
		repeat(number_instructions)
		begin
			@(ALU_Interface.cb);
			get_payload();
			$display($time, "ns [RECEIVER -> GETPAYLOAD] Payload Obtained for instruction %d",instruction_rcvd);
			$display($time, "ns [RECEIVER -> GETPAYLOAD] ALUOUT = %d",aluout2cmp);
			instruction_rcvd++;
		end
		$display($time,"ns:***[RECEIVER] RECEIVING PAYLOAD ENDS***");
	endtask

//------------------PAYLOAD TASK-----------------------------------------
	task get_payload();
		aluout2cmp=ALU_Interface.cb.aluout;
		aluout_q.push_back(aluout2cmp);
	endtask
	
//------------------CHECK TASK--------------------------------------------
	task check();
		repeat(2) @(ALU_Interface.cb);
		$display($time,"ns: ~~~ [CHECKER] Checker Start");
		foreach(aluout_q[i]) begin
			$display($time, "ns [RECEIVER -> GETPAYLOAD] ALUOUT in Q = %d", aluout_q[i]);
		end
		aluout_q_val=0;
		aluout_cmp=0;
		while (Inputs.size()!=0) begin                            
			inst_sent=Inputs.pop_front();
			/*$display($time, "ns [CHECKER] Instruction Content: src1=%d,
		
src2=%d,aluoperation=%d",inst_sent.src1,inst_sent.src2,inst_sent.alu_operation);*/
			check_arith();
		end
	endtask                                           
	
//------------------CHECK ARITH TASK--------------------------------------	

	task check_arith();
		case(inst_sent.alu_operation)
       			ADD : 	begin	aluout_cmp = inst_sent.src1 + inst_sent.src2; end
       			SUB: 	begin   aluout_cmp = inst_sent.src1 - inst_sent.src2; end 
       			NOT: 	begin   aluout_cmp = {1'b0, {~inst_sent.src2}};    	end 
       			AND: 	begin   aluout_cmp = {1'b0,{inst_sent.src1 & inst_sent.src2}};    	end
       			OR: 	begin   aluout_cmp = {1'b0,{inst_sent.src1 | inst_sent.src2}};    	end
       			XOR: 	begin   aluout_cmp = {1'b0,{inst_sent.src1 ^ inst_sent.src2}};      end
       			endcase
		aluout_q_val=aluout_q.pop_front();
		$display($time, "ns: [CHECKER] ALU Result from DUT = %d and ALU Result from Model= %d", aluout_q_val, aluout_cmp); 
		if(aluout_q_val==aluout_cmp) begin
			$display(":):):):):):):) RESULTS MATCHED :):):):):):):)"); end
		else begin
			$display(":|:|:|:|:|:|:| RESULTS MATCHED :|:|:|:|:|:|:|"); end
	endtask
	
endprogram
