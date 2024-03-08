save_file:
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
        je new_file
        stosb
        inc bx
        jmp rewriteFileTable

    new_file:
        mov cx, 10
        mov si, file_name
        rep movsb
        mov cx, 3
        mov si, type
        rep movsb
        mov al, 0x1
        stosb
        mov al, 0x1
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
    mov cl, 06h
    mov dh, 0
    mov dl, 0x80
    mov bx, 0x1000
    int 0x13
    ret

file_name: db 'programS  '
type: db 'bin'