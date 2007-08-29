package Graph::Directed;

use Graph;
use base 'Graph';
use strict;

=pod

=head1 NAME

Graph::Directed - directed graphs

=head1 SYNOPSIS

    use Graph::Directed;
    my $g = Graph::Directed->new;

    # Or alternatively:

    use Graph;
    my $g = Graph->new(directed => 1);
    my $g = Graph->new(undirected => 0);

=head1 DESCRIPTION

Graph::Directed allows you to create directed graphs.

For the available methods, see L<Graph>.

=head1 SEE ALSO

L<Graph>, L<Graph::Undirected>

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut

1;
