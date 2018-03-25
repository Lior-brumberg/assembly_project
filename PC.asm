IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
shift_number dw ?
decrypted_letter dw ?
current_letter dw ?
encrypted_letter dw ? 
encryption_message db 23 dup(?)
decryption_message db 23 dup(?)
keyword db 23 dup(?)
user_answer db ?
sec db ?
;----   printing section   ----
encr_1 db 'What to encrypt?$'
AskForKey db 'Whats the key?$'
production db 'Thats what i produced:$'
decr_1 db 'What to decrypt?$'
arrow db ' Row --> $'
space db ' $'
DoubleTab db '		$'
initialize db 'Machin start protocol launched.$'
greeting db 'HI! Im a ceasar cipher encryption/decryption machin.$'
dot db '.$'
ability_declaration db 'So U got a few choices:$'
choice1 db '1) Encrypte something$'
choice2 db '2) Decrypte something$'
choice3 db '3) About my creator(Lior Brumberg)$'
choice4 db '4) About me!(what i do, how i do it)$'
choice5 db '5) Exit$'
start_line db '/>$'
num_of_key_E db 'press 1 for Keyword encryption, 2 for number encryption, or any other     number to return to main menu.$'
num_of_key_d db 'press 1 for Keyword decryption, 2 for number decryption, or any other     number to return to main menu.$'
shift_num_msg db 'enter shift number: $'
;----   bio subsection   ----
BioBuffer db '=======   bio   ======= $'
MyName db 'NAME: Lior Brumberg $'
MyBirthDay db 'BIRTH DATE: 20/05/2001 $'
MyCity db 'HOMETOWN: HADERA $'
HighSchool db 'HIGHSCHOOL: tichon hadeara $'
exitMSG db 'Goodbye! mechin terminating...$'
;----   general subsection   ----
buffer db '============================= $'
;----   what I do subsection   ----
WIDline1 db 'I specialize at a type of encryption called "ceasar cipher"$'
WIDline2 db 'Its a type of encryption created by Julius Caesar, the greek ruler$'
WIDline3 db 'What I basiclly do is i shift the letter you input several positions ahead based on a keyword or a specific number $'
WIDline4 db 'If you choose to encrypt by number(lets say 1), i just move your letter 1 space ahead so A becomes B, C becomes D and so on...$'
WIDline5 db 'If you choose a keyword i use it and encrypt every letter in your message based on a letter from your keyword based on its order and a square called:     Vigenere square$'
WIDline6 db 'would you like to see it?(1- yes, other- no)$' 

; --------------------------
CODESEG
proc input_string
;gets offset of array
	push bp 
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov dx, [bp + 4] ; offset var to input
	mov bx, dx
	mov [byte ptr bx], 21
	mov ah, 0Ah
	int 21h 
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
; inputs a string to that array
endp input_string

proc print_square
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov bl, 'a'
	mov cx, 26
	
send_to_print:
	push bx
	call print_array
	pop ax
	call NewLine
	inc bx
	loop send_to_print
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret 
;prints the vignere square to the screen
endp print_square

proc InputNumber
; the procedure gets the offset address of a variable
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov ah, 1h
	int 21h 
	sub al, '0'
	mov bx, [bp + 4]
	mov [bx], al
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
; the procedure inputs a number from 0-9 into the variable.
endp  InputNumber

proc WaitingSec ; procedure for waiting to new second
	push ax	; put the registers in the stack
	push cx
	push dx
	mov ah, 2ch ; reading hours by DOS service
	int 21h  ; second will be copied into dh
	mov [sec], dh
ReadSec:
	int 21h ; reading hours by DOS service (new value)
	cmp dh, [sec]  ; equalize
	je ReadSec ;if not yet moved 18.2 "tics"
	pop dx ;renovation registers
	pop cx
	pop ax
	ret 0
