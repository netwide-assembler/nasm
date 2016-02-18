#!/usr/bin/perl
## --------------------------------------------------------------------------
##   
##   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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


# Read the source-form of the NASM manual and generate the various
# output forms.

# TODO:
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
#
# Metadata
# \M{key}{something}
#   defines document metadata, such as authorship, title and copyright;
#   different output formats use this differently.
#
# Include subfile
# \&{filename}
#  Includes filename. Recursion is allowed.
#
 
use IO::File;

$diag = 1, shift @ARGV if $ARGV[0] eq "-d";

($out_format) = @ARGV;

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
while (defined($_ = <STDIN>)) {
  $_ = &untabify($_);
  &check_include($_);
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
if ($out_format eq 'txt') {
    print "Producing text output: ";
    &write_txt;
    print "done.\n";
} elsif ($out_format eq 'html') {
    print "Producing HTML output: ";
    &write_html;
    print "done.\n";
} elsif ($out_format eq 'texi') {
    print "Producing Texinfo output: ";
    &write_texi;
    print "done.\n";
} elsif ($out_format eq 'hlp') {
    print "Producing WinHelp output: ";
    &write_hlp;
    print "done.\n";
} elsif ($out_format eq 'dip') {
    print "Producing Documentation Intermediate Paragraphs: ";
    &write_dip;
    print "done.\n";
} else {
    die "$0: unknown output format: $out_format\n";
}

sub untabify($) {
  my($s) = @_;
  my $o = '';
  my($c, $i, $p);

  $p = 0;
  for ($i = 0; $i < length($s); $i++) {
    $c = substr($s, $i, 1);
    if ($c eq "\t") {
      do {
	$o .= ' ';
	$p++;
      } while ($p & 7);
    } else {
      $o .= $c;
      $p++;
    }
  }
  return $o;
}
sub check_include {
  local $_ = shift;
  if (/\\& (\S+)/) {
     &include($1);
  } else {
     &get_para($_);
  }
}
sub get_para($_) {
  chomp;
  if (!/\S/ || /^\\(IA|IR|M)/) { # special case: \IA \IR \M imply new-paragraph
    &got_para($para);
    $para = undef;
  }
  if (/\S/) {
    s/\\#.*$//; # strip comments
    $para .= " " . $_;
  }
}
sub include {
  my $name = shift;
  my $F = IO::File->new($name)
     or die "Cannot open $name: $!";
  while (<$F>) {
     &check_include($_);
  }
}
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
      $l =~ s/\\\{/\{/g;
      $l =~ s/\\\}/}/g;
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
    die "badly formatted chapter heading: $_\n" if !/^\\C\{([^\}]*)\}\s*(.*)$/;
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
    die "badly formatted appendix heading: $_\n" if !/^\\A\{([^\}]*)}\s*(.*)$/;
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
    die "badly formatted heading: $_\n" if !/^\\[HP]{([^\}]*)}\s*(.*)$/;
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
    die "badly formatted subheading: $_\n" if !/^\\S\{([^\}]*)\}\s*(.*)$/;
    $refs{$1} = "section $cnum.$hnum.$snum";
    $node = "Section $cnum.$hnum.$snum";
    &add_item($node, 3);
    $xrefnodes{$node} = $xref; $nodexrefs{$xref} = $node;
    $xrefs{$1} = $xref;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\IR/) {
    # An index-rewrite.
    die "badly formatted index rewrite: $_\n" if !/^\\IR\{([^\}]*)\}\s*(.*)$/;
    $irewrite = $1;
    $_ = $2;
    # the standard word-by-word code will happen next
  } elsif (/^\\IA/) {
    # An index-alias.
    die "badly formatted index alias: $_\n" if !/^\\IA\{([^\}]*)}\{([^\}]*)\}\s*$/;
    $idxalias{$1} = $2;
    return; # avoid word-by-word code
  } elsif (/^\\M/) {
    # Metadata
    die "badly formed metadata: $_\n" if !/^\\M\{([^\}]*)}\{([^\}]*)\}\s*$/;
    $metadata{$1} = $2;
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
      die "badly formatted \\c: \\c$_\n" if !/\{(([^\\}]|\\.)*)\}(.*)$/;
      $w = $1;
      $_ = $3;
      $w =~ s/\\\{/\{/g;
      $w =~ s/\\\}/\}/g;
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
      die "badly formatted $type: $type$_\n" if !/\{(([^\\}]|\\.)*)\}(.*)$/;
      $w = $1;
      $_ = $3;
      $w =~ s/\\\{/\{/g;
      $w =~ s/\\\}/\}/g;
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
      die "badly formatted \\k: \\k$_\n" if !/\{([^\}]*)\}(.*)$/;
      $_ = $2;
      push @$pname,"$t$1";
    } elsif (/^\\W/) {
      s/^\\W//;
      die "badly formatted \\W: \\W$_\n"
          if !/\{([^\}]*)\}(\\i)?(\\c)?\{(([^\\}]|\\.)*)\}(.*)$/;
      $l = $1;
      $w = $4;
      $_ = $6;
      $t = "w ";
      $t = "wc" if $3 eq "\\c";
      $indexing = 1 if $2;
      $w =~ s/\\\{/\{/g;
      $w =~ s/\\\}/\}/g;
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
      $w =~ s/\\\{/\{/g;
      $w =~ s/\\\}/\}/g;
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
	     $a =~ tr/A-Za-z0-9//cd;
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

