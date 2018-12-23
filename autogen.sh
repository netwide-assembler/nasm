#!/bin/sh -xe
#
# Run this script to regenerate autoconf files
#
recheck=false
if [ x"$1" = x--recheck ]; then
    recheck=true
    config=$(sh config.status --config 2>/dev/null)
fi

mkdir -p autoconf autoconf/aux config
autolib="`automake --print-libdir`"
for prg in install-sh compile config.guess config.sub; do
    cp -f "$autolib"/"$prg" autoconf/aux
done
rm -f autoconf/aclocal.m4
mkdir -p autoconf/m4.old autoconf/m4
mv -f autoconf/m4/*.m4 autoconf/m4.old/ 2>/dev/null || true
ACLOCAL_PATH="${ACLOCAL_PATH}${ACLOCAL_PATH:+:}`pwd`/autoconf/m4.old"
export ACLOCAL_PATH
aclocal --install --output=autoconf/aclocal.m4 -I autoconf/m4
test -f autoconf/aclocal.m4
rm -rf autoconf/m4.old
autoheader -B autoconf
autoconf -B autoconf
rm -rf autom4te.cache config.log config.status config/config.h Makefile

if $recheck; then
    # This bizarre statement has to do with how config.status quotes its output
    echo exec sh configure $config | sh -
fi
