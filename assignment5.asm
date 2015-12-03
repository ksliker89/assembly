; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151122
; Title: assignment5 cs271(working with arrays and generating random numbers)
; Usage: This program generates random numbers in the range [100 .. 999], displays the list, sorts the list,
;    	 displays the sorted list, and the median value of the list. 
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc
INCLUDE GraphWin.inc

LOWERBOUND = 10						; define global constants
UPPERBOUND = 200
RANGEHI = 999
RANGELO = 100
MAX = 200

.data                           	; declare variables
numArray	DWORD MAX DUP(?) 		; declare an array of 200 elements
arraySize	DWORD 0		 			; declare and array count for the size of array
line_count 	BYTE 0					; variable for formatting output
median		DWORD 0					; varibale for calculating the median value


.code								; main program
main proc
	

	call sayHello					; runs the SayHello procedure (mostly prompts explaining the program)
	call getInput					; runs the GetInput procedure (gets the number of composites wanted by user)

	push OFFSET numArray 			; push the array onto stack
	push arraySize					; push arraySize onto stack
	call populateArray				; this loads the array with random integers
	mWrite "Before Sort:"
	call crlf
	call displayArray 				; this displays the array before sorting

	

	call sortArray					; sorts the array
	mWrite "After Sort:"
	call crlf
	call displayArray				; this displays the array after sorting

	call crlf
	call findMedian					; calculates the median of the sorted array
	call crlf
	
	call sayGoodbye					; runs the SayGoodbye procedure (mostly prompts)
	call WaitMsg
	invoke ExitProcess, 0
main ENDP 





;---------------------------------------------------------------------------------------
; Procedure: Displays a few simple prompts to the user.
; Parameters: none
; PreConditions: none
; PostConditions: none
; Registers Changed: none
;---------------------------------------------------------------------------------------

sayHello PROC 
	mWrite "Sorting random integers.	      By: Kevin Sliker"							; introduction to the user
	call crlf
	mWrite "This program generates random numbers in the range [100...999],"			; display the directions to the user 
	mWrite "places them into a list. Displays the list and the mean, sorts the list,"
	mWrite "and displays the sorted list in descending order."
	call crlf
	ret
sayHello ENDP




;---------------------------------------------------------------------------------------
; Procedure: Gets the input from the user.
; Parameters: none
; PreConditions: none
; PostConditions: range = [1-400]
; Registers Changed: EAX, ECX
;---------------------------------------------------------------------------------------

getInput PROC
	validate:
		mWrite "How many numbers should be generated? [10..200]: "		; make sure user enters a valid number
		call ReadInt													; read the range given from the user
		mov arraySize, eax												; store the range value
		cmp arraySize, UPPERBOUND										; check upper bound
		jle checklowerbound												; jump if less than or equal to upperbound
		jg validate														; else jump to validate to start again
	checklowerbound:							
		cmp arraySize, LOWERBOUND										; check lower bound 
		jge store														; jump if greater than or equal to store the value
		jl validate														; else go back to validate and start again
	store:
		mov arraySize, eax												; save the entered value as the size of the array
	ret																	; end of proc, return to main
getInput ENDP


;---------------------------------------------------------------------------------------
; Procedure: Populates the array with random numbers between [RANGEHI...RANGELO]
; Parameters: array numArray, int arraySize
; PreConditions: numArray is NULL, arraySize is not NULL
; PostConditions: numArray is populated with random numbers with arrayCount(size) == user entered input
; Registers Changed: ebp, edi, ecx, eax, ebx, esp
;---------------------------------------------------------------------------------------

populateArray PROC
	push ebp									; save ebp register
	mov ebp, esp								; copy esp into ebp
	mov edi, [ebp+12]							; address of numArray
	mov ecx, [ebp+8]							; address of arraySize

	L1:
		mov eax, RANGEHI						
		sub eax, RANGELO						; subtract rangelo from rangehi
		inc eax									; add one to range
		call RandomRange						; returns random number between given eax range
		add eax, RANGELO						; add to rangelo

		mov [edi], eax							; move random number into array
		add edi, 4								; increment array position
		loop L1									; loop again until ecx = 0
	pop ebp										; return the saved ebp register to its original status
	ret											; return to main
populateArray ENDP

;---------------------------------------------------------------------------------------
; Procedure: Displays an array of numbers
; Parameters: array numArray, int arraySize
; PreConditions: numArray != NULL
; PostConditions: none
; Registers Changed: ebp, edi, ecx, eax, ebx, esp
;---------------------------------------------------------------------------------------

