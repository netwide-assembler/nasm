# -*- makefile -*-
#
# Makefile for cross-compiling NASM from Linux
# to DOS, Win32 or OS/2 using OpenWatcom.
#

top_srcdir	= .
srcdir		= .
prefix		= C:/Program Files/NASM
exec_prefix	= $(prefix)
bindir		= $(prefix)/bin
mandir		= $(prefix)/man

CC		= wcl386
CFLAGS		= -3 -bcl=$(TARGET) -ox -wx -ze -fpi
BUILD_CFLAGS	= $(CFLAGS) # -I$(srcdir)/inttypes
INTERNAL_CFLAGS = -I$(srcdir) -I. \
		  -DHAVE_SNPRINTF -DHAVE_VSNPRINTF
ALL_CFLAGS	= $(BUILD_CFLAGS) $(INTERNAL_CFLAGS)
LD		= $(CC)
LDFLAGS		= $(ALL_CFLAGS)
LIBS		= 
PERL		= perl -I$(srcdir)/perllib

STRIP		= wstrip

# Binary suffixes
O               = obj
X               = .exe

# WMAKE errors out if a suffix is declared more than once, including
# its own built-in declarations.  Thus, we need to explicitly clear the list
# first.  Also, WMAKE only allows implicit rules that point "to the left"
# in this list!
.SUFFIXES:
.SUFFIXES: .man .1 .$(O) .i .c

.c.$(O):
	$(CC) -c $(ALL_CFLAGS) -fo=$@ $<

NASM =	nasm.$(O) nasmlib.$(O) float.$(O) insnsa.$(O) assemble.$(O) \
	labels.$(O) hashtbl.$(O) crc64.$(O) parser.$(O) \
	outform.$(O) output/outbin.$(O) \
	output/outaout.$(O) output/outcoff.$(O) \
	output/outelf32.$(O) output/outelf64.$(O) \
	output/outobj.$(O) output/outas86.$(O) output/outrdf2.$(O) \
	output/outdbg.$(O) output/outieee.$(O) output/outmacho.$(O) \
	preproc.$(O) pptok.$(O) \
	listing.$(O) eval.$(O) exprlib.$(O) stdscan.$(O) tokhash.$(O)

NDISASM = ndisasm.$(O) disasm.$(O) sync.$(O) nasmlib.$(O) insnsd.$(O)

what:
	@echo 'Please build "dos", "win32" or "os2"'

dos:
	$(MAKE) -f $(MAKEFILE_LIST) all TARGET=DOS4G

win32:
	$(MAKE) -f $(MAKEFILE_LIST) all TARGET=NT

os2:
	$(MAKE) -f $(MAKEFILE_LIST) all TARGET=OS2V2

all: nasm$(X) ndisasm$(X)

nasm$(X): $(NASM)
	$(LD) $(LDFLAGS) -fe=nasm$(X) $(NASM) $(LIBS)

ndisasm$(X): $(NDISASM)
	$(LD) $(LDFLAGS) -fe=ndisasm$(X) $(NDISASM) $(LIBS)

# These source files are automagically generated from a single
# instruction-table file by a Perl script. They're distributed,
# though, so it isn't necessary to have Perl just to recompile NASM
# from the distribution.

insnsa.c: insns.dat insns.pl
	$(PERL) $(srcdir)/insns.pl -a $(srcdir)/insns.dat
insnsd.c: insns.dat insns.pl
	$(PERL) $(srcdir)/insns.pl -d $(srcdir)/insns.dat
insnsi.h: insns.dat insns.pl
	$(PERL) $(srcdir)/insns.pl -i $(srcdir)/insns.dat
insnsn.c: insns.dat insns.pl
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

macros.c: macros.pl standard.mac version.mac
	$(PERL) $(srcdir)/macros.pl $(srcdir)/standard.mac version.mac

# These source files are generated from regs.dat by yet another
# perl script.
regs.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl c $(srcdir)/regs.dat > regs.c
regflags.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl fc $(srcdir)/regs.dat > regflags.c
regdis.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl dc $(srcdir)/regs.dat > regdis.c
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

# This target generates all files that require perl.
# This allows easier generation of distribution (see dist target).
PERLREQ = macros.c insnsa.c insnsd.c insnsi.h insnsn.c \
	  regs.c regs.h regflags.c regdis.c regvals.c tokhash.c tokens.h \
	  version.h version.mac pptok.h pptok.c
perlreq: $(PERLREQ)

