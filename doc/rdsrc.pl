#!/usr/bin/perl

# Read the source-form of the NASM manual and generate the various
# output forms.

# TODO:
#
# PS output:
# - show page numbers in printed output
# - think about double-sided support (start all chapters on RHS,
#   ie odd-numbered, pages).
#
# Ellipsis support would be nice.

# Source-form features:
# ---------------------
# 
# Bullet \b
#   Bullets the paragraph. Rest of paragraph is indented to cope. In
#   HTML, consecutive groups of bulleted paragraphs become unordered
#   lists.
# 
# Emphasis \e{foobar}
#   produces `_foobar_' in text and italics in HTML, PS, RTF
# 
# Inline code \c{foobar}
#   produces ``foobar'' in text, and fixed-pitch font in HTML, PS, RTF
# 
# Display code
# \c  line one
# \c   line two
#   produces fixed-pitch font where appropriate, and doesn't break
#   pages except sufficiently far into the middle of a display.
# 
# Chapter, header and subheader
# \C{intro} Introduction
# \H{whatsnasm} What is NASM?
# \S{free} NASM Is Free
#   dealt with as appropriate. Chapters begin on new sides, possibly
#   even new _pages_. (Sub)?headers are good places to begin new
#   pages. Just _after_ a (sub)?header isn't.
#   The keywords can be substituted with \K and \k.
#
# Keyword \K{cintro} \k{cintro}
#   Expands to `Chapter 1', `Section 1.1', `Section 1.1.1'. \K has an
#   initial capital whereas \k doesn't. In HTML, will produce
#   hyperlinks.
# 
# Web link \W{http://foobar/}{text} or \W{mailto:me@here}\c{me@here}
#   the \W prefix is ignored except in HTML; in HTML the last part
#   becomes a hyperlink to the first part.
# 
# Literals \{ \} \\
#   In case it's necessary, they expand to the real versions.
# 
# Nonbreaking hyphen \-
#   Need more be said?
# 
# Source comment \#
#   Causes everything after it on the line to be ignored by the
#   source-form processor.
#
# Indexable word \i{foobar} (or \i\e{foobar} or \i\c{foobar}, equally)
#   makes word appear in index, referenced to that point
#   \i\c comes up in code style even in the index; \i\e doesn't come
#   up in emphasised style.
#
# Indexable non-displayed word \I{foobar} or \I\c{foobar}
#   just as \i{foobar} except that nothing is displayed for it
#
# Index rewrite
# \IR{foobar} \c{foobar} operator, uses of
#   tidies up the appearance in the index of something the \i or \I
#   operator was applied to
#
# Index alias
# \IA{foobar}{bazquux}
#   aliases one index tag (as might be supplied to \i or \I) to
#   another, so that \I{foobar} has the effect of \I{bazquux}, and
#   \i{foobar} has the effect of \I{bazquux}foobar

$diag = 1, shift @ARGV if $ARGV[0] eq "-d";

$| = 1;

$tstruct_previtem = $node = "Top";
$nodes = ($node);
$tstruct_level{$tstruct_previtem} = 0;
$tstruct_last[$tstruct_level{$tstruct_previtem}] = $tstruct_previtem;
$MAXLEVEL = 10;  # really 3, but play safe ;-)

# Read the file; pass a paragraph at a time to the paragraph processor.
print "Reading input...";
$pname = "para000000";
@pnames = @pflags = ();
$para = undef;
while (<>) {
  chomp;
  if (!/\S/ || /^\\I[AR]/) { # special case: \I[AR] implies new-paragraph
    &got_para($para);
    $para = undef;
  }
  if (/\S/) {
    s/\\#.*$//; # strip comments
    $para .= " " . $_;
  }
}
&got_para($para);
print "done.\n";

# Now we've read in the entire document and we know what all the
# heading keywords refer to. Go through and fix up the \k references.
print "Fixing up cross-references...";
&fixup_xrefs;
print "done.\n";

# Sort the index tags, according to the slightly odd order I've decided on.
print "Sorting index tags...";
&indexsort;
print "done.\n";

if ($diag) {
  print "Writing index-diagnostic file...";
  &indexdiag;
  print "done.\n";
}

# OK. Write out the various output files.
print "Producing text output: ";
&write_txt;
print "done.\n";
print "Producing HTML output: ";
&write_html;
print "done.\n";
print "Producing PostScript output: ";
&write_ps;
print "done.\n";
print "Producing Texinfo output: ";
&write_texi;
print "done.\n";
print "Producing WinHelp output: ";
&write_hlp;
print "done.\n";

sub got_para {
  local ($_) = @_;
  my $pflags = "", $i, $w, $l, $t;
  return if !/\S/;

  @$pname = ();

  # Strip off _leading_ spaces, then determine type of paragraph.
  s/^\s*//;
  $irewrite = undef;
  if (/^\\c[^{]/) {
    # A code paragraph. The paragraph-array will contain the simple
    # strings which form each line of the paragraph.
    $pflags = "code";
    while (/^\\c (([^\\]|\\[^c])*)(.*)$/) {
      $l = $1;
      $_ = $3;
      $l =~ s/\\{/{/g;
      $l =~ s/\\}/}/g;
      $l =~ s/\\\\/\\/g;
      push @$pname, $l;
    }
    $_ = ''; # suppress word-by-word code
  } elsif (/^\\C/) {
    # A chapter heading. Define the keyword and allocate a chapter
    # number.
    $cnum++;
    $hnum = 0;
    $snum = 0;
    $xref = "chapter-$cnum";
    $pflags = "chap $cnum :$xref";
    die "badly formatted chapter heading: $_\n" if !/^\\C{([^}]*)}\s*(.*)$/;
    $refs{$1} = "chapter $cnum";
    $node = "Chapter $cnum";
    &add_item($node, 1);
    $xrefnodes{$node} = $xref; $nodexrefs{$xref} = $node;
    $xrefs{$1} = $xref;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\A/) {
    # An appendix heading. Define the keyword and allocate an appendix
    # letter.
    $cnum++;
    $cnum = 'A' if $cnum =~ /[0-9]+/;
    $hnum = 0;
    $snum = 0;
    $xref = "appendix-$cnum";
    $pflags = "appn $cnum :$xref";
    die "badly formatted appendix heading: $_\n" if !/^\\A{([^}]*)}\s*(.*)$/;
    $refs{$1} = "appendix $cnum";
    $node = "Appendix $cnum";
    &add_item($node, 1);
    $xrefnodes{$node} = $xref; $nodexrefs{$xref} = $node;
    $xrefs{$1} = $xref;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\H/) {
    # A major heading. Define the keyword and allocate a section number.
    $hnum++;
    $snum = 0;
    $xref = "section-$cnum.$hnum";
    $pflags = "head $cnum.$hnum :$xref";
    die "badly formatted heading: $_\n" if !/^\\[HP]{([^}]*)}\s*(.*)$/;
    $refs{$1} = "section $cnum.$hnum";
    $node = "Section $cnum.$hnum";
    &add_item($node, 2);
    $xrefnodes{$node} = $xref; $nodexrefs{$xref} = $node;
    $xrefs{$1} = $xref;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\S/) {
    # A sub-heading. Define the keyword and allocate a section number.
    $snum++;
    $xref = "section-$cnum.$hnum.$snum";
    $pflags = "subh $cnum.$hnum.$snum :$xref";
    die "badly formatted subheading: $_\n" if !/^\\S{([^}]*)}\s*(.*)$/;
    $refs{$1} = "section $cnum.$hnum.$snum";
    $node = "Section $cnum.$hnum.$snum";
    &add_item($node, 3);
    $xrefnodes{$node} = $xref; $nodexrefs{$xref} = $node;
    $xrefs{$1} = $xref;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\IR/) {
    # An index-rewrite.
    die "badly formatted index rewrite: $_\n" if !/^\\IR{([^}]*)}\s*(.*)$/;
    $irewrite = $1;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\IA/) {
    # An index-alias.
    die "badly formatted index alias: $_\n" if !/^\\IA{([^}]*)}{([^}]*)}\s*$/;
    $idxalias{$1} = $2;
    return; # avoid word-by-word code
  } elsif (/^\\b/) {
    # A bulleted paragraph. Strip off the initial \b and let the
    # word-by-word code take care of the rest.
    $pflags = "bull";
    s/^\\b\s*//;
  } else {
    # A normal paragraph. Just set $pflags: the word-by-word code does
    # the rest.
    $pflags = "norm";
  }

  # The word-by-word code: unless @$pname is already defined (which it
  # will be in the case of a code paragraph), split the paragraph up
  # into words and push each on @$pname.
  #
  # Each thing pushed on @$pname should have a two-character type
  # code followed by the text.
  #
  # Type codes are:
  # "n " for normal
  # "da" for a dash
  # "es" for first emphasised word in emphasised bit
  # "e " for emphasised in mid-emphasised-bit
  # "ee" for last emphasised word in emphasised bit
  # "eo" for single (only) emphasised word
  # "c " for code
  # "k " for cross-ref
  # "kK" for capitalised cross-ref
  # "w " for Web link
  # "wc" for code-type Web link
  # "x " for beginning of resolved cross-ref; generates no visible output,
  #      and the text is the cross-reference code
  # "xe" for end of resolved cross-ref; text is same as for "x ".
  # "i " for point to be indexed: the text is the internal index into the
  #      index-items arrays
  # "sp" for space
  while (/\S/) {
    s/^\s*//, push @$pname, "sp" if /^\s/;
    $indexing = $qindex = 0;
    if (/^(\\[iI])?\\c/) {
      $qindex = 1 if $1 eq "\\I";
      $indexing = 1, s/^\\[iI]// if $1;
      s/^\\c//;
      die "badly formatted \\c: \\c$_\n" if !/{(([^\\}]|\\.)*)}(.*)$/;
      $w = $1;
      $_ = $3;
      $w =~ s/\\{/{/g;
      $w =~ s/\\}/}/g;
      $w =~ s/\\-/-/g;
      $w =~ s/\\\\/\\/g;
      (push @$pname,"i"),$lastp = $#$pname if $indexing;
      push @$pname,"c $w" if !$qindex;
      $$pname[$lastp] = &addidx($node, $w, "c $w") if $indexing;
    } elsif (/^\\[iIe]/) {
      /^(\\[iI])?(\\e)?/;
      $emph = 0;
      $qindex = 1 if $1 eq "\\I";
      $indexing = 1, $type = "\\i" if $1;
      $emph = 1, $type = "\\e" if $2;
      s/^(\\[iI])?(\\e?)//;
      die "badly formatted $type: $type$_\n" if !/{(([^\\}]|\\.)*)}(.*)$/;
      $w = $1;
      $_ = $3;
      $w =~ s/\\{/{/g;
      $w =~ s/\\}/}/g;
      $w =~ s/\\-/-/g;
      $w =~ s/\\\\/\\/g;
      $t = $emph ? "es" : "n ";
      @ientry = ();
      (push @$pname,"i"),$lastp = $#$pname if $indexing;
      foreach $i (split /\s+/,$w) {  # \e and \i can be multiple words
        push @$pname,"$t$i","sp" if !$qindex;
	($ii=$i) =~ tr/A-Z/a-z/, push @ientry,"n $ii","sp" if $indexing;
	$t = $emph ? "e " : "n ";
      }
      $w =~ tr/A-Z/a-z/, pop @ientry if $indexing;
      $$pname[$lastp] = &addidx($node, $w, @ientry) if $indexing;
      pop @$pname if !$qindex; # remove final space
      if (substr($$pname[$#$pname],0,2) eq "es" && !$qindex) {
        substr($$pname[$#$pname],0,2) = "eo";
      } elsif ($emph && !$qindex) {
        substr($$pname[$#$pname],0,2) = "ee";
      }
    } elsif (/^\\[kK]/) {
      $t = "k ";
      $t = "kK" if /^\\K/;
      s/^\\[kK]//;
      die "badly formatted \\k: \\c$_\n" if !/{([^}]*)}(.*)$/;
      $_ = $2;
      push @$pname,"$t$1";
    } elsif (/^\\W/) {
      s/^\\W//;
      die "badly formatted \\W: \\W$_\n"
          if !/{([^}]*)}(\\i)?(\\c)?{(([^\\}]|\\.)*)}(.*)$/;
      $l = $1;
      $w = $4;
      $_ = $6;
      $t = "w ";
      $t = "wc" if $3 eq "\\c";
      $indexing = 1 if $2;
      $w =~ s/\\{/{/g;
      $w =~ s/\\}/}/g;
      $w =~ s/\\-/-/g;
      $w =~ s/\\\\/\\/g;
      (push @$pname,"i"),$lastp = $#$pname if $indexing;
      push @$pname,"$t<$l>$w";
      $$pname[$lastp] = &addidx($node, $w, "c $w") if $indexing;
    } else {
      die "what the hell? $_\n" if !/^(([^\s\\\-]|\\[\\{}\-])*-?)(.*)$/;
      die "painful death! $_\n" if !length $1;
      $w = $1;
      $_ = $3;
      $w =~ s/\\{/{/g;
      $w =~ s/\\}/}/g;
      $w =~ s/\\-/-/g;
      $w =~ s/\\\\/\\/g;
      if ($w eq "-") {
        push @$pname,"da";
      } else {
        push @$pname,"n $w";
      }
    }
  }
  if ($irewrite ne undef) {
    &addidx(undef, $irewrite, @$pname);
    @$pname = ();
  } else {
    push @pnames, $pname;
    push @pflags, $pflags;
    $pname++;
  }
}

