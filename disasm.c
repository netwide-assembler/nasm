/* disasm.c   where all the _work_ gets done in the Netwide Disassembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 27/iii/95 by Simon Tatham
 */

#include <stdio.h>
#include <string.h>

#include "nasm.h"
#include "disasm.h"
#include "sync.h"
#include "insns.h"

#include "names.c"

extern struct itemplate **itable[];

/*
 * Flags that go into the `segment' field of `insn' structures
 * during disassembly.
 */
#define SEG_RELATIVE 1
#define SEG_32BIT 2
#define SEG_RMREG 4
#define SEG_DISP8 8
#define SEG_DISP16 16
#define SEG_DISP32 32
#define SEG_NODISP 64
#define SEG_SIGNED 128

static int whichreg(long regflags, int regval) 
{
    static int reg32[] = {
	R_EAX, R_ECX, R_EDX, R_EBX, R_ESP, R_EBP, R_ESI, R_EDI };
    static int reg16[] = {
	R_AX, R_CX, R_DX, R_BX, R_SP, R_BP, R_SI, R_DI };
    static int reg8[] = {
	R_AL, R_CL, R_DL, R_BL, R_AH, R_CH, R_DH, R_BH };
    static int sreg[] = {
	R_ES, R_CS, R_SS, R_DS, R_FS, R_GS, 0, 0 };
    static int creg[] = {
	R_CR0, 0, R_CR2, R_CR3, R_CR4, 0, 0, 0 };
    static int dreg[] = {
	R_DR0, R_DR1, R_DR2, R_DR3, 0, 0, R_DR6, R_DR7 };
    static int treg[] = {
	0, 0, 0, R_TR3, R_TR4, R_TR5, R_TR6, R_TR7 };
    static int fpureg[] = {
	R_ST0, R_ST1, R_ST2, R_ST3, R_ST4, R_ST5, R_ST6, R_ST7 };
    static int mmxreg[] = {
	R_MM0, R_MM1, R_MM2, R_MM3, R_MM4, R_MM5, R_MM6, R_MM7 };
    static int xmmreg[] = {
	R_XMM0, R_XMM1, R_XMM2, R_XMM3, R_XMM4, R_XMM5, R_XMM6, R_XMM7 };

    if (!(REG_AL & ~regflags))
	return R_AL;
    if (!(REG_AX & ~regflags))
	return R_AX;
    if (!(REG_EAX & ~regflags))
	return R_EAX;
    if (!(REG_DX & ~regflags))
	return R_DX;
    if (!(REG_CL & ~regflags))
	return R_CL;
    if (!(REG_CX & ~regflags))
	return R_CX;
    if (!(REG_ECX & ~regflags))
	return R_ECX;
    if (!(REG_CR4 & ~regflags))
	return R_CR4;
    if (!(FPU0 & ~regflags))
	return R_ST0;
    if (!(REG_CS & ~regflags))
	return R_CS;
    if (!(REG_DESS & ~regflags))
	return (regval == 0 || regval == 2 || regval == 3 ? sreg[regval] : 0);
    if (!(REG_FSGS & ~regflags))
	return (regval == 4 || regval == 5 ? sreg[regval] : 0);
    if (!((REGMEM|BITS8) & ~regflags))
	return reg8[regval];
    if (!((REGMEM|BITS16) & ~regflags))
	return reg16[regval];
    if (!((REGMEM|BITS32) & ~regflags))
	return reg32[regval];
    if (!(REG_SREG & ~regflags))
	return sreg[regval];
    if (!(REG_CREG & ~regflags))
	return creg[regval];
    if (!(REG_DREG & ~regflags))
	return dreg[regval];
    if (!(REG_TREG & ~regflags))
	return treg[regval];
    if (!(FPUREG & ~regflags))
	return fpureg[regval];
    if (!(MMXREG & ~regflags))
	return mmxreg[regval];
    if (!(XMMREG & ~regflags))
	return xmmreg[regval];
    return 0;
}

