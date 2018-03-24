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
;---------------------------
encr_1 db 'what to encrypt?$'
AskForKey db 'whats the key?$'
production db 'thats what i produced:$'
decr_1 db 'what to decrypt?$'
arrow db ' row --> $'
space db ' $'


; --------------------------
CODESEG
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

proc encrypt_letter
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
endp encrypt_letter

proc input_string
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
	
endp input_string

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
	
endp encrypt_message
proc decrypt_letter
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
	
endp decrypt_letter
proc decrypt_message
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
	
endp decrypt_message

proc square_encryption_main
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset encr_1
	call print
	pop ax
	
	push offset encryption_message
	call NewLine
	call input_string
	pop ax
	call NewLine
	
	push offset AskForKey
	call print
	pop ax
	call NewLine
	
	push offset keyword
	call input_string
	pop ax
	call NewLine
	
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
endp square_encryption_main

proc square_decryption_main
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset decr_1
	call print
	pop ax
	
	push offset decryption_message
	call NewLine
	call input_string
	pop ax
	call NewLine
	
	push offset AskForKey
	call print
	pop ax
	call NewLine
	
	push offset keyword
	call input_string
	pop ax
	
	call NewLine
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
endp square_decryption_main

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
proc encrypt_by_shift
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset shift_number
	call InputNumber
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
endp encrypt_by_shift
proc decrypt_by_shift
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	push offset shift_number
	call InputNumber
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
endp decrypt_by_shift

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
	push offset decryption_message
	call NewLine
	call input_string
	pop ax
	call NewLine
	
	call decrypt_by_shift
; --------------------------

exit:
	mov ax, 4c00h
	int 21h
END start





