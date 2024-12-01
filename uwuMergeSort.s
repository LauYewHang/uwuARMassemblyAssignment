	AREA uwuCode, CODE, READONLY
	ENTRY
	
; define names for register and constant uwu
uwuLeft RN R0 ; reserve R0 for variable "left"
uwuMid RN R1 ; reserve R1 for variable "mid"
uwuRight RN R2 ; reserve R2 for variable "right"

uwuReadFrom RN R3 ; address of array to read from uwu
uwuWriteTo RN R4 ; address of array to write to uwu
uwuStartInt RN R5 ; starting int uwu (inclusive)
uwuEndInt RN R6 ; end int uwu (exclusive)

uwuLeftS RN R7 ; keep track of size of left array in merge process
uwuRightS RN R8 ; keep track of size of right array in merge process
uwuI RN R9 ; keep track of indexing of left array in merge
uwuJ RN R10 ; keep track of indexting of right array in merge

uwuLeftArrayR RN R3 ; register to keep track of left array's address
uwuRightArrayR RN R4 ; register to keep track of right array's address
uwuSortedArrayR RN R5 ; register to keep track of sorted array's address

uwuHold RN R11 ; use to hold random value uwu
uwuHold2 RN R12 ; use to hold random value2 uwu

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
	MOV uwuStartInt, #0 ; read from first index
	MOV uwuEndInt, #uwuArraySize ; until the last
	BL uwuReadArray ; call the read array function
	
	MOV uwuHold, PC ; store current PC
	ADD uwuHold, #8 ; offset 12 bytes (3 instructions) since we want to skip PUSH and uwuMergeSort
	PUSH {uwuLeft, uwuMid, uwuRight, uwuHold} ; store the PC so next time the last function POP it jumps back here uwu
	B uwuMergeSort ; call mergeSort function
	B uwuStop ; uwu stop
	
uwuReadArray	
	LDR uwuHold, [uwuReadFrom] ; load the value from array A
	STR uwuHold, [uwuWriteTo] ; store the value to array B
	
	ADD uwuReadFrom, #uwuWord
	ADD uwuWriteTo, #uwuWord ; add 4 bytes offset to array B (get address to write next value)
	ADD uwuStartInt, #1 ; increment iteration by 1
	CMP uwuStartInt, uwuEndInt ; compare the condition
	BLT uwuReadArray ; repeat until indexFrom >= indexTo
	BX LR ; branch back after completing the loop
	
uwuMergeSort ; uwuMergeSort function with parameters "left" & "right", uwuMergeSort(left, right)
	CMP uwuLeft, uwuRight ; compare left and right
	POPGE {uwuLeft, uwuMid, uwuRight, PC} ; return to previous instruction's location if left >= right (return statement)
	
	; sort left side
	SUB uwuMid, uwuRight, uwuLeft
	LSR uwuMid, uwuMid, #1 
	ADD uwuMid, uwuLeft ; mid = left + (right-left) / 2
	
	MOV uwuHold, PC
	ADD uwuHold, #16 ; current PC with 16 bytes offset since we want to skip 2 PUSH, 1 MOV, and first uwuMergeSort
	
	PUSH {uwuHold} ; save the PC address uwu
	PUSH {uwuLeft, uwuMid, uwuRight} ; save the current left mid right value uwu
	MOV uwuRight, uwuMid ; right = mid
	B uwuMergeSort ; call uwuMergeSort with (left, mid)
	
	
	; sort right side
	MOV uwuHold, PC
	ADD uwuHold, #20 ; current PC with 20 bytes offset since we want to skip 2 PUSH, 1 MOV, 1 ADD, 1 uwuMergeSort
	
	PUSH {uwuHold}
	PUSH {uwuLeft, uwuMid, uwuRight}
	
	MOV uwuLeft, uwuMid
	ADD uwuLeft, #1 ; left = mid + 1
	B uwuMergeSort ; call uwuMergeSort with (mid+1, right)
	
	B uwuMerge ; merge the two array together uwu

uwuMerge
	; initialize left and right array size
	SUB uwuLeftS, uwuMid, uwuLeft
	ADD uwuLeftS, #1 ; left array size = (mid-left) + 1
	SUB uwuRightS, uwuRight, uwuMid ; right array size = (right-mid)

	; store to left array
	LDR uwuReadFrom, =uwuSortedArray
	MOV uwuHold, #uwuWord
	MUL uwuHold, uwuLeft, uwuHold
	ADD uwuReadFrom, uwuHold
	LDR uwuWriteTo, =uwuLeftArray
	MOV uwuStartInt, #0
	MOV uwuEndInt, uwuLeftS
	BL uwuReadArray
	
	; store to right array
	LDR uwuReadFrom, =uwuSortedArray
	MOV uwuHold, #uwuWord
	MUL uwuHold, uwuMid, uwuHold
	ADD uwuHold, #uwuWord
	ADD uwuReadFrom, uwuHold
	LDR uwuWriteTo, =uwuRightArray
	MOV uwuStartInt, #0
	MOV uwuEndInt, uwuRightS
	BL uwuReadArray
	
	LDR uwuLeftArrayR, =uwuLeftArray
	LDR uwuRightArrayR, =uwuRightArray
	LDR uwuSortedArrayR, =uwuSortedArray
	MOV uwuHold, #uwuWord
	MUL uwuHold, uwuLeft, uwuHold
	ADD uwuSortedArrayR, uwuHold
	MOV uwuI, #0
	MOV uwuJ, #0
	BL compare
	BL uwuStoreLeft
	BL uwuStoreRight
	POP {uwuLeft, uwuMid, uwuRight, PC}
	
compare
	CMP uwuI, uwuLeftS
	CMPLT uwuJ, uwuRightS
	BXGE LR
	LDR uwuHold, [uwuLeftArrayR]
	LDR uwuHold2, [uwuRightArrayR]
	CMP uwuHold, uwuHold2
	STRLT uwuHold, [uwuSortedArrayR]
	ADDLT uwuLeftArrayR, #uwuWord
	ADDLT uwuI, #1
	STRGE uwuHold2, [uwuSortedArrayR]
	ADDGE uwuRightArrayR, #uwuWord
	ADDGE uwuJ, #1
	ADD uwuSortedArrayR, #uwuWord
	B compare

uwuStoreLeft
	CMP uwuI, uwuLeftS
	BXGE LR
	LDR uwuHold, [uwuLeftArrayR]
	STR uwuHold, [uwuSortedArrayR]
	ADD uwuLeftArrayR, #uwuWord
	ADD uwuI, #1
	ADD uwuSortedArrayR, #uwuWord
	B uwuStoreLeft
	
uwuStoreRight
	CMP uwuJ, uwuRightS
	BXGE LR
	LDR uwuHold2, [uwuRightArrayR]
	STR uwuHold2, [uwuSortedArrayR]
	ADD uwuRightArrayR, #uwuWord
	ADD uwuJ, #1
	ADD uwuSortedArrayR, #uwuWord
	B uwuStoreRight

; uwu end
uwuStop B uwuStop	
	
uwuUnsortedArray DCD 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 ; original unsorted array uwu	
	
	AREA uwuMemory, DATA, READWRITE
uwuStackMemory SPACE 4096 ; used for storing stack value (PUSH and POP) uwu
uwuLeftArray SPACE 40 ; used to store left side array during merge process uwu
uwuRightArray SPACE 40 ; used to store right side array during merge process uwu
uwuSortedArray SPACE 40 ; used to store the sorted array uwu
	END