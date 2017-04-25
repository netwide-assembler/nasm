/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2017 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

/*
 * bytesex.h - byte order helper functions
 *
 * In this function, be careful about getting X86_MEMORY versus
 * LITTLE_ENDIAN correct: X86_MEMORY also means we are allowed to
 * do unaligned memory references, and is probabilistic.
 */

#ifndef NASM_BYTEORD_H
#define NASM_BYTEORD_H

#include "compiler.h"

/*
 * Some handy macros that will probably be of use in more than one
 * output format: convert integers into little-endian byte packed
 * format in memory.
 */

#if X86_MEMORY

#define WRITECHAR(p,v)                          \
    do {                                        \
        *(uint8_t *)(p) = (v);                  \
        (p) += 1;                               \
    } while (0)

#define WRITESHORT(p,v)                         \
    do {                                        \
        *(uint16_t *)(p) = (v);                 \
        (p) += 2;                               \
    } while (0)

#define WRITELONG(p,v)                          \
    do {                                        \
        *(uint32_t *)(p) = (v);                 \
        (p) += 4;                               \
    } while (0)

#define WRITEDLONG(p,v)                         \
    do {                                        \
        *(uint64_t *)(p) = (v);                 \
        (p) += 8;                               \
    } while (0)

#define WRITEADDR(p,v,s)                        \
    do {                                        \
        uint64_t _wa_v = (v);                   \
        memcpy((p), &_wa_v, (s));               \
        (p) += (s);                             \
    } while (0)

#else /* !X86_MEMORY */

#define WRITECHAR(p,v)                          \
    do {                                        \
        uint8_t *_wc_p = (uint8_t *)(p);        \
        uint8_t _wc_v = (v);                    \
        _wc_p[0] = _wc_v;                       \
        (p) = (void *)(_wc_p + 1);              \
    } while (0)

#define WRITESHORT(p,v)                         \
    do {                                        \
        uint8_t *_ws_p = (uint8_t *)(p);        \
        uint16_t _ws_v = (v);                   \
        _ws_p[0] = _ws_v;                       \
        _ws_p[1] = _ws_v >> 8;                  \
        (p) = (void *)(_ws_p + 2);              \
    } while (0)

#define WRITELONG(p,v)                          \
    do {                                        \
        uint8_t *_wl_p = (uint8_t *)(p);        \
        uint32_t _wl_v = (v);                   \
        _wl_p[0] = _wl_v;                       \
        _wl_p[1] = _wl_v >> 8;                  \
        _wl_p[2] = _wl_v >> 16;                 \
        _wl_p[3] = _wl_v >> 24;                 \
        (p) = (void *)(_wl_p + 4);              \
    } while (0)

#define WRITEDLONG(p,v)                         \
    do {                                        \
        uint8_t *_wq_p = (uint8_t *)(p);        \
        uint64_t _wq_v = (v);                   \
        _wq_p[0] = _wq_v;                       \
        _wq_p[1] = _wq_v >> 8;                  \
        _wq_p[2] = _wq_v >> 16;                 \
        _wq_p[3] = _wq_v >> 24;                 \
        _wq_p[4] = _wq_v >> 32;                 \
        _wq_p[5] = _wq_v >> 40;                 \
        _wq_p[6] = _wq_v >> 48;                 \
        _wq_p[7] = _wq_v >> 56;                 \
        (p) = (void *)(_wq_p + 8);              \
    } while (0)

#define WRITEADDR(p,v,s)                        \
    do {                                        \
        int _wa_s = (s);                        \
        uint64_t _wa_v = (v);                   \
        while (_wa_s--) {                       \
            WRITECHAR(p,_wa_v);                 \
            _wa_v >>= 8;                        \
        }                                       \
    } while(0)

#endif


/*
 * Endian control functions which work on a single integer
 */
#ifdef WORDS_LITTLEENDIAN

#ifndef HAVE_CPU_TO_LE16
static inline uint16_t cpu_to_le16(uint16_t v) { return v; }
#endif
#ifndef HAVE_CPU_TO_LE32
static inline uint32_t cpu_to_le32(uint32_t v) { return v; }
#endif
#ifndef HAVE_CPU_TO_LE64
static inline uint64_t cpu_to_le64(uint64_t v) { return v; }
#endif

#elif defined(WORDS_BIGENDIAN)

#ifndef HAVE_CPU_TO_LE16
static inline uint16_t cpu_to_le16(uint16_t v)
{
# ifdef HAVE___CPU_TO_LE16
    return __cpu_to_le16(v);
# elif defined(HAVE_HTOLE16)
    return htole16(v);
# elif defined(HAVE___BSWAP_16)
    return __bswap_16(v);
# elif defined(HAVE___BUILTIN_BSWAP16)
    return __builtin_bswap16(v);
# elif defined(HAVE__BYTESWAP_USHORT) && (USHRT_MAX == 0xffffU)
    return _byteswap_ushort(v);
# else
    return (v << 8) | (v >> 8);
# endif
}
#endif

#ifndef HAVE_CPU_TO_LE32
static inline uint32_t cpu_to_le32(uint32_t v)
{
# ifdef HAVE___CPU_TO_LE32
    return __cpu_to_le32(v);
# elif defined(HAVE_HTOLE32)
    return htole32(v);
# elif defined(HAVE___BSWAP_32)
    return __bswap_32(v);
# elif defined(HAVE___BUILTIN_BSWAP32)
    return __builtin_bswap32(v);
# elif defined(HAVE__BYTESWAP_ULONG) && (ULONG_MAX == 0xffffffffUL)
    return _byteswap_ulong(v);
# else
    v = ((v << 8) & 0xff00ff00 ) |
        ((v >> 8) & 0x00ff00ff);
    return (v << 16) | (v >> 16);
# endif
}
#endif

#ifndef HAVE_CPU_TO_LE64
static inline uint64_t cpu_to_le64(uint64_t v)
{
# ifdef HAVE___CPU_TO_LE64
    return __cpu_to_le64(v);
# elif defined(HAVE_HTOLE64)
    return htole64(v);
# elif defined(HAVE___BSWAP_64)
    return __bswap_64(v);
# elif defined(HAVE___BUILTIN_BSWAP64)
    return __builtin_bswap64(v);
# elif defined(HAVE__BYTESWAP_UINT64)
    return _byteswap_uint64(v);
# else
    v = ((v << 8) & 0xff00ff00ff00ff00ull) |
        ((v >> 8) & 0x00ff00ff00ff00ffull);
    v = ((v << 16) & 0xffff0000ffff0000ull) |
        ((v >> 16) & 0x0000ffff0000ffffull);
    return (v << 32) | (v >> 32);
# endif
}
#endif

#else /* not WORDS_LITTLEENDIAN or WORDS_BIGENDIAN */

static inline uint16_t cpu_to_le16(uint16_t v)
{
    union u16 {
        uint16_t v;
        uint8_t c[2];
    } x;
    uint8_t *cp = &x.c;

    WRITESHORT(cp, v);
    return x.v;
}

static inline uint32_t cpu_to_le32(uint32_t v)
{
    union u32 {
        uint32_t v;
        uint8_t c[4];
    } x;
    uint8_t *cp = &x.c;

    WRITELONG(cp, v);
    return x.v;
}

static inline uint64_t cpu_to_le64(uint64_t v)
{
    union u64 {
        uint64_t v;
        uint8_t c[8];
    } x;
    uint8_t *cp = &x.c;

    WRITEDLONG(cp, v);
    return x.v;
}

#endif

#endif /* NASM_BYTESEX_H */
