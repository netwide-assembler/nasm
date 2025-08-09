#!/usr/bin/perl
#
# Generate CPU feature dependency bitmasks
#

use integer;
use strict;

require 'x86/x86features.ph';

our @cpufeatures;
our $cpufeature_words;

my($outfile) = @ARGV;

open(my $out, '>', $outfile) or die "$0: $outfile: $!\n";

print $out "#ifndef X86_FEATUREINFO_H\n";
print $out "#define X86_FEATUREINFO_H 1\n\n";

print $out "#include \"compiler.h\"\n\n";

print $out "struct cpu_feature_info {\n";
print $out "    const char \*name;\n";
print $out "    const char \*help;\n";
print $out "    unsigned int num;\n";
print $out "    uint32_t deps[$cpufeature_words];\n";
print $out "};\n\n";

printf $out "extern const struct cpu_feature_info cpu_feature_info[%d];\n\n",
    scalar(@cpufeatures);

printf $out "#endif\n\n";

print $out "#ifdef COMPILING_FEATUREINFO_C\n\n";

printf $out "const struct cpu_feature_info cpu_feature_info[%d] = {\n",
    scalar(@cpufeatures);

foreach my $feat (@cpufeatures) {
    printf $out "    { %-15s \"%s\", %d, {%s} },\n",
	'"'.$feat->{'name'}.'",',
	$feat->{'help'},
	$feat->{'num'},
	join(',', map { sprintf('0x%08x', $_) } @{$feat->{'depmask'}});
}
print $out "};\n\n";

print $out "#endif\n";

close($out);