static char *whichcond(int condval) 
{
    static int conds[] = {
	C_O, C_NO, C_C, C_NC, C_Z, C_NZ, C_NA, C_A,
	C_S, C_NS, C_PE, C_PO, C_L, C_NL, C_NG, C_G
    };
    return conditions[conds[condval]];
}

/*
 * Process an effective address (ModRM) specification.
 */
static unsigned char *do_ea (unsigned char *data, int modrm, int asize,
			     int segsize, operand *op) 
{
    int mod, rm, scale, index, base;

    mod = (modrm >> 6) & 03;
    rm = modrm & 07;

    if (mod == 3) {		       /* pure register version */
	op->basereg = rm;
	op->segment |= SEG_RMREG;
	return data;
    }

    op->addr_size = 0;

    if (asize == 16) {
	/*
	 * <mod> specifies the displacement size (none, byte or
	 * word), and <rm> specifies the register combination.
	 * Exception: mod=0,rm=6 does not specify [BP] as one might
	 * expect, but instead specifies [disp16].
	 */
	op->indexreg = op->basereg = -1;
	op->scale = 1;		       /* always, in 16 bits */
	switch (rm) {
	  case 0: op->basereg = R_BX; op->indexreg = R_SI; break;
	  case 1: op->basereg = R_BX; op->indexreg = R_DI; break;
	  case 2: op->basereg = R_BP; op->indexreg = R_SI; break;
	  case 3: op->basereg = R_BP; op->indexreg = R_DI; break;
	  case 4: op->basereg = R_SI; break;
	  case 5: op->basereg = R_DI; break;
	  case 6: op->basereg = R_BP; break;
	  case 7: op->basereg = R_BX; break;
	}
	if (rm == 6 && mod == 0) {     /* special case */
	    op->basereg = -1;
	    if (segsize != 16)
		op->addr_size = 16;
	    mod = 2;		       /* fake disp16 */
	}
	switch (mod) {
	  case 0:
	    op->segment |= SEG_NODISP;
	    break;
	  case 1:
	    op->segment |= SEG_DISP8;
	    op->offset = (signed char) *data++;
	    break;
	  case 2:
	    op->segment |= SEG_DISP16;
	    op->offset = *data++;
	    op->offset |= (*data++) << 8;
	    break;
	}
	return data;
    } else {
	/*
	 * Once again, <mod> specifies displacement size (this time
	 * none, byte or *dword*), while <rm> specifies the base
	 * register. Again, [EBP] is missing, replaced by a pure
	 * disp32 (this time that's mod=0,rm=*5*). However, rm=4
	 * indicates not a single base register, but instead the
	 * presence of a SIB byte...
	 */
	op->indexreg = -1;
	switch (rm) {
	  case 0: op->basereg = R_EAX; break;
	  case 1: op->basereg = R_ECX; break;
	  case 2: op->basereg = R_EDX; break;
	  case 3: op->basereg = R_EBX; break;
	  case 5: op->basereg = R_EBP; break;
	  case 6: op->basereg = R_ESI; break;
	  case 7: op->basereg = R_EDI; break;
	}
	if (rm == 5 && mod == 0) {
	    op->basereg = -1;
	    if (segsize != 32)
		op->addr_size = 32;
	    mod = 2;		       /* fake disp32 */
	}
	if (rm == 4) {		       /* process SIB */
	    scale = (*data >> 6) & 03;
	    index = (*data >> 3) & 07;
	    base = *data & 07;
	    data++;

	    op->scale = 1 << scale;
	    switch (index) {
	      case 0: op->indexreg = R_EAX; break;
	      case 1: op->indexreg = R_ECX; break;
	      case 2: op->indexreg = R_EDX; break;
	      case 3: op->indexreg = R_EBX; break;
	      case 4: op->indexreg = -1; break;
	      case 5: op->indexreg = R_EBP; break;
	      case 6: op->indexreg = R_ESI; break;
	      case 7: op->indexreg = R_EDI; break;
	    }

	    switch (base) {
	      case 0: op->basereg = R_EAX; break;
	      case 1: op->basereg = R_ECX; break;
	      case 2: op->basereg = R_EDX; break;
	      case 3: op->basereg = R_EBX; break;
	      case 4: op->basereg = R_ESP; break;
	      case 6: op->basereg = R_ESI; break;
	      case 7: op->basereg = R_EDI; break;
	      case 5:
		if (mod == 0) {
		    mod = 2;
		    op->basereg = -1;
		} else
		    op->basereg = R_EBP;
		break;
	    }
	}
	switch (mod) {
	  case 0:
	    op->segment |= SEG_NODISP;
	    break;
	  case 1:
	    op->segment |= SEG_DISP8;
	    op->offset = (signed char) *data++;
	    break;
	  case 2:
	    op->segment |= SEG_DISP32;
	    op->offset = *data++;
	    op->offset |= (*data++) << 8;
	    op->offset |= ((long) *data++) << 16;
	    op->offset |= ((long) *data++) << 24;
	    break;
	}
	return data;
    }
}

