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
$$bwdq $op	rm#,reg#			[mr:	$hle o# $00# /r				]	8086,SM,$lock
$$bwdq $op	reg#,rm#			[rm:	o# $02# /r				]	8086,SM
$$wdq  $op	rm#,sbyte#			[mi:	$hle o# 83  /$n ib,s			]	8086,SM,$lock
$$bwdq $op	ax#,imm#			[-i:	o# $04# i#				]	8086,SM
$$bwdq $op	rm#,imm#			[mi:	$hle o# 80# /$n i#			]	8086,SM,$lock
$$bwdq $op	reg#?,reg#,rm#			[vrm:	evex.ndx.nf.l0.m4.o#     $02# /r	]	$apx,SM
$$bwdq $op	reg#?,rm#,reg#			[vmr:	evex.ndx.nf.l0.m4.o#     $00# /r	]	$apx,SM
$$wdq  $op	reg#?,rm#,sbyte#		[vmi:	evex.ndx.nf.l0.m4.o#     83 /$n ib,s	]	$apx,SM
$$bwdq $op	reg#?,rm#,imm#			[vmi:	evex.ndx.nf.l0.m4.o#     80# /$n ib	]	$apx,SM
EOL
};

# Common pattern for the basic shift and rotate instructions
$macros{'shift'} = {
    'def' => *def_eightfold,
	'txt' => <<'EOL'
$$bwdq $op	rm#,unity			[m-:	o# d0# /$n]				]	8086
$$bwdq $op	rm#,reg_cl			[m-:	o# d2# /$n]				]	8086
$$bwdq $op	rm#,imm8			[mi:	o# c0# /$n ib,u]			]	186
$$dq   ${op}X	reg#?,rm#,reg#			[rmv:	vex.nds.lz.$x.w#.$xs /r			]	SM0-1,FUTURE,BMI2,!FL
$$dq   ${op}X	reg#?,rm#,reg8			[rmv:	vex.nds.lz.$x.w#.$xs /r			]	SM0-1,FUTURE,BMI2,!FL,ND
$$dq   $op	reg#?,rm#,reg#			[rmv:	vex.nds.lz.$x.w#.$xs /r			]	SM0-1,FUTURE,BMI2,!FL
$$dq   $op	reg#?,rm#,reg8			[rmv:	vex.nds.lz.$x.w#.$xs /r			]	SM0-1,FUTURE,BMI2,!FL,ND
$$bwdq $op	reg#?,rm#,unity			[vm-:	evex.ndx.nf.l0.m4.o#  d0# /$n		]	$apx,SM0-1
$$bwdq $op	reg#?,rm#,reg_cl		[vm-:	evex.ndx.nf.l0.m4.o#  d2# /$n		]	$apx,SM0-1
$$bwdq $op	reg#?,rm#,imm8			[vmi:	evex.ndx.nf.l0.m4.o#  c0# /$n ib,u	]	$apx,SM0-1
EOL
};

#
# Common pattern for multiple 32/64, 16/32/64, or 8/16/32/64 instructions
#
my @sizename = ('b', 'w', 'd', 'q');

for (my $i = 1; $i <= 15; $i++) {
    my $n;
    for (my $j = 0; $j < scalar @sizename; $j++) {
	$n .= $sizename[$j] if ($i & (1 << $j));
    }
    $macros{$n} = { 'func' => *func_multisize, 'mask' => $i };
}

sub func_multisize($$$) {
    my($mac, $args, $rawargs) = @_;
    my @sbyte = ('imm8', 'sbyteword16', 'sbytedword32', 'sbytedword64');

    my @ol;
    my $mask = $mac->{'mask'};

    for (my $i = 0; $i < scalar(@sizename); $i++) {
	next unless ($mask & (1 << $i));
	my $s = 8 << $i;
	my $o;
	my $ins = join("\t", @$rawargs);
	while ($ins =~ /^(.*?)((?:\b[0-9a-f]{2}|\bsbyte|\bimm|\bi|\b(?:reg_)?[abcd]x|\bw)?\#|\%)(.*)$/) {
	    $o .= $1;
	    my $mw = $2;
	    $ins = $3;
	    if ($mw eq '%') {
		$o .= uc($sizename[$i]);
	    } elsif ($mw =~ /^([0-9a-f]{2})\#$/) {
		$o .= sprintf('%02x', hex($1) | ($s >= 16));
	    } elsif ($mw eq 'sbyte#') {
		$o .= $sbyte[$i];
	    } elsif ($mw eq 'imm#') {
		$o .= ($i >= 3) ? "sdword$s" : "imm$s";
	    } elsif ($mw eq 'i#') {
		$o .= ($i >= 3) ? 'id,s' : 'i'.$sizename[$i];
	    } elsif ($mw =~ /^(?:reg_)?([abcd])x\#$/) {
		if ($i == 0) {
		    $o .= "reg_${1}l";
		} elsif ($i == 1) {
		    $o .= "reg_${1}x";
		} elsif ($i == 2) {
		    $o .= "reg_e${1}x";
		} else {
		    $o .= "reg_r${1}x";
		}
	    } elsif ($mw eq 'w#') {
		$o .= ($i >= 3) ? 'w1' : 'w0';
	    } else {
		$o .= $s;
	    }
	}
	$o .= $ins;
	$o =~ s/\bNOLONG${i}\b/NOLONG/;
	$o =~ s/\bNOLONG[0-9]+\b//;
	if ($o =~ /\[[^\]]*\bnw\b[^\]]*\bo32\b[^\]]*\]/) {
	    # nw o32 -> NOLONG
	    $o .= ',NOLONG';
	}
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
	    $n++;
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

    return undef unless (@i);

    if ($i[2] =~ /\b(o64(nw)?\b|rex2?|a64\b)/) {
	add_flag($i[3], 'LONG');
    }
    if (has_flag($i[3], 'NOLONG') && has_flag($i[3], 'LONG')) {
	# This is obviously not very useful...
	return undef;
    }

    if ($i[0] =~ /\bKILL\b/ || $i[1] =~ /\bKILL\b/ ||
	$i[2] =~ /\bKILL\b/ || has_flag($i[3], 'KILL')) {
	return undef;
    }

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

    next unless (adjust_instruction($f[1], $f[3], $f[5], \%flags));

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
	    push(@insi, "$2\n") unless ($2 eq ''); # Retain comment
	    my @args = ($1 =~ /(?:\[[^\]]*\]|\"[^\"]*\"|[^\[\]\"\s])+/g);
	    unshift(@insi, process_macro(@args));
	} else {
	    process_insn($out, $li);
	}
    }
}

close($in);
close($out);
