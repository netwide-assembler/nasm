#!/usr/bin/perl
#
# Perfect Minimal Hash Generator written in Perl, which produces
# C output.
#

require 'phash.ph';

#
# Main program
#
sub main() {
    my $n;
    my %data;
    my @hashinfo;
    my $x, $i;

    %data = read_input();
    @hashinfo = gen_perfect_hash(\%data);

    if (!defined(@hashinfo)) {
	die "$0: no hash found\n";
    }

    verify_hash_table(\%data, \@hashinfo);

    ($n, $sv, $f1, $f2, $g) = @hashinfo;

    print "static int HASHNAME_fg1[$n] =\n";
    print "{\n";
    for ($i = 0; $i < $n; $i++) {
	print "\t", ${$g}[${$f1}[$i]], "\n";
    }
    print "};\n\n";

    print "static int HASHNAME_fg2[$n] =\n";
    print "{\n";
    for ($i = 0; $i < $n; $i++) {
	print "\t", ${$g}[${$f2}[$i]], "\n";
    }
    print "};\n\n";

    print "struct p_hash HASHNAME =\n";
    print "{\n";
    print "\t$n\n";
    print "\t$sv\n";
    print "\tHASHNAME_fg1,\n";
    print "\tHASHNAME_fg2,\n";
    print "};\n";
}

main();
