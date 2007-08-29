package Graph::AdjacencyMap;

use strict;

require Exporter;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS);
@ISA = qw(Exporter);
@EXPORT_OK   = qw(_COUNT _MULTI _COUNTMULTI _GEN_ID
		  _HYPER _UNORD _UNIQ _REF _UNORDUNIQ _UNIONFIND _LIGHT
		  _n _f _a _i _s _p _g _u _ni _nc _na _nm);
%EXPORT_TAGS =
    (flags =>  [qw(_COUNT _MULTI _COUNTMULTI _GEN_ID
		   _HYPER _UNORD _UNIQ _REF _UNORDUNIQ _UNIONFIND _LIGHT)],
     fields => [qw(_n _f _a _i _s _p _g _u _ni _nc _na _nm)]);

sub _COUNT      () {  0x00000001   }
sub _MULTI      () {  0x00000002   }
sub _COUNTMULTI () { _COUNT|_MULTI }
sub _HYPER      () {  0x00000004   }
sub _UNORD      () {  0x00000008   }
sub _UNIQ       () {  0x00000010   }
sub _REF        () {  0x00000020   }
sub _UNORDUNIQ  () { _UNORD|_UNIQ  }
sub _UNIONFIND  () {  0x00000040   }
sub _LIGHT      () {  0x00000080   }

my $_GEN_ID = 0;

sub _GEN_ID () { \$_GEN_ID }

sub _ni () { 0 } # Node index.
sub _nc () { 1 } # Node count.
sub _na () { 2 } # Node attributes.
sub _nm () { 3 } # Node map.

sub _n () { 0 } # Next id.
sub _f () { 1 } # Flags.
sub _a () { 2 } # Arity.
sub _i () { 3 } # Index to path.
sub _s () { 4 } # Successors / Path to Index.
sub _p () { 5 } # Predecessors.
sub _g () { 6 } # Graph (AdjacencyMap::Light)

sub _V () { 2 }  # Graph::_V()

sub _new {
    my $class = shift;
    my $map = bless [ 0, @_ ], $class;
    return $map;
}

sub _ids {
    my $m = shift;
    return $m->[ _i ];
}

sub has_paths {
    my $m = shift;
    return defined $m->[ _i ] && keys %{ $m->[ _i ] };
}

sub _dump {
    my $d = Data::Dumper->new([$_[0]],[ref $_[0]]);
    defined wantarray ? $d->Dump : print $d->Dump;
}

sub _del_id {
    my ($m, $i) = @_;
    my @p = $m->_get_id_path( $i );
    $m->del_path( @p ) if @p;
}

sub _new_node {
    my ($m, $n, $id) = @_;
    my $f = $m->[ _f ];
    my $i = $m->[ _n ]++;
    if (($f & _MULTI)) {
	$id = 0 if $id eq _GEN_ID;
	$$n = [ $i, 0, undef, { $id => { } } ];
    } elsif (($f & _COUNT)) {
	$$n = [ $i, 1 ];
    } else {
	$$n = $i;
    }
    return $i;
}

sub _inc_node {
    my ($m, $n, $id) = @_;
    my $f = $m->[ _f ];
    if (($f & _MULTI)) {
	if ($id eq _GEN_ID) {
	    $$n->[ _nc ]++
		while exists $$n->[ _nm ]->{ $$n->[ _nc ] };
	    $id = $$n->[ _nc ];
	}
	$$n->[ _nm ]->{ $id } = { };
    } elsif (($f & _COUNT)) {
	$$n->[ _nc ]++;
    }
    return $id;
}

sub __get_path_node {
    my $m = shift;
    my ($p, $k);
    my $f = $m->[ _f ];
    @_ = sort @_ if ($f & _UNORD);
    if ($m->[ _a ] == 2 && @_ == 2 && !($f & (_HYPER|_REF|_UNIQ))) { # Fast path.
	return unless exists $m->[ _s ]->{ $_[0] };
	$p = [ $m->[ _s ], $m->[ _s ]->{ $_[0] } ];
	$k = [ $_[0], $_[1] ];
    } else {
	($p, $k) = $m->__has_path( @_ );
    }
    return unless defined $p && defined $k;
    my $l = defined $k->[-1] ? $k->[-1] : "";
    return ( exists $p->[-1]->{ $l }, $p->[-1]->{ $l }, $p, $k, $l );
}

