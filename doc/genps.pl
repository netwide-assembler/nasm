#!/usr/bin/perl
#
# Format the documentation as PostScript
#

require 'psfonts.ph';		# The fonts we want to use
require 'pswidth.ph';		# PostScript string width

#
# PostScript configurables; these values are also available to the
# PostScript code itself
#
%psconf = (
	   pagewidth => 595,    # Page width in PostScript points
	   pageheight => 792,	# Page height in PostScript points
	   lmarg => 100,	# Left margin in PostScript points
	   rmarg => 50,		# Right margin in PostScript points
	   topmarg => 100,	# Top margin in PostScript points
	   botmarg => 100,	# Bottom margin in PostScript points
	   plmarg => 50,	# Page number position relative to left margin
	   prmarg => 0,		# Page number position relative to right margin
	   pymarg => 50,	# Page number position relative to bot margin
	   bulladj => 12,	# How much to indent a bullet paragraph
	   tocind => 12,	# TOC indentation per level
	   tocpnz => 24,	# Width of TOC page number only zone
	   tocdots => 8,	# Spacing between TOC dots
	   idxspace => 24,	# Minimum space between index title and pg#
	   idxindent => 32,	# How much to indent a subindex entry
	   idxgutter => 24,	# Space between index columns
	   );

# US-Letter paper
# $psconf{pagewidth} = 612; $psconf{pageheight} = 792;
# A4 paper
# $psconf{pagewidth} = 595; $psconf{pageheight} = 842;

$paraskip = 6;			# Space between paragraphs
$chapstart = 30;		# Space before a chapter heading
$chapskip = 24;			# Space after a chapter heading
$tocskip = 6;			# Space between TOC entries

# Configure post-paragraph skips for each kind of paragraph
%skiparray = ('chap' => $chapskip, 'appn' => $chapstart,
	      'head' => $paraskip, 'subh' => $paraskip,
	      'norm' => $paraskip, 'bull' => $paraskip,
	      'code' => $paraskip, 'toc0' => $tocskip,
	      'toc1' => $tocskip,  'toc2' => $tocskip);

#
# First, format the stuff coming from the front end into
# a cleaner representation
#
open(PARAS, '< nasmdoc.dip');
while ( defined($line = <PARAS>) ) {
    chomp $line;
    $data = <PARAS>;
    chomp $data;
    if ( $line =~ /^meta :/ ) {
	$metakey = $';
	$metadata{$metakey} = $data;
    } elsif ( $line =~ /^indx :/ ) {
	$ixentry = $';
	push(@ixentries, $ixentry);
	$ixterms{$ixentry} = [split(/\037/, $data)];
	# Look for commas.  This is easier done on the string
	# representation, so do it now.
	if ( $line =~ /^(.*\,)\037sp\037/ ) {
	    $ixprefix = $1;
	    $ixhasprefix{$ixentry} = $ixprefix;
	    if ( !$ixprefixes{$ixprefix} ) {
		$ixcommafirst{$ixentry}++;
	    }
	    $ixprefixes{$ixprefix}++;
	}
    } else {
	push(@ptypes, $line);
	push(@paras, [split(/\037/, $data)]);
    }
}
close(PARAS);

#
# Convert an integer to a chosen base
#
sub int2base($$) {
    my($i,$b) = @_;
    my($s) = '';
    my($n) = '';
    my($z) = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return '0' if ($i == 0);
    if ( $i < 0 ) { $n = '-'; $i = -$i; }
    while ( $i ) {
	$s = substr($z,$i%$b,1) . $s;
	$i = int($i/$b);
    }
    return $n.$s;
}    

#
# Take a crossreference name and generate the PostScript name for it.
#
sub ps_xref($) {
    my($s) = @_;
    return $s;			# Identity transform should be OK for now
}

