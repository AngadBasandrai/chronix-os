;; fs: location
;; bx: offset
;; si: fileType

startFileSearch:
    mov di, cmdString ; di points to start of cmdString
    mov ax, 0x1000
    mov es, ax
    xor bx, bx ; reset bx so that es:bx points to start of file table

charCheckLoop:
    mov al, [ES:BX] ; al has file table character
    cmp al, '\'
    je commandError

    cmp al, [di]
    je startComparison

    add bx, 17 ; next entry of file table
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
    add bx, 17
    jmp charCheckLoop

fileFound:
    pop bx
    add bx, 10

fileExtension:
    mov di, fileExtensionString
    mov al, [ES:BX]
    mov [di], al
    inc di
    inc bx
    mov al, [ES:BX]
    mov [di], al
    inc di
    inc bx
    mov al, [ES:BX]
    mov [di], al
    inc di
    inc bx
    mov byte [di], 0

fileExtensionCheck:
    mov al, [fileExtensionString]
    cmp al, 't'
    je textLoop
    jmp sectorCheck

textLoop:
    mov al, [fileExtensionString+1]
    cmp al, 'x'
    jne sectorCheck
    mov al, [fileExtensionString+2]
    cmp al, 't'
    jne sectorCheck
    mov si, 0
    push si

sectorCheck:
    mov cl, 10 ; we need to multiply by 10
    xor al, al ; reset al

sectorNumberLoop:
    mov dl, [ES:BX]
    call hexToCharD
    inc bx
    cmp dl, 0x30 
    jl invalidSector
    cmp dl, 0x39
    jg invalidSector
    sub dl, 0x30
    mul cl
    add al, dl

    mov dl, [ES:BX]
    call hexToCharD
    inc bx
    cmp dl, 0x30
    jl invalidSector
    cmp dl, 0x39
    jg invalidSector
    sub dl, 0x30
    mul cl
    add al, dl

    mov cl, al
    push cx
    xor al, al
    mov cl, 10

    mov dl, [ES:BX]
    call hexToCharD
    inc bx
    cmp dl, 0x30 
    jl invalidSector
    cmp dl, 0x39
    jg invalidSector
    sub dl, 0x30
    mul cl
    add al, dl

    mov dl, [ES:BX]
    call hexToCharD
    inc bx
    cmp dl, 0x30
    jl invalidSector
    cmp dl, 0x39
    jg invalidSector
    sub dl, 0x30
    mul cl
    add al, dl

    jmp openFile

invalidSector:
    mov si, invalidSectorMsg
    call printString
    jmp endFileTable

openFile:
    mov ah, 0x00 
    mov dl, 0x00
    int 0x13 ;; reset disk system i.e. sends disk system to track 0

    pop cx
    mov ah, 0x02
    mov ch, 0x00
    mov dh, 0x00
    mov dl, 0x80

    mov bx, fs
    mov es, bx
    pop bx

    ;; reads sectors
    int 0x13
    jnc fileLoaded ; jmp if carry flag not set

    mov si, unableToLoadMsg
    call printString
    jmp endFileTable

fileLoaded:

    pop si
    cmp si, 0
    je txtFileFound

    mov ax, es
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x8000:0x0000 ;; find a way to use es:bx

endFileTable:
    jmp getInput