sub set_path_by_multi_id {
    my $m = shift;
    my ($p, $k) = $m->__set_path( @_ );
    return unless defined $p && defined $k;
    my $l = defined $k->[-1] ? $k->[-1] : "";
    return $m->__set_path_node( $p, $l, @_ );
}

sub get_multi_ids {
    my $m = shift;
    my $f = $m->[ _f ];
    return () unless ($f & _MULTI);
    my ($e, $n) = $m->__get_path_node( @_ );
    return $e ? keys %{ $n->[ _nm ] } : ();
}

sub _has_path_attrs {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	return keys %{ $p->[-1]->{ $l }->[ _nm ]->{ $id } } ? 1 : 0;
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	return ref $n && $#$n == _na && keys %{ $n->[ _na ] } ? 1 : 0;
    }
}

sub _set_path_attrs {
    my $m = shift;
    my $f = $m->[ _f ];
    my $attr = pop;
    my $id   = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( @_ );
    push @_, $id if ($f & _MULTI);
    my ($p, $k) = $m->__set_path( @_ );
    return unless defined $p && defined $k;
    my $l = defined $k->[-1] ? $k->[-1] : "";
    $m->__set_path_node( $p, $l, @_ ) unless exists $p->[-1]->{ $l };
    if (($f & _MULTI)) {
	$p->[-1]->{ $l }->[ _nm ]->{ $id } = $attr;
    } else {
	# Extend the node if it is a simple id node.
	$p->[-1]->{ $l } = [ $p->[-1]->{ $l }, 1 ] unless ref $p->[-1]->{ $l };
	$p->[-1]->{ $l }->[ _na ] = $attr;
    }
}

sub _has_path_attr {
    my $m = shift;
    my $f = $m->[ _f ];
    my $attr = pop;
    my $id   = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	exists $p->[-1]->{ $l }->[ _nm ]->{ $id }->{ $attr };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	return ref $n && $#$n == _na ? exists $n->[ _na ]->{ $attr } : undef;
    }
}

sub _set_path_attr {
    my $m = shift;
    my $f = $m->[ _f ];
    my $val  = pop;
    my $attr = pop;
    my $id   = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    my ($p, $k);
    $m->__attr( \@_ ); # _LIGHT maps need this to get upgraded when needed.
    push @_, $id if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    if ($m->[ _a ] == 2 && @_ == 2 && !($f & (_REF|_UNIQ|_HYPER|_UNIQ))) {
	$m->[ _s ]->{ $_[0] } ||= { };
	$p = [ $m->[ _s ], $m->[ _s ]->{ $_[0] } ];
	$k = [ $_[0], $_[1] ];
    } else {
	($p, $k) = $m->__set_path( @_ );
    }
    return unless defined $p && defined $k;
    my $l = defined $k->[-1] ? $k->[-1] : "";
    $m->__set_path_node( $p, $l, @_ ) unless exists $p->[-1]->{ $l };
    if (($f & _MULTI)) {
	$p->[-1]->{ $l }->[ _nm ]->{ $id }->{ $attr } = $val;
    } else {
	# Extend the node if it is a simple id node.
	$p->[-1]->{ $l } = [ $p->[-1]->{ $l }, 1 ] unless ref $p->[-1]->{ $l };
	$p->[-1]->{ $l }->[ _na ]->{ $attr } = $val;
    }
    return $val;
}

sub _get_path_attrs {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id   = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	$p->[-1]->{ $l }->[ _nm ]->{ $id };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return unless $e;
	return $n->[ _na ] if ref $n && $#$n == _na;
	return;
    }
}

sub _get_path_attr {
    my $m = shift;
    my $f = $m->[ _f ];
    my $attr = pop;
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	return $p->[-1]->{ $l }->[ _nm ]->{ $id }->{ $attr };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	return ref $n && $#$n == _na ? $n->[ _na ]->{ $attr } : undef;
    }
}