#
# Flow lines according to a particular font set and width
#
# A "font set" is represented as an array containing
# arrays of pairs: [<size>, <metricref>]
#
# Each line is represented as:
# [ [type,first|last,aux,fontset,page,ypos], [rendering array] ]
#
# A space character may be "squeezed" by up to this much
# (as a fraction of the normal width of a space.)
#
$ps_space_squeeze = 0.00;	# Min space width 100%
sub ps_flow_lines($$$@) {
    my($wid, $fontset, $type, @data) = @_;
    my($fonts) = $$fontset{fonts};
    my($e);
    my($w)  = 0;		# Width of current line
    my($sw) = 0;		# Width of current line due to spaces
    my(@l)  = ();		# Current line
    my(@ls) = ();		# Accumulated output lines
    my(@xd) = ();		# Metadata that goes with subsequent text

    $w = 0;
    foreach $e ( @data ) {
	if ( $$e[0] < 0 ) {
	    # Type is metadata.  Zero width.
	    if ( $$e[0] < -1 ) {
		# -1 (end anchor) goes with the preceeding text, otherwise
		# with the subsequent text
		push(@xd, $e);
	    } else {
		push(@l, $e);
	    }
	} else {
	    my $ew = ps_width($$e[1], $fontset->{fonts}->[$$e[0]][1]) *
		($fontset->{fonts}->[$$e[0]][0]/1000);
	    my $sp = $$e[1];
	    $sp =~ tr/[^ ]//d;	# Delete nonspaces
	    my $esw = ps_width($sp, $fontset->{fonts}->[$$e[0]][1]) *
		($fontset->{fonts}->[$$e[0]][0]/1000);
	    
	    if ( ($w+$ew) - $ps_space_squeeze*($sw+$esw) > $wid ) {
		# Begin new line
		# Search backwards for previous space chunk
		my $lx = scalar(@l)-1;
		my @rm = ();
		while ( $lx >= 0 ) {
		    while ( $lx >= 0 && $l[$lx]->[0] < 0 ) { $lx-- }; # Skip metadata
		    if ( $lx >= 0 ) {
			if ( $l[$lx]->[1] eq ' ' ) {
			    splice(@l, $lx, 1);
			    @rm = splice(@l, $lx);
			    last; # Found place to break
			} else {
			    $lx--;
			}
		    }
		}

		# Now @l contains the stuff to remain on the old line
		# If we broke the line inside a link of type -2 or -3,
		# then split the link into two.
		my $lkref = undef;
		foreach my $lc ( @l ) {
		    if ( $$lc[0] == -2 || $$lc[0] == -3 ) {
			$lkref = $lc;
		    } elsif ( $$lc[0] == -1 ) {
			undef $lkref;
		    }
		}
		push(@l, [-1,undef]) if ( defined($lkref) );
		push(@ls, [[$type,0,undef,$fontset,0,0],[@l]]);
		@l = @rm;
		unshift(@l, $lkref) if ( defined($lkref) );
		$w = $sw = 0;
		# Compute the width of the remainder array
		for my $le ( @l ) {
		    if ( $$le[0] >= 0 ) {
			my $xew = ps_width($$le[1], $fontset->{fonts}->[$$le[0]][1]) *
			    ($fontset->{fonts}->[$$le[0]][0]/1000);
			my $xsp = $$le[1];
			$xsp =~ tr/[^ ]//d;	# Delete nonspaces
			my $xsw = ps_width($xsp, $fontset->{fonts}->[$$le[0]][1]) *
			    ($fontset->{fonts}->[$$le[0]][0]/1000);
			$w += $xew;  $sw += $xsw;
		    }
		}
	    }
	    push(@l, @xd);	# Accumulated metadata
	    @xd = ();
	    if ( $$e[1] ne '' ) {
		push(@l, $e);
		$w += $ew; $sw += $esw;
	    }
	}
    }
    push(@l,@wd);
    if ( scalar(@l) ) {
	push(@ls, [[$type,0,undef,$fontset,0,0],[@l]]);	# Final line
    }

    # Mark the first line as first and the last line as last
    if ( scalar(@ls) ) {
	$ls[0]->[0]->[1] |= 1;	   # First in para
	$ls[-1]->[0]->[1] |= 2;    # Last in para
    }
    return @ls;
}

