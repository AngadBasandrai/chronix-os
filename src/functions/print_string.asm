;;; uses si

printString:
    pusha
printStringLoop:
    mov ah, 0x0e ;;; Teletype output
    lodsb
    cmp al, 0
    je _printString
    int 0x10
    jmp printStringLoop

_printString:
    popa
    ret