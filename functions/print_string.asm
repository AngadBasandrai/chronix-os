;;; uses bx

printString:
    pusha
    mov ah, 0x0e ;;; Teletype output
    mov bh, 0x0
    mov bl, 0x07

printStringLoop:
    mov al, [si]
    cmp al, 0
    je _printString
    int 0x10
    add si, 1
    jmp printStringLoop

_printString:
    popa
    ret