clean:
	-rm -f *.$(O)
	-rm -f *.s
	-rm -f *.i
	-rm -f output/*.$(O)
	-rm -f output/*.s
	-rm -f output/*.i
	-rm -f nasm$(X)
	-rm -f ndisasm$(X)
	# cd rdoff && $(MAKE) clean

distclean: clean .SYMBOLIC
	-rm -f config.h
	-rm -f config.log
	-rm -f config.status
	-rm -f Makefile
	-rm -f *~
	-rm -f *.bak
	-rm -f *.lst
	-rm -f *.bin
	-rm -f output/*~
	-rm -f output/*.bak
	-rm -f test/*.lst
	-rm -f test/*.bin
	-rm -f test/*.$(O)
	-rm -f test/*.bin
	-rm -f/s autom4te*.cache
	# cd rdoff && $(MAKE) distclean

cleaner: clean .SYMBOLIC
	-rm -f $(PERLREQ)
	-rm -f *.man
	-rm -f nasm.spec
	# cd doc && $(MAKE) clean

spotless: distclean cleaner .SYMBOLIC
	-rm -f doc/Makefile
	-rm -f doc/*~
	-rm -f doc/*.bak

strip:
	$(STRIP) *.exe

rdf:
	# cd rdoff && $(MAKE)

doc:
	# cd doc && $(MAKE) all

everything: all doc rdf

#-- Magic hints to mkdep.pl --#
# @object-ending: ".$(O)"
# @path-separator: "/"
# @exclude: "config.h"
# @continuation: "\"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.$(O): assemble.c assemble.h compiler.h insns.h insnsi.h nasm.h \
 nasmlib.h pptok.h preproc.h regflags.c regs.h regvals.c tokens.h version.h
crc64.$(O): crc64.c compiler.h
disasm.$(O): disasm.c compiler.h disasm.h insns.h insnsi.h insnsn.c names.c \
 nasm.h nasmlib.h regdis.c regs.c regs.h sync.h tokens.h version.h
eval.$(O): eval.c compiler.h eval.h float.h insnsi.h labels.h nasm.h \
 nasmlib.h regs.h version.h
exprlib.$(O): exprlib.c compiler.h insnsi.h nasm.h nasmlib.h regs.h \
 version.h
float.$(O): float.c compiler.h float.h insnsi.h nasm.h nasmlib.h regs.h \
 version.h
hashtbl.$(O): hashtbl.c compiler.h hashtbl.h insnsi.h nasm.h nasmlib.h \
 regs.h version.h
insnsa.$(O): insnsa.c compiler.h insns.h insnsi.h nasm.h nasmlib.h regs.h \
 tokens.h version.h
insnsd.$(O): insnsd.c compiler.h insns.h insnsi.h nasm.h nasmlib.h regs.h \
 tokens.h version.h
insnsn.$(O): insnsn.c
labels.$(O): labels.c compiler.h hashtbl.h insnsi.h nasm.h nasmlib.h regs.h \
 version.h
lib/snprintf.$(O): lib/snprintf.c compiler.h nasmlib.h
lib/vsnprintf.$(O): lib/vsnprintf.c compiler.h nasmlib.h
listing.$(O): listing.c compiler.h insnsi.h listing.h nasm.h nasmlib.h \
 regs.h version.h
macros.$(O): macros.c compiler.h
names.$(O): names.c compiler.h insnsn.c regs.c
nasm.$(O): nasm.c assemble.h compiler.h eval.h float.h insns.h insnsi.h \
 labels.h listing.h nasm.h nasmlib.h outform.h parser.h pptok.h preproc.h \
 regs.h stdscan.h tokens.h version.h
nasmlib.$(O): nasmlib.c compiler.h insns.h insnsi.h nasm.h nasmlib.h regs.h \
 tokens.h version.h
ndisasm.$(O): ndisasm.c compiler.h disasm.h insns.h insnsi.h nasm.h \
 nasmlib.h regs.h sync.h tokens.h version.h
outform.$(O): outform.c compiler.h insnsi.h nasm.h nasmlib.h outform.h \
 regs.h version.h
output/outaout.$(O): output/outaout.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h stdscan.h version.h
output/outas86.$(O): output/outas86.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outbin.$(O): output/outbin.c compiler.h eval.h insnsi.h labels.h \
 nasm.h nasmlib.h outform.h regs.h stdscan.h version.h
output/outcoff.$(O): output/outcoff.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outdbg.$(O): output/outdbg.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outelf32.$(O): output/outelf32.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h stdscan.h version.h
output/outelf64.$(O): output/outelf64.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h stdscan.h version.h
output/outieee.$(O): output/outieee.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outmacho.$(O): output/outmacho.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outobj.$(O): output/outobj.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h stdscan.h version.h
output/outrdf.$(O): output/outrdf.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h regs.h version.h
output/outrdf2.$(O): output/outrdf2.c compiler.h insnsi.h nasm.h nasmlib.h \
 outform.h rdoff/rdoff.h regs.h version.h
parser.$(O): parser.c compiler.h float.h insns.h insnsi.h nasm.h nasmlib.h \
 parser.h regflags.c regs.h stdscan.h tokens.h version.h
pptok.$(O): pptok.c compiler.h hashtbl.h nasmlib.h pptok.h preproc.h
preproc.$(O): preproc.c compiler.h hashtbl.h insnsi.h macros.c nasm.h \
 nasmlib.h pptok.h preproc.h regs.h stdscan.h tokens.h version.h
regdis.$(O): regdis.c
regflags.$(O): regflags.c
regs.$(O): regs.c compiler.h
regvals.$(O): regvals.c
stdscan.$(O): stdscan.c compiler.h insns.h insnsi.h nasm.h nasmlib.h regs.h \
 stdscan.h tokens.h version.h
sync.$(O): sync.c compiler.h nasmlib.h sync.h
tokhash.$(O): tokhash.c compiler.h hashtbl.h insns.h insnsi.h nasm.h \
 nasmlib.h regs.h tokens.h version.h
