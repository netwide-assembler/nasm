/* ndisasm.c   the Netwide Disassembler main module
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "insns.h"
#include "nasm.h"
#include "nasmlib.h"
#include "sync.h"
#include "disasm.h"

#define BPL 8			       /* bytes per line of hex dump */

static const char *help =
"usage: ndisasm [-a] [-i] [-h] [-r] [-u] [-b bits] [-o origin] [-s sync...]\n"
"               [-e bytes] [-k start,bytes] [-p vendor] file\n"
"   -a or -i activates auto (intelligent) sync\n"
"   -u sets USE32 (32-bit mode)\n"
"   -b 16 or -b 32 sets number of bits too\n"
"   -h displays this text\n"
"   -r displays the version number\n"
"   -e skips <bytes> bytes of header\n"
"   -k avoids disassembling <bytes> bytes from position <start>\n"
"   -p selects the preferred vendor instruction set (intel, amd, cyrix, idt)\n";

static void output_ins (unsigned long, unsigned char *, int, char *);
static void skip (unsigned long dist, FILE *fp);

int main(int argc, char **argv) 
{
    unsigned char buffer[INSN_MAX * 2], *p, *q;
    char outbuf[256];
    char *pname = *argv;
    char *filename = NULL;
    unsigned long nextsync, synclen, initskip = 0L;
    int lenread, lendis;
    int autosync = FALSE;
    int bits = 16;
    int eof = FALSE;
    unsigned long prefer = 0;
    int rn_error;
    long offset;
    FILE *fp;

    offset = 0;
    init_sync();

    while (--argc) {
	char *v, *vv, *p = *++argv;
	if (*p == '-' && p[1]) {
	    p++;
	    while (*p) switch (tolower(*p)) {
	      case 'a':		       /* auto or intelligent sync */
	      case 'i':
		autosync = TRUE;
		p++;
		break;
	      case 'h':
		fprintf(stderr, help);
		return 0;
	      case 'r':
		fprintf(stderr, "NDISASM version " NASM_VER "\n");
		return 0;
	      case 'u':		       /* USE32 */
		bits = 32;
		p++;
		break;
	      case 'b':		       /* bits */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-b' requires an argument\n", pname);
		    return 1;
		}
		if (!strcmp(v, "16"))
		    bits = 16;
		else if (!strcmp(v, "32"))
		    bits = 32;
		else {
		    fprintf(stderr, "%s: argument to `-b' should"
			    " be `16' or `32'\n", pname);
		}
		p = "";		       /* force to next argument */
		break;
	      case 'o':		       /* origin */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-o' requires an argument\n", pname);
		    return 1;
		}
		offset = readnum (v, &rn_error);
		if (rn_error) {
		    fprintf(stderr, "%s: `-o' requires a numeric argument\n",
			    pname);
		    return 1;
		}
		p = "";		       /* force to next argument */
		break;
	      case 's':		       /* sync point */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-s' requires an argument\n", pname);
		    return 1;
		}
		add_sync (readnum (v, &rn_error), 0L);
		if (rn_error) {
		    fprintf(stderr, "%s: `-s' requires a numeric argument\n",
			    pname);
		    return 1;
		}
		p = "";		       /* force to next argument */
		break;
	      case 'e':		       /* skip a header */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-e' requires an argument\n", pname);
		    return 1;
		}
		initskip = readnum (v, &rn_error);
		if (rn_error) {
		    fprintf(stderr, "%s: `-e' requires a numeric argument\n",
			    pname);
		    return 1;
		}
		p = "";		       /* force to next argument */
		break;
	      case 'k':		       /* skip a region */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-k' requires an argument\n", pname);
		    return 1;
		}
		vv = strchr(v, ',');
		if (!vv) {
		    fprintf(stderr, "%s: `-k' requires two numbers separated"
			    " by a comma\n", pname);
		    return 1;
		}
		*vv++ = '\0';
		nextsync = readnum (v, &rn_error);
		if (rn_error) {
		    fprintf(stderr, "%s: `-k' requires numeric arguments\n",
			    pname);
		    return 1;
		}
		synclen = readnum (vv, &rn_error);
		if (rn_error) {
		    fprintf(stderr, "%s: `-k' requires numeric arguments\n",
			    pname);
		    return 1;
		}
		add_sync (nextsync, synclen);
		p = "";		       /* force to next argument */
		break;
	    case 'p':		       /* preferred vendor */
		v = p[1] ? p+1 : --argc ? *++argv : NULL;
		if (!v) {
		    fprintf(stderr, "%s: `-p' requires an argument\n", pname);
		    return 1;
		}
		if ( !strcmp(v, "intel") ) {
		  prefer = 0;	/* Default */
		} else if ( !strcmp(v, "amd") ) {
		  prefer = IF_AMD|IF_3DNOW;
		} else if ( !strcmp(v, "cyrix") ) {
		  prefer = IF_CYRIX|IF_3DNOW;
		} else if ( !strcmp(v, "idt") || !strcmp(v, "centaur") ||
			    !strcmp(v, "winchip") ) {
		  prefer = IF_3DNOW;
		} else {
		  fprintf(stderr, "%s: unknown vendor `%s' specified with `-p'\n", pname, v);
		  return 1;
		}
		p = "";		       /* force to next argument */
		break;
	    }
	} else if (!filename) {
	    filename = p;
	} else {
	    fprintf(stderr, "%s: more than one filename specified\n", pname);
	    return 1;
	}
    }

    if (!filename) {
	fprintf(stderr, help, pname);
	return 0;
    }

    if (strcmp(filename, "-")) {
	fp = fopen(filename, "rb");
	if (!fp) {
	    fprintf(stderr, "%s: unable to open `%s': %s\n",
		    pname, filename, strerror(errno));
	    return 1;
	}
    } else
	fp = stdin;

    if (initskip > 0)
	skip (initskip, fp);

    /*
     * This main loop is really horrible, and wants rewriting with
     * an axe. It'll stay the way it is for a while though, until I
     * find the energy...
     */

    p = q = buffer;
    nextsync = next_sync (offset, &synclen);
    do {
	unsigned long to_read = buffer+sizeof(buffer)-p;
	if (to_read > nextsync-offset-(p-q))
	    to_read = nextsync-offset-(p-q);
	if (to_read) {
	    lenread = fread (p, 1, to_read, fp);
	    if (lenread == 0)
		eof = TRUE;	       /* help along systems with bad feof */
	} else
	    lenread = 0;
	p += lenread;
	if (offset == nextsync) {
	    if (synclen) {
		printf("%08lX  skipping 0x%lX bytes\n", offset, synclen);
		offset += synclen;
		skip (synclen, fp);
	    }
	    p = q = buffer;
	    nextsync = next_sync (offset, &synclen);
	}
	while (p > q && (p - q >= INSN_MAX || lenread == 0)) {
	    lendis = disasm (q, outbuf, bits, offset, autosync, prefer);
	    if (!lendis || lendis > (p - q) ||
		lendis > nextsync-offset)
		lendis = eatbyte (q, outbuf);
	    output_ins (offset, q, lendis, outbuf);
	    q += lendis;
	    offset += lendis;
	}
	if (q >= buffer+INSN_MAX) {
	    unsigned char *r = buffer, *s = q;
	    int count = p - q;
	    while (count--)
		*r++ = *s++;
	    p -= (q - buffer);
	    q = buffer;
	}
    } while (lenread > 0 || !(eof || feof(fp)));

    if (fp != stdin)
	fclose (fp);

    return 0;
}

