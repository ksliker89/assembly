; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151118
; Title: assignment6 cs271(factorials and combinatorics OptionB)
; Usage: This program uses combinatorics, to interact with the user. It is essentially a combination game. It
;    	 will give the user a randomly generated n and r, then compute nCr. 
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc
INCLUDE GraphWin.inc

NHI = 12							; global constant for n upperbound
NLO = 3								; global constant for n lowerbound
									; the reason for bounds is to keep the factorial size down to 32 bits


.data                           	; declare variables
N			DWORD 0					; varibale for n
R			DWORD 0					; varibale for r
result		DWORD 0					; variable for combination to get stored in
userAnswer	BYTE 20 DUP(?)			; variable for the user to try and guess the combination
userNumber	DWORD 0

.code								; main program
main proc
	call Randomize
	call sayHello					; runs the SayHello procedure (mostly prompts explaining the program)
	
	push OFFSET N					; pass N as parameter
	push OFFSET R					; pass R as parameter
	call showProblem				; shows the problem with n and r passed to it
	
	push OFFSET userAnswer			; push the string
	push OFFSET	userNumber			; push the number
	call getData					; gets the users answer to the combinatorics problem
	
	push N							; pass N as parameter
	push R							; pass R as parameter
 	push OFFSET result				; pass result as a parameter
	call combinations

	push OFFSET result				; pass result as a parameter
	push N							; pass N as a parameter
	push R							; pass R as a parameter
	push userNumber					; pass the number(converted from string) to function as parameter
	call showResults				; displays the correct answer

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
	mWrite "Welcome to the combinatorics calculator."
	call crlf
	mWrite "By: Kevin Sliker"														; introduction to the user
	call crlf
	call crlf
	mWrite "I'll give you a combinations problem. You enter your answer, "			; display the directions to the user 
	call crlf
	mWrite "and I'll let you know if you're right."
	call crlf
	ret
sayHello ENDP




;---------------------------------------------------------------------------------------
; Procedure: show the problem to the user
; Parameters: n r 
; PreConditions: none
; PostConditions: none
; Registers Changed: all
;---------------------------------------------------------------------------------------

showProblem PROC

	push ebp									; save ebp register
	mov ebp, esp								; copy esp into ebp
	mov ecx, [ebp+8]							; address of N
	mov ebx, [ebp+12]							; address of R

	; create and store N
	mov eax, NHI								; number high bound
	sub eax, NLO								; number low bound
	inc eax										; increment to send to randomization
	call RandomRange							; randomize
	add eax, NLO								; 
	mov [ecx], eax								; store random into ecx - N
	
	; create and store R
	call RandomRange
	inc eax
	mov [ebp+12], eax
	mov [ebx], eax								; store random into ebx - R

	mWrite "Problem:"
	call crlf
	mWrite "Number of elements in the set: "
	mov	 eax, [ecx]								; output the problem to the user
	call WriteInt								; with the given random numbers
	call crlf

	mWrite "Number of elements to choose from the set: "
	mov eax, [ebx]								; output the problem to the user
	call WriteInt								; with the given random numbers
	call crlf

	pop ebp
	ret 8
showProblem ENDP


;---------------------------------------------------------------------------------------
; Procedure: get the data from the user
; Parameters: user string, user number
; PreConditions: none
; PostConditions: nione
; Registers Changed: all
;---------------------------------------------------------------------------------------

getData PROC
	push	ebp							
	
	mov		ebp, esp
	mov		edx, [ebp+12]					; userAnswer the string
	mov		ebx, [ebp+8]					; userNumber the actual integer
	mov		ecx, 32							; how many bits can be in the array

	mWrite "What is your answer? "			
	call	ReadString						; get the users guess
	mov		ecx, eax						; copy it
	mov		esi, [ebp+12]					; move it into the userAnswer string
	cld
	cdq


validate:
	lodsb									; load a byte
	cmp		al,48							; make sure its withing lower bound of ascii
	jl		invalidInp		
	cmp		al,57							; make sure its within upper bound of ascii
	jg		invalidInp
	push	ecx								; save the ecx for counter
	mov		ecx, 10							; this is the 10 needed for multiplication
	
	movzx	eax, al							; save the single byte from user string
	sub		eax, 48							; sub it with 48 to get difference in ascii values

	push	eax								; save the eax register (result) of sub above
	mov		eax, edx						; grab edx (starts at nothing, then repopulates to next byte in string)
	mul		ecx								; multiply it by 10
	mov		edx, eax						; move it to edx to be saved
	pop		eax								; get the subtraction eax value
	add		edx, eax						; add those two terms together
	pop		ecx								; restore the counter for loop
	loop	validate						; loop if needed
	jmp		finish							; if not loop, jump to finish
	
