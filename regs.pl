#!/usr/bin/perl
# $Id$
#
# Read regs.dat and output regs.h and regs.c (included in names.c)
#

$nline = 0;

sub process_line($) {
    my($line) = @_;
    my @v;

    if ( $line !~ /^\s*(\S+)\s*(\S+)\s*(\S+)\s*([0-9]+)\s*$/ ) {
	die "regs.dat:$nline: invalid input\n";
    }
    $reg    = $1;
    $aclass = $2;
    $dclass = $3;
    $regval   = $4;

    $regs{$reg} = $aclass;
    $regvals{$reg} = $regval;

    if ( !defined($disclass{$dclass}) ) {
	$disclass{$dclass} = [(undef) x 8];
    }

    $disclass{$dclass}->[$regval] = $reg;
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

    if ( $line =~ /\*/ ) {
	for ( $i = 0 ; $i < 8 ; $i++ ) {
	    ($xline = $line) =~ s/\*/$i/g;
	    process_line($xline);
	}
    } else {
	process_line($line);
    }
}
close(REGS);

if ( $fmt eq 'h' ) {
    # Output regs.h
    print "/* automatically generated from $file - do not edit */\n";
    print "enum reg_enum {\n";
    $attach = ' = EXPR_REG_START'; # EXPR_REG_START == 1
    foreach $reg ( sort(keys(%regs)) ) {
	print "    R_\U${reg}\E${attach},\n";
	$attach = ''; $ch = ',';
    }
    print "    REG_ENUM_LIMIT\n";
    print "};\n\n";
    foreach $reg ( sort(keys(%regs)) ) {
	print "#define REG_NUM_\U${reg}     $regvals{$reg}\n";
    }
    print "\n";
} elsif ( $fmt eq 'c' ) {
    # Output regs.c
    print "/* automatically generated from $file - do not edit */\n";
    print "static const int8_t *reg_names[] = "; $ch = '{';
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
	print ",\n    ", $regvals{$reg}; # Print the regval of the register
    }
    print "\n};\n";
} elsif ( $fmt eq 'dc' ) {
    # Output regdis.c
    print "/* automatically generated from $file - do not edit */\n";
    foreach $class ( sort(keys(%disclass)) ) {
	printf "static const int %-8s[] = {", $class;
	@foo = @{$disclass{$class}};
	for ( $i = 0 ; $i < scalar(@foo) ; $i++ ) {
	    $foo[$i] = defined($foo[$i]) ? "R_\U$foo[$i]\E" : '0';
	}
	print join(',', @foo), "};\n";
    }
} else {
    die "$0: Unknown output format\n";
}
