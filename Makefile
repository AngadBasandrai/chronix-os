# Tools
AS = nasm
CC = gcc
LD = ld

# Directories
BUILD_DIR = build
BOOTLOADER_DIR = bootloader
KERNEL_DIR = kernel

# Output file
OS_IMAGE = chronix_v1.0.img

# Flags
ASFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -fno-builtin -nostdlib -Wall -Wextra -O2 -fno-pic -fno-pie
LDFLAGS = -m elf_i386 -T $(KERNEL_DIR)/linker.ld

# Kernel sources
KERNEL_C_SRC = $(KERNEL_DIR)/kernel.c $(KERNEL_DIR)/idt.c
KERNEL_ASM_SRC = $(KERNEL_DIR)/kernel_entry.asm $(KERNEL_DIR)/idt_flush.asm $(KERNEL_DIR)/isr_stub.asm
KERNEL_OBJS = $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/idt_flush.o $(BUILD_DIR)/isr_stub.o

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Default target
all: clean compile run

# Main build target
compile: $(BUILD_DIR) $(OS_IMAGE)

# Build kernel objects
$(BUILD_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/idt.o: $(KERNEL_DIR)/idt.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel_entry.o: $(KERNEL_DIR)/kernel_entry.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/idt_flush.o: $(KERNEL_DIR)/idt_flush.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/isr_stub.o: $(KERNEL_DIR)/isr_stub.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Build kernel binary
$(BUILD_DIR)/kernel.bin: $(KERNEL_OBJS)
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/kernel.elf $^
	objcopy -O binary $(BUILD_DIR)/kernel.elf $(BUILD_DIR)/kernel.bin

# Build bootloader
$(BUILD_DIR)/bootloader_1.bin: $(BOOTLOADER_DIR)/bootloader_1.asm | $(BUILD_DIR)
	$(AS) -f bin $< -o $@

$(BUILD_DIR)/bootloader_2.bin: $(BOOTLOADER_DIR)/bootloader_2.asm | $(BUILD_DIR)
	$(AS) -f bin $< -o $@

# Create final bootable image
$(OS_IMAGE): $(BUILD_DIR)/bootloader_1.bin $(BUILD_DIR)/bootloader_2.bin $(BUILD_DIR)/kernel.bin
	dd if=/dev/zero of=$(BUILD_DIR)/$(OS_IMAGE) bs=1M count=2
	dd if=$(BUILD_DIR)/bootloader_1.bin of=$(BUILD_DIR)/$(OS_IMAGE) conv=notrunc
	dd if=$(BUILD_DIR)/bootloader_2.bin of=$(BUILD_DIR)/$(OS_IMAGE) conv=notrunc bs=512 seek=1
	dd if=$(BUILD_DIR)/kernel.bin of=$(BUILD_DIR)/$(OS_IMAGE) conv=notrunc bs=512 seek=2
	cp $(BUILD_DIR)/$(OS_IMAGE) ./$(OS_IMAGE)
	rm -f $(BUILD_DIR)/*.bin
	rm -f $(BUILD_DIR)/*.o
	rm -f $(BUILD_DIR)/*.elf
	rm -f $(BUILD_DIR)/../*.img
	@echo "Build complete! Final image: build/$(OS_IMAGE)"

# Run in QEMU
run: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=build/$(OS_IMAGE),if=floppy -no-reboot -no-shutdown

# Debug in QEMU
debug: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=build/$(OS_IMAGE),if=floppy -no-reboot -no-shutdown -s -S

# Clean everything except final image
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(OS_IMAGE)
	@echo "Cleaned build directory and OS image"

# Help
help:
	@echo "Available targets:"
	@echo "  all     - Clean, build, and run (default workflow)"
	@echo "  compile    - Build the OS image only"
	@echo "  run     - Run the OS in QEMU"
	@echo "  debug   - Run the OS in QEMU with debugging enabled"
	@echo "  clean   - Clean all build files"
	@echo "  help    - Show this help message"

.PHONY: all compile run debug clean help
