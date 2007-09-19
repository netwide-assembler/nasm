/* float.c     floating-point constant support for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 13/ix/96 by Simon Tatham
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "nasm.h"

#define TRUE 1
#define FALSE 0

#define MANT_WORDS  10          /* 112 bits + 48 for accuracy == 160 */
#define MANT_DIGITS 49          /* 50 digits don't fit in 160 bits */

/*
 * guaranteed top bit of from is set
 * => we only have to worry about _one_ bit shift to the left
 */

static int ieee_multiply(uint16_t *to, uint16_t *from)
{
    uint32_t temp[MANT_WORDS * 2];
    int i, j;

    for (i = 0; i < MANT_WORDS * 2; i++)
        temp[i] = 0;

    for (i = 0; i < MANT_WORDS; i++)
        for (j = 0; j < MANT_WORDS; j++) {
            uint32_t n;
            n = (uint32_t)to[i] * (uint32_t)from[j];
            temp[i + j] += n >> 16;
            temp[i + j + 1] += n & 0xFFFF;
        }

    for (i = MANT_WORDS * 2; --i;) {
        temp[i - 1] += temp[i] >> 16;
        temp[i] &= 0xFFFF;
    }
    if (temp[0] & 0x8000) {
	memcpy(to, temp, 2*MANT_WORDS);
	return 0;
    } else {
        for (i = 0; i < MANT_WORDS; i++)
            to[i] = (temp[i] << 1) + !!(temp[i + 1] & 0x8000);
        return -1;
    }
}

static int hexval(char c)
{
    if (c >= '0' && c <= '9')
	return c-'0';
    else if (c >= 'a' && c <= 'f')
	return c-'a'+10;
    else
	return c-'A'+10;
}

static void ieee_flconvert_hex(char *string, uint16_t *mant,
			       int32_t *exponent, efunc error)
{
    static const int log2tbl[16] =
	{ -1, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3 };
    uint16_t mult[MANT_WORDS+1], *mp;
    int ms;
    int32_t twopwr;
    int seendot, seendigit;
    unsigned char c;

    twopwr = 0;
    seendot = seendigit = 0;

    memset(mult, 0, sizeof mult);

    while ((c = *string++) != '\0') {
	if (c == '.') {
            if (!seendot)
                seendot = TRUE;
            else {
                error(ERR_NONFATAL,
                      "too many periods in floating-point constant");
                return;
            }
	} else if (isxdigit(c)) {
	    int v = hexval(c);

	    if (!seendigit && v) {
		int l = log2tbl[v];

		seendigit = 1;
		mp = mult;
		ms = 15-l;

		twopwr = seendot ? twopwr-4+l : l-3;
	    }

	    if (seendigit) {
		if (ms <= 0) {
		    *mp |= v >> -ms;
		    mp++;
		    if (mp > &mult[MANT_WORDS])
			mp = &mult[MANT_WORDS]; /* Guard slot */
		    ms += 16;
		}
		*mp |= v << ms;
		ms -= 4;

		if (!seendot)
		    twopwr += 4;
	    } else {
		if (seendot)
		    twopwr -= 4;
	    }
	} else if (c == 'p' || c == 'P') {
	    twopwr += atoi(string);
	    break;
	} else {
            error(ERR_NONFATAL,
                  "floating-point constant: `%c' is invalid character",
                  c);
            return;
        }
    }

    if (!seendigit) {
	memset(mant, 0, 2*MANT_WORDS); /* Zero */
	*exponent = 0;
    } else {
	memcpy(mant, mult, 2*MANT_WORDS);
	*exponent = twopwr;
    }
}

