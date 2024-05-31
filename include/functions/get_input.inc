getInput:
    mov di, cmdString
    mov byte [cmdLength], 0
    call printNewCommandSymbol

getInputLoop:

    mov ah, 0x00
    int 0x16 ;; BIOS int: get keystroke if ah = 0x00, read character goes to al

    mov ah, 0x0e
    int 0x10 ;; print inputted char to screen
    cmp al, 0x0D
    je checkCommands

    cmp al, 0x08
    jne notBackspace
    dec di
    dec byte [cmdLength]
    jmp getInputLoop

notBackspace:
    inc byte [cmdLength]
    mov [di], al ;; effectively => mov cmdString[idx], al
    inc di
    jmp getInputLoop