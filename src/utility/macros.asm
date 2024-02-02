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

printSpace:
    mov ah, 0x0e
    mov al, ' '
    int 0x10
    ret

hexToChar: ; assume hex in al
    add al, 0x30
    cmp al, 0x39
    jle _hexToChar
    add al, 0x7
_hexToChar:
    ret