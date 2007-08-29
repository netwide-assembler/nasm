package Graph::SPTHeapElem;

use strict;
use vars qw($VERSION @ISA);
use Heap071::Elem;

use base 'Heap071::Elem';

$VERSION = 0.01;

sub new {
    my $class = shift;
    bless { u => $_[0], v => $_[1], w => $_[2] }, $class;
}

sub cmp {
    ($_[0]->{ w } || 0) <=> ($_[1]->{ w } || 0) ||
    ($_[0]->{ u } cmp $_[1]->{ u }) ||
    ($_[0]->{ u } cmp $_[1]->{ v });
}

sub val {
    @{ $_[0] }{ qw(u v w) };
}

1;
