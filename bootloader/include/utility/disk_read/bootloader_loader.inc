; bootloader/include/utility/disk_read/bootloader_loader.inc
; loads 2nd stage bootloader into memory using int 0x13

load_bootloader:
    pusha
    
    ; Reset disk system first
    mov ah, 0x00
    mov dl, 0x00    ; floppy disk drive
    int 0x13
    
    ; Load stage 2
    mov ah, 0x02    ; read sectors mode
    mov al, 1       ; number of sectors to read
    mov ch, 0       ; cylinder no.
    mov cl, 2       ; sector no. (bootloader1 is sector 1, stage2 is sector 2)
    mov dh, 0       ; head no. 
    mov dl, 0x00    ; drive no. (0x00 for floppy, 0x80 for hard disk)
    
    ; Load to 0x1000:0x0000 (physical address 0x10000)
    mov bx, 0x8000
    mov es, bx
    xor bx, bx      ; es:bx = 0x1000:0x0000

    int 0x13        ; bios read function
    
    jc disk_error

    popa
    jmp 0x8000:0x0000   ; jump to loaded stage 2

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