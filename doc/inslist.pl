#!/usr/bin/perl
#
# inslist.pl   produce inslist.src
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.

# Opcode prefixes which need their own opcode tables
# LONGER PREFIXES FIRST!
@disasm_prefixes = qw(0F24 0F25 0F38 0F3A 0F7A 0FA6 0FA7 0F);

print STDERR "Reading insns.dat...\n";

@args   = ();
undef $output;
foreach $arg ( @ARGV ) {
    if ( $arg =~ /^\-/ ) {
	if  ( $arg =~ /^\-([adins])$/ ) {
	    $output = $1;
	} else {
	    die "$0: Unknown option: ${arg}\n";
	}
    } else {
	push (@args, $arg);
    }
}

$fname = "../insns.dat" unless $fname = $args[0];
open (F, $fname) || die "unable to open $fname";
print STDERR "Writing inslist.src...\n";
open S, ">inslist.src";
$line = 0;
$insns = 0;
while (<F>) {
  $line++;
  if ( /^\s*;/ )  # comments
  {
    if ( /^\s*;\#\s*(.+)/ )  # section subheader
    {
      print S "\n\\S{} $1\n\n";
    }
    next;
  }
  chomp;
  my @entry = split;
  next if $#entry == -1; # blank lines
  (warn "line $line does not contain four fields\n"), next if $#entry != 3;

  @entry[1] =~ s/ignore//;
  @entry[1] =~ s/void//;
  @entry[3] =~ s/ignore//;
  @entry[3] =~ s/,SB//;
  @entry[3] =~ s/,SM//;
  @entry[3] =~ s/,SM2//;
  @entry[3] =~ s/,SQ//;
  @entry[3] =~ s/,AR2//;
  printf S "\\c %-16s %-24s %s\n",@entry[0],@entry[1],@entry[3];
  $insns++;
}
print S "\n";
close S;
close F;
printf STDERR "Done: %d instructions\n", $insns;

