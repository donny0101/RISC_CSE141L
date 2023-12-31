// Design Name:    basic_proc
// Module Name:    InstFetch 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2021.01.27
//
module ProgCtr #(parameter L=10) (	   // value of L should = A in InstROM
  input              Reset,			   // reset, init, etc. -- force PC to 0 
                     Start, 
                     Clk,			   // PC can change on pos. edges only
                     BranchRel,	       // jump to Target + PC
					 BranchAbs,
					 BaddEn,
					 BsubEn,
					 Zero,
  input        [L-1:0] Target,	       // jump ... "how high?"
  output logic [L-1:0] ProgCtr           // the program counter register itself
  );
	 
// program counter can clear to 0, increment, or jump
/*
  always_ff @(posedge Clk)	           // or just always; always_ff is a linting construct
	if(Reset)
	  ProgCtr <= 0;				       // for first program; want different value for 2nd or 3rd
	else if(BranchAbs)	               // unconditional absolute jump
	  ProgCtr <= Target;			   //   how would you make it conditional and/or relative?
	else if(BranchRel)   // conditional relative jump
	  ProgCtr <= Target + ProgCtr;	   //   how would you make it unconditional and/or absolute
	else if(!Start)
	  ProgCtr <= ProgCtr+'b1; 	       // default increment (no need for ARM/MIPS +4 -- why?)
*/

always_ff @(posedge Clk)
	if(Reset)
		ProgCtr <= 0;
	else if(BaddEn && Zero) //basically branch abs
		ProgCtr <= Target;
	else if(BsubEn && Zero) //basically branch rel but im going to try and not use 
		ProgCtr <= ProgCtr - Target;
	else if(!Start)
		ProgCtr <= ProgCtr+'b1;

endmodule

