/* assemble.c   code generation for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * the actual codes (C syntax, i.e. octal):
 * \0            - terminates the code. (Unless it's a literal of course.)
 * \1, \2, \3    - that many literal bytes follow in the code stream
 * \4, \6        - the POP/PUSH (respectively) codes for CS, DS, ES, SS
 *                 (POP is never used for CS) depending on operand 0
 * \5, \7        - the second byte of POP/PUSH codes for FS, GS, depending
 *                 on operand 0
 * \10, \11, \12 - a literal byte follows in the code stream, to be added
 *                 to the register value of operand 0, 1 or 2
 * \17           - encodes the literal byte 0. (Some compilers don't take
 *                 kindly to a zero byte in the _middle_ of a compile time
 *                 string constant, so I had to put this hack in.)
 * \14, \15, \16 - a signed byte immediate operand, from operand 0, 1 or 2
 * \20, \21, \22 - a byte immediate operand, from operand 0, 1 or 2
 * \24, \25, \26 - an unsigned byte immediate operand, from operand 0, 1 or 2
 * \30, \31, \32 - a word immediate operand, from operand 0, 1 or 2
 * \34, \35, \36 - select between \3[012] and \4[012] depending on 16/32 bit
 *                 assembly mode or the address-size override on the operand
 * \37           - a word constant, from the _segment_ part of operand 0
 * \40, \41, \42 - a long immediate operand, from operand 0, 1 or 2
 * \50, \51, \52 - a byte relative operand, from operand 0, 1 or 2
 * \60, \61, \62 - a word relative operand, from operand 0, 1 or 2
 * \64, \65, \66 - select between \6[012] and \7[012] depending on 16/32 bit
 *                 assembly mode or the address-size override on the operand
 * \70, \71, \72 - a long relative operand, from operand 0, 1 or 2
 * \1ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field the register value of operand b.
 * \2ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field equal to digit b.
 * \30x          - might be an 0x67 byte, depending on the address size of
 *                 the memory reference in operand x.
 * \310          - indicates fixed 16-bit address size, i.e. optional 0x67.
 * \311          - indicates fixed 32-bit address size, i.e. optional 0x67.
 * \320          - indicates fixed 16-bit operand size, i.e. optional 0x66.
 * \321          - indicates fixed 32-bit operand size, i.e. optional 0x66.
 * \322          - indicates that this instruction is only valid when the
 *                 operand size is the default (instruction to disassembler,
 *                 generates no code in the assembler)
 * \330          - a literal byte follows in the code stream, to be added
 *                 to the condition code value of the instruction.
 * \331		 - instruction not valid with REP prefix.  Hint for
 *                 disassembler only; for SSE instructions.
 * \332		 - disassemble a rep (0xF3 byte) prefix as repe not rep.
 * \333		 - REP prefix (0xF3 byte); for SSE instructions.  Not encoded
 *		   as a literal byte in order to aid the disassembler.
 * \340          - reserve <operand 0> bytes of uninitialised storage.
 *                 Operand 0 had better be a segmentless constant.
 */

#include <stdio.h>
#include <string.h>

#include "nasm.h"
#include "nasmlib.h"
#include "assemble.h"
#include "insns.h"

extern struct itemplate *nasm_instructions[];

typedef struct {
    int sib_present;		       /* is a SIB byte necessary? */
    int bytes;			       /* # of bytes of offset needed */
    int size;			       /* lazy - this is sib+bytes+1 */
    unsigned char modrm, sib;	       /* the bytes themselves */
} ea;

static efunc errfunc;
static struct ofmt *outfmt;
static ListGen *list;

static long calcsize (long, long, int, insn *, char *);
static void gencode (long, long, int, insn *, char *, long);
static int  regval (operand *o);
static int  matches (struct itemplate *, insn *);
static ea * process_ea (operand *, ea *, int, int, int);
static int  chsize (operand *, int);

/*
 * This routine wrappers the real output format's output routine,
 * in order to pass a copy of the data off to the listing file
 * generator at the same time.
 */
static void out (long offset, long segto, void *data, unsigned long type,
		 long segment, long wrt) 
{
    static long lineno;
    static char *lnfname;

    if ((type & OUT_TYPMASK) == OUT_ADDRESS) {
	if (segment != NO_SEG || wrt != NO_SEG) {
	    /*
	     * This address is relocated. We must write it as
	     * OUT_ADDRESS, so there's no work to be done here.
	     */
	    list->output (offset, data, type);
	} 
	else {
	    unsigned char p[4], *q = p;
	    /*
	     * This is a non-relocated address, and we're going to
	     * convert it into RAWDATA format.
	     */
	    if ((type & OUT_SIZMASK) == 4) {
		WRITELONG (q, * (long *) data);
		list->output (offset, p, OUT_RAWDATA+4);
	    } 
	    else {
		WRITESHORT (q, * (long *) data);
		list->output (offset, p, OUT_RAWDATA+2);
	    }
	}
    } 
    else if ((type & OUT_TYPMASK) == OUT_RAWDATA) {
	list->output (offset, data, type);
    } 
    else if ((type & OUT_TYPMASK) == OUT_RESERVE) {
	list->output (offset, NULL, type);
    } 
    else if ((type & OUT_TYPMASK) == OUT_REL2ADR ||
	       (type & OUT_TYPMASK) == OUT_REL4ADR) {
	list->output (offset, data, type);
    }

    if (src_get(&lineno,&lnfname))
	outfmt->current_dfmt->linenum(lnfname,lineno,segto);

    outfmt->output (segto, data, type, segment, wrt);
}

