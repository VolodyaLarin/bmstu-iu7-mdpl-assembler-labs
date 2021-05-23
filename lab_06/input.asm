.186

EXTRN num: word
PUBLIC input_num

input_num_CODE SEGMENT para public 'CODE'
    assume CS:input_num_CODE
input_num PROC far
    mov bp, sp

    sub sp, 66

    mov al, 62
    mov ss:[bp - 64], al

    ;; change ds for input
    mov bx, ds
    mov ax, ss
    mov ds, ax

    mov dx, bp
    sub dx, 64

    mov ah, 0ah

    int 21h
    mov ds, bx ; return ds
    
    mov si, 0

    mov cx, 0
    mov cl,  ss:[bp - 63] ; get str size


    mov al, 0
    mov ss:[bp - 66], al ; sign - is_negative
    
    mov al, '-'
    cmp al, ss:[bp + si] - 62
    jne positive_input ; if is negative
        mov al, 1
        mov ss:[bp - 66], al
        inc si
    positive_input:

    mov ax, 0
    parse_loop:
        mov dl, ss:[bp + si] - 62
        sub dl, '0'

        shl ax, 1
        add al, dl

        inc si

    cmp si, cx
    jne parse_loop


    mov dl, 0
    cmp dl, ss:[bp - 66]
    je negative_input_final; if is negative
        neg ax   
    negative_input_final:

    mov num, ax

    mov sp, bp
    ret
input_num ENDP

input_num_CODE ENDS
END