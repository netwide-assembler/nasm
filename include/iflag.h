#ifndef NASM_IFLAG_H
#define NASM_IFLAG_H

#include "compiler.h"
#include "ilog2.h"

#include "iflaggen.h"
#include "featureinfo.h"

#define IF_GENBIT(bit)          (UINT32_C(1) << ((bit) & 31))

static inline int ifcomp(uint32_t a, uint32_t b)
{
    return (a > b) - (a < b);
}

static inline bool iflag_test(const iflag_t *f, unsigned int bit)
{
    return !!(f->field[bit >> 5] & IF_GENBIT(bit));
}

static inline void iflag_set(iflag_t *f, unsigned int bit)
{
    f->field[bit >> 5] |= IF_GENBIT(bit);
}

static inline void iflag_clear(iflag_t *f, unsigned int bit)
{
    f->field[bit >> 5] &= ~IF_GENBIT(bit);
}

static inline void iflag_clear_all(iflag_t *f)
{
     memset(f, 0, sizeof(*f));
}

static inline void iflag_set_all(iflag_t *f)
{
     memset(f, ~0, sizeof(*f));
}

static inline bool iflag_bits_ok(const iflag_t *f, int bits)
{
    switch (bits) {
    case 16:
        return true;
    case 32:
        return iflag_test(f, IF_386);
    case 64:
        return iflag_test(f, IF_X86_64);
    default:
        return false;
    }
}

static inline bool iflag_features_ok(const iflag_t *have, const iflag_t *need)
{
    uint32_t bad = 0;
    size_t i;

    for (i = IF_FEATURE_FIELD; i < IF_FEATURE_FIELD+IF_FEATURE_NFIELDS; i++)
        bad |= need->field[i] & ~have->field[i];

    return !bad;
}

#define iflag_for_each_field(v) for ((v) = 0; (v) < IF_FIELD_COUNT; (v)++)

static inline int iflag_cmp(const iflag_t *a, const iflag_t *b)
{
    int i;

    /* This is intentionally a reverse loop! */
    for (i = IF_FIELD_COUNT-1; i >= 0; i--) {
        if (a->field[i] == b->field[i])
            continue;

        return ifcomp(a->field[i], b->field[i]);
    }

    return 0;
}

#define IF_GEN_HELPER(name, op)                                         \
    static inline iflag_t iflag_##name(const iflag_t *a, const iflag_t *b) \
    {                                                                   \
        unsigned int i;                                                 \
        iflag_t res;                                                    \
                                                                        \
        iflag_for_each_field(i)                                         \
            res.field[i] = a->field[i] op b->field[i];                  \
                                                                        \
        return res;                                                     \
    }

IF_GEN_HELPER(xor, ^)

/* Some helpers which are to work with predefined masks */
/* TSMASK = "True size" mask */
#define IF_TSMASK       (IFM_SB|IFM_SW|IFM_SD|IFM_SQ|IFM_ST|IFM_SO|\
                         IFM_SY|IFM_SZ)
#define IF_SMASK	(IF_TSMASK|IFM_NWSIZE|IFM_OSIZE|IFM_ASIZE|\
                         IFM_ANYSIZE|IFM_SX)
#define IF_ARMASK       (IFM_AR0|IFM_AR1|IFM_AR2|IFM_AR3|IFM_AR4)
#define IF_SMMASK       (IFM_SM0|IFM_SM1|IFM_SM2|IFM_SM3|IFM_SM4)

#define _itemp_smask(idx)      (insns_flags[(idx)].field[0] & IF_SMASK)
#define _itemp_armask(idx)     (insns_flags[(idx)].field[0] & IF_ARMASK)
#define _itemp_smmask(idx)     (insns_flags[(idx)].field[0] & IF_SMMASK)
#define _itemp_arx(idx)        (_itemp_armask(idx) >> IF_AR0)
#define _itemp_smx(idx)        (_itemp_smmask(idx) >> IF_SM0)

#define itemp_smask(itemp)      _itemp_smask((itemp)->iflag_idx)
#define itemp_armask(itemp)     _itemp_armask((itemp)->iflag_idx)
#define itemp_smmask(itemp)     _itemp_smmask((itemp)->iflag_idx)
#define itemp_arx(itemp)        _itemp_arx((itemp)->iflag_idx)
#define itemp_smx(itemp)        _itemp_smx((itemp)->iflag_idx)

static inline void iflag_set_features(iflag_t *a, const uint32_t *features)
{
    uint32_t *p = &a->field[IF_FEATURE_FIELD];

    memcpy(p, features, IF_FEATURE_NFIELDS * sizeof(uint32_t));
}

static inline void iflag_clear_features(iflag_t *a)
{
    uint32_t *p = &a->field[IF_FEATURE_FIELD];

    memset(p, 0, IF_FEATURE_NFIELDS * sizeof(uint32_t));
}

static inline bool iflag_test_feature(const iflag_t *a, unsigned int feature)
{
    return iflag_test(a, feature + IF_FEATURE_FIRST);
}

/*
 * When ADDING a feature, enable all features that depend on it as
 * well, for user sanity.  When REMOVING a feature, delete only that
 * feature bit; the instruction feature masks take care of
 * dependencies (e.g. AVX512F depends on AVX512, so if the AVX512 bit
 * is off, an AVX512F instruction will not match even if the AVX512F
 * bit is still set.)
 */
static inline void iflag_add_feature(iflag_t *a, unsigned int feature)
{
    unsigned int i;
    const uint32_t *p = cpu_feature_info[feature - IF_FEATURE_FIRST].deps;
    uint32_t *q = &a->field[IF_FEATURE_FIELD];

    for (i = 0; i < IF_FEATURE_NFIELDS; i++)
        *q++ |= *p++;
}

static inline void iflag_del_feature(iflag_t *a, unsigned int feature)
{
    iflag_clear(a, feature + IF_FEATURE_FIRST);
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
