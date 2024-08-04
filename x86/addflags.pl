#!/usr/bin/perl
#
# Tag instructions which set the flags, and tag instructions
# which already do upper-zeroing.
#
# This can also be used to create other implied flags.
#

use integer;
use strict;

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

my($infile, $outfile) = @ARGV;

open(my $in, '<', $infile) or die "$0:$infile: $!\n";
open(my $out, '>', $outfile) or die "$0:$outfile: $!\n";

while (defined(my $l = <$in>)) {
    chomp $l;

    if ($l =~ /^\s*\;/ ||
	$l !~ /^(\s*)(\S+)(\s+)(\S+)(\s+)(\S+|\[.*\])(\s+)(\S+)\s*$/) {
	print $out $l, "\n";
        next;
    }
    # Opcode   = $f[1]
    # Operands = $f[3]
    # Encoding = $f[5]
    # Flags    = $f[7]
    my @f = ($1, $2, $3, $4, $5, $6, $7, $8);

    # Flag-changing instructions
    if ($f[7] !~ /\b(FL|NF)\b/ && $f[1] =~ /$flaggy/io) {
	$f[7] .= ',FL';
    }

    ## XXX: fix special case: XCHG
    ## XXX: check: CMPSS, CMPSD
    ## XXX: check VEX encoded instructions that do not write

    # Zero-upper. This can also be used to select the AVX forms
    # to clear the upper part of a vector register.
    if ($f[7] !~ /\bZU\b/ &&
	(($f[5] =~ /\bE?VEXb/ && $f[3] =~ /^(xyz)mm(reg|rm)/) ||
	 $f[3] =~ /^((reg|rm)(32|64)|reg_[re]([abcd]x|[sb]p|[sd]i))\b/) &&
	$f[1] !~ /$nozero/io) {
	$f[7] .= ',ZU';
    }

    print $out @f, "\n";
}

close($in);
close($out);
