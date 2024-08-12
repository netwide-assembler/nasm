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

our %macros;
our($macro, $outfile, $infile, $line);	# Public for error messages

# Common pattern for the basic 8 arithmetric functions
$macros{'arith'} = sub {
    return eightfold(<<'EOL', {}, @_);
$op		rm8,reg8			[mr:	$hle $o0 /r				]	8086,SM,$lock
$op		rm16,reg16			[mr:	$hle o16 $o1 /r				]	8086,SM,$lock
$op		rm32,reg32			[mr:	$hle o32 $o1 /r				]	386,SM,$lock,$zu
$op		rm64,reg64			[mr:	$hle o64 $o1 /r				]	X86_64,LONG,SM,$lock,$zu
$op		reg8,rm8			[rm:	$o2 /r					]	8086,SM
$op		reg16,rm16			[rm:	o16 $o3 /r				]	8086,SM
$op		reg32,rm32			[rm:	o32 $o3 /r				]	386,SM,$zu
$op		reg64,rm64			[rm:	o64 $o3 /r				]	X86_64,LONG,SM,$zu
$op		reg_al,imm8			[-i:	$o4 ib					]	8086,SM
$op		rm8,imm8			[mi:	$hle 80 /$n ib				]	8086,SM,$lock
$op		rm16,sbyteword16		[mi:	$hle o16 83 /$n ib,s			]	8086,SM,$lock
$op		reg_ax,imm16			[-i:	o16 $o5 iw				]	8086,SM
$op		rm16,imm16			[mi:	$hle o16 81 /$n iw			]	8086,SM,$lock
$op		rm32,sbytedword32		[mi:	$hle o32 83 /$n ib,s			]	386,SM,$lock,$zu
$op		reg_eax,imm32			[-i:	o32 $o5 id				]	386,SM,$zu
$op		rm32,imm32			[mi:	$hle o32 81 /$n id			]	386,SM,$lock,$zu
$op		rm64,sbytedword64		[mi:	$hle o64 83 /$n ib,s			]	X86_64,LONG,SM,$lock,$zu
$op		reg_rax,sdword64		[-i:	o64 $o5 id,s				]	X86_64,LONG,SM,$zu
$op		rm64,sdword64			[mi:	$hle o64 81 /$n id,s			]	X86_64,LONG,SM,$lock,$zu
$op		reg8?,reg8,rm8			[vrm:	evex.ndx.nf.l0.m4.o8     $o2 /r		]	$apx,SM
$op		reg16?,reg16,rm16		[vrm:	evex.ndx.nf.l0.m4.o16    $o3 /r		]	$apx,SM
$op		reg32?,reg32,rm32		[vrm:	evex.ndx.nf.l0.m4.o32    $o3 /r		]	$apx,SM
$op		reg64?,reg64,rm64		[vrm:	evex.ndx.nf.l0.m4.o64    $o3 /r		]	$apx,SM
$op		reg8?,rm8,reg8			[vmr:	evex.ndx.nf.l0.m4.o8     $o0 /r		]	$apx,SM
$op		reg16?,rm16,reg16		[vmr:	evex.ndx.nf.l0.m4.o16    $o1 /r		]	$apx,SM
$op		reg32?,rm32,reg32		[vmr:	evex.ndx.nf.l0.m4.o32    $o1 /r		]	$apx,SM,$zu
$op		reg64?,rm64,reg64		[vmr:	evex.ndx.nf.l0.m4.o64    $o1 /r		]	$apx,SM,$zu
$op		reg8?,rm8,imm8			[vmi:	evex.ndx.nf.l0.m4.o8     80 /$n ib	]	$apx,SM
$op		reg16?,rm16,sbyteword16		[vmi:	evex.ndx.nf.l0.m4.o16    83 /$n ib,s	]	$apx,SM
$op		reg16?,rm16,imm16		[vmi:	evex.ndx.nf.l0.m4.o16    81 /$n iw	]	$apx,SM
$op		reg32?,rm32,sbytedword32	[vmi:	evex.ndx.nf.l0.m4.o32    83 /$n ib,s	]	$apx,SM
$op		reg32?,rm32,imm32		[vmi:	evex.ndx.nf.l0.m4.o32    81 /$n id	]	$apx,SM
$op		reg64?,rm64,sbytedword32	[vmi:	evex.ndx.nf.l0.m4.o64    83 /$n ib,s	]	$apx,SM
$op		reg64?,rm64,sdword64		[vmi:	evex.ndx.nf.l0.m4.o64    81 /$n id,s	]	$apx,SM
EOL
};

