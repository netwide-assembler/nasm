#!/usr/bin/perl
#
# Script to create Makefile-style dependencies.
#
# Usage: perl [-s path-separator] [-o obj-ext] mkdep.pl dir... > deps
#

sub scandeps($) {
    my($file) = @_;
    my($line, $nf);
    my(@xdeps) = ();
    my(@mdeps) = ();

    open(FILE, "< $file\0") or return; # If not openable, assume generated
    while ( defined($line = <FILE>) ) {
	chomp $line;
	$line =~ s:/\*.*\*/::g;
	$line =~ s://.*$::;
	if ( $line =~ /^\s*\#\s*include\s+\"(.*)\"\s*$/ ) {
	    $nf = $1;
	    push(@mdeps, $nf);
	    push(@xdeps, $nf) unless ( defined($deps{$nf}) );
	}
    }
    close(FILE);
    $deps{$file} = [@mdeps];

    foreach $file ( @xdeps ) {
	scandeps($file);
    }
}

# %deps contains direct dependencies.  This subroutine resolves
# indirect dependencies that result.
sub alldeps($) {
    my($file) = @_;
    my(%adeps);
    my($dep,$idep);

    foreach $dep ( @{$deps{$file}} ) {
	$adeps{$dep} = 1;
	foreach $idep ( alldeps($dep) ) {
	    $adeps{$idep} = 1;
	}
    }
    return keys(%adeps);
}

%deps = ();
@files = ();
$sep = '/';			# Default, and works on most systems
$obj = 'o';			# Object file extension

while ( defined($arg = shift(@ARGV)) ) {
    if ( $arg =~ /^\-s$/ ) {
	$sep = shift(@ARGV);
    } elsif ( $arg =~ /^\-o$/ ) {
	$obj = shift(@ARGV);
    } elsif ( $arg =~ /^-/ ) {
	die "Unknown option: $arg\n";
    } else {
	push(@files, $arg);
    }
}

foreach $dir ( @files ) {
    opendir(DIR, $dir) or die "$0: Cannot open directory: $dir";

    while ( $file = readdir(DIR) ) {
	$path = ($dir eq '.') ? $file : $dir.$sep.$file;
	if ( $file =~ /\.[Cc]$/ ) {
	    scandeps($path);
	}
    }
    closedir(DIR);
}

foreach $file ( sort(keys(%deps)) ) {
    if ( $file =~ /\.[Cc]$/ && scalar(@{$deps{$file}}) ) {
	$ofile = $file; $ofile =~ s/\.[Cc]$/\./; $ofile .= $obj;
	print $ofile, ': ';
	print join(' ', alldeps($file));
	print "\n";
    }
}

