txtFileFound:
    mov dl, al
    mov cl, 2
    mul cl
    call printNewLine
    call printHex
    jmp $