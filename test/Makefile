.SUFFIXES: .bin .o .o64 .obj .obj64 .exe .asm .lst

NASM = ../nasm

%.bin: %.asm $(NASM)
	$(NASM) -f bin -o $@ -l $*.lst $<

%.o: %.asm $(NASM)
	$(NASM) -f elf32 -o $@ -l $*.lst $<

%.o64: %.asm $(NASM)
	$(NASM) -f elf64 -o $@ -l $*.lst $<

%.obj: %.asm $(NASM)
	$(NASM) -f win32 -o $@ -l $*.lst $<

%.obj64: %.asm $(NASM)
	$(NASM) -f win64 -o $@ -l $*.lst $<

all:

clean:
	rm -f *.com *.o *.o64 *.obj *.obj64 *.exe *.lst *.bin
