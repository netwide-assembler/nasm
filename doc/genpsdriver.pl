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

use File::Spec;
use Fcntl;

$perl   = $ENV{'PERL'}   || 'perl';
$srcdir = $ENV{'srcdir'} || '.';

$versionfile = File::Spec->catfile(File::Spec->updir($srcdir), 'version');
$genps = File::Spec->catfile($srcdir, 'genps.pl');

sysopen(VERSION, $versionfile, O_RDONLY)
    or die "$0: cannot open $versionfile\n";
$version = <VERSION>;
chomp $version;
close(VERSION);

system($perl, $genps, '-subtitle', 'version '.$version, 'nasmdoc.dip');
