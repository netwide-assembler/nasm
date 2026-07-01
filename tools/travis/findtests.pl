#!/usr/bin/perl

use strict;
use integer;
use File::Find;
use File::Spec;

my($srcdir,$objdir,$subdir) = @ARGV;

my $base = File::Spec->catdir($srcdir, $subdir);

sub print_dir {
    return if (! -d $_);
    my($vol,$dirs) = File::Spec->splitpath($_, 1);
    my @dirs = File::Spec->splitdir($dirs);

    # $objdir really should be part of catfile, but that breaks our
    # current "golden reference" files -- fix that at some point.
    my $json = File::Spec->catfile(@dirs, $dirs[-1].'.json');
    if ( -f $json ) {
	print File::Spec->catfile($objdir, File::Spec->abs2rel($json, $srcdir)), "\n";
    }
}
find({no_chdir => 1, wanted => \&print_dir}, $base);
