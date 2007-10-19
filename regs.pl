#!/usr/bin/perl
#
# Read regs.dat and output regs.h and regs.c (included in names.c)
#

$nline = 0;

sub toint($) {
    my($v) = @_;

    return ($v =~ /^0/) ? oct $v : $v+0;
}

sub process_line($) {
    my($line) = @_;
    my @v;

    if ( $line !~ /^\s*(\S+)\s*(\S+)\s*(\S+)\s*([0-9]+)$/i ) {
	die "regs.dat:$nline: invalid input\n";
    }
    $reg      = $1;
    $aclass   = $2;
    $dclasses = $3;
    $x86regno = toint($4);

    if ($reg =~ /^(.*[^0-9])([0-9]+)\-([0-9]+)(|[^0-9].*)$/) {
	$nregs = $3-$2+1;
	$reg = $1.$2.$4;
	$reg_nr = $2;
	$reg_prefix = $1;
	$reg_suffix = $4;
    } else {
	$nregs = 1;
	undef $reg_prefix, $reg_suffix;
    }

    while ($nregs--) {
	$regs{$reg} = $aclass;
	$regvals{$reg} = $x86regno;

	foreach $dclass (split(/,/, $dclasses)) {
	    if ( !defined($disclass{$dclass}) ) {
		$disclass{$dclass} = [];
	    }

	    $disclass{$dclass}->[$x86regno] = $reg;
	}

	# Compute the next register, if any
	if (defined($reg_prefix)) {
	    $x86regno++;
	    $reg_nr++;
	    $reg = sprintf("%s%u%s", $reg_prefix, $reg_nr, $reg_suffix);
	} else {
	    # Not a dashed sequence
	    die if ($nregs);
	}
    }
}

($fmt, $file) = @ARGV;

%regs = ();
%regvals = ();
%disclass = ();
open(REGS, "< ${file}") or die "$0: Cannot open $file\n";
while ( defined($line = <REGS>) ) {
    $nline++;

    chomp $line;
    $line =~ s/\s*(\#.*|)$//;

    next if ( $line eq '' );

    process_line($line);
}
close(REGS);

if ( $fmt eq 'h' ) {
    # Output regs.h
    print "/* automatically generated from $file - do not edit */\n\n";
    $expr_regs = 1;
    printf "#define EXPR_REG_START %d\n", $expr_regs;
    print "enum reg_enum {\n";
    $attach = ' = EXPR_REG_START'; # EXPR_REG_START == 1
    foreach $reg ( sort(keys(%regs)) ) {
	print "    R_\U${reg}\E${attach},\n";
	$attach = '';
	$expr_regs++;
    }
    print "    REG_ENUM_LIMIT,\n";
    # Unfortunately the code uses both 0 and -1 as "no register" in
    # different places...
    print "    R_zero = 0,\n";
    print "    R_none = -1";
    print "};\n\n";
    printf "#define EXPR_REG_END %d\n", $expr_regs-1;
    foreach $reg ( sort(keys(%regs)) ) {
	printf "#define %-15s %2d\n", "REG_NUM_\U${reg}", $regvals{$reg};
    }
    print "\n";
} elsif ( $fmt eq 'c' ) {
    # Output regs.c
    print "/* automatically generated from $file - do not edit */\n\n";
    print "#include \"compiler.h\"\n\n";
    print "static const char * const reg_names[] = "; $ch = '{';
    # This one has no dummy entry for 0
    foreach $reg ( sort(keys(%regs)) ) {
	print "$ch\n    \"${reg}\"";
	$ch = ',';
    }
    print "\n};\n";
} elsif ( $fmt eq 'fc' ) {
    # Output regflags.c
    print "/* automatically generated from $file - do not edit */\n";
    print "static const int32_t reg_flags[] = {\n";
    print "    0";		# Dummy entry for 0
    foreach $reg ( sort(keys(%regs)) ) {
	print ",\n    ", $regs{$reg}; # Print the class of the register
    }
    print "\n};\n";
} elsif ( $fmt eq 'vc' ) {
    # Output regvals.c
    print "/* automatically generated from $file - do not edit */\n";
    print "static const int regvals[] = {\n";
    print "    -1";		# Dummy entry for 0
    foreach $reg ( sort(keys(%regs)) ) {
	printf ",\n    %2d", $regvals{$reg}; # Print the regval of the register
    }
    print "\n};\n";
} elsif ( $fmt eq 'dc' ) {
    # Output regdis.c
    print "/* automatically generated from $file - do not edit */\n";
    foreach $class ( sort(keys(%disclass)) ) {
	printf "static const enum reg_enum rd_%-8s[] = {", $class;
	@foo = @{$disclass{$class}};
	@bar = ();
	for ( $i = 0 ; $i < scalar(@foo) ; $i++ ) {
            if (defined($foo[$i])) {
		push(@bar, "R_\U$foo[$i]\E");
	    } else {
		die "$0: No register name for class $class, value $i\n";
            }
	}
	print join(',', @bar), "};\n";
    }
} else {
    die "$0: Unknown output format\n";
}
