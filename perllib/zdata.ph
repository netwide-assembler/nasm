# -*- perl -*-
# SPDX-License-Identifier: BSD-2-Clause
# Copyright 1996-2026 The NASM Authors - All Rights Reserved

use strict;
use integer;
use bytes;
use Compress::Zlib;

#
# Print out a string as a byte array
#
sub print_data($$) {
    my($o, $s) = @_;
    my $perline = 8;

    for (my $ix = 0; $ix < length($s); $ix += $perline) {
	my $ss = substr($s, $ix, $perline);
	print $o '    ';
	foreach my $b (unpack('C*', $ss)) {
	    printf $o '0x%02x,', $b;
	}
	print $o "\n";
    }
    print $o "};\n";
}

#
# Generate a struct zdata constant string in C syntax.  The first
# argument is a (constant) C expression for a pointer to the byte data
# ($zdata->{zdata}); the rest is the hash reference returned by
# make_zdata().
#
sub zdata_def($$) {
    my($var, $zdata) = @_;
    return sprintf("{ %d, %d, %s }", $zdata->{dsize}, $zdata->{zsize}, $var);
}

#
# Compress data as expected by nasmlib/zdata.c; returns
# a hash reference with *at least* the following members:
# zdata : compressed data (byte string)
# zsize : compressed data size (== length(zdata))
# dsize : uncompressed data size (== length(input))
#
# In the future there may be additional fields to be used by zdata_def().
#
sub make_zdata($) {
    my($data) = @_;
    my $dsize = length($data);
    my $zblob = Compress::Zlib::compress($data, 9);
    my $zsize = length($zblob);

    if ($zsize >= $dsize) {
	# Incompressible data
	return { 'zdata' => $data, 'dsize' => $dsize, 'zsize' => $dsize };
    } else {
	return { 'zdata' => $zblob, 'dsize' => $dsize, 'zsize' => $zsize };
    }
}

1;
