#!/usr/bin/perl
#
# Generate a list of rotation vectors so we always use the same set.
# This needs to be run on a platform with /dev/urandom.
#

($n) = @ARGV;

sysopen(UR, '/dev/urandom', O_RDONLY) or die;

$maxlen = 78;

print "\@random_sv_vectors = (\n";
$outl = '   ';

for ($i = 0; $i < $n; $i++) {

    do {
	die if (sysread(UR, $x4, 4) != 4);
	@n = unpack("C*", $x4);

	$n[0] &= 31;
	$n[1] &= 31;
	$n[2] &= 31;
	$n[3] &= 31;
    } while ($n[0] == 0 || $n[1] == 0 || $n[2] == 0 || $n[3] == 0 ||
	$n[0] == $n[3] || $n[1] == $n[2]);

    $xl = sprintf(" [%d,%d,%d,%d]%s",
		  $n[0], $n[1], $n[2], $n[3],
		  ($i == $n-1) ? '' : ',');
    if (length($outl.$xl) > $maxlen) {
	print $outl, "\n";
	$outl = '   ';
    }
    $outl .= $xl;
}
close(UR);

print $outl, "\n";
print ");\n";
print "1;\n";
