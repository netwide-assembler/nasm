#!/usr/bin/perl -w
#
# macros.pl   produce macros.c from standard.mac
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.

# use strict; # if your PERL's got it

my $fname;
my $line = 0;
my $index = 0;

$fname = "standard.mac" unless $fname = $ARGV[0];
open INPUT,$fname || die "unable to open $fname\n";
open OUTPUT,">macros.c" || die "unable to open macros.c\n";

print OUTPUT "/* This file auto-generated from standard.mac by macros.pl" .
        " - don't edit it */\n\nstatic char *stdmac[] = {\n";

while (<INPUT>) {
	$line++;
	chomp;
	if (m/^\s*((\s*([^"';\s]+|"[^"]*"|'[^']*'))*)\s*(;.*)?$/) {
		$_ = $1;
    	s/\\/\\\\/g;
    	s/"/\\"/g;
		if (length > 0) {
			print OUTPUT "    \"$_\",\n";
			if ($index >= 0) {
				if (m/__NASM_MAJOR__/) {
					$index = -$index;
				} else {
					$index++;
				}
			}		
		} 
  	} else {
		die "$fname:$line:  error unterminated quote";
	}
}
$index = -$index;
print OUTPUT "    NULL\n};\n#define TASM_MACRO_COUNT $index\n"
