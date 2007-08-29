package Graph::Traversal;

use strict;

# $SIG{__DIE__ } = sub { use Carp; confess };
# $SIG{__WARN__} = sub { use Carp; confess };

sub DEBUG () { 0 }

sub reset {
    my $self = shift;
    $self->{ unseen } = { map { $_ => $_ } $self->{ graph }->vertices };
    $self->{ seen   } = { };
    $self->{ order     } = [ ];
    $self->{ preorder  } = [ ];
    $self->{ postorder } = [ ];
    $self->{ roots     } = [ ];
    $self->{ tree      } =
	Graph->new( directed => $self->{ graph }->directed );
    delete $self->{ terminate };
}

my $see = sub {
    my $self = shift;
    $self->see;
};

my $see_active = sub {
    my $self = shift;
    delete @{ $self->{ active } }{ $self->see };
};

sub has_a_cycle {
    my ($u, $v, $t, $s) = @_;
    $s->{ has_a_cycle } = 1;
    $t->terminate;
}

sub find_a_cycle {
    my ($u, $v, $t, $s) = @_;
    my @cycle = ( $u );
    push @cycle, $v unless $u eq $v;
    my $path  = $t->{ order };
    if (@$path) {
	my $i = $#$path;
	while ($i >= 0 && $path->[ $i ] ne $v) { $i-- }
	if ($i >= 0) {
	    unshift @cycle, @{ $path }[ $i+1 .. $#$path ];
	}
    }
    $s->{ a_cycle } = \@cycle;
    $t->terminate;
}

sub configure {
    my ($self, %attr) = @_;
    $self->{ pre  } = $attr{ pre }  if exists $attr{ pre  };
    $self->{ post } = $attr{ post } if exists $attr{ post };
    $self->{ pre_vertex  } = $attr{ pre_vertex }  if exists $attr{ pre_vertex  };
    $self->{ post_vertex } = $attr{ post_vertex } if exists $attr{ post_vertex };
    $self->{ pre_edge  } = $attr{ pre_edge  } if exists $attr{ pre_edge  };
    $self->{ post_edge } = $attr{ post_edge } if exists $attr{ post_edge };
    if (exists $attr{ successor }) { # Graph 0.201 compatibility.
	$self->{ tree_edge } = $self->{ non_tree_edge } = $attr{ successor };
    }
    if (exists $attr{ unseen_successor }) {
	if (exists $self->{ tree_edge }) { # Graph 0.201 compatibility.
	    my $old_tree_edge = $self->{ tree_edge };
	    $self->{ tree_edge } = sub {
		$old_tree_edge->( @_ );
		$attr{ unseen_successor }->( @_ );
	    };
	} else {
	    $self->{ tree_edge } = $attr{ unseen_successor };
	}
    }
    if ($self->graph->multiedged || $self->graph->countedged) {
	$self->{ seen_edge } = $attr{ seen_edge } if exists $attr{ seen_edge };
	if (exists $attr{ seen_successor }) { # Graph 0.201 compatibility.
	    $self->{ seen_edge } = $attr{ seen_edge };
	}
    }
    $self->{ non_tree_edge } = $attr{ non_tree_edge } if exists $attr{ non_tree_edge };
    $self->{ pre_edge  } = $attr{ tree_edge } if exists $attr{ tree_edge };
    $self->{ back_edge } = $attr{ back_edge } if exists $attr{ back_edge };
    $self->{ down_edge } = $attr{ down_edge } if exists $attr{ down_edge };
    $self->{ cross_edge } = $attr{ cross_edge } if exists $attr{ cross_edge };
    if (exists $attr{ start }) {
	$attr{ first_root } = $attr{ start };
	$attr{ next_root  } = undef;
    }
    if (exists $attr{ get_next_root }) {
	$attr{ next_root  } = $attr{ get_next_root }; # Graph 0.201 compat.
    }
    $self->{ next_root } =
	exists $attr{ next_root } ?
	    $attr{ next_root } :
		$attr{ next_alphabetic } ?
		    \&Graph::_next_alphabetic :
			$attr{ next_numeric } ?
			    \&Graph::_next_numeric :
				\&Graph::_next_random;
    $self->{ first_root } =
	exists $attr{ first_root } ?
	    $attr{ first_root } :
		exists $attr{ next_root } ?
		    $attr{ next_root } :
			$attr{ next_alphabetic } ?
			    \&Graph::_next_alphabetic :
				$attr{ next_numeric } ?
				    \&Graph::_next_numeric :
					\&Graph::_next_random;
    $self->{ next_successor } =
	exists $attr{ next_successor } ?
	    $attr{ next_successor } :
		$attr{ next_alphabetic } ?
		    \&Graph::_next_alphabetic :
			$attr{ next_numeric } ?
			    \&Graph::_next_numeric :
				\&Graph::_next_random;
    if (exists $attr{ has_a_cycle }) {
	my $has_a_cycle =
	    ref $attr{ has_a_cycle } eq 'CODE' ?
		$attr{ has_a_cycle } : \&has_a_cycle;
	$self->{ back_edge } = $has_a_cycle;
	if ($self->{ graph }->is_undirected) {
	    $self->{ down_edge } = $has_a_cycle;
	}
    }
    if (exists $attr{ find_a_cycle }) {
	my $find_a_cycle =
	    ref $attr{ find_a_cycle } eq 'CODE' ?
		$attr{ find_a_cycle } : \&find_a_cycle;
	$self->{ back_edge } = $find_a_cycle;
	if ($self->{ graph }->is_undirected) {
	    $self->{ down_edge } = $find_a_cycle;
	}
    }
    $self->{ add } = \&add_order;
    $self->{ see } = $see;
    delete @attr{ qw(
		     pre post pre_edge post_edge
		     successor unseen_successor seen_successor
		     tree_edge non_tree_edge
		     back_edge down_edge cross_edge seen_edge
		     start get_next_root
		     next_root next_alphabetic next_numeric next_random next_successor
		     first_root
		     has_a_cycle find_a_cycle
		    ) };
    if (keys %attr) {
	require Carp;
	my @attr = sort keys %attr;
	Carp::croak(sprintf "Graph::Traversal: unknown attribute%s @{[map { qq['$_'] } @attr]}\n", @attr == 1 ? '' : 's');
    }
}

sub new {
    my $class = shift;
    my $g = shift;
    unless (ref $g && $g->isa('Graph')) {
	require Carp;
	Carp::croak("Graph::Traversal: first argument is not a Graph");
    }
    my $self = { graph => $g, state => { } };
    bless $self, $class;
    $self->reset;
    $self->configure( @_ );
    return $self;
}

sub terminate {
    my $self = shift;
    $self->{ terminate } = 1;
}

sub add_order {
    my ($self, @next) = @_;
    push @{ $self->{ order } }, @next;
}

sub visit {
    my ($self, @next) = @_;
    delete @{ $self->{ unseen } }{ @next };
    print "unseen = @{[sort keys %{$self->{unseen}}]}\n" if DEBUG;
    @{ $self->{ seen } }{ @next } = @next;
    print "seen = @{[sort keys %{$self->{seen}}]}\n" if DEBUG;
    $self->{ add }->( $self, @next );
    print "order = @{$self->{order}}\n" if DEBUG;
    if (exists $self->{ pre }) {
	my $p = $self->{ pre };
	for my $v (@next) {
	    $p->( $v, $self );
	}
    }
}

sub visit_preorder {
    my ($self, @next) = @_;
    push @{ $self->{ preorder } }, @next;
    for my $v (@next) {
	$self->{ preordern }->{ $v } = $self->{ preorderi }++;
    }
    print "preorder = @{$self->{preorder}}\n" if DEBUG;
    $self->visit( @next );
}

sub visit_postorder {
    my ($self) = @_;
    my @post = reverse $self->{ see }->( $self );
    push @{ $self->{ postorder } }, @post;
    for my $v (@post) {
	$self->{ postordern }->{ $v } = $self->{ postorderi }++;
    }
    print "postorder = @{$self->{postorder}}\n" if DEBUG;
    if (exists $self->{ post }) {
	my $p = $self->{ post };
	for my $v (@post) {
	    $p->( $v, $self ) ;
	}
    }
    if (exists $self->{ post_edge }) {
	my $p = $self->{ post_edge };
	my $u = $self->current;
	if (defined $u) {
	    for my $v (@post) {
		$p->( $u, $v, $self, $self->{ state });
	    }
	}
    }
}

sub _callbacks {
    my ($self, $current, @all) = @_;
    return unless @all;
    my $nontree  = $self->{ non_tree_edge };
    my $back     = $self->{ back_edge };
    my $down     = $self->{ down_edge };
    my $cross    = $self->{ cross_edge };
    my $seen     = $self->{ seen_edge };
    my $bdc = defined $back || defined $down || defined $cross;
    if (defined $nontree || $bdc || defined $seen) {
	my $u = $current;
	my $preu  = $self->{ preordern  }->{ $u };
	my $postu = $self->{ postordern }->{ $u };
	for my $v ( @all ) {
	    my $e = $self->{ tree }->has_edge( $u, $v );
	    if ( !$e && (defined $nontree || $bdc) ) {
		if ( exists $self->{ seen }->{ $v }) {
		    $nontree->( $u, $v, $self, $self->{ state })
			if $nontree;
		    if ($bdc) {
			my $postv = $self->{ postordern }->{ $v };
			if ($back &&
			    (!defined $postv || $postv >= $postu)) {
			    $back ->( $u, $v, $self, $self->{ state });
			} else {
			    my $prev = $self->{ preordern }->{ $v };
			    if ($down && $prev > $preu) {
				$down ->( $u, $v, $self, $self->{ state });
			    } elsif ($cross && $prev < $preu) {
				$cross->( $u, $v, $self, $self->{ state });
			    }
			}
		    }
		}
	    }
	    if ($seen) {
		my $c = $self->graph->get_edge_count($u, $v);
		while ($c-- > 1) {
		    $seen->( $u, $v, $self, $self->{ state } );
		}
	    }
	}
    }
}

sub next {
    my $self = shift;
    return undef if $self->{ terminate };
    my @next;
    while ($self->seeing) {
	my $current = $self->current;
	print "current = $current\n" if DEBUG;
	@next = $self->{ graph }->successors( $current );
	print "next.0 - @next\n" if DEBUG;
	my %next; @next{ @next } = @next;
#	delete $next{ $current };
	print "next.1 - @next\n" if DEBUG;
	@next = keys %next;
	my @all = @next;
	print "all = @all\n" if DEBUG;
	delete @next{ $self->seen };
	@next = keys %next;
	print "next.2 - @next\n" if DEBUG;
	if (@next) {
	    @next = $self->{ next_successor }->( $self, \%next );
	    print "next.3 - @next\n" if DEBUG;
	    for my $v (@next) {
		$self->{ tree }->add_edge( $current, $v );
	    }
	    if (exists $self->{ pre_edge }) {
		my $p = $self->{ pre_edge };
		my $u = $self->current;
		for my $v (@next) {
		    $p->( $u, $v, $self, $self->{ state });
		}
	    }
	    last;
	} else {
	    $self->visit_postorder;
	}
	return undef if $self->{ terminate };
	$self->_callbacks($current, @all);
#	delete $next{ $current };
    }
    print "next.4 - @next\n" if DEBUG;
    unless (@next) {
	unless ( @{ $self->{ roots } } ) {
	    my $first = $self->{ first_root };
	    if (defined $first) {
		@next =
		    ref $first eq 'CODE' ? 
			$self->{ first_root }->( $self, $self->{ unseen } ) :
			$first;
		return unless @next;
	    }
	}
	unless (@next) {
	    return unless defined $self->{ next_root };
	    return unless @next =
		$self->{ next_root }->( $self, $self->{ unseen } );
	}
	return if exists $self->{ seen }->{ $next[0] }; # Sanity check.
	print "next.5 - @next\n" if DEBUG;
	push @{ $self->{ roots } }, $next[0];
    }
    print "next.6 - @next\n" if DEBUG;
    if (@next) {
	$self->visit_preorder( @next );
    }
    return $next[0];
}

sub _order {
    my ($self, $order) = @_;
    1 while defined $self->next;
    my $wantarray = wantarray;
    if ($wantarray) {
	@{ $self->{ $order } };
    } elsif (defined $wantarray) {
	shift @{ $self->{ $order } };
    }
}

sub preorder {
    my $self = shift;
    $self->_order( 'preorder' );
}

sub postorder {
    my $self = shift;
    $self->_order( 'postorder' );
}

sub unseen {
    my $self = shift;
    values %{ $self->{ unseen } };
}

sub seen {
    my $self = shift;
    values %{ $self->{ seen } };
}

sub seeing {
    my $self = shift;
    @{ $self->{ order } };
}

sub roots {
    my $self = shift;
    @{ $self->{ roots } };
}

sub is_root {
    my ($self, $v) = @_;
    for my $u (@{ $self->{ roots } }) {
	return 1 if $u eq $v;
    }
    return 0;
}

sub tree {
    my $self = shift;
    $self->{ tree };
}

sub graph {
    my $self = shift;
    $self->{ graph };
}

sub vertex_by_postorder {
    my ($self, $i) = @_;
    exists $self->{ postorder } && $self->{ postorder }->[ $i ];
}

sub postorder_by_vertex {
    my ($self, $v) = @_;
    exists $self->{ postordern } && $self->{ postordern }->{ $v };
}

sub postorder_vertices {
    my ($self, $v) = @_;
    exists $self->{ postordern } ? %{ $self->{ postordern } } : ();
}

sub vertex_by_preorder {
    my ($self, $i) = @_;
    exists $self->{ preorder } && $self->{ preorder }->[ $i ];
}

sub preorder_by_vertex {
    my ($self, $v) = @_;
    exists $self->{ preordern } && $self->{ preordern }->{ $v };
}

sub preorder_vertices {
    my ($self, $v) = @_;
    exists $self->{ preordern } ? %{ $self->{ preordern } } : ();
}

sub has_state {
    my ($self, $var) = @_;
    exists $self->{ state } && exists $self->{ state }->{ $var };
}

sub get_state {
    my ($self, $var) = @_;
    exists $self->{ state } ? $self->{ state }->{ $var } : undef;
}

sub set_state {
    my ($self, $var, $val) = @_;
    $self->{ state }->{ $var } = $val;
    return 1;
}

sub delete_state {
    my ($self, $var) = @_;
    delete $self->{ state }->{ $var };
    delete $self->{ state } unless keys %{ $self->{ state } };
    return 1;
}

1;
__END__
=pod

=head1 NAME

Graph::Traversal - traverse graphs

=head1 SYNOPSIS

Don't use Graph::Traversal directly, use Graph::Traversal::DFS
or Graph::Traversal::BFS instead.

    use Graph;
    my $g = Graph->new;
    $g->add_edge(...);
    use Graph::Traversal::...;
    my $t = Graph::Traversal::...->new(%opt);
    $t->...

=head1 DESCRIPTION

You can control how the graph is traversed by the various callback
parameters in the C<%opt>.  In the parameters descriptions below the
$u and $v are vertices, and the $self is the traversal object itself.

=head2 Callback parameters

The following callback parameters are available:

=over 4

=item tree_edge

Called when traversing an edge that belongs to the traversal tree.
Called with arguments ($u, $v, $self).

=item non_tree_edge

Called when an edge is met which either leads back to the traversal tree
(either a C<back_edge>, a C<down_edge>, or a C<cross_edge>).
Called with arguments ($u, $v, $self).

=item pre_edge

Called for edges in preorder.
Called with arguments ($u, $v, $self).

=item post_edge

Called for edges in postorder.
Called with arguments ($u, $v, $self).

=item back_edge

Called for back edges.
Called with arguments ($u, $v, $self).

=item down_edge

Called for down edges.
Called with arguments ($u, $v, $self).

=item cross_edge

Called for cross edges.
Called with arguments ($u, $v, $self).

=item pre

=item pre_vertex

Called for vertices in preorder.
Called with arguments ($v, $self).

=item post

=item post_vertex

Called for vertices in postorder.
Called with arguments ($v, $self).

=item first_root

Called when choosing the first root (start) vertex for traversal.
Called with arguments ($self, $unseen) where $unseen is a hash
reference with the unseen vertices as keys.

=item next_root

Called when choosing the next root (after the first one) vertex for
traversal (useful when the graph is not connected).  Called with
arguments ($self, $unseen) where $unseen is a hash reference with
the unseen vertices as keys.  If you want only the first reachable
subgraph to be processed, set the next_root to C<undef>.

=item start

Identical to defining C<first_root> and undefining C<next_root>.

=item next_alphabetic

Set this to true if you want the vertices to be processed in
alphabetic order (and leave first_root/next_root undefined).

=item next_numeric

Set this to true if you want the vertices to be processed in
numeric order (and leave first_root/next_root undefined).

=item next_successor

Called when choosing the next vertex to visit.  Called with arguments
($self, $next) where $next is a hash reference with the possible
next vertices as keys.  Use this to provide a custom ordering for
choosing vertices, as opposed to C<next_numeric> or C<next_alphabetic>.

=back

The parameters C<first_root> and C<next_successor> have a 'hierarchy'
of how they are determined: if they have been explicitly defined, use
that value.  If not, use the value of C<next_alphabetic>, if that has
been defined.  If not, use the value of C<next_numeric>, if that has
been defined.  If not, the next vertex to be visited is chose randomly.

=head2 Methods

The following methods are available:

=over 4

=item unseen

Return the unseen vertices in random order.

=item seen

Return the seen vertices in random order.

=item seeing

Return the active fringe vertices in random order.

=item preorder

Return the vertices in preorder traversal order.

=item postorder

Return the vertices in postorder traversal order.

=item vertex_by_preorder

    $v = $t->vertex_by_preorder($i)

Return the ith (0..$V-1) vertex by preorder.

=item preorder_by_vertex

    $i = $t->preorder_by_vertex($v)

Return the preorder index (0..$V-1) by vertex.

=item vertex_by_postorder

    $v = $t->vertex_by_postorder($i)

Return the ith (0..$V-1) vertex by postorder.

=item postorder_by_vertex

    $i = $t->postorder_by_vertex($v)

Return the postorder index (0..$V-1) by vertex.

=item preorder_vertices

Return a hash with the vertices as the keys and their preorder indices
as the values.

=item postorder_vertices

Return a hash with the vertices as the keys and their postorder
indices as the values.

=item tree

Return the traversal tree as a graph.

=item has_state

    $t->has_state('s')

Test whether the traversal has state 's' attached to it.

=item get_state

    $t->get_state('s')

Get the state 's' attached to the traversal (C<undef> if none).

=item set_state

    $t->set_state('s', $s)

Set the state 's' attached to the traversal.

=item delete_state

    $t->delete_state('s')

Delete the state 's' from the traversal.

=back

=head2 Backward compatibility

The following parameters are for backward compatibility to Graph 0.2xx:

=over 4

=item get_next_root

Like C<next_root>.

=item successor

Identical to having C<tree_edge> both C<non_tree_edge> defined
to be the same.

=item unseen_successor

Like C<tree_edge>.

=item seen_successor

Like C<seed_edge>.

=back

=head2 Special callbacks

If in a callback you call the special C<terminate> method,
the traversal is terminated, no more vertices are traversed.

=head1 SEE ALSO

L<Graph::Traversal::DFS>, L<Graph::Traversal::BFS>

=head1 AUTHOR AND COPYRIGHT

Jarkko Hietaniemi F<jhi@iki.fi>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut
