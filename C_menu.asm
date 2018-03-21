IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
sec db ?
encr_1 db 'What to encrypt?$'
AskForKey db 'Whats the key?$'
production db 'Thats what i produced:$'
decr_1 db 'What to decrypt?$'
arrow db ' Row --> $'
space db ' $'
DoubleTab db '		$'
initialize db 'Machin start protocol launched.$'
greeting db 'HI! Im a ceaser cipher encryption/decryption machin. you must be the guy  who woke me up$'
dot db '.$'
ability_declaration db 'So U got a few choices:$'
choice1 db '1) Encrypte something$'
choice2 db '2) Decrypte something$'
choice3 db '3) About my creatore(Lior Brumberg)$'
choice4 db '4) About me!(what i do, how i do it)$'
choice5 db '5) Exit$'
start_line db '/>$'
; --------------------------
CODESEG
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
	call NewLine
	call think
	call print_choices
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


