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
CFLAGS		= /O2 /Zi
LDFLAGS		= /DEBUG /OPT:REF /OPT:ICF # (latter two undoes /DEBUG harm)
!ENDIF

CC		= cl
LD		= link
AR		= lib
CFLAGS		= $(CFLAGS) /W2
BUILD_CFLAGS	= $(CFLAGS)
INTERNAL_CFLAGS = /I$(srcdir) /I. \
		  /I$(srcdir)/include /I./include \
		  /I$(srcdir)/x86 /I./x86 \
		  /I$(srcdir)/asm /I./asm \
		  /I$(srcdir)/disasm /I./disasm \
		  /I$(srcdir)/output /I./output \
ALL_CFLAGS	= $(BUILD_CFLAGS) $(INTERNAL_CFLAGS)
LDFLAGS		= $(LDFLAGS) /SUBSYSTEM:CONSOLE /RELEASE
LIBS		=
PERL		= perl -I$(srcdir)/perllib -I$(srcdir)

# Binary suffixes
O               = obj
A		= lib
X               = .exe

.SUFFIXES: .c .i .s .$(O) .$(A) .1 .man

.c.obj:
	$(CC) /c $(ALL_CFLAGS) /Fo$@ $<

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	asm/nasm.$(O)
NDISASM = disasm/ndisasm.$(O)

LIBOBJ = stdlib/snprintf.$(O) stdlib/vsnprintf.$(O) stdlib/strlcpy.$(O) \
	stdlib/strnlen.$(O) \
	nasmlib/ver.$(O) \
	nasmlib/crc64.$(O) nasmlib/malloc.$(O) \
	nasmlib/md5c.$(O) nasmlib/string.$(O) \
	nasmlib/file.$(O) nasmlib/mmap.$(O) nasmlib/ilog2.$(O) \
	nasmlib/realpath.$(O) nasmlib/filename.$(O) nasmlib/srcfile.$(O) \
	nasmlib/zerobuf.$(O) nasmlib/readnum.$(O) nasmlib/bsi.$(O) \
	nasmlib/rbtree.$(O) nasmlib/hashtbl.$(O) \
	nasmlib/raa.$(O) nasmlib/saa.$(O) \
	nasmlib/strlist.$(O) \
	nasmlib/perfhash.$(O) nasmlib/badenum.$(O) \
	common/common.$(O) \
	x86/insnsa.$(O) x86/insnsb.$(O) x86/insnsd.$(O) x86/insnsn.$(O) \
	x86/regs.$(O) x86/regvals.$(O) x86/regflags.$(O) x86/regdis.$(O) \
	x86/disp8.$(O) x86/iflag.$(O) \
	\
	asm/error.$(O) \
	asm/float.$(O) \
	asm/directiv.$(O) asm/directbl.$(O) \
	asm/pragma.$(O) \
	asm/assemble.$(O) asm/labels.$(O) asm/parser.$(O) \
	asm/preproc.$(O) asm/quote.$(O) asm/pptok.$(O) \
	asm/listing.$(O) asm/eval.$(O) asm/exprlib.$(O) asm/exprdump.$(O) \
	asm/stdscan.$(O) \
	asm/strfunc.$(O) asm/tokhash.$(O) \
	asm/segalloc.$(O) \
	asm/preproc-nop.$(O) \
	asm/rdstrnum.$(O) \
	\
	macros/macros.$(O) \
	\
	output/outform.$(O) output/outlib.$(O) output/legacy.$(O) \
	output/nulldbg.$(O) output/nullout.$(O) \
	output/outbin.$(O) output/outaout.$(O) output/outcoff.$(O) \
	output/outelf.$(O) \
	output/outobj.$(O) output/outas86.$(O) output/outrdf2.$(O) \
	output/outdbg.$(O) output/outieee.$(O) output/outmacho.$(O) \
	output/codeview.$(O) \
	\
	disasm/disasm.$(O) disasm/sync.$(O)

SUBDIRS  = stdlib nasmlib output asm disasm x86 common macros
XSUBDIRS = test doc nsis
#-- End File Lists --#

all: nasm$(X) ndisasm$(X)
	rem cd rdoff && $(MAKE) all

nasm$(X): $(NASM) nasm.$(A)
	$(LD) $(LDFLAGS) /OUT:nasm$(X) $(NASM) $(LIBS) nasm.$(A)

ndisasm$(X): $(NDISASM) nasm.$(A)
	$(LD) $(LDFLAGS) /OUT:ndisasm$(X) $(NDISASM) $(LIBS) nasm.$(A)

