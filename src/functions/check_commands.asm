checkCommands:
    mov byte [di], 0

dirCmd:
    xor cx, cx
    mov di, cmdString
    mov si, cmdDir
    dec di
    dec si
dirCmdLoop:
    cmp cx, 3
    je fileTable
    inc cx
    inc di
    inc si
    mov al, [di]
    cmp al, [si]
    je dirCmdLoop

gfxCmd:
    xor cx, cx
    mov di, cmdString
    mov si, cmdGfx
    dec di
    dec si
gfxCmdLoop:
    cmp cx, 3
    je gfxModeTest
    inc cx
    inc di
    inc si
    mov al, [di]
    cmp al, [si]
    je gfxCmdLoop

rbtCmd:
    xor cx, cx
    mov di, cmdString
    mov si, cmdRbt
    dec di
    dec si
rbtCmdLoop:
    cmp cx, 3
    je 0x7c00
    inc cx
    inc di
    inc si
    mov al, [di]
    cmp al, [si]
    je rbtCmdLoop

prntregCmd:
    xor cx, cx
    mov di, cmdString
    mov si, cmdPrntreg
    dec di
    dec si
prntregCmdLoop:
    cmp cx, 7
    je registers
    inc cx
    inc di
    inc si
    mov al, [di]
    cmp al, [si]
    je prntregCmdLoop
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
    call printNewLine

_checkCommands:
    call getInput