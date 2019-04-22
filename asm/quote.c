/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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
 * quote.c
 */

#include "compiler.h"


#include "nasmlib.h"
#include "quote.h"
#include "nctype.h"
#include "error.h"

char *nasm_quote(const char *str, size_t len)
{
    const char *p, *ep;
    char c, c1, *q, *nstr;
    unsigned char uc;
    bool sq_ok, dq_ok;
    size_t qlen;

    sq_ok = dq_ok = true;
    ep = str+len;
    qlen = 0;			/* Length if we need `...` quotes */
    for (p = str; p < ep; p++) {
	c = *p;
	switch (c) {
	case '\'':
	    sq_ok = false;
	    qlen++;
	    break;
	case '\"':
	    dq_ok = false;
	    qlen++;
	    break;
	case '`':
	case '\\':
	    qlen += 2;
	    break;
	default:
	    if (c < ' ' || c > '~') {
		sq_ok = dq_ok = false;
		switch (c) {
		case '\a':
		case '\b':
		case '\t':
		case '\n':
		case '\v':
		case '\f':
		case '\r':
		case 27:
		    qlen += 2;
		    break;
		default:
		    c1 = (p+1 < ep) ? p[1] : 0;
		    if (c1 >= '0' && c1 <= '7')
			uc = 0377; /* Must use the full form */
		    else
			uc = c;
		    if (uc > 077)
			qlen++;
		    if (uc > 07)
			qlen++;
		    qlen += 2;
		    break;
		}
	    } else {
		qlen++;
	    }
	    break;
	}
    }

    if (sq_ok || dq_ok) {
	/* Use '...' or "..." */
	nstr = nasm_malloc(len+3);
	nstr[0] = nstr[len+1] = sq_ok ? '\'' : '\"';
	nstr[len+2] = '\0';
	if (len > 0)
	    memcpy(nstr+1, str, len);
    } else {
	/* Need to use `...` quoted syntax */
	nstr = nasm_malloc(qlen+3);
	q = nstr;
	*q++ = '`';
	for (p = str; p < ep; p++) {
	    c = *p;
	    switch (c) {
	    case '`':
	    case '\\':
		*q++ = '\\';
		*q++ = c;
		break;
	    case 7:
		*q++ = '\\';
		*q++ = 'a';
		break;
	    case 8:
		*q++ = '\\';
		*q++ = 'b';
		break;
	    case 9:
		*q++ = '\\';
		*q++ = 't';
		break;
	    case 10:
		*q++ = '\\';
		*q++ = 'n';
		break;
	    case 11:
		*q++ = '\\';
		*q++ = 'v';
		break;
	    case 12:
		*q++ = '\\';
		*q++ = 'f';
		break;
	    case 13:
		*q++ = '\\';
		*q++ = 'r';
		break;
	    case 27:
		*q++ = '\\';
		*q++ = 'e';
		break;
	    default:
		if (c < ' ' || c > '~') {
		    c1 = (p+1 < ep) ? p[1] : 0;
		    if (c1 >= '0' && c1 <= '7')
			uc = 0377; /* Must use the full form */
		    else
			uc = c;
		    *q++ = '\\';
		    if (uc > 077)
			*q++ = ((unsigned char)c >> 6) + '0';
		    if (uc > 07)
			*q++ = (((unsigned char)c >> 3) & 7) + '0';
		    *q++ = ((unsigned char)c & 7) + '0';
		    break;
		} else {
		    *q++ = c;
		}
		break;
	    }
	}
	*q++ = '`';
	*q++ = '\0';
	nasm_assert((size_t)(q-nstr) == qlen+3);
    }
    return nstr;
}

static unsigned char *emit_utf8(unsigned char *q, uint32_t v)
{
    uint32_t vb1, vb2, vb3, vb4, vb5;

    if (v <= 0x7f) {
	*q++ = v;
        goto out0;
    }

    vb1 = v >> 6;
    if (vb1 <= 0x3f) {
	*q++ = 0xc0 + vb1;
        goto out1;
    }

    vb2 = vb1 >> 6;
    if (vb2 <= 0x1f) {
        *q++ = 0xe0 + vb2;
        goto out2;
    }

    vb3 = vb2 >> 6;
    if (vb3 <= 0x0f) {
        *q++ = 0xf0 + vb3;
        goto out3;
    }

    vb4 = vb3 >> 6;
    if (vb4 <= 0x07) {
        *q++ = 0xf8 + vb4;
        goto out4;
    }

    vb5 = vb4 >> 6;
    if (vb5 <= 0x03) {
        *q++ = 0xfc + vb5;
        goto out5;
    }

    /* Otherwise invalid, even with 31-bit "extended Unicode" (pre-UTF-16) */
    goto out0;

    /* Emit extension bytes as appropriate */
out5: *q++ = 0x80 + (vb4 & 63);
out4: *q++ = 0x80 + (vb3 & 63);
out3: *q++ = 0x80 + (vb2 & 63);
out2: *q++ = 0x80 + (vb1 & 63);
out1: *q++ = 0x80 + (v & 63);
out0: return q;
}

/*
 * Do an *in-place* dequoting of the specified string, returning the
 * resulting length (which may be containing embedded nulls.)
 *
 * In-place replacement is possible since the unquoted length is always
 * shorter than or equal to the quoted length.
 *
 * *ep points to the final quote, or to the null if improperly quoted.
 *
 * Issue an error if the string contains characters less than cerr; in
 * that case, the output string, but not *ep, is truncated before the
 * first invalid character.
 */
#define EMIT(c)                                                 \
    do {                                                        \
        unsigned char ec = (c);                                 \
        err |= ec < cerr;                                       \
        if (!err)                                               \
            *q++ = (c);                                         \
    } while (0)

