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
 * Parse and handle assembler directives
 */

#include "compiler.h"

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>

#include "nasm.h"
#include "nasmlib.h"
#include "error.h"
#include "float.h"
#include "stdscan.h"
#include "preproc.h"
#include "eval.h"
#include "assemble.h"
#include "outform.h"
#include "listing.h"
#include "labels.h"
#include "iflag.h"

static iflag_t get_cpu(char *value)
{
    iflag_t r;

    iflag_clear_all(&r);

    if (!strcmp(value, "8086"))
        iflag_set(&r, IF_8086);
    else if (!strcmp(value, "186"))
        iflag_set(&r, IF_186);
    else if (!strcmp(value, "286"))
        iflag_set(&r, IF_286);
    else if (!strcmp(value, "386"))
        iflag_set(&r, IF_386);
    else if (!strcmp(value, "486"))
        iflag_set(&r, IF_486);
    else if (!strcmp(value, "586") ||
             !nasm_stricmp(value, "pentium"))
        iflag_set(&r, IF_PENT);
    else if (!strcmp(value, "686")              ||
             !nasm_stricmp(value, "ppro")       ||
             !nasm_stricmp(value, "pentiumpro") ||
             !nasm_stricmp(value, "p2"))
        iflag_set(&r, IF_P6);
    else if (!nasm_stricmp(value, "p3") ||
             !nasm_stricmp(value, "katmai"))
        iflag_set(&r, IF_KATMAI);
    else if (!nasm_stricmp(value, "p4") ||   /* is this right? -- jrc */
             !nasm_stricmp(value, "willamette"))
        iflag_set(&r, IF_WILLAMETTE);
    else if (!nasm_stricmp(value, "prescott"))
        iflag_set(&r, IF_PRESCOTT);
    else if (!nasm_stricmp(value, "x64") ||
             !nasm_stricmp(value, "x86-64"))
        iflag_set(&r, IF_X86_64);
    else if (!nasm_stricmp(value, "ia64")   ||
             !nasm_stricmp(value, "ia-64")  ||
             !nasm_stricmp(value, "itanium")||
             !nasm_stricmp(value, "itanic") ||
             !nasm_stricmp(value, "merced"))
        iflag_set(&r, IF_IA64);
    else {
        iflag_set(&r, IF_PLEVEL);
        nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_FATAL,
                   "unknown 'cpu' type");
    }
    return r;
}

static int get_bits(char *value)
{
    int i;

    if ((i = atoi(value)) == 16)
        return i;               /* set for a 16-bit segment */
    else if (i == 32) {
        if (iflag_ffs(&cpu) < IF_386) {
            nasm_error(ERR_NONFATAL,
                         "cannot specify 32-bit segment on processor below a 386");
            i = 16;
        }
    } else if (i == 64) {
        if (iflag_ffs(&cpu) < IF_X86_64) {
            nasm_error(ERR_NONFATAL,
                         "cannot specify 64-bit segment on processor below an x86-64");
            i = 16;
        }
    } else {
        nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_FATAL,
                     "`%s' is not a valid segment size; must be 16, 32 or 64",
                     value);
        i = 16;
    }
    return i;
}

static enum directive parse_directive_line(char **directive, char **value)
{
    char *p, *q, *buf;

    buf = nasm_skip_spaces(*directive);

    /*
     * It should be enclosed in [ ].
     * XXX: we don't check there is nothing else on the remainder of the
     * line, except a possible comment.
     */
    if (*buf != '[')
        return D_none;
    q = strchr(buf, ']');
    if (!q)
        return D_corrupt;

    /*
     * Strip off the comments.  XXX: this doesn't account for quoted
     * strings inside a directive.  We should really strip the
     * comments in generic code, not here.  While we're at it, it
     * would be better to pass the backend a series of tokens instead
     * of a raw string, and actually process quoted strings for it,
     * like of like argv is handled in C.
     */
    p = strchr(buf, ';');
    if (p) {
        if (p < q) /* ouch! somewhere inside */
            return D_corrupt;
        *p = '\0';
    }

    /* no brace, no trailing spaces */
    *q = '\0';
    nasm_zap_spaces_rev(--q);

    /* directive */
    p = nasm_skip_spaces(++buf);
    q = nasm_skip_word(p);
    if (!q)
        return D_corrupt; /* sigh... no value there */
    *q = '\0';
    *directive = p;

    /* and value finally */
    p = nasm_skip_spaces(++q);
    *value = p;

    return directive_find(*directive);
}

/*
 * Process a line from the assembler and try to handle it if it
 * is a directive.  Return true if the line was handled (including
 * if it was an error), false otherwise.
 */
