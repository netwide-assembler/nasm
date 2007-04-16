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
#include <inttypes.h>

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
#define SEG_RELATIVE	  1
#define SEG_32BIT	  2
#define SEG_RMREG	  4
#define SEG_DISP8	  8
#define SEG_DISP16	 16
#define SEG_DISP32	 32
#define SEG_NODISP	 64
#define SEG_SIGNED	128
#define SEG_64BIT	256

/*
 * REX flags
 */
#define REX_P		0x40	/* REX prefix present */
#define REX_W		0x08	/* 64-bit operand size */
#define REX_R		0x04	/* ModRM reg extension */
#define REX_X		0x02	/* SIB index extension */
#define REX_B		0x01	/* ModRM r/m extension */

#include "regdis.c"

#define getu8(x) (*(uint8_t *)(x))
#if defined(__i386__) || defined(__x86_64__)
/* Littleendian CPU which can handle unaligned references */
#define getu16(x) (*(uint16_t *)(x))
#define getu32(x) (*(uint32_t *)(x))
#define getu64(x) (*(uint64_t *)(x))
#else
static uint16_t getu16(uint8_t *data)
{
    return (uint16_t)data[0] + ((uint16_t)data[1] << 8);
}
static uint32_t getu32(uint8_t *data)
{
    return (uint32_t)getu16(data) + ((uint32_t)getu16(data+2) << 16);
}
static uint64_t getu64(uint8_t *data)
{
    return (uint64_t)getu32(data) + ((uint64_t)getu32(data+4) << 32);
}
#endif

#define gets8(x) ((int8_t)getu8(x))
#define gets16(x) ((int16_t)getu16(x))
#define gets32(x) ((int32_t)getu32(x))
#define gets64(x) ((int64_t)getu64(x))

/* Important: regval must already have been adjusted for rex extensions */
static int whichreg(int32_t regflags, int regval, int rex)
{
    if (!(REG_AL & ~regflags))
        return R_AL;
    if (!(REG_AX & ~regflags))
        return R_AX;
    if (!(REG_EAX & ~regflags))
        return R_EAX;
    if (!(REG_RAX & ~regflags))
	return R_RAX;
    if (!(REG_DL & ~regflags))
        return R_DL;
    if (!(REG_DX & ~regflags))
        return R_DX;
    if (!(REG_EDX & ~regflags))
        return R_EDX;
    if (!(REG_RDX & ~regflags))
        return R_RDX;
    if (!(REG_CL & ~regflags))
        return R_CL;
    if (!(REG_CX & ~regflags))
        return R_CX;
    if (!(REG_ECX & ~regflags))
        return R_ECX;
    if (!(REG_RCX & ~regflags))
        return R_RCX;
    if (!(FPU0 & ~regflags))
        return R_ST0;
    if (!(REG_CS & ~regflags))
        return (regval == 1) ? R_CS : 0;
    if (!(REG_DESS & ~regflags))
        return (regval == 0 || regval == 2
                || regval == 3 ? rd_sreg[regval] : 0);
    if (!(REG_FSGS & ~regflags))
        return (regval == 4 || regval == 5 ? rd_sreg[regval] : 0);
    if (!(REG_SEG67 & ~regflags))
        return (regval == 6 || regval == 7 ? rd_sreg[regval] : 0);

    /* All the entries below look up regval in an 16-entry array */
    if (regval < 0 || regval > 15)
        return 0;

    if (!(rex & REX_P) && regval > 7)
	return 0;		/* Internal error! */

    if (!((REGMEM | BITS8) & ~regflags)) {
	if (rex & REX_P)
	    return rd_reg8_rex[regval];
	else
	    return rd_reg8[regval];
    }
    if (!((REGMEM | BITS16) & ~regflags))
        return rd_reg16[regval];
    if (!((REGMEM | BITS32) & ~regflags))
        return rd_reg32[regval];
    if (!((REGMEM | BITS64) & ~regflags))
        return rd_reg64[regval];
    if (!(REG_SREG & ~regflags))
        return rd_sreg[regval & 7]; /* Ignore REX */
    if (!(REG_CREG & ~regflags))
        return rd_creg[regval];
    if (!(REG_DREG & ~regflags))
        return rd_dreg[regval];
    if (!(REG_TREG & ~regflags)) {
	if (rex & REX_P)
	    return 0;		/* TR registers are ill-defined with rex */
        return rd_treg[regval];
    }
    if (!(FPUREG & ~regflags))
        return rd_fpureg[regval & 7]; /* Ignore REX */
    if (!(MMXREG & ~regflags))
        return rd_mmxreg[regval & 7]; /* Ignore REX */
    if (!(XMMREG & ~regflags))
        return rd_xmmreg[regval];

    return 0;
}

