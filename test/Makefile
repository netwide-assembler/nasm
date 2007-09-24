.SUFFIXES: .bin .o .o64 .obj .obj64 .exe .asm .lst

NASM = ../nasm
NASMOPT = -O999 -I../misc

%.bin: %.asm $(NASM)
	$(NASM) $(NASMOPT) -f bin -o $@ -l $*.lst $<

%.o: %.asm $(NASM)
	$(NASM) $(NASMOPT) -f elf32 -o $@ -l $*.lst $<

%.o64: %.asm $(NASM)
	$(NASM) $(NASMOPT) -f elf64 -o $@ -l $*.lst $<

%.obj: %.asm $(NASM)
	$(NASM) $(NASMOPT) -f win32 -o $@ -l $*.lst $<

%.obj64: %.asm $(NASM)
	$(NASM) $(NASMOPT) -f win64 -o $@ -l $*.lst $<

all:

clean:
	rm -f *.com *.o *.o64 *.obj *.obj64 *.exe *.lst *.bin
