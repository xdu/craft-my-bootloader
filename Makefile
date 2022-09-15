loader: loader.asm Makefile
	nasm loader.asm -f bin -o loader.bin

floppy: loader.bin Makefile
	dd bs=512 count=2880 if=/dev/zero of=floppy.img
	dd conv=notrunc if=loader.bin bs=512 of=floppy.img

fs : 
	mcopy -i floppy.img haribote.bin ::

build:
	make -r loader floppy

run:
	qemu-system-i386 -drive format=raw,if=floppy,media=disk,file=floppy.img

# dd bs=512 count=2880 if=/dev/zero of=floppy.img