#
# Once we have broken things into lines, having multiple chunks
# with the same font index is no longer meaningful.  Merge
# adjacent chunks to keep down the size of the whole file.
#
sub ps_merge_chunks(@) {
    my(@ci) = @_;
    my($c, $lc);
    my(@co, $eco);
    
    undef $lc;
    @co = ();
    $eco = -1;			# Index of the last entry in @co
    foreach $c ( @ci ) {
	if ( defined($lc) && $$c[0] == $lc && $$c[0] >= 0 ) {
	    $co[$eco]->[1] .= $$c[1];
	} else {
	    push(@co, $c);  $eco++;
	    $lc = $$c[0];
	}
    }
    return @co;
}

#
# Convert paragraphs to rendering arrays.  Each
# element in the array contains (font, string),
# where font can be one of:
# -1 end link
# -2 begin crossref
# -3 begin weblink
# -4 index item anchor
# -5 crossref anchor
#  0 normal
#  1 empatic (italic)
#  2 code (fixed spacing)
#

sub mkparaarray($@) {
    my($ptype, @chunks) = @_;

    my @para = ();
    my $in_e = 0;
    my $chunk;

    if ( $ptype =~ /^code/ ) {
	foreach $chunk ( @{$paras[$i]} ) {
	    push(@para, [2, $chunk]);
	}
    } else {
	foreach $chunk ( @{$paras[$i]} ) {
	    my $type = substr($chunk,0,2);
	    my $text = substr($chunk,2);
	    
	    if ( $type eq 'sp' ) {
		push(@para, [$in_e?1:0, ' ']);
	    } elsif ( $type eq 'da' ) {
		# \261 is en dash in Adobe StandardEncoding
		push(@para, [$in_e?1:0, "\261"]);
	    } elsif ( $type eq 'n ' ) {
		push(@para, [0, $text]);
		$in_e = 0;
	    } elsif ( $type =~ '^e' ) {
		push(@para, [1, $text]);
		$in_e = ($type eq 'es' || $type eq 'e ');
	    } elsif ( $type eq 'c ' ) {
		push(@para, [2, $text]);
		$in_e = 0;
	    } elsif ( $type eq 'x ' ) {
		push(@para, [-2, ps_xref($text)]);
	    } elsif ( $type eq 'xe' ) {
		push(@para, [-1, undef]);
	    } elsif ( $type eq 'wc' || $type eq 'w ' ) {
		$text =~ /\<(.*)\>(.*)$/;
		my $link = $1; $text = $2;
		push(@para, [-3, $link]);
		push(@para, [($type eq 'wc') ? 2:0, $text]);
		push(@para, [-1, undef]);
		$in_e = 0;
	    } elsif ( $type eq 'i ' ) {
		push(@para, [-4, $text]);
	    } else {
		die "Unexpected paragraph chunk: $chunk";
	    }
	}
    }
    return @para;
}

$npara = scalar(@paras);
for ( $i = 0 ; $i < $npara ; $i++ ) {
    $paras[$i] = [mkparaarray($ptypes[$i], @{$paras[$i]})];
}

#
# This converts a rendering array to a simple string
#
sub ps_arraytostr(@) {
    my $s = '';
    my $c;
    foreach $c ( @_ ) {
	$s .= $$c[1] if ( $$c[0] >= 0 );
    }
    return $s;
}

#
# This generates a duplicate of a paragraph
#
sub ps_dup_para(@) {
    my(@i) = @_;
    my(@o) = ();
    my($c);

    foreach $c ( @i ) {
	my @cc = @{$c};
	push(@o, [@cc]);
    }
    return @o;
}

