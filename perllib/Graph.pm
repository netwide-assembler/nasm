package Graph;

use strict;

BEGIN {
    if (0) { # SET THIS TO ZERO FOR TESTING AND RELEASES!
	$SIG{__DIE__ } = \&__carp_confess;
	$SIG{__WARN__} = \&__carp_confess;
    }
    sub __carp_confess { require Carp; Carp::confess(@_) }
}

use Graph::AdjacencyMap qw(:flags :fields);

use vars qw($VERSION);

$VERSION = '0.84';

require 5.006; # Weak references are absolutely required.

use Graph::AdjacencyMap::Heavy;
use Graph::AdjacencyMap::Light;
use Graph::AdjacencyMap::Vertex;
use Graph::UnionFind;
use Graph::TransitiveClosure;
use Graph::Traversal::DFS;
use Graph::MSTHeapElem;
use Graph::SPTHeapElem;
use Graph::Undirected;

use Heap071::Fibonacci;
use List::Util qw(shuffle first);
use Scalar::Util qw(weaken);

sub _F () { 0 } # Flags.
sub _G () { 1 } # Generation.
sub _V () { 2 } # Vertices.
sub _E () { 3 } # Edges.
sub _A () { 4 } # Attributes.
sub _U () { 5 } # Union-Find.

my $Inf;

BEGIN {
    local $SIG{FPE}; 
    eval { $Inf = exp(999) } ||
	eval { $Inf = 9**9**9 } ||
	    eval { $Inf = 1e+999 } ||
		{ $Inf = 1e+99 };  # Close enough for most practical purposes.
}

sub Infinity () { $Inf }

# Graphs are blessed array references.
# - The first element contains the flags.
# - The second element is the vertices.
# - The third element is the edges.
# - The fourth element is the attributes of the whole graph.
# The defined flags for Graph are:
# - _COMPAT02 for user API compatibility with the Graph 0.20xxx series.
# The vertices are contained in either a "simplemap"
# (if no hypervertices) or in a "map".
# The edges are always in a "map".
# The defined flags for maps are:
# - _COUNT for countedness: more than one instance
# - _HYPER for hyperness: a different number of "coordinates" than usual;
#   expects one for vertices and two for edges
# - _UNORD for unordered coordinates (a set): if _UNORD is not set
#   the coordinates are assumed to be meaningfully ordered
# - _UNIQ for unique coordinates: if set duplicates are removed,
#   if not, duplicates are assumed to meaningful
# - _UNORDUNIQ: just a union of _UNORD and UNIQ
# Vertices are assumed to be _UNORDUNIQ; edges assume none of these flags.

use Graph::Attribute array => _A, map => 'graph';

sub _COMPAT02 () { 0x00000001 }

sub stringify {
    my $g = shift;
    my $o = $g->is_undirected;
    my $e = $o ? '=' : '-';
    my @e =
	map {
	    my @v =
		map {
		    ref($_) eq 'ARRAY' ? "[" . join(" ", @$_) . "]" : "$_"
		}
	    @$_;
	    join($e, $o ? sort { "$a" cmp "$b" } @v : @v) } $g->edges05;
    my @s = sort { "$a" cmp "$b" } @e;
    push @s, sort { "$a" cmp "$b" } $g->isolated_vertices;
    join(",", @s);
}

sub eq {
    "$_[0]" eq "$_[1]"
}

sub ne {
    "$_[0]" ne "$_[1]"
}

use overload
    '""' => \&stringify,
    'eq' => \&eq,
    'ne' => \&ne;

sub _opt {
    my ($opt, $flags, %flags) = @_;
    while (my ($flag, $FLAG) = each %flags) {
	if (exists $opt->{$flag}) {
	    $$flags |= $FLAG if $opt->{$flag};
	    delete $opt->{$flag};
	}
	if (exists $opt->{my $non = "non$flag"}) {
	    $$flags &= ~$FLAG if $opt->{$non};
	    delete $opt->{$non};
	}
    }
}

sub is_compat02 {
    my ($g) = @_;
    $g->[ _F ] & _COMPAT02;
}

*compat02 = \&is_compat02;

sub has_union_find {
    my ($g) = @_;
    ($g->[ _F ] & _UNIONFIND) && defined $g->[ _U ];
}

sub _get_union_find {
    my ($g) = @_;
    $g->[ _U ];
}

sub _opt_get {
    my ($opt, $key, $var) = @_;
    if (exists $opt->{$key}) {
	$$var = $opt->{$key};
	delete $opt->{$key};
    }
}

sub _opt_unknown {
    my ($opt) = @_;
    if (my @opt = keys %$opt) {
	my $f = (caller(1))[3];
	require Carp;
	Carp::confess(sprintf
		      "$f: Unknown option%s: @{[map { qq['$_'] } sort @opt]}",
		      @opt > 1 ? 's' : '');
    }
}

sub new {
    my $class = shift;
    my $gflags = 0;
    my $vflags;
    my $eflags;
    my %opt = _get_options( \@_ );

    if (ref $class && $class->isa('Graph')) {
	no strict 'refs';
        for my $c (qw(undirected refvertexed compat02
                      hypervertexed countvertexed multivertexed
                      hyperedged countedged multiedged omniedged)) {
#            $opt{$c}++ if $class->$c; # 5.00504-incompatible
	    if (&{"Graph::$c"}($class)) { $opt{$c}++ }
        }
#        $opt{unionfind}++ if $class->has_union_find; # 5.00504-incompatible
	if (&{"Graph::has_union_find"}($class)) { $opt{unionfind}++ }
    }

    _opt_get(\%opt, undirected   => \$opt{omniedged});
    _opt_get(\%opt, omnidirected => \$opt{omniedged});

    if (exists $opt{directed}) {
	$opt{omniedged} = !$opt{directed};
	delete $opt{directed};
    }

    my $vnonomni =
	$opt{nonomnivertexed} ||
	    (exists $opt{omnivertexed} && !$opt{omnivertexed});
    my $vnonuniq =
	$opt{nonuniqvertexed} ||
	    (exists $opt{uniqvertexed} && !$opt{uniqvertexed});

    _opt(\%opt, \$vflags,
	 countvertexed	=> _COUNT,
	 multivertexed	=> _MULTI,
	 hypervertexed	=> _HYPER,
	 omnivertexed	=> _UNORD,
	 uniqvertexed	=> _UNIQ,
	 refvertexed	=> _REF,
	);

    _opt(\%opt, \$eflags,
	 countedged	=> _COUNT,
	 multiedged	=> _MULTI,
	 hyperedged	=> _HYPER,
	 omniedged	=> _UNORD,
	 uniqedged	=> _UNIQ,
	);

    _opt(\%opt, \$gflags,
	 compat02      => _COMPAT02,
	 unionfind     => _UNIONFIND,
	);

    if (exists $opt{vertices_unsorted}) { # Graph 0.20103 compat.
	my $unsorted = $opt{vertices_unsorted};
	delete $opt{vertices_unsorted};
	require Carp;
	Carp::confess("Graph: vertices_unsorted must be true")
	    unless $unsorted;
    }

    my @V;
    if ($opt{vertices}) {
	require Carp;
	Carp::confess("Graph: vertices should be an array ref")
	    unless ref $opt{vertices} eq 'ARRAY';
	@V = @{ $opt{vertices} };
	delete $opt{vertices};
    }

    my @E;
    if ($opt{edges}) {
	unless (ref $opt{edges} eq 'ARRAY') {
	    require Carp;
	    Carp::confess("Graph: edges should be an array ref of array refs");
	}
	@E = @{ $opt{edges} };
	delete $opt{edges};
    }

    _opt_unknown(\%opt);

    my $uflags;
    if (defined $vflags) {
	$uflags = $vflags;
	$uflags |= _UNORD unless $vnonomni;
	$uflags |= _UNIQ  unless $vnonuniq;
    } else {
	$uflags = _UNORDUNIQ;
	$vflags = 0;
    }

    if (!($vflags & _HYPER) && ($vflags & _UNORDUNIQ)) {
	my @but;
	push @but, 'unordered' if ($vflags & _UNORD);
	push @but, 'unique'    if ($vflags & _UNIQ);
	require Carp;
	Carp::confess(sprintf "Graph: not hypervertexed but %s",
		      join(' and ', @but));
    }

    unless (defined $eflags) {
	$eflags = ($gflags & _COMPAT02) ? _COUNT : 0;
    }

    if (!($vflags & _HYPER) && ($vflags & _UNIQ)) {
	require Carp;
	Carp::confess("Graph: not hypervertexed but uniqvertexed");
    }

    if (($vflags & _COUNT) && ($vflags & _MULTI)) {
	require Carp;
	Carp::confess("Graph: both countvertexed and multivertexed");
    }

    if (($eflags & _COUNT) && ($eflags & _MULTI)) {
	require Carp;
	Carp::confess("Graph: both countedged and multiedged");
    }

    my $g = bless [ ], ref $class || $class;

    $g->[ _F ] = $gflags;
    $g->[ _G ] = 0;
    $g->[ _V ] = ($vflags & (_HYPER | _MULTI)) ?
	Graph::AdjacencyMap::Heavy->_new($uflags, 1) :
	    (($vflags & ~_UNORD) ?
	     Graph::AdjacencyMap::Vertex->_new($uflags, 1) :
	     Graph::AdjacencyMap::Light->_new($g, $uflags, 1));
    $g->[ _E ] = (($vflags & _HYPER) || ($eflags & ~_UNORD)) ?
	Graph::AdjacencyMap::Heavy->_new($eflags, 2) :
	    Graph::AdjacencyMap::Light->_new($g, $eflags, 2);

    $g->add_vertices(@V) if @V;

    if (@E) {
	for my $e (@E) {
	    unless (ref $e eq 'ARRAY') {
		require Carp;
		Carp::confess("Graph: edges should be array refs");
	    }
	    $g->add_edge(@$e);
	}
    }

    if (($gflags & _UNIONFIND)) {
	$g->[ _U ] = Graph::UnionFind->new;
    }

    return $g;
}

sub countvertexed { $_[0]->[ _V ]->_is_COUNT }
sub multivertexed { $_[0]->[ _V ]->_is_MULTI }
sub hypervertexed { $_[0]->[ _V ]->_is_HYPER }
sub omnivertexed  { $_[0]->[ _V ]->_is_UNORD }
sub uniqvertexed  { $_[0]->[ _V ]->_is_UNIQ  }
sub refvertexed   { $_[0]->[ _V ]->_is_REF   }

sub countedged    { $_[0]->[ _E ]->_is_COUNT }
sub multiedged    { $_[0]->[ _E ]->_is_MULTI }
sub hyperedged    { $_[0]->[ _E ]->_is_HYPER }
sub omniedged     { $_[0]->[ _E ]->_is_UNORD }
sub uniqedged     { $_[0]->[ _E ]->_is_UNIQ  }

*undirected   = \&omniedged;
*omnidirected = \&omniedged;
sub directed { ! $_[0]->[ _E ]->_is_UNORD }

*is_directed      = \&directed;
*is_undirected    = \&undirected;

*is_countvertexed = \&countvertexed;
*is_multivertexed = \&multivertexed;
*is_hypervertexed = \&hypervertexed;
*is_omnidirected  = \&omnidirected;
*is_uniqvertexed  = \&uniqvertexed;
*is_refvertexed   = \&refvertexed;

*is_countedged    = \&countedged;
*is_multiedged    = \&multiedged;
*is_hyperedged    = \&hyperedged;
*is_omniedged     = \&omniedged;
*is_uniqedged     = \&uniqedged;

sub _union_find_add_vertex {
    my ($g, $v) = @_;
    my $UF = $g->[ _U ];
    $UF->add( $g->[ _V ]->_get_path_id( $v ) );
}

sub add_vertex {
    my $g = shift;
    if ($g->is_multivertexed) {
	return $g->add_vertex_by_id(@_, _GEN_ID);
    }
    my @r;
    if (@_ > 1) {
	unless ($g->is_countvertexed || $g->is_hypervertexed) {
	    require Carp;
	    Carp::croak("Graph::add_vertex: use add_vertices for more than one vertex or use hypervertexed");
	}
	for my $v ( @_ ) {
	    if (defined $v) {
		$g->[ _V ]->set_path( $v ) unless $g->has_vertex( $v );
	    } else {
		require Carp;
		Carp::croak("Graph::add_vertex: undef vertex");
	    }
	}
    }
    for my $v ( @_ ) {
	unless (defined $v) {
	    require Carp;
	    Carp::croak("Graph::add_vertex: undef vertex");
	}
    }
    $g->[ _V ]->set_path( @_ );
    $g->[ _G ]++;
    $g->_union_find_add_vertex( @_ ) if $g->has_union_find;
    return $g;
}

sub has_vertex {
    my $g = shift;
    my $V = $g->[ _V ];
    return exists $V->[ _s ]->{ $_[0] } if ($V->[ _f ] & _LIGHT);
    $V->has_path( @_ );
}

sub vertices05 {
    my $g = shift;
    my @v = $g->[ _V ]->paths( @_ );
    if (wantarray) {
	return $g->[ _V ]->_is_HYPER ?
	    @v : map { ref $_ eq 'ARRAY' ? @$_ : $_ } @v;
    } else {
	return scalar @v;
    }
}

sub vertices {
    my $g = shift;
    my @v = $g->vertices05;
    if ($g->is_compat02) {
        wantarray ? sort @v : scalar @v;
    } else {
	if ($g->is_multivertexed || $g->is_countvertexed) {
	    if (wantarray) {
		my @V;
		for my $v ( @v ) {
		    push @V, ($v) x $g->get_vertex_count($v);
		}
		return @V;
	    } else {
		my $V = 0;
		for my $v ( @v ) {
		    $V += $g->get_vertex_count($v);
		}
		return $V;
	    }
	} else {
	    return @v;
	}
    }
}

