#!/usr/bin/perl
## --------------------------------------------------------------------------
##
##   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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
# Instruction template flags. These specify which processor
# targets the instruction is eligible for, whether it is
# privileged or undocumented, and also specify extra error
# checking on the matching of the instruction.
#
# IF_SM stands for Size Match: any operand whose size is not
# explicitly specified by the template is `really' intended to be
# the same size as the first size-specified operand.
# Non-specification is tolerated in the input instruction, but
# _wrong_ specification is not.
#
# IF_SM2 invokes Size Match on only the first _two_ operands, for
# three-operand instructions such as SHLD: it implies that the
# first two operands must match in size, but that the third is
# required to be _unspecified_.
#
# IF_SB invokes Size Byte: operands with unspecified size in the
# template are really bytes, and so no non-byte specification in
# the input instruction will be tolerated. IF_SW similarly invokes
# Size Word, and IF_SD invokes Size Doubleword.
#
# (The default state if neither IF_SM nor IF_SM2 is specified is
# that any operand with unspecified size in the template is
# required to have unspecified size in the instruction too...)
#
# iflag_t is defined to store these flags.
#
# The order does matter here. We use some predefined masks to quick test
# for a set of flags, so be careful moving bits (and
# don't forget to update C code generation then).
#
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
    "AVX512VL"          => [ 71, "AVX-512 Vector Length Orthogonality"],
    "AVX512DQ"          => [ 72, "AVX-512 Dword and Qword"],
    "AVX512BW"          => [ 73, "AVX-512 Byte and Word"],
    "AVX512IFMA"        => [ 74, "AVX-512 IFMA instructions"],
    "AVX512VBMI"        => [ 75, "AVX-512 VBMI instructions"],
    "OBSOLETE"          => [ 93, "Instruction removed from architecture"],
    "VEX"               => [ 94, "VEX or XOP encoded instruction"],
    "EVEX"              => [ 95, "EVEX encoded instruction"],

    #
    # dword bound, index 3 - cpu type flags
    #
    # The CYRIX and AMD flags should have the highest bit values; the
    # disassembler selection algorithm depends on it.
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
    "CYRIX"             => [126, "Cyrix-specific"],
    "AMD"               => [127, "AMD-specific"],
);

my %insns_flag_hash = ();
my @insns_flag_values = ();
my $iflag_words;

sub get_flag_words() {
    my $max = -1;

    foreach my $key (keys(%insns_flag_bit)) {
	if (${$insns_flag_bit{$key}}[0] > $max) {
	    $max = ${$insns_flag_bit{$key}}[0];
	}
    }

    return int($max/32)+1;
}

sub insns_flag_index(@) {
    return undef if $_[0] eq "ignore";

    my @prekey = sort(@_);
    my $key = join("", @prekey);

    if (not defined($insns_flag_hash{$key})) {
        my @newkey = (0) x $iflag_words;

        for my $i (@prekey) {
            die "No key for $i\n" if not defined($insns_flag_bit{$i});
	    $newkey[$insns_flag_bit{$i}[0]/32] |=
		(1 << ($insns_flag_bit{$i}[0] % 32));
        }

	my $str = join(',', map { sprintf("UINT32_C(0x%08x)",$_) } @newkey);

        push @insns_flag_values, $str;
        $insns_flag_hash{$key} = $#insns_flag_values;
    }

    return $insns_flag_hash{$key};
}

sub write_iflaggen_h() {
    print STDERR "Writing $oname...\n";

    open(N, '>', $oname) or die "$0: $!\n";

    print N "/* This file is auto-generated. Don't edit. */\n";
    print N "#ifndef NASM_IFLAGGEN_H\n";
    print N "#define NASM_IFLAGGEN_H 1\n\n";

    foreach my $key (sort { $insns_flag_bit{$a}[0] <=> $insns_flag_bit{$b}[0] } keys(%insns_flag_bit)) {
        print N sprintf("#define IF_%-16s %3d /* %-64s */\n",
            $key, $insns_flag_bit{$key}[0], $insns_flag_bit{$key}[1]);
    }

    print N "\n";
    print N "typedef struct {\n";
    printf N "    uint32_t field[%d];\n", $iflag_words;
    print N "} iflag_t;\n";

    print N "\n";
    printf N "extern const iflag_t insns_flags[%d];\n\n",
	$#insns_flag_values + 1;

    print N "#endif /* NASM_IFLAGGEN_H */\n";
    close N;
}

sub write_iflag_c() {
    print STDERR "Writing $oname...\n";

    open(N, '>', $oname) or die "$0: $!\n";

    print N "/* This file is auto-generated. Don't edit. */\n";
    print N "#include \"iflag.h\"\n\n";
    print N "/* Global flags referenced from instruction templates */\n";
    printf N "const iflag_t insns_flags[%d] = {\n",
        $#insns_flag_values + 1;
    foreach my $i (0 .. $#insns_flag_values) {
        print N sprintf("    /* %4d */ {{ %s }},\n", $i, $insns_flag_values[$i]);
    }
    print N "};\n\n";
    close N;
}

$iflag_words = get_flag_words();

1;
