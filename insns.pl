#!/usr/bin/perl
#
# insns.pl   produce insnsa.c and insnsd.c from insns.dat
#
# The Netwide Assembler is copyright (C) 1996 Simon Tatham and
# Julian Hall. All rights reserved. The software is
# redistributable under the licence given in the file "Licence"
# distributed in the NASM archive.

print STDERR "Reading insns.dat...\n";

$fname = "insns.dat" unless $fname = $ARGV[0];
open (F, $fname) || die "unable to open $fname";

$line = 0;
$opcodes = 0;
$insns = 0;
while (<F>) {
  $line++;
  next if /^\s*;/;   # comments
  chomp;
  split;
  next if $#_ == -1; # blank lines
  (warn "line $line does not contain four fields\n"), next if $#_ != 3;
  ($formatted, $nd) = &format(@_);
  if ($formatted) {
    $insns++;
    $aname = "aa_$_[0]";
    push @$aname, $formatted;
  }
  $opcodes[$opcodes++] = $_[0], $done{$_[0]} = 1 if !$done{$_[0]};
  if ($formatted && !$nd) {
    push @big, $formatted;
    foreach $i (&startbyte($_[2])) {
      $aname = sprintf "dd_%02X",$i;
      push @$aname, $#big;
    }
  }
}

close F;

print STDERR "Writing insnsa.c...\n";

open A, ">insnsa.c";

print A "/* This file auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
print A "#include <stdio.h>\n";
print A "#include \"nasm.h\"\n";
print A "#include \"insns.h\"\n";
print A "\n";

foreach $i (@opcodes) {
  print A "static struct itemplate instrux_${i}[] = {\n";
  $aname = "aa_$i";
  foreach $j (@$aname) {
    print A "    $j\n";
  }
  print A "    {-1}\n};\n\n";
}
print A "struct itemplate *nasm_instructions[] = {\n";
foreach $i (@opcodes) {
  print A "    instrux_${i},\n";
}
print A "};\n";

close A;

print STDERR "Writing insnsd.c...\n";

open D, ">insnsd.c";

print D "/* This file auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
print D "#include <stdio.h>\n";
print D "#include \"nasm.h\"\n";
print D "#include \"insns.h\"\n";
print D "\n";

print D "static struct itemplate instrux[] = {\n";
foreach $j (@big) {
  print D "    $j\n";
}
print D "    {-1}\n};\n\n";

for ($c=0; $c<256; $c++) {
  $h = sprintf "%02X", $c;
  print D "static struct itemplate *itable_${h}[] = {\n";
  $aname = "dd_$h";
  foreach $j (@$aname) {
    print D "    instrux + $j,\n";
  }
  print D "    NULL\n};\n\n";
}

print D "struct itemplate **itable[] = {\n";
for ($c=0; $c<256; $c++) {
  printf D "    itable_%02X,\n", $c;
}
print D "};\n";

close D;

printf STDERR "Done: %d instructions\n", $insns;

sub format {
  local ($opcode, $operands, $codes, $flags) = @_;
  local $num, $nd = 0;

  return (undef, undef) if $operands eq "ignore";

  # format the operands
  $operands =~ s/:/|colon,/g;
  $operands =~ s/mem(\d+)/mem|bits$1/g;
  $operands =~ s/mem/memory/g;
  $operands =~ s/memory_offs/mem_offs/g;
  $operands =~ s/imm(\d+)/imm|bits$1/g;
  $operands =~ s/imm/immediate/g;
  $operands =~ s/rm(\d+)/regmem|bits$1/g;
  $num = 3;
  $operands = '0,0,0', $num = 0 if $operands eq 'void';
  $operands .= ',0', $num-- while $operands !~ /,.*,/;
  $operands =~ tr/a-z/A-Z/;

  # format the flags
  $flags =~ s/,/|IF_/g;
  $flags =~ s/(\|IF_ND|IF_ND\|)//, $nd = 1 if $flags =~ /IF_ND/;
  $flags = "IF_" . $flags;

  ("{I_$opcode, $num, {$operands}, \"$codes\", $flags},", $nd);
}

# Here we determine the range of possible starting bytes for a given
# instruction. We need only consider the codes:
# \1 \2 \3     mean literal bytes, of course
# \4 \5 \6 \7  mean PUSH/POP of segment registers: special case
# \10 \11 \12  mean byte plus register value
# \17          means byte zero
# \330         means byte plus condition code
# \0 or \340   mean give up and return empty set
sub startbyte {
  local ($codes) = @_;
  local $word, @range;

  while (1) {
    die "couldn't get code in '$codes'" if $codes !~ /^(\\[^\\]+)(\\.*)?$/;
    $word = $1, $codes = $2;
    return (hex $1) if $word =~ /^\\[123]$/ && $codes =~ /^\\x(..)/;
    return (0x07, 0x17, 0x1F) if $word eq "\\4";
    return (0xA1, 0xA9) if $word eq "\\5";
    return (0x06, 0x0E, 0x16, 0x1E) if $word eq "\\6";
    return (0xA0, 0xA8) if $word eq "\\7";
    $start=hex $1, $r=8, last if $word =~ /^\\1[012]$/ && $codes =~/^\\x(..)/;
    return (0) if $word eq "\\17";
    $start=hex $1, $r=16, last if $word =~ /^\\330$/ && $codes =~ /^\\x(..)/;
    return () if $word eq "\\0" || $word eq "\\340";
  }
  @range = ();
  push @range, $start++ while ($r-- > 0);
  @range;
}
