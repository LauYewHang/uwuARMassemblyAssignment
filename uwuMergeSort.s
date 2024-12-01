	AREA uwuCode, CODE, READONLY
	ENTRY
	
; define names for register and constant uwu
uwuLeft RN R0 ; reserve R0 for variable "left"
uwuMid RN R1 ; reserve R1 for variable "mid"
uwuRight RN R2 ; reserve R2 for variable "right"

uwuReadFrom RN R3 ; address of array to read from uwu
uwuWriteTo RN R4 ; address of array to write to uwu
uwuStartInt RN R5 ; starting int uwu (inclusive)
uwuEndInt RN R6 ; end int uwu (exclusive), these two basically means: for (int start; start < end)

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
	B uwuMergeSort ; call mergeSort function uwu
	B uwuStop ; uwu stop
	
uwuReadArray	
	LDR uwuHold, [uwuReadFrom] ; load the value from array A
	STR uwuHold, [uwuWriteTo] ; store the value to array B
	
	ADD uwuReadFrom, #uwuWord ; increment the read address by 4 bytes (points to next element)
	ADD uwuWriteTo, #uwuWord ; add 4 bytes offset to array B (get address to write next value)
	ADD uwuStartInt, #1 ; increment iteration by 1
	CMP uwuStartInt, uwuEndInt ; compare the condition
	BLT uwuReadArray ; repeat until startInt >= endInt uwu
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
	
	PUSH {uwuHold} ; save the PC address uwu (always PC first, values later, because during POP it read from top to bottom, and R0 has higher priority than R12)
	PUSH {uwuLeft, uwuMid, uwuRight} ; save the current left mid right value uwu
	MOV uwuRight, uwuMid ; right = mid
	B uwuMergeSort ; call uwuMergeSort with (left, mid)
	
	
	; sort right side
	MOV uwuHold, PC
	ADD uwuHold, #20 ; current PC with 20 bytes offset since we want to skip 2 PUSH, 1 MOV, 1 ADD, 1 uwuMergeSort
	
	PUSH {uwuHold} ; save the PC address uwu
	PUSH {uwuLeft, uwuMid, uwuRight} ; save the values uwu
	
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
	LDR uwuReadFrom, =uwuSortedArray ; read from sorted array uwu
	MOV uwuHold, #uwuWord ; save offset 4 to hold
	MUL uwuHold, uwuLeft, uwuHold ; multiply the offset by left's value (since when reading from the sorted array, it is supposed to start from sortedArray[left], for left temporary array)
	ADD uwuReadFrom, uwuHold ; add the offset to uwuReadFrom
	LDR uwuWriteTo, =uwuLeftArray ; write to the left temporary array uwu
	MOV uwuStartInt, #0 ; start from 0
	MOV uwuEndInt, uwuLeftS ; end when it is >= left array size uwu
	BL uwuReadArray ; uwu go read the array now
	
	; store to right array
	LDR uwuReadFrom, =uwuSortedArray ; read from sorted array uwu
	MOV uwuHold, #uwuWord ; save offset 4 to hold
	MUL uwuHold, uwuMid, uwuHold ; multiply the offset by mid's value
	ADD uwuHold, #uwuWord ; add the offset by 4 (mid + 1)
	ADD uwuReadFrom, uwuHold ; add the offset to the uwuReadFrom
	LDR uwuWriteTo, =uwuRightArray ; write to the right temporary array
	MOV uwuStartInt, #0 ; uwu start from 0
	MOV uwuEndInt, uwuRightS ; end when it is >= right array size uwu
	BL uwuReadArray ; uwu go read the array now
	
	LDR uwuLeftArrayR, =uwuLeftArray ; load address of left array
	LDR uwuRightArrayR, =uwuRightArray ; load address of right array
	LDR uwuSortedArrayR, =uwuSortedArray ; load address of sorted array
	MOV uwuHold, #uwuWord ; hold 4 as offset
	MUL uwuHold, uwuLeft, uwuHold ; multiply the offset by 
	ADD uwuSortedArrayR, uwuHold
	MOV uwuI, #0 ; set I as 0 uwu
	MOV uwuJ, #0 ; set J as 0 uwu
	BL compare ; go to compare uwu
	BL uwuStoreLeft ; store the remaining values in left array uwu
	BL uwuStoreRight ; store the remaining values in right array uwu
	POP {uwuLeft, uwuMid, uwuRight, PC} ; we going bakkkk uwu
	
compare
	CMP uwuI, uwuLeftS ; check if I < left array size
	CMPLT uwuJ, uwuRightS ; check if J < right array size
	BXGE LR ; if not, return back
	LDR uwuHold, [uwuLeftArrayR] ; get value from left array
	LDR uwuHold2, [uwuRightArrayR] ; get value from right array
	CMP uwuHold, uwuHold2 ; compare
	STRLT uwuHold, [uwuSortedArrayR] ; store left is less than
	ADDLT uwuLeftArrayR, #uwuWord ; increment left array address
	ADDLT uwuI, #1 ; increment for I
	STRGE uwuHold2, [uwuSortedArrayR] ; store right if hold >= hold2
	ADDGE uwuRightArrayR, #uwuWord ; increment right array address
	ADDGE uwuJ, #1 ; increment for J
	ADD uwuSortedArrayR, #uwuWord ; increment the address of sorted array
	B compare ; repeat

uwuStoreLeft
	CMP uwuI, uwuLeftS ; compare I and size of left array
	BXGE LR ; return back if I >= size
	LDR uwuHold, [uwuLeftArrayR] ; take value from left array
	STR uwuHold, [uwuSortedArrayR] ; store to sorted array
	ADD uwuLeftArrayR, #uwuWord ; increment the left array address by 4
	ADD uwuI, #1 ; increment I by 1
	ADD uwuSortedArrayR, #uwuWord ; increment the sorted array's address by 4 (points to next value)
	B uwuStoreLeft ; repeat uwu
	
uwuStoreRight
	CMP uwuJ, uwuRightS ; compare J and size of right array
	BXGE LR ; return back if J >= size
	LDR uwuHold2, [uwuRightArrayR] ; take value from right array
	STR uwuHold2, [uwuSortedArrayR] ; store to sorted array
	ADD uwuRightArrayR, #uwuWord ; increment the right array address by 4
	ADD uwuJ, #1 ; increment J by 1
	ADD uwuSortedArrayR, #uwuWord ; increment the sorted array's address by 4 (points to next value)
	B uwuStoreRight ; repeat uwu

; uwu end
uwuStop B uwuStop	
	
uwuUnsortedArray DCD 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 ; original unsorted array uwu	
	
	AREA uwuMemory, DATA, READWRITE
uwuStackMemory SPACE 4096 ; used for storing stack value (PUSH and POP) uwu
uwuLeftArray SPACE 40 ; used to store left side array during merge process uwu
uwuRightArray SPACE 40 ; used to store right side array during merge process uwu
uwuSortedArray SPACE 40 ; used to store the sorted array uwu
	END