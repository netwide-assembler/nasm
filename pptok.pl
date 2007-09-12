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
    
    if ($line =~ /^(\%.*)\*$/) {
	push(@cctok, $1);
    } elsif ($line =~ /^(\%.*)$/) {
	push(@pptok, $1);
    } elsif ($line =~ /^\*(.*)$/) {
	push(@cond, $1);
    }
}
close(IN);

@cctok = sort @cctok;
@cond = sort @cond;

# Generate the expanded list including conditionals
foreach $ct (@cctok) {
    foreach $cc (@cond) {
	push(@pptok, $ct.$cc);
	push(@pptok, $ct.'n'.$cc);
    }
}

@pptok = sort @pptok;

open(OUT, "> $out") or die "$0: cannot open: $out\n";
print OUT "/* Automatically generated from $in by $0 */\n";
print OUT "/* Do not edit */\n";
print OUT "\n";

#
# Output pptok.h
#
if ($what eq 'h') {
    print OUT "enum preproc_token {\n";
    foreach $pt (@pptok) {
	(my $px = $pt) =~ s/\%//g;
	print OUT "    PP_\U$px\E,\n";
    }
    print OUT "    PP_INVALID = -1\n";
    print OUT "};\n";
    print OUT "\n";

    $first_cc = $cond[0];
    $last_cc  = $cond[(scalar @cond)-1];

    foreach $ct (@cctok) {
	(my $cx = $ct) =~ s/\%//g;
	print OUT "#define IS_PP_\U$cx\E(x) ((x) >= PP_\U$cx$first_cc\E && ";
	print OUT "(x) <= PP_\U$cx$last_cc\E)\n";
    }
}

#
# Output pptok.c
#
if ($what eq 'c') {
    my %tokens = ();
    my @tokendata = ();

    foreach $pt (@pptok) {
	(my $px = $pt) =~ s/\%//g;
	$tokens{$pt} = scalar @tokendata;
	push(@tokendata, $pt);
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
    
    print OUT "#include <inttypes.h>\n";
    print OUT "#include <ctype.h>\n";
    print OUT "#include \"nasmlib.h\"\n";
    print OUT "#include \"preproc.h\"\n";
    print OUT "\n";

    print OUT "#define rot(x,y) (((uint32_t)(x) << (y))+((uint32_t)(x) >> (32-(y))))\n";
    print OUT "\n";

    # Note that this is global.
    printf OUT "const char * const pp_directives[%d] = {\n",
    	scalar(@tokendata);
    foreach $d (@tokendata) {
	print OUT "    \"$d\",\n";
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
    
    print OUT  "    uint32_t k1 = 0, k2 = 0;\n";
    print OUT  "    uint8_t c;\n";
    # For correct overflow behavior, "ix" should be unsigned of the same
    # width as the hash arrays.
    print OUT  "    uint16_t ix;\n";
    print OUT  "    const char *p = token;\n";
    print OUT  "\n";

    print OUT  "    while ((c = *p++) != 0) {\n";
    print OUT  "        c = tolower(c);\n";
    printf OUT "        uint32_t kn1 = rot(k1,%2d) - rot(k2,%2d) + c;\n", ${$sv}[0], ${$sv}[1];
    printf OUT "        uint32_t kn2 = rot(k2,%2d) - rot(k1,%2d) + c;\n", ${$sv}[2], ${$sv}[3];
    print OUT  "        k1 = kn1; k2 = kn2;\n";
    print OUT  "    }\n";
    print OUT  "\n";
    printf OUT "    ix = hash1[k1 & 0x%x] + hash2[k2 & 0x%x];\n", $n-1, $n-1;
    printf OUT "    if (ix >= %d)\n", scalar(@tokendata);
    print OUT  "        return PP_INVALID;\n";
    print OUT  "\n";

    print OUT  "    if (nasm_stricmp(pp_directives[ix], token))\n";
    print OUT  "        return PP_INVALID;\n";
    print OUT  "\n";
    print OUT  "    return ix;\n";
    print OUT  "}\n";
}
