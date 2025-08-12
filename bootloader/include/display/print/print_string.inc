; bootloader/include/display/print/print_string.inc
; uses si and di to print string using video memory at 0xb8000 + offset

print_string:
    pusha
    char_loop:
        lodsb                 ; load [si] into al
        or al, al             ; null terminator
        jz end_print_string

        mov ah, 0x0f          ; for white text on black bg
        mov [es:di], ax       ; store ax to video memory i.e [es:di]
        add di, 2             ; next character cell, 1 for ah, 1 for al
        jmp char_loop

end_print_string:
    popa
    ret