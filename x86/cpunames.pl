#!/usr/bin/perl
#
# Create a list of CPU names and their corresponding CPU feature
# flags. These are different from the corresponding feature flags in that:
# a) their names can overlap with instruction flags.
# b) they are never used for removal.
#
# These are usually used standalone to set the feature set to a
# corresponding CPU.
#

use integer;
use strict;

require 'x86/x86features.ph';

our @cpufeatures;
our %cpufeature;
our $cpufeature_words;

my %cpu;
my @cpus;

sub empty_mask() {
    return [(0) x $cpufeature_words];
}

sub or_mask($$) {
    my($a, $b) = @_;
    my @c;

    die if (scalar(@$a) != scalar(@$b));

    for (my $i = 0; $i < scalar(@$a); $i++) {
	$a->[$i] |= $b->[$i];
    }

    return $a;
}

sub clear_bit($$) {
    my($mask, $bit) = @_;

    $mask->[$bit >> 5] &= ~(1 << ($bit & 31));
    return $mask;
}

my $all_vendors = empty_mask();
foreach my $feat (@cpufeatures) {
    if ($feat->{'vendor'}) {
	or_mask($all_vendors, $feat->{'depmask'});
    }
}

# CPU definition
sub c_($$@) {
    my($name, $help, @features) = @_;

    $name = lc($name);

    if (defined($cpu{$name})) {
	die "$0: multiple definitions of cpu $name\n";
    }

    my $cdef = {
	'name' => $name,
	'help' => $help
    };

    my $fm = empty_mask();

    my $found_vendor = 0;

    foreach my $fn (@features) {
	my $f = lc($fn);
	my $feat;
	my $minus = 0;
	if ($f =~ s/^\+//) {
	    $feat = $cpu{$f};
	} else {
	    $minus = ($f =~ s/^\-//);
	    $feat = $cpufeature{$f};
	}
	if (!defined($feat)) {
	    die "$0: unknown feature in cpu $name: $fn\n";
	}

	$found_vendor |= $feat->{'vendor'};

	if ($minus) {
	    clear_bit($fm, $feat->{'num'});
	} else {
	    or_mask($fm, $feat->{'depmask'});
	}
    }

    if (!$found_vendor) {
	or_mask($fm, $all_vendors);
    }

    $cdef->{'depmask'} = $fm;
    push(@cpus, $cdef);
    $cpu{$name} = $cdef;
}

# CPU alias (implement this later)
sub a_($$;$) { }

require 'x86/cpunames.ph';

my($outfile) = @ARGV;

open(my $out, '>', $outfile) or die "$0: $outfile: $!\n";

print $out "#ifndef X86_CPUNAMES_H\n";
print $out "#define X86_CPUNAMES_H 1\n\n";

print $out "#include \"featureinfo.h\"\n\n";

printf $out "extern const struct cpu_feature_info known_cpus[%d];\n\n",
    scalar(@cpus);

print $out "#endif\n\n";
print $out "#ifdef COMPILING_CPUNAMES_C\n\n";

printf $out "const struct cpu_feature_info known_cpus[%d] = {\n",
    scalar(@cpus);

foreach my $cpu (@cpus) {
    printf $out "    { \"%s\", \"%s\", -1U, {%s} },\n",
	$cpu->{'name'},
	$cpu->{'help'},
	join(',', map { sprintf('0x%08x', $_) } @{$cpu->{'depmask'}});
}
print $out "};\n\n";
print $out "#endif\n";
