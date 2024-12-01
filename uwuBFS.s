	AREA uwuCode, CODE, READONLY
	ENTRY
	
uwuWord EQU 4 ; define shortcut for 4 bytess uwu
uwuLeft EQU 4 ; offset for left node
uwuRight EQU 8 ; offset for right node
uwuTraversed EQU 12 ; offset for traversed value
uwuBlocked EQU 16 ; offset for blocking (the value has been used)
uwuNextNode EQU 20 ; offset for next node
uwuListSize EQU 15 ; the size of unsorted list

; general register
uwuSortCount RN R8 ; count if sorted for 15 times (the number of array)
uwuConstQueue RN R9 ; register for storing queue address
uwuCurrentIndex RN R10 ; R10 to keep track of the current element
					   ; using RN associate a register with a name
					   
; for sorting binary tree
uwuListR RN R0 ; register for storing the address of current list value
uwuTreeR RN R1 ; register for storing the address of variable of current tree node
uwuListValR RN R2 ; register for storing the value of current list address
uwuTreeValR RN R3 ; register for storing the value of current tree node
uwuCurrentTree RN R11 ; register that keep track of currentTreeAddress
	
; for uwu BFS
uwuSmallest RN R0 ; register for storing the current smallest value
uwuTakeAny RN R1 ; determine if BFS should take the next value as smallest (foundation)
uwuSmallestAddress RN R2 ; used to store the previous recorded smallest address
uwuCurrentNode RN R11 ; determine the current address of node in queue (that needs to be traverse)
uwuCurrentHold RN R12 ; register to hold current value from node / random things that need to be hold


; place root to tree uwu
uwuPlaceTreeRoot
	LDR uwuListR, =uwuUnsortedList ; R0 is now address of list
	LDR uwuTreeR, =uwuTree ; R1 is now address of tree
	MOV uwuCurrentTree, uwuTreeR ; R9 is now constantly pointing to the address of tree
	LDR uwuListValR, [uwuListR] ; R2 is now value of 1st element of list
	STR uwuListValR, [uwuTreeR] ; store the 1st element of list to tree
	LDR uwuTreeValR, [uwuTreeR] ; load the root value of to R3
	ADD uwuCurrentIndex, uwuCurrentIndex, #1 ; increment to index count

; sort the tree uwu
uwuSortTree
	CMP uwuCurrentIndex, #uwuListSize ; compare to see if all the values inside unsorted list has been placed to uwuTree
	BGE uwuBFSsortInitialize ; jump to BFS sort if all the values have been added
	
	; get the value of new element in list
	ADD uwuListR, uwuListR, #uwuWord ; shift the address of R1 (original pointing to uwuTree) to make it point to next value in list
	LDR uwuListValR, [uwuListR] ; get the value of n-th element in unsorted list

; search which *left or *right the node should be placed to uwu
uwuSearchChild
	LDR uwuTreeValR, [uwuTreeR]
	CMP uwuListValR, uwuTreeValR ; compare the value in current node in tree (starting from root) to the value of n-th element in list
	ADD uwuTreeR, uwuTreeR, #uwuWord ; shift 4 bytes to address of uwuTree (makes it point to *left of current node)
	ADDGT uwuTreeR, uwuTreeR, #uwuWord ; shift 4 bytes to the address of uwuTree if current value in list is greater than value in node (makes it point to *right)
	
	; create a new node and store it as the child if the child is null
	MOV R5, uwuCurrentIndex
	MOV R6, #uwuNextNode
	MUL R7, R5, R6 ; the offset of new node
	ADD R7, R7, uwuCurrentTree
	STR uwuListValR, [R7] ; store the value into the new node
	
	LDR R4, [uwuTreeR] ; load the value of *left or *right to R4
	CMP R4, #0 ; check if the child is null (indicate can add a new child)
	BEQ uwuCanStore ; jump to uwuCanStore for making the node a child, if the current *left or *right is empty
	MOV uwuTreeR, R4 ; else, if it is not empty (the pointer already has a node), make uwuTreeR (the node) to be the child node
	B uwuSearchChild ; continue looping until finding an empty edge
	
