#!/usr/bin/perl
## --------------------------------------------------------------------------
##
##   Copyright 1996-2013 The NASM Authors - All Rights Reserved
##   See the file AUTHORS included with the NASM distribution for
##   the specific copyright holders.
##
##   Redistribution and use in source and binary forms, with or without
##   modification, are permitted provided that the following
##   conditions are met:
##
##   * Redistributions of source code must retain the above copyright
##     notice, this list of conditions and the following disclaimer.
##   * Redistributions in binary form must reproduce the above
##     copyright notice, this list of conditions and the following
##     disclaimer in the documentation and/or other materials provided
##     with the distribution.
##
##     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
##     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
##     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
##     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
##     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
##     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
##     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
##     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
##     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
##     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
##     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
##     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
##     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
## --------------------------------------------------------------------------

#
# Here we generate instrcution template flags. Note we assume that at moment
# less than 128 bits are used for all flags. If needed it can be extended
# arbitrary, but it'll be needed to extend arrays (they are 4 32 bit elements
# by now).

#
# The order does matter here. We use some predefined masks to quick test
# for a set of flags, so be carefull moving bits (and
# don't forget to update C code generation then).
my %insns_flag_bit = (
    #
    # dword bound, index 0 - specific flags
    #
    "SM"                => [  0, "Size match"],
    "SM2"               => [  1, "Size match first two operands"],
    "SB"                => [  2, "Unsized operands can't be non-byte"],
    "SW"                => [  3, "Unsized operands can't be non-word"],
    "SD"                => [  4, "Unsized operands can't be non-dword"],
    "SQ"                => [  5, "Unsized operands can't be non-qword"],
    "SO"                => [  6, "Unsized operands can't be non-oword"],
    "SY"                => [  7, "Unsized operands can't be non-yword"],
    "SZ"                => [  8, "Unsized operands can't be non-zword"],
    "SIZE"              => [  9, "Unsized operands must match the bitsize"],
    "SX"                => [ 10, "Unsized operands not allowed"],
    "AR0"               => [ 11, "SB, SW, SD applies to argument 0"],
    "AR1"               => [ 12, "SB, SW, SD applies to argument 1"],
    "AR2"               => [ 13, "SB, SW, SD applies to argument 2"],
    "AR3"               => [ 14, "SB, SW, SD applies to argument 3"],
    "AR4"               => [ 15, "SB, SW, SD applies to argument 4"],
    "OPT"               => [ 16, "Optimizing assembly only"],

    #
    # dword bound, index 1 - instruction filtering flags
    #
    "PRIV"              => [ 32, "Privileged instruction"],
    "SMM"               => [ 33, "Only valid in SMM"],
    "PROT"              => [ 34, "Protected mode only"],
    "LOCK"              => [ 35, "Lockable if operand 0 is memory"],
    "NOLONG"            => [ 36, "Not available in long mode"],
    "LONG"              => [ 37, "Long mode"],
    "NOHLE"             => [ 38, "HLE prefixes forbidden"],
    "MIB"               => [ 39, "disassemble with split EA"],
    "BND"               => [ 40, "BND (0xF2) prefix available"],
    "UNDOC"             => [ 41, "Undocumented"],
    "HLE"               => [ 42, "HLE prefixed"],
    "FPU"               => [ 43, "FPU"],
    "MMX"               => [ 44, "MMX"],
    "3DNOW"             => [ 45, "3DNow!"],
    "SSE"               => [ 46, "SSE (KNI, MMX2)"],
    "SSE2"              => [ 47, "SSE2"],
    "SSE3"              => [ 48, "SSE3 (PNI)"],
    "VMX"               => [ 49, "VMX"],
    "SSSE3"             => [ 50, "SSSE3"],
    "SSE4A"             => [ 51, "AMD SSE4a"],
    "SSE41"             => [ 52, "SSE4.1"],
    "SSE42"             => [ 53, "SSE4.2"],
    "SSE5"              => [ 54, "SSE5"],
    "AVX"               => [ 55, "AVX (128b)"],
    "AVX2"              => [ 56, "AVX2 (256b)"],
    "FMA"               => [ 57, ""],
    "BMI1"              => [ 58, ""],
    "BMI2"              => [ 59, ""],
    "TBM"               => [ 60, ""],
    "RTM"               => [ 61, ""],
    "INVPCID"           => [ 62, ""],

    #
    # dword bound, index 2 - instruction filtering flags
    #
    "AVX512"            => [ 64, "AVX-512F (512b)"],
    "AVX512CD"          => [ 65, "AVX-512 Conflict Detection"],
    "AVX512ER"          => [ 66, "AVX-512 Exponential and Reciprocal"],
    "AVX512PF"          => [ 67, "AVX-512 Prefetch"],
    "MPX"               => [ 68	,"MPX"],
    "SHA"               => [ 69	,"SHA"],
    "PREFETCHWT1"       => [ 70	,"PREFETCHWT1"],

    #
    # dword bound, index 3 - cpu type flags
    #
    "8086"              => [ 96, "8086"],
    "186"               => [ 97, "186+"],
    "286"               => [ 98, "286+"],
    "386"               => [ 99, "386+"],
    "486"               => [100, "486+"],
    "PENT"              => [101, "Pentium"],
    "P6"                => [102, "P6"],
    "KATMAI"            => [103, "Katmai"],
    "WILLAMETTE"        => [104, "Willamette"],
    "PRESCOTT"          => [105, "Prescott"],
    "X86_64"            => [106, "x86-64 (long or legacy mode)"],
    "NEHALEM"           => [107, "Nehalem"],
    "WESTMERE"          => [108, "Westmere"],
    "SANDYBRIDGE"       => [109, "Sandy Bridge"],
    "FUTURE"            => [110, "Future processor (not yet disclosed)"],
    "IA64"              => [111, "IA64 (in x86 mode)"],
    "CYRIX"             => [112, "Cyrix-specific"],
    "AMD"               => [113, "AMD-specific"],
);

