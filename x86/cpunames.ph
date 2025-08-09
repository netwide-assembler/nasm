# -*- perl -*-
#
# List of CPU names and their corresponding features
# A + means include the feature set for that CPU, otherwise this
# is the name of a base feature as defined in x86/features.ph.
#

use integer;
use strict;

our @cpufeatures;

#
# Format:
# c_(name, help text, feature set)
# The feature set can include any set of CPU features as defined in
# x86/features.ph, or "+cpu" to add all features present for "cpu"
# (which has to be already defined in this file!), or "-feature" to
# remove a feature.
#
# Dependent features (as defined in x86/x86features.ph) are automatically
# included as well.
#
# a_(name, original, help text)
# Indicate that "name" is an alias for "original"
# If "help text" is undef then the alias is hidden from help text
# and documentation.
#
# CPU and feature names are case insensitive and non-alphanumeric
# characters ignored.
#

# For legacy reasons FPU is always included
c_("8086",              "8086/8088 with optional 8087", qw(8086 8086only fpu undoc));
c_("186",               "80186/80188 with optional 8087", qw(+8086 -8086only 186));
c_("286",               "80286 with optional 80287", qw(+186 286 286only priv));
c_("386",               "80386 with optional 80387", qw(+286 -286only 386only));
c_("486",               "Early 486 without CPUID", qw(+386 -386only smm));
c_("486dx",             "486DX/487SX including CPUID", qw(+486 cpuid));
c_("486sx",             "486SX including CPUID, no FPU", qw(+486dx -fpu));
c_("586",              "Pentium P5/P54C", qw(+486dx pent));
a_("586", "pentium");
a_("586", "p5");
a_("586", "p54");
a_("586", "p54c");
c_("ia64",              "IA64 (in x86 mode)", qw(+pent jmpe));
a_("itanium", "ia64");
a_("itanic", "ia64");
a_("merced", "ia64");
c_("pentiummmx",        "Pentium MMX (P55C)", qw(+pent mmx));
a_("p55", "pentiummmx");
a_("p55c", "pentiummmx");
c_("p6",                "Pentium Pro", qw(+pentiumpro cmov));
c_("pentiumpro",        "Pentium Pro", qw(+pent p6 cmov));
# Some Pentium II steppings had fxsave support in anticipation of Pentium III
c_("pentiumii",         "Pentium II", qw(+p6 mmx sysenter fxsave));
a_("pentiumii", "pentium2");
a_("pentiumii", "p2");
c_("katmai",            "Pentium III", qw(+pentium2 sse));
a_("katmai", "pentiumiii");
a_("katmai", "pentium3");
a_("katmai", "p3");
c_("pentiumm", "Pentium M", qw(+katmai sse2));
a_("pentiumm", "pm");
a_("pentiumm", "centrino");
# c_("k6",                "AMD K6", qw(+pentiumii syscall 3dnow));
# c_("k7",                "AMD K7 (Athlon)", qw(+katmai syscall 3dnow));
c_("willamette",        "Intel Willamette", qw(+katmai sse2 willamette));
a_("willamette", "pentium4");
c_("prescott",          "Intel Prescott", qw(+willamette prescott sse3));
# For historical reasons this includes LOCKREX
c_("x86-64-v1",         "x86-64 level 1", qw(+willamette x86-64 sse2 lockrex));
a_("x86-64-v1", "x64-1");
# Legacy definition
c_("x86-64",            "Early x86-64 CPUs", qw(+x86-64-v1 cx16 lahf_lm sse3));
a_("x64", "x86-64");
c_("x86-64-v2",         "x86-64 level 2", qw(+x86-64-v1 cx16 lahf_lm popcnt sse4.2"));
a_("x86-64-v2", "x64-2");
c_("x86-64-v3",         "x86-64 level 3", qw(+x86-64-v2 avx2 vmi2 f16c lzcnt movbe xsave));
a_("x86-64-v3", "x64-3");
c_("x86-64-v4",         "x86-64 level 4", qw(+x86-64-v3 avx512f avx512bw avx512cd avx512dq avx512vl));
a_("x86-64-v4", "x64-4");
c_("core2",             qw(+x86-64-v1 +prescott cx16 lahf_lm ssse3));
c_("nehalem",           "Intel Nehalem", qw(+core2 nehalem sse4.2 popcnt));
a_("nehalem", "corei7");
c_("westmere",          "Intel Westmere", qw(+nehalem westmere pclmul));
c_("sandybridge",       "Intel Sandy Bridge", qw(+westmere sandybridge avx xsave));
c_("ivybridge",         "Intel Ivy Bridge", qw(+sandybridge fsgsbase rdrand f16c));
c_("haswell",           "Intel Haswell", qw(+ivybridge avx2 bmi1 bmi2 lzcnt fma movbe hle));
c_("broadwell",         "Intel Broadwell", qw(+haswell rdseed adcx prefetchw));
c_("skylake",           "Intel Skylake", qw(+broadwell aes clflushopt xsavec xsaves sgx));

c_('any',		"Enable all known CPU features",
   map { $_->{'name'} } @cpufeatures);
a_("any", "all");
c_("default",           "Default CPU feature set", qw(+any -superceded -lateavx));

1;
