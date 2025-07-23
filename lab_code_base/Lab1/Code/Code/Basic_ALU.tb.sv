/********************************************************************/ 
/*                                                                  */
/*  CODE: 	 	 Lab 1 FOR ECE745                           		*/
/*	  	                                                    		*/
/*  DESCRIPTION: A Simple ALU Testbench							    */
/*                       											*/
/*  DATE:        August 8, 2009                                     */
/*             				                                        */
/********************************************************************/

//------------------------------------------------------------
// PROGRAM DECLARATION
//------------------------------------------------------------

program Basic_ALU_test(Basic_ALU_interface.TB ALU_Interface);
	
	parameter   reg_wd    	= 32;

	reg	[reg_wd-1:0] 	payload_aluin1[$];		
	reg	[reg_wd-1:0] 	payload_aluin2[$];			
	reg [2:0]			alu_operation, alu_opselect;
	reg [reg_wd:0]		aluout;

	int 	count = 0;
	int 	run_n_times;		// number of packets to test
	
//------------------------------------------------------------
// MAIN CODE
//------------------------------------------------------------	
	
	initial begin
		run_n_times = 5;
		reset();
		repeat(run_n_times) begin
		$display($time, "ns: Creating Another Payload Queue");
		gen();
		send();
		end
    	repeat(5) @(ALU_Interface.cb);
		$finish;
  	end

//------------------------------------------------------------
//	RESET TASK
//------------------------------------------------------------
	task reset();
		$display($time, "ns: RESET BEGIN");		
		ALU_Interface.reset 				<= 1'b1;
		ALU_Interface.cb.enable 			<= 1'b0;
		repeat(5) @(ALU_Interface.cb);
		ALU_Interface.reset 				<= 1'b0;
		ALU_Interface.cb.enable 			<= 1'b1;
		$display($time, "ns: RESET END");
	endtask


//------------------------------------------------------------
//	GENERATE PACKETS
//------------------------------------------------------------

	task gen();
		//generate an arbitrary number of payloads
		repeat(6)
		begin 
			$display($time, "ns:  [GENERATE] Created Payload Packet");
			payload_aluin1.push_back($random);
			payload_aluin2.push_back($random);
			//$display($time, "ns: [GENERATE] aluin1= %p", payload_aluin1);
			//$display($time, "ns: [GENERATE] aluin2= %p", payload_aluin2);
		end
	endtask

//-------------------------------------------------------------
//	SEND PAYLOAD
//-------------------------------------------------------------
	task send();
		send_payload();
	endtask

//-------------------------------------------------------------
//	SEND PAYLOAD TASK
//-------------------------------------------------------------
	task send_payload();
		ALU_Interface.cb.enable 	<= 1'b1;
		
		while (payload_aluin1.size() !=0)
		begin 
				ALU_Interface.cb.aluopselect<=3'b001;
			   	ALU_Interface.cb.aluin1	<=	payload_aluin1.pop_front();
			   	ALU_Interface.cb.aluin2	<=	payload_aluin2.pop_front();
				ALU_Interface.cb.aluoperation <= $urandom_range(1,6);
		   	@(ALU_Interface.cb);
			display();
		end
	endtask

//-------------------------------------------------------------
//	DISPLAY  TASK
//-------------------------------------------------------------
	task display();
		$display($time, "ns:  [DEBUG] Inputs to ALU: aluin1 = %h, aluin2 = %h, aluoperation= %b", ALU_Interface.cb.aluin1, ALU_Interface.cb.aluin2, ALU_Interface.cb.aluoperation);
		
		$display($time, "ns:  [DEBUG] Outputs from ALU: aluout = %h, carry = %b", ALU_Interface.cb.aluout, ALU_Interface.cb.aluout[32]);
	endtask
endprogram
