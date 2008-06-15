#!/usr/bin/perl
#
# Sync the output file list between Makefiles
# Use the mkdep.pl parameters to get the filename syntax
#
# The first file is the source file; the other ones target.
# The initial file is assumed to be in Unix notation.
#
%def_hints = ('object-ending' => '.o',
	      'path-separator' => '/',
	      'continuation' => "\\");

sub do_transform($$) {
    my($l, $h) = @_;

    $l =~ s/\x01/$$h{'object-ending'}/g;
    $l =~ s/\x02/$$h{'path-separator'}/g;
    $l =~ s/\x03/$$h{'continuation'}/g;

    return $l;
}

@file_list = ();

$first = 1;
$first_file = $ARGV[0];
die unless (defined($first_file));

foreach $file (@ARGV) {
    open(FILE, "< $file\0") or die;

    # First, read the syntax hints
    %hints = %def_hints;
    while (defined($line = <FILE>)) {
	if ($line =~ /^\#\s+\@(\S+)\:\s*\"([^\"]+)\"/) {
	    $hints{$1} = $2;
	}
    }

    # Read and process the file
    seek(FILE,0,0);
    @lines = ();
    $processing = 0;
    while (defined($line = <FILE>)) {
	chomp $line;
	if ($processing) {
	    if ($line eq '#--- End File Lists ---#') {
		push(@lines, $line."\n");
		$processing = 0;
	    } elsif ($first) {
		my $xl = $line;
		my $oe = "\Q$hints{'object-ending'}";
		my $ps = "\Q$hints{'path-separator'}";
		my $cn = "\Q$hints{'continuation'}";

		$xl =~ s/${oe}(\s|$)/\x01$1/g;
		$xl =~ s/${ps}/\x02/g;
		$xl =~ s/${cn}$/\x03/;
		push(@file_list, $xl);
		push(@lines, $line);
	    }
	} else {
	    push(@lines, $line."\n");
	    if ($line eq '#--- Begin File Lists ---#') {
		$processing = 1;
		if (!$first) {
		    push(@lines, "# Edit in $first_file, not here!\n");
		    foreach $l (@file_list) {
			push(@lines, do_transform($l, \%hints)."\n");
		    }
		}
	    }
	}
    }
    close(FILE);

    # Write the file back out
    if (!$first) {
	open(FILE, "> $file\0") or die;
	print FILE @lines;
	close(FILE);
    }

    undef @lines;
    $first = 0;
}
