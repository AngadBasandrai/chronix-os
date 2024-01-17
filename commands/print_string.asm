;;; uses bx

printString:
    pusha   ; push all registers to stack (this is done to not change any memory due to this function call)
    mov ah, 0x0e ;;; Teletype output

printStringLoop:
    mov al, [bx]
    cmp al, 0
    je _printString
    int 0x10
    add bx, 1
    jmp printStringLoop

_printString:
    popa ; pop all registers from stack
    ret