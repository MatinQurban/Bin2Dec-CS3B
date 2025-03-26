// Matin Qurbanzadeh
// CS3B - Bin2Dec Group Project - Sign Extension (prependStr.s)
// Date Last Modified: 03/25/2025
// The purpose of this function is to prepend a given string with its first character until it reaches a desired length.  
// The function ensures proper alignment by shifting the existing characters before prepending 
//  
// Algorithm/Pseudocode:  
//    1. Compute the difference (D) between the desired length (16) and the current string length (L).  
//    2. Store the first character of the string as the prepend character.  
//    3. Create pointers for both the original string and the larger destination space.  
//    4. Shift the existing characters towards the end of the new string buffer to make space.  
//    5. Prepend the retained first character D times until the desired length is met.  
//    6. Return to the caller for further processing.  

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
