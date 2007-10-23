#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "stdscan.h"
#include "insns.h"

/*
 * Standard scanner routine used by parser.c and some output
 * formats. It keeps a succession of temporary-storage strings in
 * stdscan_tempstorage, which can be cleared using stdscan_reset.
 */
static char **stdscan_tempstorage = NULL;
static int stdscan_tempsize = 0, stdscan_templen = 0;
#define STDSCAN_TEMP_DELTA 256

static void stdscan_pop(void)
{
    nasm_free(stdscan_tempstorage[--stdscan_templen]);
}

void stdscan_reset(void)
{
    while (stdscan_templen > 0)
        stdscan_pop();
}

/*
 * Unimportant cleanup is done to avoid confusing people who are trying
 * to debug real memory leaks
 */
void stdscan_cleanup(void)
{
    stdscan_reset();
    nasm_free(stdscan_tempstorage);
}

static char *stdscan_copy(char *p, int len)
{
    char *text;

    text = nasm_malloc(len + 1);
    strncpy(text, p, len);
    text[len] = '\0';

    if (stdscan_templen >= stdscan_tempsize) {
        stdscan_tempsize += STDSCAN_TEMP_DELTA;
        stdscan_tempstorage = nasm_realloc(stdscan_tempstorage,
                                           stdscan_tempsize *
                                           sizeof(char *));
    }
    stdscan_tempstorage[stdscan_templen++] = text;

    return text;
}

