getFileName:
    call printNewLine
    mov di, cmdString
    mov byte [cmdLength], 0

inputFileNameLoop:
    mov ah, 0x00
    int 0x16
    mov ah, 0x0e

    cmp al, 0x1B ; 0x1B is escape key
    je mainMenu

    int 0x10

    cmp al, 0xD
    je startFileSearch

    inc byte [cmdLength]
    mov [di], al
    inc di
    jmp inputFileNameLoop

startFileSearch:
    mov di, cmdString ; di points to start of cmdString
    xor bx, bx ; reset bx so that es:bx points to start of file table

charCheckLoop:
    mov al, [ES:BX] ; al has file table character
    cmp al, '}'
    je fileNotFound

    cmp al, [di]
    je startComparison

    inc bx ; next char of file table
    jmp charCheckLoop

startComparison:
    push bx ; save file table position
    mov byte cl, [cmdLength]

comparisonLoop:
    mov al, [ES:BX]
    inc bx

    cmp al, [di]
    jne restartFileSearch

    dec cl
    jz fileFound

    inc di
    jmp comparisonLoop

restartFileSearch:
    mov di, cmdString
    pop bx
    inc bx
    jmp charCheckLoop

fileNotFound:
    mov si, fileNotFoundMsg
    call printString
    jmp endFileTable

fileFound:
    inc bx ; pointer was at '-' now move it to sector no.
    mov cl, 10 ; we need to multiply by 10
    xor al, al ; reset al

sectorNumberLoop:
    mov dl, [ES:BX]
    inc bx
    cmp dl, ',' ; end of sector no.
    je openFile
    cmp dl, 0x30 ; ascii of numbers is 48-57 (0x30 - 0x39)
    jl invalidSector
    cmp dl, 0x39
    jg invalidSector
    sub dl, 0x30 ; if it is a number convert from ascii to actual no.
    mul cl ; multiply al by cl, here multiplying by 10 to send to next tenths place
    add al, dl ; add in ones places
    jmp sectorNumberLoop

invalidSector:
    mov si, invalidSectorMsg
    call printString
    jmp endFileTable

openFile:
    mov cl, al ; al had sector no.
    push cx

    mov ah, 0x00 
    mov dl, 0x00
    int 0x13 ;; reset disk system i.e. sends disk system to track 0

    mov ah, 0x02
    mov al, 0x01
    pop cx
    mov ch, 0x00
    mov dh, 0x00

    mov bx, 0x8000 ;; location to load file
    mov es, bx
    xor bx, bx

    ;; reads sectors
    int 0x13   
    jnc fileLoaded ; jmp if carry flag not set

    mov si, unableToLoadMsg
    call printString
    jmp endFileTable

fileLoaded:
    mov ax, 0x8000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x8000:0x0000

endFileTable:
    mov ah, 0x00
    int 0x16
    cmp al, 0x1B
    jne printFileTable
    jmp mainMenu