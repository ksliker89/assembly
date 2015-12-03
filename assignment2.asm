; *************************************************************************************************************
; Name: Kevin Sliker
; Date: 20151014
; Title: assignment2 cs271(fibinacci sequence)
; Usage: This program prompts the user to enter an integer in the range of 1-46.
;        The program then returns a fibinacci sequence starting from 1 and going to their entered number range.
; *************************************************************************************************************

INCLUDE Irvine32.inc
INCLUDE Macros.inc


; __________________________________Variable Declaration__________________________________

.data
user_name			byte 31 dup(?)		
range				dword 0
line_count			dword 0
fibinacci			dword 0





; __________________________________Main Program__________________________________

.code
main proc



; __________________________________Introduction__________________________________

mWrite "Welcome to the 'Fibanacci Sequence'    by Kevin Sliker"
call crlf


mWrite "Please enter your first name: " 
mReadString user_name										; store user first name into user_name
call crlf

mWrite "Hello, "
mWriteString user_name										; say hello with the users name after hello
call crlf

mWrite "Please enter a value between 1-46: "
call ReadDec												; read the range given from the user
mov range, eax												; store the range value





; __________________________________Validate data from the user__________________________________
	
.repeat
	cmp range, 47											; compare ranges
	jle displayFib											; if range is less than 47 jmp to displayFib
	mWrite "Bad Input, try again: "							; if range is bad input, ask user for another range value
	call ReadDec											; get the range for fib sequence from user
	mov range, eax											; store the number range into range variable
	call crlf
.until range < 47											; repeat this process until range is within bounds






; __________________________________Display the fibinacci numbers__________________________________

displayFib:
	mov ecx, range											; set the loop counter
	mov edx, 0												; clear edx register
	mov ebx, 1												; start ebx at first fib, 1

	fib:
		mov eax, ebx										; copy first fib num into eax register
		add eax, edx										; add first two fib nums
		mov ebx, edx										; store answer into ebx register
		mov edx, eax										; move to next two fib numbers in sequence
		call WriteInt										; output fibs to screen
		mWrite "     "
		dec range											; decrement the counter
		inc line_count								
		.IF (line_count == 5)								; inc line_count is strictly for 
			call crlf										; display purposes and formatting
			mov line_count, 0
		.ENDIF
		loop fib											; return to loop

	call crlf








; __________________________________Say Goodbye__________________________________
mWrite "Fibonacci Sequence is complete :) "
mWrite "Goodbye, "
mWriteString user_name										; say goodbye to user with their name
call crlf

		

call WaitMsg
invoke ExitProcess, 0
main endp
end main