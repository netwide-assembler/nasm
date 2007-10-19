#!/usr/bin/perl
#
# insns.pl   produce insnsa.c, insnsd.c, insnsi.h, insnsn.c from insns.dat
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
	if  ( $arg =~ /^\-([adin])$/ ) {
	    $output = $1;
	} else {
	    die "$0: Unknown option: ${arg}\n";
	}
    } else {
	push (@args, $arg);
    }
}

$fname = "insns.dat" unless $fname = $args[0];
open (F, $fname) || die "unable to open $fname";

%dinstables = ();

$line = 0;
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
  if ( $_[0] =~ /cc$/ ) {
      # Conditional instruction
      $k_opcodes_cc{$_[0]}++;
  } else {
      # Unconditional instruction
      $k_opcodes{$_[0]}++;
  }
  if ($formatted && !$nd) {
    push @big, $formatted;
    foreach $i (startseq($_[2])) {
	if (!defined($dinstables{$i})) {
	    $dinstables{$i} = [];
	}
	push(@{$dinstables{$i}}, $#big);
    }
  }
}

close F;

@opcodes    = sort keys(%k_opcodes);
@opcodes_cc = sort keys(%k_opcodes_cc);

if ( !defined($output) || $output eq 'a' ) {
    print STDERR "Writing insnsa.c...\n";

    open A, ">insnsa.c";

    print A "/* This file auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
    print A "#include \"nasm.h\"\n";
    print A "#include \"insns.h\"\n";
    print A "\n";

    foreach $i (@opcodes, @opcodes_cc) {
	print A "static const struct itemplate instrux_${i}[] = {\n";
	$aname = "aa_$i";
	foreach $j (@$aname) {
	    print A "    $j\n";
	}
	print A "    ITEMPLATE_END\n};\n\n";
    }
    print A "const struct itemplate * const nasm_instructions[] = {\n";
    foreach $i (@opcodes, @opcodes_cc) {
	print A "    instrux_${i},\n";
    }
    print A "};\n";

    close A;
}

if ( !defined($output) || $output eq 'd' ) {
    print STDERR "Writing insnsd.c...\n";

    open D, ">insnsd.c";

    print D "/* This file auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
    print D "#include \"nasm.h\"\n";
    print D "#include \"insns.h\"\n";
    print D "\n";

    print D "static const struct itemplate instrux[] = {\n";
    $n = 0;
    foreach $j (@big) {
	printf D "    /* %4d */ %s\n", $n++, $j;
    }
    print D "};\n";

    foreach $h (sort(keys(%dinstables))) {
	print D "\nstatic const struct itemplate * const itable_${h}[] = {\n";
	foreach $j (@{$dinstables{$h}}) {
	    print D "    instrux + $j,\n";
	}
	print D "};\n";
    }

    foreach $h (@disasm_prefixes, '') {
	$is_prefix{$h} = 1;
	print D "\n";
	print D "static " unless ($h eq '');
	print D "const struct disasm_index ";
	print D ($h eq '') ? 'itable' : "itable_$h";
	print D "[256] = {\n";
	for ($c = 0; $c < 256; $c++) {
	    $nn = sprintf("%s%02X", $h, $c);
	    if ($is_prefix{$nn}) {
		die "$0: ambiguous decoding of $nn\n"
		    if (defined($dinstables{$nn}));
		printf D "    { itable_%s, -1 },\n", $nn;
	    } elsif (defined($dinstables{$nn})) {
		printf D "    { itable_%s, %u },\n",
		$nn, scalar(@{$dinstables{$nn}});
	    } else {
		printf D "    { NULL, 0 },\n";
	    }
	}
    print D "};\n";
    }

    close D;
}

if ( !defined($output) || $output eq 'i' ) {
    print STDERR "Writing insnsi.h...\n";

    open I, ">insnsi.h";

    print I "/* This file is auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
    print I "/* This file in included by nasm.h */\n\n";

    print I "/* Instruction names */\n\n";
    print I "#ifndef NASM_INSNSI_H\n";
    print I "#define NASM_INSNSI_H 1\n\n";
    print I "enum opcode {\n";
    $maxlen = 0;
    foreach $i (@opcodes, @opcodes_cc) {
	print I "\tI_${i},\n";
	$len = length($i);
	$len++ if ( $i =~ /cc$/ );	# Condition codes can be 3 characters long
	$maxlen = $len if ( $len > $maxlen );
    }
    print I "\tI_none = -1\n";
    print I "\n};\n\n";
    print I "#define MAX_INSLEN ", $maxlen, "\n\n";
    print I "#endif /* NASM_INSNSI_H */\n";

    close I;
}

