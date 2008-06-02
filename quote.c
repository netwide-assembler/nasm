/* quote.c	library routines for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the license given in the file "LICENSE"
 * distributed in the NASM archive.
 */

#include "compiler.h"

#include <assert.h>
#include <stdlib.h>

#include "nasmlib.h"
#include "quote.h"

#define numvalue(c)  ((c)>='a' ? (c)-'a'+10 : (c)>='A' ? (c)-'A'+10 : (c)-'0')

char *nasm_quote(char *str, size_t len)
{
    char c, c1, *p, *q, *nstr, *ep;
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
		    if (c > 077 || (c1 >= '0' && c1 <= '7'))
			qlen += 4; /* Must use the full form */
		    else if (c > 07)
			qlen += 3;
		    else
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
	    case '\a':
		*q++ = '\\';
		*q++ = 'a';
		break;
	    case '\b':
		*q++ = '\\';
		*q++ = 'b';
		break;
	    case '\t':
		*q++ = '\\';
		*q++ = 't';
		break;
	    case '\n':
		*q++ = '\\';
		*q++ = 'n';
		break;
	    case '\v':
		*q++ = '\\';
		*q++ = 'v';
		break;
	    case '\f':
		*q++ = '\\';
		*q++ = 'f';
		break;
	    case '\r':
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
			q += sprintf(q, "\\%03o", (unsigned char)c);
		    else
			q += sprintf(q, "\\%o", (unsigned char)c);
		} else {
		    *q++ = c;
		}
		break;
	    }
	}
	*q++ = '`';
	*q++ = '\0';
	assert((size_t)(q-nstr) == qlen+3);
    }
    return nstr;
}

static char *emit_utf8(char *q, int32_t v)
{
    if (v < 0) {
	/* Impossible - do nothing */
    } else if (v <= 0x7f) {
	*q++ = v;
    } else if (v <= 0x000007ff) {
	*q++ = 0xc0 | (v >> 6);
	*q++ = 0x80 | (v & 63);
    } else if (v <= 0x0000ffff) {
	*q++ = 0xe0 | (v >> 12);
	*q++ = 0x80 | ((v >> 6) & 63);
	*q++ = 0x80 | (v & 63);
    } else if (v <= 0x001fffff) {
	*q++ = 0xf0 | (v >> 18);
	*q++ = 0x80 | ((v >> 12) & 63);
	*q++ = 0x80 | ((v >> 6) & 63);
	*q++ = 0x80 | (v & 63);
    } else if (v <= 0x03ffffff) {
	*q++ = 0xf8 | (v >> 24);
	*q++ = 0x80 | ((v >> 18) & 63);
	*q++ = 0x80 | ((v >> 12) & 63);
	*q++ = 0x80 | ((v >> 6) & 63);
	*q++ = 0x80 | (v & 63);
    } else {
	*q++ = 0xfc | (v >> 30);
	*q++ = 0x80 | ((v >> 24) & 63);
	*q++ = 0x80 | ((v >> 18) & 63);
	*q++ = 0x80 | ((v >> 12) & 63);
	*q++ = 0x80 | ((v >> 6) & 63);
	*q++ = 0x80 | (v & 63);
    }
    return q;
}

/*
 * Do an *in-place* dequoting of the specified string, returning the
 * resulting length (which may be containing embedded nulls.)
 *
 * In-place replacement is possible since the unquoted length is always
 * shorter than or equal to the quoted length.
 */
