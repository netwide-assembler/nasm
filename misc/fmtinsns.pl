#!/usr/bin/perl
#
# Re-align the columns in insns.dat
#

@cols = (0, 16, 40, 72);

while ($line = <STDIN>) {
    chomp $line;
    if ($line !~ /^\s*(\;.*|)$/) {
	($ln = $line) =~ s/\s+$//;
	@fields = split(/\s+/, $line);
	if (scalar(@fields) == 4) {
	    $c = 0;
	    $line = '';
	    for ($i = 0; $i < scalar(@fields); $i++) {
		if ($i > 0 && $c >= $cols[$i]) {
		    $line .= ' ';
		    $c++;
		}
		while ($c < $cols[$i]) {
		    $line .= "\t";
		    $c = ($c+8) & ~7;
		}
		$line .= $fields[$i];
		$c += length($fields[$i]);
	    }
	}
    }
    print $line, "\n";
}
