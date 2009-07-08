#!/usr/bin/perl
## --------------------------------------------------------------------------
##   
##   Copyright 1996-2009 The NASM Authors - All Rights Reserved
##   See the file AUTHORS included with the NASM distribution for
##   the specific copyright holders.
##
##   Redistribution and use in source and binary forms, with or without
##   modification, are permitted provided that the following
##   conditions are met:
##
##   * Redistributions of source code must retain the above copyright
##     notice, this list of conditions and the following disclaimer.
##   * Redistributions in binary form must reproduce the above
##     copyright notice, this list of conditions and the following
##     disclaimer in the documentation and/or other materials provided
##     with the distribution.
##     
##     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
##     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
##     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
##     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
##     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
##     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
##     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
##     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
##     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
##     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
##     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
##     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
##     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
## --------------------------------------------------------------------------

#
# Parse AFM metric files
#

@widths = ((undef)x256);

while ( $line = <STDIN> ) {
    if ( $line =~ /^\s*FontName\s+(.*)\s*$/ ) {
	$fontname = $1;
    } elsif ( $line =~ /^\s*StartCharMetrics\b/ ) {
	$charmetrics = 1;
    } elsif ( $line =~ /^\s*EndCharMetrics\b/ ) {
	$charmetrics = 0;
    } elsif ( $line =~ /^\s*StartKernPairs\b/ ) {
	$kerndata = 1;
    } elsif ( $line =~ /^\s*EndKernPairs\b/ ) {
	$kerndata = 0;
    } elsif ( $charmetrics ) {
	@data = split(/\s*;\s*/, $line);
	undef $charcode, $width, $name;
	foreach $d ( @data ) {
	    @dd = split(/\s+/, $d);
	    if ( $dd[0] eq 'C' ) {
		$charcode = $dd[1];
	    } elsif ( $dd[0] eq 'WX' ) {
		$width = $dd[1];
	    } elsif ( $dd[0] eq 'W' ) {
		$width = $dd[2];
	    } elsif ( $dd[0] eq 'N' ) {
		$name = $dd[1];
	    }
	}
	if ( defined($name) && defined($width) ) {
	    $charwidth{$name} = $width;
	}
    } elsif ( $kerndata ) {
	@data = split(/\s+/, $line);
	if ( $data[0] eq 'KPX' ) {
	    if ( defined($charcodes{$data[1]}) &&
		 defined($charcodes{$data[2]}) &&
		 $data[3] != 0 ) {
		$kernpairs{chr($charcodes{$data[1]}).
			   chr($charcodes{$data[2]})} = $data[3];
	    }
	}
    }
}

sub qstr($) {
    my($s) = @_;
    my($o,$c,$i);
    $o = '"';
    for ( $i = 0 ; $i < length($s) ; $i++ ) {
	$c = substr($s,$i,1);
	if ( $c lt ' ' || $c gt '~' ) {
	    $o .= sprintf("\\%03o", ord($c));
	} elsif ( $c eq "\'" || $c eq "\"" || $c eq "\\" ) {
	    $o .= "\\".$c;
	} else {
	    $o .= $c;
	}
    }
    return $o.'"';
}

$psfont = $fontname;
$psfont =~ s/[^A-Za-z0-9]/_/g;

print "%PS_${psfont} = (\n";
print "  name => \'$fontname\',\n";
print "  widths => {";
$lw = 100000;
foreach $cc ( keys(%charwidth) ) {
    $ss = sprintf('%s => %d, ', qstr($cc), $charwidth{$cc});
    $lw += length($ss);
    if ( $lw > 72 ) {
	print "\n    ";
	$lw = 4 + length($ss);
    }
    print $ss;
}
print "\n  }\n";
#print "  kern => {";
#$lw = 100000;
#foreach $kp ( keys(%kernpairs) ) {
#    $ss = sprintf('%s => %d, ', qstr($kp), $kernpairs{$kp});
#    $lw += length($ss);
#    if ( $lw > 72 ) {
#	print "\n    ";
#	$lw = 4 + length($ss);
#    }
#    print $ss;
#}
#print "  }\n";
print ");\n";
print "1;\n";
