package Graph::Attribute;

use strict;

sub _F () { 0 }
sub _COMPAT02 () { 0x00000001 }

sub import {
    my $package = shift;
    my %attr = @_;
    my $caller = caller(0);
    if (exists $attr{array}) {
	my $i = $attr{array};
	no strict 'refs';
	*{"${caller}::_get_attributes"} = sub { $_[0]->[ $i ] };
	*{"${caller}::_set_attributes"} =
	    sub { $_[0]->[ $i ] ||= { };
		  $_[0]->[ $i ] = $_[1] if @_ == 2;
		  $_[0]->[ $i ] };
	*{"${caller}::_has_attributes"} = sub { defined $_[0]->[ $i ] };
	*{"${caller}::_delete_attributes"} = sub { undef $_[0]->[ $i ]; 1 };
    } elsif (exists $attr{hash}) {
	my $k = $attr{hash};
	no strict 'refs';
	*{"${caller}::_get_attributes"} = sub { $_[0]->{ $k } };
	*{"${caller}::_set_attributes"} =
	    sub { $_[0]->{ $k } ||= { };
		  $_[0]->{ $k } = $_[1] if @_ == 2;
		  $_[0]->{ $k } };
	*{"${caller}::_has_attributes"} = sub { defined $_[0]->{ $k } };
	*{"${caller}::_delete_attributes"} = sub { delete $_[0]->{ $k } };
    } else {
	die "Graph::Attribute::import($package @_) caller $caller\n";
    }
    my @api = qw(get_attribute
		 get_attributes
		 set_attribute
		 set_attributes
		 has_attribute
		 has_attributes
		 delete_attribute
		 delete_attributes
		 get_attribute_names
		 get_attribute_values);
    if (exists $attr{map}) {
	my $map = $attr{map};
	for my $api (@api) {
	    my ($first, $rest) = ($api =~ /^(\w+?)_(.+)/);
	    no strict 'refs';
	    *{"${caller}::${first}_${map}_${rest}"} = \&$api;
	}
    }
}

sub set_attribute {
    my $g = shift;
    my $v = pop;
    my $a = pop;
    my $p = $g->_set_attributes;
    $p->{ $a } = $v;
    return 1;
}

sub set_attributes {
    my $g = shift;
    my $a = pop;
    my $p = $g->_set_attributes( $a );
    return 1;
}

sub has_attribute {
    my $g = shift;
    my $a = pop;
    my $p = $g->_get_attributes;
    $p ? exists $p->{ $a } : 0;
}

sub has_attributes {
    my $g = shift;
    $g->_get_attributes ? 1 : 0;
}

sub get_attribute {
    my $g = shift;
    my $a = pop;
    my $p = $g->_get_attributes;
    $p ? $p->{ $a } : undef;
}

sub delete_attribute {
    my $g = shift;
    my $a = pop;
    my $p = $g->_get_attributes;
    if (defined $p) {
	delete $p->{ $a };
	return 1;
    } else {
	return 0;
    }
}

sub delete_attributes {
    my $g = shift;
    if ($g->_has_attributes) {
	$g->_delete_attributes;
	return 1;
    } else {
	return 0;
    }
}

sub get_attribute_names {
    my $g = shift;
    my $p = $g->_get_attributes;
    defined $p ? keys %{ $p } : ( );
}

sub get_attribute_values {
    my $g = shift;
    my $p = $g->_get_attributes;
    defined $p ? values %{ $p } : ( );
}

sub get_attributes {
    my $g = shift;
    my $a = $g->_get_attributes;
    ($g->[ _F ] & _COMPAT02) ? (defined $a ? %{ $a } : ()) : $a;
}

1;
