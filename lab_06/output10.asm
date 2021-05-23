.186

EXTRN num: word
PUBLIC output
PUBLIC output_signed

output_CODE SEGMENT para public 'CODE'
	osnovanie word 0
    assume CS:output_CODE



output_signed PROC far
    mov ax, num
    mov cx, 0
    cmp ax, cx
    jge output_signed_minus
        mov cx, ax ; save input registers
        mov bx, dx

        mov ah, 02
        mov dl, '-'
        int 21h ; print minus

        mov ax, cx
        mov dx, bx
        neg ax

    output_signed_minus:
    call output

    ret
output_signed ENDP
output PROC far
    mov osnovanie, dx
    mov bh, 02h
    mov dl, 0

    mov bp, sp
    sub sp, 17
    
    output10_buffer equ ss:[bp-17]  

    mov di, 16
    output10_loop:
        xor dx, dx
        div osnovanie
        add dl, '0'

        dec di
        mov ss:[bp + di] - 17, dl 

    cmp ax, 0
    jne output10_loop

    
    mov al, '$'
    mov ss:[bp] - 1, al

    mov bx, ds
    mov ax, ss
    mov ds, ax 
    
    mov ah, 09h
    mov dx, bp
    sub dx, 17
    add dx, di
    
    int 21h

    mov ds, bx    
    mov sp, bp
    ret
output ENDP

output_CODE ENDS
END