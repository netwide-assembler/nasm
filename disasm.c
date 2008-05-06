/* disasm.c   where all the _work_ gets done in the Netwide Disassembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the license given in the file "LICENSE"
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
    uint8_t vex[3];		/* VEX prefix present */
    uint8_t vex_m;		/* VEX.M field */
    uint8_t vex_v;
    uint8_t vex_lp;		/* VEX.LP fields */
    uint32_t rex;		/* REX prefix present */
};

#define getu8(x) (*(uint8_t *)(x))
#if X86_MEMORY
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
    if (!(YMMREG & ~regflags))
        return rd_ymmreg[regval];

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
		op->indexreg = rd_reg32[index | ((rex & REX_X) ? 8 : 0)];

	    if (base == 5 && mod == 0) {
		op->basereg = -1;
		mod = 2;	/* Fake disp32 */
	    } else if (a64)
		op->basereg = rd_reg64[base | ((rex & REX_B) ? 8 : 0)];
	    else
		op->basereg = rd_reg32[base | ((rex & REX_B) ? 8 : 0)];

	    if (segsize == 16)
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
            op->offset = gets32(data);
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
#define case4(x) case (x): case (x)+1: case (x)+2: case (x)+3

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
    int i, c;
    struct operand *opx;
    int s_field_for = -1;	/* No 144/154 series code encountered */

    for (i = 0; i < MAX_OPERANDS; i++) {
	ins->oprs[i].segment = ins->oprs[i].disp_size =
	    (segsize == 64 ? SEG_64BIT : segsize == 32 ? SEG_32BIT : 0);
    }
    ins->condition = -1;
    ins->rex = prefix->rex;
    memset(ins->prefixes, 0, sizeof ins->prefixes);

    if (t->flags & (segsize == 64 ? IF_NOLONG : IF_LONG))
        return false;

    if (prefix->rep == 0xF2)
        drep = P_REPNE;
    else if (prefix->rep == 0xF3)
        drep = P_REP;

    while ((c = *r++) != 0) {
	opx = &ins->oprs[c & 3];

	switch (c) {
	case 01:
	case 02:
	case 03:
            while (c--)
                if (*r++ != *data++)
                    return false;
	    break;

	case 04:
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
	    break;

	case 05:
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
	    break;

	case 06:
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
	    break;

	case 07:
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
	    break;

	case4(010):
	{
            int t = *r++, d = *data++;
            if (d < t || d > t + 7)
                return false;
            else {
                opx->basereg = (d-t)+
		    (ins->rex & REX_B ? 8 : 0);
                opx->segment |= SEG_RMREG;
            }
	    break;
	}

	case4(014):
            opx->offset = (int8_t)*data++;
            opx->segment |= SEG_SIGNED;
	    break;

	case4(020):
            opx->offset = *data++;
	    break;

	case4(024):
            opx->offset = *data++;
	    break;

	case4(030):
            opx->offset = getu16(data);
	    data += 2;
	    break;

	case4(034):
	    if (osize == 32) {
		opx->offset = getu32(data);
		data += 4;
	    } else {
		opx->offset = getu16(data);
		data += 2;
	    }
            if (segsize != asize)
                opx->disp_size = asize;
	    break;

	case4(040):
            opx->offset = getu32(data);
	    data += 4;
	    break;

	case4(044):
	    switch (asize) {
	    case 16:
		opx->offset = getu16(data);
		data += 2;
		if (segsize != 16)
		    opx->disp_size = 16;
		break;
	    case 32:
		opx->offset = getu32(data);
		data += 4;
		if (segsize == 16)
		    opx->disp_size = 32;
		break;
	    case 64:
		opx->offset = getu64(data);
		opx->disp_size = 64;
		data += 8;
		break;
	    }
	    break;

	case4(050):
            opx->offset = gets8(data++);
            opx->segment |= SEG_RELATIVE;
	    break;

	case4(054):
	    opx->offset = getu64(data);
	    data += 8;
	    break;

	case4(060):
            opx->offset = gets16(data);
	    data += 2;
            opx->segment |= SEG_RELATIVE;
            opx->segment &= ~SEG_32BIT;
	    break;

	case4(064):
            opx->segment |= SEG_RELATIVE;
	    if (osize == 16) {
		opx->offset = gets16(data);
		data += 2;
                opx->segment &= ~(SEG_32BIT|SEG_64BIT);
	    } else if (osize == 32) {
		opx->offset = gets32(data);
		data += 4;
                opx->segment &= ~SEG_64BIT;
                opx->segment |= SEG_32BIT;
	    }
            if (segsize != osize) {
                opx->type =
                    (opx->type & ~SIZE_MASK)
                    | ((osize == 16) ? BITS16 : BITS32);
            }
	    break;

	case4(070):
            opx->offset = gets32(data);
	    data += 4;
            opx->segment |= SEG_32BIT | SEG_RELATIVE;
	    break;

	case4(0100):
	case4(0110):
	case4(0120):
	case4(0130):
	{
	    int modrm = *data++;
            opx->segment |= SEG_RMREG;
            data = do_ea(data, modrm, asize, segsize,
			 &ins->oprs[(c >> 3) & 3], ins);
	    if (!data)
		return false;
            opx->basereg = ((modrm >> 3)&7)+
		(ins->rex & REX_R ? 8 : 0);
	    break;
	}

	case4(0140):
	    if (s_field_for == (c & 3)) {
		opx->offset = gets8(data);
		data++;
	    } else {
		opx->offset = getu16(data);
		data += 2;
	    }
	    break;

	case4(0144):
	case4(0154):
	    s_field_for = (*data & 0x02) ? c & 3 : -1;
	    if ((*data++ & ~0x02) != *r++)
		return false;
	    break;

	case4(0150):
	    if (s_field_for == (c & 3)) {
		opx->offset = gets8(data);
		data++;
	    } else {
		opx->offset = getu32(data);
		data += 4;
	    }
	    break;

	case4(0160):
	    ins->rex |= REX_D;
	    ins->drexdst = c & 3;
	    break;

	case4(0164):
	    ins->rex |= REX_D|REX_OC;
	    ins->drexdst = c & 3;
	    break;

	case 0170:
            if (*data++)
                return false;
	    break;

	case 0171:
	    data = do_drex(data, ins);
	    if (!data)
		return false;
	    break;

	case 0172:
	{
	    uint8_t ximm = *data++;
	    c = *r++;
	    ins->oprs[c >> 3].basereg = ximm >> 4;
	    ins->oprs[c >> 3].segment |= SEG_RMREG;
	    ins->oprs[c & 7].offset = ximm & 15;
	}
	break;

	case4(0200):
	case4(0204):
	case4(0210):
	case4(0214):
	case4(0220):
	case4(0224):
	case4(0230):
	case4(0234):
	{
            int modrm = *data++;
            if (((modrm >> 3) & 07) != (c & 07))
                return false;   /* spare field doesn't match up */
            data = do_ea(data, modrm, asize, segsize,
                         &ins->oprs[(c >> 3) & 07], ins);
	    if (!data)
		return false;
	    break;
	}

	case4(0260):
	{
	    int vexm   = *r++;
	    int vexwlp = *r++;
	    ins->rex |= REX_V;
	    if ((prefix->rex & (REX_V|REX_D|REX_P)) != REX_V)
		return false;

	    if ((vexm & 0x1f) != prefix->vex_m)
		return false;

	    switch (vexwlp & 030) {
	    case 000:
		if (prefix->rex & REX_W)
		    return false;
		break;
	    case 010:
		if (!(prefix->rex & REX_W))
		    return false;
		break;
	    default:
		break;		/* XXX: Need to do anything special here? */
	    }

	    if ((vexwlp & 007) != prefix->vex_lp)
		return false;

	    opx->segment |= SEG_RMREG;
	    opx->basereg = prefix->vex_v;
	    break;
	}

	case 0270:
	{
	    int vexm   = *r++;
	    int vexwlp = *r++;
	    ins->rex |= REX_V;
	    if ((prefix->rex & (REX_V|REX_D|REX_P)) != REX_V)
		return false;

	    if ((vexm & 0x1f) != prefix->vex_m)
		return false;

	    switch (vexwlp & 030) {
	    case 000:
		if (ins->rex & REX_W)
		    return false;
		break;
	    case 010:
		if (!(ins->rex & REX_W))
		    return false;
		break;
	    default:
		break;		/* Need to do anything special here? */
	    }

	    if ((vexwlp & 007) != prefix->vex_lp)
		return false;

	    if (prefix->vex_v != 0)
		return false;

	    break;
	}

	case 0310:
            if (asize != 16)
                return false;
            else
                a_used = true;
	    break;

	case 0311:
            if (asize == 16)
                return false;
            else
                a_used = true;
	    break;

	case 0312:
            if (asize != segsize)
                return false;
            else
                a_used = true;
	    break;

	case 0313:
	    if (asize != 64)
		return false;
	    else
		a_used = true;
	    break;

	case 0314:
	    if (prefix->rex & REX_B)
		return false;
	    break;

	case 0315:
	    if (prefix->rex & REX_X)
		return false;
	    break;

	case 0316:
	    if (prefix->rex & REX_R)
		return false;
	    break;

	case 0317:
	    if (prefix->rex & REX_W)
		return false;
	    break;

	case 0320:
            if (osize != 16)
                return false;
            else
                o_used = true;
	    break;

	case 0321:
            if (osize != 32)
                return false;
            else
                o_used = true;
	    break;

	case 0322:
            if (osize != (segsize == 16) ? 16 : 32)
                return false;
            else
                o_used = true;
	    break;

	case 0323:
	    ins->rex |= REX_W;	/* 64-bit only instruction */
	    osize = 64;
	    o_used = true;
	    break;

	case 0324:
	    if (!(ins->rex & (REX_P|REX_W)) || osize != 64)
		return false;
	    o_used = true;
	    break;

	case 0330:
	{
            int t = *r++, d = *data++;
            if (d < t || d > t + 15)
                return false;
            else
                ins->condition = d - t;
	    break;
	}

	case 0331:
            if (prefix->rep)
                return false;
	    break;

	case 0332:
	    if (prefix->rep != 0xF2)
		return false;
	    drep = 0;
	    break;

	case 0333:
            if (prefix->rep != 0xF3)
                return false;
            drep = 0;
	    break;

	case 0334:
	    if (lock) {
		ins->rex |= REX_R;
		lock = 0;
	    }
	    break;

	case 0335:
            if (drep == P_REP)
                drep = P_REPE;
	    break;

	case 0340:
	    return false;

	case 0364:
	    if (prefix->osp)
		return false;
	    break;

	case 0365:
	    if (prefix->asp)
		return false;
	    break;

	case 0366:
	    if (!prefix->osp)
		return false;
	    o_used = true;
	    break;

	case 0367:
	    if (!prefix->asp)
		return false;
	    a_used = true;
	    break;

	default:
	    return false;	/* Unknown code */
	}
    }

    /* REX cannot be combined with DREX or VEX */
    if ((ins->rex & (REX_D|REX_V)) && (prefix->rex & REX_P))
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
    if (!o_used) {
	if (osize != ((segsize == 16) ? 16 : 32)) {
	    enum prefixes pfx = 0;

	    switch (osize) {
	    case 16:
		pfx = P_O16;
		break;
	    case 32:
		pfx = P_O32;
		break;
	    case 64:
		pfx = P_O64;
		break;
	    }

	    if (ins->prefixes[PPS_OSIZE])
		return false;
	    ins->prefixes[PPS_OSIZE] = pfx;
	}
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
    bool end_prefix;

    memset(&ins, 0, sizeof ins);

    /*
     * Scan for prefixes.
     */
    memset(&prefix, 0, sizeof prefix);
    prefix.asize = segsize;
    prefix.osize = (segsize == 64) ? 32 : segsize;
    segover = NULL;
    origdata = data;

    end_prefix = false;
    while (!end_prefix) {
	switch (*data) {
	case 0xF2:
	case 0xF3:
            prefix.rep = *data++;
	    break;
	case 0xF0:
            prefix.lock = *data++;
	    break;
	case 0x2E:
	    segover = "cs", prefix.seg = *data++;
	    break;
	case 0x36:
	    segover = "ss", prefix.seg = *data++;
	    break;
	case 0x3E:
	    segover = "ds", prefix.seg = *data++;
	    break;
	case 0x26:
	    segover = "es", prefix.seg = *data++;
	    break;
	case 0x64:
	    segover = "fs", prefix.seg = *data++;
	    break;
	case 0x65:
	    segover = "gs", prefix.seg = *data++;
	    break;
	case 0x66:
	    prefix.osize = (segsize == 16) ? 32 : 16;
	    prefix.osp = *data++;
	    break;
	case 0x67:
	    prefix.asize = (segsize == 32) ? 16 : 32;
	    prefix.asp = *data++;
	    break;
	case 0xC4:
	case 0xC5:
	    if (segsize == 64 || (data[1] & 0xc0) == 0xc0) {
		prefix.vex[0] = *data++;
		prefix.vex[1] = *data++;
		if (prefix.vex[0] == 0xc4)
		    prefix.vex[2] = *data++;
	    }
	    prefix.rex = REX_V;
	    if (prefix.vex[0] == 0xc4) {
		prefix.rex |= (~prefix.vex[1] >> 5) & 7; /* REX_RXB */
		prefix.rex |= (prefix.vex[2] >> (7-3)) & REX_W;
		prefix.vex_m = prefix.vex[1] & 0x1f;
		prefix.vex_v = (~prefix.vex[2] >> 3) & 15;
		prefix.vex_lp = prefix.vex[2] & 7;
	    } else {
		prefix.rex |= (~prefix.vex[1] >> (7-2)) & REX_R;
		prefix.vex_m = 1;
		prefix.vex_v = (~prefix.vex[1] >> 3) & 15;
		prefix.vex_lp = prefix.vex[1] & 7;
	    }
	    end_prefix = true;
	    break;
	case REX_P + 0x0:
	case REX_P + 0x1:
	case REX_P + 0x2:
	case REX_P + 0x3:
	case REX_P + 0x4:
	case REX_P + 0x5:
	case REX_P + 0x6:
	case REX_P + 0x7:
	case REX_P + 0x8:
	case REX_P + 0x9:
	case REX_P + 0xA:
	case REX_P + 0xB:
	case REX_P + 0xC:
	case REX_P + 0xD:
	case REX_P + 0xE:
	case REX_P + 0xF:
	    if (segsize == 64) {
		prefix.rex = *data++;
		if (prefix.rex & REX_W)
		    prefix.osize = 64;
	    }
	    end_prefix = true;
	    break;
	default:
	    end_prefix = true;
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
			/* If it's a mem-only EA but we have a
			   register, die. */
			((tmp_ins.oprs[i].segment & SEG_RMREG) &&
			 !(MEMORY & ~(*p)->opd[i])) ||
			/* If it's a reg-only EA but we have a memory
			   ref, die. */
			(!(tmp_ins.oprs[i].segment & SEG_RMREG) &&
			 !(REG_EA & ~(*p)->opd[i]) &&
			 !((*p)->opd[i] & REG_SMASK)) ||
			/* Register type mismatch (eg FS vs REG_DESS):
			   die. */
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
        case P_A64:
            slen += snprintf(output + slen, outbufsize - slen, "a64 ");
            break;
        case P_O16:
            slen += snprintf(output + slen, outbufsize - slen, "o16 ");
            break;
        case P_O32:
            slen += snprintf(output + slen, outbufsize - slen, "o32 ");
            break;
        case P_O64:
            slen += snprintf(output + slen, outbufsize - slen, "o64 ");
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
	    else if (segsize != 64)
		offs &= 0xffffffff;

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
                snprintf(output + slen, outbufsize - slen,
			 "[%s%s%s0x%"PRIx64"]",
                         (segover ? segover : ""),
                         (segover ? ":" : ""),
			 (o->disp_size == 64 ? "qword " :
			  o->disp_size == 32 ? "dword " :
			  o->disp_size == 16 ? "word " : ""), offs);
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
            if (t & BITS128)
                slen +=
                    snprintf(output + slen, outbufsize - slen, "oword ");
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
		const char *prefix;
		uint8_t offset = offs;
		if ((int8_t)offset < 0) {
		    prefix = "-";
		    offset = -offset;
		} else {
		    prefix = "+";
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen, "%s0x%"PRIx8"",
			     prefix, offset);
            } else if (o->segment & SEG_DISP16) {
		const char *prefix;
		uint16_t offset = offs;
		if ((int16_t)offset < 0 && started) {
		    offset = -offset;
		    prefix = "-";
		} else {
		    prefix = started ? "+" : "";
		}
                slen +=
                    snprintf(output + slen, outbufsize - slen,
			     "%s0x%"PRIx16"", prefix, offset);
            } else if (o->segment & SEG_DISP32) {
		if (prefix.asize == 64) {
		    const char *prefix;
		    uint64_t offset = (int64_t)(int32_t)offs;
		    if ((int32_t)offs < 0 && started) {
			offset = -offset;
			prefix = "-";
		    } else {
			prefix = started ? "+" : "";
		    }
		    slen +=
			snprintf(output + slen, outbufsize - slen,
				 "%s0x%"PRIx64"", prefix, offset);
		} else {
		    const char *prefix;
		    uint32_t offset = offs;
		    if ((int32_t) offset < 0 && started) {
			offset = -offset;
			prefix = "-";
		    } else {
			prefix = started ? "+" : "";
		    }
		    slen +=
			snprintf(output + slen, outbufsize - slen,
				 "%s0x%"PRIx32"", prefix, offset);
		}
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
