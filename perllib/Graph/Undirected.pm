package Graph::Undirected;

use Graph;
use base 'Graph';
use strict;

=pod

=head1 NAME

Graph::Undirected - undirected graphs

=head1 SYNOPSIS

    use Graph::Undirected;
    my $g = Graph::Undirected->new;

    # Or alternatively:

    use Graph;
    my $g = Graph->new(undirected => 1);
    my $g = Graph->new(directed => 0);

=head1 DESCRIPTION

Graph::Undirected allows you to create undirected graphs.

For the available methods, see L<Graph>.

=head1 SEE ALSO

L<Graph>, L<Graph::Directed>

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut

sub new {
    my $class = shift;
    bless Graph->new(undirected => 1, @_), ref $class || $class;
}

1;
