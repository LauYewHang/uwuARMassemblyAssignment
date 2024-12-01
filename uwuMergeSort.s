	AREA uwuCode, CODE, READONLY
	ENTRY
	
; define names for register and constant uwu
uwuLeft RN R0 ; reserve R0 for variable "left"
uwuMid RN R1 ; reserve R1 for variable "mid"
uwuRight RN R2 ; reserve R2 for variable "right"

uwuReadFrom RN R3 ; address of array to read from uwu
uwuWriteTo RN R4 ; address of array to write to uwu
uwuIndexFrom RN R5 ; read from which index (inclusive) uwu
uwuIndexTo RN R6 ; read to which index (exclusive) uwu

uwuHold RN R12 ; use to hold random value uwu

uwuArraySize EQU 10 ; constant for array size uwu
uwuWord EQU 4 ; constant for word size uwu

; set up the stack and read from unsortedd array uwu
uwuInitialize
	LDR SP, =uwuStackMemory ; make SP points to stack memory's address uwu
	ADD SP, SP, #4096 ; offset SP by 4096 since stack starts from below uwu
	MOV uwuRight, #uwuArraySize ; makle uwuRight the size of array
	SUB uwuRight, uwuRight, #1 ; make uwuRight the size of array - 1 (since array only index until its size - 1)
	
	LDR uwuReadFrom, =uwuUnsortedArray ; read from unsorted array uwu
	LDR uwuWriteTo, =uwuSortedArray ; write to sorted array
	MOV uwuIndexFrom, #0 ; read from first index
	MOV uwuIndexTo, #uwuArraySize ; until the last
	BL uwuReadArray ; call the read array function
	
	MOV uwuHold, PC ; store current PC
	ADD uwuHold, #8 ; offset 8 bytes (2 instructions) since we want to skip uwuHold and uwuMergeSort
	PUSH {uwuHold}
	B uwuMergeSort ; call mergeSort function
	B uwuStop ; uwu stop
	
uwuReadArray
	MOV uwuHold, #uwuWord ; hold 4 bytes offset
	MUL uwuHold, uwuIndexFrom, uwuHold ; get the offset of index (in bytes form)
	
	LDR uwuHold, [uwuReadFrom, uwuHold] ; load the value from array A (address of A + offset, where the reading should start)
	STR uwuHold, [uwuWriteTo] ; store the value to array B
	
	ADD uwuWriteTo, #uwuWord ; add 4 bytes offset to array B (get address to write next value)
	ADD uwuIndexFrom, #1 ; increment iteration by 1
	CMP uwuIndexFrom, uwuIndexTo ; compare the condition
	BLT uwuReadArray ; repeat until indexFrom >= indexTo
	BX LR ; branch back after completing the loop
	
uwuMergeSort
	CMP uwuLeft, uwuRight ; compare left and right
	POPGE {PC} ; return to previous instruction's location if left >= right (return statement)
	
	; sort left side
	B uwuMergeSort
	
	; sort right side
	B uwuMergeSort

uwuMerge
	
; uwu end
uwuStop B uwuStop	
	
uwuUnsortedArray DCD 8, 29, 50, 81, 4, 23, 24, 30, 1, 7 ; original unsorted array uwu	
	
	AREA uwuMemory, DATA, READWRITE
uwuStackMemory SPACE 4096 ; used for storing stack value (PUSH and POP) uwu
uwuLeftArray SPACE 40 ; used to store left side array during merge process uwu
uwuRightArray SPACE 40 ; used to store right side array during merge process uwu
uwuSortedArray SPACE 40 ; used to store the sorted array uwu
	END