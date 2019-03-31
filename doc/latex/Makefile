.PHONY: all .FORCE
.DEFAULT_GOAL := all

ifeq ($(strip $(V)),)
        E := @echo
        Q := @
else
        E := @\#
        Q :=
endif

export E Q

define msg-gen
        $(E) "  GEN     " $(1)
endef

define msg-clean
        $(E) "  CLEAN   " $(1)
endef

RM		?= rm -f
XELATEX		?= xelatex
XELATEX-OPTS	?= -output-driver="xdvipdfmx -V 3" -8bit

tex-d		+= src/16bit.tex
tex-d		+= src/32bit.tex
tex-d		+= src/64bit.tex
tex-d		+= src/changelog.tex
tex-d		+= src/contact.tex
tex-d		+= src/directive.tex
tex-d		+= src/idxconf.ist
tex-d		+= src/inslist.tex
tex-d		+= src/intro.tex
tex-d		+= src/language.tex
tex-d		+= src/macropkg.tex
tex-d		+= src/mixsize.tex
tex-d		+= src/nasmlogo.eps
tex-d		+= src/ndisasm.tex
tex-d		+= src/outfmt.tex
tex-d		+= src/preproc.tex
tex-d		+= src/running.tex
tex-d		+= src/source.tex
tex-d		+= src/trouble.tex
tex-d		+= src/version.tex
tex-y		+= src/nasm.tex

$(tex-y): $(tex-d)
	@true

nasm.pdf: $(tex-y) .FORCE
	$(call msg-gen,$@)
	$(Q) $(XELATEX) $(XELATEX-OPTS) $^
	$(Q) $(XELATEX) $(XELATEX-OPTS) $^
all-y += nasm.pdf

# Default target
all: $(all-y)

clean:
	$(call msg-clean,nasm)
	$(Q) $(RM) ./nasm.aux ./nasm.idx ./nasm.ilg ./nasm.ind ./nasm.log
	$(Q) $(RM) ./nasm.out ./nasm.pdf ./nasm.toc

# Disable implicit rules in _this_ Makefile.
.SUFFIXES:
