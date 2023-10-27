/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module LUT(
  input       [ 4:0] Addr,
  output logic[ 9:0] Target
  );

always_comb begin
  Target = 10'h001;	   // default to 1 (or PC+1 for relative)
  case(Addr)	
		5'b00000: Target = 10'h01C; //crptoPreSpaces
		5'b00001: Target = 10'h031; //setupCrptoMsg
		5'b00010: Target = 10'h03D; //CrptoMsg
		5'b00011: Target = 10'h052; //SetupReducParity
		5'b00100: Target = 10'h064; //ReducParity
		5'b00101: Target = 10'h077; //DONE
  endcase
end

endmodule

/*
	crptoPreSpaces: 00000 			Prog1-machine_V1 Line: 29 So we need 28: 00_0001_1100 = 10'h01C
	setupCrptoMsg : 00001			Prog1-machine_V1 Line: 50 So we need 49: 00_0011_0001 = 10'h031
	CrptoMsg : 00010					Prog1-machine_V1 Line: 62 So we need 61: 00_0011_1101 = 10'h03D
	SetupReducParity : 00011 		Prog1-machine_V1 Line: 83 So we need 82: 00_0101_0010 = 10'h052
	ReducParity : 00100				Prog1-machine_V1 Line: 101 So we need 100: 00_0110_0100 = 10'h064
	DONE : 00101 						Prog1-machine_V1 Line: 120 So we need 119: 00_0111_0111 = 10'h077
*/


//22 = 00_0001_0110 = 10'h016 FOR PROG1PROCESSOR TESTING
//13 = 00_0000_1101 = 10'h00D FOR PROG1PROCESSOR TESTING LABEL IS LINE 14 IN MACHINE FILE, SUBTRACT 1 FOR TARGET
//40 = 00_0010_1000 = 10'h028

/*
	5'b00000:   Target = 10'h3f0;  // -16, i.e., move back 16 lines of machine code, 10'h3f0 = 11_1111_0000 = -16
	2'b01:	 Target = 10'h003;
	2'b10:	 Target = 10'h007;
*/