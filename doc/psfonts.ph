#!/usr/bin/perl
#
# Font metrics for the PS code generator
#

# These files are generated from AFM files
require 'metrics/ptmr8a.ph';	# Times-Roman
require 'metrics/ptmri8a.ph';	# Times-Italic
require 'metrics/pcrr8a.ph';	# Courier
require 'metrics/pcrb8a.ph';	# Courier-Bold
require 'metrics/phvb8a.ph';	# Helvetica-Bold
require 'metrics/phvbo8a.ph';	# Helvetica-BoldOblique

# The fonts we want to use for various things
# The order is: <normal> <emphatic> <code>

%ChapFont = (name => 'cfont',
             leading => 18,
	     fonts => [[18,\%PS_Helvetica_Bold],
		       [18,\%PS_Helvetica_BoldOblique],
		       [18,\%PS_Courier_Bold]]);
%HeadFont = (name => 'hfont',
	     leading => 14,
	     fonts => [[14,\%PS_Helvetica_Bold],
		       [14,\%PS_Helvetica_BoldOblique],
		       [14,\%PS_Courier_Bold]]);
%SubhFont = (name => 'sfont',
	     leading => 12,
	     fonts => [[12,\%PS_Helvetica_Bold],
		       [12,\%PS_Helvetica_BoldOblique],
		       [12,\%PS_Courier_Bold]]);
%TextFont = (name => 'tfont',
	     leading => 11,
	     fonts => [[11,\%PS_Times_Roman],
		       [11,\%PS_Times_Italic],
		       [11,\%PS_Courier]]);

#
# List of all fontsets; used to compute the list of fonts needed
#
@AllFonts = ( \%ChapFont, \%HeadFont, \%SubhFont, \%TextFont );

# OK
1;
