// Xandro Sunico
// CS3B - Bin2Dec - complement
// 25 Mar 2025
// 2s complement of binary number in string
// Algorithm / Pseudocode:
//	For bits 0 to 15:
//		Flip bit
//	For bit 15:
//		Add binary 1 to bit
//		Keep count of carry
//	For bit 14 to 0 or when carry = 0:
//		Update bit according to the carry
//		Decrement current working bit
//	Return

//	Pre:
//	X0: Null terminated string containing 16 binary digits
//	X5: Positive or negative number

//	Working:
//	X0: Current bit address
//	X1: Current bit
//	X2: Carry
//	X3: Counter
//	X4: Saved original address
//	X6: Return address

//	Post:
//	X0: Null terminated string containing 16 binary digits
//	X5: Positive or negative number

.global complement	// Function starting address

complement:
	.text	// Code here

//	Flip the bits

	MOV	X4, X0		// Save original address into X4
	MOV	X3, #0		// Reset counter to 0

complement_firstloop:

	ADD	X3, X3, #1	// Increment counter
	LDRB	W1, [X0]	// Get current bit
	CMP	W1, #'0'	// Find if bit is 0 or 1
	B.EQ	complement_0	// Jump if current bit is 0

	MOV	W1, #'0'	// If current bit is 1, store 0
	B	complement_firstcont	// Jump to continue

complement_0:

	MOV	W1, #'1'	// If current bit is 0, store 1

complement_firstcont:

	STRB	W1, [X0]	// Store current bit into current bit address
	ADD	X0, X0, #1	// Increment address
	CMP	X3, #16		// See if reached end of loop
	B.NE	complement_firstloop	// Repeat loop if not yet at last bit

//	Add 1

	LDRB	W1, [X0]	// Get current bit
	CMP	W1, #'0'	// Find if bit is 0 or 1
	B.NE	complement_firstbitone	// Jump if first bit is 1

	MOV	W1, #'1'	// If current bit is 0, change to 1
	STRB	W1, [X0]	// Store into current bit address
	B	complement_end	// Jump to end

complement_firstbitone:

	MOV	W1, #'0'	// Update bit
	MOV	X2, #1		// Save carry into X2

complement_carryloop:

	SUB	X0, X0, #1	// Decrement current address
	LDRB	W1, [X0]	// Get current bit
	CMP	W1, #'0'	// Find if bit is 0 or 1
	B.EQ	complement_carryzero	// Jump if bit is 0

	MOV	W1, #'0'	// If bit is 1, update to 0
	STRB	W1, [X0]	// Save bit
	CMP	X0, X4		// Find out if at beginning of address
	B.GT	complement_carryloop	// If not, then restart loop
	B	complement_end	// If so, jump to end

complement_carryzero:

	MOV	W1, #'1'	// If bit is 0, update to 1
	STRB	W1, [X0]	// Save bit

complement_end:

	MOV	X0, X4		// Save original address into X0
	RET			// Return function

	.data	// Data here

.end	// End of function
