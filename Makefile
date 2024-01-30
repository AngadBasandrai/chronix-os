OS:
	make boot.iso
	make kernel.iso
	make fileTable.iso
	make program1.iso
	type bin\boot.iso bin\kernel.iso bin\fileTable.iso bin\program1.iso > OS.iso
	move OS.iso bin\OS.iso
	del bin\boot.iso
	del bin\fileTable.iso
	del bin\kernel.iso
	del bin\program1.iso
	qemu-system-x86_64 -drive format=raw,file=bin\OS.iso

boot.iso:
	nasm src\asm\boot.asm -f bin -o boot.iso
	move boot.iso bin\boot.iso

fileTable.iso:
	nasm src\asm\file_table.asm -f bin -o fileTable.iso
	move fileTable.iso bin\fileTable.iso

kernel.iso:
	nasm src\asm\kernel.asm -f bin -o kernel.iso
	move kernel.iso bin\kernel.iso

program1.iso:
	nasm src\programs\program1.asm -f bin -o program1.iso
	move program1.iso bin\program1.iso