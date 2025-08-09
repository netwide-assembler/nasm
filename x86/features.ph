
f_("VEX",  "VEX or XOP encoded instruction");
f_("EVEX", "EVEX encoded instruction", qw(PROT));

#
# Encoding formats that can be set with the CPU directive
#
#
# Modes and attributes
#
f_("OBSOLETE",           "Instruction removed from architecture");
f_("NEVER",              "Instruction never implemented", qw(obsolete));
f_("NOP",                "Non-explicit noop instructions");
f_("PRIV",               "Privileged instruction", qw(prot));
f_("PROT",               "Protected mode only");
f_("SMM",                "System management mode only");
f_("LONG",               "Long mode only", qw(x86-64));
f_("VIRTUAL",            "Virtual instructions");
f_("UNDOC",              "Undocumented instructions");
f_("VENDOR",             "Vendor-specific instructions");
f_("SUPERCEDED",         "Instruction opcode has been reused");
f_("APX",                "Advanced Performance Extensions", qw(long));
f_("APX_F",              "Advanced Performance Extensions (APX) base set");

f_("FPU",                "x87 floating-point instructions");
f_("MMX",                "MMX", qw(FPU));
f_("MMXEXT",             "MMX extension SSE subset", qw(MMX));
f_("3DNOW",              "3DNow!", qw(MMXEXT));
f_("SSE",                "SSE (KNI, MMX2)", qw(MMXEXT));
f_("SSE2",               "SSE2", qw(SSE));
f_("SSE3",               "SSE3 (PNI)", qw(SSE2));
f_("VMX",                "VMX");
f_("SSSE3",              "SSSE3", qw(SSE3));
f_("SSE4A",              "AMD SSE4a", qw(SSE3));
f_("SSE4.1",             "SSE4.1", qw(SSSE3));
f_("SSE4.2",             "SSE4.2", qw(SSE4.1));
f_("SSE5",               "SSE5", qw(SSE4.2));
f_("LAHF_LM",            "LAHF/SAHF in long mode");
f_("LOCKREX",            "LOCK as REX.R in 16/32-bit mode");
f_("CX16",               "CMPXCHG16B");
f_("AVX",                "AVX  (256-bit floating point)", qw(VEX SSSE3));
f_("AVX2",               "AVX2 (256-bit integer)", qw(AVX));
f_("FMA",                "Fused multiply-add", qw(AVX));
f_("BMI1",               "Bit manipulation instructions 1");
f_("BMI2",               "Bit manipulation instructions 2", qw(bmi1));
f_("TBM",                "");
f_("RTM",                "");
f_("AVX512",             "AVX-512 instructions");
f_("AVX512F",            "AVX-512F (base architecture)", qw(EVEX));
f_("AVX512CD",           "AVX-512 Conflict Detection", qw(AVX512F));
f_("AVX512ER",           "AVX-512 Exponential and Reciprocal", qw(AVX512F));
f_("AVX512PF",           "AVX-512 Prefetch");
f_("MPX",                "Memory protection extension", qw(obsolete));
f_("SHA",                "SHA instructions");
f_("AVX512VL",           "AVX-512 Vector Length Orthogonality", qw(AVX512F));
f_("AVX512DQ",           "AVX-512 Dword and Qword", qw(AVX512F));
f_("AVX512BW",           "AVX-512 Byte and Word", qw(AVX512F));
f_("AVX512IFMA",         "AVX-512 IFMA instructions");
f_("AVX512VBMI",         "AVX-512 VBMI instructions");
f_("AES",                "AES instructions");
f_("VAES",               "AES AVX instructions", qw(AES AVX));
f_("VPCLMULQDQ",         "AVX Carryless Multiplication");
f_("GFNI",               "Galois Field instructions");
f_("AVX512VBMI2",        "AVX-512 VBMI2 instructions");
f_("AVX512VNNI",         "AVX-512 VNNI instructions");
f_("AVX512BITALG",       "AVX-512 Bit Algorithm instructions");
f_("AVX512VPOPCNTDQ",    "AVX-512 VPOPCNTD/VPOPCNTQ");
f_("AVX5124FMAPS",       "AVX-512 4-iteration multiply-add");
f_("AVX5124VNNIW",       "AVX-512 4-iteration dot product");
f_("AVX512FP16",         "AVX-512 FP16 instructions");
f_("AVX512FC16",         "AVX-512 FC16 instructions");
f_("SGX",                "Intel Software Guard Extensions (SGX)");
f_("CET",                "Intel Control-Flow Enforcement Technology (CET)");
f_("ENQCMD",             "Enqueue command instructions");
f_("TSXLDTRK",           "TSX suspend load address tracking");
f_("AVX512BF16",         "AVX-512 bfloat16");
f_("AVX512VP2INTERSECT", "AVX-512 VP2INTERSECT instructions");
f_("AMXTILE",            "AMX tile configuration instructions", qw(AMXTILE));
f_("AMXBF16",            "AMX bfloat16 multiplication", qw(AMXTILE));
f_("AMXINT8",            "AMX 8-bit integer multiplication", qw(AMXTILE));
f_("FRED",               "Flexible Return and Exception Delivery (FRED)", qw(lkgs));
f_("RAOINT",		 "Remote atomic operations (RAO-INT)");
f_("UINTR",		 "User interrupts");
f_("CMPCCXADD",          "CMPccXADD instructions");
f_("PREFETCHI",          "PREFETCHI0 and PREFETCHI1 instructions");
f_("MSRLIST",            "RDMSRLIST and WRMSRLIST instructions");
f_("AVXNECONVERT",	 "AVX exceptionless floating-point conversions");
f_("AVXVNNIINT8",        "AVX Vector Neural Network 8-bit integer instructions");
f_("AVXIFMA",            "AVX integer multiply and add");
f_("LATEAVX",            "Instructions first added as EVEX encoded; VEX added later");
f_("HRESET",             "History reset");
f_("SMAP",		 "Supervisor Mode Access Prevention (SMAP)");
f_("SHA512",             "SHA512 instructions");
f_("HSM3",               "SM3 hash instructions");
f_("HSM4",               "SM4 hash instructions");
f_("AVX10.1",            "AVX 10.1 instructions", qw(avx2));
f_("AVX10.2",            "AVX 10.2 instructions", qw(avx10.1));
f_("ADX",                "ADCX and ADOX instructions");
f_("PKU",		 "Protection key for user mode");
f_("MONITOR",		 "MONITOR and MWAIT instructions");
f_("MONITORX",		 "MONITORX and MWAITX instructions");
f_("WAITPKG",            "User wait instructions package");

