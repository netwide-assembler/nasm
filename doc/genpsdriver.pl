#!/usr/bin/perl
#
# Runs the equivalent of the following command line:
#
#       $(PERL) $(srcdir)/genps.pl -subtitle "version `cat ../version`" \
#                nasmdoc.dip
#
# This is implemented as a Perl script since `cat ...` doesn't
# necessarily work on non-Unix systems.
#

$perl   = $ENV{'PERL'}   || 'perl';
$srcdir = $ENV{'srcdir'} || '.';

open(VERSION, '< ../version') or die "$0: cannot open ../version\n";
$version = <VERSION>;
chomp $version;
close(VERSION);

system($perl, "${srcdir}/genps.pl", '-subtitle',
       'version '.$version, 'nasmdoc.dip');
