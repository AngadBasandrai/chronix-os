saveFile:
    ;; TODO: check file in fileTable
    times 3 call printNewLine
    mov si, fileNameEnterMsg
    call printString
    mov di, fileName
    xor cx, cx
    fileNameLoop:
        mov ah, 0x00
        int 0x16
        mov ah, 0x0e
        int 0x10
        cmp al, 0x0D
        je fileExt
        mov [di], al
        inc di
        inc cx
        cmp cx, 10
        je fileExt
        jmp fileNameLoop
    fileExt:
        call printNewLine
        mov si, fileExtMsg
        call printString
        mov di, type
        xor cx, cx
    fileExtLoop:
        mov ah, 0x00
        int 0x16
        mov ah, 0x0e
        int 0x10
        cmp al, 0x0D
        je saveStart
        mov [di], al
        inc di
        inc cx
        cmp cx, 3
        je saveStart
        jmp fileExtLoop

    saveStart:

    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    endFileTableSaveFileLoop:
        mov al, [ES:BX]
        cmp al, '\'
        je fileTableEnded
        inc bx
        jmp endFileTableSaveFileLoop
    
    fileTableEnded:
        sub bx, 4
        mov di, sec
        mov al, [ES:BX]
        mov [di], al
        inc di
        inc bx
        mov al, [ES:BX]
        mov [di], al
        inc bx
        mov di, siz
        mov al, [ES:BX]
        mov [di], al
        inc di
        inc bx
        mov al, [ES:BX]
        mov [di], al

        mov ax, [sec]
        mov bx, [siz]
        add ax, bx
        ror ax, 8 ;; 2 nibbles or 2 hex chars
        mov di, sec
        mov [di], al

        
        mov di, secInt+1
        mov ax, [sec] ; ax = 0x080C
        and ax, 0x00FF
        xor dx, dx
        mov bx, 10
        div bx ; ax = ax//bx, dx = ax%bx
        mov [di], dl
        dec di
        xor dx, dx
        mov bx, 10
        div bx ; ax = ax//bx, dx = ax%bx
        mov [di], dl

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
        mov al, [secInt]
        stosb
        mov al, [secInt+1]
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
    mov cl, [sec]
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
        mov cl, [sec]
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

fileName: db '          ', 0
type: db '   ', 0
sec: db 0x00, 0
siz: db 0x00, 0
secInt: db '00', 0
fileNameEnterMsg: db 'Enter File Name: ', 0
fileExtMsg: db 'Enter File Extension: ', 0