invalidInp:
	mWrite	"You did not enter a digit! Please try again: "
	mov		edx, [ebp+12]					; userAnswer the string
	mov		ecx, 32							; max size of bits the user can enter
	call	ReadString						; read user input
	mov		ecx, eax						; save string size into ecx
	mov		esi, [ebp+12]					; move old value into register
	cdq
	jmp		validate						; check to validate that value

finish:
	mov		eax, [ebp+8]					; userNumber the integer
	mov		[ebx], eax						; save the value of ebx into userNumber
	
	pop		ebp
	ret		8
getData ENDP





;---------------------------------------------------------------------------------------
; Procedure: calculates the factorials
; Parameters: n, r, and user number
; PreConditions: none
; PostConditions: none 
; Registers Changed: all
;---------------------------------------------------------------------------------------

combinations PROC 

	push ebp
	mov ebp, esp
	mov ebx, [ebp+16]				; get N
	mov eax, ebx

									;make calls to factorial
	push eax						; numerator
	call factorial
	mov edi, eax					; save N! in edi
	pop eax
	mov ecx, eax					; save N

	mov ebx, [ebp+12]				; get R
	mov eax, ebx
	push eax						;ldenom
	call factorial
	mov esi, eax					; save R!
	pop eax
	mov edx, eax					; save R
	
									; calculate (N-R)!
	mov ebx, edx					; move R into ebx
	mov eax, ecx					; move N into eax
	sub eax, ebx					; N-R

	push eax						; eax = N-R
	call factorial					; (N-R)!
	mov esi, eax					; esi holds (N-R)!
	pop eax							; eax = N-R					
	
									; calculate result n! / r!
	mov eax, edi					; edi = N!
	mov ebx, esi					; esi = R!
	cdq
	div ebx							; eax = (n!)/(r!)
									
	mov ebx, esp					; (n! / r!) / (n-r)!
	cdq								; eax = n! / r!
	div ebx							; eax = result
	
	mov ebx, [ebp+8]				; save result
	mov [ebx], eax					; get result

	pop ebp
	ret 12
combinations ENDP



;---------------------------------------------------------------------------------------
; Procedure: recursive function to factorial the numbers given
; Parameters: n r n-r
; PreConditions: none
; PostConditions: none
; Registers Changed: all
;---------------------------------------------------------------------------------------

factorial PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp+8]				; could be N, R, or N-R
	cmp edx, 2						; compare it with 2 so we dont factorial uneeded numbers
	jg GO
	jle STOP

	GO:								; factorial is good
		dec edx						; decrement the value
		push edx					; save that value
		call factorial				; recursively call factorial on n-1
		pop ebx						; grab old value upon return
		mul ebx						; mul it with n...so eax = n (n-1)...

	STOP:
		pop ebp						; grab the od value and your done
		ret 						; return to factorial (recursion) or combinations
factorial ENDP

;---------------------------------------------------------------------------------------
; Procedure: show results to the user
; Parameters: r n result userNumber
; PreConditions: none
; PostConditions: none
; Registers Changed: all
;---------------------------------------------------------------------------------------

showResults PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+8]					; get userNumber
	mov esi, [ebp+12]					; get R
	mov ebx, [ebp+16]					; get N
	mov edx, [ebp+20]					; get result
	call crlf
	call crlf
	mWrite "There are "					; output the results to the user
	mov eax, edx						; result
	call WriteDec						; output results
	mWrite " combinations of "
	mov eax, esi						; output R
	call WriteDec
	mWrite " items from a set of "
	mov eax, ebx						; output N
	call WriteDec
	mWrite "."							; end of output to user

	mov eax, edi						; compare what the user guessed
	mov ebx, [edx]						; with what the actual answer was
	cmp eax, ebx
	je correct							; jump if correct
	jne notcorrect						; jumpp if wront


	correct:
		call crlf
		mWrite "You are correct!"		; tell the user they are correct
		pop ebp							; then return to main
		ret 8

	notcorrect:
		call crlf
		mWrite "You need more practice!"	;tell the user they are incorrect
		pop ebp								; then return to main
		ret 8
	
showResults ENDP

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
