/*
 * omfdump.c
 *
 * Very simple program to dump the contents of an OMF (OBJ) file
 *
 * This assumes a littleendian, unaligned-load-capable host and a
 * C compiler which handles basic C99.
 */

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>

const char *progname;

static const char *record_types[256] =
{
    [0x80] = "THEADR",
    [0x82] = "LHEADR",
    [0x88] = "COMENT",
    [0x8a] = "MODEND16",
    [0x8b] = "MODEND32",
    [0x8c] = "EXTDEF",
    [0x90] = "PUBDEF16",
    [0x91] = "PUBDEF32",
    [0x94] = "LINNUM16",
    [0x95] = "LINNUM32",
    [0x96] = "LNAMES",
    [0x98] = "SEGDEF16",
    [0x99] = "SEGDEF32",
    [0x9a] = "GRPDEF",
    [0x9c] = "FIXUPP16",
    [0x9d] = "FIXUPP32",
    [0xa0] = "LEDATA16",
    [0xa1] = "LEDATA32",
    [0xa2] = "LIDATA16",
    [0xa3] = "LIDATA32",
    [0xb0] = "COMDEF",
    [0xb2] = "BAKPAT16",
    [0xb3] = "BAKPAT32",
    [0xb4] = "LEXTDEF",
    [0xb6] = "LPUBDEF16",
    [0xb7] = "LPUBDEF32",
    [0xb8] = "LCOMDEF",
    [0xbc] = "CEXTDEF",
    [0xc2] = "COMDAT16",
    [0xc3] = "COMDAT32",
    [0xc4] = "LINSYM16",
    [0xc5] = "LINSYM32",
    [0xc6] = "ALIAS",
    [0xc8] = "NBKPAT16",
    [0xc9] = "NBKPAT32",
    [0xca] = "LLNAMES",
    [0xcc] = "VERNUM",
    [0xce] = "VENDEXT",
    [0xf0] = "LIBHDR",
    [0xf1] = "LIBEND",
};

typedef void (*dump_func)(uint8_t, const uint8_t *, size_t);

static void hexdump_data(unsigned int offset, const uint8_t *data,
                         size_t n, size_t field)
{
    unsigned int i, j;

    for (i = 0; i < n; i += 16) {
	printf("   %04x: ", i+offset);
	for (j = 0; j < 16; j++) {
            char sep = (j == 7) ? '-' : ' ';
	    if (i+j < field)
		printf("%02x%c", data[i+j], sep);
	    else if (i+j < n)
                printf("xx%c", sep); /* Beyond end of... */
            else
		printf("   ");  /* No separator */
	}
	printf(" :  ");
	for (j = 0; j < 16; j++) {
            if (i+j < n)
                putchar((i+j >= field) ? 'x' :
                        isprint(data[i+j]) ? data[i+j] : '.');
	}
	putchar('\n');
    }
}

static void dump_unknown(uint8_t type, const uint8_t *data, size_t n)
{
    (void)type;
    hexdump_data(0, data, n, n);
}

static void dump_coment(uint8_t type, const uint8_t *data, size_t n)
{
    uint8_t class;
    static const char *coment_class[256] = {
	[0x00] = "Translator",
	[0x01] = "Copyright",
	[0x81] = "Library specifier",
	[0x9c] = "MS-DOS version",
	[0x9d] = "Memory model",
	[0x9e] = "DOSSEG",
	[0x9f] = "Library search",
	[0xa0] = "OMF extensions",
	[0xa1] = "New OMF extension",
	[0xa2] = "Link pass separator",
	[0xa3] = "LIBMOD",
	[0xa4] = "EXESTR",
	[0xa6] = "INCERR",
	[0xa7] = "NOPAD",
	[0xa8] = "WKEXT",
	[0xa9] = "LZEXT",
	[0xda] = "Comment",
	[0xdb] = "Compiler",
	[0xdc] = "Date",
	[0xdd] = "Timestamp",
	[0xdf] = "User",
	[0xe9] = "Dependency file",
	[0xff] = "Command line"
    };

    if (n < 2) {
	hexdump_data(type, data, 2, n);
	return;
    }

    type  = data[0];
    class = data[1];

    printf("   [NP=%d NL=%d UD=%02X] %02X %s\n",
	   (type >> 7) & 1,
	   (type >> 6) & 1,
	   type & 0x3f,
	   class,
	   coment_class[class] ? coment_class[class] : "???");

    hexdump_data(2, data+2, n-2, n-2);
}

/* Parse an index field */
static uint16_t get_index(const uint8_t **pp)
{
    uint8_t c;

    c = *(*pp)++;
    if (c & 0x80) {
        return ((c & 0x7f) << 8) + *(*pp)++;
    } else {
        return c;
    }
}

static uint16_t get_16(const uint8_t **pp)
{
    uint16_t v = *(const uint16_t *)(*pp);
    (*pp) += 2;

    return v;
}

