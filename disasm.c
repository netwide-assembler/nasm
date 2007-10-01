/* disasm.c   where all the _work_ gets done in the Netwide Disassembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 27/iii/95 by Simon Tatham
 */

#include "compiler.h"

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <inttypes.h>

#include "nasm.h"
#include "disasm.h"
#include "sync.h"
#include "insns.h"

#include "names.c"

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

#include "regdis.c"

/*
 * Prefix information
 */
struct prefix_info {
    uint8_t osize;		/* Operand size */
    uint8_t asize;		/* Address size */
    uint8_t osp;		/* Operand size prefix present */
    uint8_t asp;		/* Address size prefix present */
    uint8_t rep;		/* Rep prefix present */
    uint8_t seg;		/* Segment override prefix present */
    uint8_t lock;		/* Lock prefix present */
    uint8_t rex;		/* Rex prefix present */
};

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
static enum reg_enum whichreg(int32_t regflags, int regval, int rex)
{
    if (!(regflags & (REGISTER|REGMEM)))
	return 0;		/* Registers not permissible?! */

    regflags |= REGISTER;

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

    if (!(REG8 & ~regflags)) {
	if (rex & REX_P)
	    return rd_reg8_rex[regval];
	else
	    return rd_reg8[regval];
    }
    if (!(REG16 & ~regflags))
        return rd_reg16[regval];
    if (!(REG32 & ~regflags))
        return rd_reg32[regval];
    if (!(REG64 & ~regflags))
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
 * Process a DREX suffix
 */
static uint8_t *do_drex(uint8_t *data, insn *ins)
{
    uint8_t drex = *data++;
    operand *dst = &ins->oprs[ins->drexdst];

    if ((drex & 8) != ((ins->rex & REX_OC) ? 8 : 0))
	return NULL;	/* OC0 mismatch */
    ins->rex = (ins->rex & ~7) | (drex & 7);

    dst->segment = SEG_RMREG;
    dst->basereg = drex >> 4;
    return data;
}


/*
 * Process an effective address (ModRM) specification.
 */
static uint8_t *do_ea(uint8_t *data, int modrm, int asize,
		      int segsize, operand * op, insn *ins)
{
    int mod, rm, scale, index, base;
    int rex;
    uint8_t sib = 0;

    mod = (modrm >> 6) & 03;
    rm = modrm & 07;

    if (mod != 3 && rm == 4 && asize != 16)
	sib = *data++;

    if (ins->rex & REX_D) {
	data = do_drex(data, ins);
	if (!data)
	    return NULL;
    }
    rex = ins->rex;

    if (mod == 3) {             /* pure register version */
        op->basereg = rm+(rex & REX_B ? 8 : 0);
        op->segment |= SEG_RMREG;
        return data;
    }

    op->disp_size = 0;
    op->eaflags = 0;

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
                op->disp_size = 16;
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
		op->eaflags |= EAF_REL;
		op->segment |= SEG_RELATIVE;
		mod = 2;	/* fake disp32 */
	    }

	    if (asize != 64)
		op->disp_size = asize;

