# -*- makefile -*-
#
# Makefile for building NASM using Microsoft Visual C++ and NMAKE.
# Tested on Microsoft Visual C++ 2005 Express Edition.
#
# Make sure to put the appropriate directories in your PATH, in
# the case of MSVC++ 2005, they are ...\VC\bin and ...\Common7\IDE.
#
# This is typically done by opening the Visual Studio Command Prompt.
#

top_srcdir	= .
srcdir		= .
VPATH		= .
prefix		= C:\Program Files\NASM
exec_prefix	= $(prefix)
bindir		= $(prefix)/bin
mandir		= $(prefix)/man

!IF "$(DEBUG)" == "1"
CFLAGS		= /Od /Zi
LDFLAGS		= /DEBUG
!ELSE
CFLAGS		= /O2
!ENDIF

CC		= cl
LD		= link
CFLAGS		= $(CFLAGS) /W2
BUILD_CFLAGS	= $(CFLAGS) /I$(srcdir)/inttypes
INTERNAL_CFLAGS = /I$(srcdir) /I. \
		  /DHAVE__SNPRINTF /DHAVE__VSNPRINTF /DHAVE__FULLPATH
ALL_CFLAGS	= $(BUILD_CFLAGS) $(INTERNAL_CFLAGS)
LDFLAGS		= $(LDFLAGS) /SUBSYSTEM:CONSOLE
LIBS		=
PERL		= perl -I$(srcdir)/perllib

# Binary suffixes
O               = obj
X               = .exe

.SUFFIXES: .c .i .s .$(O) .1 .man

.c.obj:
	$(CC) /c $(ALL_CFLAGS) /Fo$@ $<

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	nasm.$(O) nasmlib.$(O) ver.$(O) \
	raa.$(O) saa.$(O) rbtree.$(O) \
	realpath.$(O) \
	float.$(O) insnsa.$(O) insnsb.$(O) \
	directiv.$(O) \
	assemble.$(O) labels.$(O) hashtbl.$(O) crc64.$(O) parser.$(O) \
	output/outform.$(O) output/outlib.$(O) output/nulldbg.$(O) \
	output/nullout.$(O) \
	output/outbin.$(O) output/outaout.$(O) output/outcoff.$(O) \
	output/outelf.$(O) output/outelf32.$(O) output/outelf64.$(O) \
	output/outelfx32.$(O) \
	output/outobj.$(O) output/outas86.$(O) output/outrdf2.$(O) \
	output/outdbg.$(O) output/outieee.$(O) output/outmacho.$(O) \
	md5c.$(O) output/codeview.$(O) \
	preproc.$(O) quote.$(O) pptok.$(O) \
	macros.$(O) listing.$(O) eval.$(O) exprlib.$(O) stdscan.$(O) \
	strfunc.$(O) tokhash.$(O) regvals.$(O) regflags.$(O) \
	ilog2.$(O) \
	lib/strlcpy.$(O) \
	preproc-nop.$(O) \
	disp8.$(O) \
	iflag.$(O)

NDISASM = ndisasm.$(O) disasm.$(O) sync.$(O) nasmlib.$(O) ver.$(O) \
	insnsd.$(O) insnsb.$(O) insnsn.$(O) regs.$(O) regdis.$(O) \
	disp8.$(O) iflag.$(O)
#-- End File Lists --#

all: nasm$(X) ndisasm$(X)
	rem cd rdoff && $(MAKE) all

nasm$(X): $(NASM)
	$(LD) $(LDFLAGS) /OUT:nasm$(X) $(NASM) $(LIBS)

ndisasm$(X): $(NDISASM)
	$(LD) $(LDFLAGS) /OUT:ndisasm$(X) $(NDISASM) $(LIBS)

# These source files are automagically generated from a single
# instruction-table file by a Perl script. They're distributed,
# though, so it isn't necessary to have Perl just to recompile NASM
# from the distribution.

insns.pl: insns-iflags.pl

INSDEP = insns.dat insns.pl insns-iflags.pl

iflag.c: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -fc $(srcdir)/insns.dat
iflaggen.h: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -fh $(srcdir)/insns.dat
insnsb.c: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -b $(srcdir)/insns.dat
insnsa.c: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -a $(srcdir)/insns.dat
insnsd.c: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -d $(srcdir)/insns.dat
insnsi.h: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -i $(srcdir)/insns.dat
insnsn.c: $(INSDEP)
	$(PERL) $(srcdir)/insns.pl -n $(srcdir)/insns.dat