*vertices_unsorted = \&vertices_unsorted; # Graph 0.20103 compat.

sub unique_vertices {
    my $g = shift;
    my @v = $g->vertices05;
    if ($g->is_compat02) {
        wantarray ? sort @v : scalar @v;
    } else {
	return @v;
    }
}

sub has_vertices {
    my $g = shift;
    scalar $g->[ _V ]->has_paths( @_ );
}

sub _add_edge {
    my $g = shift;
    my $V = $g->[ _V ];
    my @e;
    if (($V->[ _f ]) & _LIGHT) {
	for my $v ( @_ ) {
	    $g->add_vertex( $v ) unless exists $V->[ _s ]->{ $v };
	    push @e, $V->[ _s ]->{ $v };
	}
    } else {
	my $h = $g->[ _V ]->_is_HYPER;
	for my $v ( @_ ) {
	    my @v = ref $v eq 'ARRAY' && $h ? @$v : $v;
	    $g->add_vertex( @v ) unless $V->has_path( @v );
	    push @e, $V->_get_path_id( @v );
	}
    }
    return @e;
}

sub _union_find_add_edge {
    my ($g, $u, $v) = @_;
    $g->[ _U ]->union($u, $v);
}

sub add_edge {
    my $g = shift;
    if ($g->is_multiedged) {
	unless (@_ == 2 || $g->is_hyperedged) {
	    require Carp;
	    Carp::croak("Graph::add_edge: use add_edges for more than one edge");
	}
	return $g->add_edge_by_id(@_, _GEN_ID);
    }
    unless (@_ == 2) {
	unless ($g->is_hyperedged) {
	    require Carp;
	    Carp::croak("Graph::add_edge: graph is not hyperedged");
	}
    }
    my @e = $g->_add_edge( @_ );
    $g->[ _E ]->set_path( @e );
    $g->[ _G ]++;
    $g->_union_find_add_edge( @e ) if $g->has_union_find;
    return $g;
}

sub _vertex_ids {
    my $g = shift;
    my $V = $g->[ _V ];
    my @e;
    if (($V->[ _f ] & _LIGHT)) {
	for my $v ( @_ ) {
	    return () unless exists $V->[ _s ]->{ $v };
	    push @e, $V->[ _s ]->{ $v };
	}
    } else {
	my $h = $g->[ _V ]->_is_HYPER;
	for my $v ( @_ ) {
	    my @v = ref $v eq 'ARRAY' && $h ? @$v : $v;
	    return () unless $V->has_path( @v );
	    push @e, $V->_get_path_id( @v );
	}
    }
    return @e;
}

sub has_edge {
    my $g = shift;
    my $E = $g->[ _E ];
    my $V = $g->[ _V ];
    my @i;
    if (($V->[ _f ] & _LIGHT) && @_ == 2) {
	return 0 unless
	    exists $V->[ _s ]->{ $_[0] } &&
	    exists $V->[ _s ]->{ $_[1] };
	@i = @{ $V->[ _s ] }{ @_[ 0, 1 ] };
    } else {
	@i = $g->_vertex_ids( @_ );
	return 0 if @i == 0 && @_;
    }
    my $f = $E->[ _f ];
    if ($E->[ _a ] == 2 && @i == 2 && !($f & (_HYPER|_REF|_UNIQ))) { # Fast path.
	@i = sort @i if ($f & _UNORD);
	return exists $E->[ _s ]->{ $i[0] } &&
	       exists $E->[ _s ]->{ $i[0] }->{ $i[1] } ? 1 : 0;
    } else {
	return defined $E->_get_path_id( @i ) ? 1 : 0;
    }
}

sub edges05 {
    my $g = shift;
    my $V = $g->[ _V ];
    my @e = $g->[ _E ]->paths( @_ );
    wantarray ?
	map { [ map { my @v = $V->_get_id_path($_);
		      @v == 1 ? $v[0] : [ @v ] }
		@$_ ] }
            @e : @e;
}

sub edges02 {
    my $g = shift;
    if (@_ && defined $_[0]) {
	unless (defined $_[1]) {
	    my @e = $g->edges_at($_[0]);
	    wantarray ?
		map { @$_ }
                    sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] } @e
                : @e;
	} else {
	    die "edges02: unimplemented option";
	}
    } else {
	my @e = map { ($_) x $g->get_edge_count(@$_) } $g->edges05( @_ );
	wantarray ?
          map { @$_ }
              sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] } @e
          : @e;
    }
}

sub unique_edges {
    my $g = shift;
    ($g->is_compat02) ? $g->edges02( @_ ) : $g->edges05( @_ );
}

sub edges {
    my $g = shift;
    if ($g->is_compat02) {
	return $g->edges02( @_ );
    } else {
	if ($g->is_multiedged || $g->is_countedged) {
	    if (wantarray) {
		my @E;
		for my $e ( $g->edges05 ) {
		    push @E, ($e) x $g->get_edge_count(@$e);
		}
		return @E;
	    } else {
		my $E = 0;
		for my $e ( $g->edges05 ) {
		    $E += $g->get_edge_count(@$e);
		}
		return $E;
	    }
	} else {
	    return $g->edges05;
	}
    }
}

sub has_edges {
    my $g = shift;
    scalar $g->[ _E ]->has_paths( @_ );
}

###
# by_id
#

sub add_vertex_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    $g->[ _V ]->set_path_by_multi_id( @_ );
    $g->[ _G ]++;
    $g->_union_find_add_vertex( @_ ) if $g->has_union_find;
    return $g;
}

sub add_vertex_get_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $id = $g->[ _V ]->set_path_by_multi_id( @_, _GEN_ID );
    $g->[ _G ]++;
    $g->_union_find_add_vertex( @_ ) if $g->has_union_find;
    return $id;
}

sub has_vertex_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    $g->[ _V ]->has_path_by_multi_id( @_ );
}

sub delete_vertex_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $V = $g->[ _V ];
    return unless $V->has_path_by_multi_id( @_ );
    # TODO: what to about the edges at this vertex?
    # If the multiness of this vertex goes to zero, delete the edges?
    $V->del_path_by_multi_id( @_ );
    $g->[ _G ]++;
    return $g;
}

sub get_multivertex_ids {
    my $g = shift;
    $g->expect_multivertexed;
    $g->[ _V ]->get_multi_ids( @_ );
}

sub add_edge_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $id = pop;
    my @e = $g->_add_edge( @_ );
    $g->[ _E ]->set_path( @e, $id );
    $g->[ _G ]++;
    $g->_union_find_add_edge( @e ) if $g->has_union_find;
    return $g;
}

sub add_edge_get_id {
    my $g = shift;
    $g->expect_multiedged;
    my @i = $g->_add_edge( @_ );
    my $id = $g->[ _E ]->set_path_by_multi_id( @i, _GEN_ID );
    $g->_union_find_add_edge( @i ) if $g->has_union_find;
    $g->[ _G ]++;
    return $id;
}

sub has_edge_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $id = pop;
    my @i = $g->_vertex_ids( @_ );
    return 0 if @i == 0 && @_;
    $g->[ _E ]->has_path_by_multi_id( @i, $id );
}

sub delete_edge_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $V = $g->[ _E ];
    my $id = pop;
    my @i = $g->_vertex_ids( @_ );
    return unless $V->has_path_by_multi_id( @i, $id );
    $V->del_path_by_multi_id( @i, $id );
    $g->[ _G ]++;
    return $g;
}

sub get_multiedge_ids {
    my $g = shift;
    $g->expect_multiedged;
    my @id = $g->_vertex_ids( @_ );
    return unless @id;
    $g->[ _E ]->get_multi_ids( @id );
}

###
# Neighbourhood.
#

sub vertices_at {
    my $g = shift;
    my $V = $g->[ _V ];
    return @_ unless ($V->[ _f ] & _HYPER);
    my %v;
    my @i;
    for my $v ( @_ ) {
	my $i = $V->_get_path_id( $v );
	return unless defined $i;
	push @i, ( $v{ $v } = $i );
    }
    my $Vi = $V->_ids;
    my @v;
    while (my ($i, $v) = each %{ $Vi }) {
	my %i;
	my $h = $V->[_f ] & _HYPER;
	@i{ @i } = @i if @i; # @todo: nonuniq hyper vertices?
	for my $u (ref $v eq 'ARRAY' && $h ? @$v : $v) {
	    my $j = exists $v{ $u } ? $v{ $u } : ( $v{ $u } = $i );
	    if (defined $j && exists $i{ $j }) {
		delete $i{ $j };
		unless (keys %i) {
		    push @v, $v;
		    last;
		}
	    }
	}
    }
    return @v;
}

sub _edges_at {
    my $g = shift;
    my $V = $g->[ _V ];
    my $E = $g->[ _E ];
    my @e;
    my $en = 0;
    my %ev;
    my $h = $V->[_f ] & _HYPER;
    for my $v ( $h ? $g->vertices_at( @_ ) : @_ ) {
	my $vi = $V->_get_path_id( ref $v eq 'ARRAY' && $h ? @$v : $v );
	next unless defined $vi;
	my $Ei = $E->_ids;
	while (my ($ei, $ev) = each %{ $Ei }) {
	    if (wantarray) {
		for my $j (@$ev) {
		    push @e, [ $ei, $ev ]
			if $j == $vi && !$ev{$ei}++;
		}
	    } else {
		for my $j (@$ev) {
		    $en++ if $j == $vi;
		}
	    }		    
	}
    }
    return wantarray ? @e : $en;
}

sub _edges_from {
    my $g = shift;
    my $V = $g->[ _V ];
    my $E = $g->[ _E ];
    my @e;
    my $o = $E->[ _f ] & _UNORD;
    my $en = 0;
    my %ev;
    my $h = $V->[_f ] & _HYPER;
    for my $v ( $h ? $g->vertices_at( @_ ) : @_ ) {
	my $vi = $V->_get_path_id( ref $v eq 'ARRAY' && $h ? @$v : $v );
	next unless defined $vi;
	my $Ei = $E->_ids;
	if (wantarray) {
	    if ($o) {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    push @e, [ $ei, $ev ]
			if ($ev->[0] == $vi || $ev->[-1] == $vi) && !$ev{$ei}++;
		}
	    } else {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    push @e, [ $ei, $ev ]
			if $ev->[0] == $vi && !$ev{$ei}++;
		}
	    }
	} else {
	    if ($o) {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    $en++ if ($ev->[0] == $vi || $ev->[-1] == $vi);
		}
	    } else {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    $en++ if $ev->[0] == $vi;
		}
	    }
	}
    }
    if (wantarray && $g->is_undirected) {
	my @i = map { $V->_get_path_id( $_ ) } @_;
	for my $e ( @e ) {
	    unless ( $e->[ 1 ]->[ 0 ] == $i[ 0 ] ) { # @todo
		$e = [ $e->[ 0 ], [ reverse @{ $e->[ 1 ] } ] ];
	    }
	}
    }
    return wantarray ? @e : $en;
}

sub _edges_to {
    my $g = shift;
    my $V = $g->[ _V ];
    my $E = $g->[ _E ];
    my @e;
    my $o = $E->[ _f ] & _UNORD;
    my $en = 0;
    my %ev;
    my $h = $V->[_f ] & _HYPER;
    for my $v ( $h ? $g->vertices_at( @_ ) : @_ ) {
	my $vi = $V->_get_path_id( ref $v eq 'ARRAY' && $h ? @$v : $v );
	next unless defined $vi;
	my $Ei = $E->_ids;
	if (wantarray) {
	    if ($o) {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    push @e, [ $ei, $ev ]
			if ($ev->[-1] == $vi || $ev->[0] == $vi) && !$ev{$ei}++;
		}
	    } else {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    push @e, [ $ei, $ev ]
			if $ev->[-1] == $vi && !$ev{$ei}++;
		}
	    }
	} else {
	    if ($o) {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    $en++ if $ev->[-1] == $vi || $ev->[0] == $vi;
		}
	    } else {
		while (my ($ei, $ev) = each %{ $Ei }) {
		    next unless @$ev;
		    $en++ if $ev->[-1] == $vi;
		}
	    }
	}
    }
    if (wantarray && $g->is_undirected) {
	my @i = map { $V->_get_path_id( $_ ) } @_;
	for my $e ( @e ) {
	    unless ( $e->[ 1 ]->[ -1 ] == $i[ -1 ] ) { # @todo
		$e = [ $e->[ 0 ], [ reverse @{ $e->[ 1 ] } ] ];
	    }
	}
    }
    return wantarray ? @e : $en;
}

sub _edges_id_path {
    my $g = shift;
    my $V  = $g->[ _V ];
    [ map { my @v = $V->_get_id_path($_);
	    @v == 1 ? $v[0] : [ @v ] }
          @{ $_[0]->[1] } ];
}

sub edges_at {
    my $g = shift;
    map { $g->_edges_id_path($_ ) } $g->_edges_at( @_ );
}

sub edges_from {
    my $g = shift;
    map { $g->_edges_id_path($_ ) } $g->_edges_from( @_ );
}

sub edges_to {
    my $g = shift;
    map { $g->_edges_id_path($_ ) } $g->_edges_to( @_ );
}

sub successors {
    my $g = shift;
    my $E = $g->[ _E ];
    ($E->[ _f ] & _LIGHT) ?
	$E->_successors($g, @_) :
	Graph::AdjacencyMap::_successors($E, $g, @_);
}

