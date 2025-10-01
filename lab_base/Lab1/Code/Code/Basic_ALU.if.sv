/********************************************************************/ 
/*                                                                  */
/*  CODE: 	 	 Lab 1 FOR ECE745                           		*/
/*	  	                                                    		*/
/*  DESCRIPTION: An Interface for ALU Testbench 			   		*/
/*                       											*/
/*  DATE:        August 8, 2009                                     */
/*             				                                        */
/********************************************************************/

interface Basic_ALU_interface(input bit clock);
  	parameter   reg_wd    	=   32;

  	logic						reset, enable;
  	logic 	[reg_wd -1:0]       aluin1, aluin2; 
  	logic 	[2:0]       		aluoperation, aluopselect;
	logic  	[reg_wd:0]          aluout; 

//---------------------------------------------------
// Clocking Block
//---------------------------------------------------

  	clocking cb @(posedge clock);
    	default input #1 output #1;
		output 	enable;
   		output	aluin1, aluin2; 
   		output 	aluoperation, aluopselect; 
   		input	aluout;
  	endclocking

//---------------------------------------------------
// Modport
//---------------------------------------------------

  	modport TB(clocking cb, output reset);
endinterface
