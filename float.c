/* float.c     floating-point constant support for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 13/ix/96 by Simon Tatham
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nasm.h"

#define TRUE 1
#define FALSE 0

#define MANT_WORDS 6		       /* 64 bits + 32 for accuracy == 96 */
#define MANT_DIGITS 28		       /* 29 digits don't fit in 96 bits */

/*
 * guaranteed top bit of from is set
 * => we only have to worry about _one_ bit shift to the left
 */

static int multiply(unsigned short *to, unsigned short *from) 
{
    unsigned long temp[MANT_WORDS*2];
    int           i, j;

    for (i=0; i<MANT_WORDS*2; i++)
	temp[i] = 0;

    for (i=0; i<MANT_WORDS; i++)
	for (j=0; j<MANT_WORDS; j++) {
	    unsigned long n;
	    n = (unsigned long)to[i] * (unsigned long)from[j];
	    temp[i+j] += n >> 16;
	    temp[i+j+1] += n & 0xFFFF;
	}

    for (i=MANT_WORDS*2; --i ;) {
	temp[i-1] += temp[i] >> 16;
	temp[i] &= 0xFFFF;
    }
    if (temp[0] & 0x8000) {
	for (i=0; i<MANT_WORDS; i++)
	    to[i] = temp[i] & 0xFFFF;
	return 0;
    } else {
	for (i=0; i<MANT_WORDS; i++)
	    to[i] = (temp[i] << 1) + !!(temp[i+1] & 0x8000);
	return -1;
    }
}

