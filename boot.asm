[org 0x7c00]

start:

    mov ax, 0x0003 ;;; clear screen
    int 0x10

    mov ah, 0x0B ;;; set background color mode
    mov bh, 0x00

    mov bl, 0x01 ;;; color to set to
    int 0x10



    mov bx, str1
    call printString

    mov bx, nl
    call printString

    mov bx, str2
    call printString

    mov dx, 0x91AF
    call printHex

    jmp end


    ;;; Includes
    %include "functions/print_string.asm"
    %include "functions/print_hex.asm"

; Variables

str1: db 'String Test', 0
str2: db 'Hex Test: ', 0
nl: db 0xA, 0xD, 0

end:
    jmp end


times 510-($-$$) db 0
dw 0xAA55