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
CCFLAGS = -c -g -Wall -ansi -pedantic -I..
LINK = gcc
LINKFLAGS = -g -o
DLINKFLAGS = -o
LIBRARIES = 
STRIP = strip
LDRDFLIBS = rdoff.o ../nasmlib.o symtab.o collectn.o rdlib.o
RDXLIBS = rdoff.o rdfload.o symtab.o collectn.o

.c.o:
	$(CC) $(CCFLAGS) $*.c

all : rdfdump ldrdf rdx rdflib rdf2bin rdf2com

rdfdump : rdfdump.o
	$(LINK) $(LINKFLAGS) rdfdump rdfdump.o
ldrdf : ldrdf.o $(LDRDFLIBS)
	$(LINK) $(LINKFLAGS) ldrdf ldrdf.o $(LDRDFLIBS)
rdx : rdx.o  $(RDXLIBS)
	$(LINK) $(LINKFLAGS) rdx rdx.o $(RDXLIBS)
rdflib : rdflib.o
	$(LINK) $(LINKFLAGS) rdflib rdflib.o
rdf2bin : rdf2bin.o $(RDXLIBS) ../nasmlib.o
	$(LINK) $(LINKFLAGS) rdf2bin rdf2bin.o $(RDXLIBS) ../nasmlib.o
rdf2com :
	ln -s rdf2bin rdf2com

rdf2bin.o : rdf2bin.c
rdfdump.o : rdfdump.c
rdoff.o : rdoff.c rdoff.h
ldrdf.o : ldrdf.c rdoff.h ../nasmlib.h symtab.h collectn.h rdlib.h
symtab.o : symtab.c symtab.h
collectn.o : collectn.c collectn.h
rdx.o : rdx.c rdoff.h rdfload.h symtab.h
rdfload.o : rdfload.c rdfload.h rdoff.h collectn.h symtab.h
rdlib.o : rdlib.c rdlib.h
rdflib.o : rdflib.c

clean :
	rm -f *.o *~ rdfdump ldrdf rdx rdflib rdf2bin


