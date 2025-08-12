; kernel/kernel_entry.asm
[BITS 32]
[extern kernel_main]     ; External C function

global _start            ; Entry point symbol
_start:
    call kernel_main     ; Call C kernel
    jmp $                ; Halt if kernel returns