sub _get_path_attr_names {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	keys %{ $p->[-1]->{ $l }->[ _nm ]->{ $id } };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	return keys %{ $n->[ _na ] } if ref $n && $#$n == _na;
	return;
    }
}

sub _get_path_attr_values {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	values %{ $p->[-1]->{ $l }->[ _nm ]->{ $id } };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	return values %{ $n->[ _na ] } if ref $n && $#$n == _na;
	return;
    }
}

sub _del_path_attrs {
    my $m = shift;
    my $f = $m->[ _f ];
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	delete $p->[-1]->{ $l }->[ _nm ]->{ $id };
	unless (keys %{ $p->[-1]->{ $l }->[ _nm ] } ||
		(defined $p->[-1]->{ $l }->[ _na ] &&
		 keys %{ $p->[-1]->{ $l }->[ _na ] })) {
	    delete $p->[-1]->{ $l };
	}
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	if (ref $n) {
	    $e = _na == $#$n && keys %{ $n->[ _na ] } ? 1 : 0;
	    $#$n = _na - 1;
	    return $e;
	} else {
	    return 0;
	}
    }
}

sub _del_path_attr {
    my $m = shift;
    my $f = $m->[ _f ];
    my $attr = pop;
    my $id = pop if ($f & _MULTI);
    @_ = sort @_ if ($f & _UNORD);
    $m->__attr( \@_ );
    if (($f & _MULTI)) {
	my ($p, $k) = $m->__has_path( @_ );
	return unless defined $p && defined $k;
	my $l = defined $k->[-1] ? $k->[-1] : "";
	delete $p->[-1]->{ $l }->[ _nm ]->{ $id }->{ $attr };
	$m->_del_path_attrs( @_, $id )
	    unless keys %{ $p->[-1]->{ $l }->[ _nm ]->{ $id } };
    } else {
	my ($e, $n) = $m->__get_path_node( @_ );
	return undef unless $e;
	if (ref $n && $#$n == _na && exists $n->[ _na ]->{ $attr }) {
	    delete $n->[ _na ]->{ $attr };
	    return 1;
	} else {
	    return 0;
	}
    }
}

sub _is_COUNT { $_[0]->[ _f ] & _COUNT }
sub _is_MULTI { $_[0]->[ _f ] & _MULTI }
sub _is_HYPER { $_[0]->[ _f ] & _HYPER }
sub _is_UNORD { $_[0]->[ _f ] & _UNORD }
sub _is_UNIQ  { $_[0]->[ _f ] & _UNIQ  }
sub _is_REF   { $_[0]->[ _f ] & _REF   }

sub __arg {
    my $m = shift;
    my $f = $m->[ _f ];
    my @a = @{$_[0]};
    if ($f & _UNIQ) {
	my %u;
	if ($f & _UNORD) {
	    @u{ @a } = @a;
	    @a = values %u;
	} else {
	    my @u;
	    for my $e (@a) {
		push @u, $e if $u{$e}++ == 0;
	    }
	    @a = @u;
	}
    }
    # Alphabetic or numeric sort, does not matter as long as it unifies.
    @{$_[0]} = ($f & _UNORD) ? sort @a : @a;
}

sub _successors {
    my $E = shift;
    my $g = shift;
    my $V = $g->[ _V ];
    map { my @v = @{ $_->[ 1 ] };
	  shift @v;
	  map { $V->_get_id_path($_) } @v } $g->_edges_from( @_ );
}

sub _predecessors {
    my $E = shift;
    my $g = shift;
    my $V = $g->[ _V ];
    if (wantarray) {
	map { my @v = @{ $_->[ 1 ] };
	      pop @v;
	      map { $V->_get_id_path($_) } @v } $g->_edges_to( @_ );
    } else {
	return $g->_edges_to( @_ );
    }
}

1;
__END__
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

=item get_multi_ids

Return the multi ids.

=item has_path(@id)

Return true if the Map has the path by ids, false if not.

=item has_paths

Return true if the Map has any paths, false if not.

=item has_path_by_multi_id($id)

Return true ifd the a Map has the path by a multi(vertex) id, false if not.

=item paths

Return all the paths of the Map.

=item set_path(@id)

Set the path by @ids.

=item set_path_by_multi_id

Set the path in the Map by the multi id.

=back

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
