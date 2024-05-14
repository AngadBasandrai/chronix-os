saveFile:
    ;; TODO: check file in fileTable
    ;; TODO: fix

    xor ax, ax
    mov es, ax
    mov di, 0x1000
    
    mov bx, 0x1000
    mov fs, bx
    xor bx, bx

    rewriteFileTable:
        mov al, [FS:BX]
        cmp al, '\'
        je newFile
        stosb
        inc bx
        jmp rewriteFileTable

    newFile:
        mov cx, 10
        mov si, fileName
        rep movsb
        mov cx, 3
        mov si, type
        rep movsb
        mov al, 0x1
        stosb
        mov al, 0x2
        stosb
        mov al, 0x0
        stosb
        mov al, 0x1
        stosb
        mov al, '\'
        stosb

    mov ah, 0x03
    mov al, 0x01
    xor ch, ch
    mov cl, 0x06
    mov dh, 0
    mov dl, 0x80
    mov bx, 0x1000
    int 0x13

    xor ax, ax
    mov es, ax

    mov ah, 0x02
    mov al, 0x01
    xor ch, ch
    mov cl, 0x0C
    mov dh, 0
    mov dl, 0x80
    mov bx, 0x9000
    int 0x13

    mov di, 0x9000

    mov si, hexCode
    
    xor cx, cx

    writeData:
        cmp cx, 512
        je writeSector
        mov dx, [si]
        mov [es:di], dx
        add di, 2
        add si, 2
        add cx, 2
        jmp writeData

    writeSector:
        mov ah, 0x03
        mov al, 0x01
        xor ch, ch
        mov cl, 0x0C
        mov dh, 0
        mov dl, 0x80
        mov bx, 0x9000
        int 0x13

    ;; Reload File Table
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x06
    mov dh, 0x00
    mov dl, 0x80
    mov bx, 0x1000
    mov es, bx
    mov bx, 0x0000
    int 0x13

    ret

fileName: db 'programS  '
type: db 'bin'