my %insns_flag_hash = ();
my @insns_flag_values = ();

sub insns_flag_index(@) {
    return undef if $_[0] eq "ignore";

    my @prekey = sort(@_);
    my $key = join("", @prekey);

    if (not defined($insns_flag_hash{$key})) {
        my @newkey = ([], [], [], []);
        my $str = "";

        for my $i (@prekey) {
            die "No key for $i\n" if not defined($insns_flag_bit{$i});
            if ($insns_flag_bit{$i}[0] <       32) {
                push @newkey[0], $insns_flag_bit{$i}[0] -  0;
            } elsif ($insns_flag_bit{$i}[0] <  64) {
                push @newkey[1], $insns_flag_bit{$i}[0] - 32;
            } elsif ($insns_flag_bit{$i}[0] <  96) {
                push @newkey[2], $insns_flag_bit{$i}[0] - 64;
            } elsif ($insns_flag_bit{$i}[0] < 128) {
                push @newkey[3], $insns_flag_bit{$i}[0] - 96;
            } else {
                die "Key value is too big ", $insns_flag_bit{$i}[0], "\n";
            }
        }

        for my $j (0 .. $#newkey) {
            my $v = "";
            if (scalar(@{$newkey[$j]})) {
                $v = join(" | ", map { map { sprintf("(UINT32_C(1) << %d)", $_) } @$_; } $newkey[$j]);
            } else {
                $v = "0";
            }
            $str .= sprintf(".field[%d] = %s, ", $j, $v);
        }

        push @insns_flag_values, $str;
        $insns_flag_hash{$key} = $#insns_flag_values;
    }

    return $insns_flag_hash{$key};
}

sub write_iflaggen_h() {
    print STDERR "Writing iflaggen.h ...\n";

    open(N, ">iflaggen.h") or die "$0: $!\n";

    print N "/* This file is auto-generated. Don't edit. */\n";
    print N "#ifndef NASM_IFLAGGEN_H\n";
    print N "#define NASM_IFLAGGEN_H 1\n\n";

    foreach my $key (sort { $insns_flag_bit{$a}[0] <=> $insns_flag_bit{$b}[0] } keys(%insns_flag_bit)) {
        print N sprintf("#define IF_%-16s %3d /* %-64s */\n",
            $key, $insns_flag_bit{$key}[0], $insns_flag_bit{$key}[1]);
    }

    print N "\n";
    print N sprintf("extern iflag_t insns_flags[%d];\n\n",
		    $#insns_flag_values + 1);

    print N "#endif /* NASM_IFLAGGEN_H */\n";
    close N;
}

sub write_iflag_c() {
    print STDERR "Writing iflag.c ...\n";

    open N, ">iflag.c";

    print N "/* This file is auto-generated. Don't edit. */\n";
    print N "#include \"iflag.h\"\n\n";
    print N "/* Global flags referenced from instruction templates */\n";
    print N sprintf("iflag_t insns_flags[%d] = {\n", $#insns_flag_values + 1);
    foreach my $i (0 .. $#insns_flag_values) {
        print N sprintf("    [%8d] = { %s },\n", $i, $insns_flag_values[$i]);
    }
    print N "};\n\n";
    close N;
}

1;