sub addidx {
  my ($node, $text, @ientry) = @_;
  $text = $idxalias{$text} || $text;
  if ($node eq undef || !$idxmap{$text}) {
    @$ientry = @ientry;
    $idxmap{$text} = $ientry;
    $ientry++;
  }
  if ($node) {
    $idxnodes{$node,$text} = 1;
    return "i $text";
  }
}

sub indexsort {
  my $iitem, $ientry, $i, $piitem, $pcval, $cval, $clrcval;

  @itags = map { # get back the original data as the 1st elt of each list
             $_->[0]
	   } sort { # compare auxiliary (non-first) elements of lists
	     $a->[1] cmp $b->[1] ||
	     $a->[2] cmp $b->[2] ||
	     $a->[0] cmp $b->[0]
           } map { # transform array into list of 3-element lists
	     my $ientry = $idxmap{$_};
	     my $a = substr($$ientry[0],2);
	     $a =~ tr/A-Za-z//cd;
	     [$_, uc($a), substr($$ientry[0],0,2)]
	   } keys %idxmap;

  # Having done that, check for comma-hood.
  $cval = 0;
  foreach $iitem (@itags) {
    $ientry = $idxmap{$iitem};
    $clrcval = 1;
    $pcval = $cval;
    FL:for ($i=0; $i <= $#$ientry; $i++) {
      if ($$ientry[$i] =~ /^(n .*,)(.*)/) {
        $$ientry[$i] = $1;
	splice @$ientry,$i+1,0,"n $2" if length $2;
	$commapos{$iitem} = $i+1;
	$cval = join("\002", @$ientry[0..$i]);
	$clrcval = 0;
	last FL;
      }
    }
    $cval = undef if $clrcval;
    $commanext{$iitem} = $commaafter{$piitem} = 1
      if $cval and ($cval eq $pcval);
    $piitem = $iitem;
  }
}

sub indexdiag {
  my $iitem,$ientry,$w,$ww,$foo,$node;
  open INDEXDIAG,">index.diag";
  foreach $iitem (@itags) {
    $ientry = $idxmap{$iitem};
    print INDEXDIAG "<$iitem> ";
    foreach $w (@$ientry) {
      $ww = &word_txt($w);
      print INDEXDIAG $ww unless $ww eq "\001";
    }
    print INDEXDIAG ":";
    $foo = " ";
    foreach $node (@nodes) {
      (print INDEXDIAG $foo,$node), $foo = ", " if $idxnodes{$node,$iitem};
    }
    print INDEXDIAG "\n";
  }
  close INDEXDIAG;
}

sub fixup_xrefs {
  my $pname, $p, $i, $j, $k, $caps, @repl;

  for ($p=0; $p<=$#pnames; $p++) {
    next if $pflags[$p] eq "code";
    $pname = $pnames[$p];
    for ($i=$#$pname; $i >= 0; $i--) {
      if ($$pname[$i] =~ /^k/) {
        $k = $$pname[$i];
        $caps = ($k =~ /^kK/);
	$k = substr($k,2);	
        $repl = $refs{$k};
	die "undefined keyword `$k'\n" unless $repl;
	substr($repl,0,1) =~ tr/a-z/A-Z/ if $caps;
	@repl = ();
	push @repl,"x $xrefs{$k}";
	foreach $j (split /\s+/,$repl) {
	  push @repl,"n $j";
	  push @repl,"sp";
	}
	pop @repl; # remove final space
	push @repl,"xe$xrefs{$k}";
	splice @$pname,$i,1,@repl;
      }
    }
  }
}