sub predecessors {
    my $g = shift;
    my $E = $g->[ _E ];
    ($E->[ _f ] & _LIGHT) ?
	$E->_predecessors($g, @_) :
	Graph::AdjacencyMap::_predecessors($E, $g, @_);
}

sub neighbours {
    my $g = shift;
    my $V  = $g->[ _V ];
    my @s = map { my @v = @{ $_->[ 1 ] }; shift @v; @v } $g->_edges_from( @_ );
    my @p = map { my @v = @{ $_->[ 1 ] }; pop   @v; @v } $g->_edges_to  ( @_ );
    my %n;
    @n{ @s } = @s;
    @n{ @p } = @p;
    map { $V->_get_id_path($_) } keys %n;
}

*neighbors = \&neighbours;

sub delete_edge {
    my $g = shift;
    my @i = $g->_vertex_ids( @_ );
    return $g unless @i;
    my $i = $g->[ _E ]->_get_path_id( @i );
    return $g unless defined $i;
    $g->[ _E ]->_del_id( $i );
    $g->[ _G ]++;
    return $g;
}

sub delete_vertex {
    my $g = shift;
    my $V = $g->[ _V ];
    return $g unless $V->has_path( @_ );
    my $E = $g->[ _E ];
    for my $e ( $g->_edges_at( @_ ) ) {
	$E->_del_id( $e->[ 0 ] );
    }
    $V->del_path( @_ );
    $g->[ _G ]++;
    return $g;
}

sub get_vertex_count {
    my $g = shift;
    $g->[ _V ]->_get_path_count( @_ ) || 0;
}

sub get_edge_count {
    my $g = shift;
    my @e = $g->_vertex_ids( @_ );
    return 0 unless @e;
    $g->[ _E ]->_get_path_count( @e ) || 0;
}

sub delete_vertices {
    my $g = shift;
    while (@_) {
	my $v = shift @_;
	$g->delete_vertex($v);
    }
    return $g;
}

sub delete_edges {
    my $g = shift;
    while (@_) {
	my ($u, $v) = splice @_, 0, 2;
	$g->delete_edge($u, $v);
    }
    return $g;
}

###
# Degrees.
#

sub _in_degree {
    my $g = shift;
    return undef unless @_ && $g->has_vertex( @_ );
    my $in =  $g->is_undirected && $g->is_self_loop_vertex( @_ ) ? 1 : 0;
    $in += $g->get_edge_count( @$_ ) for $g->edges_to( @_ );
    return $in;
}

sub in_degree {
    my $g = shift;
    $g->_in_degree( @_ );
}

sub _out_degree {
    my $g = shift;
    return undef unless @_ && $g->has_vertex( @_ );
    my $out =  $g->is_undirected && $g->is_self_loop_vertex( @_ ) ? 1 : 0;
    $out += $g->get_edge_count( @$_ ) for $g->edges_from( @_ );
    return $out;
}

sub out_degree {
    my $g = shift;
    $g->_out_degree( @_ );
}

sub _total_degree {
    my $g = shift;
    return undef unless @_ && $g->has_vertex( @_ );
    $g->is_undirected ?
	$g->_in_degree( @_ ) :
	$g-> in_degree( @_ ) - $g-> out_degree( @_ );
}

sub degree {
    my $g = shift;
    if (@_) {
	$g->_total_degree( @_ );
    } else {
	if ($g->is_undirected) {
	    my $total = 0;
	    $total += $g->_total_degree( $_ ) for $g->vertices05;
	    return $total;
	} else {
	    return 0;
	}
    }
}

*vertex_degree = \&degree;

sub is_sink_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->successors( @_ ) == 0 && $g->predecessors( @_ ) > 0;
}

sub is_source_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->predecessors( @_ ) == 0 && $g->successors( @_ ) > 0;
}

sub is_successorless_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->successors( @_ ) == 0;
}

sub is_predecessorless_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->predecessors( @_ ) == 0;
}

sub is_successorful_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->successors( @_ ) > 0;
}

sub is_predecessorful_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->predecessors( @_ ) > 0;
}

sub is_isolated_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->predecessors( @_ ) == 0 && $g->successors( @_ ) == 0;
}

sub is_interior_vertex {
    my $g = shift;
    return 0 unless @_;
    my $p = $g->predecessors( @_ );
    my $s = $g->successors( @_ );
    if ($g->is_self_loop_vertex( @_ )) {
	$p--;
	$s--;
    }
    $p > 0 && $s > 0;
}

sub is_exterior_vertex {
    my $g = shift;
    return 0 unless @_;
    $g->predecessors( @_ ) == 0 || $g->successors( @_ ) == 0;
}

sub is_self_loop_vertex {
    my $g = shift;
    return 0 unless @_;
    for my $s ( $g->successors( @_ ) ) {
	return 1 if $s eq $_[0]; # @todo: hypervertices
    }
    return 0;
}

sub sink_vertices {
    my $g = shift;
    grep { $g->is_sink_vertex($_) } $g->vertices05;
}

sub source_vertices {
    my $g = shift;
    grep { $g->is_source_vertex($_) } $g->vertices05;
}

sub successorless_vertices {
    my $g = shift;
    grep { $g->is_successorless_vertex($_) } $g->vertices05;
}

sub predecessorless_vertices {
    my $g = shift;
    grep { $g->is_predecessorless_vertex($_) } $g->vertices05;
}

sub successorful_vertices {
    my $g = shift;
    grep { $g->is_successorful_vertex($_) } $g->vertices05;
}

sub predecessorful_vertices {
    my $g = shift;
    grep { $g->is_predecessorful_vertex($_) } $g->vertices05;
}

sub isolated_vertices {
    my $g = shift;
    grep { $g->is_isolated_vertex($_) } $g->vertices05;
}

sub interior_vertices {
    my $g = shift;
    grep { $g->is_interior_vertex($_) } $g->vertices05;
}

sub exterior_vertices {
    my $g = shift;
    grep { $g->is_exterior_vertex($_) } $g->vertices05;
}

sub self_loop_vertices {
    my $g = shift;
    grep { $g->is_self_loop_vertex($_) } $g->vertices05;
}

###
# Paths and cycles.
#

sub add_path {
    my $g = shift;
    my $u = shift;
    while (@_) {
	my $v = shift;
	$g->add_edge($u, $v);
	$u = $v;
    }
    return $g;
}

sub delete_path {
    my $g = shift;
    my $u = shift;
    while (@_) {
	my $v = shift;
	$g->delete_edge($u, $v);
	$u = $v;
    }
    return $g;
}

sub has_path {
    my $g = shift;
    my $u = shift;
    while (@_) {
	my $v = shift;
	return 0 unless $g->has_edge($u, $v);
	$u = $v;
    }
    return $g;
}

sub add_cycle {
    my $g = shift;
    $g->add_path(@_, $_[0]);
}

sub delete_cycle {
    my $g = shift;
    $g->delete_path(@_, $_[0]);
}

sub has_cycle {
    my $g = shift;
    @_ ? ($g->has_path(@_, $_[0]) ? 1 : 0) : 0;
}

sub has_a_cycle {
    my $g = shift;
    my @r = ( back_edge => \&Graph::Traversal::has_a_cycle );
    push @r,
      down_edge => \&Graph::Traversal::has_a_cycle
       if $g->is_undirected;
    my $t = Graph::Traversal::DFS->new($g, @r, @_);
    $t->dfs;
    return $t->get_state('has_a_cycle');
}

sub find_a_cycle {
    my $g = shift;
    my @r = ( back_edge => \&Graph::Traversal::find_a_cycle);
    push @r,
      down_edge => \&Graph::Traversal::find_a_cycle
	if $g->is_undirected;
    my $t = Graph::Traversal::DFS->new($g, @r, @_);
    $t->dfs;
    $t->has_state('a_cycle') ? @{ $t->get_state('a_cycle') } : ();
}

###
# Attributes.

# Vertex attributes.

sub set_vertex_attribute {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $value = pop;
    my $attr  = pop;
    $g->add_vertex( @_ ) unless $g->has_vertex( @_ );
    $g->[ _V ]->_set_path_attr( @_, $attr, $value );
}

sub set_vertex_attribute_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $value = pop;
    my $attr  = pop;
    $g->add_vertex_by_id( @_ ) unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_set_path_attr( @_, $attr, $value );
}

sub set_vertex_attributes {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $attr = pop;
    $g->add_vertex( @_ ) unless $g->has_vertex( @_ );
    $g->[ _V ]->_set_path_attrs( @_, $attr );
}

sub set_vertex_attributes_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $attr = pop;
    $g->add_vertex_by_id( @_ ) unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_set_path_attrs( @_, $attr );
}

sub has_vertex_attributes {
    my $g = shift;
    $g->expect_non_multivertexed;
    return 0 unless $g->has_vertex( @_ );
    $g->[ _V ]->_has_path_attrs( @_ );
}

sub has_vertex_attributes_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    return 0 unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_has_path_attrs( @_ );
}

sub has_vertex_attribute {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $attr = pop;
    return 0 unless $g->has_vertex( @_ );
    $g->[ _V ]->_has_path_attr( @_, $attr );
}

sub has_vertex_attribute_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $attr = pop;
    return 0 unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_has_path_attr( @_, $attr );
}

sub get_vertex_attributes {
    my $g = shift;
    $g->expect_non_multivertexed;
    return unless $g->has_vertex( @_ );
    my $a = $g->[ _V ]->_get_path_attrs( @_ );
    ($g->is_compat02) ? (defined $a ? %{ $a } : ()) : $a;
}

sub get_vertex_attributes_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    return unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_get_path_attrs( @_ );
}

sub get_vertex_attribute {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $attr = pop;
    return unless $g->has_vertex( @_ );
    $g->[ _V ]->_get_path_attr( @_, $attr );
}

sub get_vertex_attribute_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $attr = pop;
    return unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_get_path_attr( @_, $attr );
}

sub get_vertex_attribute_names {
    my $g = shift;
    $g->expect_non_multivertexed;
    return unless $g->has_vertex( @_ );
    $g->[ _V ]->_get_path_attr_names( @_ );
}

sub get_vertex_attribute_names_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    return unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_get_path_attr_names( @_ );
}

sub get_vertex_attribute_values {
    my $g = shift;
    $g->expect_non_multivertexed;
    return unless $g->has_vertex( @_ );
    $g->[ _V ]->_get_path_attr_values( @_ );
}

sub get_vertex_attribute_values_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    return unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_get_path_attr_values( @_ );
}

sub delete_vertex_attributes {
    my $g = shift;
    $g->expect_non_multivertexed;
    return undef unless $g->has_vertex( @_ );
    $g->[ _V ]->_del_path_attrs( @_ );
}

sub delete_vertex_attributes_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    return undef unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_del_path_attrs( @_ );
}

sub delete_vertex_attribute {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $attr = pop;
    return undef unless $g->has_vertex( @_ );
    $g->[ _V ]->_del_path_attr( @_, $attr );
}

sub delete_vertex_attribute_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $attr = pop;
    return undef unless $g->has_vertex_by_id( @_ );
    $g->[ _V ]->_del_path_attr( @_, $attr );
}

# Edge attributes.

sub _set_edge_attribute {
    my $g = shift;
    my $value = pop;
    my $attr  = pop;
    my $E = $g->[ _E ];
    my $f = $E->[ _f ];
    my @i;
    if ($E->[ _a ] == 2 && @_ == 2 && !($f & (_HYPER|_REF|_UNIQ))) { # Fast path.
	@_ = sort @_ if ($f & _UNORD);
	my $s = $E->[ _s ];
	$g->add_edge( @_ ) unless exists $s->{ $_[0] } && exists $s->{ $_[0] }->{ $_[1] };
	@i = @{ $g->[ _V ]->[ _s ] }{ @_ };
    } else {
	$g->add_edge( @_ ) unless $g->has_edge( @_ );
	@i = $g->_vertex_ids( @_ );
    }
    $g->[ _E ]->_set_path_attr( @i, $attr, $value );
}

sub set_edge_attribute {
    my $g = shift;
    $g->expect_non_multiedged;
    my $value = pop;
    my $attr  = pop;
    my $E = $g->[ _E ];
    $g->add_edge( @_ ) unless $g->has_edge( @_ );
    $E->_set_path_attr( $g->_vertex_ids( @_ ), $attr, $value );
}

sub set_edge_attribute_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $value = pop;
    my $attr  = pop;
    # $g->add_edge_by_id( @_ ) unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_set_path_attr( $g->_vertex_ids( @_ ), $id, $attr, $value );
}

sub set_edge_attributes {
    my $g = shift;
    $g->expect_non_multiedged;
    my $attr = pop;
    $g->add_edge( @_ ) unless $g->has_edge( @_ );
    $g->[ _E ]->_set_path_attrs( $g->_vertex_ids( @_ ), $attr );
}

sub set_edge_attributes_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $attr = pop;
    $g->add_edge_by_id( @_ ) unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_set_path_attrs( $g->_vertex_ids( @_ ), $id, $attr );
}

sub has_edge_attributes {
    my $g = shift;
    $g->expect_non_multiedged;
    return 0 unless $g->has_edge( @_ );
    $g->[ _E ]->_has_path_attrs( $g->_vertex_ids( @_ ) );
}

sub has_edge_attributes_by_id {
    my $g = shift;
    $g->expect_multiedged;
    return 0 unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_has_path_attrs( $g->_vertex_ids( @_ ), $id );
}

sub has_edge_attribute {
    my $g = shift;
    $g->expect_non_multiedged;
    my $attr = pop;
    return 0 unless $g->has_edge( @_ );
    $g->[ _E ]->_has_path_attr( $g->_vertex_ids( @_ ), $attr );
}