long assemble (long segment, long offset, int bits,
	       insn *instruction, struct ofmt *output, efunc error,
	       ListGen *listgen) 
{
    struct itemplate *temp;
    int    j;
    int    size_prob;
    long   insn_end;
    long   itimes;
    long   start = offset;
    long   wsize = 0;		       /* size for DB etc. */

    errfunc = error;		       /* to pass to other functions */
    outfmt = output;		       /* likewise */
    list = listgen;		       /* and again */

    switch (instruction->opcode) 
    {
	case   -1: return 0;
	case I_DB: wsize = 1; break;
	case I_DW: wsize = 2; break;
	case I_DD: wsize = 4; break;
	case I_DQ: wsize = 8; break;
	case I_DT: wsize = 10; break;
    }

    if (wsize) {
	extop  * e;
	long   t = instruction->times;
	if (t < 0)
	    errfunc(ERR_PANIC, "instruction->times < 0 (%ld) in assemble()",t);

	while (t--) 		       /* repeat TIMES times */
	{
	    for (e = instruction->eops; e; e = e->next) 
	    {
		if (e->type == EOT_DB_NUMBER) 
		{
		    if (wsize == 1) {
			if (e->segment != NO_SEG)
			    errfunc (ERR_NONFATAL,
				     "one-byte relocation attempted");
			else {
			    unsigned char out_byte = e->offset;
			    out (offset, segment, &out_byte, OUT_RAWDATA+1,
				 NO_SEG, NO_SEG);
			}
		    } 
		    else if (wsize > 5) {
			errfunc (ERR_NONFATAL, "integer supplied to a D%c"
				 " instruction", wsize==8 ? 'Q' : 'T');
		    } 
		    else
			out (offset, segment, &e->offset,
			     OUT_ADDRESS+wsize, e->segment,
			     e->wrt);
		    offset += wsize;
		} 
		else if (e->type == EOT_DB_STRING) 
		{
		    int align;

		    out (offset, segment, e->stringval,
			 OUT_RAWDATA+e->stringlen, NO_SEG, NO_SEG);
		    align = e->stringlen % wsize;

		    if (align) {
			align = wsize - align;
			out (offset, segment, "\0\0\0\0\0\0\0\0",
			     OUT_RAWDATA+align, NO_SEG, NO_SEG);
			}
		    offset += e->stringlen + align;
		}
	    }
	    if (t > 0 && t == instruction->times-1) 
	    {
		/*
		 * Dummy call to list->output to give the offset to the
		 * listing module.
		 */
		list->output (offset, NULL, OUT_RAWDATA);
		list->uplevel (LIST_TIMES);
	    }
	}
	if (instruction->times > 1)
	    list->downlevel (LIST_TIMES);
	return offset - start;
    }

    if (instruction->opcode == I_INCBIN) 
    {
	static char fname[FILENAME_MAX];
	FILE        * fp;
	long        len;

	len = FILENAME_MAX-1;
	if (len > instruction->eops->stringlen)
	    len = instruction->eops->stringlen;
	strncpy (fname, instruction->eops->stringval, len);
	fname[len] = '\0';

	if ( (fp = fopen(fname, "rb")) == NULL)
	    error (ERR_NONFATAL, "`incbin': unable to open file `%s'", fname);
	else if (fseek(fp, 0L, SEEK_END) < 0)
	    error (ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
		   fname);
	else 
	{
	    static char buf[2048];
	    long t = instruction->times;
	    long base = 0;

	    len = ftell (fp);
	    if (instruction->eops->next) {
		base = instruction->eops->next->offset;
		len -= base;
		if (instruction->eops->next->next &&
		    len > instruction->eops->next->next->offset)
		    len = instruction->eops->next->next->offset;
	    }
	    /*
	     * Dummy call to list->output to give the offset to the
	     * listing module.
	     */
	    list->output (offset, NULL, OUT_RAWDATA);
	    list->uplevel(LIST_INCBIN);
	    while (t--) 
	    {
		long l;

		fseek (fp, base, SEEK_SET);		
		l = len;
		while (l > 0) {
		    long m = fread (buf, 1, (l>sizeof(buf)?sizeof(buf):l),
				    fp);
		    if (!m) {
			/*
			 * This shouldn't happen unless the file
			 * actually changes while we are reading
			 * it.
			 */
			error (ERR_NONFATAL, "`incbin': unexpected EOF while"
			       " reading file `%s'", fname);
			t=0;  /* Try to exit cleanly */
			break;
		    }
		    out (offset, segment, buf, OUT_RAWDATA+m,
			 NO_SEG, NO_SEG);
		    l -= m;
		}
	    }
	    list->downlevel(LIST_INCBIN);
	    if (instruction->times > 1) {
		/*
		 * Dummy call to list->output to give the offset to the
		 * listing module.
		 */
		list->output (offset, NULL, OUT_RAWDATA);
		list->uplevel(LIST_TIMES);
		list->downlevel(LIST_TIMES);
	    }
	    fclose (fp);
	    return instruction->times * len;
	}
	return 0;		       /* if we're here, there's an error */
    }

    size_prob = FALSE;
    temp = nasm_instructions[instruction->opcode];
    while (temp->opcode != -1) {
	int m = matches (temp, instruction);

	if (m == 100) 		       /* matches! */
	{
	    char *codes = temp->code;
	    long insn_size = calcsize(segment, offset, bits,
				      instruction, codes);
	    itimes = instruction->times;
	    if (insn_size < 0)	       /* shouldn't be, on pass two */
	    	error (ERR_PANIC, "errors made it through from pass one");
	    else while (itimes--) {
		insn_end = offset + insn_size;
		for (j=0; j<instruction->nprefix; j++) {
		    unsigned char c=0;
		    switch (instruction->prefixes[j]) {
		      case P_LOCK:
			c = 0xF0; break;
		      case P_REPNE: case P_REPNZ:
			c = 0xF2; break;
		      case P_REPE: case P_REPZ: case P_REP:
			c = 0xF3; break;
		      case R_CS: c = 0x2E; break;
		      case R_DS: c = 0x3E; break;
		      case R_ES: c = 0x26; break;
		      case R_FS: c = 0x64; break;
		      case R_GS: c = 0x65; break;
		      case R_SS: c = 0x36; break;
		      case P_A16:
			if (bits != 16)
			    c = 0x67;
			break;
		      case P_A32:
			if (bits != 32)
			    c = 0x67;
			break;
		      case P_O16:
			if (bits != 16)
			    c = 0x66;
			break;
		      case P_O32:
			if (bits != 32)
			    c = 0x66;
			break;
		      default:
			error (ERR_PANIC,
			       "invalid instruction prefix");
		    }
		    if (c != 0) {
			out (offset, segment, &c, OUT_RAWDATA+1,
			     NO_SEG, NO_SEG);
			offset++;
		    }
		}
		gencode (segment, offset, bits, instruction, codes, insn_end);
		offset += insn_size;
		if (itimes > 0 && itimes == instruction->times-1) {
		    /*
		     * Dummy call to list->output to give the offset to the
		     * listing module.
		     */
		    list->output (offset, NULL, OUT_RAWDATA);
		    list->uplevel (LIST_TIMES);
		}
	    }
	    if (instruction->times > 1)
		list->downlevel (LIST_TIMES);
	    return offset - start;
	} else if (m > 0) {
	    size_prob = m;
	}
	temp++;
    }

    if (temp->opcode == -1) {	       /* didn't match any instruction */
	if (size_prob == 1)	       /* would have matched, but for size */
	    error (ERR_NONFATAL, "operation size not specified");
	else if (size_prob == 2)
	    error (ERR_NONFATAL, "mismatch in operand sizes");
	else
	    error (ERR_NONFATAL,
		   "invalid combination of opcode and operands");
    }
    return 0;
}