# Common pattern for the basic shift and rotate instructions
$macros{'shift'} = sub {
    return eightfold(<<'EOL', {}, @_);
$op		rm8,unity			[m-:	d0 /$n]					8086
$op		rm8,reg_cl			[m-:	d2 /$n]					8086
$op		rm8,imm8			[mi:	c0 /$n ib,u]				186
$op		rm16,unity			[m-:	o16 d1 /$n]				8086
$op		rm16,reg_cl			[m-:	o16 d3 /$n]				8086
$op		rm16,imm8			[mi:	o16 c1 /$n ib,u]			186
$op		rm32,unity			[m-:	o32 d1 /$n]				386
$op		rm32,reg_cl			[m-:	o32 d3 /$n]				386
$op		rm32,imm8			[mi:	o32 c1 /$n ib,u]			386
$op		rm64,unity			[m-:	o64 d1 /$n]				X86_64,LONG
$op		rm64,reg_cl			[m-:	o64 d3 /$n]				X86_64,LONG
$op		rm64,imm8			[mi:	o64 c1 /$n ib,u]			X86_64,LONG
$op		reg8?,rm8,unity			[vm-:	evex.ndx.nf.l0.m4.o8  d2 /$n     ]	$apx,SM0-1
$op		reg16?,rm16,unity		[vm-:	evex.ndx.nf.l0.m4.o16 d3 /$n     ]	$apx,SM0-1
$op		reg32?,rm32,unity		[vm-:	evex.ndx.nf.l0.m4.o32 d3 /$n     ]	$apx,SM0-1
$op		reg64?,rm64,unity		[vm-:	evex.ndx.nf.l0.m4.o64 d3 /$n     ]	$apx,SM0-1
$op		reg8?,rm8,reg_cl		[vm-:	evex.ndx.nf.l0.m4.o8  d0 /$n     ]	$apx,SM0-1
$op		reg16?,rm16,reg_cl		[vm-:	evex.ndx.nf.l0.m4.o16 d1 /$n     ]	$apx,SM0-1
$op		reg32?,rm32,reg_cl		[vm-:	evex.ndx.nf.l0.m4.o32 d1 /$n     ]	$apx,SM0-1
$op		reg64?,rm64,reg_cl		[vm-:	evex.ndx.nf.l0.m4.o64 d1 /$n     ]	$apx,SM0-1
$op		reg8?,rm8,imm8			[vmi:	evex.ndx.nf.l0.m4.o8  c0 /$n ib,u]	$apx,SM0-1
$op		reg16?,rm16,imm8		[vmi:	evex.ndx.nf.l0.m4.o16 c1 /$n ib,u]	$apx,SM0-1
$op		reg32?,rm32,imm8		[vmi:	evex.ndx.nf.l0.m4.o32 c1 /$n ib,u]	$apx,SM0-1
$op		reg64?,rm64,imm8		[vmi:	evex.ndx.nf.l0.m4.o64 c1 /$n ib,u]	$apx,SM0-1
EOL
};

#
# Macro helper functions for common constructs
#

# "8-fold" or similar sequential instruction patterns
sub eightfold($$@) {
    my $pat  = shift(@_);
    my $uvars = shift(@_);
    my @l;

    my $n = 0;

    my %initvars = ('shift' => 3, %$uvars);

    foreach my $ops (@_) {
	my %vars = %initvars;
	$vars{'n'} = $n;
	for (my $i = 0; $i < (1 << $vars{'shift'}); $i++) {
	    $vars{"o$i"} = sprintf("%02x", $vars{'base'}+($n << $vars{'shift'})+$i);
	}
	my $nd = 0;
	my $outdata = 0;
	foreach my $op (split(/\,/, $ops)) {
	    if ($op =~ s/^\@//) {
		$nd = 1;
	    }
	    if ($op =~ /^(\w+)\=(.*)$/) {
		$vars{$1} = $2;
		next;
	    } elsif ($op =~ /^([\!\+\-])(\w+)$/) {
		$vars{$2} =
		    ($1 eq '+') ? $2 :
		    ($1 eq '!') ? 'KILL' :
		    '';
		next;
	    } elsif ($op =~ /^\-?$/) {
		next;
	    }

	    $vars{'op'} = $op;
	    my $sp = substitute($pat, \%vars);
	    if ($nd) {
		$sp =~ s/^(\w.*)$/$1,ND/gm;
	    }
	    push(@l, $sp);
	    $outdata = $nd = 1;
	}
	if ($outdata) {
	    $n++;
	} else {
	    %initvars = %vars;
	}
    }

    return @l;
}

#
# Substitute variables in a pattern
#
sub substitute($$) {
    my($pat, $vars) = @_;
    my $o = '';

    while ($pat =~ /^(.*?)\$(?:(\w+)\b|\{(\w+)\})(.*)$/s) {
	$o .= $1;
	$pat = $4;
	my $vn = $2.$3;
	my $vv = $vars->{$vn};
	if (!defined($vv)) {
#	    warn "$0:$infile:$line: no variable \$$vn in macro \$$macro\n";
	    $vv = $vn;
	}
	$o .= $vv;
    }
    $o .= $pat;

    return $o;
}

#
# Main program
#
($infile, $outfile) = @ARGV;
$line = 0;

sub process_macro(@) {
    $macro = shift(@_);
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

    # The symbol KILL can be used in macros to eliminate a pattern entirely
    next if ($f[3] =~ /\bKILL\b/ || $f[5] =~ /\bKILL\b/ || $f[7] =~ /\bKILL\b/);

    # Clean up stray commas and duplicate flags
    my %fls = ('' => 1);
    my @flc;
    foreach my $fl (split(/\,/, uc($f[7]))) {
	unless ($fls{$fl}) {
	    push(@flc, $fl);
	    $fls{$fl}++;
	}
    }
    $f[7] = join(',', @flc);
    print $out @f, "\n";
}

open(my $in, '<', $infile) or die "$0:$infile: $!\n";
open(my $out, '>', $outfile) or die "$0:$outfile: $!\n";


while (defined(my $l = <$in>)) {
    $line++;
    chomp $l;

    if ($l =~ /^\$\s*(\w+[^\;]*?)\s*(\;.*)?$/) {
	print $out $2, "\n" if ($2 ne '');
	my @args = grep { !/^\s*$/ } split(/((?:\[.*?\]|[^\[\]\s]+)+)/, $1);
	foreach my $ins (process_macro(@args)) {
	    process_insn($out, $ins);
	}
    } else {
	process_insn($out, $l);
    }
}

close($in);
close($out);