#
# Scan for header paragraphs and fix up their contents;
# also generate table of contents and PDF bookmarks.
#
@tocparas = ([[-5, 'contents'], [0,'Contents']]);
@tocptypes = ('chap');
@bookmarks = (['title', 0, 'Title Page'], ['contents', 0, 'Contents']);
%bookref = ();
for ( $i = 0 ; $i < $npara ; $i++ ) {
    my $xtype = $ptypes[$i];
    my $ptype = substr($xtype,0,4);
    my $str;
    my $book;

    if ( $ptype eq 'chap' || $ptype eq 'appn' ) {
	unless ( $xtype =~ /^\S+ (\S+) :(.*)$/ ) {
	    die "Bad para";
	}
	my $secn = $1;
	my $sech = $2;
	my $xref = ps_xref($sech);
	my $chap = ($ptype eq 'chap')?'Chapter':'Appendix';

	$book = [$xref, 0, ps_arraytostr(@{$paras[$i]})];
	push(@bookmarks, $book);
	$bookref{$secn} = $book;

	push(@tocparas, [ps_dup_para(@{$paras[$i]})]);
	push(@tocptypes, 'toc0'.' :'.$sech.':'.$chap.' '.$secn.':');

	unshift(@{$paras[$i]},
 		[-5, $xref], [0,$chap.' '.$secn.':'], [0, ' ']);
    } elsif ( $ptype eq 'head' || $ptype eq 'subh' ) {
	unless ( $xtype =~ /^\S+ (\S+) :(.*)$/ ) {
	    die "Bad para";
	}
	my $secn = $1;
	my $sech = $2;
	my $xref = ps_xref($sech);
	my $pref;
	$pref = $secn; $pref =~ s/\.[^\.]+$//; # Find parent node

	$book = [$xref, 0, ps_arraytostr(@{$paras[$i]})];
	push(@bookmarks, $book);
	$bookref{$secn} = $book;
	$bookref{$pref}->[1]--;	# Adjust count for parent node

	push(@tocparas, [ps_dup_para(@{$paras[$i]})]);
	push(@tocptypes,
	     (($ptype eq 'subh') ? 'toc2':'toc1').' :'.$sech.':'.$secn);

	unshift(@{$paras[$i]}, [-5, $xref]);
    }
}

#
# Add TOC to beginning of paragraph list
#
unshift(@paras,  @tocparas);
unshift(@ptypes, @tocptypes);
$npara = scalar(@paras);

#
# Line Auxilliary Information Types
#
$AuxStr	    = 1;		# String
$AuxPage    = 2;		# Page number (from xref)
$AuxPageStr = 3;		# Page number as a PostScript string
$AuxXRef    = 4;		# Cross reference as a name
$AuxNum     = 5;		# Number

#
# Break or convert paragraphs into lines.
#
@pslines    = ();
@pslinedata = ();
$linewidth  = $psconf{pagewidth}-$psconf{lmarg}-$psconf{rmarg};
$bullwidth  = $linewidth-$psconf{bulladj};

for ( $i = 0 ; $i < $npara ; $i++ ) {
    my $xtype = $ptypes[$i];
    my $ptype = substr($xtype,0,4);
    my @data = @{$paras[$i]};
    my @ls = ();
    if ( $ptype eq 'code' ) {
	my $p;
	# Code paragraph; each chunk is a line
	foreach $p ( @data ) {
	    push(@ls, [[$ptype,0,undef,\%TextFont,0,0],[$p]]);
	}
	$ls[0]->[0]->[1] |= 1;	     # First in para
	$ls[-1]->[0]->[1] |= 2;      # Last in para
    } elsif ( $ptype eq 'chap' || $ptype eq 'appn' ) {
	# Chapters are flowed normally, but in an unusual font
	@ls = ps_flow_lines($linewidth, \%ChapFont, $ptype, @data);
    } elsif ( $ptype eq 'head' || $ptype eq 'subh' ) {
	unless ( $xtype =~ /^\S+ (\S+) :(.*)$/ ) {
	    die "Bad para";
	}
	my $secn = $1;
	my $sech = $2;
	my $font = ($ptype eq 'head') ? \%HeadFont : \%SubhFont;
	@ls = ps_flow_lines($linewidth, $font, $ptype, @data);
	# We need the heading number as auxillary data
	$ls[0]->[0]->[2] = [[$AuxStr,$secn]];
    } elsif ( $ptype eq 'norm' ) {
	@ls = ps_flow_lines($linewidth, \%TextFont, $ptype, @data);
    } elsif ( $ptype eq 'bull' ) {
	@ls = ps_flow_lines($bullwidth, \%TextFont, $ptype, @data);
    } elsif ( $ptype =~ /^toc/ ) {
	unless ( $xtype =~/^\S+ :([^:]*):(.*)$/ ) {
	    die "Bad para";
	}
	my $xref = $1;
	my $refname = $2.' ';
	my $ntoc = substr($ptype,3,1)+0;
	my $refwidth = ps_width($refname, $TextFont{fonts}->[0][1]) *
	    ($TextFont{fonts}->[0][0]/1000);
	
	@ls = ps_flow_lines($linewidth-$ntoc*$psconf{tocind}-
			    $psconf{tocpnz}-$refwidth,
			    \%TextFont, $ptype, @data);

	# Auxilliary data: for the first line, the cross reference symbol
	# and the reference name; for all lines but the first, the
	# reference width; and for the last line, the page number
	# as a string.
	my $nl = scalar(@ls);
	$ls[0]->[0]->[2] = [[$AuxStr,$refname], [$AuxXRef,$xref]];
	for ( $j = 1 ; $j < $nl ; $j++ ) {
	    $ls[$j]->[0]->[2] = [[$AuxNum,$refwidth]];
	}
	push(@{$ls[$nl-1]->[0]->[2]}, [$AuxPageStr,$xref]);
    } else {
	die "Unknown para type: $ptype";
    }
    # Merge adjacent identical chunks
    foreach $l ( @ls ) {
    	@{$$l[1]} = ps_merge_chunks(@{$$l[1]});
    }
    push(@pslines,@ls);
}

