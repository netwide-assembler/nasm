#!/usr/bin/perl
#
# Preprocess the instruction pattern file.
#
# Generate some common repeated patterns here.
#
# Tag instructions which set the flags, and tag instructions
# which already do upper-zeroing.
#
# This can also be used to create other implied flags.
#

use integer;
use strict;

# Common patterns for the basic 8 arithmetric functions
sub mac_arith {
    my @l;
    my $cnt = 0;
    foreach my $op (@_) {
	my $o0 = sprintf("%02x", ($cnt << 3)+0);
	my $o1 = sprintf("%02x", ($cnt << 3)+1);
	my $o2 = sprintf("%02x", ($cnt << 3)+2);
	my $o3 = sprintf("%02x", ($cnt << 3)+3);
	my $o4 = sprintf("%02x", ($cnt << 3)+4);
	my $o5 = sprintf("%02x", ($cnt << 3)+5);
	my($hle,$lock,$zu) = ($op ne 'CMP') ? ('hle','LOCK','ZU') : ('','','');

	push(@l, <<EOL);
$op		rm8,reg8			[mr:	$hle $o0 /r]				8086,SM,$lock
$op		rm16,reg16			[mr:	$hle o16 $o1 /r]			8086,SM,$lock
$op		rm32,reg32			[mr:	$hle o32 $o1 /r]			386,SM,$lock,$zu
$op		rm64,reg64			[mr:	$hle o64 $o1 /r]			X86_64,LONG,SM,$lock,$zu
$op		reg8,rm8			[rm:	$o2 /r]					8086,SM
$op		reg16,rm16			[rm:	o16 $o3 /r]				8086,SM
$op		reg32,rm32			[rm:	o32 $o3 /r]				386,SM,$zu
$op		reg64,rm64			[rm:	o64 $o3 /r]				X86_64,LONG,SM,$zu
$op		reg_al,imm8			[-i:	$o4 ib]					8086,SM
$op		rm8,imm8			[mi:	$hle 80 /$cnt ib]			8086,SM,$lock
$op		rm16,sbyteword16		[mi:	$hle o16 83 /$cnt ib,s]			8086,SM,$lock
$op		reg_ax,imm16			[-i:	o16 $o5 iw]				8086,SM
$op		rm16,imm16			[mi:	$hle o16 81 /$cnt iw]			8086,SM,$lock
$op		rm32,sbytedword32		[mi:	$hle o32 83 /$cnt ib,s]			386,SM,$lock,$zu
$op		reg_eax,imm32			[-i:	o32 $o5 id]				386,SM,$zu
$op		rm32,imm32			[mi:	$hle o32 81 /$cnt id]			386,SM,$lock,$zu
$op		rm64,sbytedword64		[mi:	$hle o64 83 /$cnt ib,s]			X86_64,LONG,SM,$lock,$zu
$op		reg_rax,sdword64		[-i:	o64 $o5 id,s]				X86_64,LONG,SM,$zu
$op		rm64,sdword64			[mi:	$hle o64 81 /$cnt id,s]			X86_64,LONG,SM,$lock,$zu
$op		reg8?,reg8,rm8			[vrm:	evex.ndx.nf.l0.m4.o8     $o2 /r		]	APX,SM
$op		reg16?,reg16,rm16		[vrm:	evex.ndx.nf.l0.m4.o16    $o3 /r		]	APX,SM
$op		reg32?,reg32,rm32		[vrm:	evex.ndx.nf.l0.m4.o32    $o3 /r		]	APX,SM
$op		reg64?,reg64,rm64		[vrm:	evex.ndx.nf.l0.m4.o64    $o3 /r		]	APX,SM
$op		reg8?,rm8,reg8			[vmr:	evex.ndx.nf.l0.m4.o8     $o0 /r		]	APX,SM
$op		reg16?,rm16,reg16		[vmr:	evex.ndx.nf.l0.m4.o16    $o1 /r		]	APX,SM
$op		reg32?,rm32,reg32		[vmr:	evex.ndx.nf.l0.m4.o32    $o1 /r		]	APX,SM,$zu
$op		reg64?,rm64,reg64		[vmr:	evex.ndx.nf.l0.m4.o64    $o1 /r		]	APX,SM,$zu
$op		reg8?,rm8,imm8			[vmi:	evex.ndx.nf.l0.m4.o8     80 /$cnt ib	]	APX,SM
$op		reg16?,rm16,sbyteword16		[vmi:	evex.ndx.nf.l0.m4.o16    83 /$cnt ib,s	]	APX,SM,ND
$op		reg16?,rm16,imm16		[vmi:	evex.ndx.nf.l0.m4.o16    81 /$cnt iw	]	APX,SM
$op		reg32?,rm32,sbytedword32	[vmi:	evex.ndx.nf.l0.m4.o32    83 /$cnt ib,s	]	APX,SM,ND
$op		reg32?,rm32,imm32		[vmi:	evex.ndx.nf.l0.m4.o32    81 /$cnt id	]	APX,SM
$op		reg64?,rm64,sbytedword32	[vmi:	evex.ndx.nf.l0.m4.o64    83 /$cnt ib,s	]	APX,SM,ND
$op		reg64?,rm64,sdword64		[vmi:	evex.ndx.nf.l0.m4.o64    81 /$cnt id,s	]	APX,SM

EOL
	$cnt++;
    }

    return @l;
}