/*
 * Determine whether the instruction template in t corresponds to the data
 * stream in data. Return the number of bytes matched if so.
 */
static int matches (struct itemplate *t, unsigned char *data, int asize,
		    int osize, int segsize, int rep, insn *ins) 
{
    unsigned char * r = (unsigned char *)(t->code);
    unsigned char * origdata = data;
    int           a_used = FALSE, o_used = FALSE;
    int           drep = 0;

    if ( rep == 0xF2 )
      drep = P_REPNE;
    else if ( rep == 0xF3 )
      drep = P_REP;

    while (*r) 
    {
	int c = *r++;
	if (c >= 01 && c <= 03) {
	    while (c--)
		if (*r++ != *data++)
		    return FALSE;
	}
	if (c == 04) {
	    switch (*data++) {
	      case 0x07: ins->oprs[0].basereg = 0; break;
	      case 0x17: ins->oprs[0].basereg = 2; break;
	      case 0x1F: ins->oprs[0].basereg = 3; break;
	      default: return FALSE;
	    }
	}
	if (c == 05) {
	    switch (*data++) {
	      case 0xA1: ins->oprs[0].basereg = 4; break;
	      case 0xA9: ins->oprs[0].basereg = 5; break;
	      default: return FALSE;
	    }
	}
	if (c == 06) {
	    switch (*data++) {
	      case 0x06: ins->oprs[0].basereg = 0; break;
	      case 0x0E: ins->oprs[0].basereg = 1; break;
	      case 0x16: ins->oprs[0].basereg = 2; break;
	      case 0x1E: ins->oprs[0].basereg = 3; break;
	      default: return FALSE;
	    }
	}
	if (c == 07) {
	    switch (*data++) {
	      case 0xA0: ins->oprs[0].basereg = 4; break;
	      case 0xA8: ins->oprs[0].basereg = 5; break;
	      default: return FALSE;
	    }
	}
	if (c >= 010 && c <= 012) {
	    int t = *r++, d = *data++;
	    if (d < t || d > t+7)
		return FALSE;
	    else {
		ins->oprs[c-010].basereg = d-t;
		ins->oprs[c-010].segment |= SEG_RMREG;
	    }
	}
	if (c == 017)
	    if (*data++)
		return FALSE;
	if (c >= 014 && c <= 016) {
	    ins->oprs[c-014].offset = (signed char) *data++;
	    ins->oprs[c-014].segment |= SEG_SIGNED;
	}
	if (c >= 020 && c <= 022)
	    ins->oprs[c-020].offset = *data++;
	if (c >= 024 && c <= 026)
	    ins->oprs[c-024].offset = *data++;
	if (c >= 030 && c <= 032) {
	    ins->oprs[c-030].offset = *data++;
	    ins->oprs[c-030].offset |= (*data++ << 8);
	}
	if (c >= 034 && c <= 036) {
	    ins->oprs[c-034].offset = *data++;
	    ins->oprs[c-034].offset |= (*data++ << 8);
	    if (asize == 32) {
		ins->oprs[c-034].offset |= (((long) *data++) << 16);
		ins->oprs[c-034].offset |= (((long) *data++) << 24);
	    }
	    if (segsize != asize)
		ins->oprs[c-034].addr_size = asize;
	}
	if (c >= 040 && c <= 042) {
	    ins->oprs[c-040].offset = *data++;
	    ins->oprs[c-040].offset |= (*data++ << 8);
	    ins->oprs[c-040].offset |= (((long) *data++) << 16);
	    ins->oprs[c-040].offset |= (((long) *data++) << 24);
	}
	if (c >= 050 && c <= 052) {
	    ins->oprs[c-050].offset = (signed char) *data++;
	    ins->oprs[c-050].segment |= SEG_RELATIVE;
	}
	if (c >= 060 && c <= 062) {
	    ins->oprs[c-060].offset = *data++;
	    ins->oprs[c-060].offset |= (*data++ << 8);
	    ins->oprs[c-060].segment |= SEG_RELATIVE;
	    ins->oprs[c-060].segment &= ~SEG_32BIT;
	}
	if (c >= 064 && c <= 066) {
	    ins->oprs[c-064].offset = *data++;
	    ins->oprs[c-064].offset |= (*data++ << 8);
	    if (asize == 32) {
		ins->oprs[c-064].offset |= (((long) *data++) << 16);
		ins->oprs[c-064].offset |= (((long) *data++) << 24);
		ins->oprs[c-064].segment |= SEG_32BIT;
	    } else
		ins->oprs[c-064].segment &= ~SEG_32BIT;
	    ins->oprs[c-064].segment |= SEG_RELATIVE;
	    if (segsize != asize)
		ins->oprs[c-064].addr_size = asize;
	}
	if (c >= 070 && c <= 072) {
	    ins->oprs[c-070].offset = *data++;
	    ins->oprs[c-070].offset |= (*data++ << 8);
	    ins->oprs[c-070].offset |= (((long) *data++) << 16);
	    ins->oprs[c-070].offset |= (((long) *data++) << 24);
	    ins->oprs[c-070].segment |= SEG_32BIT | SEG_RELATIVE;
	}
	if (c >= 0100 && c <= 0177) {
	    int modrm = *data++;
	    ins->oprs[c & 07].basereg = (modrm >> 3) & 07;
	    ins->oprs[c & 07].segment |= SEG_RMREG;
	    data = do_ea (data, modrm, asize, segsize,
			  &ins->oprs[(c >> 3) & 07]);
	}
	if (c >= 0200 && c <= 0277) {
	    int modrm = *data++;
	    if (((modrm >> 3) & 07) != (c & 07))
		return FALSE;	       /* spare field doesn't match up */
	    data = do_ea (data, modrm, asize, segsize,
			  &ins->oprs[(c >> 3) & 07]);
	}
	if (c >= 0300 && c <= 0302) {
	    if (asize)
		ins->oprs[c-0300].segment |= SEG_32BIT;
	    else
		ins->oprs[c-0300].segment &= ~SEG_32BIT;
	    a_used = TRUE;
	}
	if (c == 0310) {
	    if (asize == 32)
		return FALSE;
	    else
		a_used = TRUE;
	}
	if (c == 0311) {
	    if (asize == 16)
		return FALSE;
	    else
		a_used = TRUE;
	}
	if (c == 0312) {
	    if (asize != segsize)
		return FALSE;
	    else
		a_used = TRUE;
	}
	if (c == 0320) {
	    if (osize == 32)
		return FALSE;
	    else
		o_used = TRUE;
	}
	if (c == 0321) {
	    if (osize == 16)
		return FALSE;
	    else
		o_used = TRUE;
	}
	if (c == 0322) {
	    if (osize != segsize)
		return FALSE;
	    else
		o_used = TRUE;
	}
	if (c == 0330) {
	    int t = *r++, d = *data++;
	    if (d < t || d > t+15)
		return FALSE;
	    else
		ins->condition = d - t;
	}
	if (c == 0331) {
	    if ( rep )
	        return FALSE;
	}
	if (c == 0332) {
	    if (drep == P_REP)
	        drep = P_REPE;
	}
	if (c == 0333) {
	    if ( rep != 0xF3 )
	        return FALSE;
	    drep = 0;
	}
    }

    /*
     * Check for unused rep or a/o prefixes.
     */
    ins->nprefix = 0;
    if (drep)
        ins->prefixes[ins->nprefix++] = drep;
    if (!a_used && asize != segsize)
	ins->prefixes[ins->nprefix++] = (asize == 16 ? P_A16 : P_A32);
    if (!o_used && osize != segsize)
	ins->prefixes[ins->nprefix++] = (osize == 16 ? P_O16 : P_O32);

    return data - origdata;
}

