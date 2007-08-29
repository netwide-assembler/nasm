package Graph::TransitiveClosure::Matrix;

use strict;

use Graph::AdjacencyMatrix;
use Graph::Matrix;

sub _new {
    my ($g, $class, $opt, $want_transitive, $want_reflexive, $want_path, $want_path_vertices) = @_;
    my $m = Graph::AdjacencyMatrix->new($g, %$opt);
    my @V = $g->vertices;
    my $am = $m->adjacency_matrix;
    my $dm; # The distance matrix.
    my $pm; # The predecessor matrix.
    my @di;
    my %di; @di{ @V } = 0..$#V;
    my @ai = @{ $am->[0] };
    my %ai = %{ $am->[1] };
    my @pi;
    my %pi;
    unless ($want_transitive) {
	$dm = $m->distance_matrix;
	@di = @{ $dm->[0] };
	%di = %{ $dm->[1] };
	$pm = Graph::Matrix->new($g);
	@pi = @{ $pm->[0] };
	%pi = %{ $pm->[1] };
	for my $u (@V) {
	    my $diu = $di{$u};
	    my $aiu = $ai{$u};
	    for my $v (@V) {
		my $div = $di{$v};
		my $aiv = $ai{$v};
		next unless
		    # $am->get($u, $v)
		    vec($ai[$aiu], $aiv, 1)
			;
		# $dm->set($u, $v, $u eq $v ? 0 : 1)
		$di[$diu]->[$div] = $u eq $v ? 0 : 1
		    unless
			defined
			    # $dm->get($u, $v)
			    $di[$diu]->[$div]
			    ;
		$pi[$diu]->[$div] = $v unless $u eq $v;
	    }
	}
    }
    # XXX (see the bits below): sometimes, being nice and clean is the
    # wrong thing to do.  In this case, using the public API for graph
    # transitive matrices and bitmatrices makes things awfully slow.
    # Instead, we go straight for the jugular of the data structures.
    for my $u (@V) {
	my $diu = $di{$u};
	my $aiu = $ai{$u};
	my $didiu = $di[$diu];
	my $aiaiu = $ai[$aiu];
	for my $v (@V) {
	    my $div = $di{$v};
	    my $aiv = $ai{$v};
	    my $didiv = $di[$div];
	    my $aiaiv = $ai[$aiv];
	    if (
		# $am->get($v, $u)
		vec($aiaiv, $aiu, 1)
		|| ($want_reflexive && $u eq $v)) {
		my $aivivo = $aiaiv;
		if ($want_transitive) {
		    if ($want_reflexive) {
			for my $w (@V) {
			    next if $w eq $u;
			    my $aiw = $ai{$w};
			    return 0
				if  vec($aiaiu, $aiw, 1) &&
				   !vec($aiaiv, $aiw, 1);
			}
			# See XXX above.
			# for my $w (@V) {
			#    my $aiw = $ai{$w};
			#    if (
			#	# $am->get($u, $w)
			#	vec($aiaiu, $aiw, 1)
			#	|| ($u eq $w)) {
			#	return 0
			#	    if $u ne $w &&
			#		# !$am->get($v, $w)
			#		!vec($aiaiv, $aiw, 1)
			#		    ;
			#	# $am->set($v, $w)
			#	vec($aiaiv, $aiw, 1) = 1
			#	    ;
			#     }
			# }
		    } else {
			# See XXX above.
			# for my $w (@V) {
			#     my $aiw = $ai{$w};
			#     if (
			#	# $am->get($u, $w)
			#	vec($aiaiu, $aiw, 1)
			#       ) {
			#	return 0
			#	    if $u ne $w &&
			#		# !$am->get($v, $w)
			#		!vec($aiaiv, $aiw, 1)
			#		    ;
			# 	# $am->set($v, $w)
			# 	vec($aiaiv, $aiw, 1) = 1
			# 	    ;
			#     }
			# }
			$aiaiv |= $aiaiu;
		    }
		} else {
		    if ($want_reflexive) {
			$aiaiv |= $aiaiu;
			vec($aiaiv, $aiu, 1) = 1;
			# See XXX above.
			# for my $w (@V) {
			#     my $aiw = $ai{$w};
			#     if (
			# 	# $am->get($u, $w)
			#	vec($aiaiu, $aiw, 1)
			#	|| ($u eq $w)) {
			#	# $am->set($v, $w)
			#	vec($aiaiv, $aiw, 1) = 1
			#	    ;
			#     }
			# }
		    } else {
			$aiaiv |= $aiaiu;
			# See XXX above.
			# for my $w (@V) {
			#    my $aiw = $ai{$w};
			#    if (
			#	# $am->get($u, $w)
			#	vec($aiaiu, $aiw, 1)
			#       ) {
			#	# $am->set($v, $w)
			#	vec($aiaiv, $aiw, 1) = 1
			#	    ;
			#     }
			# }
		    }
		}
		if ($aiaiv ne $aivivo) {
		    $ai[$aiv] = $aiaiv;
		    $aiaiu = $aiaiv if $u eq $v;
		}
	    }
	    if ($want_path && !$want_transitive) {
		for my $w (@V) {
		    my $aiw = $ai{$w};
		    next unless
			# See XXX above.
			# $am->get($v, $u)
			vec($aiaiv, $aiu, 1)
			    &&
			# See XXX above.
			# $am->get($u, $w)
			vec($aiaiu, $aiw, 1)
			    ;
		    my $diw = $di{$w};
		    my ($d0, $d1a, $d1b);
		    if (defined $dm) {
			# See XXX above.
			# $d0  = $dm->get($v, $w);
			# $d1a = $dm->get($v, $u) || 1;
			# $d1b = $dm->get($u, $w) || 1;
			$d0  = $didiv->[$diw];
			$d1a = $didiv->[$diu] || 1;
			$d1b = $didiu->[$diw] || 1;
		    } else {
			$d1a = 1;
			$d1b = 1;
		    }
		    my $d1 = $d1a + $d1b;
		    if (!defined $d0 || ($d1 < $d0)) {
			# print "d1 = $d1a ($v, $u) + $d1b ($u, $w) = $d1 ($v, $w) (".(defined$d0?$d0:"-").")\n";
			# See XXX above.
			# $dm->set($v, $w, $d1);
			$didiv->[$diw] = $d1;
			$pi[$div]->[$diw] = $pi[$div]->[$diu]
			    if $want_path_vertices;
		    }
		}
		# $dm->set($u, $v, 1)
		$didiu->[$div] = 1
		    if $u ne $v &&
		       # $am->get($u, $v)
		       vec($aiaiu, $aiv, 1)
			   &&
		       # !defined $dm->get($u, $v);
		       !defined $didiu->[$div];
	    }
	}
    }
    return 1 if $want_transitive;
    my %V; @V{ @V } = @V;
    $am->[0] = \@ai;
    $am->[1] = \%ai;
    if (defined $dm) {
	$dm->[0] = \@di;
	$dm->[1] = \%di;
    }
    if (defined $pm) {
	$pm->[0] = \@pi;
	$pm->[1] = \%pi;
    }
    bless [ $am, $dm, $pm, \%V ], $class;
}

