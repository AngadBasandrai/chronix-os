[org 0x7c00]

start:

    mov ax, 0x0003 ;;; clear screen
    int 0x10

    mov ah, 0x0B ;;; set background color mode
    mov bh, 0x00

    mov bl, 0x02 ;;; color to set to
    int 0x10

    mov ah, 0x0e

    mov bx, str1
    call printString

    mov bx, nl
    call printString

    mov bx, str2
    call printString

    jmp end

printString:
    mov al, [bx]
    cmp al, 0
    je _printString
    int 0x10
    add bx, 1
    jmp printString

_printString:
    ret

; Variables

str1: db 'Hello World!', 0
str2: db 'Bye!', 0
nl: db 0xA, 0xD, 0

end:
    jmp $


times 510-($-$$) db 0
dw 0xAA55