static size_t nasm_unquote_common(char *str, char **ep,
                                  const unsigned char cerr)
{
    char bq;
    unsigned char *p, *q;
    unsigned char *escp = NULL;
    unsigned char c;
    bool err = false;
    enum unq_state {
	st_start,
	st_backslash,
	st_hex,
	st_oct,
	st_ucs
    } state;
    int ndig = 0;
    uint32_t nval = 0;

    p = q = (unsigned char *)str;

    bq = *p++;
    if (!bq)
	return 0;

    switch (bq) {
    case '\'':
    case '\"':
	/* '...' or "..." string */
        while (1) {
            c = *p;
            if (!c) {
                break;
            } else if (c == bq) {
                /* Doubled quote = escaped quote */
                c = p[1];
                if (c != bq)
                    break;
                p++;
            }
            p++;
            EMIT(c);
        }
        *q = '\0';
	break;

    case '`':
	/* `...` string */
	state = st_start;

	while ((c = *p)) {
	    p++;
	    switch (state) {
	    case st_start:
		switch (c) {
		case '\\':
		    state = st_backslash;
		    break;
		case '`':
		    p--;
		    goto out;
		default:
                    EMIT(c);
		    break;
		}
		break;

	    case st_backslash:
		state = st_start;
		escp = p;	/* Beginning of argument sequence */
		nval = 0;
		switch (c) {
		case 'a':
		    nval = 7;
		    break;
		case 'b':
		    nval = 8;
		    break;
		case 'e':
		    nval = 27;
		    break;
		case 'f':
		    nval = 12;
		    break;
		case 'n':
		    nval = 10;
		    break;
		case 'r':
		    nval = 13;
		    break;
		case 't':
		    nval = 9;
		    break;
		case 'u':
		    state = st_ucs;
		    ndig = 4;
		    break;
		case 'U':
		    state = st_ucs;
		    ndig = 8;
		    break;
		case 'v':
		    nval = 11;
		    break;
		case 'x':
		case 'X':
		    state = st_hex;
		    ndig = 2;
		    break;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		    state = st_oct;
		    ndig = 2;	/* Up to two more digits */
		    nval = c - '0';
		    break;
		default:
		    nval = c;
		    break;
		}
                if (state == st_start)
                    EMIT(nval);
		break;

	    case st_oct:
		if (c >= '0' && c <= '7') {
		    nval = (nval << 3) + (c - '0');
		    if (!--ndig) {
			*q++ = nval;
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    EMIT(nval);
		    state = st_start;
		}
		break;

	    case st_hex:
		if (nasm_isxdigit(c)) {
		    nval = (nval << 4) + numvalue(c);
		    if (!--ndig) {
			*q++ = nval;
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    EMIT((p > escp) ? nval : escp[-1]);
		    state = st_start;
		}
		break;

	    case st_ucs:
		if (nasm_isxdigit(c)) {
		    nval = (nval << 4) + numvalue(c);
		    if (!--ndig) {
                        err |= nval < cerr;
                        if (!err)
                            q = emit_utf8(q, nval);
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    if (p > escp) {
                        err |= nval < cerr;
                        if (!err)
                            q = emit_utf8(q, nval);
                    } else {
			EMIT(escp[-1]);
                    }
		    state = st_start;
		}
		break;
	    }
	}
	switch (state) {
	case st_start:
	case st_backslash:
	    break;
	case st_oct:
	    EMIT(nval);
	    break;
	case st_hex:
	    EMIT((p > escp) ? nval : escp[-1]);
	    break;
	case st_ucs:
	    if (p > escp) {
                err |= nval < cerr;
                if (!err)
                    q = emit_utf8(q, nval);
            } else {
		EMIT(escp[-1]);
            }
	    break;
	}
    out:
	break;

    default:
	/* Not a quoted string, just return the input... */
        while ((c = *p++)) {
            if (!c)
                break;
            EMIT(c);
        }
	break;
    }

    *q = '\0';

    if (err)
        nasm_nonfatal("control character in string not allowed here");

    if (ep)
	*ep = (char *)p;
    return (char *)q - str;
}
#undef EMIT

size_t nasm_unquote(char *str, char **ep)
{
    return nasm_unquote_common(str, ep, 0);
}
size_t nasm_unquote_cstr(char *str, char **ep)
{
    return nasm_unquote_common(str, ep, ' ');
}

/*
 * Find the end of a quoted string; returns the pointer to the terminating
 * character (either the ending quote or the null character, if unterminated.)
 */
char *nasm_skip_string(char *str)
{
    char bq;
    char *p;
    char c;
    enum unq_state {
	st_start,
	st_backslash
    } state;

    bq = str[0];
    if (bq == '\'' || bq == '\"') {
	/* '...' or "..." string */
	for (p = str+1; *p; p++) {
            if (p[0] == bq && p[1] != bq)
                break;
        }
	return p;
    } else if (bq == '`') {
	/* `...` string */
	state = st_start;
	p = str+1;
	if (!*p)
		return p;

	while ((c = *p++)) {
	    switch (state) {
	    case st_start:
		switch (c) {
		case '\\':
		    state = st_backslash;
		    break;
		case '`':
		    return p-1;	/* Found the end */
		default:
		    break;
		}
		break;

	    case st_backslash:
		/*
		 * Note: for the purpose of finding the end of the string,
		 * all successor states to st_backslash are functionally
		 * equivalent to st_start, since either a backslash or
		 * a backquote will force a return to the st_start state.
		 */
		state = st_start;
		break;
	    }
	}
	return p-1;		/* Unterminated string... */
    } else {
	return str;		/* Not a string... */
    }
}