sub has_edge_attribute_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $attr = pop;
    return 0 unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_has_path_attr( $g->_vertex_ids( @_ ), $id, $attr );
}

sub get_edge_attributes {
    my $g = shift;
    $g->expect_non_multiedged;
    return unless $g->has_edge( @_ );
    my $a = $g->[ _E ]->_get_path_attrs( $g->_vertex_ids( @_ ) );
    ($g->is_compat02) ? (defined $a ? %{ $a } : ()) : $a;
}

sub get_edge_attributes_by_id {
    my $g = shift;
    $g->expect_multiedged;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    return $g->[ _E ]->_get_path_attrs( $g->_vertex_ids( @_ ), $id );
}

sub _get_edge_attribute { # Fast path; less checks.
    my $g = shift;
    my $attr = pop;
    my $E = $g->[ _E ];
    my $f = $E->[ _f ];
    if ($E->[ _a ] == 2 && @_ == 2 && !($f & (_HYPER|_REF|_UNIQ))) { # Fast path.
	@_ = sort @_ if ($f & _UNORD);
	my $s = $E->[ _s ];
	return unless exists $s->{ $_[0] } && exists $s->{ $_[0] }->{ $_[1] };
    } else {
	return unless $g->has_edge( @_ );
    }
    my @i = $g->_vertex_ids( @_ );
    $E->_get_path_attr( @i, $attr );
}

sub get_edge_attribute {
    my $g = shift;
    $g->expect_non_multiedged;
    my $attr = pop;
    return undef unless $g->has_edge( @_ );
    my @i = $g->_vertex_ids( @_ );
    return undef if @i == 0 && @_;
    my $E = $g->[ _E ];
    $E->_get_path_attr( @i, $attr );
}

sub get_edge_attribute_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $attr = pop;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_get_path_attr( $g->_vertex_ids( @_ ), $id, $attr );
}

sub get_edge_attribute_names {
    my $g = shift;
    $g->expect_non_multiedged;
    return unless $g->has_edge( @_ );
    $g->[ _E ]->_get_path_attr_names( $g->_vertex_ids( @_ ) );
}

sub get_edge_attribute_names_by_id {
    my $g = shift;
    $g->expect_multiedged;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_get_path_attr_names( $g->_vertex_ids( @_ ), $id );
}

sub get_edge_attribute_values {
    my $g = shift;
    $g->expect_non_multiedged;
    return unless $g->has_edge( @_ );
    $g->[ _E ]->_get_path_attr_values( $g->_vertex_ids( @_ ) );
}

sub get_edge_attribute_values_by_id {
    my $g = shift;
    $g->expect_multiedged;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_get_path_attr_values( $g->_vertex_ids( @_ ), $id );
}

sub delete_edge_attributes {
    my $g = shift;
    $g->expect_non_multiedged;
    return unless $g->has_edge( @_ );
    $g->[ _E ]->_del_path_attrs( $g->_vertex_ids( @_ ) );
}

sub delete_edge_attributes_by_id {
    my $g = shift;
    $g->expect_multiedged;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_del_path_attrs( $g->_vertex_ids( @_ ), $id );
}

sub delete_edge_attribute {
    my $g = shift;
    $g->expect_non_multiedged;
    my $attr = pop;
    return unless $g->has_edge( @_ );
    $g->[ _E ]->_del_path_attr( $g->_vertex_ids( @_ ), $attr );
}

sub delete_edge_attribute_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $attr = pop;
    return unless $g->has_edge_by_id( @_ );
    my $id = pop;
    $g->[ _E ]->_del_path_attr( $g->_vertex_ids( @_ ), $id, $attr );
}

###
# Compat.
#

sub vertex {
    my $g = shift;
    $g->has_vertex( @_ ) ? @_ : undef;
}

sub out_edges {
    my $g = shift;
    return unless @_ && $g->has_vertex( @_ );
    my @e = $g->edges_from( @_ );
    wantarray ? map { @$_ } @e : @e;
}

sub in_edges {
    my $g = shift;
    return unless @_ && $g->has_vertex( @_ );
    my @e = $g->edges_to( @_ );
    wantarray ? map { @$_ } @e : @e;
}

sub add_vertices {
    my $g = shift;
    $g->add_vertex( $_ ) for @_;
}

sub add_edges {
    my $g = shift;
    while (@_) {
	my $u = shift @_;
	if (ref $u eq 'ARRAY') {
	    $g->add_edge( @$u );
	} else {
	    if (@_) {
		my $v = shift @_;
		$g->add_edge( $u, $v );
	    } else {
		require Carp;
		Carp::croak("Graph::add_edges: missing end vertex");
	    }
	}
    }
}

###
# More constructors.
#

sub copy {
    my $g = shift;
    my %opt = _get_options( \@_ );
    
    my $c = (ref $g)->new(directed => $g->directed ? 1 : 0,
			  compat02 => $g->compat02 ? 1 : 0);
    for my $v ($g->isolated_vertices) { $c->add_vertex($v) }
    for my $e ($g->edges05)           { $c->add_edge(@$e)  }
    return $c;
}

*copy_graph = \&copy;

sub deep_copy {
    require Data::Dumper;
    my $g = shift;
    my $d = Data::Dumper->new([$g]);
    use vars qw($VAR1);
    $d->Purity(1)->Terse(1)->Deepcopy(1);
    $d->Deparse(1) if $] >= 5.008;
    eval $d->Dump;
}

*deep_copy_graph = \&deep_copy;

sub transpose_edge {
    my $g = shift;
    if ($g->is_directed) {
	return undef unless $g->has_edge( @_ );
	my $c = $g->get_edge_count( @_ );
	my $a = $g->get_edge_attributes( @_ );
	my @e = reverse @_;
	$g->delete_edge( @_ ) unless $g->has_edge( @e );
	$g->add_edge( @e ) for 1..$c;
	$g->set_edge_attributes(@e, $a) if $a;
    }
    return $g;
}

sub transpose_graph {
    my $g = shift;
    my $t = $g->copy;
    if ($t->directed) {
	for my $e ($t->edges05) {
	    $t->transpose_edge(@$e);
	}
    }
    return $t;
}

*transpose = \&transpose_graph;

sub complete_graph {
    my $g = shift;
    my $c = $g->new( directed => $g->directed );
    my @v = $g->vertices05;
    for (my $i = 0; $i <= $#v; $i++ ) {
	for (my $j = 0; $j <= $#v; $j++ ) {
	    next if $i >= $j;
	    if ($g->is_undirected) {
		$c->add_edge($v[$i], $v[$j]);
	    } else {
		$c->add_edge($v[$i], $v[$j]);
		$c->add_edge($v[$j], $v[$i]);
	    }
	}
    }
    return $c;
}

*complement = \&complement_graph;

sub complement_graph {
    my $g = shift;
    my $c = $g->new( directed => $g->directed );
    my @v = $g->vertices05;
    for (my $i = 0; $i <= $#v; $i++ ) {
	for (my $j = 0; $j <= $#v; $j++ ) {
	    next if $i >= $j;
	    if ($g->is_undirected) {
		$c->add_edge($v[$i], $v[$j])
		    unless $g->has_edge($v[$i], $v[$j]);
	    } else {
		$c->add_edge($v[$i], $v[$j])
		    unless $g->has_edge($v[$i], $v[$j]);
		$c->add_edge($v[$j], $v[$i])
		    unless $g->has_edge($v[$j], $v[$i]);
	    }
	}
    }
    return $c;
}

*complete = \&complete_graph;

###
# Transitivity.
#

sub is_transitive {
    my $g = shift;
    Graph::TransitiveClosure::is_transitive($g);
}

###
# Weighted vertices.
#

my $defattr = 'weight';

sub _defattr {
    return $defattr;
}

sub add_weighted_vertex {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $w = pop;
    $g->add_vertex(@_);
    $g->set_vertex_attribute(@_, $defattr, $w);
}

sub add_weighted_vertices {
    my $g = shift;
    $g->expect_non_multivertexed;
    while (@_) {
	my ($v, $w) = splice @_, 0, 2;
	$g->add_vertex($v);
	$g->set_vertex_attribute($v, $defattr, $w);
    }
}

sub get_vertex_weight {
    my $g = shift;
    $g->expect_non_multivertexed;
    $g->get_vertex_attribute(@_, $defattr);
}

sub has_vertex_weight {
    my $g = shift;
    $g->expect_non_multivertexed;
    $g->has_vertex_attribute(@_, $defattr);
}

sub set_vertex_weight {
    my $g = shift;
    $g->expect_non_multivertexed;
    my $w = pop;
    $g->set_vertex_attribute(@_, $defattr, $w);
}

sub delete_vertex_weight {
    my $g = shift;
    $g->expect_non_multivertexed;
    $g->delete_vertex_attribute(@_, $defattr);
}

sub add_weighted_vertex_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $w = pop;
    $g->add_vertex_by_id(@_);
    $g->set_vertex_attribute_by_id(@_, $defattr, $w);
}

sub add_weighted_vertices_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $id = pop;
    while (@_) {
	my ($v, $w) = splice @_, 0, 2;
	$g->add_vertex_by_id($v, $id);
	$g->set_vertex_attribute_by_id($v, $id, $defattr, $w);
    }
}

sub get_vertex_weight_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    $g->get_vertex_attribute_by_id(@_, $defattr);
}

sub has_vertex_weight_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    $g->has_vertex_attribute_by_id(@_, $defattr);
}

sub set_vertex_weight_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    my $w = pop;
    $g->set_vertex_attribute_by_id(@_, $defattr, $w);
}

sub delete_vertex_weight_by_id {
    my $g = shift;
    $g->expect_multivertexed;
    $g->delete_vertex_attribute_by_id(@_, $defattr);
}

###
# Weighted edges.
#

sub add_weighted_edge {
    my $g = shift;
    $g->expect_non_multiedged;
    if ($g->is_compat02) {
	my $w = splice @_, 1, 1;
	$g->add_edge(@_);
	$g->set_edge_attribute(@_, $defattr, $w);
    } else {
	my $w = pop;
	$g->add_edge(@_);
	$g->set_edge_attribute(@_, $defattr, $w);
    }
}

sub add_weighted_edges {
    my $g = shift;
    $g->expect_non_multiedged;
    if ($g->is_compat02) {
	while (@_) {
	    my ($u, $w, $v) = splice @_, 0, 3;
	    $g->add_edge($u, $v);
	    $g->set_edge_attribute($u, $v, $defattr, $w);
	}
    } else {
	while (@_) {
	    my ($u, $v, $w) = splice @_, 0, 3;
	    $g->add_edge($u, $v);
	    $g->set_edge_attribute($u, $v, $defattr, $w);
	}
    }
}

sub add_weighted_edges_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $id = pop;
    while (@_) {
	my ($u, $v, $w) = splice @_, 0, 3;
	$g->add_edge_by_id($u, $v, $id);
	$g->set_edge_attribute_by_id($u, $v, $id, $defattr, $w);
    }
}

sub add_weighted_path {
    my $g = shift;
    $g->expect_non_multiedged;
    my $u = shift;
    while (@_) {
	my ($w, $v) = splice @_, 0, 2;
	$g->add_edge($u, $v);
	$g->set_edge_attribute($u, $v, $defattr, $w);
	$u = $v;
    }
}

sub get_edge_weight {
    my $g = shift;
    $g->expect_non_multiedged;
    $g->get_edge_attribute(@_, $defattr);
}

sub has_edge_weight {
    my $g = shift;
    $g->expect_non_multiedged;
    $g->has_edge_attribute(@_, $defattr);
}

sub set_edge_weight {
    my $g = shift;
    $g->expect_non_multiedged;
    my $w = pop;
    $g->set_edge_attribute(@_, $defattr, $w);
}

sub delete_edge_weight {
    my $g = shift;
    $g->expect_non_multiedged;
    $g->delete_edge_attribute(@_, $defattr);
}

sub add_weighted_edge_by_id {
    my $g = shift;
    $g->expect_multiedged;
    if ($g->is_compat02) {
	my $w = splice @_, 1, 1;
	$g->add_edge_by_id(@_);
	$g->set_edge_attribute_by_id(@_, $defattr, $w);
    } else {
	my $w = pop;
	$g->add_edge_by_id(@_);
	$g->set_edge_attribute_by_id(@_, $defattr, $w);
    }
}

sub add_weighted_path_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $id = pop;
    my $u = shift;
    while (@_) {
	my ($w, $v) = splice @_, 0, 2;
	$g->add_edge_by_id($u, $v, $id);
	$g->set_edge_attribute_by_id($u, $v, $id, $defattr, $w);
	$u = $v;
    }
}

sub get_edge_weight_by_id {
    my $g = shift;
    $g->expect_multiedged;
    $g->get_edge_attribute_by_id(@_, $defattr);
}

sub has_edge_weight_by_id {
    my $g = shift;
    $g->expect_multiedged;
    $g->has_edge_attribute_by_id(@_, $defattr);
}

sub set_edge_weight_by_id {
    my $g = shift;
    $g->expect_multiedged;
    my $w = pop;
    $g->set_edge_attribute_by_id(@_, $defattr, $w);
}

sub delete_edge_weight_by_id {
    my $g = shift;
    $g->expect_multiedged;
    $g->delete_edge_attribute_by_id(@_, $defattr);
}

###
# Error helpers.
#

my %expected;
@expected{qw(directed undirected acyclic)} = qw(undirected directed cyclic);

