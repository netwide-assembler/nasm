
                    README
          NASM, the Netwide Assembler


 Changes from 0.98.07 release to 98.09b as of 28-Oct-2001
 ========================================================

1. More closely compatible with 0.98 when -O0 is implied 
or specified.  Not strictly identical, since backward 
branches in range of short offsets are recognized, and signed
byte values with no explicit size specification will be
assembled as a single byte.

2. More forgiving with the PUSH instruction.  0.98 requires
a size to be specified always.  0.98.09b will imply the size
from the current BITS setting (16 or 32).

3. Changed definition of the optimization flag:

	-O0	strict two-pass assembly, JMP and Jcc are
		handled more like 0.98, except that back-
		ward JMPs are short, if possible.

	-O1	strict two-pass assembly, but forward
		branches are assembled with code guaranteed
		to reach; may produce larger code than
		-O0, but will produce successful assembly
		more often if branch offset sizes are not
		specified.

	-O2	multi-pass optimization, minimize branch
		offsets; also will minimize signed immed-
		iate bytes, overriding size specification.

	-O3	like -O2, but more passes taken, if needed


 Changes from 0.98 release to 98.03 as of 27-Jul-2000
 ====================================================

1. Added signed byte optimizations for the 0x81/0x83 class
of instructions: ADC, ADD, AND, CMP, OR, SBB, SUB, XOR:
when used as 'ADD reg16,imm' or 'ADD reg32,imm.'  Also
optimization of signed byte form of 'PUSH imm' and 'IMUL
reg,imm'/'IMUL reg,reg,imm.'  No size specification is needed.

2. Added multi-pass JMP and Jcc offset optimization.  Offsets
on forward references will preferentially use the short form,
without the need to code a specific size (short or near) for
the branch.  Added instructions for 'Jcc label' to use the
form 'Jnotcc $+3/JMP label', in cases where a short offset
is out of bounds.  If compiling for a 386 or higher CPU, then
the 386 form of Jcc will be used instead.

This feature is controlled by a new command-line switch: "O",
(upper case letter O).  "-O0" reverts the assembler to no
extra optimization passes, "-O1" allows up to 5 extra passes,
and "-O2"(default), allows up to 10 extra optimization passes.

3. Added a new directive:  'cpu XXX', where XXX is any of: 
8086, 186, 286, 386, 486, 586, pentium, 686, PPro, P2, P3 or
Katmai.  All are case insensitive.  All instructions will
be selected only if they apply to the selected cpu or lower.
Corrected a couple of bugs in cpu-dependence in 'insns.dat'.

4. Added to 'standard.mac', the "use16" and "use32" forms of
the "bits 16/32" directive. This is nothing new, just conforms
to a lot of other assemblers. (minor)

5. Changed label allocation from 320/32 (10000 labels @ 200K+) 
to 32/37 (1000 labels); makes running under DOS much easier.
Since additional label space is allocated dynamically, this
should have no effect on large programs with lots of labels.
The 37 is a prime, believed to be better for hashing. (minor)

6. Integrated patchfile 0.98-0.98.01.  I call this version
0.98.03, for historical reasons:  0.98.02 was trashed.

--John Coffman <johninsd@san.rr.com>               27-Jul-2000

(end)