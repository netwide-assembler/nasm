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
require 'metrics/phvr8a.ph';	# Helvetica
require 'metrics/phvro8a.ph';	# Helvetica-Oblique
require 'metrics/phvb8a.ph';	# Helvetica-Bold
require 'metrics/phvbo8a.ph';	# Helvetica-BoldOblique

# The fonts we want to use for various things
# The order is: <normal> <emphatic> <code>

if ( 1 ) {
    # Times family fonts

    %TitlFont = (name => 'tfont',
		 leading => 24,
	     fonts => [[20,\%PS_Times_Bold],
		       [20,\%PS_Times_BoldItalic],
		       [20,\%PS_Courier_Bold]]);
    %ChapFont = (name => 'cfont',
		 leading => 21.6,
		 fonts => [[18,\%PS_Times_Bold],
			   [18,\%PS_Times_BoldItalic],
			   [18,\%PS_Courier_Bold]]);
    %HeadFont = (name => 'hfont',
		 leading => 16.8,
		 fonts => [[14,\%PS_Times_Bold],
			   [14,\%PS_Times_BoldItalic],
			   [14,\%PS_Courier_Bold]]);
    %SubhFont = (name => 'sfont',
		 leading => 14.4,
		 fonts => [[12,\%PS_Times_Bold],
			   [12,\%PS_Times_BoldItalic],
			   [12,\%PS_Courier_Bold]]);
    %BodyFont = (name => 'bfont',
		 leading => 12,
		 fonts => [[10,\%PS_Times_Roman],
			   [10,\%PS_Times_Italic],
			   [10,\%PS_Courier]]);
} elsif ( 0 ) {
    # Helvetica family fonts

    %TitlFont = (name => 'tfont',
		 leading => 24,
		 fonts => [[20,\%PS_Helvetica_Bold],
			   [20,\%PS_Helvetica_BoldOblique],
			   [20,\%PS_Courier_Bold]]);
    %ChapFont = (name => 'cfont',
		 leading => 21.6,
		 fonts => [[18,\%PS_Helvetica_Bold],
			   [18,\%PS_Helvetica_BoldOblique],
			   [18,\%PS_Courier_Bold]]);
    %HeadFont = (name => 'hfont',
		 leading => 16.8,
		 fonts => [[14,\%PS_Helvetica_Bold],
			   [14,\%PS_Helvetica_BoldOblique],
			   [14,\%PS_Courier_Bold]]);
    %SubhFont = (name => 'sfont',
		 leading => 14.4,
		 fonts => [[12,\%PS_Helvetica_Bold],
			   [12,\%PS_Helvetica_BoldOblique],
			   [12,\%PS_Courier_Bold]]);
    %BodyFont = (name => 'bfont',
		 leading => 12,
		 fonts => [[10,\%PS_Helvetica],
			   [10,\%PS_Helvetica_Oblique],
			   [10,\%PS_Courier]]);
} else {
    # Body text Times; headings Helvetica
    %TitlFont = (name => 'tfont',
		 leading => 24,
		 fonts => [[20,\%PS_Helvetica_Bold],
			   [20,\%PS_Helvetica_BoldOblique],
			   [20,\%PS_Courier_Bold]]);
    %ChapFont = (name => 'cfont',
		 leading => 21.6,
		 fonts => [[18,\%PS_Helvetica_Bold],
			   [18,\%PS_Helvetica_BoldOblique],
			   [18,\%PS_Courier_Bold]]);
    %HeadFont = (name => 'hfont',
		 leading => 16.8,
		 fonts => [[14,\%PS_Helvetica_Bold],
			   [14,\%PS_Helvetica_BoldOblique],
			   [14,\%PS_Courier_Bold]]);
    %SubhFont = (name => 'sfont',
		 leading => 14.4,
		 fonts => [[12,\%PS_Helvetica_Bold],
			   [12,\%PS_Helvetica_BoldOblique],
			   [12,\%PS_Courier_Bold]]);
    %BodyFont = (name => 'bfont',
		 leading => 12,
		 fonts => [[10,\%PS_Times_Roman],
			   [10,\%PS_Times_Italic],
			   [10,\%PS_Courier]]);
}

#
# List of all fontsets; used to compute the list of fonts needed
#
@AllFonts = ( \%TitlFont, \%ChapFont, \%HeadFont, \%SubhFont, \%BodyFont );

# OK
1;