nasm.$(A): $(LIBOBJ)
	$(AR) $(ARFLAGS) /OUT:$@ $**

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
directbl.c: directiv.dat directiv.pl perllib/phash.ph
	$(PERL) $(srcdir)/directiv.pl c $(srcdir)/directiv.dat directbl.c

# This target generates all files that require perl.
# This allows easier generation of distribution (see dist target).
PERLREQ = macros.c insnsb.c insnsa.c insnsd.c insnsi.h insnsn.c \
	  regs.c regs.h regflags.c regdis.c regvals.c tokhash.c tokens.h \
	  version.h version.mac pptok.h pptok.c iflag.c iflaggen.h \
	  directbl.c directiv.h pptok.ph regdis.h
perlreq: $(PERLREQ)

clean:
	-del /f *.$(O)
	-del /f *.pdb
	-del /f *.s
	-del /f *.i
	-del /f lib\*.$(O)
	-del /f lib\*.pdb
	-del /f lib\*.s
	-del /f lib\*.i
	-del /f output\*.$(O)
	-del /f output\*.pdb
	-del /f output\*.s
	-del /f output\*.i
	-del /f nasmlib\*.$(O)
	-del /f nasmlib\*.pdb
	-del /f nasmlib\*.s
	-del /f nasmlib\*.i
	-del /f stdlib\*.$(O)
	-del /f stdlib\*.pdb
	-del /f stdlib\*.s
	-del /f stdlib\*.i
	-del /f nasm.$(A)
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
# @exclude: "config/config.h"
#-- Everything below is generated by mkdep.pl - do not edit --#
asm/assemble.$(O): asm/assemble.c asm/assemble.h asm/directiv.h \
 asm/listing.h asm/pptok.h asm/preproc.h asm/tokens.h config/msvc.h \
 config/unknown.h config/watcom.h include/compiler.h include/disp8.h \
 include/error.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/directbl.$(O): asm/directbl.c asm/directiv.h config/msvc.h \
 config/unknown.h config/watcom.h include/compiler.h include/nasmint.h \
 include/nasmlib.h include/perfhash.h
asm/directiv.$(O): asm/directiv.c asm/assemble.h asm/directiv.h asm/eval.h \
 asm/float.h asm/listing.h asm/pptok.h asm/preproc.h asm/stdscan.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/error.h include/iflag.h include/labels.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h output/outform.h x86/iflaggen.h \
 x86/insnsi.h x86/regs.h
asm/error.$(O): asm/error.c config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasmint.h include/nasmlib.h
asm/eval.$(O): asm/eval.c asm/assemble.h asm/directiv.h asm/eval.h \
 asm/float.h asm/pptok.h asm/preproc.h config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/iflag.h \
 include/labels.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/exprdump.$(O): asm/exprdump.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/insnsi.h \
 x86/regs.h
asm/exprlib.$(O): asm/exprlib.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/insnsi.h \
 x86/regs.h
asm/float.$(O): asm/float.c asm/directiv.h asm/float.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
asm/labels.$(O): asm/labels.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/error.h include/hashtbl.h include/labels.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/insnsi.h x86/regs.h
asm/listing.$(O): asm/listing.c asm/directiv.h asm/listing.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
asm/nasm.$(O): asm/nasm.c asm/assemble.h asm/directiv.h asm/eval.h \
 asm/float.h asm/listing.h asm/parser.h asm/pptok.h asm/preproc.h \
 asm/stdscan.h asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/iflag.h include/insns.h \
 include/labels.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/raa.h include/saa.h \
 include/strlist.h include/tables.h include/ver.h output/outform.h \
 x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/parser.$(O): asm/parser.c asm/assemble.h asm/directiv.h asm/eval.h \
 asm/float.h asm/parser.h asm/pptok.h asm/preproc.h asm/stdscan.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/iflag.h include/insns.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/iflaggen.h \
 x86/insnsi.h x86/regs.h
asm/pptok.$(O): asm/pptok.c asm/pptok.h asm/preproc.h config/msvc.h \
 config/unknown.h config/watcom.h include/compiler.h include/hashtbl.h \
 include/nasmint.h include/nasmlib.h
asm/pragma.$(O): asm/pragma.c asm/assemble.h asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/iflag.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/preproc-nop.$(O): asm/preproc-nop.c asm/directiv.h asm/listing.h \
 asm/pptok.h asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
asm/preproc.$(O): asm/preproc.c asm/directiv.h asm/eval.h asm/listing.h \
 asm/pptok.h asm/preproc.h asm/quote.h asm/stdscan.h asm/tokens.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/error.h include/hashtbl.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
