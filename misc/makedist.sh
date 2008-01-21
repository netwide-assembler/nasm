#!/bin/sh
# * THIS SCRIPT IS OBSOLETE DO NOT USE *
 
MAJORVER=`grep NASM_MAJOR_VER nasm.h | head -1 | cut -f3 -d' '`
MINORVER=`grep NASM_MINOR_VER nasm.h | head -1 | cut -f3 -d' '`
VERSION=`grep NASM_VER nasm.h | head -1 | cut -f3 -d' ' | sed s/\"//g`
DOSVERSION="${MAJORVER}${MINORVER}"
NASM_TAR_GZ=dist/nasm-${VERSION}.tar.gz
NASM_ZIP=dist/nasm${DOSVERSION}s.zip
NASM_DOS_ZIP=dist/nasm${DOSVERSION}.zip
NASM_DOC_ZIP=dist/nasm${DOSVERSION}d.zip

if [ -d dist ]; then rm -rf dist; fi
if [ -d nasm-${VERSION} ]; then rm -rf nasm-${VERSION}; fi
if [ ! -d dist ]; then mkdir dist; fi
if [ -f dist/nasm.tar.gz ]; then rm dist/nasm.tar.gz; fi
mkdir nasm-${VERSION}
(cd nasm-${VERSION}; ln -s ../* .;
 rm -f nasm-${VERSION} dist Checklist GNUmakefile)
find nasm-${VERSION}/ -follow -name GNUmakefile > tar-exclude
find nasm-${VERSION}/ -follow -name RCS >> tar-exclude
find nasm-${VERSION}/ -follow -name '*.exe' >> tar-exclude
find nasm-${VERSION}/ -follow -name '*.uu' >> tar-exclude
find nasm-${VERSION}/ -follow -name '*,v' >> tar-exclude
for i in nasm-${VERSION}/doc/{nasmdoc.hpj,nasmdoc.rtf,nasmdoc.texi,Readme};
  do echo $i; done >> tar-exclude
tar chvfX dist/nasm-${VERSION}.tar tar-exclude nasm-${VERSION}
rm -f tar-exclude
tar tf dist/nasm-${VERSION}.tar | (echo nasm.doc; sed \
  -e 's:^nasm-[^/]*/::' \
  -e 's:/$::' \
  -e '/install-sh/d' \
  -e '/makedist\.sh/d' \
  -e '/exasm\.zip/d' \
  -e '/config/d' \
  -e '/doc\/.*\.html/d' \
  -e '/doc\/Readme/d' \
  -e '/doc\/nasmdoc\.ps/d' \
  -e '/doc\/nasmdoc\.txt/d' \
  -e '/doc\/nasmdoc\.rtf/d' \
  -e '/doc\/nasmdoc\.hpj/d' \
  -e '/doc\/nasmdoc\.texi/d' \
  -e '/doc\/nasmdoc\.hlp/d' \
  -e '/doc\/nasm\.info/d' \
  ) | sort > zipfiles
sed \
  -e '/^[^\/]*\.\(c\|h\|pl\|bas\|dat\)$/d' \
  -e '/^doc\(\/.*\)\?/d' \
  -e '/standard\.mac/d' \
  -e '/Makefile/d' \
  -e '/rdoff/d' \
  < zipfiles > zipfiles.dos
gzip -9 dist/nasm-${VERSION}.tar
rm -rf nasm-${VERSION}
ln -s doc/nasmdoc.src nasm.doc
zip -l -k ${NASM_ZIP} `cat zipfiles`
zip -k ${NASM_ZIP} *.exe misc/exasm.zip
zip -l -k ${NASM_DOS_ZIP} `cat zipfiles.dos`
zip -k ${NASM_DOS_ZIP} *.exe misc/exasm.zip
rm -f nasm.doc
(cd doc; zip -l -k ../${NASM_DOC_ZIP} \
  Readme \
  nasmdoc.src rdsrc.pl inslist.pl \
  nasmdoc.txt \
  nasmdoc.ps \
  *.html
 zip -k ../${NASM_DOC_ZIP} \
  nasmdoc.hlp \
  nasm.info)
rm -f zipfiles zipfiles.dos
echo Distributions complete.
