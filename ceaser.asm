IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
tester dw ?
leter_syntex db 061h

a_row db 27 dup(?)
b_row db 27 dup(?)
c_row db 27 dup(?)
d_row db 27 dup(?)
e_row db 27 dup(?)
f_row db 27 dup(?)
g_row db 27 dup(?)
h_row db 27 dup(?)
i_row db 27 dup(?)
j_row db 27 dup(?)
k_row db 27 dup(?)
l_row db 27 dup(?)
m_row db 27 dup(?)
n_row db 27 dup(?)
o_row db 27 dup(?)
p_row db 27 dup(?)
q_row db 27 dup(?)
r_row db 27 dup(?)
s_row db 27 dup(?)
t_row db 27 dup(?)
u_row db 27 dup(?)
v_row db 27 dup(?)
w_row db 27 dup(?)
x_row db 27 dup(?)
y_row db 27 dup(?)
z_row db 27 dup(?)
encrypted_letter dw ? 
message db 23 dup(?)
keyword db 23 dup(?)
;---------------------------
z db 'what to encrypt?$'
s db 'whats the key?$'
e db 'thats what i produced:$'

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

proc fill_array
; gets offset of array (length 26) to fill and number of letter tio start from
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov [leter_syntex], 061h
	mov bx, [bp + 4] ; array offset
	mov cx, [bp + 6] ; start number
start_point:
	add [leter_syntex], 1h
	loop start_point
	
	mov cx, 26
	
fill_loop:
	mov al, [leter_syntex]
	cmp al, 07Ah
	jg set_letter
	mov [bx], al
	inc bx
	add [leter_syntex], 1h
	loop fill_loop
	mov dl, '$'
	mov [bx], dl
	jmp kill_switch

set_letter:
	mov [leter_syntex], 061h
	jmp fill_loop
	
kill_switch:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
; fills the array according the start number
endp fill_array	

proc FillSquare
;gets nothing
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	xor bx, bx
	mov ax, 27
	mul bx
	add ax, offset a_row
	
fill_matrix:
	push bx
	push ax
	call fill_array
	pop ax ; cleaning
	pop ax ; cleaning
	inc bx
	mov ax, 27
	mul bx
	add ax, offset a_row
	cmp bx, 26
	jne fill_matrix
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;builds the viz'nare square
endp FillSquare

proc PrintSquare
;gets nothing 
	push ax
	push bx
	push cx
	push dx
	
	mov cx, 26
	mov ax, offset a_row
	
print_array:
	push ax
	call print
	call NewLine	
	pop bx
	add ax, 27
	loop print_array
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;prints the viz'nare square
endp PrintSquare
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
	mov bx, offset a_row
	mov cx, 26

search_loop:
	cmp [bx], ah
	je found_row
	add bx, 27
	loop search_loop

found_row:
	sub al, 061h
	xor cx, cx
	mov cl, al

go_over:
	inc bx
	loop go_over
	xor ax, ax
	mov al, [bx]
	mov [offset encrypted_letter], al
	mov ah, '$'
	mov [offset encrypted_letter + 1], ah
	
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
proc length_of_var
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
	
	mov bx, [bp + 4]; offset var
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
	
endp length_of_var
proc x
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
	mov di, offset message
	add bx, 2d
	add di, 2d
y:
	
	cmp al, [offset keyword + 1]
	je reset_bx
	
	cmp cl, [offset message + 1]
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
	jmp y

reset_bx:
	xor ax, ax
	mov bx, offset keyword
	jmp y

end_proc:

	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
	
endp x
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
	call FillSquare
	push offset z
	call print
	push offset message
	call NewLine
	call input_string
	call NewLine
	push offset s
	call print
	call NewLine
	push offset keyword
	call input_string
	call NewLine
	push offset e
	call print
	call NewLine
	call x
	
; --------------------------

exit:
	mov ax, 4c00h
	int 21h
END start


