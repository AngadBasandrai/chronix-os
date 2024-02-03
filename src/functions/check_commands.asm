checkCommands:
    mov byte [di], 0 ;; null terminate cmdString
    mov al, [cmdString]
    cmp al, 0
    je newLine
    cmp al, 'F' ;; TODO: change to check command list
    je fileTable
    cmp al, 'R'
    je 0x7c00 ;; jump to bootloader
    cmp al, 'P'
    je registers
    cmp al, 'G'
    je gfxModeTest
    jmp commandError

fileTable:
    call printNewLine
    call printFileTable
    jmp _checkCommands

registers:
    call printNewLine
    call printRegisters
    jmp _checkCommands

gfxModeTest:
    call clearGfxScreen
    call gfxTest
    jmp _checkCommands

commandError:
    call printNewLine
    mov si, failure
    call printString
    jmp _checkCommands

newLine:
    times 2 call printNewLine

_checkCommands:
    call getInput