if ( !defined($output) || $output eq 'n' ) {
    print STDERR "Writing insnsn.c...\n";

    open N, ">insnsn.c";

    print N "/* This file is auto-generated from insns.dat by insns.pl" .
        " - don't edit it */\n\n";
    print N "/* This file in included by names.c */\n\n";

    print N "static const char * const insn_names[] = {";
    $first = 1;
    foreach $i (@opcodes) {
	print N "," if ( !$first );
	$first = 0;
	$ilower = $i;
	$ilower =~ tr/A-Z/a-z/;	# Change to lower case (Perl 4 compatible)
	print N "\n\t\"${ilower}\"";
    }
    print N "\n};\n\n";
    print N "/* Conditional instructions */\n";
    print N "static const char *icn[] = {";
    $first = 1;
    foreach $i (@opcodes_cc) {
	print N "," if ( !$first );
	$first = 0;
	$ilower = $i;
	$ilower =~ s/cc$//;		# Skip cc suffix
	$ilower =~ tr/A-Z/a-z/;	# Change to lower case (Perl 4 compatible)
	print N "\n\t\"${ilower}\"";
    }

    print N "\n};\n\n";
    print N "/* and the corresponding opcodes */\n";
    print N "static const enum opcode ico[] = {";
    $first = 1;
    foreach $i (@opcodes_cc) {
	print N "," if ( !$first );
	$first = 0;
	print N "\n\tI_$i";
    }

    print N "\n};\n";

    close N;
}

printf STDERR "Done: %d instructions\n", $insns;

sub format {
    my ($opcode, $operands, $codes, $flags) = @_;
    my $num, $nd = 0;

    return (undef, undef) if $operands eq "ignore";

    # format the operands
    $operands =~ s/:/|colon,/g;
    $operands =~ s/mem(\d+)/mem|bits$1/g;
    $operands =~ s/mem/memory/g;
    $operands =~ s/memory_offs/mem_offs/g;
    $operands =~ s/imm(\d+)/imm|bits$1/g;
    $operands =~ s/imm/immediate/g;
    $operands =~ s/rm(\d+)/rm_gpr|bits$1/g;
    $operands =~ s/mmxrm/rm_mmx/g;
    $operands =~ s/xmmrm/rm_xmm/g;
    $operands =~ s/\=([0-9]+)/same_as|$1/g;
    if ($operands eq 'void') {
	@ops = ();
    } else {
	@ops = split(/\,/, $operands);
    }
    $num = scalar(@ops);
    while (scalar(@ops) < 4) {
	push(@ops, '0');
    }
    $operands = join(',', @ops);
    $operands =~ tr/a-z/A-Z/;

    # format the flags
    $flags =~ s/,/|IF_/g;
    $flags =~ s/(\|IF_ND|IF_ND\|)//, $nd = 1 if $flags =~ /IF_ND/;
    $flags = "IF_" . $flags;

    ("{I_$opcode, $num, {$operands}, \"$codes\", $flags},", $nd);
}

sub hexlist($$$) {
    my($prefix, $start, $n) = @_;
    my $i;
    my @l = ();

    for ($i = 0; $i < $n; $i++) {
	push(@l, sprintf("%s%02X", $prefix, $start+$i));
    }
    return @l;
}

# Here we determine the range of possible starting bytes for a given
# instruction. We need only consider the codes:
# \1 \2 \3     mean literal bytes, of course
# \4 \5 \6 \7  mean PUSH/POP of segment registers: special case
# \1[0123]     mean byte plus register value
# \170         means byte zero
# \330         means byte plus condition code
# \0 or \340   mean give up and return empty set
sub startseq($) {
  my ($codestr) = @_;
  my $word, @range;
  my @codes = ();
  my $c = $codestr;
  my $c0, $c1, $i;
  my $prefix = '';

  # Although these are C-syntax strings, by convention they should have
  # only octal escapes (for directives) and hexadecimal escapes
  # (for verbatim bytes)
  while ($c ne '') {
      if ($c =~ /^\\x([0-9a-f]+)(.*)$/i) {
	  push(@codes, hex $1);
	  $c = $2;
	  next;
      } elsif ($c =~ /^\\([0-7]{1,3})(.*)$/) {
	  push(@codes, oct $1);
	  $c = $2;
	  next;
      } else {
	  die "$0: unknown code format in \"$codestr\"\n";
      }
  }

  while ($c0 = shift(@codes)) {
      $c1 = $codes[0];
      if ($c0 == 01 || $c0 == 02 || $c0 == 03 || $c0 == 0170) {
	  # Fixed byte string
	  my $fbs = $prefix;
	  while (1) {
	      if ($c0 == 01 || $c0 == 02 || $c0 == 03) {
		  while ($c0--) {
		      $fbs .= sprintf("%02X", shift(@codes));
		  }
	      } elsif ($c0 == 0170) {
		  $fbs .= '00';
	      } else {
		  last;
	      }
	      $c0 = shift(@codes);
	  }

	  foreach $pfx (@disasm_prefixes) {
	      if ($fbs =~ /^$pfx(.*)$/) {
		  $prefix = $pfx;
		  $fbs = $1;
		  last;
	      }
	  }

	  if ($fbs ne '') {
	      return ($prefix.substr($fbs,0,2));
	  }
      } elsif ($c0 == 04) {
	  return ("07", "17", "1F");
      } elsif ($c0 == 05) {
	  return ("A1", "A9");
      } elsif ($c0 == 06) {
	  return ("06", "0E", "16", "1E");
      } elsif ($c0 == 07) {
	  return ("A0", "A8");
      } elsif ($c0 >= 010 && $c0 <= 013) {
	  return hexlist($prefix, $c1, 8);
      } elsif ($c0 == 0330) {
	  return hexlist($prefix, $c1, 16);
      } elsif ($c0 == 0 || $c0 == 0340) {
	  return ();
      }
  }
  return ();
}
