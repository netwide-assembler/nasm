# Makefile for RDOFF object file utils; part of the Netwide Assembler
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.
#
# This Makefile is designed for use under Unix (probably fairly
# portably).

CC = gcc
CCFLAGS = -c -O -g -Wall -ansi -pedantic -I..
LINK = gcc
LINKFLAGS = -o
DLINKFLAGS = -o
LIBRARIES =
STRIP = strip
LDRDFLIBS = rdoff.o ../nasmlib.o symtab.o collectn.o
RDXLIBS = rdoff.o rdfload.o symtab.o collectn.o

.c.o:
	$(CC) $(CCFLAGS) $*.c

all : rdfdump ldrdf rdx

rdfdump : rdfdump.o
	$(LINK) $(LINKFLAGS) rdfdump rdfdump.o
ldrdf : ldrdf.o $(LDRDFLIBS)
	$(LINK) $(LINKFLAGS) ldrdf ldrdf.o $(LDRDFLIBS)
rdx : rdx.o  $(RDXLIBS)
	$(LINK) $(LINKFLAGS) rdx rdx.o $(RDXLIBS)

rdfdump.o : rdfdump.c
rdoff.o : rdoff.c rdoff.h
ldrdf.o : ldrdf.c rdoff.h ../nasmlib.h symtab.h collectn.h
symtab.o : symtab.c symtab.h
collectn.o : collectn.c collectn.h
rdx.o : rdx.c rdoff.h rdfload.h symtab.h
rdfload.o : rdfload.c rdfload.h rdoff.h collectn.h symtab.h

clean :
	rm -f *.o *~ rdfdump ldrdf rdx
	make -C test clean
