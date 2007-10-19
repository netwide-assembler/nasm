#!/usr/bin/perl
#
# Produce pptok.c and pptok.h from pptok.dat
#

require 'phash.ph';

my($what, $in, $out) = @ARGV;

#
# Read pptok.dat
#
open(IN, "< $in") or die "$0: cannot open: $in\n";
while (defined($line = <IN>)) {
    chomp $line;
    $line =~ s/^\s+//;		# Remove leading whitespace
    $line =~ s/\s*\#.*$//;	# Remove comments and trailing whitespace
    next if ($line eq '');

    if ($line =~ /^\%(.*)\*$/) {
	push(@cctok, $1);
    } elsif ($line =~ /^\%(.*)$/) {
	push(@pptok, $1);
    } elsif ($line =~ /^\*(.*)$/) {
	push(@cond, $1);
    }
}
close(IN);

@cctok = sort @cctok;
@cond = sort @cond;
@pptok = sort @pptok;

# Generate the expanded list including conditionals.  The conditionals
# are at the beginning, padded to a power of 2, with the inverses
# interspersed; this allows a simple mask to pick out the condition.

while ((scalar @cond) & (scalar @cond)-1) {
    push(@cond, undef);
}

@cptok = ();
foreach $ct (@cctok) {
    foreach $cc (@cond) {
	if (defined($cc)) {
	    push(@cptok, $ct.$cc);
	    push(@cptok, $ct.'n'.$cc);
	} else {
	    push(@cptok, undef, undef);
	}
    }
}
$first_uncond = $pptok[0];
@pptok = (@cptok, @pptok);

open(OUT, "> $out") or die "$0: cannot open: $out\n";
print OUT "/* Automatically generated from $in by $0 */\n";
print OUT "/* Do not edit */\n";
print OUT "\n";

#
# Output pptok.h
#
if ($what eq 'h') {
    print OUT "enum preproc_token {\n";
    $n = 0;
    foreach $pt (@pptok) {
	if (defined($pt)) {
	    printf OUT "    %-16s = %3d,\n", "PP_\U$pt\E", $n;
	}
	$n++;
    }
    printf OUT "    %-16s = %3d\n", 'PP_INVALID', -1;
    print OUT "};\n";
    print OUT "\n";

    print  OUT "enum pp_conditional {\n";
    $n = 0;
    foreach $cc (@cond) {
	if (defined($cc)) {
	    printf OUT "    %-16s = %3d,\n", "PPC_IF\U$cc\E", $n;
	}
	$n += 2;
    }
    print  OUT "};\n\n";

    printf OUT "#define PP_COND(x)     ((enum pp_conditional)((x) & 0x%x))\n",
	(scalar(@cond)-1) << 1;
    print  OUT "#define PP_IS_COND(x)  ((unsigned int)(x) < PP_\U$first_uncond\E)\n";
    print  OUT "#define PP_NEGATIVE(x) ((x) & 1)\n";
    print  OUT "\n";

    foreach $ct (@cctok) {
	print OUT "#define CASE_PP_\U$ct\E";
	$pref = " \\\n";
	foreach $cc (@cond) {
	    if (defined($cc)) {
		print OUT "$pref\tcase PP_\U${ct}${cc}\E: \\\n";
		print OUT "\tcase PP_\U${ct}N${cc}\E";
		$pref = ":\\\n";
	    }
	}
	print OUT "\n";		# No colon or newline on the last one
    }
}

#
# Output pptok.c
#
if ($what eq 'c') {
    my %tokens = ();
    my @tokendata = ();

    my $n = 0;
    foreach $pt (@pptok) {
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
    if (!defined(@hashinfo)) {
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
    printf OUT "const char * const pp_directives[%d] = {\n", scalar(@pptok);
    foreach $d (@pptok) {
	if (defined($d)) {
	    print OUT "    \"%$d\",\n";
	} else {
	    print OUT "    NULL,\n";
	}
    }
    print OUT  "};\n";

    print OUT "enum preproc_token pp_token_hash(const char *token)\n";
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
    printf OUT "    if (ix >= %d)\n", scalar(@pptok);
    print OUT  "        return PP_INVALID;\n";
    print OUT  "\n";

    print OUT  "    if (!pp_directives[ix] || nasm_stricmp(pp_directives[ix], token))\n";
    print OUT  "        return PP_INVALID;\n";
    print OUT  "\n";
    print OUT  "    return ix;\n";
    print OUT  "}\n";
}
