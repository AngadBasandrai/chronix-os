; bootloader.asm
; 16 bit bootloader that jumps to 32 bit

; define bits mode
[BITS 16]
; origin is at mem 0x7c00
ORG 0x7c00

load_protected_mode:
    
    ; Reset all registers
    xor ax, ax
    mov ds, ax      
    mov es, ax       
    mov ss, ax      
    mov sp, 0x7C00  ; stack pointer = top of boot sector

    ; Reset disk system
    mov ah, 0x00
    mov dl, 0x00    ; floppy disk drive
    int 0x13


    mov ax, 0x0000
    mov es, ax
    mov bx, 0x1000 ; load at es:bx

    mov ah, 0x02 ; read sectors mode
    mov al, 4 ; no of sectors to read
    mov ch, 0 ; cylinder no.
    mov cl, 2 ; sector no. 
    mov dh, 0 ; head no.
    mov dl, 0x00 ; drive no. (0x00 for floppy, 0x80 for hard disk)

    int 0x13 ; load

    ; line A20 has to be enabled to acess all memory
    in al, 0x92
    or al, 2
    out 0x92, al
    
    cli
    lgdt [gdt_descriptor] ; load gdt
    mov eax, cr0
    or eax, 1 ; set protection enable bit in control register 0 (cr0) to 1
    mov cr0, eax

    jmp CODE_SEG:init_32_bit ; jmp to protected mode code (Far jump is req)

[BITS 32]

init_32_bit:
    ; set up stacks for 32 bit correctly
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov esp, 0xA0000

    ; jmp to where kernel is loaded
    jmp CODE_SEG:0x1000

[BITS 16]

gdt_start:
dq 0x0000000000000000
gdt_code:
dq 0x00CF9A000000FFFF
gdt_data:
dq 0x00CF92000000FFFF
gdt_end:

; this is the format of gdt descriptor required by lgdt
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start ; this is the convention
DATA_SEG equ gdt_data - gdt_start

; pad out 1 sector with 0's and end with aa55 to specify little/big endian
times 510 - ($ - $$) db 0
dw 0xaa55