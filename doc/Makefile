#
# Makefile for NASM documentation

SRCS	= nasmdoc.src
OUT	= nasm.info

all: $(OUT)

.SUFFIXES: .src .texi .info .ps .rtf .hpj .ps .txt .pl

# Consider html, txt and src output a side effect
.src.texi:
	-mkdir html
	perl ./rdsrc.pl < $<
	mv -f *.html html

nasm.info: nasmdoc.texi
	-mkdir info
	makeinfo $<
	mv -f *.info *.info-* info

clean:
	-rm -f *.rtf *.hpj *.texi

spotless: clean
	-rm -rf html info *.hlp *.txt *.ps


