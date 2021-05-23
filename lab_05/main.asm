; Ларин В.Н. ИУ7-44Б
; символьная прямоугольная матрица
;
; транспонировать квадратную матрицу максимального размера,
; входящую в исходную и включающую элемент последней строки
; и последнего столбца

.186
MAX_WIDTH EQU 9h
MAX_HEIGHT EQU 9h

STK SEGMENT para STACK 'STACK'
	db 100 dup(?)
STK ENDS

SD1 SEGMENT para 'DATA'
    rows db 0
    cols db 0

    matrix DB MAX_WIDTH * MAX_HEIGHT DUP (?)

    input_error_msg db "Incorrect input $"
    input_msg db "Input rows and cols: $"
    input_els_msg db "Input matrix: $"

SD1 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:SD1

matrix_for_each:
    push ax
    push bx
    push cx
    push dx

    mov bx, sp
    
    mov ax, ss:[bx+ 4 * 2 + 4]  ; new line function
    push ax
    mov ax, ss:[bx+ 4 * 2 + 2]  ; every element functon
    

    mov ch, 0
    mov cl, rows
    mov bx, OFFSET matrix
    matrix_for_each_loop:
        push cx
        mov cl, cols
        matrix_for_each_loop_r:
            mov dl, [bx]
            call ax
            mov [bx], dl
            inc bx
        loop matrix_for_each_loop_r
        pop cx

        pop dx
        push dx

        call dx
    loop matrix_for_each_loop
    

    pop dx
    pop dx
    pop cx
    pop bx
    pop ax
    ret

matrix_input:
    push ax

    mov ah, 01h
    int 21h
    push ax

    mov ah, 02h
    mov dl, 20h;space
    int 21h 

    pop dx

    pop ax

    ret

matrix_print:
    push ax
    push dx

    mov ah, 02h
    int 21h

    mov dl, 20h;space
    int 21h 

    pop dx
    pop ax

    ret

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

matrix_transpose:
    ; транспонирование матрицы по заданию
    pusha

    mov ah, 0
    mov al, rows
    cmp al, cols

    ; find min
    JL matrix_transpose_if
        mov al, cols
    matrix_transpose_if:

    mov dh, rows
    mov dl, cols

    sub dl, al ; start rows submatrix
    sub dh, al ; start cols submatrix
    
    mov ch, 0
    matrix_transpose_loop:
        mov cl, ch
        matrix_transpose_loop_r:
            mov bx, cx 
            xchg bl, bh ; transposed 

            push cx
            
            add cx, dx ; count index in original matrix
            add bx, dx ; count index in original matrix
            
            call swap
            
            pop cx
        inc cl
        cmp cl, al
        JNE matrix_transpose_loop_r

    inc ch
    cmp ch, al
    JNE matrix_transpose_loop

    popa
    ret

swap:
    ; swap matrix[ch][cl] and matrix[bh][bl]

    pusha
    
    mov al, cols
    mul bh
    add al, bl
    mov dx, ax

    mov al, cols
    mul ch
    add al, cl    

    mov bx, OFFSET matrix
    add bl, al
    mov cl, [bx]

    mov bx, OFFSET matrix
    add bl, dl
    mov ch, [bx]

    xchg cl, ch

    mov bx, OFFSET matrix
    add bl, al
    mov [bx], cl

    mov bx, OFFSET matrix
    add bl, dl
    mov [bx], ch

    popa
    ret

input_num:
    mov AH, 01h 
    int 21h
    
    ; check num
    cmp al, '0'
    JLE exit_err
    cmp al, '9'
    JG exit_err 
    
    sub AL, '0'
    
    ret

main:
    ; setup data segment registers
	mov ax, SD1
	mov ds, ax

    mov ah, 09h
    mov dx, offset input_msg
    int 21h
    
    ; input rows
    call input_num
    mov rows, al


    mov ah, 02h
    mov dl, 20h;space
    int 21h 

    ; input cols
    call input_num
    mov cols, al

    call CRLF

    mov ah, 09h
    mov dx, offset input_els_msg
    int 21h
    
    call CRLF

    mov ax, CRLF
    push ax
    mov ax, matrix_input
    push ax
    call matrix_for_each
    sub sp, 4 ; clear stack
    
    call CRLF

    call matrix_transpose


    mov ax, CRLF
    push ax
    mov ax, matrix_print
    push ax
    call matrix_for_each
    sub sp, 4 ; clear stack

exit:
    mov ah, 4ch
	int 21h
exit_err:
    call CRLF

    mov ah, 09h
    mov dx, offset input_error_msg
    int 21h
    jmp exit
CSEG ENDS
END main