sub new {
    my ($class, $g, %opt) = @_;
    my %am_opt = (distance_matrix => 1);
    if (exists $opt{attribute_name}) {
	$am_opt{attribute_name} = $opt{attribute_name};
	delete $opt{attribute_name};
    }
    if ($opt{distance_matrix}) {
	$am_opt{distance_matrix} = $opt{distance_matrix};
    }
    delete $opt{distance_matrix};
    if (exists $opt{path}) {
	$opt{path_length}   = $opt{path};
	$opt{path_vertices} = $opt{path};
	delete $opt{path};
    }
    my $want_path_length;
    if (exists $opt{path_length}) {
	$want_path_length = $opt{path_length};
	delete $opt{path_length};
    }
    my $want_path_vertices;
    if (exists $opt{path_vertices}) {
	$want_path_vertices = $opt{path_vertices};
	delete $opt{path_vertices};
    }
    my $want_reflexive;
    if (exists $opt{reflexive}) {
	$want_reflexive = $opt{reflexive};
	delete $opt{reflexive};
    }
    my $want_transitive;
    if (exists $opt{is_transitive}) {
	$want_transitive = $opt{is_transitive};
	$am_opt{is_transitive} = $want_transitive;
	delete $opt{is_transitive};
    }
    die "Graph::TransitiveClosure::Matrix::new: Unknown options: @{[map { qq['$_' => $opt{$_}]} keys %opt]}"
	if keys %opt;
    $want_reflexive = 1 unless defined $want_reflexive;
    my $want_path = $want_path_length || $want_path_vertices;
    # $g->expect_dag if $want_path;
    _new($g, $class,
	 \%am_opt,
	 $want_transitive, $want_reflexive,
	 $want_path, $want_path_vertices);
}

sub has_vertices {
    my $tc = shift;
    for my $v (@_) {
	return 0 unless exists $tc->[3]->{ $v };
    }
    return 1;
}

sub is_reachable {
    my ($tc, $u, $v) = @_;
    return undef unless $tc->has_vertices($u, $v);
    return 1 if $u eq $v;
    $tc->[0]->get($u, $v);
}

sub is_transitive {
    if (@_ == 1) {	# Any graph.
	__PACKAGE__->new($_[0], is_transitive => 1);	# Scary.
    } else {		# A TC graph.
	my ($tc, $u, $v) = @_;
	return undef unless $tc->has_vertices($u, $v);
	$tc->[0]->get($u, $v);
    }
}

sub vertices {
    my $tc = shift;
    values %{ $tc->[3] };
}

sub path_length {
    my ($tc, $u, $v) = @_;
    return undef unless $tc->has_vertices($u, $v);
    return 0 if $u eq $v;
    $tc->[1]->get($u, $v);
}