my %macros = ( 'arith' => *mac_arith );

my($infile, $outfile) = @ARGV;
my $line = 0;

sub process_macro(@) {
    my $macro = shift(@_);
    my $mfunc = $macros{$macro};

    if (!defined($mfunc)) {
	die "$0:$infile:$line: no macro named \$$macro\n";
    }

    return map { split(/\n/, $_) } $mfunc->(@_);
}

## XXX: fix special case: XCHG
## XXX: check: CMPSS, CMPSD
## XXX: check VEX encoded instructions that do not write

# Instructions which (possibly) change the flags
my $flaggy = '^(aa[adms]|ad[dc]|ad[co]x|aes\w*kl|and|andn|arpl|bextr|bl[sc]ic?|bl[sc]msk|bl[sc]r|\
bs[rf]|bt|bt[crs]|bzhi|clac|clc|cld|cli|clrssbsy|cmc|cmp|cmpxchg.*|da[as]|dec|div|\
encodekey.*|enqcmd.*|fu?comip?|idiv|imul|inc|iret.*|kortest.*|ktest.*|lar|loadiwkey|\
lsl|[lt]zcnt|mul|neg|or|pconfig|popcnt|popf.*|r[co][lr]|rdrand|rdseed|sahf|s[ah][lr]|\
sbb|scas.*|sh[lr]d|stac|stc|std|sti|sub|test|testui|tpause|v?u?comis[sdh]|uiret|\
umwait|ver[rw]|vtestp[ps]|xadd|xor|xtest|getsec|rsm|sbb|cmps[bwdq]|hint_.*)$';

# Instructions which don't write their leftmost operand are inherently not {zu}
my $nozero = '^(jmp|call|bt|test|cmp|ud[012].*|ptwrite|tpause|u?monitor.*|u?mwait.*|incssp.*|\
enqcmds?|senduipi|hint_.*|jmpe|nop|inv.*|push2?p?|vmwrite|clzero|clflush|clwb|lkgs)$';

sub adjust_instruction_flags(@) {
    my($opcode, $operands, $encoding, $flags) = @_;

    # Flag-changing instructions
    if ($flags !~ /\b(FL|NF)\b/ && $opcode =~ /$flaggy/io) {
	$flags .= ',FL';
    }

    ## XXX: fix special case: XCHG
    ## XXX: check: CMPSS, CMPSD
    ## XXX: check VEX encoded instructions that do not write

    # Zero-upper. This can also be used to select the AVX forms
    # to clear the upper part of a vector register.
    if ($flags !~ /\bZU\b/ &&
	(($encoding =~ /\bE?VEXb/ && $operands =~ /^(xyz)mm(reg|rm)/) ||
	 $operands =~ /^((reg|rm)(32|64)|reg_[re]([abcd]x|[sb]p|[sd]i))\b/) &&
	$opcode !~ /$nozero/io) {
	$flags .= ',ZU';
    }

    return ($opcode, $operands, $encoding, $flags);
}

sub adjust_instruction(@) {
    my @i = @_;

    @i = adjust_instruction_flags(@i);

    return @i;
}

sub process_insn($$) {
    my($out, $l) = @_;

    if ($l !~ /^(\s*)([^\s\;]+)(\s+)([^\s\;]+)(\s+)([^\s\;]+|\[[^\;]*\])(\s+)([^\s\;]+)(\s*(\;.*)?)$/) {
	print $out $l, "\n";
	return;
    }

    # Opcode   = $f[1]
    # Operands = $f[3]
    # Encoding = $f[5]
    # Flags    = $f[7]
    my @f = ($1, $2, $3, $4, $5, $6, $7, $8);

    # Modify the instruction flags
    ($f[1], $f[3], $f[5], $f[7]) = adjust_instruction($f[1], $f[3], $f[5], $f[7]);

    # Clean up stray commas in flags
    $f[7] =~ s/^\+//;
    $f[7] =~ s/\+$//;
    $f[7] =~ s/\,\,+/,/g;

    print $out @f, "\n";
}

open(my $in, '<', $infile) or die "$0:$infile: $!\n";
open(my $out, '>', $outfile) or die "$0:$outfile: $!\n";


while (defined(my $l = <$in>)) {
    chomp $l;

    if ($l =~ /^\$\s*([^\s\;][^\;]*?)\s*(\;.*)?$/) {
	foreach my $ins (process_macro(split(/\s+/, $1))) {
	    process_insn($out, $ins);
	}
    } else {
	process_insn($out, $l);
    }
}

close($in);
close($out);
