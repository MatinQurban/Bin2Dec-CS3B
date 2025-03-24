// header from coding standard here, set tab to 4 spaces
.global _start // Provide program starting address

_start:
.EQU SYS_exit, 93 // exit() supervisor call code
.text // code section
	LDR X0, =cmdList	// Load address of cmd list
	BL putstring		// print user commands
	LDR X0, =szEOL		// load address of EOL
	BL putstring		// print newline
B2DLoop:
	LDR X0, =szOutput	// Load address of output str
	MOV X1, #0			// Move 0 into register
	STR X1, [X0]		// Store 0 into output str to clear previous values

	LDR X0, =prompt		// Load address of prompt
	BL putstring		// Output prompt
	
	LDR X0, =szInput	// Load string buffer for binary input
	LDR X1, #16			// Load input size
	BL getBinput		// getstring modified for binary input
	
// Check if user input command
	CMP X1, #-1			// if -1, quit program
	B.EQ terminateB2D	// jump to quit block if input returned -1
	CMP X11, #1			// if 1, output error message
	B.EQ errorInputMsg	// jump to error block
	CMP X1, #-2			// if -2, clear Input (reset str ptr)
	B.EQ B2DLoop		// jump to reading again if input returned -3
B2DContinue:
// Extension Check
    LDR X0, =szInput	// Load adress of string input
	BL String_length	// Obtain length of string input
	CMP X1, #16			// Check if our input is 16 bits
	B.GE Bin2DecConvert	// If 16 bits, skip sign extension
	
	// Sign extension	
	LDR X0, =szInput	// Reload string input
	MOV X2, #16			// prepend needs desired length
	BL prependStr		// prepend string to sign extend binary input to 16 bits
	
Bin2DecConvert:
	LDR X0, =szInput	// Load string buffer
	BL putstring		// print 16 bit binary value

	LDR X0, =szArrow	// load arrow string address
	BL putstring		// print arrow 

	LDR X0, =szInput	// Load binary input
	BL convert			// convert 16 bit binary number to decimal equivalent
	MOV X9, X1			// Copy neg flag into X9 so it is not modified during int2cstr
	LDR X1, =szOutput	// int2cstr needs address large enough to hold converted value
	BL int2cstr			// convert decimal value in X0 to cstr and store in X1

	CMP X9, #1			// if X1 = 1, set minus sign for negative number
	B.NE decimalPositive// if not 1, then we do not need to output minus sign	
	LDR X0, =szNeg		// load address for minus sign
	BL putstring		// print minus sign
decimalPositive:
	LDR X0, =szOutput	// Load address of cstring decimal converted binary value
	BL putstring		// Print decimal value
	LDR X0, =szEOL		// Load address of eol
	BL putstring		// print newline
	//B terminateB2D		// terminates program
	B B2DLoop			// Loop until user quits
errorInputMsg:
	LDR X0, =inputError	// load address of input error message
	BL putstring		// print error
	LDR X0, =szEOL		// load address of EOL
	BL putstring		// print new line
	B B2DContinue		// Continue program
terminateB2D:
	// terminate the program
    MOV X0, #0 // set return code to 0, all good
    MOV X8, #SYS_exit // set exit() supervisor call code
    SVC 0 // call Linux to exit
.data // data section
	cmdList:		.asciz "\n\t'c' will clear\n\t'q' will exit\n"	// user commands
	prompt:			.asciz "Enter a Binary Number : " // prompt message
	szArrow:		.asciz " --> "	// arrow for conversion
	szInput:		.skip 64	   // Binary value string input buffer
	szOutput:		.skip 25		// Decimal equivalent of binary input
	szEOL:          .asciz "\n"    // end of line string
	szNeg:			.asciz "-"		// negative sign
	inputError:		.asciz "Warning: Can only accept the following characters - <1> <0> <c> <q>. Will ignore invalid characters."	
.end // end of program, optional but good pra