sub _expected {
    my $exp = shift;
    my $got = @_ ? shift : $expected{$exp};
    $got = defined $got ? ", got $got" : "";
    if (my @caller2 = caller(2)) {
	die "$caller2[3]: expected $exp graph$got, at $caller2[1] line $caller2[2].\n";
    } else {
	my @caller1 = caller(1);
	die "$caller1[3]: expected $exp graph$got, at $caller1[1] line $caller1[2].\n";
    }
}

sub expect_undirected {
    my $g = shift;
    _expected('undirected') unless $g->is_undirected;
}

sub expect_directed {
    my $g = shift;
    _expected('directed') unless $g->is_directed;
}

sub expect_acyclic {
    my $g = shift;
    _expected('acyclic') unless $g->is_acyclic;
}

sub expect_dag {
    my $g = shift;
    my @got;
    push @got, 'undirected' unless $g->is_directed;
    push @got, 'cyclic'     unless $g->is_acyclic;
    _expected('directed acyclic', "@got") if @got;
}

sub expect_multivertexed {
    my $g = shift;
    _expected('multivertexed') unless $g->is_multivertexed;
}

sub expect_non_multivertexed {
    my $g = shift;
    _expected('non-multivertexed') if $g->is_multivertexed;
}

sub expect_non_multiedged {
    my $g = shift;
    _expected('non-multiedged') if $g->is_multiedged;
}

sub expect_multiedged {
    my $g = shift;
    _expected('multiedged') unless $g->is_multiedged;
}

sub _get_options {
    my @caller = caller(1);
    unless (@_ == 1 && ref $_[0] eq 'ARRAY') {
	die "$caller[3]: internal error: should be called with only one array ref argument, at $caller[1] line $caller[2].\n";
    }
    my @opt = @{ $_[0] };
    unless (@opt  % 2 == 0) {
	die "$caller[3]: expected an options hash, got a non-even number of arguments, at $caller[1] line $caller[2].\n";
    }
    return @opt;
}

###
# Random constructors and accessors.
#

sub __fisher_yates_shuffle (@) {
    # From perlfaq4, but modified to be non-modifying.
    my @a = @_;
    my $i = @a;
    while ($i--) {
	my $j = int rand ($i+1);
	@a[$i,$j] = @a[$j,$i];
    }
    return @a;
}

BEGIN {
    sub _shuffle(@);
    # Workaround for the Perl bug [perl #32383] where -d:Dprof and
    # List::Util::shuffle do not like each other: if any debugging
    # (-d) flags are on, fall back to our own Fisher-Yates shuffle.
    # The bug was fixed by perl changes #26054 and #26062, which
    # went to Perl 5.9.3.  If someone tests this with a pre-5.9.3
    # bleadperl that calls itself 5.9.3 but doesn't yet have the
    # patches, oh, well.
    *_shuffle = $^P && $] < 5.009003 ?
	\&__fisher_yates_shuffle : \&List::Util::shuffle;
}

sub random_graph {
    my $class = (@_ % 2) == 0 ? 'Graph' : shift;
    my %opt = _get_options( \@_ );
    my $random_edge;
    unless (exists $opt{vertices} && defined $opt{vertices}) {
	require Carp;
	Carp::croak("Graph::random_graph: argument 'vertices' missing or undef");
    }
    if (exists $opt{random_seed}) {
	srand($opt{random_seed});
	delete $opt{random_seed};
    }
    if (exists $opt{random_edge}) {
	$random_edge = $opt{random_edge};
	delete $opt{random_edge};
    }
    my @V;
    if (my $ref = ref $opt{vertices}) {
	if ($ref eq 'ARRAY') {
	    @V = @{ $opt{vertices} };
	} else {
	    Carp::croak("Graph::random_graph: argument 'vertices' illegal");
	}
    } else {
	@V = 0..($opt{vertices} - 1);
    }
    delete $opt{vertices};
    my $V = @V;
    my $C = $V * ($V - 1) / 2;
    my $E;
    if (exists $opt{edges} && exists $opt{edges_fill}) {
	Carp::croak("Graph::random_graph: both arguments 'edges' and 'edges_fill' specified");
    }
    $E = exists $opt{edges_fill} ? $opt{edges_fill} * $C : $opt{edges};
    delete $opt{edges};
    delete $opt{edges_fill};
    my $g = $class->new(%opt);
    $g->add_vertices(@V);
    return $g if $V < 2;
    $C *= 2 if $g->directed;
    $E = $C / 2 unless defined $E;
    $E = int($E + 0.5);
    my $p = $E / $C;
    $random_edge = sub { $p } unless defined $random_edge;
    # print "V = $V, E = $E, C = $C, p = $p\n";
    if ($p > 1.0 && !($g->countedged || $g->multiedged)) {
	require Carp;
	Carp::croak("Graph::random_graph: needs to be countedged or multiedged ($E > $C)");
    }
    my @V1 = @V;
    my @V2 = @V;
    # Shuffle the vertex lists so that the pairs at
    # the beginning of the lists are not more likely.
    @V1 = _shuffle @V1;
    @V2 = _shuffle @V2;
 LOOP:
    while ($E) {
	for my $v1 (@V1) {
	    for my $v2 (@V2) {
		next if $v1 eq $v2; # TODO: allow self-loops?
		my $q = $random_edge->($g, $v1, $v2, $p);
		if ($q && ($q == 1 || rand() <= $q) &&
		    !$g->has_edge($v1, $v2)) {
		    $g->add_edge($v1, $v2);
		    $E--;
		    last LOOP unless $E;
		}
	    }
	}
    }
    return $g;
}

sub random_vertex {
    my $g = shift;
    my @V = $g->vertices05;
    @V[rand @V];
}

sub random_edge {
    my $g = shift;
    my @E = $g->edges05;
    @E[rand @E];
}

sub random_successor {
    my ($g, $v) = @_;
    my @S = $g->successors($v);
    @S[rand @S];
}

sub random_predecessor {
    my ($g, $v) = @_;
    my @P = $g->predecessors($v);
    @P[rand @P];
}

###
# Algorithms.
#

my $MST_comparator = sub { ($_[0] || 0) <=> ($_[1] || 0) };

sub _MST_attr {
    my $attr = shift;
    my $attribute =
	exists $attr->{attribute}  ?
	    $attr->{attribute}  : $defattr;
    my $comparator =
	exists $attr->{comparator} ?
	    $attr->{comparator} : $MST_comparator;
    return ($attribute, $comparator);
}

sub _MST_edges {
    my ($g, $attr) = @_;
    my ($attribute, $comparator) = _MST_attr($attr);
    map { $_->[1] }
        sort { $comparator->($a->[0], $b->[0], $a->[1], $b->[1]) }
             map { [ $g->get_edge_attribute(@$_, $attribute), $_ ] }
                 $g->edges05;
}

sub MST_Kruskal {
    my ($g, %attr) = @_;

    $g->expect_undirected;

    my $MST = Graph::Undirected->new;

    my $UF  = Graph::UnionFind->new;
    for my $v ($g->vertices05) { $UF->add($v) }

    for my $e ($g->_MST_edges(\%attr)) {
	my ($u, $v) = @$e; # TODO: hyperedges
	my $t0 = $UF->find( $u );
	my $t1 = $UF->find( $v );
	unless ($t0 eq $t1) {
	    $UF->union($u, $v);
	    $MST->add_edge($u, $v);
	}
    }

    return $MST;
}

sub _MST_add {
    my ($g, $h, $HF, $r, $attr, $unseen) = @_;
    for my $s ( grep { exists $unseen->{ $_ } } $g->successors( $r ) ) {
	$HF->add( Graph::MSTHeapElem->new( $r, $s, $g->get_edge_attribute( $r, $s, $attr ) ) );
    }
}

sub _next_alphabetic { shift; (sort               keys %{ $_[0] })[0] }
sub _next_numeric    { shift; (sort { $a <=> $b } keys %{ $_[0] })[0] }
sub _next_random     { shift; (values %{ $_[0] })[ rand keys %{ $_[0] } ] }

sub _root_opt {
    my $g = shift;
    my %opt = @_ == 1 ? ( first_root => $_[0] ) : _get_options( \@_ );
    my %unseen;
    my @unseen = $g->vertices05;
    @unseen{ @unseen } = @unseen;
    @unseen = _shuffle @unseen;
    my $r;
    if (exists $opt{ start }) {
	$opt{ first_root } = $opt{ start };
	$opt{ next_root  } = undef;
    }
    if (exists $opt{ get_next_root }) {
	$opt{ next_root  } = $opt{ get_next_root }; # Graph 0.201 compat.
    }
    if (exists $opt{ first_root }) {
	if (ref $opt{ first_root } eq 'CODE') {
	    $r = $opt{ first_root }->( $g, \%unseen );
	} else {
	    $r = $opt{ first_root };
	}
    } else {
	$r = shift @unseen;
    }
    my $next =
	exists $opt{ next_root } ?
	    $opt{ next_root } :
		$opt{ next_alphabetic } ?
		    \&_next_alphabetic :
			$opt{ next_numeric } ? \&_next_numeric :
			    \&_next_random;
    my $code = ref $next eq 'CODE';
    my $attr = exists $opt{ attribute } ? $opt{ attribute } : $defattr;
    return ( \%opt, \%unseen, \@unseen, $r, $next, $code, $attr );
}

sub _heap_walk {
    my ($g, $h, $add, $etc) = splice @_, 0, 4; # Leave %opt in @_.

    my ($opt, $unseenh, $unseena, $r, $next, $code, $attr) = $g->_root_opt(@_);
    my $HF = Heap071::Fibonacci->new;

    while (defined $r) {
	# print "r = $r\n";
	$add->($g, $h, $HF, $r, $attr, $unseenh, $etc);
	delete $unseenh->{ $r };
	while (defined $HF->top) {
	    my $t = $HF->extract_top;
	    # use Data::Dumper; print "t = ", Dumper($t);
	    if (defined $t) {
		my ($u, $v, $w) = $t->val;
		# print "extracted top: $u $v $w\n";
		if (exists $unseenh->{ $v }) {
		    $h->set_edge_attribute($u, $v, $attr, $w);
		    delete $unseenh->{ $v };
		    $add->($g, $h, $HF, $v, $attr, $unseenh, $etc);
		}
	    }
	}
	return $h unless defined $next;
	$r = $code ? $next->( $g, $unseenh ) : shift @$unseena;
    }

    return $h;
}

sub MST_Prim {
    my $g = shift;
    $g->expect_undirected;
    $g->_heap_walk(Graph::Undirected->new(), \&_MST_add, undef, @_);
}

*MST_Dijkstra = \&MST_Prim;

*minimum_spanning_tree = \&MST_Prim;

###
# Cycle detection.
#

*is_cyclic = \&has_a_cycle;

sub is_acyclic {
    my $g = shift;
    return !$g->is_cyclic;
}

sub is_dag {
    my $g = shift;
    return $g->is_directed && $g->is_acyclic ? 1 : 0;
}

*is_directed_acyclic_graph = \&is_dag;

###
# Backward compat.
#

sub average_degree {
    my $g = shift;
    my $V = $g->vertices05;

    return $V ? $g->degree / $V : 0;
}

sub density_limits {
    my $g = shift;

    my $V = $g->vertices05;
    my $M = $V * ($V - 1);

    $M /= 2 if $g->is_undirected;

    return ( 0.25 * $M, 0.75 * $M, $M );
}

sub density {
    my $g = shift;
    my ($sparse, $dense, $complete) = $g->density_limits;

    return $complete ? $g->edges / $complete : 0;
}

###
# Attribute backward compat
#

sub _attr02_012 {
    my ($g, $op, $ga, $va, $ea) = splice @_, 0, 5;
    if ($g->is_compat02) {
	if    (@_ == 0) { return $ga->( $g ) }
	elsif (@_ == 1) { return $va->( $g, @_ ) }
	elsif (@_ == 2) { return $ea->( $g, @_ ) }
	else {
	    die sprintf "$op: wrong number of arguments (%d)", scalar @_;
	}
    } else {
	die "$op: not a compat02 graph"
    }
}

sub _attr02_123 {
    my ($g, $op, $ga, $va, $ea) = splice @_, 0, 5;
    if ($g->is_compat02) {
	if    (@_ == 1) { return $ga->( $g, @_ ) }
	elsif (@_ == 2) { return $va->( $g, @_[1, 0] ) }
	elsif (@_ == 3) { return $ea->( $g, @_[1, 2, 0] ) }
	else {
	    die sprintf "$op: wrong number of arguments (%d)", scalar @_;
	}
    } else {
	die "$op: not a compat02 graph"
    }
}

sub _attr02_234 {
    my ($g, $op, $ga, $va, $ea) = splice @_, 0, 5;
    if ($g->is_compat02) {
	if    (@_ == 2) { return $ga->( $g, @_ ) }
	elsif (@_ == 3) { return $va->( $g, @_[1, 0, 2] ) }
	elsif (@_ == 4) { return $ea->( $g, @_[1, 2, 0, 3] ) }
	else {
	    die sprintf "$op: wrong number of arguments (%d)", scalar @_;
	}
    } else {
	die "$op: not a compat02 graph";
    }
}

sub set_attribute {
    my $g = shift;
    $g->_attr02_234('set_attribute',
		    \&Graph::set_graph_attribute,
		    \&Graph::set_vertex_attribute,
		    \&Graph::set_edge_attribute,
		    @_);

}

sub set_attributes {
    my $g = shift;
    my $a = pop;
    $g->_attr02_123('set_attributes',
		    \&Graph::set_graph_attributes,
		    \&Graph::set_vertex_attributes,
		    \&Graph::set_edge_attributes,
		    $a, @_);

}