long disasm (unsigned char *data, char *output, int segsize, long offset,
	     int autosync, unsigned long prefer)
{
    struct itemplate **p, **best_p;
    int length, best_length = 0;
    char *segover;
    int rep, lock, asize, osize, i, slen, colon;
    unsigned char *origdata;
    int works;
    insn tmp_ins, ins;
    unsigned long goodness, best;

    /*
     * Scan for prefixes.
     */
    asize = osize = segsize;
    segover = NULL;
    rep = lock = 0;
    origdata = data;
    for (;;) {
	if (*data == 0xF3 || *data == 0xF2)
	    rep = *data++;
	else if (*data == 0xF0)
	    lock = *data++;
	else if (*data == 0x2E || *data == 0x36 || *data == 0x3E ||
		 *data == 0x26 || *data == 0x64 || *data == 0x65) {
	    switch (*data++) {
	      case 0x2E: segover = "cs"; break;
	      case 0x36: segover = "ss"; break;
	      case 0x3E: segover = "ds"; break;
	      case 0x26: segover = "es"; break;
	      case 0x64: segover = "fs"; break;
	      case 0x65: segover = "gs"; break;
	    }
	} else if (*data == 0x66)
	    osize = 48 - segsize, data++;
	else if (*data == 0x67)
	    asize = 48 - segsize, data++;
	else
	    break;
    }

    tmp_ins.oprs[0].segment = tmp_ins.oprs[1].segment =
    tmp_ins.oprs[2].segment =
    tmp_ins.oprs[0].addr_size = tmp_ins.oprs[1].addr_size =
      tmp_ins.oprs[2].addr_size = (segsize == 16 ? 0 : SEG_32BIT);
    tmp_ins.condition = -1;
    best = ~0UL;		/* Worst possible */
    best_p = NULL;
    for (p = itable[*data]; *p; p++) {
      if ( (length = matches(*p, data, asize, osize,
			     segsize, rep, &tmp_ins)) ) {
	works = TRUE;
	/*
	 * Final check to make sure the types of r/m match up.
	 */
	for (i = 0; i < (*p)->operands; i++) {
	  if (
	      /* If it's a mem-only EA but we have a register, die. */
	      ((tmp_ins.oprs[i].segment & SEG_RMREG) &&
	       !(MEMORY & ~(*p)->opd[i])) ||
	      
	      /* If it's a reg-only EA but we have a memory ref, die. */
	      (!(tmp_ins.oprs[i].segment & SEG_RMREG) &&
	       !(REGNORM & ~(*p)->opd[i]) &&
	       !((*p)->opd[i] & REG_SMASK)) ||
	      
	      /* Register type mismatch (eg FS vs REG_DESS): die. */
	      ((((*p)->opd[i] & (REGISTER | FPUREG)) ||
		(tmp_ins.oprs[i].segment & SEG_RMREG)) &&
	       !whichreg ((*p)->opd[i], tmp_ins.oprs[i].basereg))) {
	    works = FALSE;
	    break;
	  }
	}  
	
	if (works) {
	  goodness = ((*p)->flags & IF_PFMASK) ^ prefer;
	  if ( goodness < best ) {
	    /* This is the best one found so far */
	    best        = goodness;
	    best_p      = p;
	    best_length = length;
	    ins         = tmp_ins;
	  }
	}
      }
    }

    if (!best_p)
	return 0;		       /* no instruction was matched */

    /* Pick the best match */
    p      = best_p;
    length = best_length;

    slen = 0;

    if (lock)
	slen += sprintf(output+slen, "lock ");
    for (i = 0; i < ins.nprefix; i++)
	switch (ins.prefixes[i]) {
	  case P_REP:   slen += sprintf(output+slen, "rep "); break;
	  case P_REPE:  slen += sprintf(output+slen, "repe "); break;
	  case P_REPNE: slen += sprintf(output+slen, "repne "); break;
	  case P_A16:   slen += sprintf(output+slen, "a16 "); break;
	  case P_A32:   slen += sprintf(output+slen, "a32 "); break;
	  case P_O16:   slen += sprintf(output+slen, "o16 "); break;
	  case P_O32:   slen += sprintf(output+slen, "o32 "); break;
	}

    for (i = 0; i < elements(ico); i++)
	if ((*p)->opcode == ico[i]) {
	    slen += sprintf(output+slen, "%s%s", icn[i],
			    whichcond(ins.condition));
	    break;
	}
    if (i >= elements(ico))
	slen += sprintf(output+slen, "%s", insn_names[(*p)->opcode]);
    colon = FALSE;
    length += data - origdata;	       /* fix up for prefixes */
    for (i=0; i<(*p)->operands; i++) {
	output[slen++] = (colon ? ':' : i==0 ? ' ' : ',');

	if (ins.oprs[i].segment & SEG_RELATIVE) {
	    ins.oprs[i].offset += offset + length;
	    /*
	     * sort out wraparound
	     */
	    if (!(ins.oprs[i].segment & SEG_32BIT))
		ins.oprs[i].offset &= 0xFFFF;
	    /*
	     * add sync marker, if autosync is on
	     */
	    if (autosync)
		add_sync (ins.oprs[i].offset, 0L);
	}

	if ((*p)->opd[i] & COLON)
	    colon = TRUE;
	else
	    colon = FALSE;

	if (((*p)->opd[i] & (REGISTER | FPUREG)) ||
	    (ins.oprs[i].segment & SEG_RMREG)) 
	{
	    ins.oprs[i].basereg = whichreg ((*p)->opd[i],
					    ins.oprs[i].basereg);
	    if ( (*p)->opd[i] & TO )
		slen += sprintf(output+slen, "to ");
	    slen += sprintf(output+slen, "%s",
			    reg_names[ins.oprs[i].basereg-EXPR_REG_START]);
	} else if (!(UNITY & ~(*p)->opd[i])) {
	    output[slen++] = '1';
	} else if ( (*p)->opd[i] & IMMEDIATE ) {
	    if ( (*p)->opd[i] & BITS8 ) {
		slen += sprintf(output+slen, "byte ");
		if (ins.oprs[i].segment & SEG_SIGNED) {
		    if (ins.oprs[i].offset < 0) {
			ins.oprs[i].offset *= -1;
			output[slen++] = '-';
		    } else
			output[slen++] = '+';
		}
	    } else if ( (*p)->opd[i] & BITS16 ) {
		slen += sprintf(output+slen, "word ");
	    } else if ( (*p)->opd[i] & BITS32 ) {
		slen += sprintf(output+slen, "dword ");
	    } else if ( (*p)->opd[i] & NEAR ) {
		slen += sprintf(output+slen, "near ");
	    } else if ( (*p)->opd[i] & SHORT ) {
		slen += sprintf(output+slen, "short ");
	    }
	    slen += sprintf(output+slen, "0x%lx", ins.oprs[i].offset);
	} else if ( !(MEM_OFFS & ~(*p)->opd[i]) ) {
	    slen += sprintf(output+slen, "[%s%s%s0x%lx]",
			    (segover ? segover : ""),
			    (segover ? ":" : ""),
			    (ins.oprs[i].addr_size == 32 ? "dword " :
			     ins.oprs[i].addr_size == 16 ? "word " : ""),
			    ins.oprs[i].offset);
	    segover = NULL;
	} else if ( !(REGMEM & ~(*p)->opd[i]) ) {
	    int started = FALSE;
	    if ( (*p)->opd[i] & BITS8 )
		slen += sprintf(output+slen, "byte ");
	    if ( (*p)->opd[i] & BITS16 )
		slen += sprintf(output+slen, "word ");
	    if ( (*p)->opd[i] & BITS32 )
		slen += sprintf(output+slen, "dword ");
	    if ( (*p)->opd[i] & BITS64 )
		slen += sprintf(output+slen, "qword ");
	    if ( (*p)->opd[i] & BITS80 )
		slen += sprintf(output+slen, "tword ");
	    if ( (*p)->opd[i] & FAR )
		slen += sprintf(output+slen, "far ");
	    if ( (*p)->opd[i] & NEAR )
		slen += sprintf(output+slen, "near ");
	    output[slen++] = '[';
	    if (ins.oprs[i].addr_size)
		slen += sprintf(output+slen, "%s",
				(ins.oprs[i].addr_size == 32 ? "dword " :
				 ins.oprs[i].addr_size == 16 ? "word " : ""));
	    if (segover) {
		slen += sprintf(output+slen, "%s:", segover);
		segover = NULL;
	    }
	    if (ins.oprs[i].basereg != -1) {
		slen += sprintf(output+slen, "%s",
				reg_names[(ins.oprs[i].basereg -
					   EXPR_REG_START)]);
		started = TRUE;
	    }
	    if (ins.oprs[i].indexreg != -1) {
		if (started)
		    output[slen++] = '+';
		slen += sprintf(output+slen, "%s",
				reg_names[(ins.oprs[i].indexreg -
					   EXPR_REG_START)]);
		if (ins.oprs[i].scale > 1)
		    slen += sprintf(output+slen, "*%d", ins.oprs[i].scale);
		started = TRUE;
	    }
	    if (ins.oprs[i].segment & SEG_DISP8) {
		int sign = '+';
		if (ins.oprs[i].offset & 0x80) {
		    ins.oprs[i].offset = - (signed char) ins.oprs[i].offset;
		    sign = '-';
		}
		slen += sprintf(output+slen, "%c0x%lx", sign,
				ins.oprs[i].offset);
	    } else if (ins.oprs[i].segment & SEG_DISP16) {
		if (started)
		    output[slen++] = '+';
		slen += sprintf(output+slen, "0x%lx", ins.oprs[i].offset);
	    } else if (ins.oprs[i].segment & SEG_DISP32) {
		if (started)
		    output[slen++] = '+';
		slen += sprintf(output+slen, "0x%lx", ins.oprs[i].offset);
	    }
	    output[slen++] = ']';
	} else {
	    slen += sprintf(output+slen, "<operand%d>", i);
	}
    }
    output[slen] = '\0';
    if (segover) {		       /* unused segment override */
	char *p = output;
	int count = slen+1;
	while (count--)
	    p[count+3] = p[count];
	strncpy (output, segover, 2);
	output[2] = ' ';
    }
    return length;
}

long eatbyte (unsigned char *data, char *output) 
{
    sprintf(output, "db 0x%02X", *data);
    return 1;
}
