.186
PUBLIC num
extern CRLF: near
extern menu_print: near
extern input: near
extern print_signed10: near
extern print_unsigned16: near

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS
SD SEGMENT para public 'DATA'
	num word 'XX'
	err_msg db 10, 13, 'Incorrect menu position', 10, 13 , '$'
	menu_cmd dw exit, input, print_signed10, print_unsigned16
SD ENDS
SC SEGMENT para public 'CODE'
	assume CS:SC, DS:SD
err_menu:
	mov ah, 09h
	mov dx, offset err_msg
	int 21h
	jmp main_menu_loop
main:
    mov ax, SD
    mov ds, ax


	main_menu_loop:
		call CRLF
		call menu_print
		
		mov ah, 01h
		int 21h
		call CRLF

		mov ah, 0
		sub al, '0'

		cmp al, 3
		ja err_menu



		

		shl ax, 1h
		mov di, ax
		mov bp, offset menu_cmd
		
		

		call menu_cmd[di]	
	jmp main_menu_loop

	
    
exit:
    mov ah, 4ch
	int 21h
SC ENDS
END main