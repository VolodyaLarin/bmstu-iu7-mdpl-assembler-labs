.intel_syntax noprefix
# format ELF64 
# EQUAL_ANY       = 0000b
# RANGES          = 0100b
# EQUAL_EACH      = 1000b
# EQUAL_ORDERED       = 1100b
# NEGATIVE_POLARITY = 010000b
# BYTE_MASK    = 1000000b

.text

# https://aaronbloomfield.github.io/pdr/book/x86-64bit-ccc-chapter.pdf
# To pass parameters to the subroutine,  we put up to six of them into registers 
# (in order:  rdi, rsi,rdx, rcx, r8, r9).  If there are more than six parameters
# to the subroutine, then push the rest ontothe  stack  inreverse  order
# (i.e.   last  parameter  first)  –  since  the  stack  grows  down,  the
#  first  of  theextra parameters (really the seventh parameter) parameter will
# be stored at the lowest address (thisinversion of parameters was historically
# used to allow functions to be passed a variable number ofparameters).

.global _my_strcpy
.global _my_strlen

_my_strlen:
    # rdi - input ptr
    # rax - temp ptr
    mov rax, rdi

    test rax, rax
    je _my_strlen_loop_ends # nullptr check

    _my_strlen_loop:
        cmpb [rax], 0
        je _my_strlen_loop_ends
        inc rax
        jmp _my_strlen_loop
    _my_strlen_loop_ends:

    sub rax, rdi # return ptr diff
    ret

_my_strcpy:
    # rdi - dest string
    # rsi - src string
    # rdx - size of src strings

    test rdi, rdi
    je _my_strcpy_end # nullptr check

    test rsi, rsi
    je _my_strcpy_end # nullptr check

    mov rcx, rdx
    rep movsb
    movb [rdi], 0 #end c string

    _my_strcpy_end:
    ret