uwuCanStore
	STR R7, [uwuTreeR] ; store the address of node to *left or *right and thus making it a child
	LDR uwuTreeR, =uwuTree ; reset the root to original address after sucessfully storing
	ADD uwuCurrentIndex, uwuCurrentIndex, #1 ; increment the index count
	B uwuSortTree ; loop again for the next value in list


; BFS start here uwu
uwuBFSsortInitialize
	MOV uwuTakeAny, #1 ; at the start of traversing, it should been able to take on any value as the smallest
	MOV uwuCurrentIndex, #1 ; set value of current index to 1 (since we already have root as first element) (for queue, as in which index to add the next node)
	MOV uwuCurrentTree, #0 ; reset value of current index (for tree, as in which tree BFS is accessing from queue)
	LDR uwuConstQueue, =uwuQueue
	LDR uwuCurrentHold, =uwuTree ; currently hold the address of first node of tree
	STR uwuCurrentHold, [uwuConstQueue] ; store the first node to queue
uwuBFSsort
	MOV R3, uwuCurrentTree ; store the index of current tree node to R3
	MOV R4, #uwuWord ; R4 = #4
	MUL R5, R3, R4 ; the offset of current index (to determine which element in queue to access)
	ADD R5, R5, uwuConstQueue ; the address of current element that BFS should be accessing

	MOV R3, R5 ; copy the address of current element (in queue)
	LDR R3, [R3] ; replace R3 to the address of the node in tree to access
	LDR uwuCurrentHold, [R3] ; get the value of the tree
	LDR R4, [R3, #uwuBlocked] ; check if this value has been taken
	CMP R4, #0
	CMPEQ uwuTakeAny, #1 ; see if any value can be considered as the smallest
	MOVEQ uwuSmallest, uwuCurrentHold ; if uwuTakeAny == 1, then assign the uwuCurrentHold as smallest
	MOVEQ uwuTakeAny, #0 ; set uwuTakeAny to 0 (no longer take any value)
	MOVEQ uwuSmallestAddress, R3 ; now the smallest address is the one node being taken
	BNE uwuCompare
uwuAfterCompare
	BL uwuCheck ; check for *left
	BL uwuCheck ; check for *right
	
	ADD uwuCurrentTree, uwuCurrentTree, #1
	CMP uwuCurrentTree, #uwuListSize
	MOVEQ uwuCurrentHold, #1
	STREQ uwuCurrentHold, [uwuSmallestAddress, #uwuBlocked]
	BLT uwuBFSsort
	
	LDR uwuCurrentHold, =uwuSortedArray
	MOV R3, #uwuWord
	MOV R4, uwuSortCount
	MUL R5, R3, R4
	STR uwuSmallest, [uwuCurrentHold, R5]
	ADD uwuSortCount, uwuSortCount, #1
	CMP uwuSortCount, #uwuListSize
	BLT uwuBFSsortInitialize
	BGE uwuStop
	
uwuCheck
	ADD R3, #uwuWord ; first time to get *left, second time to get *right
	LDR R4, [R3] ; get *left / *right
	CMP R4, #0 ; check if its child is null
	BNE uwuAddNodeAddress
uwuCheckBack
	BX LR
	
uwuAddNodeAddress
	MOV R5, uwuConstQueue
	MOV R6, #uwuWord
	MUL R7, R6, uwuCurrentIndex
	
	ADD R5, R5, R7
	STR R4, [R5]
	ADD uwuCurrentIndex, uwuCurrentIndex, #1 ; after we add a node to the queue, we increment by 1
	B uwuCheckBack
	
uwuCompare
	CMP R4, #0
	CMPEQ uwuCurrentHold, uwuSmallest
	MOVLT uwuSmallest, uwuCurrentHold
	MOVLT uwuSmallestAddress, R3
	B uwuAfterCompare

uwuStop B uwuStop

uwuUnsortedList DCD 10, 5, 30, 78, 2, 19, 11, 23, 48, 79, 1, 14, 9, 41, 31 ; original unsorted array of values

	AREA uwuMemory, DATA, READWRITE
uwuTree SPACE 300 	; for storing the tree
					; it is 300 bytes because we have 5 variable for each nodes
					; 1. value
					; 2. *left
					; 3. *right
					; 4. traversed
					; 5. blocked (the value has been used)
					
uwuQueue SPACE 60 ; for storing queue when traversing through the graph

uwuSortedArray SPACE 60 ; for storing the sorted array

	END