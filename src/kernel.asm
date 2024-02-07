mainMenu:
    call clearTextScreen

    mov si, welcome
    call printString
    
    call getInput

end:
    cli ;; clear interrupts
    hlt ;; halt

    ;;; Includes
    %include "include/gfx/gfx_test.asm"

    %include "include/functions/check_commands.asm"
    %include "include/functions/check_file.asm"
    %include "include/functions/get_input.asm"
    %include "include/functions/print_file_table.asm"
    %include "include/functions/print_hex.asm"
    %include "include/functions/print_string.asm"
    %include "include/functions/read_text_file.asm"

    %include "include/screen/clear_text_screen.asm"
    %include "include/screen/clear_gfx_screen.asm"

    %include "include/utility/print_registers.asm"
    %include "include/utility/macros.asm"
    %include "include/utility/vars.asm"
    
times 2048-($-$$) db 0
