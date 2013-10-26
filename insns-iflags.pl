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

sub write_iflags() {
    print STDERR "Writing iflag.h ...\n";

    open N, ">iflag.h";

    print N "/* This file is auto-generated. Don't edit. */\n";
    print N "#ifndef NASM_IFLAG_H__\n";
    print N "#define NASM_IFLAG_H__\n\n";

    print N "#include <inttypes.h>\n\n";
    print N "#include <string.h>\n\n";

    print N "#include \"compiler.h\"\n";

    print N "extern int ilog2_32(uint32_t v);\n\n";

    print N "/*\n";
    print N " * Instruction template flags. These specify which processor\n";
    print N " * targets the instruction is eligible for, whether it is\n";
    print N " * privileged or undocumented, and also specify extra error\n";
    print N " * checking on the matching of the instruction.\n";
    print N " *\n";
    print N " * IF_SM stands for Size Match: any operand whose size is not\n";
    print N " * explicitly specified by the template is `really' intended to be\n";
    print N " * the same size as the first size-specified operand.\n";
    print N " * Non-specification is tolerated in the input instruction, but\n";
    print N " * _wrong_ specification is not.\n";
    print N " *\n";
    print N " * IF_SM2 invokes Size Match on only the first _two_ operands, for\n";
    print N " * three-operand instructions such as SHLD: it implies that the\n";
    print N " * first two operands must match in size, but that the third is\n";
    print N " * required to be _unspecified_.\n";
    print N " *\n";
    print N " * IF_SB invokes Size Byte: operands with unspecified size in the\n";
    print N " * template are really bytes, and so no non-byte specification in\n";
    print N " * the input instruction will be tolerated. IF_SW similarly invokes\n";
    print N " * Size Word, and IF_SD invokes Size Doubleword.\n";
    print N " *\n";
    print N " * (The default state if neither IF_SM nor IF_SM2 is specified is\n";
    print N " * that any operand with unspecified size in the template is\n";
    print N " * required to have unspecified size in the instruction too...)\n";
    print N " *\n";
    print N " * iflag_t is defined to store these flags.\n";
    print N " */\n";
    foreach my $key (sort { $insns_flag_bit{$a}[0] <=> $insns_flag_bit{$b}[0] } keys(%insns_flag_bit)) {
        print N sprintf("#define IF_%-16s (%3d) /* %-64s */\n",
            $key, $insns_flag_bit{$key}[0], $insns_flag_bit{$key}[1]);
    }

    print N "\n";
    print N "typedef struct {\n";
    print N "    uint32_t field[4];\n";
    print N "} iflag_t;\n\n";

    print N "\n";
    print N sprintf("extern iflag_t insns_flags[%d];\n\n", $#insns_flag_values + 1);

    print N "#define IF_GENBIT(bit)          (UINT32_C(1) << (bit))\n\n";

    print N "static inline unsigned int iflag_test(iflag_t *f,unsigned int bit)\n";
    print N "{\n";
    print N "    unsigned int index = bit / 32;\n";
    print N "    return f->field[index] & (UINT32_C(1) << (bit - (index * 32)));\n";
    print N "}\n\n";

    print N "static inline void iflag_set(iflag_t *f, unsigned int bit)\n";
    print N "{\n";
    print N "    unsigned int index = bit / 32;\n";
    print N "    f->field[index] |= (UINT32_C(1) << (bit - (index * 32)));\n";
    print N "}\n\n";

    print N "static inline void iflag_clear(iflag_t *f, unsigned int bit)\n";
    print N "{\n";
    print N "    unsigned int index = bit / 32;\n";
    print N "    f->field[index] &= ~(UINT32_C(1) << (bit - (index * 32)));\n";
    print N "}\n\n";

    print N "static inline void iflag_clear_all(iflag_t *f)\n";
    print N "{\n";
    print N "     memset(f, 0, sizeof(*f));\n";
    print N "}\n\n";

    print N "static inline void iflag_set_all(iflag_t *f)\n";
    print N "{\n";
    print N "     memset(f, 0xff, sizeof(*f));\n";
    print N "}\n\n";

    print N "static inline int iflag_cmp(iflag_t *a, iflag_t *b)\n";
    print N "{\n";
    print N "    unsigned int i;\n";
    print N "\n";
    print N "    for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++) {\n";
    print N "        if (a->field[i] < b->field[i])\n";
    print N "            return -1;\n";
    print N "        else if (a->field[i] > b->field[i])\n";
    print N "            return 1;\n";
    print N "    }\n";
    print N "\n";
    print N "    return 0;\n";
    print N "}\n\n";

    print N "static inline int iflag_cmp_cpu(iflag_t *a, iflag_t *b)\n";
    print N "{\n";
    print N "    if (a->field[3] < b->field[3])\n";
    print N "        return -1;\n";
    print N "    else if (a->field[3] > b->field[3])\n";
    print N "        return 1;\n";
    print N "    return 0;\n";
    print N "}\n\n";

    print N "static inline unsigned int iflag_ffs(iflag_t *a)\n";
    print N "{\n";
    print N "    unsigned int i;\n";
    print N "\n";
    print N "    for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++) {\n";
    print N "        if (a->field[i])\n";
    print N "            return ilog2_32(a->field[i]) + (i * 32);\n";
    print N "    }\n";
    print N "\n";
    print N "    return 0;\n";
    print N "}\n\n";

    print N "#define IF_GEN_HELPER(name, op)                                         \\\n";
    print N "    static inline iflag_t iflag_##name(iflag_t *a, iflag_t *b)          \\\n";
    print N "    {                                                                   \\\n";
    print N "        unsigned int i;                                                 \\\n";
    print N "        iflag_t res;                                                    \\\n";
    print N "                                                                        \\\n";
    print N "        for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++)    \\\n";
    print N "            res.field[i] = a->field[i] op b->field[i];                  \\\n";
    print N "                                                                        \\\n";
    print N "        return res;                                                     \\\n";
    print N "    }\n";
    print N "\n";
    print N "IF_GEN_HELPER(xor, ^)\n";
    print N "\n\n";

    print N "/* Use this helper to test instruction template flags */\n";
    print N "#define itemp_has(itemp, bit)   iflag_test(&insns_flags[(itemp)->iflag_idx], bit)\n\n";

    print N "\n";
    print N "/* Maximum processor level at moment */\n";
    print N "#define IF_PLEVEL               IF_IA64\n";

    print N "/* Some helpers which are to work with predefined masks */\n";
    print N "#define IF_SMASK        \\\n";
    print N "    (IF_GENBIT(IF_SB)  |\\\n";
    print N "     IF_GENBIT(IF_SW)  |\\\n";
    print N "     IF_GENBIT(IF_SD)  |\\\n";
    print N "     IF_GENBIT(IF_SQ)  |\\\n";
    print N "     IF_GENBIT(IF_SO)  |\\\n";
    print N "     IF_GENBIT(IF_SY)  |\\\n";
    print N "     IF_GENBIT(IF_SZ)  |\\\n";
    print N "     IF_GENBIT(IF_SIZE))\n";
    print N "#define IF_ARMASK       \\\n";
    print N "    (IF_GENBIT(IF_AR0) |\\\n";
    print N "     IF_GENBIT(IF_AR1) |\\\n";
    print N "     IF_GENBIT(IF_AR2) |\\\n";
    print N "     IF_GENBIT(IF_AR3) |\\\n";
    print N "     IF_GENBIT(IF_AR4))\n";

    print N "\n";
    print N "#define __itemp_smask(idx)      (insns_flags[(idx)].field[0] & IF_SMASK)\n";
    print N "#define __itemp_armask(idx)     (insns_flags[(idx)].field[0] & IF_ARMASK)\n";
    print N "#define __itemp_arg(idx)        ((__itemp_armask(idx) >> IF_AR0) - 1)\n";
    print N "\n";
    print N "#define itemp_smask(itemp)      __itemp_smask((itemp)->iflag_idx)\n";
    print N "#define itemp_arg(itemp)        __itemp_arg((itemp)->iflag_idx)\n";
    print N "#define itemp_armask(itemp)     __itemp_armask((itemp)->iflag_idx)\n";

    print N "\n";
    print N "static inline int iflag_cmp_cpu_level(iflag_t *a, iflag_t *b)\n";
    print N "{\n";
    print N "    iflag_t v1 = *a;\n";
    print N "    iflag_t v2 = *b;\n";
    print N "\n";
    print N "    iflag_clear(&v1, IF_CYRIX);\n";
    print N "    iflag_clear(&v1, IF_AMD);\n";
    print N "\n";
    print N "    iflag_clear(&v2, IF_CYRIX);\n";
    print N "    iflag_clear(&v2, IF_AMD);\n";
    print N "\n";
    print N "    if (v1.field[3] < v2.field[3])\n";
    print N "        return -1;\n";
    print N "    else if (v1.field[3] > v2.field[3])\n";
    print N "        return 1;\n";
    print N "\n";
    print N "    return 0;\n";
    print N "}\n";


    print N "\n";
    print N "static inline iflag_t __iflag_pfmask(iflag_t *a)\n";
    print N "{\n";
    print N "	iflag_t r = (iflag_t) {\n";
    print N "		.field[1] = a->field[1],\n";
    print N "		.field[2] = a->field[2],\n";
    print N "	};\n";
    print N "\n";
    print N "	if (iflag_test(a, IF_CYRIX))\n";
    print N "		iflag_set(&r, IF_CYRIX);\n";
    print N "	if (iflag_test(a, IF_AMD))\n";
    print N "		iflag_set(&r, IF_AMD);\n";
    print N "\n";
    print N "	return r;\n";
    print N "}\n";

    print N "\n";
    print N "#define iflag_pfmask(itemp)	__iflag_pfmask(&insns_flags[(itemp)->iflag_idx])\n";

    print N "\n";
    print N "#endif /* NASM_IFLAG_H__ */\n";
    close N;

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
