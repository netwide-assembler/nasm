Summary: The Netwide Assembler, a portable x86 assembler with Intel-like syntax
Name: nasm
Version: 0.98
Release: 1
Copyright: Freely Distributable
Group: Development/Languages
Source: ftp://ftp.us.kernel.org/pub/software/devel/nasm/source/nasm-%{version}.tar.gz
URL: http://www.cryogen.com/Nasm/
BuildRoot: /tmp/rpm-build-nasm
Prefix: /usr

%package doc
Summary: Extensive documentation for NASM
Group: Development/Languages
Prereq: /sbin/install-info

%package rdoff
Summary: Tools for the RDOFF binary format, sometimes used with NASM.
Group: Development/Tools

%description
NASM is the Netwide Assembler, a free portable assembler for the Intel
80x86 microprocessor series, using primarily the traditional Intel
instruction mnemonics and syntax.

%description doc
Extensive documentation for the Netwide Assembler, NASM, in HTML,
info, PostScript and text formats.

%description rdoff
Tools for the operating-system independent RDOFF binary format, which
is sometimes used with the Netwide Assembler (NASM).  These tools
include linker, library manager, loader, and information dump.

%prep
%setup

%build
CFLAGS="$RPM_OPT_FLAGS" LDFLAGS=-s ./configure --prefix=/usr
make everything

%install
mkdir -p "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT"/usr/bin
mkdir -p "$RPM_BUILD_ROOT"/usr/man/man1
mkdir -p "$RPM_BUILD_ROOT"/usr/info
DOC="$RPM_BUILD_ROOT"/usr/doc/nasm-%{version}
rm -rf "$DOC"
mkdir -p "$DOC"
mkdir -p "$DOC"/rdoff
rm -f "$RPM_BUILD_ROOT"/usr/info/nasm.*
make INSTALLROOT="$RPM_BUILD_ROOT" docdir=/usr/doc/nasm-%{version} install_everything
gzip -9 "$RPM_BUILD_ROOT"/usr/info/nasm.*
gzip -9 "$DOC"/*.txt "$DOC"/*.ps
cp Changes Licence MODIFIED Readme Wishlist *.doc changed.asm "$DOC"
cp rdoff/README rdoff/Changes "$DOC"/rdoff

%clean
rm -rf "$RPM_BUILD_ROOT"

%post doc
/sbin/install-info "$RPM_INSTALL_PREFIX"/info/nasm.info.gz "$RPM_INSTALL_PREFIX"/info/dir

%preun doc
if [ $1 = 0 ]; then
  /sbin/install-info --delete "$RPM_INSTALL_PREFIX"/info/nasm.info.gz "$RPM_INSTALL_PREFIX"/info/dir
fi

%files
%attr(-,root,root)	/usr/bin/nasm
%attr(-,root,root)	/usr/bin/ndisasm
%attr(-,root,root) %doc /usr/man/man1/nasm.1
%attr(-,root,root) %doc /usr/man/man1/ndisasm.1
%attr(-,root,root) %doc /usr/doc/nasm-%{version}/Licence

%files doc
%attr(-,root,root) %doc /usr/info/nasm.info*.gz
%attr(-,root,root) %doc /usr/doc/nasm-%{version}/*

%files rdoff
%attr(-,root,root)	/usr/bin/ldrdf
%attr(-,root,root)	/usr/bin/rdf2bin
%attr(-,root,root)	/usr/bin/rdf2com
%attr(-,root,root)	/usr/bin/rdfdump
%attr(-,root,root)	/usr/bin/rdflib
%attr(-,root,root)	/usr/bin/rdx
%attr(-,root,root) %doc	/usr/doc/nasm-%{version}/rdoff/*
