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

fileNameLoop:
    mov al, [ES:BX]
    cmp al, 0 ;; end of fileTable
    je fileNameEnd
    cmp cx, 10
    je fileExtensionPadding
    int 0x10
    inc cx
    inc bx
    jmp fileNameLoop

fileNameEnd:
    call printSpace
    inc bx
    inc cx
    jmp fileNameLoop

fileExtensionPadding:
    times 9 call printSpace
    jmp fileExtensionLoop

fileExtensionLoop:
    mov al, [ES:BX]
    cmp cx, 13
    je startSectorPadding
    int 0x10
    inc cx
    inc bx
    jmp fileExtensionLoop

startSectorPadding:
    times 9 call printSpace
    jmp startSectorLoop

startSectorLoop:
    mov al, [ES:BX]
    cmp cx, 15
    je fileSize
    call hexToChar
    int 0x10
    inc cx
    inc bx
    jmp startSectorLoop

fileSize:
    times 7 call printSpace
    mov al, [ES:BX]
    call hexToChar
    int 0x10
    inc bx
    mov al, [ES:BX]
    call hexToChar
    int 0x10
    jmp nextElement

nextElement:
    xor cx, cx
    inc bx
    mov al, [ES:BX]
    cmp al, '}'
    je _printFileTableLoop
    times 2 call printNewLine
    jmp fileNameLoop

_printFileTableLoop:
    call printNewLine
    jmp getFileName