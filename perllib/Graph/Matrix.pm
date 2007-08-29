package Graph::Matrix;

# $SIG{__DIE__ } = sub { use Carp; confess };
# $SIG{__WARN__} = sub { use Carp; confess };

use strict;

sub new {
    my ($class, $g) = @_;
    my @V = $g->vertices;
    my $V = @V;
    my %V; @V{ @V } = 0 .. $#V;
    bless [ [ map { [ ] } 0 .. $#V ], \%V ], $class;
}

sub set {
    my ($m, $u, $v, $val) = @_;
    my ($i, $j) = map { $m->[1]->{ $_ } } ($u, $v);
    $m->[0]->[$i]->[$j] = $val;
}

sub get {
    my ($m, $u, $v) = @_;
    my ($i, $j) = map { $m->[1]->{ $_ } } ($u, $v);
    $m->[0]->[$i]->[$j];
}

1;
__END__
=pod

=head1 NAME

Graph::Matrix - create and manipulate a V x V matrix of graph G

=head1 SYNOPSIS

    use Graph::Matrix;
    use Graph::Directed;
    my $g  = Graph::Directed->new;
    $g->add_...(); # build $g
    my $m = Graph::Matrix->new($g);
    $m->get($u, $v)
    $s->get($u, $v, $val)

=head1 DESCRIPTION

B<This module is meant for internal use by the Graph module.>

=head2 Class Methods

=over 4

=item new($g)

Construct a new Matrix from the Graph $g.

=back

=head2 Object Methods

=over 4

=item get($u, $v)

Return the value at the edge from $u to $v.

=item set($u, $v, $val)

Set the edge from $u to $v to value $val.

=back

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
