#!/usr/bin/perl
#
# Generate a perfect hash for token parsing
#
# Usage: tokenhash.pl insns.dat regs.dat tokens.dat
#

require 'phash.ph';

my($insns_dat, $regs_dat, $tokens_dat) = @ARGV;

%tokens = ();
@tokendata = ();

#
# List of condition codes
#
@conditions = ('a', 'ae', 'b', 'be', 'c', 'e', 'g', 'ge', 'l', 'le',
	       'na', 'nae', 'nb', 'nbe', 'nc', 'ne', 'ng', 'nge', 'nl',
	       'nle', 'no', 'np', 'ns', 'nz', 'o', 'p', 'pe', 'po', 's', 'z');

#
# Read insns.dat
#
open(ID, "< ${insns_dat}") or die "$0: cannot open $insns_dat: $!\n";
while (defined($line = <ID>)) {
    if ($line =~ /^([A-Z0-9_]+)(|cc)\s/) {
	$insn = $1.$2;
	($token = $1) =~ tr/A-Z/a-z/;
	
	if ($2 eq '') {
	    # Single instruction token
	    if (!defined($tokens{$token})) {
		$tokens{$token} = scalar @tokendata;
		push(@tokendata, "\"${token}\", TOKEN_INSN, 0, I_${insn}");
	    }
	} else {
	    # Conditional instruction
	    foreach $cc (@conditions) {
		if (!defined($tokens{$token.$cc})) {
		    $tokens{$token.$cc} = scalar @tokendata;
		    push(@tokendata, "\"${token}${cc}\", TOKEN_INSN, C_\U$cc\E, I_${insn}");
		}
	    }
	}
    }
}
close(ID);

#
# Read regs.dat
#
open(RD, "< ${regs_dat}") or die "$0: cannot open $regs_dat: $!\n";
while (defined($line = <RD>)) {
    if ($line =~ /^([a-z0-9_-]+)\s/) {
	$reg = $1;

	if ($reg =~ /^(.*[^0-9])([0-9]+)\-([0-9]+)(|[^0-9].*)$/) {
	    $nregs = $3-$2+1;
	    $reg = $1.$2.$4;
	    $reg_nr = $2;
	    $reg_prefix = $1;
	    $reg_suffix = $4;	
	} else {
	    $nregs = 1;
	    undef $reg_prefix, $reg_suffix;
	}

	while ($nregs--) {
	    if (defined($tokens{$reg})) {
		die "Duplicate definition: $reg\n";
	    }
	    $tokens{$reg} = scalar @tokendata;
	    push(@tokendata, "\"${reg}\", TOKEN_REG, 0, R_\U${reg}\E");
	
	    if (defined($reg_prefix)) {
		$reg_nr++;
		$reg = sprintf("%s%u%s", $reg_prefix, $reg_nr, $reg_suffix);
	    } else {
		# Not a dashed sequence
		die if ($nregs);
	    }
	}
    }
}
close(RD);

#
# Read tokens.dat
#
open(TD, "< ${tokens_dat}") or die "$0: cannot open $tokens_dat: $!\n";
while (defined($line = <TD>)) {
    if ($line =~ /^\%\s+(.*)$/) {
	$pattern = $1;
    } elsif ($line =~ /^([a-z0-9_-]+)/) {
	$token = $1;

	if (defined($tokens{$token})) {
	    die "Duplicate definition: $token\n";
	}
	$tokens{$token} = scalar @tokendata;
	
	$data = $pattern;
	$data =~ s/\*/\U$token/g;

	push(@tokendata, "\"$token\", $data");
    }
}
close(TD);

#
# Actually generate the hash
#
@hashinfo = gen_perfect_hash(\%tokens);
if (!defined(@hashinfo)) {
    die "$0: no hash found\n";
}

# Paranoia...
verify_hash_table(\%tokens, \@hashinfo);

($n, $sv, $g) = @hashinfo;
$sv2 = $sv+2;

die if ($n & ($n-1));

print "/*\n";
print " * This file is generated from insns.dat, regs.dat and token.dat\n";
print " * by tokhash.pl; do not edit.\n";
print " */\n";
print "\n";

print "#include <string.h>\n";
print "#include \"nasm.h\"\n";
print "#include \"insns.h\"\n";
print "\n";

print "#define rot(x,y) (((uint32_t)(x) << (y))+((uint32_t)(x) >> (32-(y))))\n";
print "\n";

# These somewhat odd sizes and ordering thereof are due to the
# relative ranges of the types; this makes it fit in 16 bytes on
# 64-bit machines and 12 bytes on 32-bit machines.
print "struct tokendata {\n";
print "    const char *string;\n";
print "    int16_t tokentype;\n";
print "    uint16_t aux;\n";
print "    uint32_t num;\n";
print "};\n";
print "\n";

print "int nasm_token_hash(const char *token, struct tokenval *tv)\n";
print "{\n";

# Put a large value in unused slots.  This makes it extremely unlikely
# that any combination that involves unused slot will pass the range test.
# This speeds up rejection of unrecognized tokens, i.e. identifiers.
print "#define UNUSED 16383\n";

print "    static const int16_t hash1[$n] = {\n";
for ($i = 0; $i < $n; $i++) {
    my $h = ${$g}[$i*2+0];
    print "        ", defined($h) ? $h : 'UNUSED', ",\n";
}
print "    };\n";

print "    static const int16_t hash2[$n] = {\n";
for ($i = 0; $i < $n; $i++) {
    my $h = ${$g}[$i*2+1];
    print "        ", defined($h) ? $h : 'UNUSED', ",\n";
}
print "    };\n";

printf "    static const struct tokendata tokendata[%d] = {\n", scalar(@tokendata);
foreach $d (@tokendata) {
    print "        { ", $d, " },\n";
}
print  "    };\n";

print  "    uint32_t k1 = 0, k2 = 0;\n";
print  "    uint8_t c;\n";
# For correct overflow behavior, "ix" should be unsigned of the same
# width as the hash arrays.
print  "    uint16_t ix;\n";
print  "    const struct tokendata *data;\n";
print  "    const char *p = token;\n";
print  "\n";

print  "    while ((c = *p++) != 0) {\n";
printf "        uint32_t kn1 = rot(k1,%2d) - rot(k2,%2d) + c;\n", ${$sv}[0], ${$sv}[1];
printf "        uint32_t kn2 = rot(k2,%2d) - rot(k1,%2d) + c;\n", ${$sv}[2], ${$sv}[3];
print  "        k1 = kn1; k2 = kn2;\n";
print  "    }\n";
print  "\n";
printf "    ix = hash1[k1 & 0x%x] + hash2[k2 & 0x%x];\n", $n-1, $n-1;
printf "    if (ix >= %d)\n", scalar(@tokendata);
print  "        return -1;\n";
print  "\n";
print  "    data = &tokendata[ix];\n";

# print  "    fprintf(stderr, \"Looked for: %s found: %s\\n\", token, data->string);\n\n";

print  "    if (strcmp(data->string, token))\n";
print  "        return -1;\n";
print  "\n";
print  "    tv->t_integer = data->num;\n";
print  "    tv->t_inttwo  = data->aux;\n";
print  "    return tv->t_type = data->tokentype;\n";
print  "}\n";
