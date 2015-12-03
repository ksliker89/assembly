; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151118
; Title: assignment5 cs271(working with arrays and generating random numbers)
; Usage: This program generates random numbers in the range [100 .. 999], displays the list, sorts the list,
;    	 displays the sorted list, and the median value of the list. 
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc

LOWERBOUND = 10			; define global constants
UPPERBOUND = 200
RANGEHI = 999
RANGELO = 100
MAX = 200

.data                           	; declare variables
numArray	DWORD MAX DUP(?) 	; declare an array of 200 elements
arraySize	DWORD 0		 	; declare and array count for the size of array
line_count 	BYTE 0			; variable for formatting output
median		DWORD 0			; varibale for calculating the median value


.code					; main program
main proc
	call sayHello			;runs the SayHello procedure (mostly prompts explaining the program)
	call getInput			;runs the GetInput procedure (gets the number of composites wanted by user)

	push OFFSET numArray 	; push the array onto stack
	push arraySize			; push arraySize onto stack
	call populateArray		; this loads the array with random integers
	mWrite "Before Sort:"
	call crlf
	call displayArray 		; this displays the array

	

	call sortArray
	mWrite "After Sort:"
	call crlf
	call displayArray

	call crlf
	call findMedian
	call crlf
	
	call sayGoodbye			;runs the SayGoodbye procedure (mostly prompts)
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
	mWrite "Sorting random integers.	      By: Kevin Sliker"		; introduction to the user
	call crlf
	mWrite "This program generates random numbers in the range [100...999],"	; display the directions to the user 
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
		mWrite "How many numbers should be generated? [10..200]: "	; make sure user enters a valid number
		call ReadInt						; read the range given from the user
		mov arraySize, eax					; store the range value
		cmp arraySize, UPPERBOUND				; check upper bound
		jle checklowerbound					; jump if less than or equal to upperbound
		jg validate						; else jump to validate to start again
	checklowerbound:							
		cmp arraySize, LOWERBOUND				; check lower bound 
		jge store						; jump if greater than or equal to store the value
		jl validate						; else go back to validate and start again
	store:
		mov arraySize, eax
	ret								; end of proc, return to main
getInput ENDP


;---------------------------------------------------------------------------------------
; Procedure: Populates the array with random numbers
; Parameters: range, numArray[]
; PreConditions: numArray is NULL
; PostConditions: numArray is populated with random numbers with arrayCount(size) == user entered input
; Registers Changed: ecx
;---------------------------------------------------------------------------------------

populateArray PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+12]
	mov ecx, [ebp+8]

	L1:
		mov eax, RANGEHI
		sub eax, RANGELO
		inc eax
		call RandomRange
		add eax, RANGELO

		mov [edi], eax
		add edi, 4
		loop L1
	pop ebp
	ret 
populateArray ENDP

;---------------------------------------------------------------------------------------
; Procedure: Displays the array of numbers
; Parameters: numArray[]
; PreConditions: numArray != NULL
; PostConditions: none
; Registers Changed: 
;---------------------------------------------------------------------------------------

displayArray PROC

	push ebp
	mov ebp, esp
	mov esi, [ebp+12]
	mov ecx, [ebp+8]
	mov edx, 0
	
	L1:
		mov eax, [esi+edx]
		call WriteDec
		add edx, 4
		mWrite "     "
		inc line_count
		.IF(line_count == 10)
			call crlf
			mov line_count, 0
		.ENDIF
		loop L1 
	pop ebp
	ret 
displayArray ENDP


;---------------------------------------------------------------------------------------
; Procedure: Sorts the array of numbers into descending order
; Parameters: numArray[]
; PreConditions: numArray != NULL
; PostConditions: none
; Registers Changed: 
;---------------------------------------------------------------------------------------

sortArray PROC
	
	call crlf

	push ebp


	mov ebp, esp
	
	mov ecx, [ebp+8]
	dec ecx


L1:	
	push ecx				; save outer loop count
	mov esi, [ebp+12]

L2:	
	mov eax,[esi]			; get array value
	cmp [esi+4], eax		; compare a pair of values
	jl L3					; if [esi] <= [edi], don't exch
	xchg eax,[esi+4]		; exchange the pair
	mov [esi],eax

L3:	
	add esi, 4				; move both pointers forward
	loop L2					; inner loop

	pop ecx					; retrieve outer loop count
	loop L1					; else repeat outer loop

L4:	
	pop ebp
	ret
sortArray ENDP



;---------------------------------------------------------------------------------------
; Procedure: Displays an exit prompt to the user.
; Parameters: none
; PreConditions: none
; PostConditions: none
; Registers Changed: none
;---------------------------------------------------------------------------------------

findMedian PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp+12] ; ARRAY
	mov eax, [ebp+8]  ; SIZE
	mov edx, 0
	
	push eax   ; push array size onto the stack to save its value
	mov ebx, 2  
	div ebx			; divide by two to see if array has even elts
	
	push edx
	mov ebx, 4			
	mul ebx				; multiply eax by 4 b/c elements in array are dword
	mov median, eax		; save current eax value into median to be used later in IF(edx != 0)
	
	pop edx
	pop eax

	

	.IF(edx == 0)
		mov ebx, 2
		div ebx
		mov ebx, 4
		mul ebx
		mov edx, eax

		; add the two elements
		mov eax, [esi+edx]
		add eax, [esi+edx-4]
		mov median, eax
	
		; divide by two
		mov eax, median
		mov ebx, 2
		cdq
		div ebx
		mWrite "The median is: "
		call WriteDec
		; reset edx to prevent going into next .IF
		mov edx, 0
	.ENDIF
	.IF(edx != 0)
		mov edx, median
		mov eax, [esi+edx]
		mWrite "The median is: "
		call WriteDec
	.ENDIF


	pop ebp
	ret
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
