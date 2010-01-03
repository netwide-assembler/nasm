# -*- makefile -*-
#
# Makefile for building NASM using OpenWatcom 1.7
# building on a DOS/Win/OS2 platform host (backslashes
# used in pathnames)
#

top_srcdir	= .
srcdir		= .
VPATH		= .\output
prefix		= C:\Program Files\NASM
exec_prefix	= $(prefix)
bindir		= $(prefix)\bin
mandir		= $(prefix)\man

CC		= wcl386
DEBUG		=
CFLAGS		= -6 -ox -wx -ze -fpi $(DEBUG)
BUILD_CFLAGS	= $(CFLAGS) $(TARGET_FLAGS) # -I$(srcdir)/inttypes
INTERNAL_CFLAGS = -I$(srcdir) -I. -DHAVE_SNPRINTF -DHAVE_VSNPRINTF
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

# Needed to find C files anywhere but in the current directory
.c : $(VPATH)

.c.$(O):
	$(CC) -c $(ALL_CFLAGS) -fo=$^@ $[@

# Note: wcl386 is broken if forward slashes are used as path separators.
#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	nasm.$(O) nasmlib.$(O) ver.$(O) &
	raa.$(O) saa.$(O) rbtree.$(O) &
	float.$(O) insnsa.$(O) insnsb.$(O) &
	directives.$(O) &
	assemble.$(O) labels.$(O) hashtbl.$(O) crc64.$(O) parser.$(O) &
	output\outform.$(O) output\outlib.$(O) output\nulldbg.$(O) &
	output\nullout.$(O) &
	output\outbin.$(O) output\outaout.$(O) output\outcoff.$(O) &
	output\outelf.$(O) output\outelf32.$(O) output\outelf64.$(O) &
	output\outobj.$(O) output\outas86.$(O) output\outrdf2.$(O) &
	output\outdbg.$(O) output\outieee.$(O) output\outmacho32.$(O) &
	output\outmacho64.$(O) preproc.$(O) quote.$(O) pptok.$(O) &
	macros.$(O) listing.$(O) eval.$(O) exprlib.$(O) stdscan.$(O) &
	strfunc.$(O) tokhash.$(O) regvals.$(O) regflags.$(O) &
	lib\strlcpy.$(O)

NDISASM = ndisasm.$(O) disasm.$(O) sync.$(O) nasmlib.$(O) ver.$(O) &
	insnsd.$(O) insnsb.$(O) insnsn.$(O) regs.$(O) regdis.$(O)
#-- End File Lists --#

what:	.SYMBOLIC
	@echo Please build "dos", "win32" or "os2"

dos:	.SYMBOLIC
	$(MAKE) /f $(__MAKEFILES__) all TARGET_FLAGS="-bt=DOS -l=DOS4G"

win32:	.SYMBOLIC
	$(MAKE) /f $(__MAKEFILES__) all TARGET_FLAGS="-bt=NT  -l=NT"

os2:	.SYMBOLIC
	$(MAKE) /f $(__MAKEFILES__) all TARGET_FLAGS="-bt=OS2 -l=OS2V2"

all: nasm$(X) ndisasm$(X) .SYMBOLIC
	rem cd rdoff && $(MAKE) all

nasm$(X): $(NASM)
	$(LD) $(LDFLAGS) -fe=nasm$(X) $(NASM) $(LIBS)

ndisasm$(X): $(NDISASM)
	$(LD) $(LDFLAGS) -fe=ndisasm$(X) $(NDISASM) $(LIBS)

# These source files are automagically generated from a single
# instruction-table file by a Perl script. They're distributed,
# though, so it isn't necessary to have Perl just to recompile NASM
# from the distribution.

insnsb.c: insns.dat insns.pl
	$(PERL) $(srcdir)/insns.pl -b $(srcdir)/insns.dat
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
regdis.h: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl dh $(srcdir)/regs.dat > regdis.h
regvals.c: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl vc $(srcdir)/regs.dat > regvals.c
regs.h: regs.dat regs.pl
	$(PERL) $(srcdir)/regs.pl h $(srcdir)/regs.dat > regs.h

# Assembler token hash
tokhash.c: insns.dat regs.dat tokens.dat tokhash.pl perllib/phash.ph
	$(PERL) $(srcdir)/tokhash.pl c $(srcdir)/insns.dat $(srcdir)/regs.dat &
		$(srcdir)/tokens.dat > tokhash.c

# Assembler token metadata
tokens.h: insns.dat regs.dat tokens.dat tokhash.pl perllib/phash.ph
	$(PERL) $(srcdir)/tokhash.pl h $(srcdir)/insns.dat $(srcdir)/regs.dat &
		$(srcdir)/tokens.dat > tokens.h

# Preprocessor token hash
pptok.h: pptok.dat pptok.pl perllib/phash.ph
	$(PERL) $(srcdir)/pptok.pl h $(srcdir)/pptok.dat pptok.h
pptok.c: pptok.dat pptok.pl perllib/phash.ph
	$(PERL) $(srcdir)/pptok.pl c $(srcdir)/pptok.dat pptok.c

# This target generates all files that require perl.
# This allows easier generation of distribution (see dist target).
PERLREQ = macros.c insnsb.c insnsa.c insnsd.c insnsi.h insnsn.c &
	  regs.c regs.h regflags.c regdis.c regdis.h regvals.c &
	  tokhash.c tokens.h pptok.h pptok.c &
	  version.h version.mac
perlreq: $(PERLREQ)

clean: .SYMBOLIC
	-del /f *.$(O)
	-del /f *.s
	-del /f *.i
	-del /f output\*.$(O)
	-del /f output\*.s
	-del /f output\*.i
	-del /f nasm$(X)
	-del /f ndisasm$(X)
	rem cd rdoff && $(MAKE) clean

distclean: clean .SYMBOLIC
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

cleaner: clean .SYMBOLIC
	-del /f $(PERLREQ)
	-del /f *.man
	-del /f nasm.spec
	rem cd doc && $(MAKE) clean

spotless: distclean cleaner .SYMBOLIC
	-del /f doc\Makefile
	-del doc\*~
	-del doc\*.bak

strip: .SYMBOLIC
	$(STRIP) *.exe

rdf:
	# cd rdoff && $(MAKE)

doc:
	# cd doc && $(MAKE) all

everything: all doc rdf

#-- Magic hints to mkdep.pl --#
# @object-ending: ".$(O)"
# @path-separator: "\"
# @exclude: "config.h"
# @continuation: "&"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.$(O): assemble.c assemble.h compiler.h directives.h insns.h &
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h &
 tokens.h
crc64.$(O): crc64.c compiler.h nasmlib.h
directives.$(O): directives.c compiler.h directives.h hashtbl.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
disasm.$(O): disasm.c compiler.h directives.h disasm.h insns.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regdis.h regs.h sync.h &
 tables.h tokens.h
eval.$(O): eval.c compiler.h directives.h eval.h float.h insnsi.h labels.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
exprlib.$(O): exprlib.c compiler.h directives.h insnsi.h nasm.h nasmlib.h &
 opflags.h pptok.h preproc.h regs.h
float.$(O): float.c compiler.h directives.h float.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h
hashtbl.$(O): hashtbl.c compiler.h directives.h hashtbl.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h
insnsa.$(O): insnsa.c compiler.h directives.h insns.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsb.$(O): insnsb.c compiler.h directives.h insns.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsd.$(O): insnsd.c compiler.h directives.h insns.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsn.$(O): insnsn.c compiler.h insnsi.h opflags.h tables.h
labels.$(O): labels.c compiler.h directives.h hashtbl.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h
lib\snprintf.$(O): lib\snprintf.c compiler.h nasmlib.h
lib\strlcpy.$(O): lib\strlcpy.c compiler.h
lib\vsnprintf.$(O): lib\vsnprintf.c compiler.h nasmlib.h
listing.$(O): listing.c compiler.h directives.h insnsi.h listing.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h
macros.$(O): macros.c compiler.h directives.h hashtbl.h insnsi.h nasm.h &
 nasmlib.h opflags.h output\outform.h pptok.h preproc.h regs.h tables.h
nasm.$(O): nasm.c assemble.h compiler.h directives.h eval.h float.h insns.h &
 insnsi.h labels.h listing.h nasm.h nasmlib.h opflags.h output\outform.h &
 parser.h pptok.h preproc.h raa.h regs.h saa.h stdscan.h tokens.h
nasmlib.$(O): nasmlib.c compiler.h directives.h insns.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
ndisasm.$(O): ndisasm.c compiler.h directives.h disasm.h insns.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h sync.h tokens.h
output\nulldbg.$(O): output\nulldbg.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
output\nullout.$(O): output\nullout.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outlib.h pptok.h preproc.h regs.h
output\outaout.$(O): output\outaout.c compiler.h directives.h eval.h &
 insnsi.h nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h &
 pptok.h preproc.h raa.h regs.h saa.h stdscan.h
output\outas86.$(O): output\outas86.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h pptok.h &
 preproc.h raa.h regs.h saa.h
output\outbin.$(O): output\outbin.c compiler.h directives.h eval.h insnsi.h &
 labels.h nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h &
 pptok.h preproc.h regs.h saa.h stdscan.h
output\outcoff.$(O): output\outcoff.c compiler.h directives.h eval.h &
 insnsi.h nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h &
 pptok.h preproc.h raa.h regs.h saa.h
output\outdbg.$(O): output\outdbg.c compiler.h directives.h insnsi.h nasm.h &
 nasmlib.h opflags.h output\outform.h pptok.h preproc.h regs.h
output\outelf.$(O): output\outelf.c compiler.h directives.h insnsi.h nasm.h &
 nasmlib.h opflags.h output\dwarf.h output\elf.h output\outelf.h &
 output\outform.h pptok.h preproc.h regs.h
output\outelf32.$(O): output\outelf32.c compiler.h directives.h eval.h &
 insnsi.h nasm.h nasmlib.h opflags.h output\dwarf.h output\elf.h &
 output\outelf.h output\outform.h output\outlib.h output\stabs.h pptok.h &
 preproc.h raa.h rbtree.h regs.h saa.h stdscan.h
output\outelf64.$(O): output\outelf64.c compiler.h directives.h eval.h &
 insnsi.h nasm.h nasmlib.h opflags.h output\dwarf.h output\elf.h &
 output\outelf.h output\outform.h output\outlib.h output\stabs.h pptok.h &
 preproc.h raa.h rbtree.h regs.h saa.h stdscan.h
output\outform.$(O): output\outform.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h pptok.h preproc.h regs.h
output\outieee.$(O): output\outieee.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h pptok.h &
 preproc.h regs.h
output\outlib.$(O): output\outlib.c compiler.h directives.h insnsi.h nasm.h &
 nasmlib.h opflags.h output\outlib.h pptok.h preproc.h regs.h
output\outmacho32.$(O): output\outmacho32.c compiler.h directives.h eval.h &
 insnsi.h nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h &
 pptok.h preproc.h raa.h regs.h saa.h
output\outmacho64.$(O): output\outmacho64.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h pptok.h &
 preproc.h raa.h regs.h saa.h
output\outobj.$(O): output\outobj.c compiler.h directives.h eval.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h pptok.h &
 preproc.h regs.h stdscan.h
output\outrdf2.$(O): output\outrdf2.c compiler.h directives.h insnsi.h &
 nasm.h nasmlib.h opflags.h output\outform.h output\outlib.h pptok.h &
 preproc.h rdoff\rdoff.h regs.h saa.h
parser.$(O): parser.c compiler.h directives.h eval.h float.h insns.h &
 insnsi.h nasm.h nasmlib.h opflags.h parser.h pptok.h preproc.h regs.h &
 stdscan.h tables.h tokens.h
pptok.$(O): pptok.c compiler.h hashtbl.h nasmlib.h pptok.h preproc.h
preproc.$(O): preproc.c compiler.h directives.h eval.h hashtbl.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h stdscan.h &
 tables.h tokens.h
quote.$(O): quote.c compiler.h nasmlib.h quote.h
raa.$(O): raa.c compiler.h nasmlib.h raa.h
rbtree.$(O): rbtree.c compiler.h rbtree.h
regdis.$(O): regdis.c regdis.h regs.h
regflags.$(O): regflags.c compiler.h directives.h insnsi.h nasm.h nasmlib.h &
 opflags.h pptok.h preproc.h regs.h tables.h
regs.$(O): regs.c compiler.h insnsi.h opflags.h tables.h
regvals.$(O): regvals.c compiler.h insnsi.h opflags.h tables.h
saa.$(O): saa.c compiler.h nasmlib.h saa.h
stdscan.$(O): stdscan.c compiler.h directives.h insns.h insnsi.h nasm.h &
 nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h stdscan.h tokens.h
strfunc.$(O): strfunc.c compiler.h directives.h insnsi.h nasm.h nasmlib.h &
 opflags.h pptok.h preproc.h regs.h
sync.$(O): sync.c compiler.h nasmlib.h sync.h
tokhash.$(O): tokhash.c compiler.h directives.h hashtbl.h insns.h insnsi.h &
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
ver.$(O): ver.c compiler.h directives.h insnsi.h nasm.h nasmlib.h opflags.h &
 pptok.h preproc.h regs.h version.h
