// X0: ptr: string buffer
// X1: string length
// X2: Desired length
// Assuming desired length is within the string buffer size
// New string pointer should equal string buffer at the end of this function
.global prependStr // Provide program starting address

prependStr:
.EQU SYS_exit, 93 // exit() supervisor call code
.text // code section

	SUB X3, X2, X1		// X3 = X2-X1 (How many bytes we need to fill, LCV 1)
	LDRB W4, [X0]		// Save the first character, this is what we will prepend with
// Create pointers
	ADD X0, X0, X1		// Move str pointer to the end of current string
	ADD X0, X0, #1		// Increment once more to include null
	ADD X2, X0, X3		// Point to the 'end' of the result string, also including null

shiftStrLoop: // This should only loop string length number of times
	LDRB W5, [X0] 		// Copy current char to push to the back of the string
	STRB W5, [X2]		// Move char to the first available slot from the back
// Update pointers
	SUB X2, X2, #1		// Update result string pointer
	SUB X0, X0, #1		// Update current string pointer
// Update and check LCV
	SUB X1, X1, #1		// Update LCV (current string length)
	CMP X1, #0			// Check if reached the end of current string
	B.GT shiftStrLoop	// If string length greater than 0, there are still more chars to be pushed. Loop.

prependLoop: // This should only loop desired_len - string_len number of times
	STRB W4, [X2]		// Store prepend value into furthest back position

	SUB X2, X2, #1		// Update pointer
	SUB X3, X3, #1		// Update LCV

	CMP X3, #0			// Check if desired length is met
	B.GT prependLoop	// If we need to prepend more chars, loop.

	
// Return to caller
	RET			// Return
.data // data section
.end // end of program, optional but good pra
