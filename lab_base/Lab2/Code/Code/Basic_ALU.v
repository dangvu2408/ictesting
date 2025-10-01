 
/********************************************************************/ 
/*                                                                  */
/*  AUTHOR: 	 Meeta Yadav FOR ECE745                             */
/*	  	                                                     		*/
/*  LEVEL: 0														*/
/*  DESCRIPTION: Basic ALU Code to show basic test bench structure  */
/*                       											*/
/*  DATE:      August 8, 2009                                       */
/*             				                                        */
/********************************************************************/

//`timescale 1ns/100ps

//------------------------------------------------------------------
//						MODULE DECLARATION							
//------------------------------------------------------------------
module Basic_ALU 	( 
					clock, 
					reset, 
					enable, 
					aluin1, 
					aluin2, 
                    aluoperation, 
					aluopselect, 
					aluout  );
					
//------------------------------------------------------------------
//						PARAMETER DECLARATION		  				
//------------------------------------------------------------------
    
	parameter   reg_wd    	=  32;
	parameter	[0:3] 

				ADD	= 8'b001,
				SUB	= 8'b010,
				NOT	= 8'b011,
				AND	= 8'b100,
				OR	= 8'b101,
				XOR	= 8'b110;
				
	parameter   [0:3] ARITH_LOGIC = 3'b001;

//-----------------------------------------------------------------
//						PORT DECLARATION		  			   	   
//-----------------------------------------------------------------
    input                   			clock, reset, enable;
    input     		[reg_wd -1:0]   	aluin1, aluin2;
    input   		[2:0]           	aluoperation, aluopselect;
    output   reg   	[reg_wd:0]   		aluout;

	
	always @ (posedge clock)
    begin
        if (reset)
        begin
            aluout  <=  0;
        end    
        else if (enable)
        begin   
       		//if (aluopselect == ARITH_LOGIC)	// arithmetic
       		//begin
       			case(aluoperation)
       			ADD : 	begin	aluout <= aluin1 + aluin2;	    end
       			SUB: 	begin   aluout <= aluin1 - aluin2;    	end 
       			NOT: 	begin   aluout <= {1'b0, {~aluin2}};    	end 
       			AND: 	begin   aluout <= {1'b0,{aluin1 & aluin2}};    	end
       			OR: 	begin   aluout <= {1'b0,{aluin1 | aluin2}};    	end
       			XOR: 	begin   aluout <= {1'b0,{aluin1 ^ aluin2}};      end
       			endcase
       		//end
            /*else 
       		begin
       			case (aluoperation)
       			ADD : 	begin	aluout <= 0;	    end
       			SUB: 	begin   aluout <= 0;    	end 
       			NOT: 	begin   aluout <= 0;    	end 
       			AND: 	begin   aluout <= 0;    	end
       			OR: 	begin   aluout <= 0;    	end
       			XOR: 	begin   aluout <= 0;      end
       			default:	begin  aluout <= 0;          end
       			endcase
       		end   */ 
        end   
    end
endmodule 
