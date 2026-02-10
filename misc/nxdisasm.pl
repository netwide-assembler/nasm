#!/usr/bin/perl
#
# Script to extract section and symbol information from a compound
# binary object (PE, COFF, ELF...) using binutils and running them
# through ndisasm.
#

use strict;
use integer;

my @symbols;	# Symbols by address
my @sections;	# Sections by start address

# Find the last symbol list at an address <= the given address,
# and its index in the @symbols array
sub find_sym($) {
    my($addr) = @_;

    my $l = 0;
    my $h = scalar @symbols - 1;
    while ($l < $h) {
	my $m = ($l+$h) >> 1;
	my $a = $symbols[$m]->[0];
	if ($a > $addr) {
	    $h = $m - 1;
	} elsif ($a < $addr) {
	    $l = $m + 1;
	} else {
	    $l = $m;
	    last;
	}
    }
    return ($symbols[$l], $l);
}

# Print a symbolic string, possibly with an addend
sub sym_str($;$) {
    my($addr, $sym) = @_;

    if (!defined($sym)) {
	return undef unless defined($addr);
	my($sy, $sx) = find_sym($addr);
	return undef unless defined($sy);
	$sym = $sy->[1]->[0];
	return undef unless defined($sym);
    }

    $addr -= $sym->{addr};
    return '<'.$sym->{name}.'>' if ($addr == 0);
    return sprintf('<%s%s0x%x>', $sym->{name},
		   $addr < 0 ? '-' : '+', abs($addr));
}

# Print a here marker for all symbols at this index and forward for
# all symbols with the same exact address; returns the following symbol
# list, if available
sub print_symbols($;$) {
    my($addr, $sx) = @_;

    my $sy;

    if (defined($sx)) {
	$sy = $symbols[$sx];
    } else {
	($sy, $sx) = find_sym($addr);
    }
    foreach my $sym (@{$sy->[1]}) {
	my $str = sym_str($addr, $sym);
	next unless (defined($str));
	print '--- ', $str, ":\n";
    }

    $sx++;
    return ($symbols[$sx], $sx);
}

my $OBJDUMP = $ENV{'OBJDUMP'} || 'objdump';
my $NDISASM = $ENV{'NDISASM'} || 'ndisasm';

sub parse_objdump($) {
    my($file) = @_;

    my %symhash;		# Hash of symbol lists my address

    open(my $od, '-|', $OBJDUMP, '-wht', $file) or return;

    my $what = 0;
    my $seq = 0;

    while (defined(my $l = <$od>)) {
	chomp $l;
	if ($l =~ /^Sections:/) {
	    $what = 1;
	} elsif ($l =~ /^SYMBOL TABLE:/) {
	    $what = 2;
	} elsif ($what == 1 && $l =~ s/^\s*\d+\s+//) {
	    my @fields = split(/\s+/, $l, 7);
	    my %flags = map { $_ => 1 } split(/,\s*/, $fields[6]);

	    if ($flags{'CODE'} && $flags{'CONTENTS'} && $flags{'LOAD'}) {
		my $size = hex $fields[1];
		if ($size) {
		    push(@sections, { name => $fields[0],
				      size => $size,
				      addr => hex $fields[2],
				      lma  => hex $fields[3],
				      offs => hex $fields[4],
				      seq  => ++$seq });
		}
	    }
	} elsif ($what == 2) {
	    my $sym;
	    if ($l =~ /^([0-9a-f]+) (.{7}) (\S+)\s+([0-9a-f]+)\s+(\S+)/i) {
		my $flags = $2;
		my $sec = $3;
		my $addr = hex $1;
		my $size = hex $4;
		my $name = $5;
		if ($sec ne '*UND*' && $flags !~ /[WId]/ ) {
		    my $prio = 0;
		    $prio += 100 if ($flags =~ /^l/);
		    $prio += 200 if ($flags =~ /^[gu!]/);
		    $prio  -= 50 if ($flags =~ /w/);
		    $prio += 400 if ($flags =~ /F$/);
		    $prio -=  90 if ($sec eq '*ABS*');

		    $sym = {
			addr  => $addr,
			flags => $flags,
			sec   => $sec,
			size  => $size,
			name  => $name,
			prio  => $prio
		    };
		}
	    } elsif ($l =~ /^\s*\[[\s\d]+\](?:\s+|\([^)]*\))*0x([0-9a-f]+)\s+(\S+)/i) {
		$sym = { 'addr' => hex $1, 'name' => $2 }
	    }
	    if (defined($sym)) {
		my $addr = $sym->{addr};
		$sym->{seq} = ++$seq;
		$symhash{$addr} = [] unless ($symhash{$addr});
		push(@{$symhash{$addr}}, $sym);
	    }
	}
    }

    close($od);

    @sections =	sort {
	$a->{addr} <=> $b->{addr} ||
	    $a->{name} cmp $b->{name}
    } @sections;

    # Add fallback sections symbols if necessary
    foreach my $sec (@sections) {
	my $addr = $sec->{addr};
	unless ($symhash{$addr}) {
	    $symhash{$addr} = [ { addr => $addr,
				  name => $sec->{name},
				  prio => -1000000000,
				  seq => ++$seq } ];
	}
    }
    unless (exists($symhash{0})) {
	$symhash{0} = [ ];
    }

    @symbols = map { [$_, $symhash{$_}] } sort { $a <=> $b } keys(%symhash);
    foreach my $sl (@symbols) {
	$sl->[1] = [sort {
	    $b->{prio} <=> $a->{prio} ||
	    $a->{name} cmp $b->{name} ||
	    $a->{sec} cmp $b->{sec}
	} @{$sl->[1]}];
    }
}

# Look for things which may be addresses in the disassembly and output
# the symbolic address if possible in that case.
sub postprocess_ndisasm($$) {
    my($dis, $sec) = @_;

    my $addr = $sec->{addr};

    printf "=== section <%s> addr 0x%08x len 0x%x (%u):\n",
	$sec->{name}, $addr, $sec->{size}, $sec->{size};

    # First symbol in the section and its address
    my($sy, $sx) = print_symbols($addr);

    while (defined(my $l = <$dis>)) {
	# print STDERR $l;
	chomp $l;
	if ($l =~ /^([0-9a-f]+)\s+([0-9a-f]+)\s+(.*)$/i) {
	    my $addr = hex $1;
	    my $ins = $3;
	    if (defined($sy) && $addr >= $sy->[0]) {
		($sy, $sx) = print_symbols($addr, $sx);
	    }

	    while ($ins =~ s/([^+-])(0x[0-9a-f]+)/$1/i) {
		my $ss = sym_str(hex $2);
		$l .= ' '.$ss if (defined($ss));
	    }
	}

	print "    ", $l, "\n";
    }
}

# Run ndisasm on a specific section
sub disasm($@) {
    my($file, @opts) = @_;
    my $err = 0;

    foreach my $sec (@sections) {
	my $dis;
	if (!open($dis, '-|', $NDISASM, '-i', '-e', $sec->{offs},
		  '-o', $sec->{addr}, '-z', $sec->{size}, @opts, $file)) {
	    $err++;
	    next;
	}
	postprocess_ndisasm($dis, $sec);
	close($dis);
    }

    return $err;
}

my($file) = pop(@ARGV);
if ( ! -f $file ) {
    die "$0: no input file: $file\n";
}

parse_objdump($file);
exit(disasm($file, @ARGV) != 0);
