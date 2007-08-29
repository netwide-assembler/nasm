package Graph::AdjacencyMap::Vertex;

# THIS IS INTERNAL IMPLEMENTATION ONLY, NOT TO BE USED DIRECTLY.
# THE INTERFACE IS HARD TO USE AND GOING TO STAY THAT WAY AND
# ALMOST GUARANTEED TO CHANGE OR GO AWAY IN FUTURE RELEASES.

use strict;

# $SIG{__DIE__ } = sub { use Carp; confess };
# $SIG{__WARN__} = sub { use Carp; confess };

use Graph::AdjacencyMap qw(:flags :fields);
use base 'Graph::AdjacencyMap';

use Scalar::Util qw(weaken);

sub _new {
    my ($class, $flags, $arity) = @_;
    bless [ 0, $flags, $arity ], $class;
}

require overload; # for de-overloading

sub __set_path {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    if (@_ != 1) {
	require Carp;
	Carp::confess(sprintf "Graph::AdjacencyMap::Vertex: arguments %d expected 1", scalar @_);
    }
    my $p;
    $p = $m->[ _s ] ||= { };
    my @p = $p;
    my @k;
    my $k = shift;
    my $q = ref $k && ($f & _REF) && overload::Method($k, '""') ? overload::StrVal($k) : $k;
    push @k, $q;
    return (\@p, \@k);
}

sub __set_path_node {
    my ($m, $p, $l) = splice @_, 0, 3;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    unless (exists $p->[-1]->{ $l }) {
	my $i = $m->_new_node( \$p->[-1]->{ $l }, $id );
	$m->[ _i ]->{ defined $i ? $i : "" } = $_[0];
    } else {
	$m->_inc_node( \$p->[-1]->{ $l }, $id );
    }
}

sub set_path {
    my $m = shift;
    my $f = $m->[ _f ];
    my ($p, $k) = $m->__set_path( @_ );
    return unless defined $p && defined $k;
    my $l = defined $k->[-1] ? $k->[-1] : "";
    my $set = $m->__set_path_node( $p, $l, @_ );
    return $set;
}

sub __has_path {
    my $m = shift;
    my $f = $m->[ _f ];
    if (@_ != 1) {
	require Carp;
	Carp::confess(sprintf
		      "Graph::AdjacencyMap: arguments %d expected 1\n",
		      scalar @_);
    }
    my $p = $m->[ _s ];
    return unless defined $p;
    my @p = $p;
    my @k;
    my $k = shift;
    my $q = ref $k && ($f & _REF) && overload::Method($k, '""') ? overload::StrVal($k) : $k;
    push @k, $q;
    return (\@p, \@k);
}

sub has_path {
    my $m = shift;
    my ($p, $k) = $m->__has_path( @_ );
    return unless defined $p && defined $k;
    return exists $p->[-1]->{ defined $k->[-1] ? $k->[-1] : "" };
}

sub has_path_by_multi_id {
    my $m = shift;
    my $id = pop;
    my ($e, $n) = $m->__get_path_node( @_ );
    return undef unless $e;
    return exists $n->[ _nm ]->{ $id };
}

sub _get_path_id {
    my $m = shift;
    my $f = $m->[ _f ];
    my ($e, $n) = $m->__get_path_node( @_ );
    return undef unless $e;
    return ref $n ? $n->[ _ni ] : $n;
}

sub _get_path_count {
    my $m = shift;
    my $f = $m->[ _f ];
    my ($e, $n) = $m->__get_path_node( @_ );
    return 0 unless $e && defined $n;
    return
	($f & _COUNT) ? $n->[ _nc ] :
	($f & _MULTI) ? scalar keys %{ $n->[ _nm ] } : 1;
}

sub __attr {
    my $m = shift;
    if (@_ && ref $_[0] && @{ $_[0] } != $m->[ _a ]) {
	require Carp;
	Carp::confess(sprintf "Graph::AdjacencyMap::Vertex: arguments %d expected %d",
		      scalar @{ $_[0] }, $m->[ _a ]);
    }
}

sub _get_id_path {
    my ($m, $i) = @_;
    return defined $m->[ _i ] ? $m->[ _i ]->{ $i } : undef;
}

sub del_path {
    my $m = shift;
    my $f = $m->[ _f ];
    my ($e, $n, $p, $k, $l) = $m->__get_path_node( @_ );
    return unless $e;
    my $c = ($f & _COUNT) ? --$n->[ _nc ] : 0;
    if ($c == 0) {
	delete $m->[ _i ]->{ ref $n ? $n->[ _ni ] : $n };
	delete $p->[ -1 ]->{ $l };
    }
    return 1;
}

sub del_path_by_multi_id {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop;
    my ($e, $n, $p, $k, $l) = $m->__get_path_node( @_ );
    return unless $e;
    delete $n->[ _nm ]->{ $id };
    unless (keys %{ $n->[ _nm ] }) {
	delete $m->[ _i ]->{ $n->[ _ni ] };
	delete $p->[-1]->{ $l };
    }
    return 1;
}

sub paths {
    my $m = shift;
    return map { [ $_ ] } values %{ $m->[ _i ] } if defined $m->[ _i ];
    wantarray ? ( ) : 0;
}

1;
=pod

=head1 NAME

Graph::AdjacencyMap - create and a map of graph vertices or edges

=head1 SYNOPSIS

    Internal.

=head1 DESCRIPTION

B<This module is meant for internal use by the Graph module.>

=head2 Object Methods

=over 4

=item del_path(@id)

Delete a Map path by ids.

=item del_path_by_multi_id($id)

Delete a Map path by a multi(vertex) id.

=item has_path(@id)

Return true if the Map has the path by ids, false if not.

=item has_path_by_multi_id($id)

Return true ifd the a Map has the path by a multi(vertex) id, false if not.

=item paths

Return all the paths of the Map.

=item set_path(@id)

Set the path by @ids.

=back

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
