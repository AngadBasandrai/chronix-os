#include "idt.h"
#include <string.h>
#include <stddef.h>

extern void isr_stub_table();
extern void isr_stub_table_end();
extern void irq_stub_table();
extern void irq_stub_table_end();
extern void idt_flush(idt_ptr_t*);

static idt_entry_t idt[256];
static idt_ptr_t   idtp;

static void idt_set_gate(int n, uint32_t handler, uint16_t sel, uint8_t flags)
{
    idt[n].offset_low  = handler & 0xFFFF;
    idt[n].selector    = sel;
    idt[n].zero        = 0;
    idt[n].type_attr   = flags;
    idt[n].offset_high = handler >> 16;
}

static inline void outb(uint16_t port, uint8_t value)
{
    __asm__ volatile ("outb %0, %1" :: "a"(value), "Nd"(port));
}

static void pic_remap(void)
{
    outb(0x20, 0x11); outb(0xA0, 0x11);
    outb(0x21, 0x20); outb(0xA1, 0x28);
    outb(0x21, 0x04); outb(0xA1, 0x02);   
    outb(0x21, 0x01); outb(0xA1, 0x01);   
    outb(0x21, 0x0 ); outb(0xA1, 0x0 );   
}

void idt_install(void)
{
    memset(idt, 0, sizeof(idt));

    extern void isr0();
    for (int i = 0; i < 32; i++)
    {
        idt_set_gate(i, (uint32_t)((uintptr_t)isr0 + i*16), 0x08, 0x8E);
    }

    extern void irq0();
    for (int i = 0; i < 32; i++)
    {
        idt_set_gate(32+i, (uint32_t)((uintptr_t)irq0 + i*16), 0x08, 0x8E);
    }

    idtp.limit = sizeof(idt) - 1;
    idtp.base = (uint32_t)&idt;

    pic_remap();
    idt_flush(&idtp);
}
