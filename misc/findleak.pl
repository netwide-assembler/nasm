#!/usr/bin/perl
# From: Ed Beroset <beroset@mindspring.com>

my %mem = {};
my %alloc = {};
while(<>)
{
        if (/realloc\((0x[0-9a-f]+).*\).*returns \((0x[0-9a-f]+)/)
        {
                $mem{$1}--;
                if ($mem{$1} != 0) {
                        print "free before alloc! $_";
                }
                if ($mem{$2} != 0) {
                        print "memory leak! $_";
                }
                $mem{$2}++;
                $alloc{$2} = $_;
        }
        elsif (/free\((0x[0-9a-f]+)/)
        {
                $mem{$1}--;
                if ($mem{$1} != 0) {
                        print "free before alloc! $_";
                }
        }
        elsif (m/returns (0x[0-9a-f]+)/)
        {
                if ($mem{$1} != 0) {
                        print "memory leak! $_";
                }
                $mem{$1}++;
                $alloc{$1} = $_;
        }
}
foreach $goo (sort keys %mem)
{
        if ($mem{$goo})
        {
                print "$mem{$goo} $alloc{$goo}";
        }
}