static void ieee_flconvert(char *string, uint16_t *mant,
                           int32_t *exponent, efunc error)
{
    char digits[MANT_DIGITS];
    char *p, *q, *r;
    uint16_t mult[MANT_WORDS], bit;
    uint16_t *m;
    int32_t tenpwr, twopwr;
    int extratwos, started, seendot;

    if (string[0] == '0' && (string[1] == 'x' || string[1] == 'X')) {
	ieee_flconvert_hex(string+2, mant, exponent, error);
	return;
    }

    p = digits;
    tenpwr = 0;
    started = seendot = FALSE;
    while (*string && *string != 'E' && *string != 'e') {
        if (*string == '.') {
            if (!seendot)
                seendot = TRUE;
            else {
                error(ERR_NONFATAL,
                      "too many periods in floating-point constant");
                return;
            }
        } else if (*string >= '0' && *string <= '9') {
            if (*string == '0' && !started) {
                if (seendot)
                    tenpwr--;
            } else {
                started = TRUE;
                if (p < digits + sizeof(digits))
                    *p++ = *string - '0';
                if (!seendot)
                    tenpwr++;
            }
        } else {
            error(ERR_NONFATAL,
                  "floating-point constant: `%c' is invalid character",
                  *string);
            return;
        }
        string++;
    }
    if (*string) {
        string++;               /* eat the E */
        tenpwr += atoi(string);
    }

    /*
     * At this point, the memory interval [digits,p) contains a
     * series of decimal digits zzzzzzz such that our number X
     * satisfies
     *
     * X = 0.zzzzzzz * 10^tenpwr
     */

    bit = 0x8000;
    for (m = mant; m < mant + MANT_WORDS; m++)
        *m = 0;
    m = mant;
    q = digits;
    started = FALSE;
    twopwr = 0;
    while (m < mant + MANT_WORDS) {
        uint16_t carry = 0;
        while (p > q && !p[-1])
            p--;
        if (p <= q)
            break;
        for (r = p; r-- > q;) {
            int i;

            i = 2 * *r + carry;
            if (i >= 10)
                carry = 1, i -= 10;
            else
                carry = 0;
            *r = i;
        }
        if (carry)
            *m |= bit, started = TRUE;
        if (started) {
            if (bit == 1)
                bit = 0x8000, m++;
            else
                bit >>= 1;
        } else
            twopwr--;
    }
    twopwr += tenpwr;

    /*
     * At this point the `mant' array contains the first six
     * fractional places of a base-2^16 real number, which when
     * multiplied by 2^twopwr and 5^tenpwr gives X. So now we
     * really do multiply by 5^tenpwr.
     */

    if (tenpwr < 0) {
        for (m = mult; m < mult + MANT_WORDS; m++)
            *m = 0xCCCC;
        extratwos = -2;
        tenpwr = -tenpwr;
    } else if (tenpwr > 0) {
        mult[0] = 0xA000;
        for (m = mult + 1; m < mult + MANT_WORDS; m++)
            *m = 0;
        extratwos = 3;
    } else
        extratwos = 0;
    while (tenpwr) {
        if (tenpwr & 1)
            twopwr += extratwos + ieee_multiply(mant, mult);
        extratwos = extratwos * 2 + ieee_multiply(mult, mult);
        tenpwr >>= 1;
    }

    /*
     * Conversion is done. The elements of `mant' contain the first
     * fractional places of a base-2^16 real number in [0.5,1)
     * which we can multiply by 2^twopwr to get X. Or, of course,
     * it contains zero.
     */
    *exponent = twopwr;
}

/*
 * Shift a mantissa to the right by i (i < 16) bits.
 */
static void ieee_shr(uint16_t *mant, int i)
{
    uint16_t n = 0, m;
    int j;

    for (j = 0; j < MANT_WORDS; j++) {
        m = (mant[j] << (16 - i)) & 0xFFFF;
        mant[j] = (mant[j] >> i) | n;
        n = m;
    }
}

/*
 * Round a mantissa off after i words.
 */
static int ieee_round(uint16_t *mant, int i)
{
    if (mant[i] & 0x8000) {
        do {
            ++mant[--i];
            mant[i] &= 0xFFFF;
        } while (i > 0 && !mant[i]);
        return !i && !mant[i];
    }
    return 0;
}

