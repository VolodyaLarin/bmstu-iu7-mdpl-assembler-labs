format ELF64 

section '.text'

; https://aaronbloomfield.github.io/pdr/book/x86-64bit-ccc-chapter.pdf
; To pass parameters to the subroutine,  we put up to six of them into registers 
; (in order:  rdi, rsi,rdx, rcx, r8, r9).  If there are more than six parameters
; to the subroutine, then push the rest ontothe  stack  inreverse  order
; (i.e.   last  parameter  first)  –  since  the  stack  grows  down,  the
;  first  of  theextra parameters (really the seventh parameter) parameter will
; be stored at the lowest address (thisinversion of parameters was historically
; used to allow functions to be passed a variable number ofparameters).

_my_strlen:
    ; rdi - input ptr
    ; rax - temp ptr
    mov rax, rdi

    test rax, rax
    je _my_strlen_loop_ends ; nullptr check

    _my_strlen_loop:
        cmp byte [rax], 0
        je _my_strlen_loop_ends
        inc rax
        jmp _my_strlen_loop
    _my_strlen_loop_ends:

    sub rax, rdi ; return ptr diff
    ret

public _my_strlen

_my_strcpy:
    ; rdi - dest string
    ; rsi - src string
    ; rdx - size of src strings

    test rdi, rdi
    je _my_strcpy_end ; nullptr check

    test rsi, rsi
    je _my_strcpy_end ; nullptr check


    add rsi, rdx ; go to end
    add rdi, rdx

    mov byte [rdi], 0 ;end c string

    dec rsi     ; last symbols
    dec rdi

    STD ; right to left
    mov rcx, rdx
    rep movsb

    _my_strcpy_end:
    ret
public _my_strcpy
