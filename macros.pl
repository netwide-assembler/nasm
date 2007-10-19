#!/usr/bin/perl -w
#
# macros.pl   produce macros.c from standard.mac
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.

use strict;

my $fname;
my $line = 0;
my $index      = 0;
my $tasm_count;

undef $tasm_count;

open(OUTPUT,">macros.c") or die "unable to open macros.c\n";

print OUTPUT "/* This file auto-generated from standard.mac by macros.pl" .
" - don't edit it */\n\n#include \"compiler.h\"\n\nstatic const char *stdmac[] = {\n";

foreach $fname ( @ARGV ) {
    open(INPUT,$fname) or die "unable to open $fname\n";
    while (<INPUT>) {
	$line++;
	chomp;
	if (m/^\s*\*END\*TASM\*MACROS\*\s*$/) {
	    $tasm_count = $index;
	} elsif (m/^\s*((\s*([^\"\';\s]+|\"[^\"]*\"|\'[^\']*\'))*)\s*(;.*)?$/) {
	    $_ = $1;
	    s/\\/\\\\/g;
	    s/"/\\"/g;
	    if (length > 0) {
		print OUTPUT "    \"$_\",\n";
		$index++;
	    }
	} else {
	    die "$fname:$line:  error unterminated quote";
	}
    }
    close(INPUT);
}
print OUTPUT "    NULL\n};\n";
$tasm_count = $index unless ( defined($tasm_count) );
print OUTPUT "#define TASM_MACRO_COUNT $tasm_count\n";
close(OUTPUT);
