#!/usr/bin/perl
## --------------------------------------------------------------------------
##   
##   Copyright 1996-2011 The NASM Authors - All Rights Reserved
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
# Produce prtok.c, prtok.h and prtok.ph from prtok.dat
#

require 'phash.ph';

my($what, $in, $out) = @ARGV;

#
# Read prtok.dat
#
open(IN, "< $in") or die "$0: cannot open: $in\n";
while (defined($line = <IN>)) {
    chomp $line;
    $line =~ s/^\s+//;		# Remove leading whitespace
    $line =~ s/\s*\#.*$//;	# Remove comments and trailing whitespace
    next if ($line eq '');

    if ($line =~ /^(.*)$/) {
	push(@prtok, $1);
    }
}
close(IN);

@prtok = sort @prtok;

open(OUT, "> $out") or die "$0: cannot open: $out\n";

#
# Output prtok.h
#
if ($what eq 'h') {
    print OUT "/* Automatically generated from $in by $0 */\n";
    print OUT "/* Do not edit */\n";
    print OUT "\n";

    print OUT "enum pragma_token {\n";
    $n = 0;
    foreach $pt (@prtok) {
	if (defined($pt)) {
	    printf OUT "    %-16s = %3d,\n", "PR_\U$pt\E", $n;
	}
	$n++;
    }
    printf OUT "    %-16s = %3d\n", 'PR_INVALID', -1;
    print OUT "};\n";
    print OUT "\n";
}

#
# Output prtok.c
#
if ($what eq 'c') {
    print OUT "/* Automatically generated from $in by $0 */\n";
    print OUT "/* Do not edit */\n";
    print OUT "\n";

    my %tokens = ();
    my @tokendata = ();

    my $n = 0;
    foreach $pt (@prtok) {
	if (defined($pt)) {
	    $tokens{'%'.$pt} = $n;
	    if ($pt =~ /[\@\[\]\\_]/) {
		# Fail on characters which look like upper-case letters
		# to the quick-and-dirty downcasing in the prehash
		# (see below)
		die "$in: invalid character in token: $pt";
	    }
	}
	$n++;
    }

    my @hashinfo = gen_perfect_hash(\%tokens);
    if (!@hashinfo) {
	die "$0: no hash found\n";
    }

    # Paranoia...
    verify_hash_table(\%tokens, \@hashinfo);

    ($n, $sv, $g) = @hashinfo;
    $sv2 = $sv+2;

    die if ($n & ($n-1));

    print OUT "#include \"compiler.h\"\n";
    print OUT "#include <inttypes.h>\n";
    print OUT "#include <ctype.h>\n";
    print OUT "#include \"nasmlib.h\"\n";
    print OUT "#include \"hashtbl.h\"\n";
    print OUT "#include \"preproc.h\"\n";
    print OUT "\n";

    # Note that this is global.
    printf OUT "const char * const pr_directives[%d] = {\n", scalar(@prtok);
    foreach $d (@prtok) {
	if (defined($d)) {
	    print OUT "    \"$d\",\n";
	} else {
	    print OUT "    NULL,\n";
	}
    }
    print OUT  "};\n";

    printf OUT "const uint8_t pr_directives_len[%d] = {\n", scalar(@prtok);
    foreach $d (@prtok) {
	printf OUT "    %d,\n", defined($d) ? length($d)+1 : 0;
    }
    print OUT  "};\n";

    print OUT "enum pragma_token pr_token_hash(const char *token)\n";
    print OUT "{\n";

    # Put a large value in unused slots.  This makes it extremely unlikely
    # that any combination that involves unused slot will pass the range test.
    # This speeds up rejection of unrecognized tokens, i.e. identifiers.
    print OUT "#define UNUSED 16383\n";

    print OUT "    static const int16_t hash1[$n] = {\n";
    for ($i = 0; $i < $n; $i++) {
	my $h = ${$g}[$i*2+0];
	print OUT "        ", defined($h) ? $h : 'UNUSED', ",\n";
    }
    print OUT "    };\n";

    print OUT "    static const int16_t hash2[$n] = {\n";
    for ($i = 0; $i < $n; $i++) {
	my $h = ${$g}[$i*2+1];
	print OUT "        ", defined($h) ? $h : 'UNUSED', ",\n";
    }
    print OUT "    };\n";

    print OUT  "    uint32_t k1, k2;\n";
    print OUT  "    uint64_t crc;\n";
    # For correct overflow behavior, "ix" should be unsigned of the same
    # width as the hash arrays.
    print OUT  "    uint16_t ix;\n";
    print OUT  "\n";

    printf OUT "    crc = crc64i(UINT64_C(0x%08x%08x), token);\n",
	$$sv[0], $$sv[1];
    print  OUT "    k1 = (uint32_t)crc;\n";
    print  OUT "    k2 = (uint32_t)(crc >> 32);\n";
    print  OUT "\n";
    printf OUT "    ix = hash1[k1 & 0x%x] + hash2[k2 & 0x%x];\n", $n-1, $n-1;
    printf OUT "    if (ix >= %d)\n", scalar(@prtok);
    print OUT  "        return PR_INVALID;\n";
    print OUT  "\n";

    print OUT  "    if (!pr_directives[ix] || nasm_stricmp(pr_directives[ix], token))\n";
    print OUT  "        return PR_INVALID;\n";
    print OUT  "\n";
    print OUT  "    return ix;\n";
    print OUT  "}\n";
}

#
# Output prtok.ph
#
if ($what eq 'ph') {
    print OUT "# Automatically generated from $in by $0\n";
    print OUT "# Do not edit\n";
    print OUT "\n";
    
    print OUT "%prtok_hash = (\n";
    $n = 0;
    foreach $tok (@prtok) {
	if (defined($tok)) {
	    printf OUT "    '%%%s' => %d,\n", $tok, $n;
	}
	$n++;
    }
    print OUT ");\n";
    print OUT "1;\n";
}

    
