# Makefile for RDOFF object file utils; part of the Netwide Assembler
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the license given in the file "LICENSE"
# distributed in the NASM archive.
#
# This Makefile is designed for use under Unix (probably fairly
# portably).

CC = sc
CCFLAGS = -I..\ -c -a1 -mn -Nc -w2 -w7 -o+time -5
LINK = link
LINKFLAGS = /noi /exet:NT /su:console

OBJ=obj
EXE=.exe

NASMLIB = ..\nasmlib.$(OBJ)
NASMLIB_H = ..\nasmlib.h
LDRDFLIBS = rdoff.$(OBJ) $(NASMLIB) symtab.$(OBJ) collectn.$(OBJ) rdlib.$(OBJ)
RDXLIBS = rdoff.$(OBJ) rdfload.$(OBJ) symtab.$(OBJ) collectn.$(OBJ)

.c.$(OBJ):
	$(CC) $(CCFLAGS) $*.c

all : rdfdump$(EXE) ldrdf$(EXE) rdx$(EXE) rdflib$(EXE) rdf2bin$(EXE) rdf2com$(EXE)

rdfdump$(EXE)   : rdfdump.$(OBJ)
        $(LINK) $(LINKFLAGS) rdfdump.$(OBJ), rdfdump$(EXE);
ldrdf$(EXE)     : ldrdf.$(OBJ) $(LDRDFLIBS)
        $(LINK) $(LINKFLAGS) ldrdf.$(OBJ) $(LDRDFLIBS), ldrdf$(EXE);
rdx$(EXE)       : rdx.$(OBJ) $(RDXLIBS)
        $(LINK) $(LINKFLAGS) rdx.$(OBJ) $(RDXLIBS), rdx$(EXE);
rdflib$(EXE)    : rdflib.$(OBJ)
        $(LINK) $(LINKFLAGS) rdflib.$(OBJ), rdflib$(EXE);
rdf2bin$(EXE)   : rdf2bin.$(OBJ) $(RDXLIBS) $(NASMLIB)
        $(LINK) $(LINKFLAGS) rdf2bin.$(OBJ) $(RDXLIBS) $(NASMLIB), rdf2bin$(EXE);
rdf2com$(EXE)   : rdf2bin$(EXE)
        copy rdf2bin$(EXE) rdf2com$(EXE)

rdf2bin.$(OBJ)  : rdf2bin.c
rdfdump.$(OBJ)  : rdfdump.c
rdoff.$(OBJ)    : rdoff.c rdoff.h
ldrdf.$(OBJ)    : ldrdf.c rdoff.h $(NASMLIB_H) symtab.h collectn.h rdlib.h
symtab.$(OBJ)   : symtab.c symtab.h
collectn.$(OBJ) : collectn.c collectn.h
rdx.$(OBJ)      : rdx.c rdoff.h rdfload.h symtab.h
rdfload.$(OBJ)  : rdfload.c rdfload.h rdoff.h collectn.h symtab.h
rdlib.$(OBJ)    : rdlib.c rdlib.h
rdflib.$(OBJ)   : rdflib.c

clean :
        del *.$(OBJ) rdfdump$(EXE) ldrdf$(EXE) rdx$(EXE) rdflib$(EXE) rdf2bin$(EXE)


