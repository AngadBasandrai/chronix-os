mainMenu:
    call clearTextScreen

    mov si, welcome
    call printString
    
    call getInput

    ;;; Includes
    %include "include/gfx/gfx_test.inc"

    %include "include/functions/check_commands.inc"
    %include "include/functions/check_file.inc"
    %include "include/functions/get_input.inc"
    %include "include/functions/print_file_table.inc"
    %include "include/functions/print_hex.inc"
    %include "include/functions/print_string.inc"
    %include "include/functions/read_text_file.inc"

    %include "include/screen/clear_text_screen.inc"
    %include "include/screen/clear_gfx_screen.inc"

    %include "include/utility/print_registers.inc"
    %include "include/utility/macros.inc"
    %include "include/utility/vars.inc"
    
times 2048-($-$$) db 0
