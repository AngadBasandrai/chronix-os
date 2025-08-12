; bootloader/bootloader_1.asm
; boots the system and jumps to stage 2 bootloader

BITS 16
ORG 0x7c00

stage_1_start:    
    ; Set up segments properly
    xor ax, ax
    mov ds, ax      
    mov es, ax       
    mov ss, ax      
    mov sp, 0x7C00  ; stack pointer = top of boot sector
    
    ; Set up video memory for print_string
    mov ax, 0xb800
    mov es, ax      ; move start of video memory into es
    xor di, di      ; set offset to be zero
    
    mov si, welcome_msg    
    call print_string

    call load_bootloader
        
welcome_msg db "Starting Chronix OS...", 0

%include "bootloader/include/display/print/print_string.inc"
%include "bootloader/include/utility/disk_read/bootloader_loader.inc"

times 510 - ($ - $$) db 0
dw 0xaa55