// kernel.c
// The main OS kernel

#include "interrupts.h"

/// @brief The core loop of the kernel
void kernel_main()
{
    idt_init();

    char* video = (char*)0xB8000; // 0xb8000 is start of video memory and 2 bytes are value to display and 2 bytes are color data for it
    for (int i = 0; i < 80*25*2; ++i)
    video[i] = 0;

    const char* msg = "Chronix OS V1.0";
    for (int i = 0; msg[i] != 0; ++i) {
        video[i*2]   = msg[i];
        video[i*2+1] = 0x0F; // 4 bytes decide msg[i] displayed with 0x0F bg color and text color 
    }

    //int x = 1/0;
    
    while (1) __asm__("hlt");
}