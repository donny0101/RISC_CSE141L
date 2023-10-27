from io import StringIO;
import sys;

print("Starting compiler...\n");

op2machine = {
      "ADDi"     : "0000",
      "ADDr"     : "0001",
      "CMP"     : "0010",
      "XORr"     : "0011",
      "ORRr"     : "0100",
      "ANDr"     : "0101",
      "MOVr"     : "0110",
      "STRm"    : "0111",
      "LDR"    : "1000",
      "LSL"    : "1001",
      "Badd"    : "1010",
      "RXOR"   : "1011",
      "MOVrhl"    : "1100",
      "Bsub" : "1101",
      "Label" : "1110",
	    "STOP"     : "1111",
	    
      # "bge"     : "01111",
	    # "bgeq"    : "10000",
	    # "ble"     : "10001",
	    # "bleq"    : "10010",
	    # "j"       : "10011",
	    # "cmp"     : "10100",
	    # "cmpi"    : "10101",
	    # "strad"   : "10110",
      # "b"       : "10111"
      
      # 11000
      # 11001
      # 11010
      # 11011
      # 11100
      # 11101
      # 11110
      # 11111 *LABEL*
};
reg2machine = {
      "r0"  : "000",
      "r1"  : "001",
      "r2"  : "010",
      "r3"  : "011",
      "r4"  : "100",
      "r5"  : "101",
      "r6"  : "110",
      "r7"  : "111",
      # "r8"  , "1000",
      # "r9"  , "1001",
      # "r10" , "1010",
      # "r11" , "1011",
      # "r12" , "1100",
      # "r13" , "1101",
      # "r14" , "1110",                  
      # "r15" , "1111",
};
label2machine = {
      "crptoPreSpaces"   : "00000",
      "setupCrptoMsg"  : "00001",
      "CrptoMsg"      : "00010",
      "SetupReducParity"     : "00011",
      "ReducParity"     : "00100",
      "DONE"     : "00101",
      "find"     : "00110",
      "setupDcrpt"     : "00111",
      "Dcrpt"     : "01000",
      "setupErrDet"     : "01001",
      "ErrDet"     : "01010",
      "incrCount"     : "01011",
       "setupRmv"     : "01100",
        "remove"     : "01101",
          "store"     : "01110",
          "padRmvSpaces"     : "01111",
};

prog2Compile = "0";
counter = 1;  
# string line;


print("Choose an option:");
print("1) Program 1");
print("2) Program 2");
print("3) Program 3");
print("4) Exit");
print("\rSelect an option: ");
menuSelect = input();
if( menuSelect == "1"):
  prog2Compile = "Prog1";
elif( menuSelect == "2"):
  prog2Compile = "Prog2";
elif( menuSelect == "3"):
  prog2Compile = "Prog3";
elif( menuSelect == "4"):
  sys.exit();
else:
  sys.exit();


# Read the file and display it line by line.  
inputFile = open("./" + prog2Compile + "MyAssembly.txt","r");  
# Write the string array to a new file.
outputFile = open("./" + "test-" + prog2Compile + "-machine_EDMUND_TEST_1.txt","w");
    

Lines = inputFile.readlines();
for line in Lines:
  if line.isspace() or not line:
    counter += 1;
    continue;
  
  posComment = line.index("//");
  lineASM = line;
  if (posComment >= 0):
    lineASM = line[:posComment];
    if lineASM.isspace() or not lineASM:
      counter += 1;
      continue;

  asmStrs = lineASM.replace(' ',' ').replace(',',' ').split();
  filter(lambda name: name.strip(), asmStrs);

# || asmStrs.Length == 1 && !asmStrs[0].Contains("addi")
  if ( len(asmStrs) == 2 and "B" in asmStrs[0] ):      # B Type Instruction
    outputFile.write( op2machine[asmStrs[0]] + label2machine[asmStrs[1]] );
    
    counter += 1;
    continue;  
  elif(len(asmStrs) == 1 and "STOP" in asmStrs[0]):  # STOP
    outputFile.write( "1111" + op2machine[asmStrs[0]] );
  elif(len(asmStrs) == 1): #labels
    outputFile.write( "1110" + label2machine[asmStrs[0]] );

  else:                          # R or I Type Instruction
    machineCodeF1 = "";
    machineCodeF2 = "";
    machineCodeF3 = "";
    try:
      machineCodeF1 = op2machine[asmStrs[0]];
    except:
      print("FAILED AT:  machineCodeF1 = op2machine[asmStrs[0]");
      print("LINE NUMBER: {0}".format(counter));
      print("LINE: {0}".format(line));
      sys.exit();

      
    if ("r" in asmStrs[1] and "r" in asmStrs[2]): # If operand is a register
      machineCodeF2 = reg2machine[asmStrs[1]];
      machineCodeF2 = machineCodeF2.Substring(0);
      machineCodeF3 = reg2machine[asmStrs[2]];
      machineCodeF3 = machineCodeF3.Substring(1);
    elif (asmStrs[1].Any(char.IsUpper)):
      try:  
        machineCodeF2 = label2machine[asmStrs[1]];
      except:
        print("FAILED AT:  machineCodeF2 = label2machine[asmStrs[1]]");
        print("LINE NUMBER: {0}".format(counter));
        print("LINE: {0}".format(line));
        sys.exit();

      machineCodeF1 = op2machine[asmStrs[0]];
      machineCodeF2 = label2machine[asmStrs[1]];

    else:                            # If operand is an immediate
      tmp = 0;
      asmStrs[1] = asmStrs[1].Substring(1);
      tmp = int(asmStrs[1]);
      machineCodeF2 = Convert.ToString(tmp, 2).PadLeft(5, '0');
    
    
    machineCode =  machineCodeF1 + machineCodeF2 + machineCodeF3;
    outputFile.write(machineCode);
  
  
  counter += 1;  
 
      
inputFile.Close();  
outputFile.Close();
print("There were {0} lines in the assembly file.".format(counter));  
print("Compiler successfully finished!");

sys.exit();