bool process_directives(char *directive)
{
    enum directive d;
    char *value, *p, *q, *special;
    struct tokenval tokval;
    bool bad_param = false;
    int pass2 = passn > 1 ? 2 : 1;

    d = parse_directive_line(&directive, &value);

    switch (d) {
    case D_none:
        return D_none;      /* Not a directive */

    case D_corrupt:
	nasm_error(ERR_NONFATAL, "invalid directive line");
	break;

    default:			/* It's a backend-specific directive */
        switch (ofmt->directive(d, value, pass2)) {
        case DIRR_UNKNOWN:
            goto unknown;
        case DIRR_OK:
        case DIRR_ERROR:
            break;
        case DIRR_BADPARAM:
            bad_param = true;
            break;
        default:
            panic();
        }
        break;

    case D_unknown:
    unknown:
        nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_PANIC,
                   "unrecognised directive [%s]", directive);
        break;

    case D_SEGMENT:         /* [SEGMENT n] */
    case D_SECTION:
    {
	int sb;
        int32_t seg = ofmt->section(value, pass2, &sb);

        if (seg == NO_SEG) {
            nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_PANIC,
                       "segment name `%s' not recognized", value);
        } else {
            in_absolute = false;
            location.segment = seg;
        }
        break;
    }

    case D_SECTALIGN:       /* [SECTALIGN n] */
    {
	expr *e;

        if (*value) {
            stdscan_reset();
            stdscan_set(value);
            tokval.t_type = TOKEN_INVALID;
            e = evaluate(stdscan, NULL, &tokval, NULL, pass2, NULL);
            if (e) {
                uint64_t align = e->value;

		if (!is_power2(e->value)) {
                    nasm_error(ERR_NONFATAL,
                               "segment alignment `%s' is not power of two",
                               value);
		} else if (align > UINT64_C(0x7fffffff)) {
                    /*
                     * FIXME: Please make some sane message here
                     * ofmt should have some 'check' method which
                     * would report segment alignment bounds.
                     */
		    nasm_error(ERR_NONFATAL,
			       "absurdly large segment alignment `%s' (2^%d)",
			       value, ilog2_64(align));
                }

                /* callee should be able to handle all details */
                if (location.segment != NO_SEG)
                    ofmt->sectalign(location.segment, align);
            }
        }
        break;
    }

    case D_EXTERN:          /* [EXTERN label:special] */
        if (*value == '$')
            value++;        /* skip initial $ if present */
        if (pass0 == 2) {
            q = value;
            while (*q && *q != ':')
                q++;
            if (*q == ':') {
                *q++ = '\0';
                ofmt->symdef(value, 0L, 0L, 3, q);
            }
        } else if (passn == 1) {
            bool validid = true;
            q = value;
            if (!isidstart(*q))
                validid = false;
            while (*q && *q != ':') {
                if (!isidchar(*q))
                    validid = false;
                q++;
            }
            if (!validid) {
                nasm_error(ERR_NONFATAL, "identifier expected after EXTERN");
                break;
            }
            if (*q == ':') {
                *q++ = '\0';
                special = q;
            } else
                special = NULL;
            if (!is_extern(value)) {        /* allow re-EXTERN to be ignored */
                int temp = pass0;
                pass0 = 1;  /* fake pass 1 in labels.c */
                declare_as_global(value, special);
                define_label(value, seg_alloc(), 0L, NULL,
                             false, true);
                pass0 = temp;
            }
        }           /* else  pass0 == 1 */
        break;

    case D_BITS:            /* [BITS bits] */
        globalbits = get_bits(value);
        break;

    case D_GLOBAL:          /* [GLOBAL symbol:special] */
        if (*value == '$')
            value++;        /* skip initial $ if present */
        if (pass0 == 2) {   /* pass 2 */
            q = value;
            while (*q && *q != ':')
                q++;
            if (*q == ':') {
                *q++ = '\0';
                ofmt->symdef(value, 0L, 0L, 3, q);
            }
        } else if (pass2 == 1) {    /* pass == 1 */
            bool validid = true;

            q = value;
            if (!isidstart(*q))
                validid = false;
            while (*q && *q != ':') {
                if (!isidchar(*q))
                    validid = false;
                q++;
            }
            if (!validid) {
                nasm_error(ERR_NONFATAL,
                           "identifier expected after GLOBAL");
                break;
            }
            if (*q == ':') {
                *q++ = '\0';
                special = q;
            } else
                special = NULL;
            declare_as_global(value, special);
        }           /* pass == 1 */
        break;

    case D_COMMON:          /* [COMMON symbol size:special] */
    {
        int64_t size;
	bool rn_error;
	bool validid;

        if (*value == '$')
            value++;        /* skip initial $ if present */
        p = value;
        validid = true;
        if (!isidstart(*p))
            validid = false;
        while (*p && !nasm_isspace(*p)) {
            if (!isidchar(*p))
                validid = false;
            p++;
        }
        if (!validid) {
            nasm_error(ERR_NONFATAL, "identifier expected after COMMON");
            break;
        }
        if (*p) {
            p = nasm_zap_spaces_fwd(p);
            q = p;
            while (*q && *q != ':')
                q++;
            if (*q == ':') {
                *q++ = '\0';
                special = q;
            } else {
                special = NULL;
            }
            size = readnum(p, &rn_error);
            if (rn_error) {
                nasm_error(ERR_NONFATAL,
                           "invalid size specified"
                           " in COMMON declaration");
                break;
            }
        } else {
            nasm_error(ERR_NONFATAL,
                       "no size specified in"
                       " COMMON declaration");
            break;
        }

        if (pass0 < 2) {
            define_common(value, seg_alloc(), size, special);
        } else if (pass0 == 2) {
            if (special)
                ofmt->symdef(value, 0L, 0L, 3, special);
        }
        break;
    }

    case D_ABSOLUTE:        /* [ABSOLUTE address] */
    {
	expr *e;

        stdscan_reset();
        stdscan_set(value);
        tokval.t_type = TOKEN_INVALID;
        e = evaluate(stdscan, NULL, &tokval, NULL, pass2, NULL);
        if (e) {
            if (!is_reloc(e))
                nasm_error(pass0 ==
                           1 ? ERR_NONFATAL : ERR_PANIC,
                           "cannot use non-relocatable expression as "
                           "ABSOLUTE address");
            else {
                absolute.segment = reloc_seg(e);
                absolute.offset = reloc_value(e);
            }
        } else if (passn == 1)
            absolute.offset = 0x100;     /* don't go near zero in case of / */
        else
            nasm_panic(0, "invalid ABSOLUTE address "
                       "in pass two");
        in_absolute = true;
        location.segment = NO_SEG;
        break;
    }

    case D_DEBUG:           /* [DEBUG] */
    {
        bool badid, overlong;
	char debugid[128];

        p = value;
        q = debugid;
        badid = overlong = false;
        if (!isidstart(*p)) {
            badid = true;
        } else {
            while (*p && !nasm_isspace(*p)) {
                if (q >= debugid + sizeof debugid - 1) {
                    overlong = true;
                    break;
                }
                if (!isidchar(*p))
                    badid = true;
                *q++ = *p++;
            }
            *q = 0;
        }
        if (badid) {
            nasm_error(passn == 1 ? ERR_NONFATAL : ERR_PANIC,
                       "identifier expected after DEBUG");
            break;
        }
        if (overlong) {
            nasm_error(passn == 1 ? ERR_NONFATAL : ERR_PANIC,
                       "DEBUG identifier too long");
            break;
        }
        p = nasm_skip_spaces(p);
        if (pass0 == 2)
            dfmt->debug_directive(debugid, p);
        break;
    }

    case D_WARNING:         /* [WARNING {+|-|*}warn-name] */
        if (!set_warning_status(value)) {
            nasm_error(ERR_WARNING|ERR_WARN_UNK_WARNING,
                       "unknown warning option: %s", value);
        }
        break;

    case D_CPU:         /* [CPU] */
        cpu = get_cpu(value);
        break;

    case D_LIST:        /* [LIST {+|-}] */
        value = nasm_skip_spaces(value);
        if (*value == '+') {
            user_nolist = false;
        } else {
            if (*value == '-') {
                user_nolist = true;
            } else {
                bad_param = true;
            }
        }
        break;

    case D_DEFAULT:         /* [DEFAULT] */
        stdscan_reset();
        stdscan_set(value);
        tokval.t_type = TOKEN_INVALID;
        if (stdscan(NULL, &tokval) != TOKEN_INVALID) {
            switch (tokval.t_integer) {
            case S_REL:
                globalrel = 1;
                break;
            case S_ABS:
                globalrel = 0;
                break;
            case P_BND:
                globalbnd = 1;
                break;
            case P_NOBND:
                globalbnd = 0;
                break;
            default:
                bad_param = true;
                break;
            }
        } else {
            bad_param = true;
        }
        break;

    case D_FLOAT:
        if (float_option(value)) {
            nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_PANIC,
                       "unknown 'float' directive: %s", value);
        }
        break;

    case D_PRAGMA:
        process_pragma(value);
        break;
    }


    /* A common error message */
    if (bad_param) {
        nasm_error(ERR_NONFATAL, "invalid parameter to [%s] directive",
                   directive);
    }

    return d != D_none;
}