displayArray PROC

	push ebp									; save ebp register
	mov ebp, esp								; copy esp into ebp
	mov esi, [ebp+12]							; address of numArray
	mov ecx, [ebp+8]							; address of arraySize
	mov edx, 0									; clear edx register
	
	L1:
		mov eax, [esi+edx]						; get first element in array
		call WriteDec							; display the element
		add edx, 4								; increment to next element in array
		mWrite "     "
		inc line_count							; formatting 10 numbers per line
		.IF(line_count == 10)					;
			call crlf							;
			mov line_count, 0					; end of formatting
		.ENDIF
		loop L1									; loop again to display next element
	pop ebp										; return saved ebp register to original contents
	ret											; return to main procedure
displayArray ENDP


;---------------------------------------------------------------------------------------
; Procedure: Sorts the array of numbers into descending order using a bubble sort
; Parameters: array numArray, int arraySize
; PreConditions: numArray != NULL
; PostConditions: none
; Registers Changed: ebp, edi, ecx, eax, ebx, esp
;---------------------------------------------------------------------------------------

sortArray PROC
	call crlf
	push ebp									; save the contents of the ebp register

	mov ebp, esp								; copy esp into ebp
	mov ecx, [ebp+8]							; address of arraySize
	dec ecx										; decrement arraySize by 1 to not overstep swaps in bubble sort


L1:	
	push ecx									; save outer loop count
	mov esi, [ebp+12]							; address of numArray

L2:	
	mov eax,[esi]								; get array value
	cmp [esi+4], eax							; compare a pair of values
	jl L3										; if [esi] <= [edi], don't exch
	xchg eax,[esi+4]							; exchange the pair
	mov [esi],eax								; move next into array

L3:	
	add esi, 4									; move both pointers forward
	loop L2										; inner loop

	pop ecx										; retrieve outer loop count
	loop L1										; else repeat outer loop

L4:	
	pop ebp										; return the original contents to ebp
	ret											; return to main
sortArray ENDP



;---------------------------------------------------------------------------------------
; Procedure: Displays an exit prompt to the user.
; Parameters: array numArray, int arraySize
; PreConditions: none
; PostConditions: none
; Registers Changed: ebp, edi, ecx, eax, ebx, esp
;---------------------------------------------------------------------------------------

findMedian PROC
	push ebp									; save ebp register
	mov ebp, esp								; copy esp into ebp
	mov esi, [ebp+12]							; address of numArray 
	mov eax, [ebp+8]							; address of arraySize
	mov edx, 0									; clear edx register
	
	push eax									; push array size onto the stack to save its value
	mov ebx, 2  
	div ebx										; divide by two to see if array has even or odd amount of elements
	
	push edx									; save the remainder found in edx
	mov ebx, 4									; dword size to multiply by for correct array iteration
	mul ebx										; multiply eax by 4 b/c elements in array are dword
	mov median, eax								; save current eax value into median to be used later in IF(edx != 0)
	
	pop edx										; return edx (remainder) to edx
	pop eax										; return the arraySize to eax

	.IF(edx == 0)								; if array is even then we have to add two elements and divide them by two
		mov ebx, 2								; we want to divide by two
		div ebx									; make the division
		mov ebx, 4								; increment by size 4 b/c type is dword
		mul ebx									; multiply size by type
		mov edx, eax							; save this value for proper array iteration

		
		mov eax, [esi+edx]						; grab the left of middle element in array
		add eax, [esi+edx-4]					; add it to right of middle element in array
		mov median, eax							; save this addition into median
	
		; divide by two
		mov eax, median							; take the median found from above
		mov ebx, 2								; divide it by two to find new median
		cdq										; clear out register for division
		div ebx									; make the division
		mWrite "The median is: "
		call WriteDec							; display the median found
		
		mov edx, 0								; reset edx to prevent going into next .IF
	.ENDIF
	.IF(edx != 0)								; if the number of elements in array is odd just display middle element
		mov edx, median							; move calculated median (TYPE *4) into edx
		mov eax, [esi+edx]						; grab the position located in the middle of the array
		mWrite "The median is: "
		call WriteDec							; display the element in the middle of the array
	.ENDIF


	pop ebp										; return ebp to its original contents
	ret											; return to main
findMedian ENDP



;---------------------------------------------------------------------------------------
; Procedure: Displays an exit prompt to the user.
; Parameters: none
; PreConditions: none
; PostConditions: none
; Registers Changed: none
;---------------------------------------------------------------------------------------

sayGoodbye PROC
	call crlf
	mWrite "Goodbye."					; giver user exit greeting
	call crlf
	ret
sayGoodbye ENDP
END main
