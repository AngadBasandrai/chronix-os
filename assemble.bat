nasm boot.asm -f bin -o os.img
qemu-system-x86_64 -drive format=raw,file=os.img