char *stdscan_bufptr = NULL;
int stdscan(void *private_data, struct tokenval *tv)
{
    char ourcopy[MAX_KEYWORD + 1], *r, *s;

    (void)private_data;         /* Don't warn that this parameter is unused */

    while (isspace(*stdscan_bufptr))
        stdscan_bufptr++;
    if (!*stdscan_bufptr)
        return tv->t_type = 0;

    /* we have a token; either an id, a number or a char */
    if (isidstart(*stdscan_bufptr) ||
        (*stdscan_bufptr == '$' && isidstart(stdscan_bufptr[1]))) {
        /* now we've got an identifier */
        bool is_sym = false;

        if (*stdscan_bufptr == '$') {
            is_sym = true;
            stdscan_bufptr++;
        }

        r = stdscan_bufptr++;
        /* read the entire buffer to advance the buffer pointer but... */
        while (isidchar(*stdscan_bufptr))
            stdscan_bufptr++;

        /* ... copy only up to IDLEN_MAX-1 characters */
        tv->t_charptr = stdscan_copy(r, stdscan_bufptr - r < IDLEN_MAX ?
                                     stdscan_bufptr - r : IDLEN_MAX - 1);

        if (is_sym || stdscan_bufptr - r > MAX_KEYWORD)
            return tv->t_type = TOKEN_ID;       /* bypass all other checks */

        for (s = tv->t_charptr, r = ourcopy; *s; s++)
            *r++ = tolower(*s);
        *r = '\0';
        /* right, so we have an identifier sitting in temp storage. now,
         * is it actually a register or instruction name, or what? */
	return nasm_token_hash(ourcopy, tv);
    } else if (*stdscan_bufptr == '$' && !isnumchar(stdscan_bufptr[1])) {
        /*
         * It's a $ sign with no following hex number; this must
         * mean it's a Here token ($), evaluating to the current
         * assembly location, or a Base token ($$), evaluating to
         * the base of the current segment.
         */
        stdscan_bufptr++;
        if (*stdscan_bufptr == '$') {
            stdscan_bufptr++;
            return tv->t_type = TOKEN_BASE;
        }
        return tv->t_type = TOKEN_HERE;
    } else if (isnumstart(*stdscan_bufptr)) {   /* now we've got a number */
        bool rn_error;
	bool is_hex = false;
	bool is_float = false;
	bool has_e = false;
	char c;

        r = stdscan_bufptr;

	if (*stdscan_bufptr == '$') {
	    stdscan_bufptr++;
	    is_hex = true;
	}

	for (;;) {
	    c = *stdscan_bufptr++;

	    if (!is_hex && (c == 'e' || c == 'E')) {
		has_e = true;
		if (*stdscan_bufptr == '+' || *stdscan_bufptr == '-') {
		    /* e can only be followed by +/- if it is either a
		       prefixed hex number or a floating-point number */
		    is_float = true;
		    stdscan_bufptr++;
		}
	    } else if (c == 'H' || c == 'h' || c == 'X' || c == 'x') {
		is_hex = true;
	    } else if (c == 'P' || c == 'p') {
		is_float = true;
		if (*stdscan_bufptr == '+' || *stdscan_bufptr == '-')
		    stdscan_bufptr++;
	    } else if (isnumchar(c) || c == '_')
		; /* just advance */
	    else if (c == '.')
		is_float = true;
	    else
		break;
	}
	stdscan_bufptr--;	/* Point to first character beyond number */

	if (has_e && !is_hex) {
	    /* 1e13 is floating-point, but 1e13h is not */
	    is_float = true;
	}

	if (is_float) {
	    tv->t_charptr = stdscan_copy(r, stdscan_bufptr - r);
	    return tv->t_type = TOKEN_FLOAT;
	} else {
	    r = stdscan_copy(r, stdscan_bufptr - r);
	    tv->t_integer = readnum(r, &rn_error);
	    stdscan_pop();
	    if (rn_error)
		return tv->t_type = TOKEN_ERRNUM;   /* some malformation occurred */
	    tv->t_charptr = NULL;
	    return tv->t_type = TOKEN_NUM;
	}
    } else if (*stdscan_bufptr == '\'' || *stdscan_bufptr == '"') {
	/* a char constant */
        char quote = *stdscan_bufptr++, *r;
        bool rn_warn;
        r = tv->t_charptr = stdscan_bufptr;
        while (*stdscan_bufptr && *stdscan_bufptr != quote)
            stdscan_bufptr++;
        tv->t_inttwo = stdscan_bufptr - r;      /* store full version */
        if (!*stdscan_bufptr)
            return tv->t_type = TOKEN_ERRNUM;   /* unmatched quotes */
        stdscan_bufptr++;       /* skip over final quote */
        tv->t_integer = readstrnum(r, tv->t_inttwo, &rn_warn);
        /* FIXME: rn_warn is not checked! */
        return tv->t_type = TOKEN_NUM;
    } else if (*stdscan_bufptr == ';') {        /* a comment has happened - stay */
        return tv->t_type = 0;
    } else if (stdscan_bufptr[0] == '>' && stdscan_bufptr[1] == '>') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_SHR;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '<') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_SHL;
    } else if (stdscan_bufptr[0] == '/' && stdscan_bufptr[1] == '/') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_SDIV;
    } else if (stdscan_bufptr[0] == '%' && stdscan_bufptr[1] == '%') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_SMOD;
    } else if (stdscan_bufptr[0] == '=' && stdscan_bufptr[1] == '=') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_EQ;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '>') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_NE;
    } else if (stdscan_bufptr[0] == '!' && stdscan_bufptr[1] == '=') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_NE;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '=') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_LE;
    } else if (stdscan_bufptr[0] == '>' && stdscan_bufptr[1] == '=') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_GE;
    } else if (stdscan_bufptr[0] == '&' && stdscan_bufptr[1] == '&') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_DBL_AND;
    } else if (stdscan_bufptr[0] == '^' && stdscan_bufptr[1] == '^') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_DBL_XOR;
    } else if (stdscan_bufptr[0] == '|' && stdscan_bufptr[1] == '|') {
        stdscan_bufptr += 2;
        return tv->t_type = TOKEN_DBL_OR;
    } else                      /* just an ordinary char */
        return tv->t_type = (uint8_t)(*stdscan_bufptr++);
}
