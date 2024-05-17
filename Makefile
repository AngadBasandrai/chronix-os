OS:
	make build
	make compile
	make run

build:
	make boot.iso
	make kernel.iso
	make fileTable.iso
	make program1.iso
	make editor.iso
	make padding.iso

compile:
	make OS.iso
	make clean

boot.iso:
	nasm src\boot.asm -f bin -o boot.iso
	move boot.iso bin\boot.iso

fileTable.iso:
	nasm src\file_table.asm -f bin -o fileTable.iso
	move fileTable.iso bin\fileTable.iso

kernel.iso:
	nasm src\kernel.asm -f bin -o kernel.iso
	move kernel.iso bin\kernel.iso

program1.iso:
	nasm src\program1.asm -f bin -o program1.iso
	move program1.iso bin\program1.iso

editor.iso:
	nasm src\editor.asm -f bin -o editor.iso
	move editor.iso bin\editor.iso

padding.iso:
	nasm src\padding.asm -f bin -o padding.iso
	move padding.iso bin\padding.iso

OS.iso:
	type bin\boot.iso bin\kernel.iso bin\fileTable.iso bin\program1.iso bin\editor.iso bin\padding.iso > OS.iso
	move OS.iso bin\OS.iso

clean:
	del bin\boot.iso
	del bin\fileTable.iso
	del bin\kernel.iso
	del bin\program1.iso
	del bin\editor.iso
	del bin\padding.iso

run:
	qemu-system-x86_64 -drive format=raw,file=bin\OS.iso