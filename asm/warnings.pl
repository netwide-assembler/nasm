#!/usr/bin/perl

use strict;
use File::Find;
use File::Basename;

my @warnings = ();
my $err = 0;
my $nwarn = 0;

sub quote_for_c($) {
    my $s = join('', @_);

    $s =~ s/([\"\'\\])/\\\1/g;
    return $s;
}

sub find_warnings {
    my $infile = $_;

    return unless (basename($infile) =~ /^\w.*\.[ch]$/i);
    open(my $in, '<', $infile)
	or die "$0: cannot open input file $infile: $!\n";

    my $in_comment = 0;
    my $nline = 0;
    my $this;
    my @doc;

    while (defined(my $l = <$in>)) {
	$nline++;
	chomp $l;

	if (!$in_comment) {
	    $l =~ s/^.*?\/\*.*?\*\///g; # Remove single-line comments

	    if ($l =~ /^.*?(\/\*.*)$/) {
		# Begin block comment
		$l = $1;
		$in_comment = 1;
	    }
	}

	if ($in_comment) {
	    if ($l =~ /\*\//) {
		# End block comment
		$in_comment = 0;
		undef $this;
	    } elsif ($l =~ /^\s*\/?\*\!(\s*)(.*?)\s*$/) {
		my $ws = $1;
		my $str = $2;

		next if ($str eq '');
		
		if (!defined($this) || ($ws eq '' && $str ne '')) {
		    if ($str =~ /^([\w-]+)\s+\[(\w+)\]\s(.+)$/) {
			my $name = $1;
			my $def = $2;
			my $help = $3;

			my $cname = uc($name);
			$cname =~ s/[^A-Z0-9_]+/_/g;

			$this = {name => $name, cname => $cname,
				 def => $def, help => $help, doc => [],
				 file => $infile, line => $nline};
			push(@warnings, $this);
			$nwarn++;
		    } else {
			print STDERR "$infile:$nline: malformed warning definition\n";
			print STDERR "    $l\n";
			$err++;
		    }
		} else {
		    push(@{$this->{doc}}, "$str\n");
		}
	    } else {
		undef $this;
	    }
	}
    }
    close($in);
}

my($what, $outfile, @indirs) = @ARGV;

if (!defined($outfile)) {
    die "$0: usage: [c|h|doc] outfile indir...\n";
}

find({ wanted => \&find_warnings, no_chdir => 1, follow => 1 }, @indirs);

exit(1) if ($err);

my %sort_special = ( 'other' => 1, 'all' => 2 );
sub sort_warnings {
    my $an = $a->{name};
    my $bn = $b->{name};
    return ($sort_special{$an} <=> $sort_special{$bn}) || ($an cmp $bn);
}

@warnings = sort sort_warnings @warnings;
my @warn_noall = @warnings;
pop @warn_noall if ($warn_noall[$#warn_noall]->{name} eq 'all');

open(my $out, '>', $outfile)
    or die "$0: cannot open output file $outfile: $!\n";

if ($what eq 'c') {
    print $out "#include \"error.h\"\n\n";
    printf $out "const char * const warning_name[%d] = {\n",
	$#warnings + 2;
    print $out "\tNULL";
    foreach my $warn (@warnings) {
	print $out ",\n\t\"", $warn->{name}, "\"";
    }
    print $out "\n};\n\n";
    printf $out "const char * const warning_help[%d] = {\n",
	$#warnings + 2;
    print $out "\tNULL";
    foreach my $warn (@warnings) {
	my $help = quote_for_c($warn->{help});
	print $out ",\n\t\"", $help, "\"";
    }
    print $out "\n};\n\n";
    printf $out "const uint8_t warning_default[%d] = {\n",
	$#warn_noall + 2;
    print $out "\tWARN_INIT_ON"; # for entry 0
    foreach my $warn (@warn_noall) {
	print $out ",\n\tWARN_INIT_", uc($warn->{def});
    }
    print $out "\n};\n\n";
    printf $out "uint8_t warning_state[%d];\t/* Current state */\n",
	$#warn_noall + 2;
} elsif ($what eq 'h') {
    my $filename = basename($outfile);
    my $guard = $filename;
    $guard =~ s/[^A-Za-z0-9_]+/_/g;
    $guard = "NASM_\U$guard";

    print $out "#ifndef $guard\n";
    print $out "#define $guard\n";
    print $out "\n";
    print $out "#ifndef WARN_SHR\n";
    print $out "# error \"$filename should only be included from within error.h\"\n";
    print $out "#endif\n\n";
    print $out "enum warn_index {\n";
    printf $out "\tWARN_IDX_%-23s = %3d, /* not suppressible */\n", 'NONE', 0;
    my $n = 1;
    foreach my $warn (@warnings) {
	printf $out "\tWARN_IDX_%-23s = %3d%s /* %s */\n",
	    $warn->{cname}, $n,
	    ($n == $#warnings + 1) ? " " : ",",
	    $warn->{help};
	$n++;
    }
    print $out "};\n\n";

    print $out "enum warn_const {\n";
    printf $out "\tWARN_%-27s = %3d << WARN_SHR", 'NONE', 0;
    my $n = 1;
    foreach my $warn (@warn_noall) {
	printf $out ",\n\tWARN_%-27s = %3d << WARN_SHR", $warn->{cname}, $n++;
    }
    print $out "\n};\n\n";

    printf $out "extern const char * const warning_name[%d];\n",
	$#warnings + 2;
    printf $out "extern const char * const warning_help[%d];\n",
	$#warnings + 2;
    printf $out "extern const uint8_t warning_default[%d];\n",
	$#warn_noall + 2;
    printf $out "extern uint8_t warning_state[%d];\n",
	$#warn_noall + 2;
    print $out "\n#endif /* $guard */\n";
} elsif ($what eq 'doc') {
    my %whatdef = ( 'on' => 'Enabled',
		    'off' => 'Disabled',
		    'err' => 'Enabled and promoted to error' );
    foreach my $warn (@warnings) {

	my @doc = @{$warn->{doc}};
	shift @doc while ($doc[0] =~ /^\s*$/);
	pop @doc while ($doc[$#doc] =~ /^\s*$/);

	print $out "\\b \\i\\c{", $warn->{name}, "} ", @doc;

	my $docdef = $whatdef{$warn->{def}};
	if (defined($docdef)) {
	    print $out $docdef, " by default.\n";
	}

	print $out "\n";
    }
}
close($out);
