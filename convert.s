// Xandro Sunico
// CS3B - Bin2Dec - convert
// 25 Mar 2025
// Convert binary string to decimal int

// Algorithm / Pseudocode:
//	If bit 0 is 1:
//		Store negative state
//		Get 2s complement
//	For bits 0 to 15:
//		Multiply current bit by current bit place decimal value
//		Add result to the total
//		Divide bit place by 2
//		Increment current bit address
//	Return

//	Pre:
//	X0: Null terminated string containing 16 binary digits

//	Working:
//	X0: Current bit address
//	X1: Current bit decimal equivalent
//	X2: Current bit
//	X3: Bit's decimal to add to total
//	X4: Decimal number total
//	X5: Positive or negative number
//	X6: Integer storer
//	X8: Return address

//	Post:
//	X0: Decimal equivalent number
//	X1: 0 = Positive, 1 = Negative

.global convert	// Function starting address

convert:

	.text	// Code here

	MOV	X8, LR		// Move return address into X8
	MOV	X5, #0		// Store 0 into X5 as positive
	LDRB	W2, [X0]	// Get leftmost bit of the binary string
	CMP	W2, #'0'	// Find out if leftmost bit is 0 or 1
	B.EQ	convert_pos	// If the leftmost bit is a 0, jump to the positive jump
	MOV	X5, #1		// Else number is negative, so store state into X5

	BL	complement	// Call 2s complement function

convert_pos:

	MOV	X1, #32768	// Leftmost bit decimal equivalent into X1
	MOV	X4, #0		// Reset counter

convert_loop:

	LDRB	W2, [X0]	// Get current bit, store into X0
	CMP	W2, #0x00	// Compare current bit to null to see if end of string
	B.EQ	convert_end	// Go to end of convert loop if current bit is null
	MOV	W6, #'0'	// Store ASCII 0 into X6
	SUB	W2, W2, W6	// Subtract current bit by ascii 0 to convert to int
	MUL	X3, X2, X1	// Multiply current bit by current bit's decimal equivalent
	ADD	X4, X4, X3	// Add to total in X4
	MOV	X6, #2		// Save Decimal 2 into X6
	UDIV	X1, X1, X6	// Divide bit decimal equivalent by 2
	ADD	X0, X0, #1	// Increment current bit address by 1
	B	convert_loop	// Restart loop

convert_end:

	MOV	X0, X4		// Save decimal total result into X0
	MOV	X1, X5		// Save pos or neg into X1

	MOV	LR, X8		// Restore return address
	RET			// Return function

	.data	// Data here

.end	// End of function
