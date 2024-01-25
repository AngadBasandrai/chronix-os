checkCommands:
    mov byte [di], 0 ;; null terminate cmdString
    mov al, [cmdString]
    cmp al, 'F' ;; TODO: change to check command list
    je fileTable
    jmp commandError

fileTable:
    mov si, nl
    call printString
    call printFileTable
    jmp _checkCommands

commandError:
    mov si, nl
    call printString
    mov si, failure
    call printString
    
_checkCommands:
    call getInput