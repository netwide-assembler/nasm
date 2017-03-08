#ifndef NASM_IFLAG_H
#define NASM_IFLAG_H

#include <string.h>

#include "compiler.h"

int ilog2_32(uint32_t v);

#include "iflaggen.h"

#define IF_GENBIT(bit)          (UINT32_C(1) << (bit))

static inline unsigned int iflag_test(const iflag_t *f, unsigned int bit)
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

static inline int iflag_cmp(const iflag_t *a, const iflag_t *b)
{
    int i;

    for (i = sizeof(a->field) / sizeof(a->field[0]) - 1; i >= 0; i--) {
        if (a->field[i] == b->field[i])
            continue;

        return (a->field[i] > b->field[i]) ? 1 : -1;
    }

    return 0;
}

static inline int iflag_cmp_cpu(const iflag_t *a, const iflag_t *b)
{
    if (a->field[3] < b->field[3])
        return -1;
    else if (a->field[3] > b->field[3])
        return 1;
    return 0;
}

static inline unsigned int iflag_ffs(const iflag_t *a)
{
    unsigned int i;

    for (i = 0; i < sizeof(a->field) / sizeof(a->field[0]); i++) {
        if (a->field[i])
            return ilog2_32(a->field[i]) + (i * 32);
    }

    return 0;
}

#define IF_GEN_HELPER(name, op)                                         \
    static inline iflag_t iflag_##name(const iflag_t *a, const iflag_t *b) \
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

#define _itemp_smask(idx)      (insns_flags[(idx)].field[0] & IF_SMASK)
#define _itemp_armask(idx)     (insns_flags[(idx)].field[0] & IF_ARMASK)
#define _itemp_arg(idx)        ((_itemp_armask(idx) >> IF_AR0) - 1)

#define itemp_smask(itemp)      _itemp_smask((itemp)->iflag_idx)
#define itemp_arg(itemp)        _itemp_arg((itemp)->iflag_idx)
#define itemp_armask(itemp)     _itemp_armask((itemp)->iflag_idx)

static inline int iflag_cmp_cpu_level(const iflag_t *a, const iflag_t *b)
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

static inline iflag_t _iflag_pfmask(const iflag_t *a)
{
    iflag_t r;

    iflag_clear_all(&r);

    if (iflag_test(a, IF_CYRIX))
        iflag_set(&r, IF_CYRIX);
    if (iflag_test(a, IF_AMD))
        iflag_set(&r, IF_AMD);

    return r;
}

#define iflag_pfmask(itemp)     _iflag_pfmask(&insns_flags[(itemp)->iflag_idx])

#endif /* NASM_IFLAG_H */
