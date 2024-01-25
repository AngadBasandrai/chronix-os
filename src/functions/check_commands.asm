checkCommands:
    mov byte [di], 0 ;; null terminate cmdString
    mov al, [cmdString]
    cmp al, 'F' ;; TODO: change to check command list
    jne commandError
    mov si, nl
    call printString
    mov si, success
    jmp _checkCommands

commandError:
    mov si, nl
    call printString
    mov si, failure
    
_checkCommands:
    call printString
    call getInput