sub get_attribute {
    my $g = shift;
    $g->_attr02_123('get_attribute',
		    \&Graph::get_graph_attribute,
		    \&Graph::get_vertex_attribute,
		    \&Graph::get_edge_attribute,
		    @_);

}

sub get_attributes {
    my $g = shift;
    $g->_attr02_012('get_attributes',
		    \&Graph::get_graph_attributes,
		    \&Graph::get_vertex_attributes,
		    \&Graph::get_edge_attributes,
		    @_);

}

sub has_attribute {
    my $g = shift;
    return 0 unless @_;
    $g->_attr02_123('has_attribute',
		    \&Graph::has_graph_attribute,
		    \&Graph::has_vertex_attribute,
		    \&Graph::get_edge_attribute,
		    @_);

}

sub has_attributes {
    my $g = shift;
    $g->_attr02_012('has_attributes',
		    \&Graph::has_graph_attributes,
		    \&Graph::has_vertex_attributes,
		    \&Graph::has_edge_attributes,
		    @_);

}

sub delete_attribute {
    my $g = shift;
    $g->_attr02_123('delete_attribute',
		    \&Graph::delete_graph_attribute,
		    \&Graph::delete_vertex_attribute,
		    \&Graph::delete_edge_attribute,
		    @_);

}

sub delete_attributes {
    my $g = shift;
    $g->_attr02_012('delete_attributes',
		    \&Graph::delete_graph_attributes,
		    \&Graph::delete_vertex_attributes,
		    \&Graph::delete_edge_attributes,
		    @_);

}

###
# Simple DFS uses.
#

sub topological_sort {
    my $g = shift;
    my %opt = _get_options( \@_ );
    my $eic = $opt{ empty_if_cyclic };
    my $hac;
    if ($eic) {
	$hac = $g->has_a_cycle;
    } else {
	$g->expect_dag;
    }
    delete $opt{ empty_if_cyclic };
    my $t = Graph::Traversal::DFS->new($g, %opt);
    my @s = $t->dfs;
    $hac ? () : reverse @s;
}

*toposort = \&topological_sort;

sub undirected_copy {
    my $g = shift;

    $g->expect_directed;

    my $c = Graph::Undirected->new;
    for my $v ($g->isolated_vertices) { # TODO: if iv ...
	$c->add_vertex($v);
    }
    for my $e ($g->edges05) {
	$c->add_edge(@$e);
    }
    return $c;
}

*undirected_copy_graph = \&undirected_copy;

sub directed_copy {
    my $g = shift;
    $g->expect_undirected;
    my $c = Graph::Directed->new;
    for my $v ($g->isolated_vertices) { # TODO: if iv ...
	$c->add_vertex($v);
    }
    for my $e ($g->edges05) {
	my @e = @$e;
	$c->add_edge(@e);
	$c->add_edge(reverse @e);
    }
    return $c;
}

*directed_copy_graph = \&directed_copy;

###
# Cache or not.
#

my %_cache_type =
    (
     'connectivity'        => '_ccc',
     'strong_connectivity' => '_scc',
     'biconnectivity'      => '_bcc',
     'SPT_Dijkstra'        => '_spt_di',
     'SPT_Bellman_Ford'    => '_spt_bf',
    );

sub _check_cache {
    my ($g, $type, $code) = splice @_, 0, 3;
    my $c = $_cache_type{$type};
    if (defined $c) {
	my $a = $g->get_graph_attribute($c);
	unless (defined $a && $a->[ 0 ] == $g->[ _G ]) {
	    $a->[ 0 ] = $g->[ _G ];
	    $a->[ 1 ] = $code->( $g, @_ );
	    $g->set_graph_attribute($c, $a);
	}
	return $a->[ 1 ];
    } else {
	Carp::croak("Graph: unknown cache type '$type'");
    }
}

sub _clear_cache {
    my ($g, $type) = @_;
    my $c = $_cache_type{$type};
    if (defined $c) {
	$g->delete_graph_attribute($c);
    } else {
	Carp::croak("Graph: unknown cache type '$type'");
    }
}

sub connectivity_clear_cache {
    my $g = shift;
    _clear_cache($g, 'connectivity');
}

sub strong_connectivity_clear_cache {
    my $g = shift;
    _clear_cache($g, 'strong_connectivity');
}

sub biconnectivity_clear_cache {
    my $g = shift;
    _clear_cache($g, 'biconnectivity');
}

sub SPT_Dijkstra_clear_cache {
    my $g = shift;
    _clear_cache($g, 'SPT_Dijkstra');
    $g->delete_graph_attribute('SPT_Dijkstra_first_root');
}

sub SPT_Bellman_Ford_clear_cache {
    my $g = shift;
    _clear_cache($g, 'SPT_Bellman_Ford');
}

###
# Connected components.
#

sub _connected_components_compute {
    my $g = shift;
    my %cce;
    my %cci;
    my $cc = 0;
    if ($g->has_union_find) {
	my $UF = $g->_get_union_find();
	my $V  = $g->[ _V ];
	my %icce; # Isolated vertices.
	my %icci;
	my $icc = 0;
	for my $v ( $g->unique_vertices ) {
	    $cc = $UF->find( $V->_get_path_id( $v ) );
	    if (defined $cc) {
		$cce{ $v } = $cc;
		push @{ $cci{ $cc } }, $v;
	    } else {
		$icce{ $v } = $icc;
		push @{ $icci{ $icc } }, $v;
		$icc++;
	    }
	}
	if ($icc) {
	    @cce{ keys %icce } = values %icce;
	    @cci{ keys %icci } = values %icci;
	}
    } else {
	my @u = $g->unique_vertices;
	my %r; @r{ @u } = @u;
	my $froot = sub {
	    (each %r)[1];
	};
	my $nroot = sub {
	    $cc++ if keys %r;
	    (each %r)[1];
	};
	my $t = Graph::Traversal::DFS->new($g,
					   first_root => $froot,
					   next_root  => $nroot,
					   pre => sub {
					       my ($v, $t) = @_;
					       $cce{ $v } = $cc;
					       push @{ $cci{ $cc } }, $v;
					       delete $r{ $v };
					   },
					   @_);
	$t->dfs;
    }
    return [ \%cce, \%cci ];
}

sub _connected_components {
    my $g = shift;
    my $ccc = _check_cache($g, 'connectivity',
			   \&_connected_components_compute, @_);
    return @{ $ccc };
}

sub connected_component_by_vertex {
    my ($g, $v) = @_;
    $g->expect_undirected;
    my ($CCE, $CCI) = $g->_connected_components();
    return $CCE->{ $v };
}

sub connected_component_by_index {
    my ($g, $i) = @_;
    $g->expect_undirected;
    my ($CCE, $CCI) = $g->_connected_components();
    return defined $CCI->{ $i } ? @{ $CCI->{ $i } } : ( );
}

sub connected_components {
    my $g = shift;
    $g->expect_undirected;
    my ($CCE, $CCI) = $g->_connected_components();
    return values %{ $CCI };
}

sub same_connected_components {
    my $g = shift;
    $g->expect_undirected;
    if ($g->has_union_find) {
	my $UF = $g->_get_union_find();
	my $V  = $g->[ _V ];
	my $u = shift;
	my $c = $UF->find( $V->_get_path_id ( $u ) );
	my $d;
	for my $v ( @_) {
	    return 0
		unless defined($d = $UF->find( $V->_get_path_id( $v ) )) &&
		       $d eq $c;
	}
	return 1;
    } else {
	my ($CCE, $CCI) = $g->_connected_components();
	my $u = shift;
	my $c = $CCE->{ $u };
	for my $v ( @_) {
	    return 0
		unless defined $CCE->{ $v } &&
		       $CCE->{ $v } eq $c;
	}
	return 1;
    }
}

my $super_component = sub { join("+", sort @_) };

sub connected_graph {
    my ($g, %opt) = @_;
    $g->expect_undirected;
    my $cg = Graph->new(undirected => 1);
    if ($g->has_union_find && $g->vertices == 1) {
	# TODO: super_component?
	$cg->add_vertices($g->vertices);
    } else {
	my $sc_cb =
	    exists $opt{super_component} ?
		$opt{super_component} : $super_component;
	for my $cc ( $g->connected_components() ) {
	    my $sc = $sc_cb->(@$cc);
	    $cg->add_vertex($sc);
	    $cg->set_vertex_attribute($sc, 'subvertices', [ @$cc ]);
	}
    }
    return $cg;
}

sub is_connected {
    my $g = shift;
    $g->expect_undirected;
    my ($CCE, $CCI) = $g->_connected_components();
    return keys %{ $CCI } == 1;
}

sub is_weakly_connected {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->is_connected(@_);
}

*weakly_connected = \&is_weakly_connected;

sub weakly_connected_components {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->connected_components(@_);
}

sub weakly_connected_component_by_vertex {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->connected_component_by_vertex(@_);
}

sub weakly_connected_component_by_index {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->connected_component_by_index(@_);
}

sub same_weakly_connected_components {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->same_connected_components(@_);
}

sub weakly_connected_graph {
    my $g = shift;
    $g->expect_directed;
    $g->undirected_copy->connected_graph(@_);
}

sub _strongly_connected_components_compute {
    my $g = shift;
    my $t = Graph::Traversal::DFS->new($g);
    my @d = reverse $t->dfs;
    my @c;
    my $h = $g->transpose_graph;
    my $u =
	Graph::Traversal::DFS->new($h,
				   next_root => sub {
				       my ($t, $u) = @_;
				       my $root;
				       while (defined($root = shift @d)) {
					   last if exists $u->{ $root };
				       }
				       if (defined $root) {
					   push @c, [];
					   return $root;
				       } else {
					   return;
				       }
				   },
				   pre => sub {
				       my ($v, $t) = @_;
				       push @{ $c[-1] }, $v;
				   },
				   @_);
    $u->dfs;
    return \@c;
}

sub _strongly_connected_components {
    my $g = shift;
    my $scc = _check_cache($g, 'strong_connectivity',
			   \&_strongly_connected_components_compute, @_);
    return defined $scc ? @$scc : ( );
}

sub strongly_connected_components {
    my $g = shift;
    $g->expect_directed;
    $g->_strongly_connected_components(@_);
}

sub strongly_connected_component_by_vertex {
    my $g = shift;
    my $v = shift;
    $g->expect_directed;
    my @scc = $g->_strongly_connected_components( next_alphabetic => 1, @_ );
    for (my $i = 0; $i <= $#scc; $i++) {
	for (my $j = 0; $j <= $#{ $scc[$i] }; $j++) {
	    return $i if $scc[$i]->[$j] eq $v;
	}
    }
    return;
}

sub strongly_connected_component_by_index {
    my $g = shift;
    my $i = shift;
    $g->expect_directed;
    my $c = ( $g->_strongly_connected_components(@_) )[ $i ];
    return defined $c ? @{ $c } : ();
}

sub same_strongly_connected_components {
    my $g = shift;
    $g->expect_directed;
    my @scc = $g->_strongly_connected_components( next_alphabetic => 1, @_ );
    my @i;
    while (@_) {
	my $v = shift;
	for (my $i = 0; $i <= $#scc; $i++) {
	    for (my $j = 0; $j <= $#{ $scc[$i] }; $j++) {
		if ($scc[$i]->[$j] eq $v) {
		    push @i, $i;
		    return 0 if @i > 1 && $i[-1] ne $i[0];
		}
	    }
	}
    }
    return 1;
}

sub is_strongly_connected {
    my $g = shift;
    $g->expect_directed;
    my $t = Graph::Traversal::DFS->new($g);
    my @d = reverse $t->dfs;
    my @c;
    my $h = $g->transpose;
    my $u =
	Graph::Traversal::DFS->new($h,
				   next_root => sub {
				       my ($t, $u) = @_;
				       my $root;
				       while (defined($root = shift @d)) {
					   last if exists $u->{ $root };
				       }
				       if (defined $root) {
					   unless (@{ $t->{ roots } }) {
					       push @c, [];
					       return $root;
					   } else {
					       $t->terminate;
					       return;
					   }
				       } else {
					   return;
				       }
				   },
				   pre => sub {
				       my ($v, $t) = @_;
				       push @{ $c[-1] }, $v;
				   },
				   @_);
    $u->dfs;
    return @{ $u->{ roots } } == 1 && keys %{ $u->{ unseen } } == 0;
}

*strongly_connected = \&is_strongly_connected;

sub strongly_connected_graph {
    my $g = shift;
    my %attr = @_;

    $g->expect_directed;

    my $t = Graph::Traversal::DFS->new($g);
    my @d = reverse $t->dfs;
    my @c;
    my $h = $g->transpose;
    my $u =
	Graph::Traversal::DFS->new($h,
				   next_root => sub {
				       my ($t, $u) = @_;
				       my $root;
				       while (defined($root = shift @d)) {
					   last if exists $u->{ $root };
				       }
				       if (defined $root) {
					   push @c, [];
					   return $root;
				       } else {
					   return;
				       }
				   },
				   pre => sub {
				       my ($v, $t) = @_;
				       push @{ $c[-1] }, $v;
				   }
				   );

    $u->dfs;

    my $sc_cb;
    my $hv_cb;

    _opt_get(\%attr, super_component => \$sc_cb);
    _opt_get(\%attr, hypervertex => \$hv_cb);
    _opt_unknown(\%attr);

    if (defined $hv_cb && !defined $sc_cb) {
	$sc_cb = sub { $hv_cb->( [ @_ ] ) };
    }
    unless (defined $sc_cb) {
	$sc_cb = $super_component;
    }

    my $s = Graph->new;

    my %c;
    my @s;
    for (my $i = 0; $i <  @c; $i++) {
	my $c = $c[$i];
	$s->add_vertex( $s[$i] = $sc_cb->(@$c) );
	$s->set_vertex_attribute($s[$i], 'subvertices', [ @$c ]);
	for my $v (@$c) {
	    $c{$v} = $i;
	}
    }

    my $n = @c;
    for my $v ($g->vertices) {
	unless (exists $c{$v}) {
	    $c{$v} = $n;
	    $s[$n] = $v;
	    $n++;
	}
    }

    for my $e ($g->edges05) {
	my ($u, $v) = @$e; # @TODO: hyperedges
	unless ($c{$u} == $c{$v}) {
	    my ($p, $q) = ( $s[ $c{ $u } ], $s[ $c{ $v } ] );
	    $s->add_edge($p, $q) unless $s->has_edge($p, $q);
	}
    }

    if (my @i = $g->isolated_vertices) {
	$s->add_vertices(map { $s[ $c{ $_ } ] } @i);
    }

    return $s;
}

