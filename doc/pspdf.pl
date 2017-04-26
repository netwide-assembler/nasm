#!/usr/bin/perl
#
# Wrapper around a variety of programs that can do PS -> PDF conversion
#

use strict;
use File::Spec;

my $compress = 1;

my $win32_ok = eval {
    require Win32::TieRegistry;
    Win32::TieRegistry->import();
    1;
};

while ($ARGV[0] =~ /^-(.*)$/) {
    my $opt = $1;
    shift @ARGV;

    if ($opt eq '-nocompress') {
        $compress = 0;
    }
}

my ($in, $out) = @ARGV;

if (!defined($out)) {
    die "Usage: $0 [-nocompress] infile ou{ tfile\n";
}

# If Win32, help GhostScript out with some defaults
sub win32_gs_help() {
    return if (!$win32_ok);

    use Sort::Versions;
    use sort 'stable';

    my $Reg = $::Registry->Open('', {Access => 'KEY_READ', Delimiter => '/'});
    my $dir;
    my @gs;

    foreach my $k1 ('HKEY_CURRENT_USER/Software/',
                    'HKEY_LOCAL_MACHINE/SOFTWARE/') {
        foreach my $k2 ('Artifex/', '') {
            foreach my $k3 ('GPL Ghostscript/', 'AFPL Ghostscript/',
                            'Ghostscript/') {
                my $r = $Reg->{$k1.$k2.$k3};
                if (ref($r) eq 'Win32::TieRegistry') {
                    foreach my $k (keys(%$r)) {
                        my $rk = $r->{$k};
                        if (ref($rk) eq 'Win32::TieRegistry' &&
                            defined($rk->{'/GS_LIB'})) {
                            push @gs, $rk;
                        }
                    }
                }
            }
        }
    }

    @gs = sort {
        my($av) = $a->Path =~ m:^.*/([^/]+)/$:;
        my($bv) = $b->Path =~ m:^.*/([^/]+)/$:;
        versioncmp($av, $bv);
    } @gs;

    return unless (scalar(@gs));

    $ENV{'PATH'} .= ';' . $gs[0]->{'/GS_LIB'};
    $ENV{'GS_FONTPATH'} .= (defined($ENV{'GS_FONTPATH'}) ? ';' : '')
        . $ENV{'windir'}.'\\fonts';
}

# Remove output file
unlink($out);

# 1. Acrobat distiller
my $r = system('acrodist', '-n', '-q', '--nosecurity', '-o', $out, $in);
exit 0 if ( !$r && -f $out );

# 2. ps2pdf (from Ghostscript)
# The -I clause helps Ghostscript pick up the Fontdir file written by findfont.ph
# GhostScript uses # rather than - to separate options and values on Windows, it seems...
win32_gs_help();
my $o = $win32_ok ? '#' : '-';
my $r = system('ps2pdf', "-dOptimize${o}true", "-dEmbedAllFonts${o}true",
               "-dCompressPages${o}" . ($compress ? 'true' : 'false'),
               "-dUseFlateCompression${o}true", $in, $out);
exit 0 if ( !$r && -f $out );

# 3. pstopdf (BSD/MacOS X utility)
my $r = system('pstopdf', $in, '-o', $out);
exit 0 if ( !$r && -f $out );

# Otherwise, fail
unlink($out);
exit 1;
