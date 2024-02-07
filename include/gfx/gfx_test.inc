gfxTest:
    mov ah, 0x0C ; write gfx pixel
    mov al, 0x01 ; color
    mov bh, 0x00 ; page no.
    mov cx, 0x64 ; column no.
    mov dx, 0x64 ; row no.
    int 0x10

line:
    inc cx
    inc dx
    cmp cx, 0x90
    je lineEnd
    int 0x10
    jmp line

lineEnd:
    mov ah, 0x00
    int 0x16
    jmp mainMenu