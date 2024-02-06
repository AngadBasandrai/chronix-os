startEditor:
    call clearTextScreen
    xor cx, cx

    mov di, hexCode

editorLoop:
    xor ax, ax
    int 0x16
    cmp al, '\'
    je executeCode
    cmp al, '$'
    je endEditor
    mov ah, 0x0e
    int 0x10
    call asciiToHex
    inc cx
    cmp cx, 2
    je addToCode
    mov [hexByte], al
returnToLoop:  
    jmp editorLoop

asciiToHex:
    cmp al, 0x39
    jle hexNum
    sub al, 0x37
_asciiToHex:
    ret
hexNum:
    sub al, 0x30
    jmp _asciiToHex

addToCode:
    rol byte [hexByte], 4 ;; shifts hexByte 4 bits left i.e one digit left
    or byte [hexByte], al ;; put al into 2nd digit
    mov al, [hexByte]
    stosb   ; equivalent to mov [di],al inc di
    xor cx, cx
    mov al, ' '
    int 0x10
    jmp returnToLoop

executeCode:
    call addReturnCommand
    jmp hexCode

    jmp startEditor

endEditor:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x2000:0x0000 

addReturnCommand:
    mov al, 0xB8
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x00
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x00
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0xCD
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x16
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0xC3
    mov [hexByte], al
    mov [di], al
    inc di
    ret

hexByte: db 0x00

hexCode: times 255 db 0

    %include "src/screen/clear_text_screen.asm"
    %include "src/functions/print_string.asm"

times 1024-($-$$) db 0