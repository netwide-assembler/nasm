#!/usr/bin/perl
#
# macros.pl   produce macros.c from standard.mac
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.

$fname = "standard.mac" unless $fname = $ARGV[0];
open INPUT,$fname || die "unable to open $fname\n";
open OUTPUT,">macros.c" || die "unable to open macros.c\n";

print OUTPUT "/* This file auto-generated from standard.mac by macros.pl" .
        " - don't edit it */\n\nstatic char *stdmac[] = {\n";

while (<INPUT>) {
  chomp;
  # this regexp ought to match anything at all, so why bother with
  # a sensible error message ;-)
  die "swirly thing alert" unless /^\s*((\s*([^"';\s]+|"[^"]*"|'[^']*'))*)/;
  $_ = $1;
  s/\\/\\\\/g;
  s/"/\\"/g;
  print OUTPUT "    \"$_\",\n" if length > 0;
}

print OUTPUT "    NULL\n};\n"