#
# Break lines in to pages
#

# Paragraph types which should never be broken
$nobreakregexp = "^(chap|appn|head|subh|toc.)\$";
# Paragraph types which are heading (meaning they should not be broken
# immediately after)
$headingregexp = "^(chap|appn|head|subh)\$";

$curpage = 3;			# First text page is page 3
$curypos = 0;			# Space used on this page
$nlines = scalar(@pslines);

$upageheight = $psconf{pageheight}-$psconf{topmarg}-$psconf{botmarg};

for ( $i = 0 ; $i < $nlines ; $i++ ) {
    my $linfo = $pslines[$i]->[0];
    if ( ($$linfo[0] eq 'chap' || $$linfo[0] eq 'appn')
	 && ($$linfo[1] & 1) ) {
	# First line of a new chapter heading.  Start a new line.
	$curpage++ if ( $curypos > 0 );
	$curypos = $chapstart;
    }
    
    # Adjust position by the appropriate leading
    $curypos += $$linfo[3]->{leading};

    # Record the page and y-position
    $$linfo[4] = $curpage;
    $$linfo[5] = $curypos; 

    if ( $curypos > $upageheight ) {
	# We need to break the page before this line.
 	my $broken = 0;		# No place found yet
	while ( !$broken && $pslines[$i]->[0]->[4] == $curpage ) {
	    my $linfo = $pslines[$i]->[0];
	    my $pinfo = $pslines[$i-1]->[0];

	    if ( $$linfo[1] == 2 ) {
		# This would be an orphan, don't break.
	    } elsif ( $$linfo[1] & 1 ) {
		# Sole line or start of paragraph.  Break unless
		# the previous line was part of a heading.
		$broken = 1 if ( $$pinfo[0] !~ /$headingregexp/o );
	    } else {
		# Middle of paragraph.  Break unless we're in a
		# no-break paragraph, or the previous line would
		# end up being a widow.
		$broken = 1 if ( $$linfo[0] !~ /$nobreakregexp/o &&
				 $$pinfo[1] != 1 );
	    }
	    $i--;
	}
	die "Nowhere to break page $curpage\n" if ( !$broken );
	# Now $i should point to line immediately before the break, i.e.
	# the next paragraph should be the first on the new page
	$curpage++;
	$curypos = 0;
	next;
    }

    # Add end of paragraph skip
    if ( $$linfo[1] & 2 ) {
	$curypos += $skiparray{$$linfo[0]};
    }
}