static void flconvert(char *string, unsigned short *mant, long *exponent,
		      efunc error) 
{
    char           digits[MANT_DIGITS];
    char           *p, *q, *r;
    unsigned short mult[MANT_WORDS], bit;
    unsigned short * m;
    long           tenpwr, twopwr;
    int            extratwos, started, seendot;

    p = digits;
    tenpwr = 0;
    started = seendot = FALSE;
    while (*string && *string != 'E' && *string != 'e') {
	if (*string == '.') {
	    if (!seendot)
		seendot = TRUE;
	    else {
		error (ERR_NONFATAL,
		       "too many periods in floating-point constant");
		return;
	    }
	} else if (*string >= '0' && *string <= '9') {
	    if (*string == '0' && !started) {
		if (seendot)
		    tenpwr--;
	    } else {
		started = TRUE;
		if (p < digits+sizeof(digits))
		    *p++ = *string - '0';
		if (!seendot)
		    tenpwr++;
	    }
	} else {
	    error (ERR_NONFATAL,
		   "floating-point constant: `%c' is invalid character",
		   *string);
	    return;
	}
	string++;
    }
    if (*string) {
	string++;		       /* eat the E */
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
    for (m=mant; m<mant+MANT_WORDS; m++)
	*m = 0;
    m = mant;
    q = digits;
    started = FALSE;
    twopwr = 0;
    while (m < mant+MANT_WORDS) {
	unsigned short carry = 0;
	while (p > q && !p[-1])
	    p--;
	if (p <= q)
	    break;
	for (r = p; r-- > q ;) {
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
	for (m=mult; m<mult+MANT_WORDS; m++)
	    *m = 0xCCCC;
	extratwos = -2;
	tenpwr = -tenpwr;
    } else if (tenpwr > 0) {
	mult[0] = 0xA000;
	for (m=mult+1; m<mult+MANT_WORDS; m++)
	    *m = 0;
	extratwos = 3;
    } else
	extratwos = 0;
    while (tenpwr) {
	if (tenpwr & 1)
	    twopwr += extratwos + multiply (mant, mult);
	extratwos = extratwos * 2 + multiply (mult, mult);
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
static void shr(unsigned short *mant, int i) 
{
    unsigned short n = 0, m;
    int            j;

    for (j=0; j<MANT_WORDS; j++) {
	m = (mant[j] << (16-i)) & 0xFFFF;
	mant[j] = (mant[j] >> i) | n;
	n = m;
    }
}

/*
 * Round a mantissa off after i words.
 */
static int round(unsigned short *mant, int i) 
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

static int to_double(char *str, long sign, unsigned char *result,
		     efunc error) 
{
    unsigned short mant[MANT_WORDS];
    long exponent;

    sign = (sign < 0 ? 0x8000L : 0L);

    flconvert (str, mant, &exponent, error);
    if (mant[0] & 0x8000) {
	/*
	 * Non-zero.
	 */
	exponent--;
	if (exponent >= -1022 && exponent <= 1024) {
	    /*
	     * Normalised.
	     */
	    exponent += 1023;
	    shr(mant, 11);
	    round(mant, 4);
	    if (mant[0] & 0x20)	       /* did we scale up by one? */
		shr(mant, 1), exponent++;
	    mant[0] &= 0xF;	       /* remove leading one */
	    put(result+6,(exponent << 4) | mant[0] | sign);
	    put(result+4,mant[1]);
	    put(result+2,mant[2]);
	    put(result+0,mant[3]);
	} else if (exponent < -1022 && exponent >= -1074) {
	    /*
	     * Denormal.
	     */
	    int shift = -(exponent+1011);
	    int sh = shift % 16, wds = shift / 16;
	    shr(mant, sh);
	    if (round(mant, 4-wds) || (sh>0 && (mant[0]&(0x8000>>(sh-1))))) {
		shr(mant, 1);
		if (sh==0)
		    mant[0] |= 0x8000;
		exponent++;
	    }
	    put(result+6,(wds == 0 ? mant[0] : 0) | sign);
	    put(result+4,(wds <= 1 ? mant[1-wds] : 0));
	    put(result+2,(wds <= 2 ? mant[2-wds] : 0));
	    put(result+0,(wds <= 3 ? mant[3-wds] : 0));
	} else {
	    if (exponent > 0) {
		error(ERR_NONFATAL, "overflow in floating-point constant");
		return 0;
	    } else
		memset (result, 0, 8);
	}
    } else {
	/*
	 * Zero.
	 */
	memset (result, 0, 8);
    }
    return 1;			       /* success */
}

static int to_float(char *str, long sign, unsigned char *result,
		    efunc error) 
{
    unsigned short mant[MANT_WORDS];
    long exponent;

    sign = (sign < 0 ? 0x8000L : 0L);

    flconvert (str, mant, &exponent, error);
    if (mant[0] & 0x8000) {
	/*
	 * Non-zero.
	 */
	exponent--;
	if (exponent >= -126 && exponent <= 128) {
	    /*
	     * Normalised.
	     */
	    exponent += 127;
	    shr(mant, 8);
	    round(mant, 2);
	    if (mant[0] & 0x100)       /* did we scale up by one? */
		shr(mant, 1), exponent++;
	    mant[0] &= 0x7F;	       /* remove leading one */
	    put(result+2,(exponent << 7) | mant[0] | sign);
	    put(result+0,mant[1]);
	} else if (exponent < -126 && exponent >= -149) {
	    /*
	     * Denormal.
	     */
	    int shift = -(exponent+118);
	    int sh = shift % 16, wds = shift / 16;
	    shr(mant, sh);
	    if (round(mant, 2-wds) || (sh>0 && (mant[0]&(0x8000>>(sh-1))))) {
		shr(mant, 1);
		if (sh==0)
		    mant[0] |= 0x8000;
		exponent++;
	    }
	    put(result+2,(wds == 0 ? mant[0] : 0) | sign);
	    put(result+0,(wds <= 1 ? mant[1-wds] : 0));
	} else {
	    if (exponent > 0) {
		error(ERR_NONFATAL, "overflow in floating-point constant");
		return 0;
	    } else
		memset (result, 0, 4);
	}
    } else {
	memset (result, 0, 4);
    }
    return 1;
}

static int to_ldoub(char *str, long sign, unsigned char *result,
		    efunc error) 
{
    unsigned short mant[MANT_WORDS];
    long exponent;

    sign = (sign < 0 ? 0x8000L : 0L);

    flconvert (str, mant, &exponent, error);
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
	    if (round(mant, 4))	       /* did we scale up by one? */
		shr(mant, 1), mant[0] |= 0x8000, exponent++;
	    put(result+8,exponent | sign);
	    put(result+6,mant[0]);
	    put(result+4,mant[1]);
	    put(result+2,mant[2]);
	    put(result+0,mant[3]);
	} else if (exponent < -16383 && exponent >= -16446) {
	    /*
	     * Denormal.
	     */
	    int shift = -(exponent+16383);
	    int sh = shift % 16, wds = shift / 16;
	    shr(mant, sh);
	    if (round(mant, 4-wds) || (sh>0 && (mant[0]&(0x8000>>(sh-1))))) {
		shr(mant, 1);
		if (sh==0)
		    mant[0] |= 0x8000;
		exponent++;
	    }
	    put(result+8,sign);
	    put(result+6,(wds == 0 ? mant[0] : 0));
	    put(result+4,(wds <= 1 ? mant[1-wds] : 0));
	    put(result+2,(wds <= 2 ? mant[2-wds] : 0));
	    put(result+0,(wds <= 3 ? mant[3-wds] : 0));
	} else {
	    if (exponent > 0) {
		error(ERR_NONFATAL, "overflow in floating-point constant");
		return 0;
	    } else
		memset (result, 0, 10);
	}
    } else {
	/*
	 * Zero.
	 */
	memset (result, 0, 10);
    }
    return 1;
}

int float_const (char *number, long sign, unsigned char *result, int bytes,
		 efunc error) 
{
    if (bytes == 4)
	return to_float (number, sign, result, error);
    else if (bytes == 8)
	return to_double (number, sign, result, error);
    else if (bytes == 10)
	return to_ldoub (number, sign, result, error);
    else {
	error(ERR_PANIC, "strange value %d passed to float_const", bytes);
	return 0;
    }
}
