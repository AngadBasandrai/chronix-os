; bootloader/bootloader_2.asm
; loads kernel into memory, enters 32 bit mode and jumps to kernel

BITS 16
ORG 0x0000

stage_2_start:

    ; Set up segments at new location
    mov ax, 0x8000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1000

    ; Print message
    push es
    mov ax, 0xb800
    mov es, ax
    mov di, 160
    mov si, stage_2_msg
    call print_string
    pop es

    call load_kernel

    ; Copy to 0x10000
    push ds
    mov ax, 0x0000
    mov ds, ax
    mov si, 0x1000

    mov ax, 0x1000
    mov es, ax
    mov di, 0x0000

    mov cx, 2048
    rep movsb
    pop ds

    ; Enable A20
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Switch to protected mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    db 0x66
    db 0xEA
    dd 0x80000 + init_32bit - stage_2_start
    dw CODE_SEG

[BITS 32]
    init_32bit:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    ;; push ret works as push -> adrress to go go to, ret -> jmp to address
    push 0x10000
    ret

    
[bits 16]
stage_2_msg db "Switching to protected mode...", 0

gdt_start:
dq 0x0000000000000000
dq 0x00CF9A000000FFFF
dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
dw gdt_end - gdt_start - 1
dd gdt_start + 0x80000

CODE_SEG equ 0x08
DATA_SEG equ 0x10

%include "bootloader/include/display/print/print_string.inc"
%include "bootloader/include/utility/disk_read/kernel_loader.inc"

times 512 - ($ - $$) db 0
