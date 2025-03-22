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

	LDR X0, =szInput	// Load address into register	
	BL putstring	// print input
	LDR X0, =szEOL		// Load address into register
	BL putstring		// print newline	

    LDR X0, =szInput	// Load adress of string input
	BL String_length	// Obtain length of string input
	CMP X1, #16			// Check if our input is 16 bits
	B.NE Bin2DecConvert	// If 16 bits, skip sign extension
	
	// Sign extension	
	LDR X0, =szInput	// Reload string input
	MOV X2, #16			// prepend needs desired length
	BL prependStr		// prepend string to sign extend binary input to 16 bits
// NOTE: next block is for testing purposes only, delete later
	LDR X0, =szInput	// Load string buffer
	BL putsting			// print to see if extended correctly
	LDR X0, =szEOL		// load eol address
	BL putstring		// pritn endline
Bin2DecConvert:


	// terminate the program
    MOV X0, #0 // set return code to 0, all good
    MOV X8, #SYS_exit // set exit() supervisor call code
    SVC 0 // call Linux to exit
.data // data section
	prompt:			.asciz "'c' will clear all values before 'c'\n'q' will exit\n    Enter a Binary Number : " // prompt message
	szInput:		.skip 64	   // Binary value string input buffer
	szEOL:          .asciz "\n"    // end of line string
	
.end // end of program, optional but good pra
