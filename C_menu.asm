IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
current_letter dw ?
user_answer db ?
sec db ?
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
choice3 db '3) About my creatore(Lior Brumberg)$'
choice4 db '4) About me!(what i do, how i do it)$'
choice5 db '5) Exit$'
start_line db '/>$'
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
proc print_square
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
endp think 
proc print_choices
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
endp explain_WID

proc print_array
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
endp print_array
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
	cmp [user_answer], 3
	je my_bio
	cmp [user_answer], 4
	je EWID
	cmp [user_answer], 5
	je end_program
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