static const char *whichcond(int condval)
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
static uint8_t *do_ea(uint8_t *data, int modrm, int asize,
		      int segsize, operand * op, int rex)
{
    int mod, rm, scale, index, base;

    mod = (modrm >> 6) & 03;
    rm = modrm & 07;

    if (mod == 3) {             /* pure register version */
        op->basereg = rm+(rex & REX_B ? 8 : 0);
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
        op->scale = 1;          /* always, in 16 bits */
        switch (rm) {
        case 0:
            op->basereg = R_BX;
            op->indexreg = R_SI;
            break;
        case 1:
            op->basereg = R_BX;
            op->indexreg = R_DI;
            break;
        case 2:
            op->basereg = R_BP;
            op->indexreg = R_SI;
            break;
        case 3:
            op->basereg = R_BP;
            op->indexreg = R_DI;
            break;
        case 4:
            op->basereg = R_SI;
            break;
        case 5:
            op->basereg = R_DI;
            break;
        case 6:
            op->basereg = R_BP;
            break;
        case 7:
            op->basereg = R_BX;
            break;
        }
        if (rm == 6 && mod == 0) {      /* special case */
            op->basereg = -1;
            if (segsize != 16)
                op->addr_size = 16;
            mod = 2;            /* fake disp16 */
        }
        switch (mod) {
        case 0:
            op->segment |= SEG_NODISP;
            break;
        case 1:
            op->segment |= SEG_DISP8;
            op->offset = (int8_t)*data++;
            break;
        case 2:
            op->segment |= SEG_DISP16;
            op->offset = *data++;
            op->offset |= ((unsigned)*data++) << 8;
            break;
        }
        return data;
    } else {
        /*
         * Once again, <mod> specifies displacement size (this time
         * none, byte or *dword*), while <rm> specifies the base
         * register. Again, [EBP] is missing, replaced by a pure
         * disp32 (this time that's mod=0,rm=*5*) in 32-bit mode,
	 * and RIP-relative addressing in 64-bit mode.
	 *
	 * However, rm=4
         * indicates not a single base register, but instead the
         * presence of a SIB byte...
         */
	int a64 = asize == 64;

        op->indexreg = -1;

	if (a64)
	    op->basereg = rd_reg64[rm | ((rex & REX_B) ? 8 : 0)];
	else
	    op->basereg = rd_reg32[rm | ((rex & REX_B) ? 8 : 0)];

        if (rm == 5 && mod == 0) {
	    if (segsize == 64) {
		op->basereg = R_RIP;
		op->segment |= SEG_RELATIVE;
		mod = 2;	/* fake disp32 */
	    } else {
		op->basereg = -1;
		if (segsize != 32)
		    op->addr_size = 32;
		mod = 2;            /* fake disp32 */
	    }
        }

        if (rm == 4) {          /* process SIB */
            scale = (*data >> 6) & 03;
            index = (*data >> 3) & 07;
            base = *data & 07;
            data++;

            op->scale = 1 << scale;

	    if (index == 4)
		op->indexreg = -1; /* ESP/RSP/R12 cannot be an index */
	    else if (a64)
		op->indexreg = rd_reg64[index | ((rex & REX_X) ? 8 : 0)];
	    else
		op->indexreg = rd_reg64[index | ((rex & REX_X) ? 8 : 0)];

	    if (base == 5 && mod == 0) {
		op->basereg = -1;
		mod = 2;	/* Fake disp32 */
	    } else if (a64)
		op->basereg = rd_reg64[base | ((rex & REX_B) ? 8 : 0)];
	    else
		op->basereg = rd_reg32[base | ((rex & REX_B) ? 8 : 0)];
        }

        switch (mod) {
        case 0:
            op->segment |= SEG_NODISP;
            break;
        case 1:
            op->segment |= SEG_DISP8;
            op->offset = gets8(data);
	    data++;
            break;
        case 2:
            op->segment |= SEG_DISP32;
            op->offset = getu32(data);
	    data += 4;
            break;
        }
        return data;
    }
}