static uint32_t get_32(const uint8_t **pp)
{
    const uint32_t v = *(const uint32_t *)(*pp);
    (*pp) += 4;

    return v;
}

/* LNAMES or LLNAMES */
static void dump_lnames(uint8_t type, const uint8_t *data, size_t n)
{
    const uint8_t *p = data;
    const uint8_t *end = data + n;
    int i = 0;

    while (p < end) {
        size_t l = *p+1;
        if (l > n) {
            printf("   # 0x%04x: \"%.*s... <%zu missing bytes>\n",
                   ++i, n-1, p+1, l-n);
        } else {
            printf("   # 0x%04x: \"%.*s\"\n", ++i, l-1, p+1);
        }
        hexdump_data(p-data, p, l, n);
        p += l;
        n -= l;
    }
}

/* FIXUPP16 or FIXUPP32 */
static void dump_fixupp(uint8_t type, const uint8_t *data, size_t n)
{
    bool big = type & 1;
    unsigned int size = type == 0x9d ? 4 : 2;
    const uint8_t *p = data;
    const uint8_t *end = data + n;
    static const char * const method_base[4] =
        { "SEGDEF", "GRPDEF", "EXTDEF", "frame#" };

    while (p < end) {
        const uint8_t *start = p;
        uint8_t op = *p++;
        uint16_t index;
        uint32_t disp;

        if (!(op & 0x80)) {
            /* THREAD record */
            bool frame = !!(op & 0x40);

            printf("   THREAD %-7s%d%s method %c%d (%s)",
                   frame ? "frame" : "target", op & 3,
                   (op & 0x20) ? " +flag5?" : "",
                   (op & 0x40) ? 'F' : 'T',
                   op & 3, method_base[op & 3]);

            if ((op & 0x50) != 0x50) {
                printf(" index 0x%04x", get_index(&p));
            }
            putchar('\n');
        } else {
            /* FIXUP subrecord */
            uint8_t fix;

            printf("   FIXUP  %s-rel location %2d offset 0x%03x",
                   (op & 0x40) ? "seg" : "self",
                   (op & 0x3c) >> 2,
                   ((op & 3) << 8) + *p++);

            fix = *p++;
            printf("\n          frame %s%d%s",
                   (fix & 0x80) ? "thread " : "F",
                   ((fix & 0x70) >> 4),
                   ((fix & 0xc0) == 0xc0) ? "?" : "");

            if ((fix & 0xc0) == 0)
                printf(" datum 0x%04x", get_index(&p));

            printf("\n          target %s%d",
                   (fix & 0x10) ? "thread " : "method T",
                   fix & 3);

            if ((fix & 0x10) == 0)
                printf(" (%s)", method_base[fix & 3]);

            printf(" datum 0x%04x", get_index(&p));

            if ((fix & 0x08) == 0) {
                if (big) {
                    printf(" disp 0x%08x", get_32(&p));
                } else {
                    printf(" disp 0x%04x", get_16(&p));
                }
            }
            putchar('\n');
        }
        hexdump_data(start-data, start, p-start, n-(start-data));
    }
}

static const dump_func dump_type[256] =
{
    [0x88] = dump_coment,
    [0x96] = dump_lnames,
    [0x9c] = dump_fixupp,
    [0x9d] = dump_fixupp,
    [0xca] = dump_lnames,
};

int dump_omf(int fd)
{
    struct stat st;
    size_t len, n;
    uint8_t type;
    const uint8_t *p, *data;

    if (fstat(fd, &st))
	return -1;

    len = st.st_size;

    data = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);
    if (data == MAP_FAILED)
	return -1;

    p = data;
    while (len >= 3) {
	uint8_t csum;
	int i;

	type = p[0];
	n = *(uint16_t *)(p+1);

	printf("%02x %-10s %4zd bytes",
	       type,
	       record_types[type] ? record_types[type] : "???",
	       n);

	if (len < n+3) {
	    printf("\n  (truncated, only %zd bytes left)\n", len-3);
	    break;		/* Truncated */
	}

	p += 3;	      /* Header doesn't count in the length */
	n--;	      /* Remove checksum byte */

	csum = 0;
	for (i = -3; i < (int)n; i++)
	    csum -= p[i];

	printf(", checksum %02X", p[i]);
	if (csum == p[i])
	    printf(" (valid)\n");
	else
	    printf(" (actual = %02X)\n", csum);

	if (dump_type[type])
	    dump_type[type](type, p, n);
	else
	    dump_unknown(type, p, n);

	p   += n+1;
	len -= (n+4);
    }

    munmap((void *)data, st.st_size);
    return 0;
}

int main(int argc, char *argv[])
{
    int fd;
    int i;

    progname = argv[0];

    for (i = 1; i < argc; i++) {
	fd = open(argv[i], O_RDONLY);
	if (fd < 0 || dump_omf(fd)) {
	    perror(argv[i]);
	    return 1;
	}
	close(fd);
    }

    return 0;
}
