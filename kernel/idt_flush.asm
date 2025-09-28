; kernel/idt_flush.asm
[BITS 32]
global idt_flush

idt_flush:
    mov eax, [esp+4]   ; pointer to idt_ptr_t passed by C
    lidt [eax]         ; load IDTR
    ret