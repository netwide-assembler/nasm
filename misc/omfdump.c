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
#include <string.h>
#include <inttypes.h>
#include <ctype.h>
#include <stdbool.h>

typedef struct {
    uint16_t name_idx;
    uint16_t class_idx;
    uint16_t ovl_idx;
} segdef_t;

typedef struct {
    uint16_t name_idx;
} grpdef_t;

const char *progname;

static const char *record_types[256] =
{
    [0x80] = "THEADR",
    [0x82] = "LHEADR",
    [0x88] = "COMENT",
    [0x8a] = "MODEND16",
    [0x8b] = "MODEND32",
    [0x8c] = "EXTDEF",
    [0x8e] = "TYPDEF",
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

/* Ordered collection type */
struct collection {
    size_t n;                   /* Elements in collection (not including 0) */
    size_t s;                   /* Elements allocated (not including 0) */
    void const** p;                   /* Element pointers */
};

struct collection c_names, c_lsegs, c_groups, c_extsym;

static void nomem(void)
{
    fprintf(stderr, "%s: memory allocation error\n", progname);
    exit(1);
}


#define INIT_SIZE 64
static void add_collection(struct collection *c, const void *p)
{
    if (c->n >= c->s) {
        size_t cs = c->s ? (c->s << 1) : INIT_SIZE;
        void const **cp = realloc(c->p, cs*sizeof(const void *));

        if (!cp)
            nomem();

        c->p = cp;
        c->s = cs;
    }

    c->p[c->n] = p;
    c->n++;
}


static const void *get_collection(struct collection *c, size_t index)
{
    if (index == 0 || index > c->n)
        return NULL;

    return c->p[index-1];
}


static uint8_t *copy_name(size_t len, const uint8_t *data)
{
    uint8_t *r = malloc(len+1);
    if (!r) nomem();
    memcpy(r, data, len);
    r[len] = '\0';
    return r;
}


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


static void print_dostime(const uint8_t *p)
{
    uint16_t da = (p[3] << 8) + p[2];
    uint16_t ti = (p[1] << 8) + p[0];

    printf("%04u-%02u-%02u %02u:%02u:%02u",
           (da >> 9) + 1980, (da >> 5) & 15, da & 31,
           (ti >> 11), (ti >> 5) & 63, (ti << 1) & 63);
}


static void dump_coment_depfile(uint8_t type, const uint8_t *data, size_t n)
{
    (void)type;

    if (n > 4 && data[4] == n-5) {
        printf("   # ");
        print_dostime(data);
        printf("  %.*s\n", (int)(n-5), data+5);
    }

    hexdump_data(2, data, n, n);
}


static const dump_func dump_coment_class[256] = {
    [0xe9] = dump_coment_depfile
};


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
        [0xe3] = "Type definition",
        [0xe8] = "Filename",
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

    if (dump_coment_class[class])
        dump_coment_class[class](class, data+2, n-2);
    else
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


/* Returns a name as a C string in a newly allocated buffer */
const char *lname(int index)
{
    if (!index) return "''";
    return get_collection(&c_names, index);
}


const char *segment_name(uint16_t segment_idx)
{
    const segdef_t *seg;
    if (segment_idx == 0) return "";
    seg = get_collection(&c_lsegs, segment_idx);
    return lname(seg->name_idx);
}


const char *group_name(uint16_t group_idx)
{
    const grpdef_t *grp;
    if (group_idx == 0) return "";
    grp = get_collection(&c_groups, group_idx);
    return lname(grp->name_idx);
}


const char *external_name(uint16_t idx) {
    const char *name = get_collection(&c_extsym, idx);
    if (!name) return "";
    return name;
}


/* LNAMES or LLNAMES */
static void dump_lnames(uint8_t type, const uint8_t *data, size_t n)
{
    const uint8_t *p = data;
    const uint8_t *end = data + n;
    uint8_t *s;

    (void)type;

    while (p < end) {
        size_t l = *p;
        if (l > n) {
            s = malloc(n+1);
            memcpy(s, p+1, n);
            s[n] = '\0';
            add_collection(&c_names, s);
            printf("   # %4zu 0x%04zx: \"%.*s... <%zu missing bytes>\n",
                   c_names.n, c_names.n, (int)(n-1), p+1, l-n);
        } else {
            s = copy_name(l, p+1);
            add_collection(&c_names, s);

            printf("   [%04zx] '%s'\n",
                   c_names.n, s);
        }
        hexdump_data(p-data, p, l+1, n);
        p += l+1;
        n -= l+1;
    }
}


/* SEGDEF16 or SEGDEF32 */
static void dump_segdef(uint8_t type, const uint8_t *data, size_t n)
{
    bool big = type & 1;
    const uint8_t *p = data;
    const uint8_t *end = data+n;
    uint8_t attr;
    static const char * const alignment[8] =
        { "ABS", "BYTE", "WORD", "PARA", "PAGE", "DWORD", "LTL", "?ALIGN" };
    static const char * const combine[8] =
        { "PRIVATE", "?COMMON", "PUBLIC", "?COMBINE", "?PUBLIC", "STACK", "COMMON", "?PUBLIC" };
    const char *s;

    segdef_t *seg = malloc(sizeof(segdef_t));
    if (seg == NULL) {
        nomem();
    }

    if (p >= end)
        return;
    
    attr = *p++;

    printf("     %s (A%u) %s (C%u) %s%s",
           alignment[(attr >> 5) & 7], (attr >> 5) & 7,
           combine[(attr >> 2) & 7], (attr >> 2) & 7,
           (attr & 0x02) ? "MAXSIZE " : "",
           (attr & 0x01) ? "USE32" : "USE16");

    if (((attr >> 5) & 7) == 0) {
        /* Absolute segment */
        if (p+3 > end)
            goto dump;
        printf(" AT %04x:", get_16(&p));
        printf("%02x", *p++);
    }

    if (big) {
        if (p+4 > end)
            goto dump;
        printf(" size %08x", get_32(&p));
    } else {
        if (p+2 > end)
            goto dump;
        printf(" size %04x", get_16(&p));
    }
    puts("");

    seg->name_idx = get_index(&p);
    if (p > end)
        goto dump;
    s = lname(seg->name_idx);
    printf("     name '%s'", s);

    seg->class_idx = get_index(&p);
    if (p > end)
        goto dump;
    s = lname(seg->class_idx);
    if (*s) {
        printf(", class '%s'", s);        
    }

    seg->ovl_idx = get_index(&p);
    if (p > end)
        goto dump;
    s = lname(seg->ovl_idx);
    if (*s) {       /* s points to empty string if no overlay is given */
        printf(", ovl '%s'", s);      
    }

    add_collection(&c_lsegs, seg);

dump:
    putchar('\n');
    hexdump_data(0, data, n, n);
}


static void dump_grpdef(uint8_t type, const uint8_t *data, size_t n)
{
    const uint8_t *p = data;
    const uint8_t *end = data+n;
    const char *s;
    uint16_t name_idx;
    grpdef_t *grp;

    (void)type;

    grp = malloc(sizeof(grpdef_t));
    if (!grp) nomem();

    name_idx = get_index(&p);
    grp->name_idx = name_idx;

    if (p > end)
        goto dump;

    add_collection(&c_groups, grp);

    s = lname(name_idx);
    printf("     name '%s'\n", s);

    while ( p < end ) {
        if ( *p == 0xff ) {     /* segment */
            p++;
            printf("     segment '%s'\n", segment_name(get_index(&p)));
        }
        else if ( *p == 0xfe) {
            p++;
            name_idx = get_index(&p);
            s = lname(name_idx);
            printf("     external '%s'\n", s);
        }
        else goto dump;
    }

dump:
    hexdump_data(0, data, n, n);
}


static const char * const method_base[16] = {
    "SEGDEF", "GRPDEF", "EXTDEF", "frame#",
    "SEGDEF", "GRPDEF", "EXTDEF", "unsupported",
    "SEGDEF", "GRPDEF", "EXTDEF", "frame#",
    "prev. LEDATA SEG index", "TARGET index", "invalid", "unsupported"
};


static const char *location_descr[16] = {
    "low-order byte", "16-bit offset", "16-bit segment", "32-bit far ptr",
    "hi-order byte", "16-bit ldr-resolved offset", "reserved", "reserved",
    "unknown", "32-bit offset", "unknown", "48-bit ptr", "unknown",
    "32-bit ldr-resolved offset", "unknown", "unknown"
};


/* helper routine used in fixup and modend dumps */
static void dump_fixdat(bool big, const uint8_t **data)
{
    const uint8_t *p = *data;

    uint8_t fix;
    uint16_t idx;

    fix = *p++;

    /* frame decoding */
    printf("\n          frame %s%d%s",
           (fix & 0x80) ? "thread " : "method F",
           ((fix & 0x70) >> 4),
           ((fix & 0xc0) == 0xc0) ? "?" : "");
    if ((fix & 0x80) == 0)
        printf(" (%s)", method_base[((fix >> 4) & 7) + 8]);
    if ((fix & 0xc0) == 0) {
        idx = get_index(&p);
        printf(" index %04x", idx);
        if ((fix >> 4) == 0) {
            printf(" '%s'", segment_name(idx));                    
        }
        else if ((fix >> 4) == 1) {
            printf(" '%s'", group_name(idx));                      
        }
        else if ((fix >> 4) == 2) {
            printf(" '%s'", external_name(idx));                    
        }
    }
    
    /* target decoding */
    printf("\n          target %s%d",
           (fix & 0x08) ? "thread " : "method T",
           fix & 7);
    if ((fix & 0x08) == 0)
        printf(" (%s)", method_base[(fix & 7)]);
    if ((fix & 0x08) == 0) {
        idx = get_index(&p);         
        printf(" index %04x", idx);
        if ((fix & 3) == 0) {
            printf(" '%s'", segment_name(idx));
        }
        else if ((fix & 3) == 1) {
            printf(" '%s'", group_name(idx));                    
        }
        else if ((fix & 3) == 2) {
            printf(" '%s'", external_name(idx));
        }
    }
    if ((fix & 0x04) == 0) {
        if (big) {
            printf(" disp %08x", get_32(&p));
        } else {
            printf(" disp %04x", get_16(&p));
        }
    }
    putchar('\n');

    *data = p;
}


/* FIXUPP16 or FIXUPP32 */
static void dump_fixupp(uint8_t type, const uint8_t *data, size_t n)
{
    bool big = type & 1;
    const uint8_t *p = data;
    const uint8_t *end = data + n;

    while (p < end) {
        const uint8_t *start = p;
        uint8_t op = *p++;

        if (!(op & 0x80)) {
            /* THREAD record */
            bool frame = !!(op & 0x40);

            printf("   THREAD %-7s%d%s method %c%d (%s)",
                   frame ? "frame" : "target", op & 3,
                   (op & 0x20) ? " +flag5?" : "",
                   (op & 0x40) ? 'F' : 'T',
                   ((op & 0x1c) >> 2),
                   method_base[((op & 0x40) >> 3) | ((op & 0x1c) >> 2)]);

            if ((op & 0x50) != 0x50) {
                printf(" index %04x", get_index(&p));
            }
            putchar('\n');
        } else {
            /* FIXUP subrecord */
            printf("   FIXUP  %s-relative, type %d (%s)\n"
                   "          record offset %04x",
                   (op & 0x40) ? "segment" : "self",
                   (op & 0x3c) >> 2,
                   location_descr[(op & 0x3c) >> 2],
                   ((op & 3) << 8) + *p++);

            dump_fixdat(big, &p);
        }
        hexdump_data(start-data, start, p-start, n-(start-data));
    }
}


static void dump_ledata(uint8_t type, const uint8_t *data, size_t n)
{
    bool big = type & 1;
    const uint8_t *p = data;
    const segdef_t *seg = get_collection(&c_lsegs, get_index(&p));
    const char *seg_name = lname(seg->name_idx);
    size_t data_len;

    if (seg_name != NULL) {
        printf("                segment '%s', ", seg_name);
    }
    else {
        printf("                segment '(null)', ");
    }

    if (big) {
        printf("offset %08x\n", get_32(&p));
    }
    else {
        printf("offset %04x\n", get_16(&p));        
    }

    data_len = n - (p - data);
    hexdump_data(0, p, data_len, data_len);
}

static void dump_pubdef(uint8_t type, const uint8_t *data, size_t n)
{
    static int pub_names_count;
    bool big = type & 1;
    const uint8_t *p = data;
    const uint8_t *end = data + n;
    uint16_t grp_idx;
    uint16_t seg_idx;
    uint16_t type_idx;
    int name_len;

    grp_idx = get_index(&p);
    if (p > end) goto dump;

    seg_idx = get_index(&p);
    if (p > end) goto dump;

    if (grp_idx == 0 && seg_idx == 0) {
        printf("     frame %04x", get_16(&p));
    }
    else {
        printf("    ");
        if (seg_idx) {
            printf(" segment '%s'", segment_name(seg_idx));
        }
        if (grp_idx) {
            printf(" group '%s'", group_name(grp_idx));
        }
    }
    puts("");

    while (p < end) {
        pub_names_count++;

        name_len = *p++;
        printf("   [%04x] public name '%.*s' ", pub_names_count, name_len, p);
        p += name_len;

        if (big) {
            printf("offset %08x", get_32(&p));
        }
        else {
            printf("offset %04x", get_16(&p));        
        }        
        type_idx = get_index(&p);
        if (type_idx) {
            printf(", type %d", type_idx);
        }
        puts("");
    }

dump:
    hexdump_data(0, data, n, n);
}


static void dump_extdef(uint8_t type, const uint8_t *data, size_t n)
{
    static int ext_names_count;
    const uint8_t *p = data;
    const uint8_t *end = data + n;
    uint16_t type_idx;
    int name_len;
    uint8_t *name;

    (void)type;

    while (p < end) {
        ext_names_count++;
        name_len = *p++;
        name = copy_name(name_len, p);
        add_collection(&c_extsym, name);
        p += name_len;
        printf("   [%04x] external name '%s'", ext_names_count, name);        
        type_idx = get_index(&p);
        if (type_idx) {
            printf(", type %d", type_idx);
        }
        puts("");
    }

    hexdump_data(0, data, n, n);
}


static void dump_modend(uint8_t type, const uint8_t *data, size_t n)
{
    const uint8_t *p = data;
    
    if ( *p & 0x80 ) printf("     main module\n");
    if ( *p & 0x40 ) {
        printf("     start address:");
        p++;
        dump_fixdat( type & 1, &p );
    }
    hexdump_data(0, data, n, n);
}


static const dump_func dump_type[256] =
{
    [0x88] = dump_coment,
    [0x8a] = dump_modend,
    [0x8c] = dump_extdef,
    [0x90] = dump_pubdef,
    [0x91] = dump_pubdef,
    [0x96] = dump_lnames,
    [0x98] = dump_segdef,
    [0x99] = dump_segdef,
    [0x9a] = dump_grpdef,
    [0x9c] = dump_fixupp,
    [0x9d] = dump_fixupp,
    [0xa0] = dump_ledata,
    [0xa1] = dump_ledata,
    [0xca] = dump_lnames,
};


static uint8_t* read_file( FILE* f, size_t *sz ) {
   size_t size;
   uint8_t* buf;

   fseek( f, 0, SEEK_END );
   size = ftell( f );
   fseek( f, 0, SEEK_SET );

   buf = malloc( size );
   if ( !buf )
      return NULL;
   fread( buf, 1, size, f );
   *sz = size;

   return buf;
}


int dump_omf(FILE *f)
{
    size_t len, n;
    uint8_t type;
    const uint8_t *p, *data;

    data = read_file(f, &len);

    if (!data) return -1;

    p = data;
    while (len >= 3 && *p != 0x1a) {
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
            break;              /* Truncated */
        }

        p += 3;       /* Header doesn't count in the length */
        n--;          /* Remove checksum byte */

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

    free((void*)data);
    return 0;
}


int main(int argc, char *argv[])
{
    FILE *f;
    int i;

    progname = argv[0];

    if (argc < 2) {
        puts("OMFDUMP - dump contents of object module files to stdout\n");
        puts("Usage: OMFDUMP.EXE file...");
        return 0;
    }

    for (i = 1; i < argc; i++) {
        f = fopen(argv[i], "rb");
        if (f == NULL || dump_omf(f)) {
            perror(argv[i]);
            return 1;
        }
        fclose(f);
    }

    return 0;
}
