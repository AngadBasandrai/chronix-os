; bootloader/utility/disk_read/kernel_loader
; loads kernel into memory using int 0x13

[bits 16]
load_kernel:
    ; Load kernel from disk
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x1000      

    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 3
    mov dh, 0
    mov dl, 0x00

    int 0x13
    jc disk_error

    ret

disk_error:
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    mov al, 'r'
    int 0x10
    mov al, 'r'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, 'r'
    int 0x10
    hlt
    jmp $