# Makefile for the Netwide Assembler
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.
#
# This Makefile is designed for use under Unix (probably fairly
# portably). It can also be used without change to build NASM using
# DJGPP. The makefile "Makefile.dos" can be used to build NASM using
# a 16-bit DOS C compiler such as Microsoft C.
#
# The `make dist' section at the end of the Makefile is not
# guaranteed to work anywhere except Linux. Come to think of it,
# I'm not sure I want to guarantee it to work anywhere except on
# _my_ computer. :-)

CC = gcc
CCFLAGS = -c -g -O -Wall -ansi -pedantic
LINK = gcc
LINKFLAGS = -o nasm
DLINKFLAGS = -o ndisasm
LIBRARIES =
STRIP = strip
EXE =#
OBJ = o#

.c.$(OBJ):
	$(CC) $(CCFLAGS) $*.c

NASMOBJS = nasm.$(OBJ) nasmlib.$(OBJ) float.$(OBJ) insnsa.$(OBJ) \
           assemble.$(OBJ) labels.$(OBJ) parser.$(OBJ) outform.$(OBJ) \
	   outbin.$(OBJ) outaout.$(OBJ) outcoff.$(OBJ) outelf.$(OBJ) \
	   outobj.$(OBJ) outas86.$(OBJ) outrdf.$(OBJ) outdbg.$(OBJ)

NDISASMOBJS = ndisasm.$(OBJ) disasm.$(OBJ) sync.$(OBJ) nasmlib.$(OBJ) \
	      insnsd.$(OBJ)

all : nasm$(EXE) ndisasm$(EXE)

nasm$(EXE): $(NASMOBJS)
	$(LINK) $(LINKFLAGS) $(NASMOBJS) $(LIBRARIES)

ndisasm$(EXE): $(NDISASMOBJS)
	$(LINK) $(DLINKFLAGS) $(NDISASMOBJS) $(LIBRARIES)

assemble.$(OBJ): assemble.c nasm.h assemble.h insns.h
disasm.$(OBJ): disasm.c nasm.h disasm.h sync.h insns.h names.c
float.$(OBJ): float.c nasm.h
insnsa.$(OBJ): insnsa.c nasm.h insns.h
insnsd.$(OBJ): insnsd.c nasm.h insns.h
labels.$(OBJ): labels.c nasm.h nasmlib.h
nasm.$(OBJ): nasm.c nasm.h nasmlib.h parser.h assemble.h labels.h outform.h
nasmlib.$(OBJ): nasmlib.c nasm.h nasmlib.h
ndisasm.$(OBJ): ndisasm.c nasm.h sync.h disasm.h
outas86.$(OBJ): outas86.c nasm.h nasmlib.h
outaout.$(OBJ): outaout.c nasm.h nasmlib.h
outbin.$(OBJ): outbin.c nasm.h nasmlib.h
outcoff.$(OBJ): outcoff.c nasm.h nasmlib.h
outelf.$(OBJ): outelf.c nasm.h nasmlib.h
outobj.$(OBJ): outobj.c nasm.h nasmlib.h
outform.$(OBJ): outform.c outform.h nasm.h
parser.$(OBJ): parser.c nasm.h nasmlib.h parser.h float.h names.c
sync.$(OBJ): sync.c sync.h

# These two source files are automagically generated from a single
# instruction-table file by a Perl script. They're distributed,
# though, so it isn't necessary to have Perl just to recompile NASM
# from the distribution.

AUTOSRCS = insnsa.c insnsd.c
$(AUTOSRCS): insns.dat insns.pl
	perl insns.pl

clean :
	rm -f $(NASMOBJS) $(NDISASMOBJS) nasm$(EXE) ndisasm$(EXE)
	make -C rdoff clean
	make -C test clean

# Here the `make dist' section begins. Nothing is guaranteed hereafter
# unless you're using the Makefile under Linux, running bash, with
# gzip, GNU tar and a sensible version of zip readily available.

DOSEXES = nasm.exe ndisasm.exe
MANPAGES = nasm.man ndisasm.man

.SUFFIXES: .man .1

.1.man:
	-man ./$< | ul > $@

dist: $(AUTOSRCS) $(MANPAGES) $(DOSEXES) clean
	makedist.sh
