// kernel.c
#include "interrupts.h"

void kernel_main()
{
    idt_init();

    char* video = (char*)0xB8000;
    for (int i = 0; i < 80*25*2; ++i)
    video[i] = 0;

    const char* msg = "Chronix OS V1.0";
    for (int i = 0; msg[i] != 0; ++i) {
        video[i*2]   = msg[i];
        video[i*2+1] = 0x0F;
    }    

    while (1) __asm__("hlt");
}