#define put(a,b) ( (*(a)=(b)), ((a)[1]=(b)>>8) )

/* Set a bit, using *bigendian* bit numbering (0 = MSB) */
static void set_bit(uint16_t *mant, int bit)
{
    mant[bit >> 4] |= 1 << (~bit & 15);
}

/* Produce standard IEEE formats, with implicit "1" bit; this makes
   the following assumptions:

   - the sign bit is the MSB, followed by the exponent.
   - the sign bit plus exponent fit in 16 bits.
   - the exponent bias is 2^(n-1)-1 for an n-bit exponent */

struct ieee_format {
    int words;
    int mantissa;		/* Bits in the mantissa */
    int exponent;		/* Bits in the exponent */
};

static const struct ieee_format ieee_16  = { 1,  10,  5 };
static const struct ieee_format ieee_32  = { 2,  23,  8 };
static const struct ieee_format ieee_64  = { 4,  52, 11 };
static const struct ieee_format ieee_128 = { 8, 112, 15 };

/* Produce all the standard IEEE formats: 16, 32, 64, and 128 bits */
static int to_float(char *str, int32_t sign, uint8_t *result,
		    const struct ieee_format *fmt, efunc error)
{
    uint16_t mant[MANT_WORDS], *mp;
    int32_t exponent;
    int32_t expmax = 1 << (fmt->exponent-1);
    uint16_t implicit_one = 0x8000 >> fmt->exponent;
    int i;

    sign = (sign < 0 ? 0x8000L : 0L);

    if (str[0] == '_') {
	/* NaN or Infinity */
	int32_t expmask = (1 << fmt->exponent)-1;

	memset(mant, 0, sizeof mant);
	mant[0] = expmask << (15-fmt->exponent); /* Exponent: all bits one */

	switch (str[2]) {
	case 'n':		/* __nan__ */
	case 'N':
	case 'q':		/* __qnan__ */
	case 'Q':
	    set_bit(mant, fmt->exponent+1); /* Highest bit in mantissa */
	    break;
	case 's':		/* __snan__ */
	case 'S':
	    set_bit(mant, fmt->exponent+fmt->mantissa);	/* Last bit */
	    break;
	case 'i':		/* __infinity__ */
	case 'I':
	    break;
	}
    } else {
	ieee_flconvert(str, mant, &exponent, error);
	if (mant[0] & 0x8000) {
	    /*
	     * Non-zero.
	     */
	    exponent--;
	    if (exponent >= 2-expmax && exponent <= expmax) {
		/*
		 * Normalised.
		 */
		exponent += expmax;
		ieee_shr(mant, fmt->exponent);
		ieee_round(mant, fmt->words);
		/* did we scale up by one? */
		if (mant[0] & (implicit_one << 1)) {
		    ieee_shr(mant, 1);
		    exponent++;
		}
		
		mant[0] &= (implicit_one-1);     /* remove leading one */
		mant[0] |= exponent << (15 - fmt->exponent);
	    } else if (exponent < 2-expmax &&
		       exponent >= 2-expmax-fmt->mantissa) {
		/*
		 * Denormal.
		 */
		int shift = -(exponent + expmax-2-fmt->exponent);
		int sh = shift % 16, wds = shift / 16;
		ieee_shr(mant, sh);
		if (ieee_round(mant, fmt->words - wds)
		    || (sh > 0 && (mant[0] & (0x8000 >> (sh - 1))))) {
		    ieee_shr(mant, 1);
		    if (sh == 0)
			mant[0] |= 0x8000;
		    exponent++;
		}
		
		if (wds) {
		    for (i = fmt->words-1; i >= wds; i--)
			mant[i] = mant[i-wds];
		    for (; i >= 0; i--)
			mant[i] = 0;
		}
	    } else {
		if (exponent > 0) {
		    error(ERR_NONFATAL, "overflow in floating-point constant");
		    return 0;
		} else {
		    memset(mant, 0, 2*fmt->words);
		}
	    }
	} else {
	    /* Zero */
	    memset(mant, 0, 2*fmt->words);
	}
    }

    mant[0] |= sign;

    for (mp = &mant[fmt->words], i = 0; i < fmt->words; i++) {
	uint16_t m = *--mp;
	put(result, m);
	result += 2;
    }

    return 1;                   /* success */
}