	    op->basereg = -1;
	    mod = 2;            /* fake disp32 */
        }

        if (rm == 4) {          /* process SIB */
            scale = (sib >> 6) & 03;
            index = (sib >> 3) & 07;
            base = sib & 07;

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

	    if (segsize != 32)
		op->disp_size = 32;
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
static int matches(const struct itemplate *t, uint8_t *data,
		   const struct prefix_info *prefix, int segsize, insn *ins)
{
    uint8_t *r = (uint8_t *)(t->code);
    uint8_t *origdata = data;
    bool a_used = false, o_used = false;
    enum prefixes drep = 0;
    uint8_t lock = prefix->lock;
    int osize = prefix->osize;
    int asize = prefix->asize;
    int i;

    for (i = 0; i < MAX_OPERANDS; i++) {
	ins->oprs[i].segment = ins->oprs[i].disp_size =
	    (segsize == 64 ? SEG_64BIT : segsize == 32 ? SEG_32BIT : 0);
    }
    ins->condition = -1;
    ins->rex = prefix->rex;

    if (t->flags & (segsize == 64 ? IF_NOLONG : IF_LONG))
        return false;

    if (prefix->rep == 0xF2)
        drep = P_REPNE;
    else if (prefix->rep == 0xF3)
        drep = P_REP;

    while (*r) {
        int c = *r++;

	/* FIX: change this into a switch */
	if (c >= 01 && c <= 03) {
            while (c--)
                if (*r++ != *data++)
                    return false;
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
                return false;
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
                return false;
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
                return false;
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
                return false;
            }
	} else if (c >= 010 && c <= 013) {
            int t = *r++, d = *data++;
            if (d < t || d > t + 7)
                return false;
            else {
                ins->oprs[c - 010].basereg = (d-t)+
		    (ins->rex & REX_B ? 8 : 0);
                ins->oprs[c - 010].segment |= SEG_RMREG;
            }
	} else if (c >= 014 && c <= 017) {
            ins->oprs[c - 014].offset = (int8_t)*data++;
            ins->oprs[c - 014].segment |= SEG_SIGNED;
        } else if (c >= 020 && c <= 023) {
            ins->oprs[c - 020].offset = *data++;
	} else if (c >= 024 && c <= 027) {
            ins->oprs[c - 024].offset = *data++;
	} else if (c >= 030 && c <= 033) {
            ins->oprs[c - 030].offset = getu16(data);
	    data += 2;
        } else if (c >= 034 && c <= 037) {
	    if (osize == 32) {
		ins->oprs[c - 034].offset = getu32(data);
		data += 4;
	    } else {
		ins->oprs[c - 034].offset = getu16(data);
		data += 2;
	    }
            if (segsize != asize)
                ins->oprs[c - 034].disp_size = asize;
        } else if (c >= 040 && c <= 043) {
            ins->oprs[c - 040].offset = getu32(data);
	    data += 4;
        } else if (c >= 044 && c <= 047) {
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
                ins->oprs[c - 044].disp_size = asize;
        } else if (c >= 050 && c <= 053) {
            ins->oprs[c - 050].offset = gets8(data++);
            ins->oprs[c - 050].segment |= SEG_RELATIVE;
        } else if (c >= 054 && c <= 057) {
	    ins->oprs[c - 054].offset = getu64(data);
	    data += 8;
	} else if (c >= 060 && c <= 063) {
            ins->oprs[c - 060].offset = gets16(data);
	    data += 2;
            ins->oprs[c - 060].segment |= SEG_RELATIVE;
            ins->oprs[c - 060].segment &= ~SEG_32BIT;
        } else if (c >= 064 && c <= 067) {
            ins->oprs[c - 064].segment |= SEG_RELATIVE;
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
                    (ins->oprs[c - 064].type & ~SIZE_MASK)
                    | ((osize == 16) ? BITS16 : BITS32);
            }
        } else if (c >= 070 && c <= 073) {
            ins->oprs[c - 070].offset = getu32(data);
	    data += 4;
            ins->oprs[c - 070].segment |= SEG_32BIT | SEG_RELATIVE;
        } else if (c >= 0100 && c < 0140) {
            int modrm = *data++;
            ins->oprs[c & 07].segment |= SEG_RMREG;
            data = do_ea(data, modrm, asize, segsize,
			 &ins->oprs[(c >> 3) & 07], ins);
	    if (!data)
		return false;
            ins->oprs[c & 07].basereg = ((modrm >> 3)&7)+
		(ins->rex & REX_R ? 8 : 0);
        } else if (c >= 0140 && c <= 0143) {
            ins->oprs[c - 0140].offset = getu16(data);
	    data += 2;
        } else if (c >= 0150 && c <= 0153) {
	    ins->oprs[c - 0150].offset = getu32(data);
	    data += 4;
	} else if (c >= 0160 && c <= 0167) {
	    ins->rex |= (c & 4) ? REX_D|REX_OC : REX_D;
	    ins->drexdst = c & 3;
        } else if (c == 0170) {
            if (*data++)
                return false;
	} else if (c == 0171) {
	    data = do_drex(data, ins);
	    if (!data)
		return false;
        } else if (c >= 0200 && c <= 0277) {
            int modrm = *data++;
            if (((modrm >> 3) & 07) != (c & 07))
                return false;   /* spare field doesn't match up */
            data = do_ea(data, modrm, asize, segsize,
                         &ins->oprs[(c >> 3) & 07], ins);
	    if (!data)
		return false;
        } else if (c == 0310) {
            if (asize != 16)
                return false;
            else
                a_used = true;
        } else if (c == 0311) {
            if (asize == 16)
                return false;
            else
                a_used = true;
        } else if (c == 0312) {
            if (asize != segsize)
                return false;
            else
                a_used = true;
	} else if (c == 0313) {
	    if (asize != 64)
		return false;
	    else
		a_used = true;
        } else if (c == 0320) {
            if (osize != 16)
                return false;
            else
                o_used = true;
        } else if (c == 0321) {
            if (osize != 32)
                return false;
            else
                o_used = true;
        } else if (c == 0322) {
            if (osize != (segsize == 16) ? 16 : 32)
                return false;
            else
                o_used = true;
        } else if (c == 0323) {
	    ins->rex |= REX_W;	/* 64-bit only instruction */
	    osize = 64;
	} else if (c == 0324) {
	    if (!(ins->rex & (REX_P|REX_W)) || osize != 64)
		return false;
	} else if (c == 0330) {
            int t = *r++, d = *data++;
            if (d < t || d > t + 15)
                return false;
            else
                ins->condition = d - t;
        } else if (c == 0331) {
            if (prefix->rep)
                return false;
	} else if (c == 0332) {
	    if (prefix->rep != 0xF2)
		return false;
        } else if (c == 0333) {
            if (prefix->rep != 0xF3)
                return false;
            drep = 0;
        } else if (c == 0334) {
	    if (lock) {
		ins->rex |= REX_R;
		lock = 0;
	    }
        } else if (c == 0335) {
            if (drep == P_REP)
                drep = P_REPE;
	} else if (c == 0364) {
	    if (prefix->osp)
		return false;
	} else if (c == 0365) {
	    if (prefix->asp)
		return false;
	} else if (c == 0366) {
	    if (!prefix->osp)
		return false;
	    o_used = true;
	} else if (c == 0367) {
	    if (!prefix->asp)
		return false;
	    o_used = true;
	}
    }

    /* REX cannot be combined with DREX */
    if ((ins->rex & REX_D) && (prefix->rex))
	return false;

    /*
     * Check for unused rep or a/o prefixes.
     */
    for (i = 0; i < t->operands; i++) {
	if (ins->oprs[i].segment != SEG_RMREG)
	    a_used = true;
    }

    if (lock) {
	if (ins->prefixes[PPS_LREP])
	    return false;
	ins->prefixes[PPS_LREP] = P_LOCK;
    }
    if (drep) {
	if (ins->prefixes[PPS_LREP])
	    return false;
        ins->prefixes[PPS_LREP] = drep;
    }
    if (!o_used && osize == ((segsize == 16) ? 32 : 16)) {
	if (ins->prefixes[PPS_OSIZE])
	    return false;
        ins->prefixes[PPS_OSIZE] = osize == 16 ? P_O16 : P_O32;
    }
    if (!a_used && asize != segsize) {
	if (ins->prefixes[PPS_ASIZE])
	    return false;
        ins->prefixes[PPS_ASIZE] = asize == 16 ? P_A16 : P_A32;
    }

    /* Fix: check for redundant REX prefixes */

    return data - origdata;
}