long insn_size (long segment, long offset, int bits,
		insn *instruction, efunc error) 
{
    struct itemplate *temp;

    errfunc = error;		       /* to pass to other functions */

    if (instruction->opcode == -1)
    	return 0;

    if (instruction->opcode == I_DB ||
	instruction->opcode == I_DW ||
	instruction->opcode == I_DD ||
	instruction->opcode == I_DQ ||
	instruction->opcode == I_DT) 
    {
	extop *e;
	long isize, osize, wsize = 0;  /* placate gcc */

	isize = 0;
	switch (instruction->opcode) 
	{
	  case I_DB: wsize = 1; break;
	  case I_DW: wsize = 2; break;
	  case I_DD: wsize = 4; break;
	  case I_DQ: wsize = 8; break;
	  case I_DT: wsize = 10; break;
	}

	for (e = instruction->eops; e; e = e->next) 
	{
	    long align;

	    osize = 0;
	    if (e->type == EOT_DB_NUMBER)
		osize = 1;
	    else if (e->type == EOT_DB_STRING)
		osize = e->stringlen;

	    align = (-osize) % wsize;
	    if (align < 0)
		align += wsize;
	    isize += osize + align;
	}
	return isize * instruction->times;
    }

    if (instruction->opcode == I_INCBIN) 
    {
	char  fname[FILENAME_MAX];
	FILE  * fp;
	long  len;

	len = FILENAME_MAX-1;
	if (len > instruction->eops->stringlen)
	    len = instruction->eops->stringlen;
	strncpy (fname, instruction->eops->stringval, len);
	fname[len] = '\0';
	if ( (fp = fopen(fname, "rb")) == NULL )
	    error (ERR_NONFATAL, "`incbin': unable to open file `%s'", fname);
	else if (fseek(fp, 0L, SEEK_END) < 0)
	    error (ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
		   fname);
	else 
	{
	    len = ftell (fp);
	    fclose (fp);
	    if (instruction->eops->next) 
	    {
		len -= instruction->eops->next->offset;
		if (instruction->eops->next->next &&
		    len > instruction->eops->next->next->offset)
		{
		    len = instruction->eops->next->next->offset;
		}
	    }
	    return instruction->times * len;
	}
	return 0;		       /* if we're here, there's an error */
    }

    temp = nasm_instructions[instruction->opcode];
    while (temp->opcode != -1) {
	if (matches(temp, instruction) == 100) {
	    /* we've matched an instruction. */
	    long  isize;
	    char  * codes = temp->code;
	    int   j;

	    isize = calcsize(segment, offset, bits, instruction, codes);
	    if (isize < 0)
	    	return -1;
	    for (j = 0; j < instruction->nprefix; j++) 
	    {
		if ((instruction->prefixes[j] != P_A16 &&
		     instruction->prefixes[j] != P_O16 && bits==16) ||
		    (instruction->prefixes[j] != P_A32 &&
		     instruction->prefixes[j] != P_O32 && bits==32))
		{
		    isize++;
		}
	    }
	    return isize * instruction->times;
	}
	temp++;
    }
    return -1;			       /* didn't match any instruction */
}