sub path_predecessor {
    my ($tc, $u, $v) = @_;
    return undef if $u eq $v;
    return undef unless $tc->has_vertices($u, $v);
    $tc->[2]->get($u, $v);
}

sub path_vertices {
    my ($tc, $u, $v) = @_;
    return unless $tc->is_reachable($u, $v);
    return wantarray ? () : 0 if $u eq $v;
    my @v = ( $u );
    while ($u ne $v) {
	last unless defined($u = $tc->path_predecessor($u, $v));
	push @v, $u;
    }
    $tc->[2]->set($u, $v, [ @v ]) if @v;
    return @v;
}

1;
__END__
=pod

=head1 NAME

Graph::TransitiveClosure::Matrix - create and query transitive closure of graph

=head1 SYNOPSIS

    use Graph::TransitiveClosure::Matrix;
    use Graph::Directed; # or Undirected

    my $g  = Graph::Directed->new;
    $g->add_...(); # build $g

    # Compute the transitive closure matrix.
    my $tcm = Graph::TransitiveClosure::Matrix->new($g);

    # Being reflexive is the default,
    # meaning that null transitions are included.
    my $tcm = Graph::TransitiveClosure::Matrix->new($g, reflexive => 1);
    $tcm->is_reachable($u, $v)

    # is_reachable(u, v) is always reflexive.
    $tcm->is_reachable($u, $v)

    # The reflexivity of is_transitive(u, v) depends of the reflexivity
    # of the transitive closure.
    $tcg->is_transitive($u, $v)

    my $tcm = Graph::TransitiveClosure::Matrix->new($g, path_length => 1);
    $tcm->path_length($u, $v)

    my $tcm = Graph::TransitiveClosure::Matrix->new($g, path_vertices => 1);
    $tcm->path_vertices($u, $v)

    my $tcm = Graph::TransitiveClosure::Matrix->new($g, attribute_name => 'length');
    $tcm->path_length($u, $v)

    $tcm->vertices

=head1 DESCRIPTION

You can use C<Graph::TransitiveClosure::Matrix> to compute the
transitive closure matrix of a graph and optionally also the minimum
paths (lengths and vertices) between vertices, and after that query
the transitiveness between vertices by using the C<is_reachable()> and
C<is_transitive()> methods, and the paths by using the
C<path_length()> and C<path_vertices()> methods.

If you modify the graph after computing its transitive closure,
the transitive closure and minimum paths may become invalid.

=head1 Methods

=head2 Class Methods

=over 4

=item new($g)

Construct the transitive closure matrix of the graph $g.

=item new($g, options)

Construct the transitive closure matrix of the graph $g with options
as a hash. The known options are

=over 8

=item C<attribute_name> => I<attribute_name>

By default the edge attribute used for distance is C<w>.  You can
change that by giving another attribute name with the C<attribute_name>
attribute to the new() constructor.

=item reflexive => boolean

By default the transitive closure matrix is not reflexive: that is,
the adjacency matrix has zeroes on the diagonal.  To have ones on
the diagonal, use true for the C<reflexive> option.

B<NOTE>: this behaviour has changed from Graph 0.2xxx: transitive
closure graphs were by default reflexive.

=item path_length => boolean

By default the path lengths are not computed, only the boolean transitivity.
By using true for C<path_length> also the path lengths will be computed,
they can be retrieved using the path_length() method.

=item path_vertices => boolean

By default the paths are not computed, only the boolean transitivity.
By using true for C<path_vertices> also the paths will be computed,
they can be retrieved using the path_vertices() method.

=back

=back

=head2 Object Methods

=over 4

=item is_reachable($u, $v)

Return true if the vertex $v is reachable from the vertex $u,
or false if not.

=item path_length($u, $v)

Return the minimum path length from the vertex $u to the vertex $v,
or undef if there is no such path.

=item path_vertices($u, $v)

Return the minimum path (as a list of vertices) from the vertex $u to
the vertex $v, or an empty list if there is no such path, OR also return
an empty list if $u equals $v.

=item has_vertices($u, $v, ...)

Return true if the transitive closure matrix has all the listed vertices,
false if not.

=item is_transitive($u, $v)

Return true if the vertex $v is transitively reachable from the vertex $u,
false if not.

=item vertices

Return the list of vertices in the transitive closure matrix.

=item path_predecessor

Return the predecessor of vertex $v in the transitive closure path
going back to vertex $u.

=back

=head1 RETURN VALUES

For path_length() the return value will be the sum of the appropriate
attributes on the edges of the path, C<weight> by default.  If no
attribute has been set, one (1) will be assumed.

If you try to ask about vertices not in the graph, undefs and empty
lists will be returned.

=head1 ALGORITHM

The transitive closure algorithm used is Warshall and Floyd-Warshall
for the minimum paths, which is O(V**3) in time, and the returned
matrices are O(V**2) in space.

=head1 SEE ALSO

L<Graph::AdjacencyMatrix>

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
