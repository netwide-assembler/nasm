package Graph::BitMatrix;

use strict;

# $SIG{__DIE__ } = sub { use Carp; confess };
# $SIG{__WARN__} = sub { use Carp; confess };

sub _V () { 2 } # Graph::_V()
sub _E () { 3 } # Graph::_E()
sub _i () { 3 } # Index to path.
sub _s () { 4 } # Successors / Path to Index.

sub new {
    my ($class, $g, %opt) = @_;
    my @V = $g->vertices;
    my $V = @V;
    my $Z = "\0" x (($V + 7) / 8);
    my %V; @V{ @V } = 0 .. $#V;
    my $bm = bless [ [ ( $Z ) x $V ], \%V ], $class;
    my $bm0 = $bm->[0];
    my $connect_edges;
    if (exists $opt{connect_edges}) {
	$connect_edges = $opt{connect_edges};
	delete $opt{connect_edges};
    }
    $connect_edges = 1 unless defined $connect_edges;
    Graph::_opt_unknown(\%opt);
    if ($connect_edges) {
	# for (my $i = 0; $i <= $#V; $i++) {
	#    my $u = $V[$i];
	#    for (my $j = 0; $j <= $#V; $j++) {
	#	vec($bm0->[$i], $j, 1) = 1 if $g->has_edge($u, $V[$j]);
	#    }
	# }
	my $Vi = $g->[_V]->[_i];
	my $Ei = $g->[_E]->[_i];
	if ($g->is_undirected) {
	    for my $e (keys %{ $Ei }) {
		my ($i0, $j0) = @{ $Ei->{ $e } };
		my $i1 = $V{ $Vi->{ $i0 } };
		my $j1 = $V{ $Vi->{ $j0 } };
		vec($bm0->[$i1], $j1, 1) = 1;
		vec($bm0->[$j1], $i1, 1) = 1;
	    }
	} else {
	    for my $e (keys %{ $Ei }) {
		my ($i0, $j0) = @{ $Ei->{ $e } };
		vec($bm0->[$V{ $Vi->{ $i0 } }], $V{ $Vi->{ $j0 } }, 1) = 1;
	    }
	}
    }
    return $bm;
}

sub set {
    my ($m, $u, $v) = @_;
    my ($i, $j) = map { $m->[1]->{ $_ } } ($u, $v);
    vec($m->[0]->[$i], $j, 1) = 1 if defined $i && defined $j;
}

sub unset {
    my ($m, $u, $v) = @_;
    my ($i, $j) = map { $m->[1]->{ $_ } } ($u, $v);
    vec($m->[0]->[$i], $j, 1) = 0 if defined $i && defined $j;
}

sub get {
    my ($m, $u, $v) = @_;
    my ($i, $j) = map { $m->[1]->{ $_ } } ($u, $v);
    defined $i && defined $j ? vec($m->[0]->[$i], $j, 1) : undef;
}

sub set_row {
    my ($m, $u) = splice @_, 0, 2;
    my $m0 = $m->[0];
    my $m1 = $m->[1];
    my $i = $m1->{ $u };
    return unless defined $i;
    for my $v (@_) {
	my $j = $m1->{ $v };
	vec($m0->[$i], $j, 1) = 1 if defined $j;
    }
}

sub unset_row {
    my ($m, $u) = splice @_, 0, 2;
    my $m0 = $m->[0];
    my $m1 = $m->[1];
    my $i = $m1->{ $u };
    return unless defined $i;
    for my $v (@_) {
	my $j = $m1->{ $v };
	vec($m0->[$i], $j, 1) = 0 if defined $j;
    }
}

sub get_row {
    my ($m, $u) = splice @_, 0, 2;
    my $m0 = $m->[0];
    my $m1 = $m->[1];
    my $i = $m1->{ $u };
    return () x @_ unless defined $i;
    my @r;
    for my $v (@_) {
	my $j = $m1->{ $v };
	push @r, defined $j ? (vec($m0->[$i], $j, 1) ? 1 : 0) : undef;
    }
    return @r;
}

sub vertices {
    my ($m, $u, $v) = @_;
    keys %{ $m->[1] };
}

1;
__END__
=pod

=head1 NAME

Graph::BitMatrix - create and manipulate a V x V bit matrix of graph G

=head1 SYNOPSIS

    use Graph::BitMatrix;
    use Graph::Directed;
    my $g  = Graph::Directed->new;
    $g->add_...(); # build $g
    my $m = Graph::BitMatrix->new($g, %opt);
    $m->get($u, $v)
    $m->set($u, $v)
    $m->unset($u, $v)
    $m->get_row($u, $v1, $v2, ..., $vn)
    $m->set_row($u, $v1, $v2, ..., $vn)
    $m->unset_row($u, $v1, $v2, ..., $vn)
    $a->vertices()

=head1 DESCRIPTION

This class enables creating bit matrices that compactly describe
the connected of the graphs.

=head2 Class Methods

=over 4

=item new($g)

Create a bit matrix from a Graph $g.  The C<%opt>, if present,
can have the following options:

=over 8

=item *

connect_edges

If true or if not present, set the bits in the bit matrix that
correspond to edges.  If false, do not set any bits.  In either
case the bit matrix of V x V bits is allocated.

=back

=back

=head2 Object Methods

=over 4

=item get($u, $v)

Return true if the bit matrix has a "one bit" between the vertices
$u and $v; in other words, if there is (at least one) a vertex going from
$u to $v.  If there is no vertex and therefore a "zero bit", return false.

=item set($u, $v)

Set the bit between the vertices $u and $v; in other words, connect
the vertices $u and $v by an edge.  The change does not get mirrored
back to the original graph.  Returns nothing.

=item unset($u, $v)

Unset the bit between the vertices $u and $v; in other words, disconnect
the vertices $u and $v by an edge.  The change does not get mirrored
back to the original graph.  Returns nothing.

=item get_row($u, $v1, $v2, ..., $vn)

Test the row at vertex C<u> for the vertices C<v1>, C<v2>, ..., C<vn>
Returns a list of I<n> truth values.

=item set_row($u, $v1, $v2, ..., $vn)

Sets the row at vertex C<u> for the vertices C<v1>, C<v2>, ..., C<vn>,
in other words, connects the vertex C<u> to the vertices C<vi>.
The changes do not get mirrored back to the original graph.
Returns nothing.

=item unset_row($u, $v1, $v2, ..., $vn)

Unsets the row at vertex C<u> for the vertices C<v1>, C<v2>, ..., C<vn>,
in other words, disconnects the vertex C<u> from the vertices C<vi>.
The changes do not get mirrored back to the original graph.
Returns nothing.

=item vertices

Return the list of vertices in the bit matrix.

=back

=head1 ALGORITHM

The algorithm used to create the matrix is two nested loops, which is
O(V**2) in time, and the returned matrices are O(V**2) in space.

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