static void output_ins (unsigned long offset, unsigned char *data,
			int datalen, char *insn) 
{
    int bytes;
    printf("%08lX  ", offset);

    bytes = 0;
    while (datalen > 0 && bytes < BPL) {
	printf("%02X", *data++);
	bytes++;
	datalen--;
    }

    printf("%*s%s\n", (BPL+1-bytes)*2, "", insn);

    while (datalen > 0) {
	printf("         -");
	bytes = 0;
	while (datalen > 0 && bytes < BPL) {
	    printf("%02X", *data++);
	    bytes++;
	    datalen--;
	}
	printf("\n");
    }
}

/*
 * Skip a certain amount of data in a file, either by seeking if
 * possible, or if that fails then by reading and discarding.
 */
static void skip (unsigned long dist, FILE *fp) 
{
    char buffer[256];		       /* should fit on most stacks :-) */

    /*
     * Got to be careful with fseek: at least one fseek I've tried
     * doesn't approve of SEEK_CUR. So I'll use SEEK_SET and
     * ftell... horrible but apparently necessary.
     */
    if (fseek (fp, dist+ftell(fp), SEEK_SET)) {
	while (dist > 0) {
	    unsigned long len = (dist < sizeof(buffer) ?
				 dist : sizeof(buffer));
	    if (fread (buffer, 1, len, fp) < len) {
		perror("fread");
		exit(1);
	    }
	    dist -= len;
	}
    }
}