/* 80-bit format with 64-bit mantissa *including an explicit integer 1*
   and 15-bit exponent. */
static int to_ldoub(char *str, int32_t sign, uint8_t *result,
                    efunc error)
{
    uint16_t mant[MANT_WORDS];
    int32_t exponent;

    sign = (sign < 0 ? 0x8000L : 0L);

    if (str[0] == '_') {
	uint16_t is_snan = 0, is_qnan = 0x8000;
	switch (str[2]) {
	case 'n':
	case 'N':
	case 'q':
	case 'Q':
	    is_qnan = 0xc000;
	    break;
	case 's':
	case 'S':
	    is_snan = 1;
	    break;
	case 'i':
	case 'I':
	    break;
	}
	put(result + 0, is_snan);
	put(result + 2, 0);
	put(result + 4, 0);
	put(result + 6, is_qnan);
	put(result + 8, 0x7fff|sign);
	return 1;
    }

    ieee_flconvert(str, mant, &exponent, error);
    if (mant[0] & 0x8000) {
        /*
         * Non-zero.
         */
        exponent--;
        if (exponent >= -16383 && exponent <= 16384) {
            /*
             * Normalised.
             */
            exponent += 16383;
            if (ieee_round(mant, 4))    /* did we scale up by one? */
                ieee_shr(mant, 1), mant[0] |= 0x8000, exponent++;
            put(result + 0, mant[3]);
            put(result + 2, mant[2]);
            put(result + 4, mant[1]);
            put(result + 6, mant[0]);
            put(result + 8, exponent | sign);
        } else if (exponent < -16383 && exponent >= -16446) {
            /*
             * Denormal.
             */
            int shift = -(exponent + 16383);
            int sh = shift % 16, wds = shift / 16;
            ieee_shr(mant, sh);
            if (ieee_round(mant, 4 - wds)
                || (sh > 0 && (mant[0] & (0x8000 >> (sh - 1))))) {
                ieee_shr(mant, 1);
                if (sh == 0)
                    mant[0] |= 0x8000;
                exponent++;
            }
            put(result + 0, (wds <= 3 ? mant[3 - wds] : 0));
            put(result + 2, (wds <= 2 ? mant[2 - wds] : 0));
            put(result + 4, (wds <= 1 ? mant[1 - wds] : 0));
            put(result + 6, (wds == 0 ? mant[0] : 0));
            put(result + 8, sign);
        } else {
            if (exponent > 0) {
                error(ERR_NONFATAL, "overflow in floating-point constant");
                return 0;
            } else {
		goto zero;
	    }
        }
    } else {
        /*
         * Zero.
         */
    zero:
	put(result + 0, 0);
	put(result + 2, 0);
	put(result + 4, 0);
	put(result + 6, 0);
	put(result + 8, sign);
    }
    return 1;
}

int float_const(char *number, int32_t sign, uint8_t *result, int bytes,
                efunc error)
{
    switch (bytes) {
    case 2:
	return to_float(number, sign, result, &ieee_16, error);
    case 4:
        return to_float(number, sign, result, &ieee_32, error);
    case 8:
        return to_float(number, sign, result, &ieee_64, error);
    case 10:
        return to_ldoub(number, sign, result, error);
    case 16:
        return to_float(number, sign, result, &ieee_128, error);
    default:
        error(ERR_PANIC, "strange value %d passed to float_const", bytes);
        return 0;
    }
}
