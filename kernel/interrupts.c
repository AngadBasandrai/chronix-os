// interrupts.c
#include "interrupts.h"

static idt_entry_t idt[256];
static idtr_t idtr;

extern void* isr_stub_table[];

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
    idt_entry_t* descriptor = &idt[vector];

    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08; // this value can be whatever offset your kernel code selector is in your GDT
    descriptor->attributes     = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}

void exception_handler(interrupt_frame_t* frame){
    switch (frame->vector)
    {    
        default:
            default_handler(frame);
    }
}

void default_handler(interrupt_frame_t* frame){
    char* video = (char*)0xB8000;
    for (int i = 0; i < 80*25*2; ++i)
    video[i] = 0;

    uint32_t v = frame->vector;
    const char* msg = "Interrupt";
    int j = 0; 
    for (int i = 0; msg[i] != 0; ++i) {
        video[i*2]   = msg[i];
        video[i*2+1] = 0x0F;
        j = i+2;
    }   
    video[j*2]   = (int)v+65;
    video[j*2+1] = 0x0F;

    while (1) __asm__("hlt");
}


void idt_init() {
    idtr.base = (uintptr_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * 256 - 1;

    for (uint8_t vector = 0; vector < 32; vector++) {
        idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    }
    // idt_set_descriptor(13, isr_stub_table[13], 0x8E);
    // idt_set_descriptor(8, isr_stub_table[8], 0x8E);


    __asm__ volatile ("lidt %0" : : "m"(idtr)); // load the new IDT
    __asm__ volatile ("sti"); // set the interrupt flag
}
