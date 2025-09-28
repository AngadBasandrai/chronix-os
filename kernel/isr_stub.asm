[BITS 32]

section .data
isr_msg: db 'INTERRUPT!', 0

section .text

; === Macros for exception stubs ===
%macro ISR_NOERR 1
    global isr%1
isr%1:
    cli
    push dword %1
    jmp isr_common
%endmacro

%macro ISR_ERR 1
    global isr%1
isr%1:
    cli
    push dword %1
    jmp isr_common
%endmacro

; === CPU exceptions (vectors 0-31) ===
ISR_NOERR 0   ; Divide-by-zero
ISR_NOERR 1   ; Debug
ISR_NOERR 2   ; NMI
ISR_NOERR 3   ; Breakpoint
ISR_NOERR 4   ; Overflow
ISR_NOERR 5   ; Bound Range Exceeded
ISR_NOERR 6   ; Invalid Opcode
ISR_NOERR 7   ; Device Not Available
ISR_ERR  8    ; Double Fault (error code)
ISR_NOERR 9   ; Coprocessor Segment Overrun
ISR_ERR  10   ; Invalid TSS (error code)
ISR_ERR  11   ; Segment Not Present (error code)
ISR_ERR  12   ; Stack-Segment Fault (error code)
ISR_ERR  13   ; General Protection Fault (error code)
ISR_ERR  14   ; Page Fault (error code)
ISR_NOERR 15  ; Reserved
ISR_NOERR 16  ; x87 Floating-Point Exception
ISR_ERR  17   ; Alignment Check (error code)
ISR_NOERR 18  ; Machine Check
ISR_NOERR 19  ; SIMD Floating-Point Exception
ISR_NOERR 20  ; Virtualization Exception
ISR_NOERR 21  ; Control Protection Exception
ISR_NOERR 22  ; Reserved
ISR_NOERR 23  ; Reserved
ISR_NOERR 24  ; Reserved
ISR_NOERR 25  ; Reserved
ISR_NOERR 26  ; Reserved
ISR_NOERR 27  ; Reserved
ISR_NOERR 28  ; Reserved
ISR_NOERR 29  ; Reserved
ISR_NOERR 30  ; Reserved
ISR_NOERR 31  ; Reserved

; === Hardware IRQ stubs (vectors 32-47) ===
global irq0, irq1, irq2, irq3, irq4, irq5, irq6, irq7
global irq8, irq9, irq10, irq11, irq12, irq13, irq14, irq15

irq0:
    cli
    push dword 32
    jmp isr_common
irq1:
    cli
    push dword 33
    jmp isr_common
irq2:
    cli
    push dword 34
    jmp isr_common
irq3:
    cli
    push dword 35
    jmp isr_common
irq4:
    cli
    push dword 36
    jmp isr_common
irq5:
    cli
    push dword 37
    jmp isr_common
irq6:
    cli
    push dword 38
    jmp isr_common
irq7:
    cli
    push dword 39
    jmp isr_common
irq8:
    cli
    push dword 40
    jmp isr_common
irq9:
    cli
    push dword 41
    jmp isr_common
irq10:
    cli
    push dword 42
    jmp isr_common
irq11:
    cli
    push dword 43
    jmp isr_common
irq12:
    cli
    push dword 44
    jmp isr_common
irq13:
    cli
    push dword 45
    jmp isr_common
irq14:
    cli
    push dword 46
    jmp isr_common
irq15:
    cli
    push dword 47
    jmp isr_common

; === Common handler for all stubs ===
global isr_common
isr_common:
    pusha               ; Save general registers
    push ds
    push es
    push fs
    push gs

    mov ax, 0x10        ; Kernel data segment selector
    mov ds, ax
    mov es, ax

    call print_isr_msg  ; Print 'INTERRUPT!' to screen

    ; Acknowledge PIC (EOI)
    mov al, 0x20
    out 0x20, al
    out 0xA0, al

    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 4          ; Remove pushed vector number
    sti
    iret

; === Print routine: writes 'INTERRUPT!' at top-left of screen ===
print_isr_msg:
    mov esi, isr_msg    ; ESI = pointer to string
    mov edi, 0xB8000    ; EDI = start of video memory
.print_loop:
    lodsb               ; AL = [ESI], ESI++
    test al, al         ; End of string?
    jz .done
    mov ah, 0x0F        ; Attribute: white on black
    mov [edi], ax       ; Write char+attr to video memory
    add edi, 2          ; Next character cell
    jmp .print_loop
.done:
    ret
