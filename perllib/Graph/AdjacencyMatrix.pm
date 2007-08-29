package Graph::AdjacencyMatrix;

use strict;

use Graph::BitMatrix;
use Graph::Matrix;

use base 'Graph::BitMatrix';

use Graph::AdjacencyMap qw(:flags :fields);

sub _V () { 2 } # Graph::_V
sub _E () { 3 } # Graph::_E

sub new {
    my ($class, $g, %opt) = @_;
    my $n;
    my @V = $g->vertices;
    my $want_distance;
    if (exists $opt{distance_matrix}) {
	$want_distance = $opt{distance_matrix};
	delete $opt{distance_matrix};
    }
    my $d = Graph::_defattr();
    if (exists $opt{attribute_name}) {
	$d = $opt{attribute_name};
	$want_distance++;
    }
    delete $opt{attribute_name};
    my $want_transitive = 0;
    if (exists $opt{is_transitive}) {
	$want_transitive = $opt{is_transitive};
	delete $opt{is_transitive};
    }
    Graph::_opt_unknown(\%opt);
    if ($want_distance) {
	$n = Graph::Matrix->new($g);
	for my $v (@V) { $n->set($v, $v, 0) }
    }
    my $m = Graph::BitMatrix->new($g, connect_edges => $want_distance);
    if ($want_distance) {
	# for my $u (@V) {
	#     for my $v (@V) {
	#         if ($g->has_edge($u, $v)) {
	#             $n->set($u, $v,
	#                    $g->get_edge_attribute($u, $v, $d));
        #        }
        #     }
        # }
	my $Vi = $g->[_V]->[_i];
	my $Ei = $g->[_E]->[_i];
	my %V; @V{ @V } = 0 .. $#V;
	my $n0 = $n->[0];
	my $n1 = $n->[1];
	if ($g->is_undirected) {
	    for my $e (keys %{ $Ei }) {
		my ($i0, $j0) = @{ $Ei->{ $e } };
		my $i1 = $V{ $Vi->{ $i0 } };
		my $j1 = $V{ $Vi->{ $j0 } };
		my $u = $V[ $i1 ];
		my $v = $V[ $j1 ];
		$n0->[ $i1 ]->[ $j1 ] = 
		    $g->get_edge_attribute($u, $v, $d);
		$n0->[ $j1 ]->[ $i1 ] =
		    $g->get_edge_attribute($v, $u, $d);
	    }
	} else {
	    for my $e (keys %{ $Ei }) {
		my ($i0, $j0) = @{ $Ei->{ $e } };
		my $i1 = $V{ $Vi->{ $i0 } };
		my $j1 = $V{ $Vi->{ $j0 } };
		my $u = $V[ $i1 ];
		my $v = $V[ $j1 ];
		$n0->[ $i1 ]->[ $j1 ] =
		    $g->get_edge_attribute($u, $v, $d);
	    }
	}
    }
    bless [ $m, $n, [ @V ] ], $class;
}

sub adjacency_matrix {
    my $am = shift;
    $am->[0];
}

sub distance_matrix {
    my $am = shift;
    $am->[1];
}

sub vertices {
    my $am = shift;
    @{ $am->[2] };
}

sub is_adjacent {
    my ($m, $u, $v) = @_;
    $m->[0]->get($u, $v) ? 1 : 0;
}

sub distance {
    my ($m, $u, $v) = @_;
    defined $m->[1] ? $m->[1]->get($u, $v) : undef;
}

1;
__END__
=pod

=head1 NAME

Graph::AdjacencyMatrix - create and query the adjacency matrix of graph G

=head1 SYNOPSIS

    use Graph::AdjacencyMatrix;
    use Graph::Directed; # or Undirected

    my $g  = Graph::Directed->new;
    $g->add_...(); # build $g

    my $am = Graph::AdjacencyMatrix->new($g);
    $am->is_adjacent($u, $v)

    my $am = Graph::AdjacencyMatrix->new($g, distance_matrix => 1);
    $am->distance($u, $v)

    my $am = Graph::AdjacencyMatrix->new($g, attribute_name => 'length');
    $am->distance($u, $v)

    my $am = Graph::AdjacencyMatrix->new($g, ...);
    my @V  = $am->vertices();

=head1 DESCRIPTION

You can use C<Graph::AdjacencyMatrix> to compute the adjacency matrix
and optionally also the distance matrix of a graph, and after that
query the adjacencyness between vertices by using the C<is_adjacent()>
method, or query the distance between vertices by using the
C<distance()> method.

By default the edge attribute used for distance is C<w>, but you
can change that in new(), see below.

If you modify the graph after creating the adjacency matrix of it,
the adjacency matrix and the distance matrix may become invalid.

=head1 Methods

=head2 Class Methods

=over 4

=item new($g)

Construct the adjacency matrix of the graph $g.

=item new($g, options)

Construct the adjacency matrix of the graph $g with options as a hash.
The known options are

=over 8

=item distance_matrix => boolean

By default only the adjacency matrix is computed.  To compute also the
distance matrix, use the attribute C<distance_matrix> with a true value
to the new() constructor.

=item attribute_name => attribute_name

By default the edge attribute used for distance is C<w>.  You can
change that by giving another attribute name with the C<attribute_name>
attribute to new() constructor.  Using this attribute also implicitly
causes the distance matrix to be computed.

=back

=back

=head2 Object Methods

=over 4

=item is_adjacent($u, $v)

Return true if the vertex $v is adjacent to vertex $u, or false if not.

=item distance($u, $v)

Return the distance between the vertices $u and $v, or C<undef> if
the vertices are not adjacent.

=item adjacency_matrix

Return the adjacency matrix itself (a list of bitvector scalars).

=item vertices

Return the list of vertices (useful for indexing the adjacency matrix).

=back

=head1 ALGORITHM

The algorithm used to create the matrix is two nested loops, which is
O(V**2) in time, and the returned matrices are O(V**2) in space.

=head1 SEE ALSO

L<Graph::TransitiveClosure>, L<Graph::BitMatrix>

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
