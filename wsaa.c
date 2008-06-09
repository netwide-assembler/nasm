#include "compiler.h"
#include "nasmlib.h"
#include "wsaa.h"

void saa_write8(struct SAA *s, uint8_t v)
{
    saa_wbytes(s, &v, 1);
}

#ifdef WORDS_LITTEENDIAN

void saa_write16(struct SAA *s, uint16_t v)
{
    saa_wbytes(s, &v, 2);
}

void saa_write32(struct SAA *s, uint32_t v)
{
    saa_wbytes(s, &v, 4);
}

void saa_write64(struct SAA *s, uint64_t v)
{
    saa_wbytes(s, &v, 8);
}

#else /* not WORDS_LITTLEENDIAN */

void saa_write16(struct SAA *s, uint16_t v)
{
    uint8_t b[2];

    b[0] = v;
    b[1] = v >> 8;
    saa_wbytes(s, b, 2);
}

void saa_write32(struct SAA *s, uint32_t v)
{
    uint8_t b[4];

    b[0] = v;
    b[1] = v >> 8;
    b[2] = v >> 16;
    b[3] = v >> 24;
    saa_wbytes(s, b, 4);
}

void saa_write64(struct SAA *s, uint64_t v)
{
    uint8_t b[8];

    b[0] = v;
    b[1] = v >> 8;
    b[2] = v >> 16;
    b[3] = v >> 24;
    b[4] = v >> 32;
    b[5] = v >> 40;
    b[6] = v >> 48;
    b[7] = v >> 56;
    saa_wbytes(s, b, 8);
}

#endif	/* WORDS_LITTLEENDIAN */
