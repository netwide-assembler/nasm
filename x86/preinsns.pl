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

require 'x86/insns-iflags.ph';

our %macros;
our($macro, $outfile, $infile, $line);	# Public for error messages

# Common pattern for the basic 8 arithmetric functions
$macros{'arith'} = {
    'def' => *def_eightfold,
    'txt' => <<'EOL'
$op		rm8,reg8			[mr:	$hle $00 /r				]	8086,SM,$lock
$op		rm16,reg16			[mr:	$hle o16 $01 /r				]	8086,SM,$lock
$op		rm32,reg32			[mr:	$hle o32 $01 /r				]	386,SM,$lock,$zu
$op		rm64,reg64			[mr:	$hle o64 $01 /r				]	X86_64,LONG,SM,$lock,$zu
$op		reg8,rm8			[rm:	$02 /r					]	8086,SM
$op		reg16,rm16			[rm:	o16 $03 /r				]	8086,SM
$op		reg32,rm32			[rm:	o32 $03 /r				]	386,SM,$zu
$op		reg64,rm64			[rm:	o64 $03 /r				]	X86_64,LONG,SM,$zu
$op		reg_al,imm8			[-i:	$04 ib					]	8086,SM
$op		rm8,imm8			[mi:	$hle 80 /$n ib				]	8086,SM,$lock
$op		rm16,sbyteword16		[mi:	$hle o16 83 /$n ib,s			]	8086,SM,$lock
$op		reg_ax,imm16			[-i:	o16 $05 iw				]	8086,SM
$op		rm16,imm16			[mi:	$hle o16 81 /$n iw			]	8086,SM,$lock
$op		rm32,sbytedword32		[mi:	$hle o32 83 /$n ib,s			]	386,SM,$lock,$zu
$op		reg_eax,imm32			[-i:	o32 $05 id				]	386,SM,$zu
$op		rm32,imm32			[mi:	$hle o32 81 /$n id			]	386,SM,$lock,$zu
$op		rm64,sbytedword64		[mi:	$hle o64 83 /$n ib,s			]	X86_64,LONG,SM,$lock,$zu
$op		reg_rax,sdword64		[-i:	o64 $05 id,s				]	X86_64,LONG,SM,$zu
$op		rm64,sdword64			[mi:	$hle o64 81 /$n id,s			]	X86_64,LONG,SM,$lock,$zu
$op		reg8?,reg8,rm8			[vrm:	evex.ndx.nf.l0.m4.o8     $02 /r		]	$apx,SM
$op		reg16?,reg16,rm16		[vrm:	evex.ndx.nf.l0.m4.o16    $03 /r		]	$apx,SM
$op		reg32?,reg32,rm32		[vrm:	evex.ndx.nf.l0.m4.o32    $03 /r		]	$apx,SM
$op		reg64?,reg64,rm64		[vrm:	evex.ndx.nf.l0.m4.o64    $03 /r		]	$apx,SM
$op		reg8?,rm8,reg8			[vmr:	evex.ndx.nf.l0.m4.o8     $00 /r		]	$apx,SM
$op		reg16?,rm16,reg16		[vmr:	evex.ndx.nf.l0.m4.o16    $01 /r		]	$apx,SM
$op		reg32?,rm32,reg32		[vmr:	evex.ndx.nf.l0.m4.o32    $01 /r		]	$apx,SM,$zu
$op		reg64?,rm64,reg64		[vmr:	evex.ndx.nf.l0.m4.o64    $01 /r		]	$apx,SM,$zu
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
$macros{'shift'} = {
    'def' => *def_eightfold,
    'txt' => <<'EOL'
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
${op}X		reg32?,rm32,reg32		[rmv:	vex.nds.lz.$x.w0.$xs /r]		FUTURE,BMI2,!FL
${op}X		reg64?,rm64,reg64		[rmv:	vex.nds.lz.$x.w1.$xs /r]		LONG,FUTURE,BMI2,!FL
$op		reg32?,rm32,reg32		[rmv:	vex.nds.lz.$x.w0.$xs /r]		FUTURE,BMI2,NF!,OPT,ND
$op		reg64?,rm64,reg64		[rmv:	vex.nds.lz.$x.w1.$xs /r]		LONG,FUTURE,BMI2,NF!,OPT,ND
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
# Common pattern for 8/16/32/64 or 16/32/64 instructions
#
$macros{'trio'} = { 'func' => *func_trio_quad, 'first' => 16 };
$macros{'quad'} = { 'func' => *func_trio_quad, 'first' =>  8 };

sub func_trio_quad($$$) {
    my($mac, $args, $rawargs) = @_;

    my @ol;

    my %sizename = ( 8 => 'B', 16 => 'W', 32 => 'D', 64 => 'Q' );

    for (my $i = $mac->{'first'}; $i <= 64; $i <<= 1) {
	my $o;
	my $ins = join("\t", @$rawargs);
	while ($ins =~ /^(.*?)((?:\b[0-9a-f]{2})?\#|\%)(.*)$/) {
	    $o .= $1;
	    my $mw = $2;
	    $ins = $3;
	    if ($mw eq '%') {
		$o .= $sizename{$i};
	    } elsif ($mw =~ /^([0-9a-f]{2})\#$/) {
		$o .= sprintf('%02x', hex($1) | ($i >= 16));
	    } else {
		$o .= $i;
	    }
	}
	$o .= $ins;
	$o =~ s/\bNOLONG${i}\b/NOLONG/;
	$o =~ s/\bNOLONG[0-9]+\b//;
	if ($i >= 64) {
	    next if ($o =~ /\bNOLONG\b/);
	    $o .= ',X86_64,LONG';
	} elsif ($i >= 32) {
	    $o .= ',386';
	}
	push(@ol, $o);
    }

    return @ol;
}

#
# Macro helper functions for common constructs
#

# Parse arguments handling variable setting
sub parse_args($@) {
    my $uvars = shift(@_);
    my %initvars = defined($uvars) ? %$uvars : ();
    my @oa;
    my $n = 0;			# Argument counter

    foreach my $ops (@_) {
	my %vars = %initvars;
	$vars{'n'}  = $n;
	$vars{'nd'} = 0;
	my @oaa;
	foreach my $op ($ops =~ /(?:[^\,\[\]\"]+|\[.*?\]|\".*?\")+/g) {
	    $op =~ s/\"//g;

	    $vars{'nd'} = 'nd' if ($op =~ s/^\@//);
	    if ($op =~ /^(\w+)\=(.*)$/) {
		$vars{$1} = $2;
		next;
	    } elsif ($op =~ /^([\!\+\-])(\w+)$/) {
		# The commas around KILL guarantees that it is a separate token
		$vars{$2} =
		    ($1 eq '+') ? $2 :
		    ($1 eq '!') ? ',KILL,' :
		    '';
		next;
	    } elsif ($op =~ /^\-?$/) {
		next;
	    }

	    $vars{'op'} = $op;
	    push(@oaa, {%vars});
	    $vars{'nd'} = 'nd';
	}
	if (scalar(@oaa)) {
	    push(@oa, [@oaa]);
	} else {
	    # Global variable setting
	    %initvars = %vars;
	}
    }

    return @oa;
}

# "8-fold" or similar sequential instruction patterns
sub def_eightfold($$$) {
    my($var, $arg, $mac) = @_;

    my $shift = $arg->{'shift'};
    $shift = 3 unless (defined($shift));

    if ($var =~ /^[0-9a-f]{1,2}$/) {
	return sprintf('%02x', hex($var) + ($arg->{'n'} << $shift));
    } else {
	return $var;
    }
}

#
# Substitute variables in a pattern
#
sub substitute($$;$) {
    my($pat, $vars, $defs) = @_;
    my $o = '';
    my $def;
    my @defargs;

    if (defined($defs)) {
	@defargs = @$defs;
	$def = shift(@defargs);
    }

    while ($pat =~ /^(.*?)\$(?:(\w+\b|\$+)|\{(\w+|\$+)\})(.*)$/s) {
	$o .= $1;
	$pat = $4;
	my $vn = $2.$3;
	my $vv;
	if ($vn =~ /^\$/) {
	    $vv = $vn;		# Reduce by one $
	} else {
	    $vv = $vars->{$vn};
	    if (!defined($vv)) {
		if (defined($def)) {
		    $vv = $def->($vn, @defargs);
		}
		$vv = $vn unless(defined($vv));
	    }
	}
	$vv =~ s/\s+$// if ($pat =~ /^\s/);
	$o .= $vv;
    }
    $o .= $pat;

    return $o;
}

#
# Build output by substituting the variables for each argument,
#
sub subst_list($$;$$) {
    my($pat, $args, $def, $mac) = @_;
    my @o = ();

    foreach my $a0 (@$args) {
	foreach my $arg (@$a0) {
	    push(@o, substitute($pat, $arg, [$def, $arg, $mac]));
	}
    }

    return @o;
}

#
# Actually invoke a macro
#
sub process_macro(@) {
    $macro = shift(@_);
    my $mac = $macros{$macro};

    if (!defined($mac)) {
	die "$0:$infile:$line: no macro named \$$macro\n";
    }

    my @args = parse_args($mac->{'vars'}, @_);
    my $func = $mac->{'func'};
    my @o;
    if (defined($func)) {
	@o = $func->($mac, \@args, \@_);
    } else {
	@o = subst_list($mac->{'txt'}, \@args, $mac->{'def'}, $mac);
    }
    return map { split(/\n/, $_) } @o;
}

#
# Main program
#
($infile, $outfile) = @ARGV;
$line = 0;

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

sub add_flag($@) {
    my $flags = shift(@_);

    foreach my $fl (@_) {
	$flags->{$fl}++ unless ($fl =~ /^\s*$/);
    }
}

sub has_flag($@) {
    my $flags = shift(@_);
    foreach my $fl (@_) {
	return $flags->{$fl} if ($flags->{$fl});
    }
    return undef;
}

sub adjust_instruction_flags(@) {
    my($opcode, $operands, $encoding, $flags) = @_;

    # Flag-changing instructions
    if ($encoding =~ /\bnf\b/) {
	add_flag($flags, 'NF');
    }

    if (!has_flag($flags, '!FL', 'NF', 'NF!')) {
	add_flag($flags, 'FL') if ($opcode =~ /$flaggy/io);
    }

    ## XXX: fix special case: XCHG
    ## XXX: check: CMPSS, CMPSD
    ## XXX: check VEX encoded instructions that do not write

    # Zero-upper. This can also be used to select the AVX forms
    # to clear the upper part of a vector register.
    if (!$flags->{'!ZU'} &&
	(($encoding =~ /\be?vex\b/ && $operands =~ /^(xyz)mm(reg|rm)/) ||
	 $operands =~ /^((reg|rm)(32|64)|reg_[re]([abcd]x|[sb]p|[sd]i))\b/) &&
	$opcode !~ /$nozero/io) {
	add_flag($flags, 'ZU');
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

    my $nopr = ($f[3] =~ /^(void|ignore)$/) ? 0 :
	scalar(split(/[\,\:]/, $f[3]));

    # Modify the instruction flags
    my %flags = split_flags($f[7]);
    set_implied_flags(\%flags, $nopr);

    adjust_instruction($f[1], $f[3], $f[5], \%flags);

    # The symbol KILL can be used in macros to eliminate a pattern entirely
    next if ($f[1] =~ /\bKILL\b/ || $f[3] =~ /\bKILL\b/ ||
	     $f[5] =~ /\bKILL\b/ || $flags{'KILL'});

    $f[7] = merge_flags(\%flags, 1);
    print $out @f, "\n";
}

open(my $in, '<', $infile) or die "$0:$infile: $!\n";
open(my $out, '>', $outfile) or die "$0:$outfile: $!\n";


while (defined(my $l = <$in>)) {
    $line++;
    chomp $l;
    my @insi = ($l);

    while (defined(my $li = shift(@insi))) {
	if ($li =~ /^\s*\$(\w+[^\;]*?)\s*(\;.*)?$/) {
	    print $out $2, "\n" unless ($2 eq ''); # Retain comment
	    my @args = ($1 =~ /(?:\[[^\]]*\]|\"[^\"]*\"|[^\[\]\"\s])+/g);
	    push(@insi, process_macro(@args));
	} else {
	    process_insn($out, $li);
	}
    }
}

close($in);
close($out);
