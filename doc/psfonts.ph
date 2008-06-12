#!/usr/bin/perl
#
# Font metrics for the PS code generator
#

# These files are generated from AFM files
require 'metrics/ptmr8a.ph';	# Times-Roman
require 'metrics/ptmb8a.ph';	# Times-Bold
require 'metrics/ptmri8a.ph';	# Times-Italic
require 'metrics/ptmbi8a.ph';	# Times-BoldItalic
require 'metrics/pcrr8a.ph';	# Courier
require 'metrics/pcrb8a.ph';	# Courier-Bold
require 'metrics/phvb8a.ph';	# Helvetica-Bold
require 'metrics/phvbo8a.ph';	# Helvetica-BoldOblique

# The fonts we want to use for various things
# The order is: <normal> <emphatic> <code>

%TitlFont = (name => 'tfont',
	     leading => 22,
	     fonts => [[20,\%PS_Times_Bold],
		       [20,\%PS_Times_BoldItalic],
		       [20,\%PS_Courier_Bold]]);
%ChapFont = (name => 'cfont',
             leading => 19.2,
	     fonts => [[18,\%PS_Times_Bold],
		       [18,\%PS_Times_BoldItalic],
		       [18,\%PS_Courier_Bold]]);
%HeadFont = (name => 'hfont',
	     leading => 15.4,
	     fonts => [[14,\%PS_Times_Bold],
		       [14,\%PS_Times_BoldItalic],
		       [14,\%PS_Courier_Bold]]);
%SubhFont = (name => 'sfont',
	     leading => 13.2,
	     fonts => [[12,\%PS_Times_Bold],
		       [12,\%PS_Times_BoldItalic],
		       [12,\%PS_Courier_Bold]]);
%BodyFont = (name => 'bfont',
	     leading => 11,
	     fonts => [[10,\%PS_Times_Roman],
		       [10,\%PS_Times_Italic],
		       [10,\%PS_Courier]]);

#
# List of all fontsets; used to compute the list of fonts needed
#
@AllFonts = ( \%TitlFont, \%ChapFont, \%HeadFont, \%SubhFont, \%BodyFont );

# OK
1;
