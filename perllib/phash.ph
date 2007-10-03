# -*- perl -*-
#
# Perfect Minimal Hash Generator written in Perl, which produces
# C output.
#
# Requires the CPAN Graph module (tested against 0.81, 0.83, 0.84)
#

use Graph::Undirected;
require 'random_sv_vectors.ph';
require 'crc64.ph';

#
# Compute the prehash for a key
#
# prehash(key, sv, N)
#
sub prehash($$$) {
    my($key, $n, $sv) = @_;
    my @c = crc64($sv, $key);

    # Create a bipartite graph...
    $k1 = (($c[1] & ($n-1)) << 1) + 0; # low word
    $k2 = (($c[0] & ($n-1)) << 1) + 1; # high word

    return ($k1, $k2);
}

#
# Walk the assignment graph
#
sub walk_graph($$$) {
    my($gr,$n,$v) = @_;
    my $nx;

    # print STDERR "Vertex $n value $v\n";
    $gr->set_vertex_attribute($n,"val",$v);

    foreach $nx ($gr->neighbors($n)) {
	die unless ($gr->has_edge_attribute($n, $nx, "hash"));
	my $e = $gr->get_edge_attribute($n, $nx, "hash");

	# print STDERR "Edge $n=$nx value $e: ";

	if ($gr->has_vertex_attribute($nx, "val")) {
	    die if ($v+$gr->get_vertex_attribute($nx, "val") != $e);
	    # print STDERR "ok\n";
	} else {
	    walk_graph($gr, $nx, $e-$v);
	}
    }
}

#
# Generate the function assuming a given N.
#
# gen_hash_n(N, sv, \%data, run)
#
sub gen_hash_n($$$$) {
    my($n, $sv, $href, $run) = @_;
    my @keys = keys(%{$href});
    my $i, $sv, @g;
    my $gr;
    my $k, $v;
    my $gsize = 2*$n;

    $gr = Graph::Undirected->new;
    for ($i = 0; $i < $gsize; $i++) {
	$gr->add_vertex($i);
    }

    foreach $k (@keys) {
	my ($pf1, $pf2) = prehash($k, $n, $sv);
	my $e = ${$href}{$k};

	if ($gr->has_edge($pf1, $pf2)) {
	    my $xkey = $gr->get_edge_attribute($pf1, $pf2, "key");
	    my ($xp1, $xp2) = prehash($xkey, $n, $sv);
	    if (defined($run)) {
		print STDERR "$run: Collision: $pf1=$pf2 $k with ";
		print STDERR "$xkey ($xp1,$xp2)\n";
	    }
	    return;
	}

	# print STDERR "Edge $pf1=$pf2 value $e from $k\n";

	$gr->add_edge($pf1, $pf2);
	$gr->set_edge_attribute($pf1, $pf2, "hash", $e);
	$gr->set_edge_attribute($pf1, $pf2, "key", $k);
    }

    # At this point, we're good if the graph is acyclic.
    if ($gr->is_cyclic) {
	if (defined($run)) {
	    print STDERR "$run: Graph is cyclic\n";
	}
	return;
    }
    
    if (defined($run)) {
	print STDERR "$run: Graph OK, computing vertices...\n";
    }

    # Now we need to assign values to each vertex, so that for each
    # edge, the sum of the values for the two vertices give the value
    # for the edge (which is our hash index.)  Since the graph is
    # acyclic, this is always doable.
    for ($i = 0; $i < $gsize; $i++) {
	if ($gr->degree($i)) {
	    # This vertex has neighbors (is used)
	    if (!$gr->has_vertex_attribute($i, "val")) {
		walk_graph($gr,$i,0); # First vertex in a cluster
	    }
	    push(@g, $gr->get_vertex_attribute($i, "val"));
	} else {
	    # Unused vertex
	    push(@g, undef);
	}
    }

    # for ($i = 0; $i < $n; $i++) {
    #	print STDERR "Vertex ", $i, ": ", $g[$i], "\n";
    # }

    if (defined($run)) {
	printf STDERR "$run: Done: n = $n, sv = [0x%08x, 0x%08x]\n",
	$$sv[0], $$sv[1];
    }

    return ($n, $sv, \@g);
}

#
# Driver for generating the function
#
# gen_perfect_hash(\%data)
#
sub gen_perfect_hash($) {
    my($href) = @_;
    my @keys = keys(%{$href});
    my @hashinfo;
    my $n, $i, $j, $sv, $maxj;
    my $run = 1;

    # Minimal power of 2 value for N with enough wiggle room.
    # The scaling constant must be larger than 0.5 in order for the
    # algorithm to ever terminate.
    my $room = scalar(@keys)*0.7;
    $n = 1;
    while ($n < $room) {
	$n <<= 1;
    }

    # Number of times to try...
    $maxj = scalar @random_sv_vectors;

    for ($i = 0; $i < 4; $i++) {
	print STDERR "Trying n = $n...\n";
	for ($j = 0; $j < $maxj; $j++) {
	    $sv = $random_sv_vectors[$j];
	    @hashinfo = gen_hash_n($n, $sv, $href, $run++);
	    return @hashinfo if (defined(@hashinfo));
	}
	$n <<= 1;
	$maxj >>= 1;
    }

    return;
}

#
# Read input file
#
sub read_input() {
    my $key,$val;
    my %out;
    my $x = 0;

    while (defined($l = <STDIN>)) {
	chomp $l;
	$l =~ s/\s*(\#.*|)$//;
	
	next if ($l eq '');

	if ($l =~ /^([^=]+)\=([^=]+)$/) {
	    $out{$1} = $2;
	    $x = $2;
	} else {
	    $out{$l} = $x;
	}
	$x++;
    }

    return %out;
}

#
# Verify that the hash table is actually correct...
#
sub verify_hash_table($$)
{
    my ($href, $hashinfo) = @_;
    my ($n, $sv, $g) = @{$hashinfo};
    my $k;
    my $err = 0;

    foreach $k (keys(%$href)) {
	my ($pf1, $pf2) = prehash($k, $n, $sv);
	my $g1 = ${$g}[$pf1];
	my $g2 = ${$g}[$pf2];

	if ($g1+$g2 != ${$href}{$k}) {
	    printf STDERR "%s(%d,%d): %d+%d = %d != %d\n",
	    $k, $pf1, $pf2, $g1, $g2, $g1+$g2, ${$href}{$k};
	    $err = 1;
	} else {
	    # printf STDERR "%s: %d+%d = %d ok\n",
	    # $k, $g1, $g2, $g1+$g2;
	}
    }

    die "$0: hash validation error\n" if ($err);
}

1;