/*
 * Determine whether the instruction template in t corresponds to the data
 * stream in data. Return the number of bytes matched if so.
 */
static int matches(struct itemplate *t, uint8_t *data, int asize,
                   int osize, int segsize, int rep, insn * ins,
		   int rex, int *rexout)
{
    uint8_t *r = (uint8_t *)(t->code);
    uint8_t *origdata = data;
    int a_used = FALSE, o_used = FALSE;
    int drep = 0;
    
    *rexout = rex;

    if (segsize == 64) {
	if (t->flags & IF_NOLONG)
	    return FALSE;
    } else {
	if (t->flags & IF_X64)
	    return FALSE;
    }

    if (rep == 0xF2)
        drep = P_REPNE;
    else if (rep == 0xF3)
        drep = P_REP;

    while (*r) {
        int c = *r++;

	/* FIX: change this into a switch */
	if (c >= 01 && c <= 03) {
            while (c--)
                if (*r++ != *data++)
                    return FALSE;
	} else if (c == 04) {
            switch (*data++) {
            case 0x07:
                ins->oprs[0].basereg = 0;
                break;
            case 0x17:
                ins->oprs[0].basereg = 2;
                break;
            case 0x1F:
                ins->oprs[0].basereg = 3;
                break;
            default:
                return FALSE;
            }
	} else if (c == 05) {
            switch (*data++) {
            case 0xA1:
                ins->oprs[0].basereg = 4;
                break;
            case 0xA9:
                ins->oprs[0].basereg = 5;
                break;
            default:
                return FALSE;
	    }
	} else if (c == 06) {
            switch (*data++) {
            case 0x06:
                ins->oprs[0].basereg = 0;
                break;
            case 0x0E:
                ins->oprs[0].basereg = 1;
                break;
            case 0x16:
                ins->oprs[0].basereg = 2;
                break;
            case 0x1E:
                ins->oprs[0].basereg = 3;
                break;
            default:
                return FALSE;
            }
	} else if (c == 07) {
            switch (*data++) {
            case 0xA0:
                ins->oprs[0].basereg = 4;
                break;
            case 0xA8:
                ins->oprs[0].basereg = 5;
                break;
            default:
                return FALSE;
            }
	} else if (c >= 010 && c <= 012) {
            int t = *r++, d = *data++;
            if (d < t || d > t + 7)
                return FALSE;
            else {
                ins->oprs[c - 010].basereg = (d-t)+(rex & REX_B ? 8 : 0);
                ins->oprs[c - 010].segment |= SEG_RMREG;
            }
        } else if (c == 017) {
            if (*data++)
                return FALSE;
	} else if (c >= 014 && c <= 016) {
            ins->oprs[c - 014].offset = (int8_t)*data++;
            ins->oprs[c - 014].segment |= SEG_SIGNED;
        } else if (c >= 020 && c <= 022) {
            ins->oprs[c - 020].offset = *data++;
	} else if (c >= 024 && c <= 026) {
            ins->oprs[c - 024].offset = *data++;
	} else if (c >= 030 && c <= 032) {
            ins->oprs[c - 030].offset = getu16(data);
	    data += 2;
        } else if (c >= 034 && c <= 036) {
	    if (osize == 32) {
		ins->oprs[c - 034].offset = getu32(data);
		data += 4;
	    } else {
		ins->oprs[c - 034].offset = getu16(data);
		data += 2;
	    }
            if (segsize != asize)
                ins->oprs[c - 034].addr_size = asize;
        } else if (c >= 040 && c <= 042) {
            ins->oprs[c - 040].offset = getu32(data);
	    data += 4;
        } else if (c >= 044 && c <= 046) {
	    switch (asize) {
	    case 16:
		ins->oprs[c - 044].offset = getu16(data);
		data += 2;
		break;
	    case 32:
		ins->oprs[c - 044].offset = getu32(data);
		data += 4;
		break;
	    case 64:
		ins->oprs[c - 044].offset = getu64(data);
		data += 8;
		break;
	    }
            if (segsize != asize)
                ins->oprs[c - 044].addr_size = asize;
        } else if (c >= 050 && c <= 052) {
            ins->oprs[c - 050].offset = gets8(data++);
            ins->oprs[c - 050].segment |= SEG_RELATIVE;
        } else if (c >= 054 && c <= 056) {
	    ins->oprs[c - 054].offset = getu64(data);
	    data += 8;
	} else if (c >= 060 && c <= 062) {
            ins->oprs[c - 060].offset = gets16(data);
	    data += 2;
            ins->oprs[c - 060].segment |= SEG_RELATIVE;
            ins->oprs[c - 060].segment &= ~SEG_32BIT;
        } else if (c >= 064 && c <= 066) {
	    if (osize == 16) {
		ins->oprs[c - 064].offset = getu16(data);
		data += 2;
                ins->oprs[c - 064].segment &= ~(SEG_32BIT|SEG_64BIT);
	    } else if (osize == 32) {
		ins->oprs[c - 064].offset = getu32(data);
		data += 4;
                ins->oprs[c - 064].segment &= ~SEG_64BIT;
                ins->oprs[c - 064].segment |= SEG_32BIT;
	    }	
            if (segsize != osize) {
                ins->oprs[c - 064].type =
                    (ins->oprs[c - 064].type & NON_SIZE)
                    | ((osize == 16) ? BITS16 : BITS32);
            }
        } else if (c >= 070 && c <= 072) {
            ins->oprs[c - 070].offset = getu32(data);
	    data += 4;
            ins->oprs[c - 070].segment |= SEG_32BIT | SEG_RELATIVE;
        } else if (c >= 0100 && c < 0130) {
            int modrm = *data++;
            ins->oprs[c & 07].basereg = ((modrm >> 3)&7)+(rex & REX_R ? 8 : 0);
            ins->oprs[c & 07].segment |= SEG_RMREG;
            data = do_ea(data, modrm, asize, segsize,
                         &ins->oprs[(c >> 3) & 07], rex);
        } else if (c >= 0130 && c <= 0132) {
            ins->oprs[c - 0130].offset = getu16(data);
	    data += 2;
        } else if (c >= 0140 && c <= 0142) {
	    ins->oprs[c - 0140].offset = getu32(data);
	    data += 4;
        } else if (c >= 0200 && c <= 0277) {
            int modrm = *data++;
            if (((modrm >> 3) & 07) != (c & 07))
                return FALSE;   /* spare field doesn't match up */
            data = do_ea(data, modrm, asize, segsize,
                         &ins->oprs[(c >> 3) & 07], rex);
        } else if (c >= 0300 && c <= 0302) {
            a_used = TRUE;
        } else if (c == 0310) {
            if (asize != 16)
                return FALSE;
            else
                a_used = TRUE;
        } else if (c == 0311) {
            if (asize == 16)
                return FALSE;
            else
                a_used = TRUE;
        } else if (c == 0312) {
            if (asize != segsize)
                return FALSE;
            else
                a_used = TRUE;
        } else if (c == 0320) {
            if (osize != 16)
                return FALSE;
            else
                o_used = TRUE;
        } else if (c == 0321) {
            if (osize != 32)
                return FALSE;
            else
                o_used = TRUE;
        } else if (c == 0322) {
            if (osize != (segsize == 16) ? 16 : 32)
                return FALSE;
            else
                o_used = TRUE;
        } else if (c == 0323) {
	    rex |= REX_W;	/* 64-bit only instruction */
	    osize = 64;
	} else if (c == 0324) {
	    if (!(rex & (REX_P|REX_W)) || osize != 64)
		return FALSE;
	} else if (c == 0330) {
            int t = *r++, d = *data++;
            if (d < t || d > t + 15)
                return FALSE;
            else
                ins->condition = d - t;
        } else if (c == 0331) {
            if (rep)
                return FALSE;
        } else if (c == 0332) {
            if (drep == P_REP)
                drep = P_REPE;
        } else if (c == 0333) {
            if (rep != 0xF3)
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
        ins->prefixes[ins->nprefix++] = asize == 16 ? P_A16 : P_A32;
    if (!o_used && osize == ((segsize == 16) ? 32 : 16)) {
	fprintf(stderr, "osize = %d, segsize = %d\n", osize, segsize);
        ins->prefixes[ins->nprefix++] = osize == 16 ? P_O16 : P_O32;
    }

    /* Fix: check for redundant REX prefixes */

    *rexout = rex;
    return data - origdata;
}

int32_t disasm(uint8_t *data, char *output, int outbufsize, int segsize,
            int32_t offset, int autosync, uint32_t prefer)
{
    struct itemplate **p, **best_p;
    int length, best_length = 0;
    char *segover;
    int rep, lock, asize, osize, i, slen, colon, rex, rexout, best_rex;
    uint8_t *origdata;
    int works;
    insn tmp_ins, ins;
    uint32_t goodness, best;

    /*
     * Scan for prefixes.
     */
    asize = segsize;
    osize = (segsize == 64) ? 32 : segsize;
    rex = 0;
    segover = NULL;
    rep = lock = 0;
    origdata = data;
    for (;;) {
        if (*data == 0xF3 || *data == 0xF2)
            rep = *data++;
        else if (*data == 0xF0)
            lock = *data++;
        else if (*data == 0x2E)
	    segover = "cs", data++;
	else if (*data == 0x36)
	    segover = "ss", data++;
	else if (*data == 0x3E)
	    segover = "ds", data++;
	else if (*data == 0x26)
	    segover = "es", data++;
	else if (*data == 0x64)
	    segover = "fs", data++;
	else if (*data == 0x65)
	    segover = "gs", data++;
	else if (*data == 0x66) {
	    osize = (segsize == 16) ? 32 : 16;
	    data++;
	} else if (*data == 0x67) {
	    asize = (segsize == 32) ? 16 : 32;
	    data++;
	} else if (segsize == 64 && (*data & 0xf0) == REX_P) {
	    rex = *data++;
	    if (rex & REX_W)
		osize = 64;
	    break;		/* REX is always the last prefix */
	} else {
            break;
	}
    }

    tmp_ins.oprs[0].segment = tmp_ins.oprs[1].segment =
        tmp_ins.oprs[2].segment =
        tmp_ins.oprs[0].addr_size = tmp_ins.oprs[1].addr_size =
        tmp_ins.oprs[2].addr_size = (segsize == 64 ? SEG_64BIT :
				     segsize == 32 ? SEG_32BIT : 0);
    tmp_ins.condition = -1;
    best = -1;			/* Worst possible */
    best_p = NULL;
    best_rex = 0;
    for (p = itable[*data]; *p; p++) {
        if ((length = matches(*p, data, asize, osize,
                              segsize, rep, &tmp_ins, rex, &rexout))) {
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
                        !whichreg((*p)->opd[i],
                                  tmp_ins.oprs[i].basereg, rexout))) {
                    works = FALSE;
                    break;
                }
            }

            if (works) {
                goodness = ((*p)->flags & IF_PFMASK) ^ prefer;
                if (goodness < best) {
                    /* This is the best one found so far */
                    best = goodness;
                    best_p = p;
                    best_length = length;
                    ins = tmp_ins;
		    best_rex = rexout;
                }
            }
        }
    }

    if (!best_p)
        return 0;               /* no instruction was matched */

    /* Pick the best match */
    p = best_p;
    length = best_length;
    rex = best_rex;
    if (best_rex & REX_W)
	osize = 64;

    slen = 0;

    /* TODO: snprintf returns the value that the string would have if
     *      the buffer were long enough, and not the actual length of 
     *      the returned string, so each instance of using the return
     *      value of snprintf should actually be checked to assure that
     *      the return value is "sane."  Maybe a macro wrapper could
     *      be used for that purpose.
     */
    if (lock)
        slen += snprintf(output + slen, outbufsize - slen, "lock ");
    for (i = 0; i < ins.nprefix; i++)
        switch (ins.prefixes[i]) {
        case P_REP:
            slen += snprintf(output + slen, outbufsize - slen, "rep ");
            break;
        case P_REPE:
            slen += snprintf(output + slen, outbufsize - slen, "repe ");
            break;
        case P_REPNE:
            slen += snprintf(output + slen, outbufsize - slen, "repne ");
            break;
        case P_A16:
            slen += snprintf(output + slen, outbufsize - slen, "a16 ");
            break;
        case P_A32:
            slen += snprintf(output + slen, outbufsize - slen, "a32 ");
            break;
        case P_O16:
            slen += snprintf(output + slen, outbufsize - slen, "o16 ");
            break;
        case P_O32:
            slen += snprintf(output + slen, outbufsize - slen, "o32 ");
            break;
        }

    for (i = 0; i < elements(ico); i++)
        if ((*p)->opcode == ico[i]) {
            slen +=
                snprintf(output + slen, outbufsize - slen, "%s%s", icn[i],
                         whichcond(ins.condition));
            break;
        }
    if (i >= elements(ico))
        slen +=
            snprintf(output + slen, outbufsize - slen, "%s",
                     insn_names[(*p)->opcode]);
    colon = FALSE;
    length += data - origdata;  /* fix up for prefixes */
    for (i = 0; i < (*p)->operands; i++) {
        output[slen++] = (colon ? ':' : i == 0 ? ' ' : ',');

        if (ins.oprs[i].segment & SEG_RELATIVE) {
            ins.oprs[i].offset += offset + length;
            /*
             * sort out wraparound
             */
            if (!(ins.oprs[i].segment & (SEG_32BIT|SEG_64BIT)))
		ins.oprs[i].offset &= 0xffff;
            /*
             * add sync marker, if autosync is on
             */
            if (autosync)
                add_sync(ins.oprs[i].offset, 0L);
        }

        if ((*p)->opd[i] & COLON)
            colon = TRUE;
        else
            colon = FALSE;

        if (((*p)->opd[i] & (REGISTER | FPUREG)) ||
            (ins.oprs[i].segment & SEG_RMREG)) {
            ins.oprs[i].basereg = whichreg((*p)->opd[i],
                                           ins.oprs[i].basereg, rex);
            if ((*p)->opd[i] & TO)
                slen += snprintf(output + slen, outbufsize - slen, "to ");
            slen += snprintf(output + slen, outbufsize - slen, "%s",
                             reg_names[ins.oprs[i].basereg -
                                       EXPR_REG_START]);
        } else if (!(UNITY & ~(*p)->opd[i])) {
            output[slen++] = '1';
        } else if ((*p)->opd[i] & IMMEDIATE) {
            if ((*p)->opd[i] & BITS8) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "byte ");
                if (ins.oprs[i].segment & SEG_SIGNED) {
                    if (ins.oprs[i].offset < 0) {
                        ins.oprs[i].offset *= -1;
                        output[slen++] = '-';
                    } else
                        output[slen++] = '+';
                }
            } else if ((*p)->opd[i] & BITS16) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "word ");
            } else if ((*p)->opd[i] & BITS32) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "dword ");
            } else if ((*p)->opd[i] & BITS64) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "qword ");
            } else if ((*p)->opd[i] & NEAR) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "near ");
            } else if ((*p)->opd[i] & SHORT) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "short ");
            }
            slen +=
                snprintf(output + slen, outbufsize - slen, "0x%"PRIx64"",
                         ins.oprs[i].offset);
        } else if (!(MEM_OFFS & ~(*p)->opd[i])) {
            slen +=
                snprintf(output + slen, outbufsize - slen, "[%s%s%s0x%"PRIx64"]",
                         ((const char*)segover ? (const char*)segover : ""),    /* placate type mistmatch warning */
                         ((const char*)segover ? ":" : ""),                     /* by using (const char*) instead of uint8_t* */
                         (ins.oprs[i].addr_size ==
                          32 ? "dword " : ins.oprs[i].addr_size ==
                          16 ? "word " : ""), ins.oprs[i].offset);
            segover = NULL;
        } else if (!(REGMEM & ~(*p)->opd[i])) {
            int started = FALSE;
            if ((*p)->opd[i] & BITS8)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "byte ");
            if ((*p)->opd[i] & BITS16)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "word ");
            if ((*p)->opd[i] & BITS32)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "dword ");
            if ((*p)->opd[i] & BITS64)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "qword ");
            if ((*p)->opd[i] & BITS80)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "tword ");
            if ((*p)->opd[i] & FAR)
                slen += snprintf(output + slen, outbufsize - slen, "far ");
            if ((*p)->opd[i] & NEAR)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "near ");
            output[slen++] = '[';
            if (ins.oprs[i].addr_size)
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 (ins.oprs[i].addr_size == 64 ? "qword " :
				  ins.oprs[i].addr_size == 32 ? "dword " :
                                  ins.oprs[i].addr_size == 16 ? "word " :
				  ""));
            if (segover) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s:",
                             segover);
                segover = NULL;
            }
            if (ins.oprs[i].basereg != -1) {
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 reg_names[(ins.oprs[i].basereg -
                                            EXPR_REG_START)]);
                started = TRUE;
            }
            if (ins.oprs[i].indexreg != -1) {
                if (started)
                    output[slen++] = '+';
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 reg_names[(ins.oprs[i].indexreg -
                                            EXPR_REG_START)]);
                if (ins.oprs[i].scale > 1)
                    slen +=
                        snprintf(output + slen, outbufsize - slen, "*%d",
                                 ins.oprs[i].scale);
                started = TRUE;
            }
            if (ins.oprs[i].segment & SEG_DISP8) {
		int minus = 0;
		int8_t offset = ins.oprs[i].offset;
		if (offset < 0) {
		    minus = 1;
		    offset = -offset;
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s0x%"PRIx8"",
			     minus ? "-" : "+", offset);
            } else if (ins.oprs[i].segment & SEG_DISP16) {
		int minus = 0;
		int16_t offset = ins.oprs[i].offset;
		if (offset < 0) {
		    minus = 1;
		    offset = -offset;
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s0x%"PRIx16"",
			     minus ? "-" : started ? "+" : "", offset);
            } else if (ins.oprs[i].segment & SEG_DISP32) {
		    char *prefix = "";
		    int32_t offset = ins.oprs[i].offset;
		    if (ins.oprs[i].basereg == R_RIP) {
			prefix = ":";
		    } else if (offset < 0) {
			offset = -offset;
			prefix = "-";
		    } else {
			prefix = started ? "+" : "";
		    }
		    slen +=
			snprintf(output + slen, outbufsize - slen,
				 "%s0x%"PRIx32"", prefix, offset);
            }
            output[slen++] = ']';
        } else {
            slen +=
                snprintf(output + slen, outbufsize - slen, "<operand%d>",
                         i);
        }
    }
    output[slen] = '\0';
    if (segover) {              /* unused segment override */
        char *p = output;
        int count = slen + 1;
        while (count--)
            p[count + 3] = p[count];
        strncpy(output, segover, 2);
        output[2] = ' ';
    }
    return length;
}

int32_t eatbyte(uint8_t *data, char *output, int outbufsize)
{
    snprintf(output, outbufsize, "db 0x%02X", *data);
    return 1;
}
