OS:
	make boot.bin
	make kernel.bin
	type bin\boot.bin bin\kernel.bin > OS.bin
	move OS.bin bin\OS.bin
	qemu-system-x86_64 -drive format=raw,file=bin\OS.bin

boot.bin:
	nasm src\asm\boot.asm -f bin -o boot.bin
	move boot.bin bin\boot.bin

kernel.bin:
	nasm src\asm\kernel.asm -f bin -o kernel.bin
	move kernel.bin bin\kernel.bin