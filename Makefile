build: 
	nasm -f bin bootloader/bootloader.asm -o build/boot.bin
	nasm -f elf32 kernel/kernel_entry.asm -o build/kernel_entry.o
	nasm -f elf32 kernel/isr_stubs.asm -o build/isr_stubs.o

	gcc -m32 -ffreestanding -fno-builtin -nostdlib -Wall -Wextra -O2 -fno-pic -fno-pie -O0 -fno-omit-frame-pointer -mno-sse -mno-mmx -c kernel/kernel.c -o build/kernel.o
	gcc -m32 -ffreestanding -fno-builtin -nostdlib -Wall -Wextra -O2 -fno-pic -fno-pie -O0 -fno-omit-frame-pointer -mno-sse -mno-mmx -c kernel/interrupts.c -o build/interrupts.o
	
	ld -m elf_i386 -T kernel/linker.ld build/kernel_entry.o build/kernel.o build/isr_stubs.o build/interrupts.o --oformat binary -o build/kernel.bin
	
	cat build/boot.bin build/kernel.bin > build/os.img

run:
	qemu-system-i386 -drive format=raw,file=build/os.img,if=floppy -no-reboot -no-shutdown

clean:
	rm -rf build/*.bin
	rm -rf build/*.o

all:
	make build 
	make clean
	make run

.PHONY: all build run clean