###
# Biconnectivity.
#

sub _make_bcc {
    my ($S, $v, $c) = @_;
    my %b;
    while (@$S) {
	my $t = pop @$S;
	$b{ $t } = $t;
	last if $t eq $v;
    }
    return [ values %b, $c ];
}

sub _biconnectivity_compute {
    my $g = shift;
    my ($opt, $unseenh, $unseena, $r, $next, $code, $attr) =
	$g->_root_opt(@_);
    return () unless defined $r;
    my %P;
    my %I;
    for my $v ($g->vertices) {
	$I{ $v } = 0;
    }
    $I{ $r } = 1;
    my %U;
    my %S; # Self-loops.
    for my $e ($g->edges) {
	my ($u, $v) = @$e;
	$U{ $u }{ $v } = 0;
	$U{ $v }{ $u } = 0;
	$S{ $u } = 1 if $u eq $v;
    }
    my $i = 1;
    my $v = $r;
    my %AP;
    my %L = ( $r => 1 );
    my @S = ( $r );
    my %A;
    my @V = $g->vertices;

    # print "V : @V\n";
    # print "r : $r\n";

    my %T; @T{ @V } = @V;

    for my $w (@V) {
	my @s = $g->successors( $w );
	if (@s) {
	    @s = grep { $_ eq $w ? ( delete $T{ $w }, 0 ) : 1 } @s;
	    @{ $A{ $w } }{ @s } = @s;
	} elsif ($g->predecessors( $w ) == 0) {
	    delete $T{ $w };
	    if ($w eq $r) {
		delete $I { $r };
		$r = $v = each %T;
		if (defined $r) {
		    %L = ( $r => 1 );
		    @S = ( $r );
		    $I{ $r } = 1;
		    # print "r : $r\n";
		}
	    }
	}
    }

    # use Data::Dumper;
    # print "T : ", Dumper(\%T);
    # print "A : ", Dumper(\%A);

    my %V2BC;
    my @BR;
    my @BC;

    my @C;
    my $Avok;

    while (keys %T) {
	# print "T = ", Dumper(\%T);
	do {
	    my $w;
	    do {
		my @w = _shuffle values %{ $A{ $v } };
		# print "w = @w\n";
		$w = first { !$U{ $v }{ $_ } } @w;
		if (defined $w) {
		    # print "w = $w\n";
		    $U{ $v }{ $w }++;
		    $U{ $w }{ $v }++;
		    if ($I{ $w } == 0) {
			$P{ $w } = $v;
			$i++;
			$I{ $w } = $i;
			$L{ $w } = $i;
			push @S, $w;
			$v = $w;
		    } else {
			$L{ $v } = $I{ $w } if $I{ $w } < $L{ $v };
		    }
		}
	    } while (defined $w);
	    # print "U = ", Dumper(\%U);
	    # print "P = ", Dumper(\%P);
	    # print "L = ", Dumper(\%L);
	    if (!defined $P{ $v }) {
		# Do nothing.
	    } elsif ($P{ $v } ne $r) {
		if ($L{ $v } < $I{ $P{ $v } }) {
		    $L{ $P{ $v } } = $L{ $v } if $L{ $v } < $L{ $P{ $v } };
		} else {
		    $AP{ $P{ $v } } = $P{ $v };
		    push @C, _make_bcc(\@S, $v, $P{ $v } );
		}
	    } else {
		my $e;
		for my $w (_shuffle keys %{ $A{ $r } }) {
		    # print "w = $w\n";
		    unless ($U{ $r }{ $w }) {
			$e = $r;
			# print "e = $e\n";
			last;
		    }
		}
		$AP{ $e } = $e if defined $e;
		push @C, _make_bcc(\@S, $v, $r);
	    }
	    # print "AP = ", Dumper(\%AP);
	    # print "C  = ", Dumper(\@C);
	    # print "L  = ", Dumper(\%L);
	    $v = defined $P{ $v } ? $P{ $v } : $r;
	    # print "v = $v\n";
	    $Avok = 0;
	    if (defined $v) {
		if (keys %{ $A{ $v } }) {
		    if (!exists $P{ $v }) {
			for my $w (keys %{ $A{ $v } }) {
			    $Avok++ if $U{ $v }{ $w };
			}
			# print "Avok/1 = $Avok\n";
			$Avok = 0 unless $Avok == keys %{ $A{ $v } };
			# print "Avok/2 = $Avok\n";
		    }
		} else {
		    $Avok = 1;
		    # print "Avok/3 = $Avok\n";
		}
	    }
	} until ($Avok);

	last if @C == 0 && !exists $S{$v};

	for (my $i = 0; $i < @C; $i++) {
	    for my $v (@{ $C[ $i ]}) {
		$V2BC{ $v }{ $i }++;
		delete $T{ $v };
	    }
	}

	for (my $i = 0; $i < @C; $i++) {
	    if (@{ $C[ $i ] } == 2) {
		push @BR, $C[ $i ];
	    } else {
		push @BC, $C[ $i ];
	    }
	}

	if (keys %T) {
	    $r = $v = each %T;
	}
    }
    
    return [ [values %AP], \@BC, \@BR, \%V2BC ];
}

sub biconnectivity {
    my $g = shift;
    $g->expect_undirected;
    my $bcc = _check_cache($g, 'biconnectivity',
			   \&_biconnectivity_compute, @_);
    return defined $bcc ? @$bcc : ( );
}

sub is_biconnected {
    my $g = shift;
    my ($ap, $bc) = ($g->biconnectivity(@_))[0, 1];
    return defined $ap ? @$ap == 0 && $g->vertices >= 3 : undef;
}

sub is_edge_connected {
    my $g = shift;
    my ($br) = ($g->biconnectivity(@_))[2];
    return defined $br ? @$br == 0 && $g->edges : undef;
}

sub is_edge_separable {
    my $g = shift;
    my $c = $g->is_edge_connected;
    defined $c ? !$c && $g->edges : undef;
}

sub articulation_points {
    my $g = shift;
    my ($ap) = ($g->biconnectivity(@_))[0];
    return defined $ap ? @$ap : ();
}

*cut_vertices = \&articulation_points;

sub biconnected_components {
    my $g = shift;
    my ($bc) = ($g->biconnectivity(@_))[1];
    return defined $bc ? @$bc : ();
}

sub biconnected_component_by_index {
    my $g = shift;
    my $i = shift;
    my ($bc) = ($g->biconnectivity(@_))[1];
    return defined $bc ? $bc->[ $i ] : undef;
}

sub biconnected_component_by_vertex {
    my $g = shift;
    my $v = shift;
    my ($v2bc) = ($g->biconnectivity(@_))[3];
    return defined $v2bc->{ $v } ? keys %{ $v2bc->{ $v } } : ();
}

sub same_biconnected_components {
    my $g = shift;
    my $u = shift;
    my @u = $g->biconnected_component_by_vertex($u, @_);
    return 0 unless @u;
    my %ubc; @ubc{ @u } = ();
    while (@_) {
	my $v = shift;
	my @v = $g->biconnected_component_by_vertex($v);
	if (@v) {
	    my %vbc; @vbc{ @v } = ();
	    my $vi;
	    for my $ui (keys %ubc) {
		if (exists $vbc{ $ui }) {
		    $vi = $ui;
		    last;
		}
	    }
	    return 0 unless defined $vi;
	}
    }
    return 1;
}

sub biconnected_graph {
    my ($g, %opt) = @_;
    my ($bc, $v2bc) = ($g->biconnectivity, %opt)[1, 3];
    my $bcg = Graph::Undirected->new;
    my $sc_cb =
	exists $opt{super_component} ?
	    $opt{super_component} : $super_component;
    for my $c (@$bc) {
	$bcg->add_vertex(my $s = $sc_cb->(@$c));
	$bcg->set_vertex_attribute($s, 'subvertices', [ @$c ]);
    }
    my %k;
    for my $i (0..$#$bc) {
	my @u = @{ $bc->[ $i ] };
	my %i; @i{ @u } = ();
	for my $j (0..$#$bc) {
	    if ($i > $j) {
		my @v = @{ $bc->[ $j ] };
		my %j; @j{ @v } = ();
		for my $u (@u) {
		    if (exists $j{ $u }) {
			unless ($k{ $i }{ $j }++) {
			    $bcg->add_edge($sc_cb->(@{$bc->[$i]}),
					   $sc_cb->(@{$bc->[$j]}));
			}
			last;
		    }
		}
	    }
	}
    }
    return $bcg;
}

sub bridges {
    my $g = shift;
    my ($br) = ($g->biconnectivity(@_))[2];
    return defined $br ? @$br : ();
}

###
# SPT.
#

sub _SPT_add {
    my ($g, $h, $HF, $r, $attr, $unseen, $etc) = @_;
    my $etc_r = $etc->{ $r } || 0;
    for my $s ( grep { exists $unseen->{ $_ } } $g->successors( $r ) ) {
	my $t = $g->get_edge_attribute( $r, $s, $attr );
	$t = 1 unless defined $t;
	if ($t < 0) {
	    require Carp;
	    Carp::croak("Graph::SPT_Dijkstra: edge $r-$s is negative ($t)");
	}
	if (!defined($etc->{ $s }) || ($etc_r + $t) < $etc->{ $s }) {
	    my $etc_s = $etc->{ $s } || 0;
	    $etc->{ $s } = $etc_r + $t;
	    # print "$r - $s : setting $s to $etc->{ $s } ($etc_r, $etc_s)\n";
	    $h->set_vertex_attribute( $s, $attr, $etc->{ $s });
	    $h->set_vertex_attribute( $s, 'p', $r );
	    $HF->add( Graph::SPTHeapElem->new($r, $s, $etc->{ $s }) );
	}
    }
}

sub _SPT_Dijkstra_compute {
}

sub SPT_Dijkstra {
    my $g = shift;
    my %opt = @_ == 1 ? (first_root => $_[0]) : @_;
    my $first_root = $opt{ first_root };
    unless (defined $first_root) {
	$opt{ first_root } = $first_root = $g->random_vertex();
    }
    my $spt_di = $g->get_graph_attribute('_spt_di');
    unless (defined $spt_di && exists $spt_di->{ $first_root } && $spt_di->{ $first_root }->[ 0 ] == $g->[ _G ]) {
	my %etc;
	my $sptg = $g->_heap_walk($g->new, \&_SPT_add, \%etc, %opt);
	$spt_di->{ $first_root } = [ $g->[ _G ], $sptg ];
	$g->set_graph_attribute('_spt_di', $spt_di);
    }

    my $spt = $spt_di->{ $first_root }->[ 1 ];

    $spt->set_graph_attribute('SPT_Dijkstra_root', $first_root);

    return $spt;
}

*SSSP_Dijkstra = \&SPT_Dijkstra;

*single_source_shortest_paths = \&SPT_Dijkstra;

sub SP_Dijkstra {
    my ($g, $u, $v) = @_;
    my $sptg = $g->SPT_Dijkstra(first_root => $u);
    my @path = ($v);
    my %seen;
    my $V = $g->vertices;
    my $p;
    while (defined($p = $sptg->get_vertex_attribute($v, 'p'))) {
	last if exists $seen{$p};
	push @path, $p;
	$v = $p;
	$seen{$p}++;
	last if keys %seen == $V || $u eq $v;
    }
    @path = () if @path && $path[-1] ne $u;
    return reverse @path;
}

sub __SPT_Bellman_Ford {
    my ($g, $u, $v, $attr, $d, $p, $c0, $c1) = @_;
    return unless $c0->{ $u };
    my $w = $g->get_edge_attribute($u, $v, $attr);
    $w = 1 unless defined $w;
    if (defined $d->{ $v }) {
	if (defined $d->{ $u }) {
	    if ($d->{ $v } > $d->{ $u } + $w) {
		$d->{ $v } = $d->{ $u } + $w;
		$p->{ $v } = $u;
		$c1->{ $v }++;
	    }
	} # else !defined $d->{ $u } &&  defined $d->{ $v }
    } else {
	if (defined $d->{ $u }) {
	    #  defined $d->{ $u } && !defined $d->{ $v }
	    $d->{ $v } = $d->{ $u } + $w;
	    $p->{ $v } = $u;
	    $c1->{ $v }++;
	} # else !defined $d->{ $u } && !defined $d->{ $v }
    }
}