sub write_texi {
  # This is called from the top level, so I won't bother using
  # my or local.

  # Open file.
  print "writing file...";
  open TEXT,">nasmdoc.texi";
  select TEXT;

  # Preamble.
  print "\\input texinfo   \@c -*-texinfo-*-\n";
  print "\@c \%**start of header\n";
  print "\@setfilename ",$metadata{'infofile'},".info\n";
  print "\@dircategory ",$metadata{'category'},"\n";
  print "\@direntry\n";
  printf "* %-28s %s.\n",
  sprintf('%s: (%s).', $metadata{'infoname'}, $metadata{'infofile'}),
  $metadata{'infotitle'};
  print "\@end direntry\n";
  print "\@settitle ", $metadata{'title'},"\n";
  print "\@setchapternewpage odd\n";
  print "\@c \%**end of header\n";
  print "\n";
  print "\@ifinfo\n";
  print $metadata{'summary'}, "\n";
  print "\n";
  print "Copyright ",$metadata{'year'}," ",$metadata{'author'},"\n";
  print "\n";
  print $metadata{'license'}, "\n";
  print "\@end ifinfo\n";
  print "\n";
  print "\@titlepage\n";
  $title = $metadata{'title'};
  $title =~ s/ - / --- /g;
  print "\@title ${title}\n";
  print "\@author ",$metadata{'author'},"\n";
  print "\n";
  print "\@page\n";
  print "\@vskip 0pt plus 1filll\n";
  print "Copyright \@copyright{} ",$metadata{'year'},' ',$metadata{'author'},"\n";
  print "\n";
  print $metadata{'license'}, "\n";
  print "\@end titlepage\n";
  print "\n";
  print "\@node Top, $tstruct_next{'Top'}, (dir), (dir)\n";
  print "\@top ",$metadata{'infotitle'},"\n";
  print "\n";
  print "\@ifinfo\n";
  print $metadata{'summary'}, "\n";
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
      print " $tstruct_up{$node}\n";
      $hdr = ($ptype eq "subh" ? "\@unnumberedsubsec" : "\@unnumberedsec");
      print "$hdr $title\n";
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
	my $x = $i;
        warn "code line longer than 68 chars: $i\n" if length $i > 68;
	$x =~ s/\\/\\\\/g;
	$x =~ s/\{/\\\{/g;
	$x =~ s/\}/\\\}/g;
        print "$x\\par\\sb0\n";
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
  substr($w,0,length($w)-1) =~ s/-/\\\'AD/g if $wmajt ne "x"; #nonbreakhyphens
  if ($wmajt eq "n" || $wtype eq "e " || $wtype eq "w ") {
    return $w;
  } elsif ($wtype eq "sp") {
    return ' ';
  } elsif ($wtype eq "da") {
    return "\\'96";
  } elsif ($wmajt eq "c" || $wtype eq "wc") {
    $w =~ s/ /\\\'A0/g; # make spaces non-breaking
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

#
# This produces documentation intermediate paragraph format; this is
# basically the digested output of the front end.  Intended for use
# by future backends, instead of putting it all in the same script.
#
sub write_dip {
  open(PARAS, "> nasmdoc.dip");
  foreach $k (keys(%metadata)) {
      print PARAS 'meta :', $k, "\n";
      print PARAS $metadata{$k},"\n";
  }
  for ($para = 0; $para <= $#pnames; $para++) {
      print PARAS $pflags[$para], "\n";
      print PARAS join("\037", @{$pnames[$para]}, "\n");
  }
  foreach $k (@itags) {
      print PARAS 'indx :', $k, "\n";
      print PARAS join("\037", @{$idxmap{$k}}), "\n";
  }
  close(PARAS);
}
