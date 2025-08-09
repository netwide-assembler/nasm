# -*- perl -*-

#
# dword bound, index 0 - instruction generation flags;
# not part of the instruction feature mask
#
if_align('IGEN', $NOBREAK);

# The following MUST be in word 0
if_("SM0",               "Size match operand 0");
if_("SM1",               "Size match operand 1");
if_("SM2",               "Size match operand 2");
if_("SM3",               "Size match operand 3");
if_("SM4",               "Size match operand 4");
if_("AR0",               "SB, SW, SD applies to operand 0");
if_("AR1",               "SB, SW, SD applies to operand 1");
if_("AR2",               "SB, SW, SD applies to operand 2");
if_("AR3",               "SB, SW, SD applies to operand 3");
if_("AR4",               "SB, SW, SD applies to operand 4");
# These must match the order of the BITSx flags in opflags.h
# Are these obsolete?
if_("SB",                "Unsized operands can't be non-byte");
if_("SW",                "Unsized operands can't be non-word");
if_("SD",                "Unsized operands can't be non-dword");
if_("SQ",                "Unsized operands can't be non-qword");
if_("ST",                "Unsized operands can't be non-tword");
if_("SO",                "Unsized operands can't be non-oword");
if_("SY",                "Unsized operands can't be non-yword");
if_("SZ",                "Unsized operands can't be non-zword");
# End BITSx order match requirement
if_("NWSIZE",            "Operand size defaults to 64 in 64-bit mode");
if_("OSIZE",             "Unsized operands must match the default operand size");
if_("ASIZE",             "Unsized operands must match the address size");
if_("ANYSIZE",           "Ignore operand size even if explicit");
if_("SX",                "Unsized operands not allowed");
if_("SDWORD",		 "Strict sdword64 matching");
if_break_ok();

if_("PSEUDO",            "Pseudo-instruction (directive)");
if_("JMP_RELAX",         "Relaxable jump instruction");
if_("OPT",               "Optimizing assembly only");
if_("LATEVEX",           "Only if EVEX instructions are disabled");
if_("NOREX",             "Instruction does not support REX encoding");
if_("NOAPX",             "Instruction does not support APX registers or REX2");
if_("NF",                "Instruction supports the {nf} prefix");
if_("NF_R",              "Instruction requires the {nf} prefix");
if_("NF_E",              "EVEX.NF set with {nf} prefix");
if_("ZU",                "Instruction supports the {zu} prefix");
if_("ZU_R",              "Instruction requires the {zu} prefix");
if_("ZU_E",              "EVEX.ND set with {zu} prefix");
if_("LIG",               "Ignore VEX/EVEX L field");
if_("WIG",               "Ignore VEX/EVEX W field");
if_("WW",                "VEX/EVEX W is REX.W");
if_("SIB",               "SIB encoding required");
if_("LOCK",              "Lockable if operand 0 is memory");
if_("LOCK1",             "Lockable if operand 1 is memory");
if_("NOLONG",            "Not available in long mode");
if_("NOHLE",             "HLE prefixes forbidden");
if_("MIB",               "split base/index EA");
if_("BND",               "BND (0xF2) prefix available");
if_("REX2",              "REX2 encoding required");
if_("HLE",               "HLE prefixed");
if_("FL",                "Instruction modifies the flags");

#
# Special immediates types like {dfv=}
# Used to detect incorrect usage and for the disassembler.
#
if_("DFV",               "Destination flag values");

#
# dword bound - instruction feature filtering flags (from x86features.ph)
#
if_align('FEATURE');

require 'x86/x86features.ph';

our @cpufeatures;

foreach my $feat (@cpufeatures) {
    if_($feat->{'cname'}, $feat->{'help'});
}

1;
