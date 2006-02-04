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
use Env;

$perl   = $ENV{PERL}   || 'perl';
$srcdir = $ENV{srcdir} || File::Spec->curdir();

$versionfile = File::Spec->catfile($srcdir, File::Spec->updir(), 'version');
$genps = File::Spec->catfile($srcdir, 'genps.pl');

sysopen(VERSION, $versionfile, O_RDONLY)
    or die "$0: cannot open $versionfile\n";
$version = <VERSION>;
chomp $version;
close(VERSION);

# \240 = no-break space, see @NASMEncoding in genps.pl.
# If we use a normal space, it breaks on 'doze platforms...
system($perl, $genps, '-subtitle', "version\240".$version,
       @ARGV, 'nasmdoc.dip');
