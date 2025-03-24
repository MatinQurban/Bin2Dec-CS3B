// header from coding standard here, set tab to 4 spaces
.global _start // Provide program starting address

_start:
.EQU SYS_exit, 93 // exit() supervisor call code
.text // code section
	LDR X0, =prompt		// Load address of prompt
	BL putstring		// Output prompt
	
	LDR X0, =szInput	// Load string buffer for binary input
	LDR X1, #16			// Load input size
	BL getBinput		// getstring modified for binary input
	
// Check if user input quit command
	CMP X1, #-1			// if -1, quit program
	B.EQ terminateB2D	// jump to quit block if input returned -1

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
	B terminateB2D
	CMP X1, #1			// if X1 = 1, set minus sign for negative number
	B.NE decimalPositive// if not 1, then we do not need to output minus sign	
	
decimalPositive:

errorInputMsg:
	LDR X0, =inputError	// load address of input error message
	BL putstring		// print error
	LDR X0, =szEOL		// load address of EOL
	BL putstring		// print new line
terminateB2D:
	// terminate the program
    MOV X0, #0 // set return code to 0, all good
    MOV X8, #SYS_exit // set exit() supervisor call code
    SVC 0 // call Linux to exit
.data // data section
	prompt:			.asciz "    'c' will clear all values before 'c'\n    'q' will exit\nEnter a Binary Number : " // prompt message
	szArrow:		.asciz " --> "
	szInput:		.skip 64	   // Binary value string input buffer
	szEOL:          .asciz "\n"    // end of line string
	szNeg:			.asciz "-"		// negative sign
	inputError:		.asciz "Fatal Error: Can only accept the following characters - <1> <0> <c> <q>. Terminating Program."	
.end // end of program, optional but good pra