#
# Find the page number of all the indices
#
%ps_xref_page   = ();		# Crossref anchor pages
%ps_index_pages = ();		# Index item pages
for ( $i = 0 ; $i < $nlines ; $i++ ) {
    my $linfo = $pslines[$i]->[0];
    foreach my $c ( @{$pslines[$i]->[1]} ) {
	if ( $$c[0] == -4 ) {
	    if ( !defined($ps_index_pages{$$c[1]}) ) {
		$ps_index_pages{$$c[1]} = [];
	    } elsif ( $ps_index_pages{$$c[1]}->[-1] eq $$linfo[4] ) {
		# Pages are emitted in order; if this is a duplicated
		# entry it will be the last one
		next;		# Duplicate
	    }
	    push(@{$ps_index_pages{$$c[1]}}, $$linfo[4]);
	} elsif ( $$c[0] == -5 ) {
	    $ps_xref_page{$$c[1]} = $$linfo[4];
	}
    }
}

# Get the list of fonts used
%ps_all_fonts = ();
foreach $fset ( @AllFonts ) {
    foreach $font ( @{$fset->{fonts}} ) {
	$ps_all_fonts{$font->[1]->{name}}++;
    }
}

# Emit the PostScript DSC header
print "%!PS-Adobe-3.0\n";
print "%%Pages: $curpage\n";
print "%%BoundingBox: 0 0 ", $psconf{pagewidth}, ' ', $psconf{pageheight}, "\n";
print "%%Creator: NASM psflow.pl\n";
print "%%DocumentData: Clean7Bit\n";
print "%%DocumentFonts: ", join(' ', keys(%ps_all_fonts)), "\n";
print "%%DocumentNeededFonts: ", join(' ', keys(%ps_all_fonts)), "\n";
print "%%Orientation: Portrait\n";
print "%%PageOrder: Ascend\n";
print "%%EndComments\n";
print "%%BeginProlog\n";

# Emit the configurables as PostScript tokens
for $c ( keys(%psconf) ) {
    print "/$c ", $psconf{$c}, " def\n";
}

# Emit fontset definitions
foreach $fset ( @AllFonts ) {
    my $i = 0;
    my @zfonts = ();
    foreach $font ( @{$fset->{fonts}} ) {
	print '/', $fset->{name}, $i, ' ',
	'/', $font->[1]->{name}, ' findfont ',
	$font->[0], " scalefont def\n";
	push(@zfonts, $fset->{name}.$i);
	$i++;
    }
    print '/', $fset->{name}, ' [', join(' ',@zfonts), "] def\n";
}

# Emit the result as PostScript.  This is *NOT* correct code yet!
open(PSHEAD, "< head.ps");
while ( defined($line = <PSHEAD>) ) {
    print $line;
}
close(PSHEAD);
print "%%EndProlog\n";

# Generate a PostScript string
sub ps_string($) {
    my ($s) = @_;
    my ($i,$c);
    my ($o) = '(';
    my ($l) = length($s);
    for ( $i = 0 ; $i < $l ; $i++ ) {
	$c = substr($s,$i,1);
	if ( ord($c) < 32 || ord($c) > 126 ) {
	    $o .= sprintf("\\%03o", ord($c));
	} elsif ( $c eq '(' || $c eq ')' || $c eq "\\" ) {
	    $o .= "\\".$c;
	} else {
	    $o .= $c;
	}
    }
    return $o.')';
}

# Generate PDF bookmarks
print "%%BeginSetup\n";
foreach $b ( @bookmarks ) {
    print '[/Title ', ps_string($b->[2]), "\n";
    print '/Count ', $b->[1], ' ' if ( $b->[1] );
    print '/Dest /',$b->[0]," /OUT pdfmark\n";
}

# Ask the PostScript interpreter for the proper size media
print "setpagesize\n";
print "%%EndSetup\n";

# Start a PostScript page
sub ps_start_page() {
    $ps_page++;
    print "%%Page: $ps_page $ps_page\n";
    print "%%BeginPageSetup\n";
    print "save\n";
    print "%%EndPageSetup\n";
}

# End a PostScript page
sub ps_end_page($) {
    my($pn) = @_;
    if ( $pn ) {
	print "($ps_page)", (($ps_page & 1) ? 'pageodd' : 'pageeven'), "\n";
    }
    print "restore showpage\n";
}

$ps_page = 0;

