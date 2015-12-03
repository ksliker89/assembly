; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151105
; Title: assignment4 cs271(composite number finder)
; Usage: This program finds all of the composit numbers within a certain range. Specifically from [1 - 400].
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc

LOWERBOUND = 1			; define global constants
UPPERBOUND = 400


.data                           ; declare variables
range		DWORD 0		; variable for user to input range
nextComp	DWORD 0		; variable to check for composite numbers
divisor		DWORD 0     ; variable to divide nextComp by
line_count  BYTE 0		; variable used to format screen output


.code				; main program
main proc
	call sayHello			;runs the SayHello procedure (mostly prompts explaining the program)
	call getInput			;runs the GetInput procedure (gets the number of composites wanted by user)
	call displayComposite		;finds out if a number is composite and displays it to the screen
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
	mWrite "Composite Number using masm.       By: Kevin Sliker"		; introduction to the user
	call crlf
	mWrite "Enter the number of composite numbers you would like to see."	; display the directions to the user 
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
		mWrite "Please enter a value between [1 - 400]: "	; make sure user enters a valid number
		call ReadInt						; read the range given from the user
		mov range, eax						; store the range value
		cmp range, UPPERBOUND					; check upper bound
		jle checklowerbound					; jump if less than or equal to upperbound
		jg validate						; else jump to validate to start again
	checklowerbound:							
		cmp range, LOWERBOUND					; check lower bound 
		jge store						; jump if greater than or equal to store the value
		jl validate						; else go back to validate and start again
	store:
		mov eax, range
	ret								; end of proc, return to main
getInput ENDP



;---------------------------------------------------------------------------------------
; Procedure: Displays the composite numbers to the user within a given range.
; Parameters: none
; PreConditions: none
; PostConditions: none
; Registers Changed: EAX, ECX 
;---------------------------------------------------------------------------------------

displayComposite PROC
	mov ecx, range			; make range our counter
	
	mov nextComp, 4 		; first composite number is 4
	mov	divisor, 2			; start with dividing numbers by 2
	mWrite "Here are the composite numbers...."
	call crlf
	call crlf

	L1:	
		mov eax, nextComp	; find factors				
		mov ebx, divisor	; if found, display comp
		cdq					; sign extend eax for division
		div ebx				; if not, inc nextComp and loop
		
		cmp edx, 0			; check if division left a remainder
		je Comp				; if there is no remainder, then we have found a divisor
		jne notComp			; if there is a remainder, then we have not found a divisor
		

		Comp:
			mov eax, nextComp	; output the composite number to the screen
			call WriteDec
			mWrite "      "		; formatting the output screen
			inc nextComp
			inc line_count
			.IF(line_count == 5)
				call crlf
				mov line_count, 0
			.ENDIF
			loop L1
			
		notComp:
		    inc divisor			; increment the divisor and check it against nextComp
			mov eax, divisor
			mov ebx, nextComp
			.IF(eax == ebx)
				mov divisor, 2
				inc nextComp
			.ENDIF
			add ecx, 1			; dont count the iteration if the number was not composite
			loop L1	
	ret
displayComposite ENDP



;---------------------------------------------------------------------------------------
; Procedure: Displays an exit prompt to the user.
; Parameters: none
; PreConditions: none
; PostConditions: none
; Registers Changed: none
;---------------------------------------------------------------------------------------

sayGoodbye PROC
	call crlf
	mWrite "That is all the composite numbers within the given range."		; give the user confirmation of program execution and completion
	call crlf
	mWrite "Goodbye."					; giver user exit greeting
	call crlf
	ret
sayGoodbye ENDP


END main