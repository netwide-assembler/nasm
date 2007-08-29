package Graph::Traversal::BFS;

use strict;

use Graph::Traversal;
use base 'Graph::Traversal';

sub current {
    my $self = shift;
    $self->{ order }->[ 0 ];
}

sub see {
    my $self = shift;
    shift @{ $self->{ order } };
}

*bfs = \&Graph::Traversal::postorder;

1;
__END__
=pod

=head1 NAME

Graph::Traversal::BFS - breadth-first traversal of graphs

=head1 SYNOPSIS

    use Graph;
    my $g = Graph->new;
    $g->add_edge(...);
    use Graph::Traversal::BFS;
    my $b = Graph::Traversal::BFS->new(%opt);
    $b->bfs; # Do the traversal.

=head1 DESCRIPTION

With this class one can traverse a Graph in breadth-first order.

The callback parameters %opt are explained in L<Graph::Traversal>.

=head2 Methods

The following methods are available:

=over 4

=item dfs

Traverse the graph in depth-first order.

=back

=head1 SEE ALSO

L<Graph::Traversal>, L<Graph::Traversal::DFS>, L<Graph>.

=cut
