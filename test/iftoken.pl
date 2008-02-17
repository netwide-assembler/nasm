#!/usr/bin/perl

@list = ('1', '+1', '1 2', '1,2', 'foo', 'foo bar', '%', '+foo', '<<');

foreach $t (@list) {
    print "\tdb 'N \"$t\": '\n";
    print "%iftoken $t\n";
    print "\tdb 'Yes', 10\n";
    print "%else\n";
    print "\tdb 'No', 10\n";
    print "%endif\n";

    print "\tdb 'C \"$t\": '\n";
    print "%iftoken $t ; With a comment!\n";
    print "\tdb 'Yes', 10\n";
    print "%else\n";
    print "\tdb 'No', 10\n";
    print "%endif\n";
}
