package Heap071::Fibonacci;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);

# No names exported.
# No names available for export.
@EXPORT = ( );

$VERSION = '0.71';


# Preloaded methods go here.

# common names
#	h	- heap head
#	el	- linkable element, contains user-provided value
#	v	- user-provided value

################################################# debugging control

my $debug = 0;
my $validate = 0;

# enable/disable debugging output
sub debug {
    @_ ? ($debug = shift) : $debug;
}

# enable/disable validation checks on values
sub validate {
    @_ ? ($validate = shift) : $validate;
}

my $width = 3;
my $bar = ' | ';
my $corner = ' +-';
my $vfmt = "%3d";

sub set_width {
    $width = shift;
    $width = 2 if $width < 2;

    $vfmt = "%${width}d";
    $bar = $corner = ' ' x $width;
    substr($bar,-2,1) = '|';
    substr($corner,-2,2) = '+-';
}

sub hdump;

sub hdump {
    my $el = shift;
    my $l1 = shift;
    my $b = shift;

    my $ch;
    my $ch1;

    unless( $el ) {
	print $l1, "\n";
	return;
    }

    hdump $ch1 = $el->{child},
	$l1 . sprintf( $vfmt, $el->{val}->val),
	$b . $bar;

    if( $ch1 ) {
	for( $ch = $ch1->{right}; $ch != $ch1; $ch = $ch->{right} ) {
	    hdump $ch, $b . $corner, $b . $bar;
	}
    }
}

sub heapdump {
    my $h;

    while( $h = shift ) {
	my $top = $$h or last;
	my $el = $top;

	do {
	    hdump $el, sprintf( "%02d: ", $el->{degree}), '    ';
	    $el = $el->{right};
	} until $el == $top;
	print "\n";
    }
}

sub bhcheck;

sub bhcheck {
    my $el = shift;
    my $p = shift;

    my $cur = $el;
    my $prev;
    my $ch;
    do {
	$prev = $cur;
	$cur = $cur->{right};
	die "bad back link" unless $cur->{left} == $prev;
	die "bad parent link"
	    unless (defined $p && defined $cur->{p} && $cur->{p} == $p)
		|| (!defined $p && !defined $cur->{p});
	die "bad degree( $cur->{degree} > $p->{degree} )"
	    if $p && $p->{degree} <= $cur->{degree};
	die "not heap ordered"
	    if $p && $p->{val}->cmp($cur->{val}) > 0;
	$ch = $cur->{child} and bhcheck $ch, $cur;
    } until $cur == $el;
}


sub heapcheck {
    my $h;
    my $el;
    while( $h = shift ) {
	heapdump $h if $validate >= 2;
	$el = $$h and bhcheck $el, undef;
    }
}


################################################# forward declarations

sub ascending_cut;
sub elem;
sub elem_DESTROY;
sub link_to_left_of;

################################################# heap methods

# Cormen et al. use two values for the heap, a pointer to an element in the
# list at the top, and a count of the number of elements.  The count is only
# used to determine the size of array required to hold log(count) pointers,
# but perl can set array sizes as needed and doesn't need to know their size
# when they are created, so we're not maintaining that field.
sub new {
    my $self = shift;
    my $class = ref($self) || $self;
    my $h = undef;
    bless \$h, $class;
}

sub DESTROY {
    my $h = shift;

    elem_DESTROY $$h;
}

sub add {
    my $h = shift;
    my $v = shift;
    $validate && do {
	die "Method 'heap' required for element on heap"
	    unless $v->can('heap');
	die "Method 'cmp' required for element on heap"
	    unless $v->can('cmp');
    };
    my $el = elem $v;
    my $top;
    if( !($top = $$h) ) {
	$$h = $el;
    } else {
	link_to_left_of $top->{left}, $el ;
	link_to_left_of $el,$top;
	$$h = $el if $v->cmp($top->{val}) < 0;
    }
}

sub top {
    my $h = shift;
    $$h && $$h->{val};
}

*minimum = \&top;

sub extract_top {
    my $h = shift;
    my $el = $$h or return undef;
    my $ltop = $el->{left};
    my $cur;
    my $next;

    # $el is the heap with the lowest value on it
    # move all of $el's children (if any) to the top list (between
    # $ltop and $el)
    if( $cur = $el->{child} ) {
	# remember the beginning of the list of children
	my $first = $cur;
	do {
	    # the children are moving to the top, clear the p
	    # pointer for all of them
	    $cur->{p} = undef;
	} until ($cur = $cur->{right}) == $first;

	# remember the end of the list
	$cur = $cur->{left};
	link_to_left_of $ltop, $first;
	link_to_left_of $cur, $el;
    }

    if( $el->{right} == $el ) {
	# $el had no siblings or children, the top only contains $el
	# and $el is being removed
	$$h = undef;
    } else {
	link_to_left_of $el->{left}, $$h = $el->{right};
	# now all those loose ends have to be merged together as we
	# search for the
	# new smallest element
	$h->consolidate;
    }

    # extract the actual value and return that, $el is no longer used
    # but break all of its links so that it won't be pointed to...
    my $top = $el->{val};
    $top->heap(undef);
    $el->{left} = $el->{right} = $el->{p} = $el->{child} = $el->{val} =
	undef;
    $top;
}

*extract_minimum = \&extract_top;

sub absorb {
    my $h = shift;
    my $h2 = shift;

    my $el = $$h;
    unless( $el ) {
	$$h = $$h2;
	$$h2 = undef;
	return $h;
    }

    my $el2 = $$h2 or return $h;

    # add $el2 and its siblings to the head list for $h
    # at start, $ell -> $el -> ... -> $ell is on $h (where $ell is
    #				$el->{left})
    #           $el2l -> $el2 -> ... -> $el2l are on $h2
    # at end, $ell -> $el2l -> ... -> $el2 -> $el -> ... -> $ell are
    #				all on $h
    my $el2l = $el2->{left};
    link_to_left_of $el->{left}, $el2;
    link_to_left_of $el2l, $el;

    # change the top link if needed
    $$h = $el2 if $el->{val}->cmp( $el2->{val} ) > 0;

    # clean out $h2
    $$h2 = undef;

    # return the heap
    $h;
}

