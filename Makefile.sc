# Makefile for the Netwide Assembler under 32-bit Windows(tm)

#

# The Netwide Assembler is copyright (C) 1996 Simon Tatham and

# Julian Hall. All rights reserved. The software is

# redistributable under the licence given in the file "Licence"

# distributed in the NASM archive.

#

# This Makefile is designed to build NASM using the 32-bit WIN32 C

# compiler Symantec(tm) C++ 7.5, provided you have a MAKE-utility

# that's compatible to SMAKE.



CC = sc

CCFLAGS = -c -a1 -mn -Nc -w2 -w7 -o+time -5

# -5            optimize for pentium (tm)

# -c            compile only

# -o-all        no optimizations (to avoid problems in disasm.c)

# -o+time       optimize for speed

# -o+space      optimize for size

# -A1           byte alignment for structures

# -mn           compile for Win32 executable

# -Nc           create COMDAT records

# -w2           possible unattended assignment: off

# -w7           for loops with empty instruction-body



LINK = link

LINKFLAGS = /noi /exet:NT /su:console

# /noignorecase all symbols are case-sensitive

# /exet:NT      Exetype: NT (Win32)

# /su:console   Subsystem: Console (Console-App)



LIBRARIES =

EXE = .exe

OBJ = obj



.c.$(OBJ):

        $(CC) $(CCFLAGS) $*.c





#

# modules needed for different programs

#



NASMOBJS = nasm.$(OBJ) nasmlib.$(OBJ) float.$(OBJ) insnsa.$(OBJ) \

           assemble.$(OBJ) labels.$(OBJ) parser.$(OBJ) outform.$(OBJ) \

	   outbin.$(OBJ) outaout.$(OBJ) outcoff.$(OBJ) outelf.$(OBJ) \

	   outobj.$(OBJ) outas86.$(OBJ) outrdf.$(OBJ) outdbg.$(OBJ) \

	   preproc.$(OBJ) listing.$(OBJ)



NDISASMOBJS = ndisasm.$(OBJ) disasm.$(OBJ) sync.$(OBJ) nasmlib.$(OBJ) \

              insnsd.$(OBJ)





#

# programs to create

#



all : nasm$(EXE) ndisasm$(EXE)





#

# We have to have a horrible kludge here to get round the 128 character

# limit, as usual... we'll simply use LNK-files :)

#

nasm$(EXE): $(NASMOBJS)

        $(LINK) $(LINKFLAGS) @<<

$(NASMOBJS)

nasm.exe;

<<



ndisasm$(EXE): $(NDISASMOBJS)

        $(LINK) $(LINKFLAGS) @<<

$(NDISASMOBJS)

ndisasm.exe;

<<







#

# modules for programs

#



disasm.$(OBJ): disasm.c nasm.h disasm.h sync.h insns.h names.c

assemble.$(OBJ): assemble.c nasm.h assemble.h insns.h

float.$(OBJ): float.c nasm.h

labels.$(OBJ): labels.c nasm.h nasmlib.h

listing.$(OBJ): listing.c nasm.h nasmlib.h listing.h

nasm.$(OBJ): nasm.c nasm.h nasmlib.h parser.h assemble.h labels.h \

	listing.h outform.h

nasmlib.$(OBJ): nasmlib.c nasm.h nasmlib.h

ndisasm.$(OBJ): ndisasm.c nasm.h sync.h disasm.h

outas86.$(OBJ): outas86.c nasm.h nasmlib.h

outaout.$(OBJ): outaout.c nasm.h nasmlib.h

outbin.$(OBJ): outbin.c nasm.h nasmlib.h

outcoff.$(OBJ): outcoff.c nasm.h nasmlib.h

outdbg.$(OBJ): outdbg.c nasm.h nasmlib.h

outelf.$(OBJ): outelf.c nasm.h nasmlib.h

outobj.$(OBJ): outobj.c nasm.h nasmlib.h

outrdf.$(OBJ): outrdf.c nasm.h nasmlib.h

outform.$(OBJ): outform.c outform.h nasm.h

parser.$(OBJ): parser.c nasm.h nasmlib.h parser.h float.h names.c

preproc.$(OBJ): preproc.c macros.c preproc.h nasm.h nasmlib.h

sync.$(OBJ): sync.c sync.h

insnsa.$(OBJ): insnsa.c nasm.h insns.h

insnsd.$(OBJ): insnsd.c nasm.h insns.h







clean :

	del *.obj

	del nasm$(EXE)

	del ndisasm$(EXE)

