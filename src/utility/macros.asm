printNewLine:
    mov ah, 0x0e
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    ret

printNewCommandSymbol:
    mov ah, 0x0e
    mov al, '/'
    int 0x10
    mov al, '>'
    int 0x10
    ret