asm/quote.$(O): asm/quote.c asm/quote.h config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
asm/rdstrnum.$(O): asm/rdstrnum.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/insnsi.h \
 x86/regs.h
asm/segalloc.$(O): asm/segalloc.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/stdscan.$(O): asm/stdscan.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/quote.h asm/stdscan.h asm/tokens.h config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/iflag.h \
 include/insns.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 x86/iflaggen.h x86/insnsi.h x86/regs.h
asm/strfunc.$(O): asm/strfunc.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/insnsi.h \
 x86/regs.h
asm/tokhash.$(O): asm/tokhash.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/stdscan.h asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/hashtbl.h include/iflag.h include/insns.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/iflaggen.h \
 x86/insnsi.h x86/regs.h
common/common.$(O): common/common.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
disasm/disasm.$(O): disasm/disasm.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h disasm/disasm.h \
 disasm/sync.h include/compiler.h include/disp8.h include/iflag.h \
 include/insns.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 x86/iflaggen.h x86/insnsi.h x86/regdis.h x86/regs.h
disasm/ndisasm.$(O): disasm/ndisasm.c asm/directiv.h asm/pptok.h \
 asm/preproc.h asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 disasm/disasm.h disasm/sync.h include/compiler.h include/error.h \
 include/iflag.h include/insns.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h include/ver.h x86/iflaggen.h x86/insnsi.h x86/regs.h
disasm/sync.$(O): disasm/sync.c config/msvc.h config/unknown.h \
 config/watcom.h disasm/sync.h include/compiler.h include/nasmint.h \
 include/nasmlib.h
macros/macros.$(O): macros/macros.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/hashtbl.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 output/outform.h x86/insnsi.h x86/regs.h
nasmlib/badenum.$(O): nasmlib/badenum.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
nasmlib/bsi.$(O): nasmlib/bsi.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
nasmlib/crc64.$(O): nasmlib/crc64.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/hashtbl.h include/nasmint.h \
 include/nasmlib.h
nasmlib/file.$(O): nasmlib/file.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/nasmint.h \
 include/nasmlib.h nasmlib/file.h
nasmlib/filename.$(O): nasmlib/filename.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/nasmint.h \
 include/nasmlib.h
nasmlib/hashtbl.$(O): nasmlib/hashtbl.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/hashtbl.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
nasmlib/ilog2.$(O): nasmlib/ilog2.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
nasmlib/malloc.$(O): nasmlib/malloc.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/nasmint.h \
 include/nasmlib.h
nasmlib/md5c.$(O): nasmlib/md5c.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/md5.h include/nasmint.h
nasmlib/mmap.$(O): nasmlib/mmap.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/nasmint.h \
 include/nasmlib.h nasmlib/file.h
nasmlib/perfhash.$(O): nasmlib/perfhash.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/hashtbl.h include/nasmint.h \
 include/nasmlib.h include/perfhash.h
nasmlib/raa.$(O): nasmlib/raa.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h \
 include/raa.h
nasmlib/rbtree.$(O): nasmlib/rbtree.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/rbtree.h
nasmlib/readnum.$(O): nasmlib/readnum.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h x86/insnsi.h x86/regs.h
nasmlib/realpath.$(O): nasmlib/realpath.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
nasmlib/saa.$(O): nasmlib/saa.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h \
 include/saa.h
nasmlib/srcfile.$(O): nasmlib/srcfile.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/hashtbl.h include/nasmint.h \
 include/nasmlib.h
nasmlib/string.$(O): nasmlib/string.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
nasmlib/strlist.$(O): nasmlib/strlist.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h \
 include/strlist.h
nasmlib/ver.$(O): nasmlib/ver.c include/ver.h version.h
nasmlib/zerobuf.$(O): nasmlib/zerobuf.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
output/codeview.$(O): output/codeview.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/hashtbl.h include/md5.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/saa.h include/strlist.h include/tables.h \
 output/outlib.h output/pecoff.h version.h x86/insnsi.h x86/regs.h
output/legacy.$(O): output/legacy.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/error.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 output/outlib.h x86/insnsi.h x86/regs.h
output/nulldbg.$(O): output/nulldbg.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h output/outlib.h x86/insnsi.h x86/regs.h
output/nullout.$(O): output/nullout.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h output/outlib.h x86/insnsi.h x86/regs.h
output/outaout.$(O): output/outaout.c asm/directiv.h asm/eval.h asm/pptok.h \
 asm/preproc.h asm/stdscan.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/raa.h \
 include/saa.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h x86/insnsi.h x86/regs.h