sub _SPT_Bellman_Ford {
    my ($g, $opt, $unseenh, $unseena, $r, $next, $code, $attr) = @_;
    my %d;
    return unless defined $r;
    $d{ $r } = 0;
    my %p;
    my $V = $g->vertices;
    my %c0; # Changed during the last iteration?
    $c0{ $r }++;
    for (my $i = 0; $i < $V; $i++) {
	my %c1;
	for my $e ($g->edges) {
	    my ($u, $v) = @$e;
	    __SPT_Bellman_Ford($g, $u, $v, $attr, \%d, \%p, \%c0, \%c1);
	    if ($g->undirected) {
		__SPT_Bellman_Ford($g, $v, $u, $attr, \%d, \%p, \%c0, \%c1);
	    }
	}
	%c0 = %c1 unless $i == $V - 1;
    }

    for my $e ($g->edges) {
	my ($u, $v) = @$e;
	if (defined $d{ $u } && defined $d{ $v }) {
	    my $d = $g->get_edge_attribute($u, $v, $attr);
	    if (defined $d && $d{ $v } > $d{ $u } + $d) {
		require Carp;
		Carp::croak("Graph::SPT_Bellman_Ford: negative cycle exists");
	    }
	}
    }

    return (\%p, \%d);
}

sub _SPT_Bellman_Ford_compute {
}

sub SPT_Bellman_Ford {
    my $g = shift;

    my ($opt, $unseenh, $unseena, $r, $next, $code, $attr) = $g->_root_opt(@_);

    unless (defined $r) {
	$r = $g->random_vertex();
	return unless defined $r;
    }

    my $spt_bf = $g->get_graph_attribute('_spt_bf');
    unless (defined $spt_bf &&
	    exists $spt_bf->{ $r } && $spt_bf->{ $r }->[ 0 ] == $g->[ _G ]) {
	my ($p, $d) =
	    $g->_SPT_Bellman_Ford($opt, $unseenh, $unseena,
				  $r, $next, $code, $attr);
	my $h = $g->new;
	for my $v (keys %$p) {
	    my $u = $p->{ $v };
	    $h->add_edge( $u, $v );
	    $h->set_edge_attribute( $u, $v, $attr,
				    $g->get_edge_attribute($u, $v, $attr));
	    $h->set_vertex_attribute( $v, $attr, $d->{ $v } );
	    $h->set_vertex_attribute( $v, 'p', $u );
	}
	$spt_bf->{ $r } = [ $g->[ _G ], $h ];
	$g->set_graph_attribute('_spt_bf', $spt_bf);
    }

    my $spt = $spt_bf->{ $r }->[ 1 ];

    $spt->set_graph_attribute('SPT_Bellman_Ford_root', $r);

    return $spt;
}

*SSSP_Bellman_Ford = \&SPT_Bellman_Ford;

sub SP_Bellman_Ford {
    my ($g, $u, $v) = @_;
    my $sptg = $g->SPT_Bellman_Ford(first_root => $u);
    my @path = ($v);
    my %seen;
    my $V = $g->vertices;
    my $p;
    while (defined($p = $sptg->get_vertex_attribute($v, 'p'))) {
	last if exists $seen{$p};
	push @path, $p;
	$v = $p;
	$seen{$p}++;
	last if keys %seen == $V;
    }
    # @path = () if @path && "$path[-1]" ne "$u";
    return reverse @path;
}

###
# Transitive Closure.
#

sub TransitiveClosure_Floyd_Warshall {
    my $self = shift;
    my $class = ref $self || $self;
    $self = shift unless ref $self;
    bless Graph::TransitiveClosure->new($self, @_), $class;
}

*transitive_closure = \&TransitiveClosure_Floyd_Warshall;

sub APSP_Floyd_Warshall {
    my $self = shift;
    my $class = ref $self || $self;
    $self = shift unless ref $self;
    bless Graph::TransitiveClosure->new($self, path => 1, @_), $class;
}

*all_pairs_shortest_paths = \&APSP_Floyd_Warshall;

sub _transitive_closure_matrix_compute {
}

sub transitive_closure_matrix {
    my $g = shift;
    my $tcm = $g->get_graph_attribute('_tcm');
    if (defined $tcm) {
	if (ref $tcm eq 'ARRAY') { # YECHHH!
	    if ($tcm->[ 0 ] == $g->[ _G ]) {
		$tcm = $tcm->[ 1 ];
	    } else {
		undef $tcm;
	    }
	}
    }
    unless (defined $tcm) {
	my $apsp = $g->APSP_Floyd_Warshall(@_);
	$tcm = $apsp->get_graph_attribute('_tcm');
	$g->set_graph_attribute('_tcm', [ $g->[ _G ], $tcm ]);
    }

    return $tcm;
}

sub path_length {
    my $g = shift;
    my $tcm = $g->transitive_closure_matrix;
    $tcm->path_length(@_);
}

sub path_predecessor {
    my $g = shift;
    my $tcm = $g->transitive_closure_matrix;
    $tcm->path_predecessor(@_);
}

sub path_vertices {
    my $g = shift;
    my $tcm = $g->transitive_closure_matrix;
    $tcm->path_vertices(@_);
}

sub is_reachable {
    my $g = shift;
    my $tcm = $g->transitive_closure_matrix;
    $tcm->is_reachable(@_);
}

sub for_shortest_paths {
    my $g = shift;
    my $c = shift;
    my $t = $g->transitive_closure_matrix;
    my @v = $g->vertices;
    my $n = 0;
    for my $u (@v) {
	for my $v (@v) {
	    next unless $t->is_reachable($u, $v);
	    $n++;
	    $c->($t, $u, $v, $n);
	}
    }
    return $n;
}

sub _minmax_path {
    my $g = shift;
    my $min;
    my $max;
    my $minp;
    my $maxp;
    $g->for_shortest_paths(sub {
			       my ($t, $u, $v, $n) = @_;
			       my $l = $t->path_length($u, $v);
			       return unless defined $l;
			       my $p;
			       if ($u ne $v && (!defined $max || $l > $max)) {
				   $max = $l;
				   $maxp = $p = [ $t->path_vertices($u, $v) ];
			       }
			       if ($u ne $v && (!defined $min || $l < $min)) {
				   $min = $l;
				   $minp = $p || [ $t->path_vertices($u, $v) ];
			       }
			   });
    return ($min, $max, $minp, $maxp);
}

sub diameter {
    my $g = shift;
    my ($min, $max, $minp, $maxp) = $g->_minmax_path(@_);
    return defined $maxp ? (wantarray ? @$maxp : $max) : undef;
}

*graph_diameter = \&diameter;

sub longest_path {
    my ($g, $u, $v) = @_;
    my $t = $g->transitive_closure_matrix;
    if (defined $u) {
	if (defined $v) {
	    return wantarray ?
		$t->path_vertices($u, $v) : $t->path_length($u, $v);
	} else {
	    my $max;
	    my @max;
	    for my $v ($g->vertices) {
		next if $u eq $v;
		my $l = $t->path_length($u, $v);
		if (defined $l && (!defined $max || $l > $max)) {
		    $max = $l;
		    @max = $t->path_vertices($u, $v);
		}
	    }
	    return wantarray ? @max : $max;
	}
    } else {
	if (defined $v) {
	    my $max;
	    my @max;
	    for my $u ($g->vertices) {
		next if $u eq $v;
		my $l = $t->path_length($u, $v);
		if (defined $l && (!defined $max || $l > $max)) {
		    $max = $l;
		    @max = $t->path_vertices($u, $v);
		}
	    }
	    return wantarray ? @max : @max - 1;
	} else {
	    my ($min, $max, $minp, $maxp) = $g->_minmax_path(@_);
	    return defined $maxp ? (wantarray ? @$maxp : $max) : undef;
	}
    }
}

sub vertex_eccentricity {
    my ($g, $u) = @_;
    $g->expect_undirected;
    if ($g->is_connected) {
	my $max;
	for my $v ($g->vertices) {
	    next if $u eq $v;
	    my $l = $g->path_length($u, $v);
	    if (defined $l && (!defined $max || $l > $max)) {
		$max = $l;
	    }
	}
	return $max;
    } else {
	return Infinity();
    }
}

sub shortest_path {
    my ($g, $u, $v) = @_;
    $g->expect_undirected;
    my $t = $g->transitive_closure_matrix;
    if (defined $u) {
	if (defined $v) {
	    return wantarray ?
		$t->path_vertices($u, $v) : $t->path_length($u, $v);
	} else {
	    my $min;
	    my @min;
	    for my $v ($g->vertices) {
		next if $u eq $v;
		my $l = $t->path_length($u, $v);
		if (defined $l && (!defined $min || $l < $min)) {
		    $min = $l;
		    @min = $t->path_vertices($u, $v);
		}
	    }
	    return wantarray ? @min : $min;
	}
    } else {
	if (defined $v) {
	    my $min;
	    my @min;
	    for my $u ($g->vertices) {
		next if $u eq $v;
		my $l = $t->path_length($u, $v);
		if (defined $l && (!defined $min || $l < $min)) {
		    $min = $l;
		    @min = $t->path_vertices($u, $v);
		}
	    }
	    return wantarray ? @min : $min;
	} else {
	    my ($min, $max, $minp, $maxp) = $g->_minmax_path(@_);
	    return defined $minp ? (wantarray ? @$minp : $min) : undef;
	}
    }
}

sub radius {
    my $g = shift;
    $g->expect_undirected;
    my ($center, $radius) = (undef, Infinity());
    for my $v ($g->vertices) {
	my $x = $g->vertex_eccentricity($v);
	($center, $radius) = ($v, $x) if defined $x && $x < $radius;
    }
    return $radius;
}

sub center_vertices {
    my ($g, $delta) = @_;
    $g->expect_undirected;
    $delta = 0 unless defined $delta;
    $delta = abs($delta);
    my @c;
    my $r = $g->radius;
    if (defined $r) {
	for my $v ($g->vertices) {
	    my $e = $g->vertex_eccentricity($v);
	    next unless defined $e;
	    push @c, $v if abs($e - $r) <= $delta;
	}
    }
    return @c;
}

*centre_vertices = \&center_vertices;

sub average_path_length {
    my $g = shift;
    my @A = @_;
    my $d = 0;
    my $m = 0;
    my $n = $g->for_shortest_paths(sub {
				       my ($t, $u, $v, $n) = @_;
				       my $l = $t->path_length($u, $v);
				       if ($l) {
					   my $c = @A == 0 ||
					       (@A == 1 && $u eq $A[0]) ||
						   ((@A == 2) &&
						    (defined $A[0] &&
						     $u eq $A[0]) ||
						    (defined $A[1] &&
						     $v eq $A[1]));
					   if ($c) {
					       $d += $l;
					       $m++;
					   }
				       }
				   });
    return $m ? $d / $m : undef;
}

###
# Simple tests.
#

sub is_multi_graph {
    my $g = shift;
    return 0 unless $g->is_multiedged || $g->is_countedged;
    my $multiedges = 0;
    for my $e ($g->edges05) {
	my ($u, @v) = @$e;
	for my $v (@v) {
	    return 0 if $u eq $v;
	}
	$multiedges++ if $g->get_edge_count(@$e) > 1;
    }
    return $multiedges;
}

sub is_simple_graph {
    my $g = shift;
    return 1 unless $g->is_countedged || $g->is_multiedged;
    for my $e ($g->edges05) {
	return 0 if $g->get_edge_count(@$e) > 1;
    }
    return 1;
}

sub is_pseudo_graph {
    my $g = shift;
    my $m = $g->is_countedged || $g->is_multiedged;
    for my $e ($g->edges05) {
	my ($u, @v) = @$e;
	for my $v (@v) {
	    return 1 if $u eq $v;
	}
	return 1 if $m && $g->get_edge_count($u, @v) > 1;
    }
    return 0;
}

###
# Rough isomorphism guess.
#

my %_factorial = (0 => 1, 1 => 1);

sub __factorial {
    my $n = shift;
    for (my $i = 2; $i <= $n; $i++) {
	next if exists $_factorial{$i};
	$_factorial{$i} = $i * $_factorial{$i - 1};
    }
    $_factorial{$n};
}

sub _factorial {
    my $n = int(shift);
    if ($n < 0) {
	require Carp;
	Carp::croak("factorial of a negative number");
    }
    __factorial($n) unless exists $_factorial{$n};
    return $_factorial{$n};
}

sub could_be_isomorphic {
    my ($g0, $g1) = @_;
    return 0 unless $g0->vertices == $g1->vertices;
    return 0 unless $g0->edges05  == $g1->edges05;
    my %d0;
    for my $v0 ($g0->vertices) {
	$d0{ $g0->in_degree($v0) }{ $g0->out_degree($v0) }++
    }
    my %d1;
    for my $v1 ($g1->vertices) {
	$d1{ $g1->in_degree($v1) }{ $g1->out_degree($v1) }++
    }
    return 0 unless keys %d0 == keys %d1;
    for my $da (keys %d0) {
	return 0
	    unless exists $d1{$da} &&
		   keys %{ $d0{$da} } == keys %{ $d1{$da} };
	for my $db (keys %{ $d0{$da} }) {
	    return 0
		unless exists $d1{$da}{$db} && 
		       $d0{$da}{$db} == $d1{$da}{$db};
	}
    }
    for my $da (keys %d0) {
	for my $db (keys %{ $d0{$da} }) {
	    return 0 unless $d1{$da}{$db} == $d0{$da}{$db};
	}
	delete $d1{$da};
    }
    return 0 unless keys %d1 == 0;
    my $f = 1;
    for my $da (keys %d0) {
	for my $db (keys %{ $d0{$da} }) {
	    $f *= _factorial(abs($d0{$da}{$db}));
	}
    }
    return $f;
}

###
# Debugging.
#

sub _dump {
    require Data::Dumper;
    my $d = Data::Dumper->new([$_[0]],[ref $_[0]]);
    defined wantarray ? $d->Dump : print $d->Dump;
}

1;
