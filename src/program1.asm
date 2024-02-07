call clearTextScreen

mov si, pgmLoadedMsg
call printString

mov ah, 0x00
int 0x16

mov ax, 0x2000
mov es, ax
xor bx, bx

mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

jmp 0x2000:0x0000

%include "include/functions/print_string.inc"
%include "include/screen/clear_text_screen.inc"

pgmLoadedMsg: db 'Program 1, Loaded', 0xA, 0xD, 0

times 512-($-$$) db 0