// interrupts.c
// Core definition of the IDT

#include "interrupts.h"

static idt_entry_t idt[256];
static idtr_t idtr;

extern void* isr_stub_table[];

/// @brief C inline definition for the outb command in asm
static inline void outb(uint16_t port, uint8_t value)
{
    __asm__ volatile ("outb %0, %1" :: "a"(value), "Nd"(port));
}


/// @brief Basic standard definition of an IDT entry 
void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
    idt_entry_t* descriptor = &idt[vector];

    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08; // this should be the kernel code selector offset in GDT
    descriptor->attributes     = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}

/// @brief Global Exception Handler, called when an interrupt occurs
/// @param frame Basic frame the includes vector and error_code for debugging interrupts
void exception_handler(interrupt_frame_t* frame){
    // use this to deal with interrupts
    switch (frame->vector)
    {    
        default:
            default_handler(frame);
    }
}

/// @brief Default handler for exceptions called from exception_handler(); 
void default_handler(interrupt_frame_t* frame){
    char* video = (char*)0xB8000;
    for (int i = 0; i < 80*25*2; ++i)
    video[i] = 0;

    uint32_t v = frame->vector; // our passed data from isr_stubs has a vector component which holds interrupt code
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

/// @brief PIC must be remapped as its first 8 IRQ's conflict with the CPU exceptions and its difficult to differentiate IRQ and software error so PIC's offsets are moved  
static void pic_remap(void)
{
    outb(0x20, 0x11); outb(0xA0, 0x11);
    outb(0x21, 0x20); outb(0xA1, 0x28);
    outb(0x21, 0x04); outb(0xA1, 0x02);   
    outb(0x21, 0x01); outb(0xA1, 0x01);   
    outb(0x21, 0x0 ); outb(0xA1, 0x0 );   
}

/// @brief The IDT initialiser, builds an IDT and applies it to use
void idt_init() {
    idtr.base = (uintptr_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * 256 - 1; // define useful macros for idtr

    for (uint8_t vector = 0; vector < 32; vector++) {
        idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    }

    pic_remap();
    __asm__ volatile ("lidt %0" : : "m"(idtr)); // load the IDT at idtr
    __asm__ volatile ("sti"); // reallow interrupts
}