sub write_txt {
  # This is called from the top level, so I won't bother using
  # my or local.

  # Open file.
  print "writing file...";
  open TEXT,">nasmdoc.txt";
  select TEXT;

  # Preamble.
  $title = "The Netwide Assembler: NASM";
  $spaces = ' ' x ((75-(length $title))/2);
  ($underscore = $title) =~ s/./=/g;
  print "$spaces$title\n$spaces$underscore\n";

  for ($para = 0; $para <= $#pnames; $para++) {
    $pname = $pnames[$para];
    $pflags = $pflags[$para];
    $ptype = substr($pflags,0,4);

    print "\n"; # always one of these before a new paragraph

    if ($ptype eq "chap") {
      # Chapter heading. "Chapter N: Title" followed by a line of
      # minus signs.
      $pflags =~ /chap (.*) :(.*)/;
      $title = "Chapter $1: ";
      foreach $i (@$pname) {
        $ww = &word_txt($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "$title\n";
      $title =~ s/./-/g;
      print "$title\n";
    } elsif ($ptype eq "appn") {
      # Appendix heading. "Appendix N: Title" followed by a line of
      # minus signs.
      $pflags =~ /appn (.*) :(.*)/;
      $title = "Appendix $1: ";
      foreach $i (@$pname) {
        $ww = &word_txt($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "$title\n";
      $title =~ s/./-/g;
      print "$title\n";
    } elsif ($ptype eq "head" || $ptype eq "subh") {
      # Heading or subheading. Just a number and some text.
      $pflags =~ /.... (.*) :(.*)/;
      $title = sprintf "%6s ", $1;
      foreach $i (@$pname) {
        $ww = &word_txt($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "$title\n";
    } elsif ($ptype eq "code") {
      # Code paragraph. Emit each line with a seven character indent.
      foreach $i (@$pname) {
        warn "code line longer than 68 chars: $i\n" if length $i > 68;
        print ' 'x7, $i, "\n";
      }
    } elsif ($ptype eq "bull" || $ptype eq "norm") {
      # Ordinary paragraph, optionally bulleted. We wrap, with ragged
      # 75-char right margin and either 7 or 11 char left margin
      # depending on bullets.
      if ($ptype eq "bull") {
        $line = ' 'x7 . '(*) ';
	$next = ' 'x11;
      } else {
        $line = $next = ' 'x7;
      }
      @a = @$pname;
      $wd = $wprev = '';
      do {
        do { $w = &word_txt(shift @a) } while $w eq "\001"; # nasty hack
	$wd .= $wprev;
	if ($wprev =~ /-$/ || $w eq ' ' || $w eq '' || $w eq undef) {
	  if (length ($line . $wd) > 75) {
	    $line =~ s/\s*$//; # trim trailing spaces
	    print "$line\n";
	    $line = $next;
	    $wd =~ s/^\s*//; # trim leading spaces
	  }
	  $line .= $wd;
	  $wd = '';
	}
	$wprev = $w;
      } while ($w ne '' && $w ne undef);
      if ($line =~ /\S/) {
	$line =~ s/\s*$//; # trim trailing spaces
	print "$line\n";
      }
    }
  }

  # Close file.
  select STDOUT;
  close TEXT;
}

sub word_txt {
  my ($w) = @_;
  my $wtype, $wmajt;

  return undef if $w eq '' || $w eq undef;
  $wtype = substr($w,0,2);
  $wmajt = substr($wtype,0,1);
  $w = substr($w,2);
  $w =~ s/<.*>// if $wmajt eq "w"; # remove web links
  if ($wmajt eq "n" || $wtype eq "e " || $wtype eq "w ") {
    return $w;
  } elsif ($wtype eq "sp") {
    return ' ';
  } elsif ($wtype eq "da") {
    return '-';
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    return "`${w}'";
  } elsif ($wtype eq "es") {
    return "_${w}";
  } elsif ($wtype eq "ee") {
    return "${w}_";
  } elsif ($wtype eq "eo") {
    return "_${w}_";
  } elsif ($wmajt eq "x" || $wmajt eq "i") {
    return "\001";
  } else {
    die "panic in word_txt: $wtype$w\n";
  }
}

sub write_html {
  # This is called from the top level, so I won't bother using
  # my or local.

  # Write contents file. Just the preamble, then a menu of links to the
  # separate chapter files and the nodes therein.
  print "writing contents file...";
  open TEXT,">nasmdoc0.html";
  select TEXT;
  &html_preamble(0);
  print "<p>This manual documents NASM, the Netwide Assembler: an assembler\n";
  print "targetting the Intel x86 series of processors, with portable source.\n";
  print "<p>";
  for ($node = $tstruct_next{'Top'}; $node; $node = $tstruct_next{$node}) {
    if ($tstruct_level{$node} == 1) {
      # Invent a file name.
      ($number = lc($xrefnodes{$node})) =~ s/.*-//;
      $fname="nasmdocx.html";
      substr($fname,8 - length $number, length $number) = $number;
      $html_fnames{$node} = $fname;
      $link = $fname;
      print "<p>";
    } else {
      # Use the preceding filename plus a marker point.
      $link = $fname . "#$xrefnodes{$node}";
    }
    $title = "$node: ";
    $pname = $tstruct_pname{$node};
    foreach $i (@$pname) {
      $ww = &word_html($i);
      $title .= $ww unless $ww eq "\001";
    }
    print "<a href=\"$link\">$title</a><br>\n";
  }
  print "<p><a href=\"nasmdoci.html\">Index</a>\n";
  print "</body></html>\n";
  select STDOUT;
  close TEXT;

  # Open a null file, to ensure output (eg random &html_jumppoints calls)
  # goes _somewhere_.
  print "writing chapter files...";
  open TEXT,">/dev/null";
  select TEXT;
  $html_lastf = '';

  $in_list = 0;

  for ($para = 0; $para <= $#pnames; $para++) {
    $pname = $pnames[$para];
    $pflags = $pflags[$para];
    $ptype = substr($pflags,0,4);

    $in_list = 0, print "</ul>\n" if $in_list && $ptype ne "bull";
    if ($ptype eq "chap") {
      # Chapter heading. Begin a new file.
      $pflags =~ /chap (.*) :(.*)/;
      $title = "Chapter $1: ";
      $xref = $2;
      &html_jumppoints; print "</body></html>\n"; select STDOUT; close TEXT;
      $html_lastf = $html_fnames{$chapternode};
      $chapternode = $nodexrefs{$xref};
      $html_nextf = $html_fnames{$tstruct_mnext{$chapternode}};
      open TEXT,">$html_fnames{$chapternode}"; select TEXT; &html_preamble(1);
      foreach $i (@$pname) {
        $ww = &word_html($i);
        $title .= $ww unless $ww eq "\001";
      }
      $h = "<h2><a name=\"$xref\">$title</a></h2>\n";
      print $h; print FULL $h;
    } elsif ($ptype eq "appn") {
      # Appendix heading. Begin a new file.
      $pflags =~ /appn (.*) :(.*)/;
      $title = "Appendix $1: ";
      $xref = $2;
      &html_jumppoints; print "</body></html>\n"; select STDOUT; close TEXT;
      $html_lastf = $html_fnames{$chapternode};
      $chapternode = $nodexrefs{$xref};
      $html_nextf = $html_fnames{$tstruct_mnext{$chapternode}};
      open TEXT,">$html_fnames{$chapternode}"; select TEXT; &html_preamble(1);
      foreach $i (@$pname) {
        $ww = &word_html($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "<h2><a name=\"$xref\">$title</a></h2>\n";
    } elsif ($ptype eq "head" || $ptype eq "subh") {
      # Heading or subheading.
      $pflags =~ /.... (.*) :(.*)/;
      $hdr = ($ptype eq "subh" ? "h4" : "h3");
      $title = $1 . " ";
      $xref = $2;
      foreach $i (@$pname) {
        $ww = &word_html($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "<$hdr><a name=\"$xref\">$title</a></$hdr>\n";
    } elsif ($ptype eq "code") {
      # Code paragraph.
      print "<p><pre>\n";
      foreach $i (@$pname) {
	$w = $i;
	$w =~ s/&/&amp;/g;
	$w =~ s/</&lt;/g;
	$w =~ s/>/&gt;/g;
        print $w, "\n";
      }
      print "</pre>\n";
    } elsif ($ptype eq "bull" || $ptype eq "norm") {
      # Ordinary paragraph, optionally bulleted. We wrap, with ragged
      # 75-char right margin and either 7 or 11 char left margin
      # depending on bullets.
      if ($ptype eq "bull") {
        $in_list = 1, print "<ul>\n" unless $in_list;
        $line = '<li>';
      } else {
        $line = '<p>';
      }
      @a = @$pname;
      $wd = $wprev = '';
      do {
        do { $w = &word_html(shift @a) } while $w eq "\001"; # nasty hack
	$wd .= $wprev;
	if ($w eq ' ' || $w eq '' || $w eq undef) {
	  if (length ($line . $wd) > 75) {
	    $line =~ s/\s*$//; # trim trailing spaces
	    print "$line\n";
	    $line = '';
	    $wd =~ s/^\s*//; # trim leading spaces
	  }
	  $line .= $wd;
	  $wd = '';
	}
	$wprev = $w;
      } while ($w ne '' && $w ne undef);
      if ($line =~ /\S/) {
	$line =~ s/\s*$//; # trim trailing spaces
	print "$line\n";
      }
    }
  }

  # Close whichever file was open.
  &html_jumppoints;
  print "</body></html>\n";
  select STDOUT;
  close TEXT;

  print "\n   writing index file...";
  open TEXT,">nasmdoci.html";
  select TEXT;
  &html_preamble(0);
  print "<p align=center><a href=\"nasmdoc0.html\">Contents</a>\n";
  print "<p>";
  &html_index;
  print "<p align=center><a href=\"nasmdoc0.html\">Contents</a>\n";
  print "</body></html>\n";
  select STDOUT;
  close TEXT;
}

sub html_preamble {
  print "<html><head><title>NASM Manual</title></head>\n";
  print "<body><h1 align=center>The Netwide Assembler: NASM</h1>\n\n";
  &html_jumppoints if $_[0];
}

sub html_jumppoints {
  print "<p align=center>";
  print "<a href=\"$html_nextf\">Next Chapter</a> |\n" if $html_nextf;
  print "<a href=\"$html_lastf\">Previous Chapter</a> |\n" if $html_lastf;
  print "<a href=\"nasmdoc0.html\">Contents</a> |\n";
  print "<a href=\"nasmdoci.html\">Index</a>\n";
}

sub html_index {
  my $itag, $a, @ientry, $sep, $w, $wd, $wprev, $line;

  $chapternode = '';
  foreach $itag (@itags) {
    $ientry = $idxmap{$itag};
    @a = @$ientry;
    push @a, "n :";
    $sep = 0;
    foreach $node (@nodes) {
      next if !$idxnodes{$node,$itag};
      push @a, "n ," if $sep;
      push @a, "sp", "x $xrefnodes{$node}", "n $node", "xe$xrefnodes{$node}";
      $sep = 1;
    }
    $line = '';
    do {
      do { $w = &word_html(shift @a) } while $w eq "\001"; # nasty hack
      $wd .= $wprev;
      if ($w eq ' ' || $w eq '' || $w eq undef) {
        if (length ($line . $wd) > 75) {
	  $line =~ s/\s*$//; # trim trailing spaces
	  print "$line\n";
	  $line = '';
	  $wd =~ s/^\s*//; # trim leading spaces
	}
	$line .= $wd;
	$wd = '';
      }
      $wprev = $w;
    } while ($w ne '' && $w ne undef);
    if ($line =~ /\S/) {
      $line =~ s/\s*$//; # trim trailing spaces
      print "$line\n";
    }
    print "<br>\n";
  }
}

sub word_html {
  my ($w) = @_;
  my $wtype, $wmajt, $pfx, $sfx;

  return undef if $w eq '' || $w eq undef;

  $wtype = substr($w,0,2);
  $wmajt = substr($wtype,0,1);
  $w = substr($w,2);
  $pfx = $sfx = '';
  $pfx = "<a href=\"$1\">", $sfx = "</a>", $w = $2
    if $wmajt eq "w" && $w =~ /^<(.*)>(.*)$/;
  $w =~ s/&/&amp;/g;
  $w =~ s/</&lt;/g;
  $w =~ s/>/&gt;/g;
  if ($wmajt eq "n" || $wtype eq "e " || $wtype eq "w ") {
    return $pfx . $w . $sfx;
  } elsif ($wtype eq "sp") {
    return ' ';
  } elsif ($wtype eq "da") {
    return '-'; # sadly, en-dashes are non-standard in HTML
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    return $pfx . "<code><nobr>${w}</nobr></code>" . $sfx;
  } elsif ($wtype eq "es") {
    return "<em>${w}";
  } elsif ($wtype eq "ee") {
    return "${w}</em>";
  } elsif ($wtype eq "eo") {
    return "<em>${w}</em>";
  } elsif ($wtype eq "x ") {
    # Magic: we must resolve the cross reference into file and marker
    # parts, then dispose of the file part if it's us, and dispose of
    # the marker part if the cross reference describes the top node of
    # another file.
    my $node = $nodexrefs{$w}; # find the node we're aiming at
    my $level = $tstruct_level{$node}; # and its level
    my $up = $node, $uplev = $level-1;
    $up = $tstruct_up{$up} while $uplev--; # get top node of containing file
    my $file = ($up ne $chapternode) ? $html_fnames{$up} : "";
    my $marker = ($level == 1 and $file) ? "" : "#$w";
    return "<a href=\"$file$marker\">";
  } elsif ($wtype eq "xe") {
    return "</a>";
  } elsif ($wmajt eq "i") {
    return "\001";
  } else {
    die "panic in word_html: $wtype$w\n";
  }
}

sub write_ps {
  # This is called from the top level, so I won't bother using
  # my or local.

  # First, set up the font metric arrays.
  &font_metrics;

  # First stage: reprocess the source arrays into a list of
  # lines, each of which is a list of word-strings, each of
  # which has a single-letter font code followed by text.
  # Each line also has an associated type, which will be
  # used for final alignment and font selection and things.
  #
  # Font codes are:
  #   n == Normal
  #   e == Emphasised
  #   c == Code
  #  ' ' == space (no following text required)
  #  '-' == dash (no following text required)
  #
  # Line types are:
  #   chap == Chapter or appendix heading.
  #   head == Major heading.
  #   subh == Sub-heading.
  #   Ccha == Contents entry for a chapter.
  #   Chea == Contents entry for a heading.
  #   Csub == Contents entry for a subheading.
  #   cone == Code paragraph with just this one line on it.
  #   cbeg == First line of multi-line code paragraph.
  #   cbdy == Interior line of multi-line code paragraph.
  #   cend == Final line of multi-line code paragraph.
  #   none == Normal paragraph with just this one line on it.
  #   nbeg == First line of multi-line normal paragraph.
  #   nbdy == Interior line of multi-line normal paragraph.
  #   nend == Final line of multi-line normal paragraph.
  #   bone == Bulleted paragraph with just this one line on it.
  #   bbeg == First line of multi-line bulleted paragraph.
  #   bbdy == Interior line of multi-line bulleted paragraph.
  #   bend == Final line of multi-line bulleted paragraph.
  print "line-breaks...";
  $lname = "psline000000";
  $lnamei = "idx" . $lname;
  @lnames = @ltypes = ();

  for ($para = 0; $para <= $#pnames; $para++) {
    $pname = $pnames[$para];
    $pflags = $pflags[$para];
    $ptype = substr($pflags,0,4);

    # New paragraph _ergo_ new line.
    @line = ();
    @lindex = (); # list of index tags referenced to this line

    if ($ptype eq "chap") {
      # Chapter heading. "Chapter N: Title" followed by a line of
      # minus signs.
      $pflags =~ /chap (.*) :(.*)/;
      push @line, "nChapter", " ", "n$1:", " ";
      foreach $i (@$pname) {
        $ww = &word_ps($i);
        push @line, $ww unless $ww eq "x";
      }
      @$lname = @line; @$lnamei = @lindex;
      push @lnames, $lname++;
      $lnamei = "idx" . $lname;
      push @ltypes, "chap";
    } elsif ($ptype eq "appn") {
      # Appendix heading. "Appendix N: Title" followed by a line of
      # minus signs.
      $pflags =~ /appn (.*) :(.*)/;
      push @line, "nAppendix", " ", "n$1:", " ";
      foreach $i (@$pname) {
        $ww = &word_ps($i);
        push @line, $ww unless $ww eq "x";
      }
      @$lname = @line; @$lnamei = @lindex;
      push @lnames, $lname++;
      $lnamei = "idx" . $lname;
      push @ltypes, "chap";
    } elsif ($ptype eq "head") {
      # Heading. Just a number and some text.
      $pflags =~ /.... (.*) :(.*)/;
      push @line, "n$1";
      foreach $i (@$pname) {
        $ww = &word_ps($i);
        push @line, $ww unless $ww eq "x";
      }
      @$lname = @line; @$lnamei = @lindex;
      push @lnames, $lname++;
      $lnamei = "idx" . $lname;
      push @ltypes, $ptype;
    } elsif ($ptype eq "subh") {
      # Subheading. Just a number and some text.
      $pflags =~ /subh (.*) :(.*)/;
      push @line, "n$1";
      foreach $i (@$pname) {
        push @line, &word_ps($i);
      }
      @$lname = @line; @$lnamei = @lindex;
      push @lnames, $lname++;
      $lnamei = "idx" . $lname;
      push @ltypes, "subh";
    } elsif ($ptype eq "code") {
      # Code paragraph. Emit lines one at a time.
      $type = "cbeg";
      foreach $i (@$pname) {
        @$lname = ("c$i");
	push @lnames, $lname++;
	$lnamei = "idx" . $lname;
	push @ltypes, $type;
	$type = "cbdy";
      }
      $ltypes[$#ltypes] = ($ltypes[$#ltypes] eq "cbeg" ? "cone" : "cend");
    } elsif ($ptype eq "bull" || $ptype eq "norm") {
      # Ordinary paragraph, optionally bulleted. We wrap, with ragged
      # 75-char right margin and either 7 or 11 char left margin
      # depending on bullets.
      if ($ptype eq "bull") {
        $width = 456; # leave 12-pt left indent for the bullet
	$type = $begtype = "bbeg";
	$bodytype = "bbdy";
	$onetype = "bone";
	$endtype = "bend";
      } else {
        $width = 468;
	$type = $begtype = "nbeg";
	$bodytype = "nbdy";
	$onetype = "none";
	$endtype = "nend";
      }
      @a = @$pname;
      @line = @wd = ();
      $linelen = 0;
      $wprev = undef;
      do {
        do { $w = &word_ps(shift @a) } while ($w eq "x");
	push @wd, $wprev if $wprev;
	if ($wprev =~ /^n.*-$/ || $w eq ' ' || $w eq '' || $w eq undef) {
	  $wdlen = &len_ps(@wd);
	  if ($linelen + $wdlen > $width) {
	    pop @line while $line[$#line] eq ' '; # trim trailing spaces
	    @$lname = @line; @$lnamei = @lindex;
	    push @lnames, $lname++;
	    $lnamei = "idx" . $lname;
	    push @ltypes, $type;
	    $type = $bodytype;
	    @line = @lindex = ();
	    $linelen = 0;
	    shift @wd while $wd[0] eq ' '; # trim leading spaces
	  }
	  push @line, @wd;
	  $linelen += $wdlen;
	  @wd = ();
	}
	$wprev = $w;
      } while ($w ne '' && $w ne undef);
      if (@line) {
        pop @line while $line[$#line] eq ' '; # trim trailing spaces
	@$lname = @line; @$lnamei = @lindex;
	push @lnames, $lname++;
	$lnamei = "idx" . $lname;
	push @ltypes, $type;
	$type = $bodytype;
      }
      $ltypes[$#ltypes] =
        ($ltypes[$#ltypes] eq $begtype ? $onetype : $endtype);
    }
  }

  # We've now processed the document source into lines. Before we
  # go on and do the page breaking, we'll fabricate a table of contents,
  # line by line, and then after doing page breaks we'll go back and
  # insert the page numbers into the contents entries.
  print "building contents...";
  @clnames = @cltypes = ();
  $clname = "pscont000000";
  @$clname = ("nContents"); # "chapter heading" for TOC
  push @clnames,$clname++;
  push @cltypes,"chap";
  for ($i=0; $i<=$#lnames; $i++) {
    $lname = $lnames[$i];
    if ($ltypes[$i] =~ /^(chap|head|subh)/) {
      @$clname = @$lname;
      splice @$clname,1,0," " if ($ltypes[$i] !~ /chap/);
      push @$clname,$i; # placeholder for page number
      push @clnames,$clname++;
      push @cltypes,"C" . substr($ltypes[$i],0,3);
    }
  }
  @$clname = ("nIndex"); # contents entry for Index
  push @$clname,$i;      # placeholder for page number
  $idx_clname = $clname;
  push @clnames,$clname++;
  push @cltypes,"Ccha";
  $contlen = $#clnames + 1;
  unshift @lnames,@clnames;
  unshift @ltypes,@cltypes;

  # Second stage: now we have a list of lines, break them into pages.
  # We do this by means of adding a third array in parallel with
  # @lnames and @ltypes, called @lpages, in which we store the page
  # number that each line resides on. We also add @ycoord which
  # stores the vertical position of each line on the page.
  #
  # Page breaks may not come after line-types:
  #   chap head subh cbeg nbeg bbeg
  # and may not come before line-types:
  #   cend nend bend
  # They are forced before line-types:
  #   chap
  print "page-breaks...";
  $pmax = 600; # ADJUSTABLE: maximum length of a page in points
  $textht = 11; # ADJUSTABLE: height of a normal line in points
  $spacing = 6; # ADJUSTABLE: space between paragraphs, in points
  $headht = 14; # ADJUSTABLE: height of a major heading in points
  $subht = 12; # ADJUSTABLE: height of a sub-heading in points
  $pstart = 0; # start line of current page
  $plen = 0; # current length of current page
  $pnum = 1; # number of current page
  $bpt = -1; # last feasible break point
  $i = 0; # line number
  while ($i <= $#lnames) {
    $lname = $lnames[$i];
    # Add the height of this line (computed the last time we went round
    # the loop, unless we're a chapter heading in which case we do it
    # now) to the length of the current page. Also, _put_ this line on
    # the current page, and allocate it a y-coordinate.
    if ($ltypes[$i] =~ /^chap$/) {
      $plen = 100; # ADJUSTABLE: space taken up by a chapter heading
      $ycoord[$i] = 0; # chapter heading: y-coord doesn't matter
    } else {
      $ycoord[$i] = $plen + $space;
      $plen += $space + $ht;
    }
    # See if we can break after this line.
    $bpt = $i if $ltypes[$i] !~ /^chap|head|subh|cbeg|nbeg|bbeg$/ &&
		 $ltypes[$i+1] !~ /^cend|nend|bend$/;
    # Assume, to start with, that we don't break after this line.
    $break = 0;
    # See if a break is forced.
    $break = 1, $bpt = $i if $ltypes[$i+1] eq "chap" || !$ltypes[$i+1];
    # Otherwise, compute the height of the next line, and break if
    # it would make this page too long.
    $ht = $textht, $space = 0 if $ltypes[$i+1] =~ /^[nbc](bdy|end)$/;
    $ht = $textht, $space = $spacing if $ltypes[$i+1] =~ /^[nbc](one|beg)$/;
    $ht = $textht, $space = $spacing if $ltypes[$i+1] =~ /^C/;
    $ht = $subht, $space = $spacing if $ltypes[$i+1] eq "subh";
    $ht = $headht, $space = $spacing if $ltypes[$i+1] eq "head";
    $break = 1 if $plen + $space + $ht > $pmax;
    # Now, if we're breaking, assign page number $pnum to all lines up
    # to $bpt, set $i == $bpt+1, and zero $space since we are at the
    # start of a new page and don't want leading space.
    if ($break) {
      die "no feasible break point at all on page $pnum\n" if $bpt == -1;
      for ($j = $pstart; $j <= $bpt; $j++) {
	$lnamei = "idx" . $lnames[$j];
	foreach $k (@$lnamei) {
	  ${$psidxpp{$k}}{$pnum} = 1;
	}
        $lpages[$j] = $pnum;
      }
      $pnum++;
      $i = $bpt;
      $bpt = -1;
      $pstart = $i+1;
      $plen = 0;
      $space = 0;
    }
    $i++;
  }

  # Now fix up the TOC with page numbers.
  print "\n   fixing up contents...";
  for ($i=0; $i<=$#lnames; $i++) {
    $lname = $lnames[$i];
    if ($ltypes[$i] =~ /^C/) {
      $j = pop @$lname;
      push @$lname, "n" . $lpages[$j+$contlen];
    }
  }

  # Having got page numbers for most stuff, generate an index.
  print "building index...";
  $iwid = 222;
  $sep = 12;
  $commaindent = 32;
  foreach $k (@itags) {
    @line = ();
    $cmd = "index";
    @idxentry = @{$idxmap{$k}};
    if ($commaafter{$k} and !$commanext{$k}) {
      # This line is a null line beginning a multiple entry. We must
      # output the prefix on a line by itself.

      @idxhead = splice @idxentry,0,$commapos{$k};
      @line = ();
      foreach $i (@idxhead) {
        $ww = &word_ps($i);
	push @line, $ww unless $ww eq "x";
      }
      &ps_idxout("index",\@line,[]);
      $cmd = "iindex";
      @line = ();
    }
    $cmd = "iindex", splice @idxentry,0,$commapos{$k} if $commanext{$k};
    foreach $i (@idxentry) {
      $ww = &word_ps($i);
      push @line, $ww unless $ww eq "x";
    }
    $len = $iwid - $sep - &len_ps(@line);
    warn "text for index tag `%s' is longer than one index line!\n"
      if $len < -$sep;
    @pp = ();
    $inums = join(',',sort { $a <=> $b } keys %{$psidxpp{$k}});
    while (length $inums) {
      $inums =~ /^([^,]+,?)(.*)$/;
      $inums = $2, $inum = $1;
      @pnum = (" ", "n$inum");
      $pnumlen = &len_ps(@pnum);
      if ($pnumlen > $len) {
        &ps_idxout($cmd,\@line,\@pp);
	@pp = ();
	@line = ();
	$cmd = "index";
	$len = $iwid - $sep;
      }
      push @pp, @pnum;
      $len -= $pnumlen;
    }
    &ps_idxout($cmd,\@line,\@pp) if (length @pp);
    $l1 = &len_ps(@line);
    $l2 = &len_ps($pp);
  }
  $$idx_clname[$#$idx_clname] = "n" . $pnum; # fix up TOC entry for index

  print "writing file...";
  open PS,">nasmdoc.ps";
  select PS;
  $page = $lpages[0];
  &ps_header;
  for ($i=0; $i<=$#lnames; $i++) {
    &ps_throw_pg($page,$lpages[$i]) if $page != $lpages[$i];
    $page = $lpages[$i];
    &ps_out_line($ycoord[$i],$ltypes[$i],$lnames[$i]);
  }
  $i = 0;
  while ($i <= $#psindex) {
    &ps_throw_pg($page, $pnum) if $page != $pnum;
    $page = $pnum++;
    $ypos = 0;
    $ypos = 100, &ps_out_line(0, "chap", ["nIndex"]) if !$i;
    $lines = ($pmax - $ypos) / $textht;
    my $col; # ps_out_line hits this variable
    PAGE:for ($col = 1; $col <= 2; $col++) {
      $y = $ypos; $l = $lines;
      COL: while ($l > 0) {
        $j = $i+1;
	$j++ while $psindex[$j] and ($psindex[$j][3] == 0); # find next break
	last COL if $j-$i > $l or $i > $#psindex;
	while ($i < $j) {
	  &ps_out_line($y, $psindex[$i][0] eq "index" ? "idl$col" : "ldl$col",
	               $psindex[$i][1]);
	  &ps_out_line($y,"idr$col",$psindex[$i][2]);
	  $i++;
	  $y += $textht;
	  $l--;
	}
      }
      last PAGE if $i > $#psindex;
    }
  }
  &ps_trailer;
  close PS;
  select STDOUT;
}

sub ps_idxout {
  my ($cmd, $left, $right) = @_;
  my $break = 1;
  $break = 0
      if ($#psindex >= 0) and ( ($#$left < 0) or ($cmd eq "iindex") );
  push @psindex,[$cmd,[@$left],[@$right],$break];
}

sub ps_header {
  @pshdr = (
    '/sp (n ) def', # here it's sure not to get wrapped inside ()
    '/nf /Times-Roman findfont 11 scalefont def',
    '/ef /Times-Italic findfont 11 scalefont def',
    '/cf /Courier findfont 11 scalefont def',
    '/nc /Helvetica-Bold findfont 18 scalefont def',
    '/ec /Helvetica-Oblique findfont 18 scalefont def',
    '/cc /Courier-Bold findfont 18 scalefont def',
    '/nh /Helvetica-Bold findfont 14 scalefont def',
    '/eh /Helvetica-Oblique findfont 14 scalefont def',
    '/ch /Courier-Bold findfont 14 scalefont def',
    '/ns /Helvetica-Bold findfont 12 scalefont def',
    '/es /Helvetica-Oblique findfont 12 scalefont def',
    '/cs /Courier-Bold findfont 12 scalefont def',
    '/n 16#6E def /e 16#65 def /c 16#63 def',
    '/chapter {',
    '  100 620 moveto',
    '  {',
    '    dup 0 get',
    '    dup n eq {pop nc setfont} {',
    '      e eq {ec setfont} {cc setfont} ifelse',
    '    } ifelse',
    '    dup length 1 sub 1 exch getinterval show',
    '  } forall',
    '  0 setlinecap 3 setlinewidth',
    '  newpath 100 610 moveto 468 0 rlineto stroke',
    '} def',
    '/heading {',
    '  686 exch sub /y exch def /a exch def',
    '  90 y moveto a 0 get dup length 1 sub 1 exch getinterval',
    '  nh setfont dup stringwidth pop neg 0 rmoveto show',
    '  100 y moveto',
    '  a dup length 1 sub 1 exch getinterval {',
    '    /s exch def',
    '    s 0 get',
    '    dup n eq {pop nh setfont} {',
    '      e eq {eh setfont} {ch setfont} ifelse',
    '    } ifelse',
    '    s s length 1 sub 1 exch getinterval show',
    '  } forall',
    '} def',
    '/subhead {',
    '  688 exch sub /y exch def /a exch def',
    '  90 y moveto a 0 get dup length 1 sub 1 exch getinterval',
    '  ns setfont dup stringwidth pop neg 0 rmoveto show',
    '  100 y moveto',
    '  a dup length 1 sub 1 exch getinterval {',
    '    /s exch def',
    '    s 0 get',
    '    dup n eq {pop ns setfont} {',
    '      e eq {es setfont} {cs setfont} ifelse',
    '    } ifelse',
    '    s s length 1 sub 1 exch getinterval show',
    '  } forall',
    '} def',
    '/disp { /j exch def',
    '  568 exch sub exch 689 exch sub moveto',
    '  {',
    '    /s exch def',
    '    s 0 get',
    '    dup n eq {pop nf setfont} {',
    '      e eq {ef setfont} {cf setfont} ifelse',
    '    } ifelse',
    '    s s length 1 sub 1 exch getinterval show',
    '    s sp eq {j 0 rmoveto} if',
    '  } forall',
    '} def',
    '/contents { /w exch def /y exch def /a exch def',
    '  /yy 689 y sub def',
    '  a a length 1 sub get dup length 1 sub 1 exch getinterval /s exch def',
    '  nf setfont 568 s stringwidth pop sub /ex exch def',
    '  ex yy moveto s show',
    '  a 0 a length 1 sub getinterval y w 0 disp',
    '  /sx currentpoint pop def nf setfont',
    '  100 10 568 { /i exch def',
    '    i 5 sub sx gt i 5 add ex lt and {',
    '      i yy moveto (.) show',
    '    } if',
    '  } for',
    '} def',
    '/just { /w exch def /y exch def /a exch def',
    '  /jj w def /spaces 0 def',
    '  a {',
    '    /s exch def',
    '    s 0 get',
    '    dup n eq {pop nf setfont} {',
    '      e eq {ef setfont} {cf setfont} ifelse',
    '    } ifelse',
    '    s s length 1 sub 1 exch getinterval stringwidth pop',
    '    jj exch sub /jj exch def',
    '    s sp eq {/spaces spaces 1 add def} if',
    '  } forall',
    '  a y w jj spaces spaces 0 eq {pop pop 0} {div} ifelse disp',
    '} def',
    '/idl { 468 exch sub 0 disp } def',
    '/ldl { 436 exch sub 0 disp } def',
    '/idr { 222 add 468 exch sub /x exch def /y exch def /a exch def',
    '  a {',
    '    /s exch def',
    '    s 0 get',
    '    dup n eq {pop nf setfont} {',
    '      e eq {ef setfont} {cf setfont} ifelse',
    '    } ifelse',
    '    s s length 1 sub 1 exch getinterval stringwidth pop',
    '    x add /x exch def',
    '  } forall',
    '  a y x 0 disp',
    '} def',
    '/left {0 disp} def',
    '/bullet {',
    '  nf setfont dup 100 exch 689 exch sub moveto (\267) show',
    '} def'
  );
  print "%!PS-Adobe-3.0\n";
  print "%%BoundingBox: 95 95 590 705\n";
  print "%%Creator: a nasty Perl script\n";
  print "%%DocumentData: Clean7Bit\n";
  print "%%Orientation: Portrait\n";
  print "%%Pages: $lpages[$#lpages]\n";
  print "%%DocumentNeededResources: font Times-Roman Times-Italic\n";
  print "%%+ font Helvetica-Bold Courier Courier-Bold\n";
  print "%%EndComments\n%%BeginProlog\n%%EndProlog\n%%BeginSetup\nsave\n";
  $pshdr = join(' ',@pshdr);
  $pshdr =~ s/\s+/ /g;
  while ($pshdr =~ /\S/) {
    last if length($pshdr) < 72 || $pshdr !~ /^(.{0,72}\S)\s(.*)$/;
    $pshdr = $2;
    print "$1\n";
  }
  print "$pshdr\n" if $pshdr =~ /\S/;
  print "%%EndSetup\n";
  &ps_initpg($lpages[0]);
}

sub ps_trailer {
  &ps_donepg;
  print "%%Trailer\nrestore\n%%EOF\n";
}

sub ps_throw_pg {
  my ($oldpg, $newpg) = @_;
  &ps_donepg;
  &ps_initpg($newpg);
}

sub ps_initpg {
  my ($pgnum) = @_;
  print "%%Page: $pgnum $pgnum\n";
  print "%%BeginPageSetup\nsave\n%%EndPageSetup\n";
}

sub ps_donepg {
  print "%%PageTrailer\nrestore showpage\n";
}

sub ps_out_line {
  my ($ypos,$ltype,$lname) = @_;
  my $c,$d,$wid;

  print "[";
  $col = 1;
  foreach $c (@$lname) {#
    $c= "n " if $c eq " ";
    $c = "n\261" if $c eq "-";
    $d = '';
    while (length $c) {
      $d .= $1, $c = $2 while $c =~ /^([ -'\*-\[\]-~]+)(.*)$/;
      while (1) {
        $d .= "\\$1", $c = $2, next if $c =~ /^([\\\(\)])(.*)$/;
	($d .= sprintf "\\%3o",unpack("C",$1)), $c = $2, next
	  if $c =~ /^([^ -~])(.*)$/;
	last;
      }
    }
    $d = "($d)";
    $col = 0, print "\n" if $col>0 && $col+length $d > 77;
    print $d;
    $col += length $d;
  }
  print "\n" if $col > 60;
  print "]";
  if ($ltype =~ /^[nb](beg|bdy)$/) {
    printf "%d %s%d just\n",
      $ypos, ($ltype eq "bbeg" ? "bullet " : ""),
      ($ltype =~ /^b/ ? 456 : 468);
  } elsif ($ltype =~ /^[nb](one|end)$/) {
    printf "%d %s%d left\n",
      $ypos, ($ltype eq "bone" ? "bullet " : ""),
      ($ltype =~ /^b/ ? 456 : 468);
  } elsif ($ltype =~ /^c(one|beg|bdy|end)$/) {
    printf "$ypos 468 left\n";
  } elsif ($ltype =~ /^C/) {
    $wid = 468;
    $wid = 456 if $ltype eq "Chea";
    $wid = 444 if $ltype eq "Csub";
    printf "$ypos $wid contents\n";
  } elsif ($ltype eq "chap") {
    printf "chapter\n";
  } elsif ($ltype eq "head") {
    printf "$ypos heading\n";
  } elsif ($ltype eq "subh") {
    printf "$ypos subhead\n";
  } elsif ($ltype =~ /([il]d[lr])([12])/) {
    $left = ($2 eq "2" ? 468-222 : 0);
    printf "$ypos $left $1\n";
  }
}

sub word_ps {
  my ($w) = @_;
  my $wtype, $wmajt;

  return undef if $w eq '' || $w eq undef;

  $wtype = substr($w,0,2);
  $wmajt = substr($wtype,0,1);
  $w = substr($w,2);
  $w =~ s/<.*>// if $wmajt eq "w"; # remove web links
  if ($wmajt eq "n" || $wtype eq "w ") {
    return "n$w";
  } elsif ($wtype eq "sp") {
    return ' ';
  } elsif ($wtype eq "da") {
    return '-';
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    return "c$w";
  } elsif ($wmajt eq "e") {
    return "e$w";
  } elsif ($wmajt eq "x") {
    return "x";
  } elsif ($wtype eq "i ") {
    push @lindex, $w;
    return "x";
  } else {
    die "panic in word_ps: $wtype$w\n";
  }
}

sub len_ps {
  my (@line) = @_;
  my $l = 0;
  my $w, $size;

  $size = 11/1000; # used only for length calculations
  while ($w = shift @line) {
    $w = "n " if $w eq " ";
    $w = "n\261" if $w eq "-";
    $f = substr($w,0,1);
    $f = "timesr" if $f eq "n";
    $f = "timesi" if $f eq "e";
    $f = "courr" if $f eq "c";
    foreach $c (unpack 'C*',substr($w,1)) {
      $l += $size * $$f[$c];
    }
  }
  return $l;
}

sub write_texi {
  # This is called from the top level, so I won't bother using
  # my or local.

  # Open file.
  print "writing file...";
  open TEXT,">nasmdoc.texi";
  select TEXT;

  # Preamble.
  print "\input texinfo   \@c -*-texinfo-*-\n";
  print "\@c \%**start of header\n";
  print "\@setfilename nasm.info\n";
  print "\@dircategory Programming\n";
  print "\@direntry\n";
  print "* NASM: (nasm).                The Netwide Assembler for x86.\n";
  print "\@end direntry\n";
  print "\@settitle NASM: The Netwide Assembler\n";
  print "\@setchapternewpage odd\n";
  print "\@c \%**end of header\n";
  print "\n";
  print "\@ifinfo\n";
  print "This file documents NASM, the Netwide Assembler: an assembler\n";
  print "targetting the Intel x86 series of processors, with portable source.\n";
  print "\n";
  print "Copyright 1997 Simon Tatham\n";
  print "\n";
  print "All rights reserved. This document is redistributable under the\n";
  print "licence given in the file \"Licence\" distributed in the NASM archive.\n";
  print "\@end ifinfo\n";
  print "\n";
  print "\@titlepage\n";
  print "\@title NASM: The Netwide Assembler\n";
  print "\@author Simon Tatham\n";
  print "\n";
  print "\@page\n";
  print "\@vskip 0pt plus 1filll\n";
  print "Copyright \@copyright{} 1997 Simon Tatham\n";
  print "\n";
  print "All rights reserved. This document is redistributable under the\n";
  print "licence given in the file \"Licence\" distributed in the NASM archive.\n";
  print "\@end titlepage\n";
  print "\n";
  print "\@node Top, $tstruct_next{'Top'}, (dir), (dir)\n";
  print "\@top\n";
  print "\n";
  print "\@ifinfo\n";
  print "This file documents NASM, the Netwide Assembler: an assembler\n";
  print "targetting the Intel x86 series of processors, with portable source.\n";
  print "\@end ifinfo\n";

  $node = "Top";

  $bulleting = 0;
  for ($para = 0; $para <= $#pnames; $para++) {
    $pname = $pnames[$para];
    $pflags = $pflags[$para];
    $ptype = substr($pflags,0,4);

    $bulleting = 0, print "\@end itemize\n" if $bulleting && $ptype ne "bull";
    print "\n"; # always one of these before a new paragraph

    if ($ptype eq "chap") {
      # Chapter heading. Begin a new node.
      &texi_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /chap (.*) :(.*)/;
      $node = "Chapter $1";
      $title = "Chapter $1: ";
      foreach $i (@$pname) {
        $ww = &word_texi($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "\@node $node, $tstruct_next{$node}, $tstruct_prev{$node},";
      print " $tstruct_up{$node}\n\@unnumbered $title\n";
    } elsif ($ptype eq "appn") {
      # Appendix heading. Begin a new node.
      &texi_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /appn (.*) :(.*)/;
      $node = "Appendix $1";
      $title = "Appendix $1: ";
      foreach $i (@$pname) {
        $ww = &word_texi($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "\@node $node, $tstruct_next{$node}, $tstruct_prev{$node},";
      print " $tstruct_up{$node}\n\@unnumbered $title\n";
    } elsif ($ptype eq "head" || $ptype eq "subh") {
      # Heading or subheading. Begin a new node.
      &texi_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /.... (.*) :(.*)/;
      $node = "Section $1";
      $title = "$1. ";
      foreach $i (@$pname) {
        $ww = &word_texi($i);
        $title .= $ww unless $ww eq "\001";
      }
      print "\@node $node, $tstruct_next{$node}, $tstruct_prev{$node},";
      print " $tstruct_up{$node}\n\@unnumbered $title\n";
    } elsif ($ptype eq "code") {
      # Code paragraph. Surround with @example / @end example.
      print "\@example\n";
      foreach $i (@$pname) {
        warn "code line longer than 68 chars: $i\n" if length $i > 68;
	$i =~ s/\@/\@\@/g;
	$i =~ s/\{/\@\{/g;
	$i =~ s/\}/\@\}/g;
        print "$i\n";
      }
      print "\@end example\n";
    } elsif ($ptype eq "bull" || $ptype eq "norm") {
      # Ordinary paragraph, optionally bulleted. We wrap, FWIW.
      if ($ptype eq "bull") {
        $bulleting = 1, print "\@itemize \@bullet\n" if !$bulleting;
	print "\@item\n";
      }
      $line = '';
      @a = @$pname;
      $wd = $wprev = '';
      do {
        do { $w = &word_texi(shift @a); } while $w eq "\001"; # hack
	$wd .= $wprev;
	if ($wprev =~ /-$/ || $w eq ' ' || $w eq '' || $w eq undef) {
	  if (length ($line . $wd) > 75) {
	    $line =~ s/\s*$//; # trim trailing spaces
	    print "$line\n";
	    $line = '';
	    $wd =~ s/^\s*//; # trim leading spaces
	  }
	  $line .= $wd;
	  $wd = '';
	}
	$wprev = $w;
      } while ($w ne '' && $w ne undef);
      if ($line =~ /\S/) {
	$line =~ s/\s*$//; # trim trailing spaces
	print "$line\n";
      }
    }
  }

  # Write index.
  &texi_index;

  # Close file.
  print "\n\@contents\n\@bye\n";
  select STDOUT;
  close TEXT;
}

# Side effect of this procedure: update global `texiwdlen' to be the length
# in chars of the formatted version of the word.
sub word_texi {
  my ($w) = @_;
  my $wtype, $wmajt;

  return undef if $w eq '' || $w eq undef;
  $wtype = substr($w,0,2);
  $wmajt = substr($wtype,0,1);
  $w = substr($w,2);
  $wlen = length $w;
  $w =~ s/\@/\@\@/g;
  $w =~ s/\{/\@\{/g;
  $w =~ s/\}/\@\}/g;
  $w =~ s/<.*>// if $wmajt eq "w"; # remove web links
  substr($w,0,1) =~ tr/a-z/A-Z/, $capital = 0 if $capital;
  if ($wmajt eq "n" || $wtype eq "e " || $wtype eq "w ") {
    $texiwdlen = $wlen;
    return $w;
  } elsif ($wtype eq "sp") {
    $texiwdlen = 1;
    return ' ';
  } elsif ($wtype eq "da") {
    $texiwdlen = 2;
    return '--';
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    $texiwdlen = 2 + $wlen;
    return "\@code\{$w\}";
  } elsif ($wtype eq "es") {
    $texiwdlen = 1 + $wlen;
    return "\@emph\{${w}";
  } elsif ($wtype eq "ee") {
    $texiwdlen = 1 + $wlen;
    return "${w}\}";
  } elsif ($wtype eq "eo") {
    $texiwdlen = 2 + $wlen;
    return "\@emph\{${w}\}";
  } elsif ($wtype eq "x ") {
    $texiwdlen = 0; # we don't need it in this case
    $capital = 1; # hack
    return "\@ref\{";
  } elsif ($wtype eq "xe") {
    $texiwdlen = 0; # we don't need it in this case
    return "\}";
  } elsif ($wmajt eq "i") {
    $texiwdlen = 0; # we don't need it in this case
    return "\001";
  } else {
    die "panic in word_texi: $wtype$w\n";
  }
}

sub texi_menu {
  my ($topitem) = @_;
  my $item, $i, $mpname, $title, $wd;

  $item = $tstruct_next{$topitem};
  print "\@menu\n";
  while ($item) {
    $title = "";
    $mpname = $tstruct_pname{$item};
    foreach $i (@$mpname) {
      $wd = &word_texi($i);
      $title .= $wd unless $wd eq "\001";
    }
    print "* ${item}:: $title\n";
    $item = $tstruct_mnext{$item};
  }
  print "* Index::\n" if $topitem eq "Top";
  print "\@end menu\n";
}

sub texi_index {
  my $itag, $ientry, @a, $wd, $item, $len;
  my $subnums = "123456789ABCDEFGHIJKLMNOPQRSTU" .
                "VWXYZabcdefghijklmnopqrstuvwxyz";

  print "\@ifinfo\n\@node Index, , $FIXMElastnode, Top\n";
  print "\@unnumbered Index\n\n\@menu\n";

  foreach $itag (@itags) {
    $ientry = $idxmap{$itag};
    @a = @$ientry;
    $item = '';
    $len = 0;
    foreach $i (@a) {
      $wd = &word_texi($i);
      $item .= $wd, $len += $texiwdlen unless $wd eq "\001";
    }
    $i = 0;
    foreach $node (@nodes) {
      next if !$idxnodes{$node,$itag};
      printf "* %s%s (%s): %s.\n",
          $item, " " x (40-$len), substr($subnums,$i++,1), $node;
    }
  }
  print "\@end menu\n\@end ifinfo\n";
}

sub write_hlp {
  # This is called from the top level, so I won't bother using
  # my or local.

  # Build the index-tag text forms.
  print "building index entries...";
  @hlp_index = map {
                 my $i,$ww;
		 my $ientry = $idxmap{$_};
		 my $title = "";
                 foreach $i (@$ientry) {
		   $ww = &word_hlp($i,0);
		   $title .= $ww unless $ww eq "\001";
		 }
		 $title;
               } @itags;

  # Write the HPJ project-description file.
  print "writing .hpj file...";
  open HPJ,">nasmdoc.hpj";
  print HPJ "[OPTIONS]\ncompress=true\n";
  print HPJ "title=NASM: The Netwide Assembler\noldkeyphrase=no\n\n";
  print HPJ "[FILES]\nnasmdoc.rtf\n\n";
  print HPJ "[CONFIG]\n";
  print HPJ 'CreateButton("btn_up", "&Up",'.
            ' "JumpContents(`nasmdoc.hlp'."'".')")';
  print HPJ "\nBrowseButtons()\n";
  close HPJ;

  # Open file.
  print "\n   writing .rtf file...";
  open TEXT,">nasmdoc.rtf";
  select TEXT;

  # Preamble.
  print "{\\rtf1\\ansi{\\fonttbl\n";
  print "\\f0\\froman Times New Roman;\\f1\\fmodern Courier New;\n";
  print "\\f2\\fswiss Arial;\\f3\\ftech Wingdings}\\deff0\n";
  print "#{\\footnote Top}\n";
  print "\${\\footnote Contents}\n";
  print "+{\\footnote browse:00000}\n";
  print "!{\\footnote DisableButton(\"btn_up\")}\n";
  print "\\keepn\\f2\\b\\fs30\\sb0\n";
  print "NASM: The Netwide Assembler\n";
  print "\\par\\pard\\plain\\sb120\n";
  print "This file documents NASM, the Netwide Assembler: an assembler \n";
  print "targetting the Intel x86 series of processors, with portable source.\n";

  $node = "Top";
  $browse = 0;

  $newpar = "\\par\\sb120\n";
  for ($para = 0; $para <= $#pnames; $para++) {
    $pname = $pnames[$para];
    $pflags = $pflags[$para];
    $ptype = substr($pflags,0,4);

    print $newpar;
    $newpar = "\\par\\sb120\n";

    if ($ptype eq "chap") {
      # Chapter heading. Begin a new node.
      &hlp_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /chap (.*) :(.*)/;
      $node = "Chapter $1";
      $title = $footnotetitle = "Chapter $1: ";
      foreach $i (@$pname) {
        $ww = &word_hlp($i,1);
	$title .= $ww, $footnotetitle .= &word_hlp($i,0) unless $ww eq "\001";
      }
      print "\\page\n";
      printf "#{\\footnote %s}\n", &hlp_sectkw($node);
      print "\${\\footnote $footnotetitle}\n";
      printf "+{\\footnote browse:%05d}\n", ++$browse;
      printf "!{\\footnote ChangeButtonBinding(\"btn_up\"," .
             "\"JumpId(\`nasmdoc.hlp',\`%s')\");\n",
	     &hlp_sectkw($tstruct_up{$node});
      print "EnableButton(\"btn_up\")}\n";
      &hlp_keywords($node);
      print "\\keepn\\f2\\b\\fs30\\sb60\\sa60\n";
      print "$title\n";
      $newpar = "\\par\\pard\\plain\\sb120\n";
    } elsif ($ptype eq "appn") {
      # Appendix heading. Begin a new node.
      &hlp_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /appn (.*) :(.*)/;
      $node = "Appendix $1";
      $title = $footnotetitle = "Appendix $1: ";
      foreach $i (@$pname) {
        $ww = &word_hlp($i,1);
	$title .= $ww, $footnotetitle .= &word_hlp($i,0) unless $ww eq "\001";
      }
      print "\\page\n";
      printf "#{\\footnote %s}\n", &hlp_sectkw($node);
      print "\${\\footnote $footnotetitle}\n";
      printf "+{\\footnote browse:%05d}\n", ++$browse;
      printf "!{\\footnote ChangeButtonBinding(\"btn_up\"," .
             "\"JumpId(\`nasmdoc.hlp',\`%s')\");\n",
	     &hlp_sectkw($tstruct_up{$node});
      print "EnableButton(\"btn_up\")}\n";
      &hlp_keywords($node);
      print "\\keepn\\f2\\b\\fs30\\sb60\\sa60\n";
      print "$title\n";
      $newpar = "\\par\\pard\\plain\\sb120\n";
    } elsif ($ptype eq "head" || $ptype eq "subh") {
      # Heading or subheading. Begin a new node.
      &hlp_menu($node)
        if $tstruct_level{$tstruct_next{$node}} > $tstruct_level{$node};
      $pflags =~ /.... (.*) :(.*)/;
      $node = "Section $1";
      $title = $footnotetitle = "$1. ";
      foreach $i (@$pname) {
        $ww = &word_hlp($i,1);
	$title .= $ww, $footnotetitle .= &word_hlp($i,0) unless $ww eq "\001";
      }
      print "\\page\n";
      printf "#{\\footnote %s}\n", &hlp_sectkw($node);
      print "\${\\footnote $footnotetitle}\n";
      printf "+{\\footnote browse:%05d}\n", ++$browse;
      printf "!{\\footnote ChangeButtonBinding(\"btn_up\"," .
             "\"JumpId(\`nasmdoc.hlp',\`%s')\");\n",
	     &hlp_sectkw($tstruct_up{$node});
      print "EnableButton(\"btn_up\")}\n";
      &hlp_keywords($node);
      print "\\keepn\\f2\\b\\fs30\\sb60\\sa60\n";
      print "$title\n";
      $newpar = "\\par\\pard\\plain\\sb120\n";
    } elsif ($ptype eq "code") {
      # Code paragraph.
      print "\\keep\\f1\\sb120\n";
      foreach $i (@$pname) {
        warn "code line longer than 68 chars: $i\n" if length $i > 68;
	$i =~ s/\\/\\\\/g;
	$i =~ s/\{/\\\{/g;
	$i =~ s/\}/\\\}/g;
        print "$i\\par\\sb0\n";
      }
      $newpar = "\\pard\\f0\\sb120\n";
    } elsif ($ptype eq "bull" || $ptype eq "norm") {
      # Ordinary paragraph, optionally bulleted. We wrap, FWIW.
      if ($ptype eq "bull") {
        print "\\tx360\\li360\\fi-360{\\f3\\'9F}\\tab\n";
	$newpar = "\\par\\pard\\sb120\n";
      } else {
	$newpar = "\\par\\sb120\n";
      }
      $line = '';
      @a = @$pname;
      $wd = $wprev = '';
      do {
        do { $w = &word_hlp((shift @a),1); } while $w eq "\001"; # hack
	$wd .= $wprev;
	if ($w eq ' ' || $w eq '' || $w eq undef) {
	  if (length ($line . $wd) > 75) {
	    $line =~ s/\s*$//; # trim trailing spaces
	    print "$line \n"; # and put one back
	    $line = '';
	    $wd =~ s/^\s*//; # trim leading spaces
	  }
	  $line .= $wd;
	  $wd = '';
	}
	$wprev = $w;
      } while ($w ne '' && $w ne undef);
      if ($line =~ /\S/) {
	$line =~ s/\s*$//; # trim trailing spaces
	print "$line\n";
      }
    }
  }

  # Close file.
  print "\\page}\n";
  select STDOUT;
  close TEXT;
}

sub word_hlp {
  my ($w, $docode) = @_;
  my $wtype, $wmajt;

  return undef if $w eq '' || $w eq undef;
  $wtype = substr($w,0,2);
  $wmajt = substr($wtype,0,1);
  $w = substr($w,2);
  $w =~ s/\\/\\\\/g;
  $w =~ s/\{/\\\{/g;
  $w =~ s/\}/\\\}/g;
  $w =~ s/<.*>// if $wmajt eq "w"; # remove web links
  substr($w,0,length($w)-1) =~ s/-/\\'AD/g if $wmajt ne "x"; #nonbreakhyphens
  if ($wmajt eq "n" || $wtype eq "e " || $wtype eq "w ") {
    return $w;
  } elsif ($wtype eq "sp") {
    return ' ';
  } elsif ($wtype eq "da") {
    return "\\'96";
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    $w =~ s/ /\\'A0/g; # make spaces non-breaking
    return $docode ? "{\\f1 ${w}}" : $w;
  } elsif ($wtype eq "es") {
    return "{\\i ${w}";
  } elsif ($wtype eq "ee") {
    return "${w}}";
  } elsif ($wtype eq "eo") {
    return "{\\i ${w}}";
  } elsif ($wtype eq "x ") {
    return "{\\uldb ";
  } elsif ($wtype eq "xe") {
    $w = &hlp_sectkw($w);
    return "}{\\v ${w}}";
  } elsif ($wmajt eq "i") {
    return "\001";
  } else {
    die "panic in word_hlp: $wtype$w\n";
  }
}

sub hlp_menu {
  my ($topitem) = @_;
  my $item, $kword, $i, $mpname, $title;

  $item = $tstruct_next{$topitem};
  print "\\li360\\fi-360\n";
  while ($item) {
    $title = "";
    $mpname = $tstruct_pname{$item};
    foreach $i (@$mpname) {
      $ww = &word_hlp($i, 0);
      $title .= $ww unless $ww eq "\001";
    }
    $kword = &hlp_sectkw($item);
    print "{\\uldb ${item}: $title}{\\v $kword}\\par\\sb0\n";
    $item = $tstruct_mnext{$item};
  }
  print "\\pard\\sb120\n";
}

sub hlp_sectkw {
  my ($node) = @_;
  $node =~ tr/A-Z/a-z/;
  $node =~ tr/- ./___/;
  $node;
}

sub hlp_keywords {
  my ($node) = @_;
  my $pfx = "K{\\footnote ";
  my $done = 0;
  foreach $i (0..$#itags) {
    (print $pfx,$hlp_index[$i]), $pfx = ";\n", $done++
        if $idxnodes{$node,$itags[$i]};
  }
  print "}\n" if $done;
}

# Make tree structures. $tstruct_* is top-level and global.
sub add_item {
  my ($item, $level) = @_;
  my $i;

  $tstruct_pname{$item} = $pname;
  $tstruct_next{$tstruct_previtem} = $item;
  $tstruct_prev{$item} = $tstruct_previtem;
  $tstruct_level{$item} = $level;
  $tstruct_up{$item} = $tstruct_last[$level-1];
  $tstruct_mnext{$tstruct_last[$level]} = $item;
  $tstruct_last[$level] = $item;
  for ($i=$level+1; $i<$MAXLEVEL; $i++) { $tstruct_last[$i] = undef; }
  $tstruct_previtem = $item;
  push @nodes, $item;
}

# PostScript font metric data. Used for line breaking.
sub font_metrics {
  @timesr = (
     250,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
     250, 333, 408, 500, 500, 833, 778, 333,
     333, 333, 500, 564, 250, 333, 250, 278,
     500, 500, 500, 500, 500, 500, 500, 500,
     500, 500, 278, 278, 564, 564, 564, 444,
     921, 722, 667, 667, 722, 611, 556, 722,
     722, 333, 389, 722, 611, 889, 722, 722,
     556, 722, 667, 556, 611, 722, 722, 944,
     722, 722, 611, 333, 278, 333, 469, 500,
     333, 444, 500, 444, 500, 444, 333, 500,
     500, 278, 278, 500, 278, 778, 500, 500,
     500, 500, 333, 389, 278, 500, 500, 722,
     500, 500, 444, 480, 200, 480, 541,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 333, 500, 500, 167, 500, 500, 500,
     500, 180, 444, 500, 333, 333, 556, 556,
       0, 500, 500, 500, 250,   0, 453, 350,
     333, 444, 444, 500,1000,1000,   0, 444,
       0, 333, 333, 333, 333, 333, 333, 333,
     333,   0, 333, 333,   0, 333, 333, 333,
    1000,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 889,   0, 276,   0,   0,   0,   0,
     611, 722, 889, 310,   0,   0,   0,   0,
       0, 667,   0,   0,   0, 278,   0,   0,
     278, 500, 722, 500,   0,   0,   0,   0
  );
  @timesi = (
     250,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
     250, 333, 420, 500, 500, 833, 778, 333,
     333, 333, 500, 675, 250, 333, 250, 278,
     500, 500, 500, 500, 500, 500, 500, 500,
     500, 500, 333, 333, 675, 675, 675, 500,
     920, 611, 611, 667, 722, 611, 611, 722,
     722, 333, 444, 667, 556, 833, 667, 722,
     611, 722, 611, 500, 556, 722, 611, 833,
     611, 556, 556, 389, 278, 389, 422, 500,
     333, 500, 500, 444, 500, 444, 278, 500,
     500, 278, 278, 444, 278, 722, 500, 500,
     500, 500, 389, 389, 278, 500, 444, 667,
     444, 444, 389, 400, 275, 400, 541,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 389, 500, 500, 167, 500, 500, 500,
     500, 214, 556, 500, 333, 333, 500, 500,
       0, 500, 500, 500, 250,   0, 523, 350,
     333, 556, 556, 500, 889,1000,   0, 500,
       0, 333, 333, 333, 333, 333, 333, 333,
     333,   0, 333, 333,   0, 333, 333, 333,
     889,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 889,   0, 276,   0,   0,   0,   0,
     556, 722, 944, 310,   0,   0,   0,   0,
       0, 667,   0,   0,   0, 278,   0,   0,
     278, 500, 667, 500,   0,   0,   0,   0
  );
  @courr = (
     600,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 600, 600, 600, 600, 600, 600, 600,
     600, 600, 600, 600, 600, 600, 600, 600,
       0, 600, 600, 600, 600,   0, 600, 600,
     600, 600, 600, 600, 600, 600,   0, 600,
       0, 600, 600, 600, 600, 600, 600, 600,
     600,   0, 600, 600,   0, 600, 600, 600,
     600,   0,   0,   0,   0,   0,   0,   0,
       0,   0,   0,   0,   0,   0,   0,   0,
       0, 600,   0, 600,   0,   0,   0,   0,
     600, 600, 600, 600,   0,   0,   0,   0,
       0, 600,   0,   0,   0, 600,   0,   0,
     600, 600, 600, 600,   0,   0,   0,   0
  );
}
