checkCommands:
    mov byte [di], 0 ;; null terminate cmdString
    mov al, [cmdString]
    cmp al, 'F' ;; TODO: change to check command list
    je fileTable
    cmp al, 'R'
    je 0x7c00 ;; jump to bootloader
    cmp al, 'P'
    je registers
    jmp commandError

fileTable:
    call printNewLine
    call printFileTable
    jmp _checkCommands

registers:
    call printNewLine
    call printRegisters
    jmp _checkCommands


commandError:
    call printNewLine
    mov si, failure
    call printString
    
_checkCommands:
    call getInput