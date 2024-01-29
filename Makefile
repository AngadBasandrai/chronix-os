OS:
	make boot.bin
	make fileTable.bin
	make kernel.bin
	make program1.bin
	type bin\boot.bin bin\fileTable.bin bin\kernel.bin bin\program1.bin > OS.bin
	move OS.bin bin\OS.bin
	del bin\boot.bin
	del bin\fileTable.bin
	del bin\kernel.bin
	del bin\program1.bin
	qemu-system-x86_64 -drive format=raw,file=bin\OS.bin

boot.bin:
	nasm src\asm\boot.asm -f bin -o boot.bin
	move boot.bin bin\boot.bin

fileTable.bin:
	nasm src\asm\file_table.asm -f bin -o fileTable.bin
	move fileTable.bin bin\fileTable.bin

kernel.bin:
	nasm src\asm\kernel.asm -f bin -o kernel.bin
	move kernel.bin bin\kernel.bin

program1.bin:
	nasm src\programs\program1.asm -f bin -o program1.bin
	move program1.bin bin\program1.bin