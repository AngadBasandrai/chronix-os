printFileTable:

    call clearTextScreen
    
    mov si, fileTableHeading
    call printString

    xor cx, cx  ;; reset counter
    mov ax, 0x1000 
    mov es, ax
    xor bx, bx ;; es:bx = 0x1000:0x0000, where file table is loaded
    mov ah, 0x0e
    call printNewLine

printFileTableLoop:
    inc bx ;; to skip { in the beggining of file Table
    mov al, [ES:BX] ;; al = 0x1000:bx
    cmp al, '}' ;; end of fileTable
    je _printFileTableLoop
    cmp al, '-' ;; diff bw program/file name and sector no
    je printSectorNumberLoop
    cmp al, ',' ;; next element in file Table
    je nextElement
    inc cx ;; increment counter if none of the above conditions
    int 0x10 ;; print any character that is not } , or -
    jmp printFileTableLoop

printSectorNumberLoop:
    cmp cx, 28 ;; white space according to heading string
    je printFileTableLoop
    mov al, ' ' ;; print space
    int 0x10
    inc cx ;; increment counter
    jmp printSectorNumberLoop

nextElement:
    xor cx, cx ;; reset counter
    ;; two new line
    times 2 call printNewLine

    jmp printFileTableLoop

_printFileTableLoop:
    times 2 call printNewLine
    mov ah, 0x00
    int 0x16
    jmp mainMenu