.SUFFIXES: .bin .o .o64 .obj .obj64 .exe .asm .lst

NASM = ../nasm

.asm.bin:
	$(NASM) -f bin -o $@ -l $*.lst $<

.asm.o:
	$(NASM) -f elf32 -o $@ -l $*.lst $<

.asm.o64:
	$(NASM) -f elf64 -o $@ -l $*.lst $<

.asm.obj:
	$(NASM) -f win32 -o $@ -l $*.lst $<

.asm.obj64:
	$(NASM) -f win64 -o $@ -l $*.lst $<

all:

clean:
	rm -f *.com *.o *.o64 *.obj *.obj64 *.exe *.lst
