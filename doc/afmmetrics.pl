#!/usr/bin/perl
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
	    } elsif ( $dd[0] eq 'N' ) {
		$name = $dd[1];
	    }
	}
	if ( defined($charcode) && $charcode >= 0 && $charcode < 256 ) {
	    $charcodes{$name} = $charcode;
	    $widths[$charcode] = $width;
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
print "  widths => [\n";
for ( $i = 0 ; $i < 256 ; $i += 8 ) {
    print "    ";
    for ( $j = 0 ; $j < 8 ; $j++ ) {
	printf("%5d", $widths[$i+$j]);
	print ',' if (($i+$j) < 255);
	print ' ' if ($j < 7);
    }
    print "\n";
}
print "  ],\n";
print "  kern => {";
$lw = 100000;
foreach $kp ( keys(%kernpairs) ) {
    $ss = sprintf('%s => %d, ', qstr($kp), $kernpairs{$kp});
    $lw += length($ss);
    if ( $lw > 72 ) {
	print "\n    ";
	$lw = 4 + length($ss);
    }
    print $ss;
}
print "  }\n";
print ");\n";


