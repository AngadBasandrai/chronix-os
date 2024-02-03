checkCommands:
    mov byte [di], 0 ;; null terminate cmdString
    xor si, si
    mov bx, [cmdString]
    mov al, [bx]
    xor cx, cx
    cmp al, 0
    je newLine
    mov di, cmdList
    dec di
commandLoop:
    xor cx, cx
    mov al, [bx]
    cmp al, [di]
    je startCompare
    jne nextElem
    jmp commandError

startCompare:
    inc di
    inc cx
    inc bx
    mov al, [cmdString]
    cmp al, [di]
    je startCompare
    cmp di, ','
    je cmdFound
    jmp nextElem

nextElem:
    inc di
    cmp di, ','
    je restartCommandLoop
    jmp nextElem

restartCommandLoop:
    inc di
    inc si
    jmp commandLoop

cmdFound:
    cmp si, 0
    je cmdFound
    jmp _checkCommands

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