// CSE141L

import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic BranchAbs     ,
               BranchRel ,
					BaddEn,
					LFSR_LUT9_En,
					Immediate_Reg,
			   RegWrEn  ,	   // write to reg_file (common)
			   MemWrEn  ,	   // write to mem (store only)
			   LoadInst	,	   // mem or ALU to reg_file ?
			   Ack		,      // "done w/ program"
  output logic[9:0] PCTarg   
  );

 /* 
assign MemWrEn   = Instruction[8:6]==3'b110;	  // store
assign RegWrEn   = Instruction[8:6]!=3'b110;	  // all other ops
assign LoadInst  = Instruction[8:6]==3'b111;
*/

assign Immediate_Reg = Instruction[8:5] == ADDi;
assign MemWrEn = Instruction[8:5] == STRm;

/*
assign RegWrEn = (Instruction[8:5] == ADDi)|(Instruction[8:5] == ADDr)
	|Instruction[8:5] == SUBr|Instruction[8:5] == XORr|Instruction[8:5] == ORRr
	|Instruction[8:5] == ANDr|Instruction[8:5] == MOvr|Instruction[8:5] == LSL
	|Instruction[8:5] == RXOR|Instruction[8:5] == MOVrhl;
*/

assign RegWrEn = (Instruction[8:5]!= CMP)&(Instruction[8:5]!= STRm)&(Instruction[8:5]!= Badd)&(Instruction[8:5]!= Bsub)&(Instruction[8:5]!= STOP)&(Instruction[8:5]!= Label);	
assign LoadInst = Instruction[8:5] == LDR;

// reserve instruction = 9'b111111111; for Ack

// jump on right shift that generates a zero

// branch every time instruction = 9'b101??????;
//assign BranchRel = Instruction[8:6]==3'b101;

assign BaddEn = Instruction[8:5] == Badd;
//assign LFSR_LUT9_En = Instruction[8:5] == LFSRL;
//assign BsubEn = Instruction[8:5] == Bsub; 

//branches for Badd and Bsub***************


// route data memory --> reg_file for loads


//   whenever instruction = 9'b110??????; 
assign PCTarg  = {5'b00000, Instruction[4:0]};

assign Ack = (Instruction[8:5] == STOP);

endmodule

