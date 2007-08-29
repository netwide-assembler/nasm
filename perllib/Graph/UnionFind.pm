package Graph::UnionFind;

use strict;

sub _PARENT  () { 0 }
sub _RANK    () { 1 }

sub new {
    my $class = shift;
    bless { }, $class;
}

sub add {
    my ($self, $elem) = @_;
    $self->{ $elem } = [ $elem, 0 ];
}

sub has {
    my ($self, $elem) = @_;
    exists $self->{ $elem };
}

sub _parent {
    return undef unless defined $_[1];
    if (@_ == 2) {
	exists $_[0]->{ $_[ 1 ] } ? $_[0]->{ $_[1] }->[ _PARENT ] : undef;
    } elsif (@_ == 3) {
	$_[0]->{ $_[1] }->[ _PARENT ] = $_[2];
    } else {
	require Carp;
	Carp::croak(__PACKAGE__ . "::_parent: bad arity");
    }
}

sub _rank {
    return unless defined $_[1];
    if (@_ == 2) {
	exists $_[0]->{ $_[1] } ? $_[0]->{ $_[1] }->[ _RANK ] : undef;
    } elsif (@_ == 3) {
	$_[0]->{ $_[1] }->[ _RANK ] = $_[2];
    } else {
	require Carp;
	Carp::croak(__PACKAGE__ . "::_rank: bad arity");
    }
}

sub find {
    my ($self, $x) = @_;
    my $px = $self->_parent( $x );
    return unless defined $px;
    $self->_parent( $x, $self->find( $px ) ) if $px ne $x;
    $self->_parent( $x );
}

sub union {
    my ($self, $x, $y) = @_;
    $self->add($x) unless $self->has($x);
    $self->add($y) unless $self->has($y);
    my $px = $self->find( $x );
    my $py = $self->find( $y );
    return if $px eq $py;
    my $rx = $self->_rank( $px );
    my $ry = $self->_rank( $py );
    # print "union($x, $y): px = $px, py = $py, rx = $rx, ry = $ry\n";
    if ( $rx > $ry ) {
	$self->_parent( $py, $px );
    } else {
	$self->_parent( $px, $py );
	$self->_rank( $py, $ry + 1 ) if $rx == $ry;
    }
}

sub same {
    my ($uf, $u, $v) = @_;
    my $fu = $uf->find($u);
    return undef unless defined $fu;
    my $fv = $uf->find($v);
    return undef unless defined $fv;
    $fu eq $fv;
}

1;
__END__
=pod

=head1 NAME

Graph::UnionFind - union-find data structures

=head1 SYNOPSIS

    use Graph::UnionFind;
    my $uf = Graph::UnionFind->new;

    # Add the vertices to the data structure.
    $uf->add($u);
    $uf->add($v);

    # Join the partitions of the vertices.
    $uf->union( $u, $v );

    # Find the partitions the vertices belong to
    # in the union-find data structure.  If they
    # are equal, they are in the same partition.
    # If the vertex has not been seen,
    # undef is returned.
    my $pu = $uf->find( $u );
    my $pv = $uf->find( $v );
    $uf->same($u, $v) # Equal to $pu eq $pv. 

    # Has the union-find seen this vertex?
    $uf->has( $v )

=head1 DESCRIPTION

I<Union-find> is a special data structure that can be used to track the
partitioning of a set into subsets (a problem known also as I<disjoint sets>).

Graph::UnionFind() is used for Graph::connected_components(),
Graph::connected_component(), and Graph::same_connected_components()
if you specify a true C<union_find> parameter when you create an undirected
graph.

Note that union-find is one way: you cannot (easily) 'ununion'
vertices once you have 'unioned' them.  This means that if you
delete edges from a C<union_find> graph, you will get wrong results
from the Graph::connected_components(), Graph::connected_component(),
and Graph::same_connected_components().

=head2 API

=over 4

=item add

    $uf->add($v)

Add the vertex v to the union-find.

=item union

    $uf->union($u, $v)

Add the edge u-v to the union-find.  Also implicitly adds the vertices.

=item has

    $uf->has($v)

Return true if the vertex v has been added to the union-find, false otherwise.

=item find

    $uf->find($v)

Return the union-find partition the vertex v belongs to,
or C<undef> if it has not been added.

=item new

    $uf = Graph::UnionFind->new()

The constructor.

=item same

    $uf->same($u, $v)

Return true of the vertices belong to the same union-find partition
the vertex v belongs to, false otherwise.

=back

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut

