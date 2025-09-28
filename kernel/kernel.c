#include "idt.h"

void kernel_main(void)
{
    idt_install();
    
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