# Title page and inner cover
ps_start_page();
# FIX THIS: This shouldn't be hard-coded like this
$title = $metadata{'title'};
$title =~ s/ \- / \320 /;	# \320 = em dash
$pstitle = ps_string($title);
print <<EOF;
lmarg pageheight 2 mul 3 div moveto
/Helvetica-Bold findfont 20 scalefont setfont
/title linkdest ${pstitle} show
lmarg pageheight 2 mul 3 div 10 sub moveto
0 setlinecap 3 setlinewidth
pagewidth lmarg sub rmarg sub 0 rlineto stroke
/nasmlogo {
gsave 1 dict begin
/sz exch def
/Courier-Bold findfont sz scalefont setfont
moveto
0.85 1.22 scale
[(-~~..~:\#;L       .-:\#;L,.-   .~:\#:;.T  -~~.~:;. .~:;. )
( E8+U    *T     +U\'   *T\#  .97     *L   E8+\'  *;T\'  *;, )
( D97     \`*L  .97     \'*L   \"T;E+:,     D9     *L    *L )
( H7       I\#  T7       I\#        \"*:.   H7     I\#    I\# )
( U:       :8  *\#+    , :8  T,      79   U:     :8    :8 )
(,\#B.     .IE,  \"T;E*  .IE, J *+;\#:T*\"  ,\#B.   .IE,  .IE,)] {
currentpoint 3 -1 roll
sz -0.10 mul 0 3 -1 roll ashow
sz 0.72 mul sub moveto
} forall
end grestore
} def
0.6 setgray
pagewidth 2 div 143 sub
pageheight 2 div 33 add
12 nasmlogo
EOF
ps_end_page(0);
ps_start_page();
print "% Inner cover goes here\n";
ps_end_page(0);

$curpage = 3;
ps_start_page();
for ( $i = 0 ; $i < $nlines ; $i++ ) {
    my $linfo = $pslines[$i]->[0];

    if ( $$linfo[4] != $curpage ) {
	ps_end_page(1);
	ps_start_page();
	$curpage = $$linfo[4];
    }

    print '[';
    my $curfont = 0;
    foreach my $c ( @{$pslines[$i]->[1]} ) {
	if ( $$c[0] >= 0 ) {
	    if ( $curfont != $$c[0] ) {
		print ($curfont = $$c[0]);
	    }
	    print ps_string($$c[1]);
	} elsif ( $$c[0] == -1 ) {
	    print '{el}';	# End link
	} elsif ( $$c[0] == -2 ) {
	    print '{/',$$c[1],' xl}'; # xref link
	} elsif ( $$c[0] == -3 ) {
	    print '{',ps_string($$c[1]),'wl}'; # web link
	} elsif ( $$c[0] == -4 ) {
	    # Index anchor -- ignore
	} elsif ( $$c[0] == -5 ) {
	    print '{/',$$c[1],' xa}'; #xref anchor
	} else {
	    die "Unknown annotation";
	}
    }
    print ']';
    if ( defined($$linfo[2]) ) {
	foreach my $x ( @{$$linfo[2]} ) {
	    if ( $$x[0] == $AuxStr ) {
		print ps_string($$x[1]);
	    } elsif ( $$x[0] == $AuxPage ) {
		print $ps_xref_page{$$x[1]},' ';
	    } elsif ( $$x[0] == $AuxPageStr ) {
		print ps_string($ps_xref_page{$$x[1]});
	    } elsif ( $$x[0] == $AuxXRef ) {
		print '/',ps_xref($$x[1]),' ';
	    } elsif ( $$x[0] == $AuxNum ) {
		print $$x[1],' ';
	    } else {
		die "Unknown auxilliary data type";
	    }
	}
    }
    print ($psconf{pageheight}-$psconf{topmarg}-$$linfo[5]);
    print ' ', $$linfo[0].$$linfo[1], "\n";
}

ps_end_page(1);
print "%%EOF\n";

# Emit index as comments for now
foreach $k ( sort(keys(%ps_index_pages)) ) {
    print "% ",$k, ' ', join(',', @{$ps_index_pages{$k}});
    print ' [prefix]' if ( defined($ixhasprefix{$k}) );
    print ' [first]' if ( defined($ixcommafirst{$k}) );
    print "\n";
}
