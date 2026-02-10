/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

/*
 * ndisasm.c   the Netwide Disassembler main module
 */

#include "compiler.h"

#include "nctype.h"
#include <errno.h>

#include "insns.h"
#include "nasm.h"
#include "nasmlib.h"
#include "error.h"
#include "ver.h"
#include "sync.h"
#include "disasm.h"

const char *_progname;

static int bpl = 8;             /* bytes per line of hex dump */

static void output_ins(uint64_t, const uint8_t *, int, const char *);
static bool skip(off_t *posp, off_t dist, FILE *fp);

int main(int argc, char **argv)
{
    uint8_t buffer[INSN_MAX * 2], *p;
    const uint8_t *q;
    char outbuf[256];
    char *pname = *argv;
    char *filename = NULL;
    uint64_t nextsync, synclen;
    size_t lenread;
    bool autosync = false;
    int bits = 16, b;
    bool eof;
    iflag_t prefer;
    bool rn_error;
    uint64_t offset, dataread, datamax;
    off_t fileoffs, initskip;
    FILE *fp;

    _progname = argv[0];

    reset_global_defaults(0);
    nasm_ctype_init();
    iflag_clear_all(&prefer);

    offset   = 0;
    datamax  = UINT64_C(-1);
    initskip = 0;

    init_sync();

    while (--argc) {
        char *v, *vv, *p = *++argv;
        if (*p == '-' && p[1]) {
            p++;
            while (*p)
                switch (nasm_tolower(*p)) {
                case 'a':      /* auto or intelligent sync */
                case 'i':
                    autosync = true;
                    p++;
                    break;
                case 'h':
                    usage();
                    return 0;
                case 'r':
                case 'v':
                    fprintf(stderr,
                            "NDISASM version %s compiled on %s\n",
			    nasm_version, nasm_date);
                    return 0;
                case 'u':	/* -u for -b 32, -uu for -b 64 */
		    if (bits < 64)
			bits <<= 1;
                    p++;
                    break;
                case 'l':
                    bits = 64;
                    p++;
                    break;
                case 'w':
                    bpl = 16;
                    p++;
                    break;
                case 'z':       /* max number of bytes to read */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-z' requires an argument\n",
                                pname);
                        return 1;
                    }
                    datamax = readnum(v, &rn_error);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-z' requires a numeric argument\n",
                                pname);
                        return 1;
                    }
                    p = "";     /* force to next argument */
                    break;

                case 'b':      /* bits */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-b' requires an argument\n",
                                pname);
                        return 1;
                    }
		    b = readnum(v, &rn_error);
		    if (rn_error ||
                        !(bits == 16 || bits == 32 || bits == 64)) {
                        fprintf(stderr, "%s: argument to `-b' should"
                                " be 16, 32 or 64\n", pname);
                    } else {
			bits = b;
		    }
                    p = "";     /* force to next argument */
                    break;
                case 'o':      /* origin */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-o' requires an argument\n",
                                pname);
                        return 1;
                    }
                    offset = readnum(v, &rn_error);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-o' requires a numeric argument\n",
                                pname);
                        return 1;
                    }
                    p = "";     /* force to next argument */
                    break;
                case 's':      /* sync point */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-s' requires an argument\n",
                                pname);
                        return 1;
                    }
                    add_sync(readnum(v, &rn_error), 0L);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-s' requires a numeric argument\n",
                                pname);
                        return 1;
                    }
                    p = "";     /* force to next argument */
                    break;
                case 'e':      /* skip a header */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-e' requires an argument\n",
                                pname);
                        return 1;
                    }
                    initskip = readnum(v, &rn_error);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-e' requires a numeric argument\n",
                                pname);
                        return 1;
                    }
                    p = "";     /* force to next argument */
                    break;
                case 'k':      /* skip a region */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-k' requires an argument\n",
                                pname);
                        return 1;
                    }
                    vv = strchr(v, ',');
                    if (!vv) {
                        fprintf(stderr,
                                "%s: `-k' requires two numbers separated"
                                " by a comma\n", pname);
                        return 1;
                    }
                    *vv++ = '\0';
                    nextsync = readnum(v, &rn_error);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-k' requires numeric arguments\n",
                                pname);
                        return 1;
                    }
                    synclen = readnum(vv, &rn_error);
                    if (rn_error) {
                        fprintf(stderr,
                                "%s: `-k' requires numeric arguments\n",
                                pname);
                        return 1;
                    }
                    add_sync(nextsync, synclen);
                    p = "";     /* force to next argument */
                    break;
                case 'p':      /* preferred vendor */
                    v = p[1] ? p + 1 : --argc ? *++argv : NULL;
                    if (!v) {
                        fprintf(stderr, "%s: `-p' requires an argument\n",
                                pname);
                        return 1;
                    }
                    if (!strcmp(v, "intel")) {
                        iflag_clear_all(&prefer); /* default */
                    } else if (!strcmp(v, "amd")) {
                        iflag_clear_all(&prefer);
                        iflag_set(&prefer, IF_AMD);
                        iflag_set(&prefer, IF_3DNOW);
                    } else if (!strcmp(v, "cyrix")) {
                        iflag_clear_all(&prefer);
                        iflag_set(&prefer, IF_CYRIX);
                        iflag_set(&prefer, IF_3DNOW);
                    } else if (!strcmp(v, "idt") ||
                               !strcmp(v, "centaur") ||
                               !strcmp(v, "winchip")) {
                        iflag_clear_all(&prefer);
                        iflag_set(&prefer, IF_3DNOW);
                    } else {
                        fprintf(stderr,
                                "%s: unknown vendor `%s' specified with `-p'\n",
                                pname, v);
                        return 1;
                    }
                    p = "";     /* force to next argument */
                    break;
                default:       /*bf */
                    fprintf(stderr, "%s: unrecognised option `-%c'\n",
                            pname, *p);
                    return 1;
                }
        } else if (!filename) {
            filename = p;
        } else {
            fprintf(stderr, "%s: more than one filename specified\n",
                    pname);
            return 1;
        }
    }

    if (!filename) {
        usage();
        return 1;
    }

    if (strcmp(filename, "-")) {
        fp = fopen(filename, "rb");
        if (!fp) {
            fprintf(stderr, "%s: unable to open `%s': %s\n",
                    pname, filename, strerror(errno));
            return 1;
        }
    } else {
        nasm_set_binary_mode(stdin);
        fp = stdin;
    }

    reset_global_defaults(bits);

    fileoffs = 0;
    dataread = 0;
    if (!skip(&fileoffs, initskip, fp))
        return 1;               /* EOF before header */

    /*
     * This main loop is really horrible, and wants rewriting with
     * an axe. It'll stay the way it is for a while though, until I
     * find the energy...
     */

    q = p = buffer;
    nextsync = next_sync(offset, &synclen);
    lenread = 0;
    eof = false;

    while (lenread > 0 || (dataread < datamax && !eof && !feof(fp))) {
        size_t to_read = buffer + sizeof(buffer) - p;
	if ((nextsync || synclen) &&
	    to_read > nextsync - offset - (p - q))
            to_read = nextsync - offset - (p - q);
        if (to_read > datamax - dataread)
            to_read = datamax - dataread;

        lenread = 0;
        if (to_read) {
            lenread = fread(p, 1, to_read, fp);
            dataread += lenread;
            fileoffs += lenread;
            p += lenread;
            eof |= !lenread; /* help along systems with bad feof */
        }

        if ((nextsync || synclen) && offset == nextsync) {
            if (synclen) {
                fprintf(stdout, "%08"PRIX64"  skipping 0x%"PRIX64" bytes\n",
			offset, synclen);
                offset += synclen;
                dataread += synclen;
                eof |= skip(&fileoffs, synclen, fp);
            }
            q = p = buffer;
            nextsync = next_sync(offset, &synclen);
        }
        while (p > q && (p - q >= INSN_MAX || lenread == 0)) {
            size_t lendis = disasm(q, INSN_MAX, outbuf, sizeof(outbuf),
                                   bits, offset, autosync, &prefer);
            if (!lendis || q + lendis > p ||
                ((nextsync || synclen) && lendis > nextsync - offset))
                lendis = eatbyte(*q, outbuf, sizeof(outbuf), bits);
            output_ins(offset, q, lendis, outbuf);
            q += lendis;
            offset += lendis;
        }
        if (q >= buffer + INSN_MAX) {
            int count = p - q;
            memmove(buffer, q, count);
            p -= (q - buffer);
            q = buffer;
        }
    }

    if (fp != stdin)
        fclose(fp);

    return 0;
}

