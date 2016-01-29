#!/usr/bin/perl
## --------------------------------------------------------------------------
##
##   Copyright 1996-2009 The NASM Authors - All Rights Reserved
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
# Generate a perfect hash for directive parsing
#
# Usage:
#      directiv.pl h directiv.dat directiv.h (to generate C header)
#      directiv.pl c directiv.dat directiv.c (to generate C source)
#

require 'phash.ph';

my($output, $directives_dat, $outfile) = @ARGV;

@directives = ();
@specials   = ('none', 'unknown');

open(DD, "< ${directives_dat}\0")
    or die "$0: cannot open: ${directives_dat}: $!\n";
while (defined($line = <DD>)) {
    chomp $line;
    if ($line =~ /^\s*([[:alnum:]]+)\s*(|[\;\#].*)$/) {
	push(@directives, $1);
    }
}
close(DD);

if ($output eq 'h') {
    open(H, "> ${outfile}\0")
	or die "$0: cannot create: ${outfile}: $!\n";

    print H "/*\n";
    print H " * This	 file is generated from directiv.dat\n";
    print H " * by directiv.pl; do not edit.\n";
    print H " */\n";
    print H "\n";

    print H "#ifndef NASM_DIRECTIVES_H\n";
    print H "#define NASM_DIRECTIVES_H\n";
    print H "\n";

    $c = '{';
    print H "enum directives ";
    foreach $d (@specials) {
	print H "$c\n    D_$d";
	$c = ',';
    }
    foreach $d (@directives) {
	print H "$c\n    D_\U$d";
	$c = ',';
    }
    print H "\n};\n\n";
    printf H "extern const char * const directives[%d];\n",
        scalar(@directives)+scalar(@specials);
    print H "enum directives find_directive(const char *token);\n\n";
    print H "#endif /* NASM_DIRECTIVES_H */\n";
} elsif ($output eq 'c') {
    %directive = ();
    $n = 0;
    foreach $d (@directives) {
	if (exists($directive{$d})) {
	    die "$0: $directives_dat: duplicate directive: $d\n";
	}
	$directive{$d} = $n++;	# This is zero-based, unlike the enum!
    }

    @hashinfo = gen_perfect_hash(\%directive);
    if (!@hashinfo) {
	die "$0: no hash found\n";
    }

    # Paranoia...
    verify_hash_table(\%directive, \@hashinfo);

    ($n, $sv, $g) = @hashinfo;

    die if ($n & ($n-1));

    open(C, "> ${outfile}\0")
	or die "$0: cannot create: ${directives_c}: $!\n";

    print C "/*\n";
    print C " * This file is generated from directiv.dat\n";
    print C " * by directiv.pl; do not edit.\n";
    print C " */\n";
    print C "\n";

    print C "#include \"compiler.h\"\n";
    print C "#include <string.h>\n";
    print C "#include \"nasm.h\"\n";
    print C "#include \"hashtbl.h\"\n";
    print C "#include \"directiv.h\"\n";
    print C "\n";

    printf C "const char * const directives[%d] =\n",
        scalar(@directives)+scalar(@specials);
    $c = '{';
    foreach $d (@specials) {
	print C "$c\n    NULL";
	$c = ',';
    }
    foreach $d (@directives) {
	print C "$c\n    \"$d\"";
	$c = ',';
    }
    print C "\n};\n\n";

    print C "enum directives find_directive(const char *token)\n";
    print C "{\n";

    # Put a large value in unused slots.  This makes it extremely unlikely
    # that any combination that involves unused slot will pass the range test.
    # This speeds up rejection of unrecognized tokens, i.e. identifiers.
    print C "#define UNUSED (65535/3)\n";

    print C "    static const int16_t hash1[$n] = {\n";
    for ($i = 0; $i < $n; $i++) {
	my $h = ${$g}[$i*2+0];
	print C "        ", defined($h) ? $h : 'UNUSED', ",\n";
    }
    print C "    };\n";

    print C "    static const int16_t hash2[$n] = {\n";
    for ($i = 0; $i < $n; $i++) {
	my $h = ${$g}[$i*2+1];
	print C "        ", defined($h) ? $h : 'UNUSED', ",\n";
    }
    print C "    };\n";

    print C  "    uint32_t k1, k2;\n";
    print C  "    uint64_t crc;\n";
    # For correct overflow behavior, "ix" should be unsigned of the same
    # width as the hash arrays.
    print C  "    uint16_t ix;\n";
    print C  "\n";
    printf C "    crc = crc64i(UINT64_C(0x%08x%08x), token);\n",
	$$sv[0], $$sv[1];
    print C  "    k1 = (uint32_t)crc;\n";
    print C  "    k2 = (uint32_t)(crc >> 32);\n";
    print C  "\n";
    printf C "    ix = hash1[k1 & 0x%x] + hash2[k2 & 0x%x];\n", $n-1, $n-1;
    printf C "    if (ix >= %d)\n", scalar(@directives);
    print C  "        return D_unknown;\n";
    print C  "\n";
    printf C "    ix += %d;\n", scalar(@specials);
    print C  "    if (nasm_stricmp(token, directives[ix]))\n";
    print C  "        return D_unknown;\n";
    print C  "\n";
    print C  "    return ix;\n";
    print C  "}\n";
}
