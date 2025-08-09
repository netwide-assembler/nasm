# -*- perl -*-
#
# CPU feature sets and their dependencies.
#

use integer;
use strict;

our %cpufeature;	# cpu features by name
our @cpufeatures;	# List of cpu features in numeric order
our @cpus;

# Make a name into a valid upper case C identifier suffix
sub cname($) {
    my($n) = @_;
    $n = uc($n);
    $n =~ s/[^\w]/_/g;
    $n =~ s/__+/_/g;
    return $n;
}

# Create a new CPU feature flag
sub f_($;$@) {
    my($name, $help, @deplist) = @_;

    $name = lc($name);
    if (!defined($help)) {
	$help = uc($name)." instruction";
    }

    my $feat = {
	'name'  => $name,
	'cname' => cname($name),
	'help'  => $help,
	'_dep'  => {$name => 1}, # All features "depend" on themselves
	'num'   => scalar(@cpufeatures),
	'vendor' => 0
    };
    $cpufeature{$name} = $feat;
    push(@cpufeatures, $feat);

    d_($name, @deplist);
    return $feat;
}

# Add dependencies to a CPU feature
sub d_($@) {
    my($name, @deplist) = @_;

    $name = lc($name);
    my $feat = $cpufeature{$name};
    if (!defined($feat)) {
	die "$0: tried to add dependencies to nonexistent cpu feature \U$name\E \n";
    }

    my $_dep = $feat->{'_dep'};
    foreach my $d (@deplist) {
	$_dep->{lc($d)} = 1;
    }
}

# The actual feature list
require 'x86/features.ph'

#
# Vendor flags
#
foreach my $v (qw(Cyrix AMD Intel)) {
    my $feat = f_($v, "$v-specific instructions", qw(vendor));
    $feat->{'vendor'} = 1;
}

#
# Some automatically generated dependencies
#
foreach my $fn (keys(%cpufeature)) {
    my $feat = $cpufeature{$fn};
    my $name = $feat->{'name'};

    if ($fn =~ /^avx512.+$/) {
	d_('avx512', $name);
    } elsif ($fn =~ /^avx.+$/) {
	d_($name, 'avx');
    }

    if ($fn =~ /^apx.+$/) {
	d_('apx', $name);
    }
}

#
# Compute the transitive closure and produce dependencies as a list of
# references as opposed to names.
#
# Although a circular dependency isn't incorrect as such, it also means
# that all the CPU features in the circle are in fact identical, and so
# they should be merged into one feature bit.
#
sub _cpufeature_closure($;@) {
    my($feat, @stack) = @_;
    my $name = $feat->{'name'};
    my $dep  = $feat->{'_dep'};

    my @_deps = keys(%$dep);

    if (defined($feat->{'deps'})) {
	return @_deps;
    } elsif (exists($feat->{'deps'})) {
	my $list = join(', ', map { $_->{'name'} } ($feat, @stack));
	die "$0: circular depencency for CPU features $list\n";
    }

    # Mark this as in progress for loop detection
    $feat->{'deps'} = undef;

    # For better error messages
    push(@stack, $feat);

    foreach my $depname (@_deps) {
	next if ($depname eq $name);
	my $cfeat = $cpufeature{$depname};
	if (!defined($cfeat)) {
	    die "$0: feature $name depends on non-existent feature $depname\n";
	}
	foreach my $cdep (_cpufeature_closure($cfeat, @stack)) {
	    $dep->{$cdep}++;
	}
    }

    @_deps = keys(%$dep);	# Update with the closure

    my $deps = [sort { $a->{'num'} <=> $b->{'num'} }
		map { $cpufeature{$_} } @_deps];

    return $feat->{'deps'} = $deps;
}

foreach my $feat (@cpufeatures) {
    _cpufeature_closure($feat);
}

#
# Create the anti-depency mask, that is, the list of features to be removed
# when a certain feature is removed, too.
#
foreach my $feat (@cpufeatures) {
    $feat->{'nuke'} = [];
}
foreach my $feat (@cpufeatures) {
    foreach my $dep (@{$feat->{'deps'}}) {
	push(@{$dep->{'nuke'}}, $feat);
    }
}

#
# Create bitmasks from lists
#
our $cpufeature_bits  = $cpufeatures[-1]->{'num'} + 1;
our $cpufeature_words = ($cpufeature_bits + 31) >> 5;

sub set_bits(\@@) {
    my $words = shift(@_);

    foreach my $n (@_) {
	$words->[$n >> 5] |= 1 << ($n & 31);
    }

    return $words;
}

sub makemask($$) {
    my($feat, $field) = @_;
    my $fw = [(0) x $cpufeature_words];
    set_bits(@$fw, map { $_->{'num'} } @{$feat->{$field}});
    return $fw;
}

foreach my $feat (@cpufeatures) {
    $feat->{'depmask'} = makemask($feat, 'deps');
    $feat->{'badmask'} = makemask($feat, 'nuke');
}

1;