# a key has been decreased, it may have to percolate up in its heap
sub decrease_key {
    my $h = shift;
    my $top = $$h;
    my $v = shift;
    my $el = $v->heap or return undef;
    my $p;

    # first, link $h to $el if it is now the smallest (we will
    # soon link $el to $top to properly put it up to the top list,
    # if it isn't already there)
    $$h = $el if $top->{val}->cmp( $v ) > 0;

    if( $p = $el->{p} and $v->cmp($p->{val}) < 0 ) {
	# remove $el from its parent's list - it is now smaller

	ascending_cut $top, $p, $el;
    }

    $v;
}


# to delete an item, we bubble it to the top of its heap (as if its key
# had been decreased to -infinity), and then remove it (as in extract_top)
sub delete {
    my $h = shift;
    my $v = shift;
    my $el = $v->heap or return undef;

    # if there is a parent, cut $el to the top (as if it had just had its
    # key decreased to a smaller value than $p's value
    my $p;
    $p = $el->{p} and ascending_cut $$h, $p, $el;

    # $el is in the top list now, make it look like the smallest and
    # remove it
    $$h = $el;
    $h->extract_top;
}


################################################# internal utility functions

sub elem {
    my $v = shift;
    my $el = undef;
    $el = {
	p	=>	undef,
	degree	=>	0,
	mark	=>	0,
	child	=>	undef,
	val	=>	$v,
	left	=>	undef,
	right	=>	undef,
    };
    $el->{left} = $el->{right} = $el;
    $v->heap($el);
    $el;
}

sub elem_DESTROY {
    my $el = shift;
    my $ch;
    my $next;
    $el->{left}->{right} = undef;

    while( $el ) {
	$ch = $el->{child} and elem_DESTROY $ch;
	$next = $el->{right};

	defined $el->{val} and $el->{val}->heap(undef);
	$el->{child} = $el->{right} = $el->{left} = $el->{p} = $el->{val}
	    = undef;
	$el = $next;
    }
}

sub link_to_left_of {
    my $l = shift;
    my $r = shift;

    $l->{right} = $r;
    $r->{left} = $l;
}

sub link_as_parent_of {
    my $p = shift;
    my $c = shift;

    my $pc;

    if( $pc = $p->{child} ) {
	link_to_left_of $pc->{left}, $c;
	link_to_left_of $c, $pc;
    } else {
	link_to_left_of $c, $c;
    }
    $p->{child} = $c;
    $c->{p} = $p;
    $p->{degree}++;
    $c->{mark} = 0;
    $p;
}

sub consolidate {
    my $h = shift;

    my $cur;
    my $this;
    my $next = $$h;
    my $last = $next->{left};
    my @a;
    do {
	# examine next item on top list
	$this = $cur = $next;
	$next = $cur->{right};
	my $d = $cur->{degree};
	my $alt;
	while( $alt = $a[$d] ) {
	    # we already saw another item of the same degree,
	    # put the larger valued one under the smaller valued
	    # one - switch $cur and $alt if necessary so that $cur
	    # is the smaller
	    ($cur,$alt) = ($alt,$cur)
		if $cur->{val}->cmp( $alt->{val} ) > 0;
	    # remove $alt from the top list
	    link_to_left_of $alt->{left}, $alt->{right};
	    # and put it under $cur
	    link_as_parent_of $cur, $alt;
	    # make sure that $h still points to a node at the top
	    $$h = $cur;
	    # we've removed the old $d degree entry
	    $a[$d] = undef;
	    # and we now have a $d+1 degree entry to try to insert
	    # into @a
	    ++$d;
	}
	# found a previously unused degree
	$a[$d] = $cur;
    } until $this == $last;
    $cur = $$h;
    for $cur (grep defined, @a) {
	$$h = $cur if $$h->{val}->cmp( $cur->{val} ) > 0;
    }
}

sub ascending_cut {
    my $top = shift;
    my $p = shift;
    my $el = shift;

    while( 1 ) {
	if( --$p->{degree} ) {
	    # there are still other children below $p
	    my $l = $el->{left};
	    $p->{child} = $l;
	    link_to_left_of $l, $el->{right};
	} else {
	    # $el was the only child of $p
	    $p->{child} = undef;
	}
	link_to_left_of $top->{left}, $el;
	link_to_left_of $el, $top;
	$el->{p} = undef;
	$el->{mark} = 0;

	# propagate up the list
	$el = $p;

	# quit at the top
	last unless $p = $el->{p};

	# quit if we can mark $el
	$el->{mark} = 1, last unless $el->{mark};
    }
}


1;

__END__

=head1 NAME

Heap::Fibonacci - a Perl extension for keeping data partially sorted

=head1 SYNOPSIS

  use Heap::Fibonacci;

  $heap = Heap::Fibonacci->new;
  # see Heap(3) for usage

=head1 DESCRIPTION

Keeps elements in heap order using a linked list of Fibonacci trees.
The I<heap> method of an element is used to store a reference to
the node in the list that refers to the element.

See L<Heap> for details on using this module.

=head1 AUTHOR

John Macdonald, jmm@perlwolf.com

=head1 COPYRIGHT

Copyright 1998-2003, O'Reilly & Associates.

This code is distributed under the same copyright terms as perl itself.

=head1 SEE ALSO

Heap(3), Heap::Elem(3).

=cut
