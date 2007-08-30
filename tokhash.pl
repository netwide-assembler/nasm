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
		push(@tokendata, "\"${token}\", TOKEN_INSN, I_${insn}, 0");
	    }
	} else {
	    # Conditional instruction
	    foreach $cc (@conditions) {
		if (!defined($tokens{$token.$cc})) {
		    $tokens{$token.$cc} = scalar @tokendata;
		    push(@tokendata, "\"${token}${cc}\", TOKEN_INSN, I_${insn}, C_\U$cc\E");
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
	    push(@tokendata, "\"${reg}\", TOKEN_REG, R_\U${reg}\E, 0");
	
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

	if (defined($tokens{$reg})) {
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

($n, $sv, $f1, $f2, $g) = @hashinfo;
$sv2 = $sv+2;

die if ($n & ($n-1));

print "#include \"nasm.h\"\n";
print "#include \"insns.h\"\n";
print "\n";

print "#define rot(x,y) (((uint32_t)(x) << (y))+((uint32_t)(x) >> (32-(y))))\n";
print "\n";

print "struct tokendata {\n";
print "\tconst char *string;\n";
print "\tint tokentype;\n";
print "\tint i1, i2;\n";
print "};\n";
print "\n";

print "int nasm_token_hash(const char *token, struct tokenval *tv)\n";
print "{\n";

print "\tstatic const int hash1[$n] =\n";
print "\t{\n";
for ($i = 0; $i < $n; $i++) {
    print "\t\t", ${$g}[${$f1}[$i]], ",\n";
}
print "\t};\n\n";

print "\tstatic const int hash2[$n] =\n";
print "\t{\n";
for ($i = 0; $i < $n; $i++) {
    print "\t\t", ${$g}[${$f2}[$i]], ",\n";
}
print "\t};\n\n";

printf "\tstatic const struct tokendata tokendata[%d] =\n", scalar(@tokendata);
print "\t{\n";
foreach $d (@tokendata) {
    print "\t\t{ ", $d, " },\n";
}
print "\t};\n\n";

print "\tuint32_t k1 = 0, k2 = 0;\n";
print "\tuint8_t c;\n";
print "\tconst struct tokendata *data;\n";
print "\tconst char *p = token;\n";
print "\n";

print "\twhile ((c = *p++) != 0) {\n";
printf "\t\tk1 = rot(k1,%2d) - rot(k2,%2d) + c;\n", ${$sv}[0], ${$sv}[1];
printf "\t\tk2 = rot(k2,%2d) - rot(k1,%2d) + c;\n", ${$sv}[2], ${$sv}[3];
print "\t}\n";
print "\n";
printf "\tdata = &tokendata[(k1+k2) & 0x%08x];\n", $n-1;
printf "\tif (data >= &tokendata[%d] || strcmp(data->string, token))\n",
    scalar(@tokendata);
print "\t\treturn -1;\n";
print "\n";
print "\ttv->t_integer = data->i1;\n";
print "\ttv->t_inttwo  = data->i2;\n";
print "\treturn tv->t_type = data->tokentype;\n";
print "}\n";
