// kernel/kernel.c
void kernel_main(void) {
    // VGA text mode buffer at 0xB8000
    char* video_memory = (char*)0xB8000;
    
    // Clear screen (80x25 characters, 2 bytes each)
    for (int i = 0; i < 80 * 25 * 2; i++) {
        video_memory[i] = 0;
    }
    
    // Write "Chronix OS - Hello from C!"
    char* message = "Chronix OS V1.0";
    for (int i = 0; message[i] != 0; i++) {
        video_memory[i * 2] = message[i];     // Character
        video_memory[i * 2 + 1] = 0x0F;      // White on black
    }
    
    // Infinite loop with halt instruction
    while (1) {
        __asm__("hlt");
    }
}
