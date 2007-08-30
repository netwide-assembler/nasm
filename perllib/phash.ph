# -*- perl -*-
#
# Perfect Minimal Hash Generator written in Perl, which produces
# C output.
#
# Requires the CPAN Graph module (tested against 0.83)

use Graph::Undirected;


# Produce the same values every time, please...
srand(0);

#
# 32-bit rotate
#
sub rot($$) {
    my($v,$s) = @_;

    return (($v << $s)+($v >> (32-$s))) & 0xffffffff;
}

#
# Compute the prehash for a key
#
# prehash(key, sv, N)
#
sub prehash($$$) {
    my($key, $n, $sv) = @_;
    my $c;
    my $k1 = 0, $k2 = 0;
    my($s0, $s1, $s2, $s3) = @{$sv};

    foreach $c (unpack("C*", $key)) {
	$k1 = (rot($k1,$s0)-rot($k2, $s1)+$c) & 0xffffffff;
	$k2 = (rot($k2,$s2)-rot($k1, $s3)+$c) & 0xffffffff;
    }

    return ($k1 % $n, $k2 % $n);
}

#
# Shuffle a list.
#
sub shuffle(@) {
    my(@l) = @_;
    my($i, $j);
    my $tmp;

    for ($i = scalar(@l)-1; $i > 0; $i--) {
	$j = int(rand($i));
	
	$tmp = $l[$j];
	$l[$j] = $l[$i];
	$l[$i] = $tmp;
    }

    return @l;
}

#
# Pick a set of F-functions of length N.
#
# ffunc(N)
#
sub ffunc($) {
    my($n) = @_;

    return shuffle(0..$n-1);
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
# gen_hash_n(N, sv, \%data)
#
sub gen_hash_n($$$) {
    my($n, $sv, $href) = @_;
    my @keys = keys(%{$href});
    my $i, $sv, @f1, @f2, @g;
    my $gr;
    my $k, $v;

    @f1 = ffunc($n);
    @f2 = ffunc($n);

    $gr = Graph::Undirected->new;
    for ($i = 0; $i < $n; $i++) {
	$gr->add_vertex($i);
    }

    foreach $k (@keys) {
	my ($p1, $p2) = prehash($k, $n, $sv);
	my $pf1 = $f1[$p1];
	my $pf2 = $f2[$p2];
	my $e = ${$href}{$k};

	if ($gr->has_edge($pf1, $pf2)) {
	    my $xkey = $gr->get_edge_attribute($pf1, $pf2, "key");
	    my ($xp1, $xp2) = prehash($xkey, $n, $sv);
	    print STDERR "Collision: $pf1=$pf2 $k ($p1,$p2) with ";
	    print STDERR "$xkey ($xp1,$xp2)\n";
	    return;
	}

	# print STDERR "Edge $pf1=$pf2 value $e from $k ($p1,$p2)\n";

	$gr->add_edge($pf1, $pf2);
	$gr->set_edge_attribute($pf1, $pf2, "hash", $e);
	$gr->set_edge_attribute($pf1, $pf2, "key", $k);
    }

    # At this point, we're good if the graph is acyclic.
    if ($gr->is_cyclic) {
	print STDERR "Graph is cyclic\n";
	return;
    }

    # print STDERR "Graph:\n$gr\n";

    # Now we need to assign values to each vertex, so that for each
    # edge, the sum of the values for the two vertices give the value
    # for the edge (which is our hash index.)  Since the graph is
    # acyclic, this is always doable.
    for ($i = 0; $i < $n; $i++) {
	if (!$gr->has_vertex_attribute($i, "val")) {
	    walk_graph($gr,$i,0); # First vertex in a cluster
	}
	push(@g, $gr->get_vertex_attribute($i, "val"));
    }

    # for ($i = 0; $i < $n; $i++) {
    #	print STDERR "Vertex ", $i, ": ", $g[$i], "\n";
    # }

    print STDERR "Done: n = $n, sv = $sv\n";

    return ($n, $sv, \@f1, \@f2, \@g);
}

#
# Generate a random prehash vector
#
sub prehash_vector()
{
    return [int(rand(32)), int(rand(32)), int(rand(32)), int(rand(32))];
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

    # Minimal power of 2 value for N with enough wiggle room
    my $room = scalar(@keys)*1.3;
    $n = 1;
    while ($n < $room) {
	$n <<= 1;
    }

    $maxj = 512; # Number of times to try

    for ($i = 0; $i < 4; $i++) {
	print STDERR "Trying n = $n...\n";
	for ($j = 0; $j < $maxj; $j++) {
	    $sv = prehash_vector();
	    @hashinfo = gen_hash_n($n, $sv, $href);
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
    my ($n, $sv, $f1, $f2, $g) = @{$hashinfo};
    my $k;
    my $err = 0;

    print STDERR "Verify: n = $n, sv = $sv\n";

    foreach $k (keys(%$href)) {
	my ($p1, $p2) = prehash($k, $n, $sv);
	my $pf1 = ${$f1}[$p1];
	my $pf2 = ${$f2}[$p2];
	my $g1 = ${$g}[$pf1];
	my $g2 = ${$g}[$pf2];

	if ($g1+$g2 != ${$href}{$k}) {
	    printf STDERR "%s(%d,%d): %d=%d, %d+%d = %d != %d\n",
	    $k, $p1, $p2, $pf1, $pf2, $g1, $g2, $g1+$g2, ${$href}{$k};
	    $err = 1;
	} else {
	    # printf STDERR "%s: %d+%d = %d ok\n",
	    # $k, $g1, $g2, $g1+$g2;
	}
    }

    die "$0: hash validation error\n" if ($err);
}

1;