#
# Single-instruction flags without special help text
#
map { f_($_) }
qw(cpuid invpcid prefetchwt1 pconfig wbnoinvd serialize
   wrmsrns clflushopt clwb rdrand rdseed rdpid
   lzcnt ptwrite cldemote movdiri movdir64b clzero
   movbe fcomi lkgs jmpe);
d_('rdseed', 'rdrand');
d_('jmpe', 'virtual');

f_("8086only",          "8086/8088 only instructions", qw(8086 obsolete));
f_("286only",           "80286 only instructions", qw(286 obsolete));
f_("386only",           "80386 only instructions", qw(386 obsolete));

f_("8087",              "8087 floating-point instructions", qw(8086 fpu));
f_("287",               "80287 floating-point instructions", qw(286 fpu));
f_("387",               "80387 floating-point instructions", qw(386 fpu));

f_("8086",              "8086/8088 base features");
f_("186",               "80186/80188 base features", qw(8086));
f_("286",               "80286 base features", qw(186));
f_("386",               "80386 base features", qw(286));
f_("486",               "486 family base instructions", qw(386));
f_("PENT",              "Pentium (P5) instructions", qw(486 fpu cpuid));
f_("P6",                "P6 (Pentium Pro)", qw(pent fcomi));
f_("KATMAI",            "Katmai (Pentium III) instructions", qw(p6 mmx sse));
f_("WILLAMETTE",        "Willamette instructions", qw(katmai));
f_("PRESCOTT",          "Prescott instructions", qw(prescott));
f_("X86-64",            "x86-64 base feature set", qw(prescott fpu syscall));
f_("NEHALEM",           "Nehalem instructions", qw(x64));
f_("WESTMERE",          "Westmere instructions", qw(nehalem));
f_("SANDYBRIDGE",       "Sandy Bridge instructions", qw(westmere));
f_("FUTURE",            "Ivy Bridge or newer instructions", qw(sandybridge));