output/outas86.$(O): output/outas86.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/raa.h \
 include/saa.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h x86/insnsi.h x86/regs.h
output/outbin.$(O): output/outbin.c asm/directiv.h asm/eval.h asm/pptok.h \
 asm/preproc.h asm/stdscan.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/labels.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/saa.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h x86/insnsi.h x86/regs.h
output/outcoff.$(O): output/outcoff.c asm/directiv.h asm/eval.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/raa.h \
 include/saa.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h output/pecoff.h x86/insnsi.h x86/regs.h
output/outdbg.$(O): output/outdbg.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/iflag.h include/insns.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h x86/iflaggen.h x86/insnsi.h x86/regs.h
output/outelf.$(O): output/outelf.c asm/directiv.h asm/eval.h asm/pptok.h \
 asm/preproc.h asm/stdscan.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/raa.h \
 include/rbtree.h include/saa.h include/strlist.h include/tables.h \
 include/ver.h output/dwarf.h output/elf.h output/outelf.h output/outform.h \
 output/outlib.h output/stabs.h x86/insnsi.h x86/regs.h
output/outform.$(O): output/outform.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 output/outform.h x86/insnsi.h x86/regs.h
output/outieee.$(O): output/outieee.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h include/ver.h output/outform.h output/outlib.h \
 x86/insnsi.h x86/regs.h
output/outlib.$(O): output/outlib.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/error.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 output/outlib.h x86/insnsi.h x86/regs.h
output/outmacho.$(O): output/outmacho.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/labels.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/raa.h include/rbtree.h include/saa.h include/strlist.h \
 include/tables.h output/outform.h output/outlib.h x86/insnsi.h x86/regs.h
output/outobj.$(O): output/outobj.c asm/directiv.h asm/eval.h asm/pptok.h \
 asm/preproc.h asm/stdscan.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/strlist.h \
 include/tables.h include/ver.h output/outform.h output/outlib.h \
 x86/insnsi.h x86/regs.h
output/outrdf2.$(O): output/outrdf2.c asm/directiv.h asm/pptok.h \
 asm/preproc.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/error.h include/nasm.h include/nasmint.h \
 include/nasmlib.h include/opflags.h include/perfhash.h include/rdoff.h \
 include/saa.h include/strlist.h include/tables.h output/outform.h \
 output/outlib.h x86/insnsi.h x86/regs.h
stdlib/snprintf.$(O): stdlib/snprintf.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/nasmlib.h
stdlib/strlcpy.$(O): stdlib/strlcpy.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h
stdlib/strnlen.$(O): stdlib/strnlen.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h
stdlib/vsnprintf.$(O): stdlib/vsnprintf.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/error.h include/nasmint.h \
 include/nasmlib.h
x86/disp8.$(O): x86/disp8.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/disp8.h include/nasm.h include/nasmint.h include/nasmlib.h \
 include/opflags.h include/perfhash.h include/strlist.h include/tables.h \
 x86/insnsi.h x86/regs.h
x86/iflag.$(O): x86/iflag.c config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/nasmint.h x86/iflaggen.h
x86/insnsa.$(O): x86/insnsa.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
x86/insnsb.$(O): x86/insnsb.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
x86/insnsd.$(O): x86/insnsd.c asm/directiv.h asm/pptok.h asm/preproc.h \
 asm/tokens.h config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/iflag.h include/insns.h include/nasm.h \
 include/nasmint.h include/nasmlib.h include/opflags.h include/perfhash.h \
 include/strlist.h include/tables.h x86/iflaggen.h x86/insnsi.h x86/regs.h
x86/insnsn.$(O): x86/insnsn.c config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/nasmint.h include/tables.h x86/insnsi.h
x86/regdis.$(O): x86/regdis.c x86/regdis.h x86/regs.h
x86/regflags.$(O): x86/regflags.c asm/directiv.h asm/pptok.h asm/preproc.h \
 config/msvc.h config/unknown.h config/watcom.h include/compiler.h \
 include/nasm.h include/nasmint.h include/nasmlib.h include/opflags.h \
 include/perfhash.h include/strlist.h include/tables.h x86/insnsi.h \
 x86/regs.h
x86/regs.$(O): x86/regs.c config/msvc.h config/unknown.h config/watcom.h \
 include/compiler.h include/nasmint.h include/tables.h x86/insnsi.h
x86/regvals.$(O): x86/regvals.c config/msvc.h config/unknown.h \
 config/watcom.h include/compiler.h include/nasmint.h include/tables.h \
 x86/insnsi.h