static void output_ins(uint64_t offset, const uint8_t *data,
                       int datalen, const char *insn)
{
    int bytes;
    int addrwidth;
    addrwidth = fprintf(stdout, "%08"PRIX64"  ", offset);

    bytes = 0;
    while (datalen > 0 && bytes < bpl) {
        fprintf(stdout, "%02X", *data++);
        bytes++;
        datalen--;
    }

    fprintf(stdout, "%*s  %s\n", (bpl - bytes) << 1, "", insn);

    while (datalen > 0) {
        fprintf(stdout, "%*s", addrwidth, "-");
        bytes = 0;
        while (datalen > 0 && bytes < bpl) {
            fprintf(stdout, "%02X", *data++);
            bytes++;
            datalen--;
        }
        putchar('\n');
    }
}

/*
 * Skip a certain amount of data in a file, either by seeking if
 * possible, or if that fails then by reading and discarding.
 * Returns true if successful, false on EOF; updates posp.
 */
static bool skip(off_t *posp, off_t dist, FILE *fp)
{
    if (!dist)
        return true;

    /*
     * Got to be careful with fseek: at least one fseek I've tried
     * doesn't approve of SEEK_CUR (WHICH ONE?). Weird...
     */
    if (!fseeko(fp, *posp + dist, SEEK_SET)) {
        *posp += dist;
    } else {
        off_t pos = ftello(fp);
        if (pos != (off_t)-1) {
            /* Possibly a partial seek? */
            dist -= (pos - *posp);
            *posp = pos;
        }

        while (dist > 0) {
            static char junk_buf[BUFSIZ];
            size_t len = sizeof junk_buf;
            size_t skipped;
            if (dist < (off_t)len)
                len = dist;
            skipped = fread(junk_buf, 1, len, fp);
            dist   -= skipped;
            *posp  += skipped;
            if (skipped < len)
                return false;   /* EOF */
        }
    }

    return true;
}
