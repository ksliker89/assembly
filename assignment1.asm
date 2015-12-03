; Kevin Sliker
; 20151010
; assignment1 cs271(elementary arithmetic)
; This program prompts the user to enter two integers upon which
; the program returns the sum, difference, product, quotient, and remainder.


INCLUDE Irvine32.inc




;-----------------------------------------------------------------------------------------
;----------                  Variable Declaration                     --------------------
;-----------------------------------------------------------------------------------------
.data
prompt_intro		byte "Welcome to Elementary Arithmetic    by Kevin Sliker", 0dh, 0ah
					byte "Please enter two numbers, and I will show you the sum,", 0dh, 0ah
					byte "difference, product, quotient, and remainder.", 0dh, 0ah, 0
prompt_exit			byte "Program is complete.", 0dh, 0ah
prompt_instr1		byte "Please enter a value:", 0
prompt_instr2		byte "Please enter another value:", 0
prompt_sum			byte "The sum of ", 0
prompt_product		byte "The product of ", 0
prompt_difference	byte "The difference between ", 0
prompt_quotient		byte "The quotient of ", 0
prompt_remainder	byte " with remainder: ", 0
prompt_and			byte " and ", 0
prompt_is			byte " is: ", 0
val1				sdword 0
val2				sdword 0
product				sdword 0
quotient			sdword 0
sum					sdword 0
remainder			sdword 0
difference			sdword 0
;------------------------------------------------------------------------------------------





; -----------------------------------------------------------------------------------------
; ----------                    Main Program                           --------------------
; -----------------------------------------------------------------------------------------
.code
main proc


; ------------------------------------------
; Introduction------------------------------
; ------------------------------------------
mov		edx, offset prompt_intro
call	WriteString							; writes a string to the console "welcome..."
call	Crlf								; creates a newline
; ------------------------------------------



; -------------------------------------------------------
; Get the first and second values from the user----------
; -------------------------------------------------------
mov		edx, offset prompt_instr1			
call	WriteString							; writes a string to the console "enter first value..."
call	ReadInt								; reads a 32 - bit integer from the console
mov		val1, eax							; populate val1 with user entered integer


mov		edx, offset prompt_instr2
call	WriteString							; writes a string to the console "enter another value..."
call	ReadInt								; reads a 32 - bit integer from the console
mov		val2, eax							; populate val2 with user entered integer
; --------------------------------------------------------
call	Crlf
call	Crlf




; --------------------------------------------------------------
; Perform calculations: product, quotient, sum, difference------
;		                and output the results            ------
; --------------------------------------------------------------

; -------------------- calculate product -----------------------
mov		eax, val1
mov		ebx, val2							; set val1 and val2 in proper register
mul		ebx									; multiply val1 by val2
mov		product, eax						; store in product
; ----------  output the product to the screen    ---------------
mov		edx, offset prompt_product			; set prompt in register
call	WriteString							; show user product prompt "the product of..."
mov		eax, val1							; put val1 into register
call	WriteInt							; show user val1 "x"
mov		edx, offset prompt_and				; set prompt in register
call	WriteString							; show user and prompt " and "
mov		eax, val2							; set val2 into register
call	WriteInt							; show user val2 "y"
mov		edx, offset prompt_is				; set prompt is
call	WriteString							; show user is prompt " is: "
mov		eax, product						; set product in register
call	WriteInt							; show user product "z"
call	Crlf
call	Crlf


; ----------------------- calculate quotient  --------------------------
mov		eax, val1
mov		ebx, val2							; set val1 and val2 in proper register
sub		edx, edx							; zero out edx register so there is no overflow error
idiv	ebx									; divide val1 by val2
mov		quotient, eax						; store quotient
mov		remainder, edx						; store remainder
; ----------- output the quotient to the screen --------------
mov		edx, offset prompt_quotient			; set prompt in register
call	WriteString							; show user quotient prompt "the quotient of ..."
mov		eax, val1							; put val1 into register
call	WriteInt							; show user val1 "x"
mov		edx, offset prompt_and				; set prompt in register
call	WriteString							; show user and prompt " and "
mov		eax, val2							; set val2 into register
call	WriteInt							; show user val2 "y"
mov		edx, offset prompt_is				; set prompt in register
call	WriteString							; show user is prompt " is: "
mov		eax, quotient						; set quotient in register
call	WriteInt							; show user product "z"
; ----------- output the remainder to the screen --------------
mov		edx, offset prompt_remainder		; set prompt in register
call	WriteString							; show user remainder prompt " with remainder: "
mov		eax, remainder						; set remainder in register
call	WriteInt							; show user remainder
call	Crlf
call	Crlf





; --------------------- calculate sum -----------------------------------
mov		eax, val1
add		eax, val2							; add val1 with val2
mov		sum, eax							; store addition into sum
; ----------------- output the result to the screen ---------------------
mov		edx, offset prompt_sum				; set prompt in register
call	WriteString							; show user prompt sum "the sum of ..."
mov		eax, val1							; set val1 in register
call	WriteInt							; show user val1 "x"
mov		edx, offset prompt_and				; set prompt and in register
call	WriteString							; show user prompt " and "
mov		eax, val2							; set val2 in register
call	WriteInt							; show user val2 "y"
mov		edx, offset prompt_is				; set prompt is in register
call	WriteString							; show user prompot " is: "
mov		eax, sum							; set sum in register
call	WriteInt							; show user sum "z"
call	Crlf
call	Crlf


; ------------------------- calculate difference -------------------------
mov		eax, val1
sub		eax, val2							; subtract val2 from val1
mov		difference, eax						; store in difference
; ------------------- output the result to the screen --------------------
mov		edx, offset prompt_difference		; set the difference prompt in register
call	WriteString							; show the user prompt difference "the difference of ..."
mov		eax, val1							; set val1 in register
call	WriteInt							; show user val1 "x"
mov		edx, offset prompt_and				; set prompt and in register
call	WriteString							; show user prompt and " and "
mov		eax, val2							; set val2 in register
call	WriteInt							; show user val2 "y"
mov		edx, offset prompt_is				; set prompt is in register
call	WriteString							; show user prompt is " is: "
mov		eax, difference						; set difference in register
call	WriteInt							; show user difference "z"
call	Crlf
call	Crlf




; ------------------------- say goodbye -----------------------
mov		edx, offset prompt_exit				; set prompt in register
call	WriteString							; show user exit prompt "program complete."
; -------------------------------------------------------------


call WaitMsg
invoke ExitProcess, 0

main endp
end main