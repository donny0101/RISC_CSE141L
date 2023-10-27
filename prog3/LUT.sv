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
		5'b00110: Target = 10'h021; //find
		5'b00111: Target = 10'h06C; //setupDcrpt
		5'b01000: Target = 10'h098; //Dcrpt
		5'b01001: Target = 10'h0B0; //setupErrDet
		5'b01010: Target = 10'h0C3; //ErrDet
		5'b01011: Target = 10'h0DC; //incrCount
		5'b01100: Target = 10'h0E1; //setupRmv
		5'b01101: Target = 10'h0EC; //remove
		5'b01110: Target = 10'h0F8; //store
		5'b01111: Target = 10'h104; //padRmvSpaces
		5'b00101: Target = 10'h112; //DONE
  endcase
end

endmodule

/*
	THESE WORKED FOR PROG 1 MACHINE V11
	crptoPreSpaces: 00000 			Prog1-machine_V11 Line: 29 So we need 28: 00_0001_1100 = 10'h01C
	setupCrptoMsg : 00001			Prog1-machine_V11 Line: 50 So we need 49: 00_0011_0001 = 10'h031
	CrptoMsg : 00010					Prog1-machine_V11 Line: 62 So we need 61: 00_0011_1101 = 10'h03D
	SetupReducParity : 00011 		Prog1-machine_V11 Line: 83 So we need 82: 00_0101_0010 = 10'h052
	ReducParity : 00100				Prog1-machine_V11 Line: 101 So we need 100: 00_0110_0100 = 10'h064
	DONE : 00101 						Prog1-machine_V11 Line: 120 So we need 119: 00_0111_0111 = 10'h077
	
	
	WORKING FOR PROG 1 MACHINE V11
	5'b00000: Target = 10'h01C; //crptoPreSpaces
		5'b00001: Target = 10'h031; //setupCrptoMsg
		5'b00010: Target = 10'h03D; //CrptoMsg
		5'b00011: Target = 10'h052; //SetupReducParity
		5'b00100: Target = 10'h064; //ReducParity
		5'b00101: Target = 10'h077; //DONE
	
	
PROGRAM 2 LUT VALUES 	********WORKING FOR V3 ITS RUNNINGGGGG!!!!!!!
	find : 00110 						Prog2-machine_V3 Line: 34 So we need 33: 00_0010_0001 = 10'h021
	setupDcrpt : 00111 				Prog2-machine_V3 Line: 109 So we need 108: 00_0110_1100 = 10'h06C
	Dcrpt : 01000 						Prog2-machine_V3 Line: 153 So we need 152: 00_1001_1000 = 10'h098
	DONE : 00101 						Prog2-machine_V3 Line: 177 So we need 176: 00_1011_0000 = 10'h0B0
	*/


/*
	PROGRAM 3 LUT VALUES V7 did work once 
			find : 00110 						Prog3-machine_V2 Line: 34 So we need 33: 00_0010_0001 = 10'h021
			setupDcrpt : 00111 				Prog3-machine_V2 Line: 109 So we need 108: 00_0110_1100 = 10'h06C
			Dcrpt : 01000 						Prog3-machine_V2 Line: 153 So we need 152: 00_1001_1000 = 10'h098
			setupErrDet : 01001 				Prog3-machine_V2 Line: 177 So we need 176: 00_1011_0000 = 10'h0B0
			ErrDet : 01010 					Prog3-machine_V2 Line: 195 So we need 194: 00_1100_0010 = 10'h0C2
			incrCount : 01011 				Prog3-machine_V2 Line: 219 So we need 218: 00_1101_1011 = 10'h0DB	
			setupRmv : 01100 					Prog3-machine_V2 Line: 225 So we need 224: 00_1110_0000 = 10'h0E0
			remove : 01101 					Prog3-machine_V2 Line: 236 So we need 235: 00_1110_1011 = 10'h0EB
			store : 01110 						Prog3-machine_V2 Line: 248 So we need 247: 00_1111_0111 = 10'h0F7
			padRmvSpaces : 01111 			Prog3-machine_V2 Line: 260 So we need 259: 01_0000_0011 = 10'h103
			DONE : 00101 						Prog2-machine_V3 Line: 274 So we need 273: 01_0001_0001 = 10'h111
			
			
	PROGRAM 3 LUT VALUES V8 WORRRRRRKKKKIIINNNGGG
			find : 00110 						Prog3-machine_V2 Line: 34 So we need 33: 00_0010_0001 = 10'h021
			setupDcrpt : 00111 				Prog3-machine_V2 Line: 109 So we need 108: 00_0110_1100 = 10'h06C
			Dcrpt : 01000 						Prog3-machine_V2 Line: 153 So we need 152: 00_1001_1000 = 10'h098
			setupErrDet : 01001 				Prog3-machine_V2 Line: 177 So we need 176: 00_1011_0000 = 10'h0B0
			ErrDet : 01010 					Prog3-machine_V2 Line: 196 So we need 195: 00_1100_0011 = 10'h0C3
			incrCount : 01011 				Prog3-machine_V2 Line: 220 So we need 219: 00_1101_1100 = 10'h0DC	
			setupRmv : 01100 					Prog3-machine_V2 Line: 226 So we need 225: 00_1110_0001 = 10'h0E1
			remove : 01101 					Prog3-machine_V2 Line: 237 So we need 236: 00_1110_1100 = 10'h0EC
			store : 01110 						Prog3-machine_V2 Line: 249 So we need 248: 00_1111_1000 = 10'h0F8
			padRmvSpaces : 01111 			Prog3-machine_V2 Line: 261 So we need 260: 01_0000_0100 = 10'h104
			DONE : 00101 						Prog2-machine_V3 Line: 275 So we need 274: 01_0001_0010 = 10'h112
	
*/	
//		5'b00110: Target = 10'h01F; //find
//		5'b00111: Target = 10'h019; //setupDcrpt
//		5'b01000: Target = 10'h04E; //Dcrpt
//		5'b00101: Target = 10'h066; //DONE


	
	
	
	
	
	
	

//22 = 00_0001_0110 = 10'h016 FOR PROG1PROCESSOR TESTING
//13 = 00_0000_1101 = 10'h00D FOR PROG1PROCESSOR TESTING LABEL IS LINE 14 IN MACHINE FILE, SUBTRACT 1 FOR TARGET
//40 = 00_0010_1000 = 10'h028

/*
	5'b00000:   Target = 10'h3f0;  // -16, i.e., move back 16 lines of machine code, 10'h3f0 = 11_1111_0000 = -16
	2'b01:	 Target = 10'h003;
	2'b10:	 Target = 10'h007;
*/