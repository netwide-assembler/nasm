#!/usr/bin/perl
#
# version.pl
# $Id$
#
# Parse the NASM version file and produce appropriate macros
#
# The NASM version number is assumed to consist of:
#
# <major>.<minor>[.<subminor>]<tail>
#
# ... where <tail> is not necessarily numeric.
#
# This defines the following macros:
#
# version.h:
# NASM_MAJOR_VER
# NASM_MINOR_VER
# NASM_SUBMINOR_VER	-- this is zero if no subminor
# NASM_VER		-- whole version number as a string
#
# version.mac:
# __NASM_MAJOR__
# __NASM_MINOR__
# __NASM_SUBMINOR__
# __NASM_VER__
#

($what) = @ARGV;

$line = <STDIN>;
chomp $line;

if ( $line =~ /^([0-9]+)\.([0-9]+)\.([0-9]+)/ ) {
    $maj  = $1;  $nmaj  = $maj+0;
    $min  = $2;  $nmin  = $min+0;
    $smin = $3;  $nsmin = $smin+0;
    $tail = $';
} elsif ( $line =~ /^([0-9]+)\.([0-9]+)/ ) {
    $maj  = $1;  $nmaj  = $maj+0;
    $min  = $2;  $nmin  = $min+0;
    $smin = '';  $nsmin = 0;
    $tail = $';
} else {
    die "$0: Invalid input format\n";
}

if ( $what eq 'h' ) {
    print  "#ifndef NASM_VERSION_H\n";
    print  "#define NASM_VERSION_H\n";
    printf "#define NASM_MAJOR_VER    %d\n", $nmaj;
    printf "#define NASM_MINOR_VER    %d\n", $nmin;
    printf "#define NASM_SUBMINOR_VER %d\n", $nsmin;
    printf "#define NASM_VER          \"%s\"\n", $line;
    print  "#endif /* NASM_VERSION_H */\n";
} elsif ( $what eq 'mac' ) {
    printf "%%define __NASM_MAJOR__ %d\n", $nmaj;
    printf "%%define __NASM_MINOR__ %d\n", $nmin;
    printf "%%define __NASM_SUBMINOR__ %d\n", $nsmin;
    printf "%%define __NASM_VER__ \"%s\"\n", $line;
} else {
    die "$0: Unknown output: $what\n";
}

exit 0;