size_t nasm_unquote(char *str)
{
    size_t ln;
    char bq, eq;
    char *p, *q, *ep;
    char *escp = NULL;
    char c;
    enum unq_state {
	st_start,
	st_backslash,
	st_hex,
	st_oct,
	st_ucs,
    } state;
    int ndig = 0;
    int32_t nval = 0;

    bq = str[0];
    if (!bq)
	return 0;
    ln = strlen(str);
    eq = str[ln-1];

    if ((bq == '\'' || bq == '\"') && bq == eq) {
	/* '...' or "..." string */
	memmove(str, str+1, ln-2);
	str[ln-2] = '\0';
	return ln-2;
    }
    if (bq == '`' || eq == '`') {
	/* `...` string */
	q = str;
	p = str+1;
	ep = str+ln-1;
	state = st_start;

	while (p < ep) {
	    c = *p++;
	    switch (state) {
	    case st_start:
		if (c == '\\')
		    state = st_backslash;
		else
		    *q++ = c;
		break;

	    case st_backslash:
		state = st_start;
		escp = p-1;
		switch (c) {
		case 'a':
		    *q++ = 7;
		    break;
		case 'b':
		    *q++ = 8;
		    break;
		case 'e':
		    *q++ = 27;
		    break;
		case 'f':
		    *q++ = 12;
		    break;
		case 'n':
		    *q++ = 10;
		    break;
		case 'r':
		    *q++ = 13;
		    break;
		case 't':
		    *q++ = 9;
		    break;
		case 'u':
		    state = st_ucs;
		    ndig = 4;
		    nval = 0;
		    break;
		case 'U':
		    state = st_ucs;
		    ndig = 8;
		    nval = 0;
		    break;
		case 'v':
		    *q++ = 11;
		case 'x':
		case 'X':
		    state = st_hex;
		    ndig = nval = 0;
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
		    ndig = 1;
		    nval = c - '0';
		    break;
		default:
		    *q++ = c;
		    break;
		}
		break;

	    case st_oct:
		if (c >= '0' && c <= '7') {
		    nval = (nval << 3) + (c - '0');
		    if (++ndig >= 3) {
			*q++ = nval;
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    *q++ = nval;
		    state = st_start;
		}
		break;

	    case st_hex:
		if ((c >= '0' && c <= '9') ||
		    (c >= 'A' && c <= 'F') ||
		    (c >= 'a' && c <= 'f')) {
		    nval = (nval << 4) + numvalue(c);
		    if (++ndig >= 2) {
			*q++ = nval;
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    *q++ = ndig ? nval : *escp;
		    state = st_start;
		}
		break;

	    case st_ucs:
		if ((c >= '0' && c <= '9') ||
		    (c >= 'A' && c <= 'F') ||
		    (c >= 'a' && c <= 'f')) {
		    nval = (nval << 4) + numvalue(c);
		    if (!--ndig) {
			q = emit_utf8(q, nval);
			state = st_start;
		    }
		} else {
		    p--;	/* Process this character again */
		    if (p > escp+1)
			q = emit_utf8(q, nval);
		    else
			*q++ = *escp;
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
	    *q++ = nval;
	    break;
	case st_hex:
	    *q++ = ndig ? nval : *escp;
	    break;
	case st_ucs:
	    if (ndig)
		q = emit_utf8(q, nval);
	    else
		*q++ = *escp;
	    break;
	}
	*q = '\0';
	return q-str;
    }

    /* Otherwise, just return the input... */
    return ln;
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
	st_backslash,
	st_hex,
	st_oct,
	st_ucs,
    } state;
    int ndig = 0;

    bq = str[0];
    if (bq == '\'' || bq == '\"') {
	/* '...' or "..." string */
	for (p = str+1; *p && *p != bq; p++)
	    ;
	return p;
    } else if (bq == '`') {
	/* `...` string */
	p = str+1;
	state = st_start;

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
		switch (c) {
		case 'a':
		case 'b':
		case 'e':
		case 'f':
		case 'n':
		case 'r':
		case 't':
		case 'v':
		default:
		    state = st_start;
		    break;
		case 'u':
		    state = st_ucs;
		    ndig = 4;
		    break;
		case 'U':
		    state = st_ucs;
		    ndig = 8;
		    break;
		case 'x':
		case 'X':
		    state = st_hex;
		    ndig = 0;
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
		    ndig = 1;
		    break;
		}
		break;

	    case st_oct:
		if (c >= '0' && c <= '7') {
		    if (++ndig >= 3)
			state = st_start;
		} else {
		    p--;	/* Process this character again */
		    state = st_start;
		}
		break;

	    case st_hex:
		if ((c >= '0' && c <= '9') ||
		    (c >= 'A' && c <= 'F') ||
		    (c >= 'a' && c <= 'f')) {
		    if (++ndig >= 2)
			state = st_start;
		} else {
		    p--;	/* Process this character again */
		    state = st_start;
		}
		break;

	    case st_ucs:
		if ((c >= '0' && c <= '9') ||
		    (c >= 'A' && c <= 'F') ||
		    (c >= 'a' && c <= 'f')) {
		    if (!--ndig)
			state = st_start;
		} else {
		    p--;	/* Process this character again */
		    state = st_start;
		}
		break;
	    }
	}
	return p;		/* Unterminated string... */
    } else {
	return str;		/* Not a string... */
    }
}
