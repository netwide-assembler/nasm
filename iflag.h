#ifndef NASM_IFLAG_H
#define NASM_IFLAG_H

#include <inttypes.h>

#include <string.h>

#include "compiler.h"

int ilog2_32(uint32_t v);

#include "iflaggen.h"

#define IF_GENBIT(bit)          (UINT32_C(1) << (bit))

static inline unsigned int iflag_test(iflag_t *f,unsigned int bit)
{
    unsigned int index = bit / 32;
    return f->field[index] & (UINT32_C(1) << (bit - (index * 32)));
}

static inline void iflag_set(iflag_t *f, unsigned int bit)
{
    unsigned int index = bit / 32;
    f->field[index] |= (UINT32_C(1) << (bit - (index * 32)));
}

static inline void iflag_clear(iflag_t *f, unsigned int bit)
{
    unsigned int index = bit / 32;
    f->field[index] &= ~(UINT32_C(1) << (bit - (index * 32)));
}

static inline void iflag_clear_all(iflag_t *f)
{
     memset(f, 0, sizeof(*f));
}

static inline void iflag_set_all(iflag_t *f)
{
     memset(f, 0xff, sizeof(*f));
}

static inline int iflag_cmp(iflag_t *a, iflag_t *b)
{
    unsigned int i;

    for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++) {
        if (a->field[i] < b->field[i])
            return -1;
        else if (a->field[i] > b->field[i])
            return 1;
    }

    return 0;
}

static inline int iflag_cmp_cpu(iflag_t *a, iflag_t *b)
{
    if (a->field[3] < b->field[3])
        return -1;
    else if (a->field[3] > b->field[3])
        return 1;
    return 0;
}

static inline unsigned int iflag_ffs(iflag_t *a)
{
    unsigned int i;

    for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++) {
        if (a->field[i])
            return ilog2_32(a->field[i]) + (i * 32);
    }

    return 0;
}

#define IF_GEN_HELPER(name, op)                                         \
    static inline iflag_t iflag_##name(iflag_t *a, iflag_t *b)          \
    {                                                                   \
        unsigned int i;                                                 \
        iflag_t res;                                                    \
                                                                        \
        for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++)    \
            res.field[i] = a->field[i] op b->field[i];                  \
                                                                        \
        return res;                                                     \
    }

IF_GEN_HELPER(xor, ^)


/* Use this helper to test instruction template flags */
#define itemp_has(itemp, bit)   iflag_test(&insns_flags[(itemp)->iflag_idx], bit)


/* Maximum processor level at moment */
#define IF_PLEVEL               IF_IA64
/* Some helpers which are to work with predefined masks */
#define IF_SMASK        \
    (IF_GENBIT(IF_SB)  |\
     IF_GENBIT(IF_SW)  |\
     IF_GENBIT(IF_SD)  |\
     IF_GENBIT(IF_SQ)  |\
     IF_GENBIT(IF_SO)  |\
     IF_GENBIT(IF_SY)  |\
     IF_GENBIT(IF_SZ)  |\
     IF_GENBIT(IF_SIZE))
#define IF_ARMASK       \
    (IF_GENBIT(IF_AR0) |\
     IF_GENBIT(IF_AR1) |\
     IF_GENBIT(IF_AR2) |\
     IF_GENBIT(IF_AR3) |\
     IF_GENBIT(IF_AR4))

#define __itemp_smask(idx)      (insns_flags[(idx)].field[0] & IF_SMASK)
#define __itemp_armask(idx)     (insns_flags[(idx)].field[0] & IF_ARMASK)
#define __itemp_arg(idx)        ((__itemp_armask(idx) >> IF_AR0) - 1)

#define itemp_smask(itemp)      __itemp_smask((itemp)->iflag_idx)
#define itemp_arg(itemp)        __itemp_arg((itemp)->iflag_idx)
#define itemp_armask(itemp)     __itemp_armask((itemp)->iflag_idx)

static inline int iflag_cmp_cpu_level(iflag_t *a, iflag_t *b)
{
    iflag_t v1 = *a;
    iflag_t v2 = *b;

    iflag_clear(&v1, IF_CYRIX);
    iflag_clear(&v1, IF_AMD);

    iflag_clear(&v2, IF_CYRIX);
    iflag_clear(&v2, IF_AMD);

    if (v1.field[3] < v2.field[3])
        return -1;
    else if (v1.field[3] > v2.field[3])
        return 1;

    return 0;
}

static inline iflag_t __iflag_pfmask(iflag_t *a)
{
	iflag_t r = (iflag_t) {
		.field[1] = a->field[1],
		.field[2] = a->field[2],
	};

	if (iflag_test(a, IF_CYRIX))
		iflag_set(&r, IF_CYRIX);
	if (iflag_test(a, IF_AMD))
		iflag_set(&r, IF_AMD);

	return r;
}

#define iflag_pfmask(itemp)	__iflag_pfmask(&insns_flags[(itemp)->iflag_idx])

#endif /* NASM_IFLAG_H__ */
