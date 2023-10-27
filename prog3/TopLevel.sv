// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

	 logic [ 7:0] Waddr1;
	 logic[7:0] InA, InB;
wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 1:0] TargSel;       // which of 4 jump/branch options?
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB; //Waddr1;  // reg_file outputs 
wire [ 7:0] ALU_out;				//InA, InB, 	   // ALU operand inputs
						// ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        MemWrite,	   // data_memory write enable
			RegWrEn,	   // reg_file write enable
			Zero,		   // ALU output = 0 flag
			Odd,           // ALU output[0] 
			Parity,        // parity of ALU output 
            Jump,	       // to program counter: jump 
            BranchEn,				// to program counter: branch enable
				Immediate_Reg,
				BaddEn;
//				BsubEn;
logic[15:0] CycleCt;	   // standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
  ProgCtr PC1 (		             // this is the program counter module
	.Reset        (Reset   ) ,   // reset to 0
	.Start        (Start   ) ,   // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (Clk     ) ,   //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchAbs    (BranchAbs) ,  // jump enable
	.BranchRel    (BranchRel     ) ,	// branch enable
	.BaddEn			(BaddEn),
    .Target       (PCTarg  ) ,	 // "where to?" or "how far?" during a jump or branch
	 .Zero			(Zero),
	.ProgCtr      (PgmCtr  )	 // program count = index to instruction memory
	);					  
	
	

// Lookup table to handle 10-bit program counter jumps w/ only 2 bits
LUT LUT1(.Addr         (Instruction[4:0]) ,
         .Target       (PCTarg  )
    );
	 
	 

// instruction memory -- holds the machine code pointed to by program counter
  InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
	);

// Decode stage = Control Decoder + Reg_file
// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction) ,  // from instr_ROM
	.BranchAbs    (BranchAbs  ) ,  // to PC to handle jump/branch instructions
	.BranchRel    (BranchRel  )	,  // to PC
	.BaddEn			(BaddEn),
	.RegWrEn      (RegWrEn    )	,  // register file write enable
	.MemWrEn      (MemWrite   ) ,  // data memory write enable
    .LoadInst     (LoadInst   ) ,  // selects memory vs ALU output as data input to reg_file
    .PCTarg       (TargSel    ) ,    
    .Ack          (Ack        )	   // "done" flag
  );

  
 // assign Waddr1  = (Instruction[8:5] == 4'b1100)? {1'b0, Instruction[1:0]}: Instruction[4:2];//MOVrhl, moves higher reg value->lower reg		
	//technically a mux, add to diagram ? ******
	
always_comb begin
	if(Instruction[8:5] == 4'b1100)
		Waddr1 = {6'b00000, Instruction[1:0]};
	else if(Instruction[8:5] == 4'b0000)
		Waddr1 = 8'b00000000;
	else
		Waddr1 = {5'b00000, Instruction[4:2]};
end
  
// reg file
	RegFile #(.W(8),.A(3)) RF1 (			  // D(3) makes this 8 elements deep
 	  .Clk    				  ,
	  .WriteEn   (RegWrEn)    , 
	  .RaddrA    ({5'b00000, Instruction[4:2]}),        //concatenate with 0 to give us 4 bits
	  .RaddrB    ({6'b000000, Instruction[1:0]}), 
	  .Waddr     (Waddr1), 	      // mux above
	  .DataIn    (RegWriteValue) , 
	  .DataOutA  (ReadA        ) , 
	  .DataOutB  (ReadB		 )
	);
	
	
	
/* one pointer, two adjacent read accesses: 
  (sample optional approach)
	.raddrA ({Instruction[5:3],1'b0});
	.raddrB ({Instruction[5:3],1'b1});
*/
//    assign InA = (Immediate_Reg)? 8'b00000000: ReadA;	 //(connect RF out to ALU in) if addi sets readA=r0
//	assign InB = (Immediate_Reg)? Instruction[4:0]: ReadB;	 //(interject switch/mux if needed) if addi,ReadB=lower 5 bits 
	
always_comb begin
	if(Instruction[8:5] == 4'b0000)begin
		InA = 8'b00000000;
		InB = {3'b000, Instruction[4:0]};
		end
	else begin
		InA = ReadA;
		InB = ReadB;
		end
end
	
// controlled by Ctrl1 -- must be high for load from data_mem; otherwise usually low
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .SC_in   (1'b1),
	  .OP      (Instruction[8:5]),
	  .Out     (ALU_out),                    //regWriteValue),
	  .Zero	   (Zero),                       // status flag; may have others, if desired
      .Odd     (Odd),
		.Clk				,
	  .Parity  (Parity)
	  );
  
	DataMem DM(
		.DataAddress  (ReadA)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (ReadB), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  		     ,
		.Reset		  (Reset)
	);
	
	/*
LFSR_prog2_LUT LUT2(.Initial_State         (ReadA) ,
	.Index (ReadB),
         .Final_State       (Waddr1  ),
			
    );
	 */
	 
/* count number of instructions executed
      not part of main design, potentially useful
      This one halts when Ack is high  
*/

always_ff @(posedge Clk)
  if (Reset)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule

