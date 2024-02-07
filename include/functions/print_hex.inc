;;; uses dx

printHex:
    pusha   ;store register
    xor cx, cx  ; init counter

printHexLoop:
    cmp cx, 4   ; check if counter is 4
    je _printHex
    
    mov ax, dx  ; move hex value into ax
    and ax, 0x000F  ; save only the last bit in ax
    add al, 0x30    ; add 30h to get it into ascii range of letters and numbers
    cmp al, 0x39    ; if less than equal to 39 than number otherwise letter
    jle movTobx
    add al, 0x7     ; add 7 to get into letters ascii range

movTobx:
    mov bx, hexString+5 ; set the last value of hexstring to be attached to bx
    sub bx, cx  ; move it back by cx times
    
    mov [bx], al    ; at the place where bx is attached set value to al
    ror dx, 4   ; rotate right to turn second last bit into last bit for next iteraton

    inc cx   ; increment counter
    jmp printHexLoop

_printHex:
    mov si, hexString
    call printString
    popa
    ret