# These files contains all the standard macros that are derived from
# the version number.
version.h: version version.pl
	$(PERL) $(srcdir)/version.pl h < $(srcdir)/version > version.h

version.mac: version version.pl
	$(PERL) $(srcdir)/version.pl mac < $(srcdir)/version > version.mac

# This source file is generated from the standard macros file
# `standard.mac' by another Perl script. Again, it's part of the
# standard distribution.

macros.c: macros.pl pptok.ph standard.mac version.mac \
	$(srcdir)/macros/*.mac $(srcdir)/output/*.mac
	$(PERL) $(srcdir)/macros.pl $(srcdir)/standard.mac version.mac \
		$(srcdir)/macros/*.mac $(srcdir)/output/*.mac

# These source files are generated from regs.dat by yet another
# perl script.
regs.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl c $(srcdir)/regs.dat > regs.c
regflags.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl fc $(srcdir)/regs.dat > regflags.c
regdis.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl dc $(srcdir)/regs.dat > regdis.c
regdis.h: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl dh $(srcdir)/regs.dat > regdis.h
regvals.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl vc $(srcdir)/regs.dat > regvals.c
regs.h: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl h $(srcdir)/regs.dat > regs.h

# Assembler token hash
tokhash.c: insns.dat regs.dat tokens.dat tokhash.pl perllib/phash.ph
	$(PERL) $(srcdir)/tokhash.pl c $(srcdir)/insns.dat $(srcdir)/regs.dat \
		$(srcdir)/tokens.dat > tokhash.c

# Assembler token metadata
tokens.h: insns.dat regs.dat tokens.dat tokhash.pl perllib/phash.ph
	$(PERL) $(srcdir)/tokhash.pl h $(srcdir)/insns.dat $(srcdir)/regs.dat \
		$(srcdir)/tokens.dat > tokens.h

# Preprocessor token hash
pptok.h: pptok.dat pptok.pl perllib/phash.ph
	$(PERL) $(srcdir)/pptok.pl h $(srcdir)/pptok.dat pptok.h
pptok.c: pptok.dat pptok.pl perllib/phash.ph
	$(PERL) $(srcdir)/pptok.pl c $(srcdir)/pptok.dat pptok.c
pptok.ph: pptok.dat pptok.pl perllib/phash.ph
	$(PERL) $(srcdir)/pptok.pl ph $(srcdir)/pptok.dat pptok.ph

# Directives hash
directiv.h: directiv.dat directiv.pl perllib/phash.ph
	$(PERL) $(srcdir)/directiv.pl h $(srcdir)/directiv.dat directiv.h
directiv.c: directiv.dat directiv.pl perllib/phash.ph
	$(PERL) $(srcdir)/directiv.pl c $(srcdir)/directiv.dat directiv.c

# This target generates all files that require perl.
# This allows easier generation of distribution (see dist target).
PERLREQ = macros.c insnsb.c insnsa.c insnsd.c insnsi.h insnsn.c \
	  regs.c regs.h regflags.c regdis.c regvals.c tokhash.c tokens.h \
	  version.h version.mac pptok.h pptok.c iflag.c iflag.h
perlreq: $(PERLREQ)

clean:
	-del /f *.$(O)
	-del /f *.s
	-del /f *.i
	-del /f lib\*.$(O)
	-del /f lib\*.s
	-del /f lib\*.i
	-del /f output\*.$(O)
	-del /f output\*.s
	-del /f output\*.i
	-del /f nasm$(X)
	-del /f ndisasm$(X)
	rem cd rdoff && $(MAKE) clean

distclean: clean
	-del /f config.h
	-del /f config.log
	-del /f config.status
	-del /f Makefile
	-del /f *~
	-del /f *.bak
	-del /f *.lst
	-del /f *.bin
	-del /f output\*~
	-del /f output\*.bak
	-del /f test\*.lst
	-del /f test\*.bin
	-del /f test\*.$(O)
	-del /f test\*.bin
	-del /f/s autom4te*.cache
	rem cd rdoff && $(MAKE) distclean

cleaner: clean
	-del /f $(PERLREQ)
	-del /f *.man
	-del /f nasm.spec
	rem cd doc && $(MAKE) clean

spotless: distclean cleaner
	-del /f doc\Makefile
	-del doc\*~
	-del doc\*.bak

strip:

rdf:
	# cd rdoff && $(MAKE)

doc:
	# cd doc && $(MAKE) all

everything: all doc rdf

#-- Magic hints to mkdep.pl --#
# @object-ending: ".$(O)"
# @path-separator: "/"
# @exclude: "config.h"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.$(O): assemble.c assemble.h compiler.h directiv.h disp8.h iflag.h \
 iflaggen.h insns.h insnsi.h listing.h nasm.h nasmlib.h opflags.h pptok.h \
 preproc.h regs.h tables.h tokens.h
crc64.$(O): crc64.c compiler.h hashtbl.h nasmlib.h
directiv.$(O): directiv.c compiler.h directiv.h hashtbl.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
disasm.$(O): disasm.c compiler.h directiv.h disasm.h disp8.h iflag.h \
 iflaggen.h insns.h insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h \
 regdis.h regs.h sync.h tables.h tokens.h
disp8.$(O): disp8.c compiler.h directiv.h disp8.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h tables.h
eval.$(O): eval.c compiler.h directiv.h eval.h float.h insnsi.h labels.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
exprlib.$(O): exprlib.c compiler.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h tables.h
float.$(O): float.c compiler.h directiv.h float.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h tables.h
hashtbl.$(O): hashtbl.c compiler.h directiv.h hashtbl.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
iflag.$(O): iflag.c compiler.h iflag.h iflaggen.h
ilog2.$(O): ilog2.c compiler.h nasmlib.h
insnsa.$(O): insnsa.c compiler.h directiv.h iflag.h iflaggen.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h \
 tokens.h
insnsb.$(O): insnsb.c compiler.h directiv.h iflag.h iflaggen.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h \
 tokens.h
insnsd.$(O): insnsd.c compiler.h directiv.h iflag.h iflaggen.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h \
 tokens.h
insnsn.$(O): insnsn.c compiler.h insnsi.h tables.h
labels.$(O): labels.c compiler.h directiv.h hashtbl.h insnsi.h labels.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
lib/snprintf.$(O): lib/snprintf.c compiler.h nasmlib.h
lib/strlcpy.$(O): lib/strlcpy.c compiler.h
lib/vsnprintf.$(O): lib/vsnprintf.c compiler.h nasmlib.h
listing.$(O): listing.c compiler.h directiv.h insnsi.h listing.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
macros.$(O): macros.c compiler.h directiv.h hashtbl.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h pptok.h preproc.h regs.h tables.h
md5c.$(O): md5c.c compiler.h md5.h
nasm.$(O): nasm.c assemble.h compiler.h directiv.h eval.h float.h iflag.h \
 iflaggen.h insns.h insnsi.h labels.h listing.h nasm.h nasmlib.h opflags.h \
 output/outform.h parser.h pptok.h preproc.h raa.h regs.h saa.h stdscan.h \
 tables.h tokens.h
nasmlib.$(O): nasmlib.c compiler.h directiv.h iflag.h iflaggen.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h \
 tokens.h
ndisasm.$(O): ndisasm.c compiler.h directiv.h disasm.h iflag.h iflaggen.h \
 insns.h insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h sync.h \
 tables.h tokens.h
output/codeview.$(O): output/codeview.c compiler.h directiv.h insnsi.h md5.h \
 nasm.h nasmlib.h opflags.h output/outlib.h output/pecoff.h pptok.h \
 preproc.h regs.h saa.h tables.h version.h
output/nulldbg.$(O): output/nulldbg.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outlib.h pptok.h preproc.h regs.h tables.h
output/nullout.$(O): output/nullout.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outlib.h pptok.h preproc.h regs.h tables.h
output/outaout.$(O): output/outaout.c compiler.h directiv.h eval.h insnsi.h \
 nasm.h nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h \
 preproc.h raa.h regs.h saa.h stdscan.h tables.h
output/outas86.$(O): output/outas86.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h preproc.h \
 raa.h regs.h saa.h tables.h
output/outbin.$(O): output/outbin.c compiler.h directiv.h eval.h insnsi.h \
 labels.h nasm.h nasmlib.h opflags.h output/outform.h output/outlib.h \
 pptok.h preproc.h regs.h saa.h stdscan.h tables.h
output/outcoff.$(O): output/outcoff.c compiler.h directiv.h eval.h insnsi.h \
 nasm.h nasmlib.h opflags.h output/outform.h output/outlib.h output/pecoff.h \
 pptok.h preproc.h raa.h regs.h saa.h tables.h
output/outdbg.$(O): output/outdbg.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h pptok.h preproc.h regs.h tables.h
output/outelf.$(O): output/outelf.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/dwarf.h output/elf.h output/outelf.h \
 output/outform.h pptok.h preproc.h rbtree.h regs.h saa.h tables.h
output/outelf32.$(O): output/outelf32.c compiler.h directiv.h eval.h \
 insnsi.h nasm.h nasmlib.h opflags.h output/dwarf.h output/elf.h \
 output/outelf.h output/outform.h output/outlib.h output/stabs.h pptok.h \
 preproc.h raa.h rbtree.h regs.h saa.h stdscan.h tables.h
output/outelf64.$(O): output/outelf64.c compiler.h directiv.h eval.h \
 insnsi.h nasm.h nasmlib.h opflags.h output/dwarf.h output/elf.h \
 output/outelf.h output/outform.h output/outlib.h output/stabs.h pptok.h \
 preproc.h raa.h rbtree.h regs.h saa.h stdscan.h tables.h
output/outelfx32.$(O): output/outelfx32.c compiler.h directiv.h eval.h \
 insnsi.h nasm.h nasmlib.h opflags.h output/dwarf.h output/elf.h \
 output/outelf.h output/outform.h output/outlib.h output/stabs.h pptok.h \
 preproc.h raa.h rbtree.h regs.h saa.h stdscan.h tables.h
output/outform.$(O): output/outform.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h pptok.h preproc.h regs.h tables.h
output/outieee.$(O): output/outieee.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h preproc.h \
 regs.h tables.h
output/outlib.$(O): output/outlib.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outlib.h pptok.h preproc.h regs.h tables.h
output/outmacho.$(O): output/outmacho.c compiler.h directiv.h insnsi.h \
 nasm.h nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h \
 preproc.h raa.h rbtree.h regs.h saa.h tables.h
output/outobj.$(O): output/outobj.c compiler.h directiv.h eval.h insnsi.h \
 nasm.h nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h \
 preproc.h regs.h stdscan.h tables.h
output/outrdf2.$(O): output/outrdf2.c compiler.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h output/outform.h output/outlib.h pptok.h preproc.h \
 rdoff/rdoff.h regs.h saa.h tables.h
parser.$(O): parser.c compiler.h directiv.h eval.h float.h iflag.h \
 iflaggen.h insns.h insnsi.h nasm.h nasmlib.h opflags.h parser.h pptok.h \
 preproc.h regs.h stdscan.h tables.h tokens.h
pptok.$(O): pptok.c compiler.h hashtbl.h nasmlib.h pptok.h preproc.h
preproc-nop.$(O): preproc-nop.c compiler.h directiv.h insnsi.h listing.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
preproc.$(O): preproc.c compiler.h directiv.h eval.h hashtbl.h insnsi.h \
 listing.h nasm.h nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h \
 stdscan.h tables.h tokens.h
quote.$(O): quote.c compiler.h nasmlib.h quote.h
raa.$(O): raa.c compiler.h nasmlib.h raa.h
rbtree.$(O): rbtree.c compiler.h rbtree.h
realpath.$(O): realpath.c compiler.h nasmlib.h
regdis.$(O): regdis.c regdis.h regs.h
regflags.$(O): regflags.c compiler.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h tables.h
regs.$(O): regs.c compiler.h insnsi.h tables.h
regvals.$(O): regvals.c compiler.h insnsi.h tables.h
saa.$(O): saa.c compiler.h nasmlib.h saa.h
stdscan.$(O): stdscan.c compiler.h directiv.h iflag.h iflaggen.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h \
 stdscan.h tables.h tokens.h
strfunc.$(O): strfunc.c compiler.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h tables.h
sync.$(O): sync.c compiler.h nasmlib.h sync.h
tokhash.$(O): tokhash.c compiler.h directiv.h hashtbl.h iflag.h iflaggen.h \
 insns.h insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h \
 stdscan.h tables.h tokens.h
ver.$(O): ver.c compiler.h directiv.h insnsi.h nasm.h nasmlib.h opflags.h \
 pptok.h preproc.h regs.h tables.h version.h
