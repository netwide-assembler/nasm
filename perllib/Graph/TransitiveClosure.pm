package Graph::TransitiveClosure;

# COMMENT THESE OUT FOR TESTING AND PRODUCTION.
# $SIG{__DIE__ } = sub { use Carp; confess };
# $SIG{__WARN__} = sub { use Carp; confess };

use base 'Graph';
use Graph::TransitiveClosure::Matrix;

sub _G () { Graph::_G() }

sub new {
    my ($class, $g, %opt) = @_;
    $g->expect_non_multiedged;
    %opt = (path_vertices => 1) unless %opt;
    my $attr = Graph::_defattr();
    if (exists $opt{ attribute_name }) {
	$attr = $opt{ attribute_name };
	# No delete $opt{ attribute_name } since we need to pass it on.
    }
    $opt{ reflexive } = 1 unless exists $opt{ reflexive };
    my $tcm = $g->new( $opt{ reflexive } ?
		       ( vertices => [ $g->vertices ] ) : ( ) );
    my $tcg = $g->get_graph_attribute('_tcg');
    if (defined $tcg && $tcg->[ 0 ] == $g->[ _G ]) {
	$tcg = $tcg->[ 1 ];
    } else {
	$tcg = Graph::TransitiveClosure::Matrix->new($g, %opt);
	$g->set_graph_attribute('_tcg', [ $g->[ _G ], $tcg ]);
    }
    my $tcg00 = $tcg->[0]->[0];
    my $tcg11 = $tcg->[1]->[1];
    for my $u ($tcg->vertices) {
	my $tcg00i = $tcg00->[ $tcg11->{ $u } ];
	for my $v ($tcg->vertices) {
	    next if $u eq $v && ! $opt{ reflexive };
	    my $j = $tcg11->{ $v };
	    if (
		# $tcg->is_transitive($u, $v)
		# $tcg->[0]->get($u, $v)
		vec($tcg00i, $j, 1)
	       ) {
		my $val = $g->_get_edge_attribute($u, $v, $attr);
		$tcm->_set_edge_attribute($u, $v, $attr,
					  defined $val ? $val :
					  $u eq $v ?
					  0 : 1);
	    }
	}
    }
    $tcm->set_graph_attribute('_tcm', $tcg);
    bless $tcm, $class;
}

sub is_transitive {
    my $g = shift;
    Graph::TransitiveClosure::Matrix::is_transitive($g);
}

1;
__END__
=pod

Graph::TransitiveClosure - create and query transitive closure of graph

=head1 SYNOPSIS

    use Graph::TransitiveClosure;
    use Graph::Directed; # or Undirected

    my $g  = Graph::Directed->new;
    $g->add_...(); # build $g

    # Compute the transitive closure graph.
    my $tcg = Graph::TransitiveClosure->new($g);
    $tcg->is_reachable($u, $v) # Identical to $tcg->has_edge($u, $v)

    # Being reflexive is the default, meaning that null transitions
    # (transitions from a vertex to the same vertex) are included.
    my $tcg = Graph::TransitiveClosure->new($g, reflexive => 1);
    my $tcg = Graph::TransitiveClosure->new($g, reflexive => 0);

    # is_reachable(u, v) is always reflexive.
    $tcg->is_reachable($u, $v)

    # The reflexivity of is_transitive(u, v) depends of the reflexivity
    # of the transitive closure.
    $tcg->is_transitive($u, $v)

    # You can check any graph for transitivity.
    $g->is_transitive()

    my $tcg = Graph::TransitiveClosure->new($g, path_length => 1);
    $tcg->path_length($u, $v)

    # path_vertices is automatically always on so this is a no-op.
    my $tcg = Graph::TransitiveClosure->new($g, path_vertices => 1);
    $tcg->path_vertices($u, $v)

    # Both path_length and path_vertices.
    my $tcg = Graph::TransitiveClosure->new($g, path => 1);
    $tcg->path_vertices($u, $v)
    $tcg->length($u, $v)

    my $tcg = Graph::TransitiveClosure->new($g, attribute_name => 'length');
    $tcg->path_length($u, $v)

=head1 DESCRIPTION

You can use C<Graph::TransitiveClosure> to compute the transitive
closure graph of a graph and optionally also the minimum paths
(lengths and vertices) between vertices, and after that query the
transitiveness between vertices by using the C<is_reachable()> and
C<is_transitive()> methods, and the paths by using the
C<path_length()> and C<path_vertices()> methods.

For further documentation, see the L<Graph::TransitiveClosure::Matrix>.

=head2 Class Methods

=over 4

=item new($g, %opt)

Construct a new transitive closure object.  Note that strictly speaking
the returned object is not a graph; it is a graph plus other stuff.  But
you should be able to use it as a graph plus a couple of methods inherited
from the Graph::TransitiveClosure::Matrix class.

=back

=head2 Object Methods

These are only the methods 'native' to the class: see
L<Graph::TransitiveClosure::Matrix> for more.

=over 4

=item is_transitive($g)

Return true if the Graph $g is transitive.

=item transitive_closure_matrix

Return the transitive closure matrix of the transitive closure object.

=back

=head2 INTERNALS

The transitive closure matrix is stored as an attribute of the graph
called C<_tcm>, and any methods not found in the graph class are searched
in the transitive closure matrix class. 

=cut
