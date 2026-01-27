; kernel_entry.asm
[BITS 32]
; externally define kernel_main
[extern kernel_main]

; define _start globally so that linker can find it
global _start
_start:
    ; go to main kernel
    call kernel_main
    jmp $