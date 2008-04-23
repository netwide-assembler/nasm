#!/usr/bin/perl
#Perform tests on nasm
use strict;
use warnings;

use File::Basename qw(fileparse);
use File::Compare qw(compare compare_text);
use File::Copy qw(move);
use File::Path qw(mkpath rmtree);

sub usage {
    print
'Perform tests on nasm.

Usage: performtest.pl ["quiet"] ["clean"] ["golden"] nasm_executable test_files...
';
    exit;
}

# sub debugprint { print (pop() . "\n"); }
sub debugprint { }

#Get one command line argument
sub get_arg { shift @ARGV; }

#Process one testfile
sub perform {
    my ($clean, $golden, $nasm, $quiet, $testpath) = @_;
    my ($stdoutfile, $stderrfile) = (".stdout", ".stderr");

    my ($testname, $ignoredpath, $ignoredsuffix) = fileparse($testpath, ".asm");
    debugprint $testname;

    my $outputdir = $golden ? "golden" : "testresults";

    mkdir "$outputdir" unless -d "$outputdir";

    if ($clean) {
        rmtree "$outputdir/$testname";
        return;
    }

    if(-d "$outputdir/$testname") {
        rmtree "$outputdir/$testname";
    }

    open(TESTFILE, '<', $testpath) or (warn "Can't open $testpath\n", return);
    TEST:
    while(<TESTFILE>) {
        #See if there is a test case
        last unless /Testname=(.*);\s*Arguments=(.*);\s*Files=(.*)/;
        my ($subname, $arguments, $files) = ($1, $2, $3);
        debugprint("$subname | $arguments | $files");

        #Call nasm with this test case
        system("$nasm $arguments $testpath > $stdoutfile 2> $stderrfile");
        debugprint("$nasm $arguments $testpath > $stdoutfile 2> $stderrfile ----> $?");

        #Move the output to the test dir
        mkpath("$outputdir/$testname/$subname");
        foreach(split / /,$files) {
            if (-f $_) {
                move($_, "$outputdir/$testname/$subname/$_") or die $!
            }
        }
        unlink ("$stdoutfile", "$stderrfile"); #Just to be sure

        if(! $golden) {
            #Compare them with the golden files
            my $result = 0;
            my @failedfiles = ();
            foreach(split / /, $files) {
                if(-f "$outputdir/$testname/$subname/$_") {
                    my $temp;
                    if($_ eq $stdoutfile or $_ eq $stderrfile) {
                        #Compare stdout and stderr in text mode so line ending changes won't matter
                        $temp = compare_text("$outputdir/$testname/$subname/$_", "golden/$testname/$subname/$_");
                    } else {
                        $temp = compare("$outputdir/$testname/$subname/$_", "golden/$testname/$subname/$_");
                    }

                    if($temp == 1) {
                        #different
                        $result = 1;
                        push @failedfiles, $_;
                    } elsif($temp == -1) {
                        #error
                        print "Error in $testname/$subname with file $_\n";
                        next TEST;
                    }
                } elsif (-f "golden/$testname/$subname/$_") {
                    #File exists in golden but not in output
                    $result = 1;
                    push @failedfiles, $_;
                }
            }


            if($result == 0) {
                print "Test $testname/$subname succeeded.\n" unless $quiet;
            } elsif ($result == 1) {
                print "Test $testname/$subname failed on @failedfiles.\n";
            } else {
                die "Impossible result";
            }
        }
    }
    close(TESTFILE);
}


my $arg;
my $nasm;
my $clean = 0;
my $golden = 0;
my $quiet = 0;

$arg = get_arg() or usage();


if($arg eq "quiet") {
    $quiet = 1;
    $arg = get_arg() or usage();
}
if($arg eq "clean") {
    $clean = 1;
    $arg = get_arg() or usage();
}
if ($arg eq "golden") {
    $golden = 1;
    $arg = get_arg() or usage();
}

$nasm = $arg;

perform($clean, $golden, $nasm, $quiet, $_) foreach @ARGV;