static long calcsize (long segment, long offset, int bits,
		      insn *ins, char *codes) 
{
    long           length = 0;
    unsigned char  c;

    (void) segment;  /* Don't warn that this parameter is unused */
    (void) offset;   /* Don't warn that this parameter is unused */

    while (*codes) switch (c = *codes++) {
      case 01: case 02: case 03:
	codes += c, length += c; break;
      case 04: case 05: case 06: case 07:
	length++; break;
      case 010: case 011: case 012:
	codes++, length++; break;
      case 017:
	length++; break;
      case 014: case 015: case 016:
	length++; break;
      case 020: case 021: case 022:
	length++; break;
      case 024: case 025: case 026:
	length++; break;
      case 030: case 031: case 032:
	length += 2; break;
      case 034: case 035: case 036:
	length += ((ins->oprs[c-034].addr_size ?
		    ins->oprs[c-034].addr_size : bits) == 16 ? 2 : 4); break;
      case 037:
	length += 2; break;
      case 040: case 041: case 042:
	length += 4; break;
      case 050: case 051: case 052:
	length++; break;
      case 060: case 061: case 062:
	length += 2; break;
      case 064: case 065: case 066:
	length += ((ins->oprs[c-064].addr_size ?
		    ins->oprs[c-064].addr_size : bits) == 16 ? 2 : 4); break;
      case 070: case 071: case 072:
	length += 4; break;
      case 0300: case 0301: case 0302:
	length += chsize (&ins->oprs[c-0300], bits);
	break;
      case 0310:
	length += (bits==32);
	break;
      case 0311:
	length += (bits==16);
	break;
      case 0312:
	break;
      case 0320:
	length += (bits==32);
	break;
      case 0321:
	length += (bits==16);
	break;
      case 0322:
	break;
      case 0330:
	codes++, length++; break;
      case 0331:
      case 0332:
	break;
      case 0333:
	length++; break;
      case 0340: case 0341: case 0342:
	if (ins->oprs[0].segment != NO_SEG)
	    errfunc (ERR_NONFATAL, "attempt to reserve non-constant"
		     " quantity of BSS space");
	else
	    length += ins->oprs[0].offset << (c-0340);
	break;
      default:			       /* can't do it by 'case' statements */
	if (c>=0100 && c<=0277) {      /* it's an EA */
	    ea ea_data;
	    if (!process_ea (&ins->oprs[(c>>3)&7], &ea_data, bits, 0,
			     ins->forw_ref)) {
	    	errfunc (ERR_NONFATAL, "invalid effective address");
		return -1;
	    } else
	    	length += ea_data.size;
	} else
	    errfunc (ERR_PANIC, "internal instruction table corrupt"
		     ": instruction code 0x%02X given", c);
    }
    return length;
}

