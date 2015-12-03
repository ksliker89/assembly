; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151102
; Title: assignment3 cs271(integer accumulator)
; Usage: This program prompts the user to enter an integer in the range of [-100,-1].
;        The program then returns the sum and the average of the numbers input.
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc

LOWERBOUND = -100			; define global constants
UPPERBOUND = -1

; __________________________________Variable Declaration__________________________________

	.data
	user_name	BYTE 31 dup(?)			; user name
	range		SDWORD -1				; starts at negative b/c the while loop checks for anything greater than 0
	array 		SDWORD 50 dup(0)		; array where user inputs integers
	array_size  DWORD 0					; size of the array
	sum			SDWORD 0				; summation of the numbers in the array
	avg			SDWORD 0				; average of numbers in the array


	; __________________________________Main Program__________________________________
	.code
	main proc
	mov ecx, 0							; make counter zero
	mov esi, OFFSET array				; move array into register
	
	call SayHello						;runs the SayHello procedure (mostly prompts)
	call GetInput						;runs the GetInput procedure (also, computes accumulation of integers)
	call SayGoodbye						;runs the SayGoodbye procedure (mostly prompts)
	call WaitMsg
	invoke ExitProcess, 0
	main ENDP 



	; __________________________________Introduction__________________________________

	SayHello PROC 
		mWrite "Welcome to the 'Integer Accumulator'  by: Kevin Sliker"			; introduction to the user
		call crlf
		mWrite "Please enter your first name: "									; get users name 
		mReadString user_name													; store user first name into user_name
		call crlf
		mWrite "Hello, "
		mWriteString user_name													; say hello with the users name after hello
		call crlf
		ret
	SayHello ENDP


	; __________________________________Validate data from the user__________________________________

	GetInput PROC uses esi								; include the array in this procedure

		validate:
			.while range < 0							; stop program if user enters any nonnegative
				mWrite "Please enter a value between [-100,-1]: "
				call ReadInt							; read the range given from the user
				mov range, eax							; store the range value
           
				cmp range, UPPERBOUND					; check upper bound
				jle checklowerbound						; jump if less than or equal to lowerbound
				jg validate								; else jump to validate to start again

			checklowerbound:							
				cmp range, lowerbound					; check lower bound 
				jge store								; jump if greater than or equal to store the value
				jl validate								; else go back to validat and start again

			store:										
				mov [esi + 4 * ecx], eax				; store the verified value into array
				inc ecx									; increment the counter
				inc array_size							; also increment array size for later use
			.endw										; end while loop

	call SumArray 										; call to calculate the array sum and average
	ret													; end of proc, return to main
	GetInput ENDP



	; __________________________________Compute the Accumulated Integers__________________________________

	SumArray PROC uses esi								; include the array for calculations
		mov ecx, 0										; zero out counter
		mov eax, 0										; zero out register

	L1: 	
		add eax, [esi + 4 * ecx]						; loop through the offsets and add them
		inc ecx											; increment the counter
		cmp ecx, array_size								; when counter == array size stop loop
		mov sum, eax									; eax has the result, store result into sum
		jne L1 


		mWrite "You entered "							; begin outputting all the calculations to the user
		mov eax, array_size								; move size of the array into register
		call WriteInt									; output the number of valid inputs from the user
		mWrite " valid numbers."						; "you entered x valid numbers."
		call crlf
		mWrite "The Accumulated Integer is "			; output the accumulated integer to user
		mov eax, sum									; move sum into register
		call WriteInt									; show sum (accumulated integer) to user
		call crlf										; "the accumulated integer is x."
		mWrite "The rounded average is "				; output the average to the user
		mov eax, sum									; move sum into register for upcoming division
		cdq												; sign extend eax into edx
		mov ebx, array_size								; move arraysize into register for upcoming division
		idiv ebx										; divide sum by arraysize to get average
		frndint											; round down to nearest integer
		mov avg, eax									; put average into register
		call WriteInt									; show user the average
		call crlf										; "the rounded average is x."
		ret
	SumArray ENDP


	; __________________________________Say Goodbye__________________________________
	SayGoodbye PROC
		mWrite "Integer Accumulator is complete!"		; give the user confirmation of program execution and completion
		call crlf
		mWrite "Goodbye, "								; giver user exit greeting
		mWriteString user_name							; say goodbye to user with their name
		call crlf
		ret
	SayGoodbye ENDP

	
END main
