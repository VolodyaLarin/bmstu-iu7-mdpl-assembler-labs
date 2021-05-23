EXTRN num:word
EXTRN output: far
EXTRN output_signed: far
EXTRN input_num: far


public CRLF
public menu_print
public input
public print_signed10
public print_unsigned16

SD SEGMENT para public 'DATA'
	menu_message db 'Menu:', 10, 13
	db '1. Input signed   2', 10, 13
	db '2. Print signed   10', 10, 13
	db '3. Print unsigned 8', 10, 13
	db '0. Exit', 10, 13
	db 'Input menu number: '
	db '$'
SD ends


SC SEGMENT para public 'CODE'

CRLF:
    ; new line
    push ax
    push dx

    mov ah, 02h
    mov dl, 13 ; CR
    int 21h
    mov dl, 10 ; LF
    int 21h 

    pop dx
    pop ax
    ret

input:
	call input_num
	call CRLF
	ret
print_unsigned16:
	mov ax, num
	mov dx, 8
	call output
	call CRLF
	ret

print_signed10:
	mov ax, num
	mov dx, 10
	call output_signed
	call CRLF
	ret

menu_print:
	mov ah, 09h
	mov dx, offset menu_message
	int 21h
	ret

SC ends
end