static void gencode (long segment, long offset, int bits,
		     insn *ins, char *codes, long insn_end) 
{
    static char condval[] = { /* conditional opcodes */
	0x7, 0x3, 0x2, 0x6, 0x2, 0x4, 0xF, 0xD, 0xC, 0xE, 0x6, 0x2,
	0x3, 0x7, 0x3, 0x5, 0xE, 0xC, 0xD, 0xF, 0x1, 0xB, 0x9, 0x5,
	0x0, 0xA, 0xA, 0xB, 0x8, 0x4
    };
    unsigned char c;
    unsigned char bytes[4];
    long          data, size;

    while (*codes)
	switch (c = *codes++) 
	{
	case 01: case 02: case 03:
	    out (offset, segment, codes, OUT_RAWDATA+c, NO_SEG, NO_SEG);
	    codes += c;
	    offset += c;
	    break;

	case 04: case 06:
	    switch (ins->oprs[0].basereg) 
	    {
	    case R_CS: 
		bytes[0] = 0x0E + (c == 0x04 ? 1 : 0); break;
	    case R_DS: 
		bytes[0] = 0x1E + (c == 0x04 ? 1 : 0); break;
	    case R_ES: 
		bytes[0] = 0x06 + (c == 0x04 ? 1 : 0); break;
	    case R_SS: 
		bytes[0] = 0x16 + (c == 0x04 ? 1 : 0); break;
	    default:
                errfunc (ERR_PANIC, "bizarre 8086 segment register received");
	    }
	    out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset++;
	    break;

	case 05: case 07:
	    switch (ins->oprs[0].basereg) {
	    case R_FS: bytes[0] = 0xA0 + (c == 0x05 ? 1 : 0); break;
	    case R_GS: bytes[0] = 0xA8 + (c == 0x05 ? 1 : 0); break;
	    default:
                errfunc (ERR_PANIC, "bizarre 386 segment register received");
	    }
	    out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset++;
	    break;

	case 010: case 011: case 012:
	    bytes[0] = *codes++ + regval(&ins->oprs[c-010]);
	    out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset += 1;
	    break;

	case 017:
	    bytes[0] = 0;
	    out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset += 1;
	    break;

	case 014: case 015: case 016:
	    if (ins->oprs[c-014].offset < -128 
		|| ins->oprs[c-014].offset > 127)
	    {
		errfunc (ERR_WARNING, "signed byte value exceeds bounds");
	    }

	    if (ins->oprs[c-014].segment != NO_SEG) 
	    {
		data = ins->oprs[c-014].offset;
		out (offset, segment, &data, OUT_ADDRESS+1,
		     ins->oprs[c-014].segment, ins->oprs[c-014].wrt);
	    } 
	    else {
		bytes[0] = ins->oprs[c-014].offset;
		out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    }
	    offset += 1;
	    break;

	case 020: case 021: case 022:
	    if (ins->oprs[c-020].offset < -256 
		|| ins->oprs[c-020].offset > 255)
	    {
		errfunc (ERR_WARNING, "byte value exceeds bounds");
	    }
	    if (ins->oprs[c-020].segment != NO_SEG) {
		data = ins->oprs[c-020].offset;
		out (offset, segment, &data, OUT_ADDRESS+1,
		     ins->oprs[c-020].segment, ins->oprs[c-020].wrt);
	    } 
	    else {
		bytes[0] = ins->oprs[c-020].offset;
		out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    }
	    offset += 1;
	    break;
	
	case 024: case 025: case 026:
	    if (ins->oprs[c-024].offset < 0 || ins->oprs[c-024].offset > 255)
		errfunc (ERR_WARNING, "unsigned byte value exceeds bounds");
	    if (ins->oprs[c-024].segment != NO_SEG) {
		data = ins->oprs[c-024].offset;
		out (offset, segment, &data, OUT_ADDRESS+1,
		     ins->oprs[c-024].segment, ins->oprs[c-024].wrt);
	    }
	    else {
		bytes[0] = ins->oprs[c-024].offset;
		out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    }
	    offset += 1;
	    break;

	case 030: case 031: case 032:
	    if (ins->oprs[c-030].segment == NO_SEG &&
		ins->oprs[c-030].wrt == NO_SEG &&
		(ins->oprs[c-030].offset < -65536L ||
		 ins->oprs[c-030].offset > 65535L))
	    {
		errfunc (ERR_WARNING, "word value exceeds bounds");
	    }
	    data = ins->oprs[c-030].offset;
	    out (offset, segment, &data, OUT_ADDRESS+2,
		 ins->oprs[c-030].segment, ins->oprs[c-030].wrt);
	    offset += 2;
	    break;

	case 034: case 035: case 036:
	    data = ins->oprs[c-034].offset;
	    size = ((ins->oprs[c-034].addr_size ?
		     ins->oprs[c-034].addr_size : bits) == 16 ? 2 : 4);
	    if (size==16 && (data < -65536L || data > 65535L))
		errfunc (ERR_WARNING, "word value exceeds bounds");
	    out (offset, segment, &data, OUT_ADDRESS+size,
		 ins->oprs[c-034].segment, ins->oprs[c-034].wrt);
	    offset += size;
	    break;

	case 037:
	    if (ins->oprs[0].segment == NO_SEG)
		errfunc (ERR_NONFATAL, "value referenced by FAR is not"
			 " relocatable");
	    data = 0L;
	    out (offset, segment, &data, OUT_ADDRESS+2,
		 outfmt->segbase(1+ins->oprs[0].segment),
		 ins->oprs[0].wrt);
	    offset += 2;
		break;

	case 040: case 041: case 042:
	    data = ins->oprs[c-040].offset;
	    out (offset, segment, &data, OUT_ADDRESS+4,
		 ins->oprs[c-040].segment, ins->oprs[c-040].wrt);
	    offset += 4;
	    break;

	case 050: case 051: case 052:
	    if (ins->oprs[c-050].segment != segment)
		errfunc (ERR_NONFATAL, "short relative jump outside segment");
	    data = ins->oprs[c-050].offset - insn_end;
	    if (data > 127 || data < -128)
		errfunc (ERR_NONFATAL, "short jump is out of range");
	    bytes[0] = data;
	    out (offset, segment, bytes, OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset += 1;
	    break;

	case 060: case 061: case 062:
	    if (ins->oprs[c-060].segment != segment) {
		data = ins->oprs[c-060].offset;
		out (offset, segment, &data, OUT_REL2ADR+insn_end-offset,
		     ins->oprs[c-060].segment, ins->oprs[c-060].wrt);
	    } else {
		data = ins->oprs[c-060].offset - insn_end;
		out (offset, segment, &data,
		     OUT_ADDRESS+2, NO_SEG, NO_SEG);
	    }
	    offset += 2;
	    break;

	case 064: case 065: case 066:
	    size = ((ins->oprs[c-064].addr_size ?
		     ins->oprs[c-064].addr_size : bits) == 16 ? 2 : 4);
	    if (ins->oprs[c-064].segment != segment) {
		data = ins->oprs[c-064].offset;
		size = (bits == 16 ? OUT_REL2ADR : OUT_REL4ADR);
		out (offset, segment, &data, size+insn_end-offset,
		     ins->oprs[c-064].segment, ins->oprs[c-064].wrt);
		size = (bits == 16 ? 2 : 4);
	    } else {
		data = ins->oprs[c-064].offset - insn_end;
		out (offset, segment, &data,
		     OUT_ADDRESS+size, NO_SEG, NO_SEG);
	    }
	    offset += size;
	    break;

	case 070: case 071: case 072:
	    if (ins->oprs[c-070].segment != segment) {
		data = ins->oprs[c-070].offset;
		out (offset, segment, &data, OUT_REL4ADR+insn_end-offset,
		     ins->oprs[c-070].segment, ins->oprs[c-070].wrt);
	    } else {
		data = ins->oprs[c-070].offset - insn_end;
		out (offset, segment, &data,
		     OUT_ADDRESS+4, NO_SEG, NO_SEG);
	    }
	    offset += 4;
	    break;

	case 0300: case 0301: case 0302:
	    if (chsize (&ins->oprs[c-0300], bits)) {
		*bytes = 0x67;
		out (offset, segment, bytes,
		     OUT_RAWDATA+1, NO_SEG, NO_SEG);
		offset += 1;
	    } else
		offset += 0;
	    break;

	case 0310:
	    if (bits==32) {
		*bytes = 0x67;
		out (offset, segment, bytes,
		     OUT_RAWDATA+1, NO_SEG, NO_SEG);
		offset += 1;
	    } else
		offset += 0;
	    break;

	case 0311:
	    if (bits==16) {
		*bytes = 0x67;
		out (offset, segment, bytes,
		     OUT_RAWDATA+1, NO_SEG, NO_SEG);
		offset += 1;
	    } else
		offset += 0;
	    break;

	case 0312:
	    break;

	case 0320:
	    if (bits==32) {
		*bytes = 0x66;
		out (offset, segment, bytes,
		     OUT_RAWDATA+1, NO_SEG, NO_SEG);
		offset += 1;
	    } else
		offset += 0;
	    break;

	case 0321:
	    if (bits==16) {
		*bytes = 0x66;
		out (offset, segment, bytes,
		     OUT_RAWDATA+1, NO_SEG, NO_SEG);
		offset += 1;
	    } else
		offset += 0;
	    break;

	case 0322:
	    break;

	case 0330:
	    *bytes = *codes++ + condval[ins->condition];
	    out (offset, segment, bytes,
		 OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset += 1;
	    break;

	case 0331:
	case 0332:
	    break;

	case 0333:
	    *bytes = 0xF3;
	    out (offset, segment, bytes,
		 OUT_RAWDATA+1, NO_SEG, NO_SEG);
	    offset += 1;
	    break;

	case 0340: case 0341: case 0342:
	    if (ins->oprs[0].segment != NO_SEG)
		errfunc (ERR_PANIC, "non-constant BSS size in pass two");
	    else {
		long size = ins->oprs[0].offset << (c-0340);
		if (size > 0)
		    out (offset, segment, NULL,
			 OUT_RESERVE+size, NO_SEG, NO_SEG);
		offset += size;
	    }
	    break;

	default:	               /* can't do it by 'case' statements */
	    if (c>=0100 && c<=0277) {      /* it's an EA */
		ea ea_data;
		int rfield;
		unsigned char *p;
		long s;

		if (c<=0177)	       /* pick rfield from operand b */
		    rfield = regval (&ins->oprs[c&7]);
		else 		       /* rfield is constant */
		    rfield = c & 7;

		if (!process_ea (&ins->oprs[(c>>3)&7], &ea_data, bits, rfield,
				 ins->forw_ref))
		{
		    errfunc (ERR_NONFATAL, "invalid effective address");
		}

		p = bytes;
		*p++ = ea_data.modrm;
		if (ea_data.sib_present)
		    *p++ = ea_data.sib;

		s = p-bytes;
		out (offset, segment, bytes, OUT_RAWDATA + s,
		     NO_SEG, NO_SEG);

		switch (ea_data.bytes) {
		case 0:
		    break;
		case 1:
		    if (ins->oprs[(c>>3)&7].segment != NO_SEG) {
			data = ins->oprs[(c>>3)&7].offset;
			out (offset, segment, &data, OUT_ADDRESS+1,
			     ins->oprs[(c>>3)&7].segment,
			     ins->oprs[(c>>3)&7].wrt);
		    } else {
			*bytes = ins->oprs[(c>>3)&7].offset;
			out (offset, segment, bytes, OUT_RAWDATA+1,
			     NO_SEG, NO_SEG);
		    }
		    s++;
		    break;
		case 2:
		case 4:
		    data = ins->oprs[(c>>3)&7].offset;
		    out (offset, segment, &data,
			 OUT_ADDRESS+ea_data.bytes,
			 ins->oprs[(c>>3)&7].segment, ins->oprs[(c>>3)&7].wrt);
		    s += ea_data.bytes;
		    break;
		}
		offset += s;
	    } else
		errfunc (ERR_PANIC, "internal instruction table corrupt"
		     ": instruction code 0x%02X given", c);
	}
}

static int regval (operand *o) 
{
    switch (o->basereg) {
      case R_EAX: case R_AX: case R_AL: case R_ES: case R_CR0: case R_DR0:
      case R_ST0: case R_MM0: case R_XMM0:
	return 0;
      case R_ECX: case R_CX: case R_CL: case R_CS: case R_DR1: case R_ST1:
      case R_MM1: case R_XMM1:
	return 1;
      case R_EDX: case R_DX: case R_DL: case R_SS: case R_CR2: case R_DR2:
      case R_ST2: case R_MM2:  case R_XMM2:
	return 2;
      case R_EBX: case R_BX: case R_BL: case R_DS: case R_CR3: case R_DR3:
      case R_TR3: case R_ST3: case R_MM3:  case R_XMM3:
	return 3;
      case R_ESP: case R_SP: case R_AH: case R_FS: case R_CR4: case R_TR4:
      case R_ST4: case R_MM4:  case R_XMM4:
	return 4;
      case R_EBP: case R_BP: case R_CH: case R_GS: case R_TR5: case R_ST5:
      case R_MM5:  case R_XMM5:
	return 5;
      case R_ESI: case R_SI: case R_DH: case R_DR6: case R_TR6: case R_ST6:
      case R_MM6:  case R_XMM6:
	return 6;
      case R_EDI: case R_DI: case R_BH: case R_DR7: case R_TR7: case R_ST7:
      case R_MM7:  case R_XMM7:
	return 7;
      default:			       /* panic */
        errfunc (ERR_PANIC, "invalid register operand given to regval()");
	return 0;
    }
}

static int matches (struct itemplate *itemp, insn *instruction) 
{
    int i, size[3], asize, oprs, ret;

    ret = 100;

    /*
     * Check the opcode
     */
    if (itemp->opcode != instruction->opcode) return 0;

    /*
     * Count the operands
     */
    if (itemp->operands != instruction->operands) return 0;

    /*
     * Check that no spurious colons or TOs are present
     */
    for (i=0; i<itemp->operands; i++)
	if (instruction->oprs[i].type & ~itemp->opd[i] & (COLON|TO))
	    return 0;

    /*
     * Check that the operand flags all match up
     */
    for (i=0; i<itemp->operands; i++)
	if (itemp->opd[i] & ~instruction->oprs[i].type ||
	    ((itemp->opd[i] & SIZE_MASK) &&
	     ((itemp->opd[i] ^ instruction->oprs[i].type) & SIZE_MASK)))
	{
	    if ((itemp->opd[i] & ~instruction->oprs[i].type & NON_SIZE) ||
		(instruction->oprs[i].type & SIZE_MASK))
		return 0;
	    else
		ret = 1;
	}

    /*
     * Check operand sizes
     */
    if (itemp->flags & IF_ARMASK) {
      size[0] = size[1] = size[2] = 0;

      switch (itemp->flags & IF_ARMASK) {
      case IF_AR0: i = 0; break;
      case IF_AR1: i = 1; break;
      case IF_AR2: i = 2; break;
      default:     break;	/* Shouldn't happen */
      }
      if (itemp->flags & IF_SB) {
	size[i] = BITS8;
      } else if (itemp->flags & IF_SW) {
	size[i] = BITS16;
      } else if (itemp->flags & IF_SD) {
	size[i] = BITS32;
      }
    } else {
      asize = 0;
      if (itemp->flags & IF_SB) {
	asize = BITS8;
	oprs = itemp->operands;
      } else if (itemp->flags & IF_SW) {
	asize = BITS16;
	oprs = itemp->operands;
      } else if (itemp->flags & IF_SD) {
	asize = BITS32;
	oprs = itemp->operands;
      }
      size[0] = size[1] = size[2] = asize;
    }

    if (itemp->flags & (IF_SM | IF_SM2)) {
      oprs = (itemp->flags & IF_SM2 ? 2 : itemp->operands);
      asize = 0;
      for (i=0; i<oprs; i++) {
	if ( (asize = itemp->opd[i] & SIZE_MASK) != 0) {
	  int j;
	  for (j=0; j<oprs; j++)
	    size[j] = asize;
	  break;
	}
      }
    } else {
      oprs = itemp->operands;
    }

    for (i=0; i<itemp->operands; i++)
	if (!(itemp->opd[i] & SIZE_MASK) &&
	    (instruction->oprs[i].type & SIZE_MASK & ~size[i]))
	    ret = 2;

    return ret;
}

static ea *process_ea (operand *input, ea *output, int addrbits, int rfield,
		       int forw_ref) 
{
    if (!(REGISTER & ~input->type)) {  /* it's a single register */
	static int regs[] = {
	  R_AL,   R_CL,   R_DL,   R_BL,   R_AH,   R_CH,   R_DH,   R_BH,
	  R_AX,   R_CX,   R_DX,   R_BX,   R_SP,   R_BP,   R_SI,   R_DI,
	  R_EAX,  R_ECX,  R_EDX,  R_EBX,  R_ESP,  R_EBP,  R_ESI,  R_EDI,
	  R_MM0,  R_MM1,  R_MM2,  R_MM3,  R_MM4,  R_MM5,  R_MM6,  R_MM7,
	  R_XMM0, R_XMM1, R_XMM2, R_XMM3, R_XMM4, R_XMM5, R_XMM6, R_XMM7
	};
	int i;

	for (i=0; i<elements(regs); i++)
	    if (input->basereg == regs[i]) break;
	if (i<elements(regs)) {
	    output->sib_present = FALSE;/* no SIB necessary */
	    output->bytes = 0;	       /* no offset necessary either */
            output->modrm = 0xC0 | (rfield << 3) | (i & 7);
	} 
	else
	    return NULL;
    } else {			       /* it's a memory reference */
	if (input->basereg==-1 && (input->indexreg==-1 || input->scale==0)) {
	    /* it's a pure offset */
	    if (input->addr_size)
		addrbits = input->addr_size;
	    output->sib_present = FALSE;
	    output->bytes = (addrbits==32 ? 4 : 2);
	    output->modrm = (addrbits==32 ? 5 : 6) | (rfield << 3);
	} 
	else {		       /* it's an indirection */
	    int i=input->indexreg, b=input->basereg, s=input->scale;
	    long o=input->offset, seg=input->segment;
	    int hb=input->hintbase, ht=input->hinttype;
	    int t;

	    if (s==0) i = -1;	       /* make this easy, at least */

	    if (i==R_EAX || i==R_EBX || i==R_ECX || i==R_EDX
		|| i==R_EBP || i==R_ESP || i==R_ESI || i==R_EDI
		|| b==R_EAX || b==R_EBX || b==R_ECX || b==R_EDX
		|| b==R_EBP || b==R_ESP || b==R_ESI || b==R_EDI) {
		/* it must be a 32-bit memory reference. Firstly we have
		 * to check that all registers involved are type Exx. */
		if (i!=-1 && i!=R_EAX && i!=R_EBX && i!=R_ECX && i!=R_EDX
		    && i!=R_EBP && i!=R_ESP && i!=R_ESI && i!=R_EDI)
		    return NULL;
		if (b!=-1 && b!=R_EAX && b!=R_EBX && b!=R_ECX && b!=R_EDX
		    && b!=R_EBP && b!=R_ESP && b!=R_ESI && b!=R_EDI)
		    return NULL;

		/* While we're here, ensure the user didn't specify WORD. */
		if (input->addr_size == 16)
		    return NULL;

		/* now reorganise base/index */
		if (s == 1 && b != i && b != -1 && i != -1 &&
		    ((hb==b&&ht==EAH_NOTBASE) || (hb==i&&ht==EAH_MAKEBASE)))
		    t = b, b = i, i = t;   /* swap if hints say so */
		if (b==i)	       /* convert EAX+2*EAX to 3*EAX */
		    b = -1, s++;
		if (b==-1 && s==1 && !(hb == i && ht == EAH_NOTBASE))
		    b = i, i = -1;     /* make single reg base, unless hint */
		if (((s==2 && i!=R_ESP && !(input->eaflags & EAF_TIMESTWO)) ||
		     s==3 || s==5 || s==9) && b==-1)
		    b = i, s--;       /* convert 3*EAX to EAX+2*EAX */
		if (s==1 && i==R_ESP)  /* swap ESP into base if scale is 1 */
		    i = b, b = R_ESP;
		if (i==R_ESP || (s!=1 && s!=2 && s!=4 && s!=8 && i!=-1))
		    return NULL;      /* wrong, for various reasons */

		if (i==-1 && b!=R_ESP) {/* no SIB needed */
		    int mod, rm;
		    switch(b) {
		      case R_EAX: rm = 0; break;
		      case R_ECX: rm = 1; break;
		      case R_EDX: rm = 2; break;
		      case R_EBX: rm = 3; break;
		      case R_EBP: rm = 5; break;
		      case R_ESI: rm = 6; break;
		      case R_EDI: rm = 7; break;
		      case -1: rm = 5; break;
		      default:	       /* should never happen */
			return NULL;
		    }
		    if (b==-1 || (b!=R_EBP && o==0 &&
				  seg==NO_SEG && !forw_ref &&
				  !(input->eaflags &
				    (EAF_BYTEOFFS|EAF_WORDOFFS))))
		    	mod = 0;
		    else if (input->eaflags & EAF_BYTEOFFS ||
			     (o>=-128 && o<=127 && seg==NO_SEG && !forw_ref &&
			      !(input->eaflags & EAF_WORDOFFS))) {
		    	mod = 1;
		    } 
		    else
		    	mod = 2;

		    output->sib_present = FALSE;
		    output->bytes = (b==-1 || mod==2 ? 4 : mod);
		    output->modrm = (mod<<6) | (rfield<<3) | rm;
		} 
		else {	       /* we need a SIB */
		    int mod, scale, index, base;

		    switch (b) {
		      case R_EAX: base = 0; break;
		      case R_ECX: base = 1; break;
		      case R_EDX: base = 2; break;
		      case R_EBX: base = 3; break;
		      case R_ESP: base = 4; break;
		      case R_EBP: case -1: base = 5; break;
		      case R_ESI: base = 6; break;
		      case R_EDI: base = 7; break;
		      default:	       /* then what the smeg is it? */
			return NULL;  /* panic */
		    }

		    switch (i) {
		      case R_EAX: index = 0; break;
		      case R_ECX: index = 1; break;
		      case R_EDX: index = 2; break;
		      case R_EBX: index = 3; break;
		      case -1: index = 4; break;
		      case R_EBP: index = 5; break;
		      case R_ESI: index = 6; break;
		      case R_EDI: index = 7; break;
		      default:	       /* then what the smeg is it? */
			return NULL;  /* panic */
		    }

		    if (i==-1) s = 1;
		    switch (s) {
		      case 1: scale = 0; break;
		      case 2: scale = 1; break;
		      case 4: scale = 2; break;
		      case 8: scale = 3; break;
		      default:	       /* then what the smeg is it? */
			return NULL;  /* panic */
		    }

		    if (b==-1 || (b!=R_EBP && o==0 &&
				  seg==NO_SEG && !forw_ref &&
				  !(input->eaflags &
				    (EAF_BYTEOFFS|EAF_WORDOFFS))))
		    	mod = 0;
		    else if (input->eaflags & EAF_BYTEOFFS ||
			     (o>=-128 && o<=127 && seg==NO_SEG && !forw_ref &&
			      !(input->eaflags & EAF_WORDOFFS)))
		    	mod = 1;
		    else
		    	mod = 2;

		    output->sib_present = TRUE;
		    output->bytes = (b==-1 || mod==2 ? 4 : mod);
		    output->modrm = (mod<<6) | (rfield<<3) | 4;
		    output->sib = (scale<<6) | (index<<3) | base;
		}
	    } 
	    else {		       /* it's 16-bit */
		int mod, rm;

		/* check all registers are BX, BP, SI or DI */
		if ((b!=-1 && b!=R_BP && b!=R_BX && b!=R_SI && b!=R_DI) ||
		    (i!=-1 && i!=R_BP && i!=R_BX && i!=R_SI && i!=R_DI))
		    return NULL;

		/* ensure the user didn't specify DWORD */
		if (input->addr_size == 32)
		    return NULL;

		if (s!=1 && i!=-1) return NULL;/* no can do, in 16-bit EA */
		if (b==-1 && i!=-1) b ^= i ^= b ^= i;   /* swap them round */
		if ((b==R_SI || b==R_DI) && i!=-1)
		    b ^= i ^= b ^= i; /* have BX/BP as base, SI/DI index */
		if (b==i) return NULL;/* shouldn't ever happen, in theory */
		if (i!=-1 && b!=-1 &&
		    (i==R_BP || i==R_BX || b==R_SI || b==R_DI))
		    return NULL;      /* invalid combinations */
		if (b==-1)	       /* pure offset: handled above */
		    return NULL;      /* so if it gets to here, panic! */

		rm = -1;
		if (i!=-1)
		    switch (i*256 + b) {
		      case R_SI*256+R_BX: rm=0; break;
		      case R_DI*256+R_BX: rm=1; break;
		      case R_SI*256+R_BP: rm=2; break;
		      case R_DI*256+R_BP: rm=3; break;
		    }
		else
		    switch (b) {
		      case R_SI: rm=4; break;
		      case R_DI: rm=5; break;
		      case R_BP: rm=6; break;
		      case R_BX: rm=7; break;
		    }
		if (rm==-1)	       /* can't happen, in theory */
		    return NULL;      /* so panic if it does */

		if (o==0 && seg==NO_SEG && !forw_ref && rm!=6 &&
		    !(input->eaflags & (EAF_BYTEOFFS|EAF_WORDOFFS)))
		    mod = 0;
		else if (input->eaflags & EAF_BYTEOFFS ||
			 (o>=-128 && o<=127 && seg==NO_SEG && !forw_ref &&
			  !(input->eaflags & EAF_WORDOFFS)))
		    mod = 1;
		else
		    mod = 2;

		output->sib_present = FALSE;  /* no SIB - it's 16-bit */
		output->bytes = mod;  /* bytes of offset needed */
		output->modrm = (mod<<6) | (rfield<<3) | rm;
	    }
	}
    }
    output->size = 1 + output->sib_present + output->bytes;
    return output;
}

static int chsize (operand *input, int addrbits) 
{
    if (!(MEMORY & ~input->type)) {
	int i=input->indexreg, b=input->basereg;

	if (input->scale==0) i = -1;

	if (i == -1 && b == -1) /* pure offset */
	    return (input->addr_size != 0 && input->addr_size != addrbits);

	if (i==R_EAX || i==R_EBX || i==R_ECX || i==R_EDX
	    || i==R_EBP || i==R_ESP || i==R_ESI || i==R_EDI
	    || b==R_EAX || b==R_EBX || b==R_ECX || b==R_EDX
	    || b==R_EBP || b==R_ESP || b==R_ESI || b==R_EDI)
	    return (addrbits==16);
	else
	    return (addrbits==32);
    } 
    else
    	return 0;
}
