//*****************************************************************************
//getB2Dinput
//  Function getB2Dinput modifies getstring: Will read a string of characters 
//	up to a specified length from the console and save it in a specified 
//	buffer as a C-String (i.e. null terminated). 
//		MODIFICATIONS:
//			Will look for 'c' inside input string and reset pointer if detected
//  		Will look for 'q' inside input string and return null if detected
//
//  X0: Points to the first byte of the buffer to receive the string. This must
//      be preserved (i.e. X0 should still point to the buffer when this function
//      returns).
//  X1: The maximum length of the buffer pointed to by X0 (note this length
//      should account for the null termination of the read string (i.e. C-String)
//  LR: Must contain the return address (automatic when BL
//      is used for the call)
//  All AAPCS mandated registers are preserved.
//*****************************************************************************
.global getBinput // Provide program starting address

getBinput:
    .EQU SYS_exit, 93 // exit() supervisor call code
    .text // code section
	MOV X7, LR			// Store return address
	MOV X4, #17			// taking 16 bit input, one more to include null character		
	MOV X3, X0			// Save string buffer address, this will be manipulated
	SUB SP, SP, #16			// Allocate 64 bits/16 bytes on the stack to store X0
	MOV SP, X0			// Save string buffer address, this will be used for resetting
	MOV X5, #0			// This is our char count and lcv
readStrLoop:	
		// READ INPUT AND PLACE INSIDE BUFFER
	MOV X0, #0		// file descriptor for SYS_READ INPUT (Keyboard)
	LDR X1, =czBuffer	//	read() needs buffer pointer in X1
	MOV X2, #1		// read() needs max read char count in X2
	MOV X8, #63		// Linus call SYS_READ() system call number
	SVC 0 			// call Linux to read the string	
	ADD X5, X5, #1	// increment lcv char count
	LDR W1, [X1]	// Load value of char into W reg
		// CHECK LCV : 
	CMP W1, #'\n' // if it’s a new line character, that means we have reached the end of the input.
	B.EQ readStrLoopEnd	// end loop and print
	
	CMP W1, #'c'	// if user entered 'c', clear previous input (reset str pointer)
	B.EQ cFlag		// if 'c', jump to c flag area
	CMP W1, #'C'	// if user entered 'C', same
	B.EQ cFlag		// jump to cflag
	B.NE LCVCheck	// if not 'C', ignore next block
	
cFlag:
	MOV X3, SP		// Reset X3 to original str ptr (stored in the stack)
	MOV X5, #0		// char count to 0
	B readStrLoop	// Since LCV reset, no need to check. Loop
LCVCheck:
	CMP X5, X4	 	// compare the amount of chars read and the length of string array
	B.GE readStrLoop	// if the length of the string has surpassed the end of our buffer stop adding to the buffer but continue reading to clear console
	STRB W1, [X3], #1	// Store char in string array, increment string pointer	
	B readStrLoop	// Loop to read next char
readStrLoopEnd:
	MOV X1, #0			// putstring needs null terminated string
	STRB W1, [X3]		// Store null character at the end of our string

	// Clear stack
	ADD SP, SP, #16			// deallocate stack

	MOV LR, X7		// Return address back to lr
    RET		// return to caller
.data // data section
	czBuffer:	.skip	16
.end // end of program, optional but good pra
