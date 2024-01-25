printRegisters:
    call printNewLine
    mov si, printRegisterHeading
    call printString

    mov si, regString
    call printString ;; 'dx             '
    call printHex ;; prints dx
    
    mov byte [regString+2], 'ax' ;; skip 0xA and 0xD and at next location put a
    call printString
    mov dx, ax
    call printHex

    mov byte [regString + 2], 'b'
    call printString
    mov dx, bx
    call printHex

    mov byte [regString + 2], 'c'
    call printString
    mov dx, cx
    call printHex

    mov word [regString + 2], 'si' ;; replace bx with si
    call printString
    mov dx, si
    call printHex

    mov byte [regString + 2], 'd'
    call printString
    mov dx, di
    call printHex

    mov word [regString + 2], 'cs'
    call printString
    mov dx, cs
    call printHex

    mov byte [regString + 2], 'd'
    call printString
    mov dx, ds
    call printHex

    mov byte [regString + 2], 'e'
    call printString
    mov dx, es
    call printHex

    mov byte [regString + 2], 'f'
    call printString
    mov dx, fs
    call printHex

    mov byte [regString + 2], 'g'
    call printString
    mov dx, gs
    call printHex

    mov byte [regString + 2], 's'
    call printString
    mov dx, ss
    call printHex

    times 2 call printNewLine

    ret