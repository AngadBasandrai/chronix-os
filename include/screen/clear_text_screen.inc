clearTextScreen:
    mov ax, 0xB800 ;start of vid mem
    mov es, ax
    xor di, di ;es:di is start of vid mem

    mov ah, 0x17 ; blue bg, gray fg
    mov al, ' ' ;char to enter
    mov cx, 80*25 ;no of times char is entered is 80 columns*25 rows
    
    rep stosw

    mov ah, 0x02 ; int 0x10, ah 0x02 = move hardware cursor
    xor bh, bh ;page no.
    xor dx, dx
    int 0x10
    ret