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

static void hexdump_data(unsigned int offset, const uint8_t *data, size_t n)
{
    unsigned int i, j;

    for (i = 0; i < n; i += 16) {
	printf("  %04x: ", i+offset);
	for (j = 0; j < 16; j++) {
	    if (i+j < n)
		printf("%02x%c", data[i+j], (j == 7) ? '-' : ' ');
	    else
		printf("   ");
	}
	printf(" :  ");
	for (j = 0; j < 16; j++) {
	    if (i+j < n)
		putchar(isprint(data[i+j]) ? data[i+j] : '.');
	}
	putchar('\n');
    }
}

static void dump_unknown(uint8_t type, const uint8_t *data, size_t n)
{
    (void)type;
    hexdump_data(0, data, n);
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
	dump_unknown(type, data, n);
	return;
    }

    type  = data[0];
    class = data[1];

    printf("  [NP=%d NL=%d UD=%02X] %02X %s\n",
	   (type >> 7) & 1,
	   (type >> 6) & 1,
	   type & 0x3f,
	   class,
	   coment_class[class] ? coment_class[class] : "???");

    hexdump_data(2, data+2, n-2);
}

static const dump_func dump_type[256] =
{
    [0x88] = dump_coment,
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