endp WaitingSec
proc Print
; the procedure gets the offset of the msg to print
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	
	mov bx, [bp + 4]
	
	LEA DX, [bx]
	MOV AH, 09H
	INT 21H
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
; the procedure prints the message
endp Print

proc NewLine
; the procedure gets nothing
	push ax
	push bx
	push cx
	push dx
	
	mov dl, 0ah
	mov ah, 2h
	int 21h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
; the procedure performs a new line action.
endp NewLine

proc think
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	mov cx, 3
printloop:
	push offset dot
	call print
	pop ax
	call WaitingSec
	loop printloop
	push offset start_line
	call print
	pop ax
	push offset space 
	call print
	pop ax
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;simulates the "tjhinking" of the mechin(waits 3 secondes and prints a command line input symbol
endp think 

proc print_choices
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	push offset ability_declaration
	call print 
	pop ax
	call NewLine
	push offset DoubleTab
	call print
	pop ax
	push offset choice1
	call print
	pop ax	
	call NewLine
	push offset DoubleTab
	call print
	pop ax
	push offset choice2
	call print
	pop ax	
	call NewLine
	push offset DoubleTab
	call print
	pop ax
	push offset choice3
	call print	
	pop ax
	call NewLine
	push offset DoubleTab
	call print
	pop ax
	push offset choice4
	call print	
	pop ax
	call NewLine
	push offset DoubleTab
	call print
	pop ax
	push offset choice5
	call print	
	pop ax
	call NewLine
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;prints the main menu to the screen
endp print_choices

proc Biography
; the procedure gets nothing
	push ax
	push bx
	push cx
	push dx 
	
	push offset BioBuffer
	call Print 
	pop ax
	call NewLine
	
	push offset MyName
	call print 
	pop ax
	call NewLine
	
	push offset MyBirthDay
	call Print
	pop ax
	call NewLine
	
	push offset MyCity
	call Print 
	pop ax
	call NewLine
	
	push offset HighSchool
	call print 
	pop ax
	call NewLine
	
	push offset buffer
	call Print
	pop ax
	call NewLine
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret 
; the procedure prints the biography msg's.
endp Biography

proc explain_WID
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset WIDline1
	call print 
	pop ax
	call NewLine
	
	call think
	push offset WIDline2
	call print 
	pop ax
	call NewLine
	
	call think
	push offset WIDline3
	call print 
	pop ax
	call NewLine
	call WaitingSec
	call WaitingSec
	
	call think
	push offset WIDline4
	call print 
	pop ax
	call NewLine
	call WaitingSec
	call WaitingSec
	
	call think
	push offset WIDline5
	call print 
	pop ax
	call NewLine
	call WaitingSec
	call WaitingSec
	
	call think
	push offset WIDline6
	call print 
	pop ax
	call NewLine
	mov al, [user_answer]
	mov ah, 0
	push ax
	
	call think
	push offset user_answer
	call InputNumber
	pop ax
	
	cmp [user_answer], 1
	jne cont

print_Vigenère:
	call print_square

cont:
	pop ax
	mov [user_answer], al
	pop dx
	pop cx
	pop bx
	pop ax
	ret 
;prints the explanation subsection 
endp explain_WID

proc print_array
;gets the starting letter to print from
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov bx, [bp + 4] ; start letter
	mov [current_letter], bx
	mov ah, '$'
	mov [offset current_letter + 1], ah
	push offset current_letter
	call print
	pop ax;cleaning
	
	push offset arrow
	call print
	pop ax;cleaning
	
	xor ax, ax
	mov cx, 25
	mov al, 'z'
	
p_array_loop:
	mov [offset current_letter], bl
	push offset current_letter
	call print
	pop dx;cleaning
	
	push offset space
	call print
	pop dx;cleaning
	
	cmp bl, al
	jae move_bx_to_start
	
	inc bx
	loop p_array_loop
	jmp kill_proc

	
move_bx_to_start:
	mov bx, 'a'
	jmp p_array_loop

kill_proc:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
;prints the abc starting from the letter given to the letter before it.
endp print_array

proc encrypt_letter
;gets letter to encrypt and a keyletter 
	push bp 
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov al, [bp + 4]; letter to encrypt
	mov ah, [bp + 6]; letter to encrypt by
	cmp al, ' '
	je ending

	
	sub ah, 'a'
	add al, ah
	cmp al, 'z'
	jbe ending
	sub al, 26
	
ending:
	mov ah, '$'
	mov [encrypted_letter], ax
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
; encrypts the letter by the keyletter
endp encrypt_letter

proc encrypt_message
;gets nothing
	push bp 
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	
	mov bx, offset keyword
	mov di, offset encryption_message
	add bx, 2d
	add di, 2d
encryption_loop:
	
	cmp al, [offset keyword + 1]
	je reset_bx
	
	cmp cl, [offset encryption_message + 1] 
	je end_proc
	
	push [bx] ; encryption row
	push [di] ; encryption letter
	call encrypt_letter
	pop dx; cleaning
	pop dx; cleaning
	push offset encrypted_letter
	call print
	pop dx
	inc bx
	inc di
	inc ax
	inc cx
	jmp encryption_loop

reset_bx:
	xor ax, ax
	mov bx, offset keyword
	add bx, 2d
	jmp encryption_loop

end_proc:

	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
;encrypts the message from the global vars
endp encrypt_message

proc decrypt_letter
;gets letter to decrypt and keyletter
	push bp 
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	mov al, [bp + 4]; letter to decrypt
	mov ah, [bp + 6]; letter to decrypt by
	cmp al, ' ' ; in case its a space, ceaser cipher does not include spaces.
	je end_it
	sub ah, 'a'


	sub al, ah
	cmp al, 'a'
	jae end_it
	add al, 26
	
end_it:
	mov ah, '$'
	mov [offset decrypted_letter ], ax
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
;decrypts the letter by the keyletter
endp decrypt_letter

proc decrypt_message
;gets nothing
	push bp 
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	mov bx, offset keyword
	mov di, offset decryption_message
	add bx, 2d
	add di, 2d
decryption_loop:
	
	cmp al, [offset keyword + 1]
	je reset_counter
	
	cmp cl, [offset decryption_message + 1] 
	je end_proc2
	
	push [bx] ; decryption row
	push [di] ; decryption letter
	call decrypt_letter
	pop dx; cleaning
	pop dx; cleaning
	push offset decrypted_letter
	call print
	pop dx
	inc bx
	inc di
	inc ax
	inc cx
	jmp decryption_loop

reset_counter:
	xor ax, ax
	mov bx, offset keyword
	add bx, 2d
	jmp decryption_loop

end_proc2:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
;decrypts the message from the global vars
endp decrypt_message

proc square_encryption_main
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	call think
	push offset encr_1
	call print
	call NewLine
	pop ax
	
	call think
	push offset encryption_message
	call input_string
	pop ax
	call NewLine
	
	call think
	push offset AskForKey
	call print
	pop ax
	call NewLine
	
	call think
	push offset keyword
	call input_string
	pop ax
	call NewLine
	
	call think
	push offset production
	call print 	
	pop ax
	
	push offset space
	call print
	pop ax
	
	call encrypt_message
	call NewLine
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret 
;prints the encryption menu
endp square_encryption_main

proc square_decryption_main
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	call think
	push offset decr_1
	call print
	pop ax
	call NewLine
	
	call think
	push offset decryption_message
	call input_string
	pop ax
	call NewLine
	
	call think
	push offset AskForKey
	call print
	pop ax
	call NewLine
	
	call think
	push offset keyword
	call input_string
	pop ax
	call NewLine
	
	call think
	push offset production
	call print
	pop ax 	
	
	push offset space
	call print
	pop ax
	
	call decrypt_message
	call NewLine
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret 
	;prints the decryption menu
endp square_decryption_main

proc encrypt_by_shift
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset encr_1
	call think
	call print
	pop ax
	
	call NewLine
	call think
	push offset encryption_message
	call input_string
	pop ax
	
	call NewLine
	call think
	push offset shift_num_msg
	call print
	pop ax
	
	call NewLine
	call think
	push offset shift_number
	call InputNumber
	pop ax
	
	call NewLine
	call think
	push offset production
	call print
	pop ax
	
	add [shift_number], 'a'
	mov bx, offset encryption_message
	inc bx
	mov cl, [bx]
	inc bx
send_to_encryption:
	push [shift_number]
	mov ax, [bx]
	mov ah, 00
	push ax
	call encrypt_letter
	pop ax
	pop ax
	push offset encrypted_letter
	call print
	pop ax
	inc bx
	loop send_to_encryption
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;prints the menu and handles the shift encryption
endp encrypt_by_shift

proc decrypt_by_shift
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset decr_1
	call think
	call print
	pop ax
	
	call NewLine
	call think
	push offset decryption_message
	call input_string
	pop ax
	
	call NewLine
	call think
	push offset shift_num_msg
	call print
	pop ax
	
	call NewLine
	call think
	push offset shift_number
	call InputNumber
	pop ax
	
	call NewLine
	call think
	push offset production
	call print
	pop ax
	
	add [shift_number], 'a'
	mov bx, offset decryption_message
	inc bx
	mov cl, [bx]
	inc bx
	
send_to_decryption:
	push [shift_number]
	mov ax, [bx]
	mov ah, 00
	push ax
	call decrypt_letter
	pop ax
	pop ax
	push offset decrypted_letter
	call print
	pop ax
	inc bx
	loop send_to_decryption
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;prints and handles the decryption by shift
endp decrypt_by_shift

proc manage_encryption
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	call NewLine
	call think
	push offset num_of_key_E
	call print
	call NewLine
	pop ax
	call think
	
	mov al, [user_answer]
	mov ah, 00
	push ax
	push offset user_answer
	call InputNumber
	call NewLine
	pop ax
	
	cmp [user_answer], 1
	je manage_keyword
	cmp [user_answer], 2
	je manage_num
	jmp endTag

manage_num:
	call encrypt_by_shift
	jmp endTag
manage_keyword:
	call square_encryption_main

endTag:
	pop ax
	mov [user_answer], al
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;sends to the right encryption(num or keyword)
endp manage_encryption

proc manage_decryption
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	call NewLine
	call think
	push offset num_of_key_d
	call print
	call NewLine
	pop ax
	call think
	
	mov al, [user_answer]
	mov ah, 00
	push ax
	push offset user_answer
	call InputNumber
	call NewLine
	pop ax
	
	cmp [user_answer], 1
	je manage_keyword_d
	cmp [user_answer], 2
	je manage_num_d
	jmp EndTag2

manage_num_d:
	call decrypt_by_shift
	jmp EndTag2
manage_keyword_d:
	call square_decryption_main

EndTag2:
	pop ax
	mov [user_answer], al
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;sends to the right decryption(num or keyword)
endp manage_decryption

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
	call WaitingSec
	push offset initialize
	call print
	call NewLine
	call think
	push offset greeting
	call print
ask:	
	call NewLine
	call think
	call print_choices
	call think
	
	push offset user_answer
	call InputNumber
	call NewLine
	
	cmp [user_answer], 1
	je encrypt_process
	
	cmp [user_answer], 2
	je decrypt_process
	
	cmp [user_answer], 3
	je my_bio
	
	cmp [user_answer], 4
	je EWID
	
	cmp [user_answer], 5
	je end_program
	jmp ask

decrypt_process:
	call manage_decryption
	jmp ask
encrypt_process:
	call manage_encryption
	jmp ask
my_bio:
	call think
	call biography
	jmp ask
EWID:
	call think
	call explain_WID
	call NewLine
	jmp ask
end_program:
	push offset exitMSG
	call print
	
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


