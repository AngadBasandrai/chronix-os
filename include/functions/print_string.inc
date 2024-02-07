;;; uses si

printString:
    pusha
printStringLoop:
    mov ah, 0x0e ;;; Teletype output
    mov al, [si]
    cmp al, 0
    je _printString
    int 0x10
    inc si
    jmp printStringLoop

_printString:
    popa
    ret