int32_t disasm(uint8_t *data, char *output, int outbufsize, int segsize,
            int32_t offset, int autosync, uint32_t prefer)
{
    const struct itemplate * const *p, * const *best_p;
    const struct disasm_index *ix;
    uint8_t *dp;
    int length, best_length = 0;
    char *segover;
    int i, slen, colon, n;
    uint8_t *origdata;
    int works;
    insn tmp_ins, ins;
    uint32_t goodness, best;
    int best_pref;
    struct prefix_info prefix;

    memset(&ins, 0, sizeof ins);

    /*
     * Scan for prefixes.
     */
    memset(&prefix, 0, sizeof prefix);
    prefix.asize = segsize;
    prefix.osize = (segsize == 64) ? 32 : segsize;
    segover = NULL;
    origdata = data;
    for (;;) {
        if (*data == 0xF3 || *data == 0xF2)
            prefix.rep = *data++;
        else if (*data == 0xF0)
            prefix.lock = *data++;
        else if (*data == 0x2E)
	    segover = "cs", prefix.seg = *data++;
	else if (*data == 0x36)
	    segover = "ss", prefix.seg = *data++;
	else if (*data == 0x3E)
	    segover = "ds", prefix.seg = *data++;
	else if (*data == 0x26)
	    segover = "es", prefix.seg = *data++;
	else if (*data == 0x64)
	    segover = "fs", prefix.seg = *data++;
	else if (*data == 0x65)
	    segover = "gs", prefix.seg = *data++;
	else if (*data == 0x66) {
	    prefix.osize = (segsize == 16) ? 32 : 16;
	    prefix.osp = *data++;
	} else if (*data == 0x67) {
	    prefix.asize = (segsize == 32) ? 16 : 32;
	    prefix.asp = *data++;
	} else if (segsize == 64 && (*data & 0xf0) == REX_P) {
	    prefix.rex = *data++;
	    if (prefix.rex & REX_W)
		prefix.osize = 64;
	    break;		/* REX is always the last prefix */
	} else {
            break;
	}
    }

    best = -1;			/* Worst possible */
    best_p = NULL;
    best_pref = INT_MAX;

    dp = data;
    ix = itable + *dp++;
    while (ix->n == -1) {
	ix = (const struct disasm_index *)ix->p + *dp++;
    }

    p = (const struct itemplate * const *)ix->p;
    for (n = ix->n; n; n--, p++) {
        if ((length = matches(*p, data, &prefix, segsize, &tmp_ins))) {
            works = true;
            /*
             * Final check to make sure the types of r/m match up.
	     * XXX: Need to make sure this is actually correct.
             */
            for (i = 0; i < (*p)->operands; i++) {
                if (!((*p)->opd[i] & SAME_AS) &&
		    (
			/* If it's a mem-only EA but we have a register, die. */
			((tmp_ins.oprs[i].segment & SEG_RMREG) &&
			 !(MEMORY & ~(*p)->opd[i])) ||
			/* If it's a reg-only EA but we have a memory ref, die. */
			(!(tmp_ins.oprs[i].segment & SEG_RMREG) &&
			 !(REG_EA & ~(*p)->opd[i]) &&
			 !((*p)->opd[i] & REG_SMASK)) ||
			/* Register type mismatch (eg FS vs REG_DESS): die. */
			((((*p)->opd[i] & (REGISTER | FPUREG)) ||
			  (tmp_ins.oprs[i].segment & SEG_RMREG)) &&
			 !whichreg((*p)->opd[i],
				   tmp_ins.oprs[i].basereg, tmp_ins.rex))
			)) {
                    works = false;
                    break;
                }
            }

	    /*
	     * Note: we always prefer instructions which incorporate
	     * prefixes in the instructions themselves.  This is to allow
	     * e.g. PAUSE to be preferred to REP NOP, and deal with
	     * MMX/SSE instructions where prefixes are used to select
	     * between MMX and SSE register sets or outright opcode
	     * selection.
	     */
            if (works) {
		int i, nprefix;
                goodness = ((*p)->flags & IF_PFMASK) ^ prefer;
		nprefix = 0;
		for (i = 0; i < MAXPREFIX; i++)
		    if (tmp_ins.prefixes[i])
			nprefix++;
                if (nprefix < best_pref ||
		    (nprefix == best_pref && goodness < best)) {
                    /* This is the best one found so far */
                    best = goodness;
                    best_p = p;
		    best_pref = nprefix;
                    best_length = length;
                    ins = tmp_ins;
                }
            }
        }
    }

    if (!best_p)
        return 0;               /* no instruction was matched */

    /* Pick the best match */
    p = best_p;
    length = best_length;

    slen = 0;

    /* TODO: snprintf returns the value that the string would have if
     *      the buffer were long enough, and not the actual length of
     *      the returned string, so each instance of using the return
     *      value of snprintf should actually be checked to assure that
     *      the return value is "sane."  Maybe a macro wrapper could
     *      be used for that purpose.
     */
    for (i = 0; i < MAXPREFIX; i++)
        switch (ins.prefixes[i]) {
	case P_LOCK:
	    slen += snprintf(output + slen, outbufsize - slen, "lock ");
	    break;
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
	default:
	    break;
        }

    for (i = 0; i < (int)elements(ico); i++)
        if ((*p)->opcode == ico[i]) {
            slen +=
                snprintf(output + slen, outbufsize - slen, "%s%s", icn[i],
                         whichcond(ins.condition));
            break;
        }
    if (i >= (int)elements(ico))
        slen +=
            snprintf(output + slen, outbufsize - slen, "%s",
                     insn_names[(*p)->opcode]);
    colon = false;
    length += data - origdata;  /* fix up for prefixes */
    for (i = 0; i < (*p)->operands; i++) {
	opflags_t t = (*p)->opd[i];
	const operand *o = &ins.oprs[i];
	int64_t offs;

	if (t & SAME_AS) {
	    o = &ins.oprs[t & ~SAME_AS];
	    t = (*p)->opd[t & ~SAME_AS];
	}

        output[slen++] = (colon ? ':' : i == 0 ? ' ' : ',');

	offs = o->offset;
        if (o->segment & SEG_RELATIVE) {
            offs += offset + length;
            /*
             * sort out wraparound
             */
            if (!(o->segment & (SEG_32BIT|SEG_64BIT)))
		offs &= 0xffff;
            /*
             * add sync marker, if autosync is on
             */
            if (autosync)
                add_sync(offs, 0L);
        }

        if (t & COLON)
            colon = true;
        else
            colon = false;

        if ((t & (REGISTER | FPUREG)) ||
            (o->segment & SEG_RMREG)) {
	    enum reg_enum reg;
            reg = whichreg(t, o->basereg, ins.rex);
            if (t & TO)
                slen += snprintf(output + slen, outbufsize - slen, "to ");
            slen += snprintf(output + slen, outbufsize - slen, "%s",
                             reg_names[reg - EXPR_REG_START]);
        } else if (!(UNITY & ~t)) {
            output[slen++] = '1';
        } else if (t & IMMEDIATE) {
            if (t & BITS8) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "byte ");
                if (o->segment & SEG_SIGNED) {
                    if (offs < 0) {
                        offs *= -1;
                        output[slen++] = '-';
                    } else
                        output[slen++] = '+';
                }
            } else if (t & BITS16) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "word ");
            } else if (t & BITS32) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "dword ");
            } else if (t & BITS64) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "qword ");
            } else if (t & NEAR) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "near ");
            } else if (t & SHORT) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "short ");
            }
            slen +=
                snprintf(output + slen, outbufsize - slen, "0x%"PRIx64"",
                         offs);
        } else if (!(MEM_OFFS & ~t)) {
            slen +=
                snprintf(output + slen, outbufsize - slen, "[%s%s%s0x%"PRIx64"]",
                         (segover ? segover : ""),
                         (segover ? ":" : ""),
                         (o->disp_size ==
                          32 ? "dword " : o->disp_size ==
                          16 ? "word " : ""), offs);
            segover = NULL;
        } else if (!(REGMEM & ~t)) {
            int started = false;
            if (t & BITS8)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "byte ");
            if (t & BITS16)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "word ");
            if (t & BITS32)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "dword ");
            if (t & BITS64)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "qword ");
            if (t & BITS80)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "tword ");
            if (t & FAR)
                slen += snprintf(output + slen, outbufsize - slen, "far ");
            if (t & NEAR)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "near ");
            output[slen++] = '[';
            if (o->disp_size)
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 (o->disp_size == 64 ? "qword " :
				  o->disp_size == 32 ? "dword " :
                                  o->disp_size == 16 ? "word " :
				  ""));
	    if (o->eaflags & EAF_REL)
		slen += snprintf(output + slen, outbufsize - slen, "rel ");
            if (segover) {
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s:",
                             segover);
                segover = NULL;
            }
            if (o->basereg != -1) {
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 reg_names[(o->basereg -
                                            EXPR_REG_START)]);
                started = true;
            }
            if (o->indexreg != -1) {
                if (started)
                    output[slen++] = '+';
                slen += snprintf(output + slen, outbufsize - slen, "%s",
                                 reg_names[(o->indexreg -
                                            EXPR_REG_START)]);
                if (o->scale > 1)
                    slen +=
                        snprintf(output + slen, outbufsize - slen, "*%d",
                                 o->scale);
                started = true;
            }
            if (o->segment & SEG_DISP8) {
		int minus = 0;
		int8_t offset = offs;
		if (offset < 0) {
		    minus = 1;
		    offset = -offset;
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s0x%"PRIx8"",
			     minus ? "-" : "+", offset);
            } else if (o->segment & SEG_DISP16) {
		int minus = 0;
		int16_t offset = offs;
		if (offset < 0) {
		    minus = 1;
		    offset = -offset;
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s0x%"PRIx16"",
			     minus ? "-" : started ? "+" : "", offset);
            } else if (o->segment & SEG_DISP32) {
		    char *prefix = "";
		    int32_t offset = offs;
		    if (offset < 0) {
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
