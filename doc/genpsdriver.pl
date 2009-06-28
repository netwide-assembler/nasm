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
# Runs the equivalent of the following command line:
#
#       $(PERL) $(srcdir)/genps.pl -subtitle "version `cat ../version`" \
#                nasmdoc.dip
#
# This is implemented as a Perl script since `cat ...` doesn't
# necessarily work on non-Unix systems.
#

use File::Spec;
use Fcntl;
use Env;

$perl   = $ENV{PERL}   || 'perl';
$srcdir = $ENV{srcdir} || File::Spec->curdir();

$versionfile = File::Spec->catfile($srcdir, File::Spec->updir(), 'version');
$genps = File::Spec->catfile($srcdir, 'genps.pl');

sysopen(VERSION, $versionfile, O_RDONLY)
    or die "$0: cannot open $versionfile\n";
$version = <VERSION>;
chomp $version;
close(VERSION);

# \240 = no-break space, see @NASMEncoding in genps.pl.
# If we use a normal space, it breaks on 'doze platforms...
system($perl, $genps, '-subtitle', "version\240".$version,
       @ARGV, 'nasmdoc.dip');
