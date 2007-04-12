/*
 * rdlar.h - definitions of new RDOFF library/archive format.
 */

#ifndef _RDLAR_H
#define _RDLAR_H

#ifndef _POSIX_SOURCE
/* For some MS-DOS C compilers */
#define getuid() 0
#define getgid() 0
#endif

#define RDLAMAG		0x414C4452      /* Archive magic */
#define RDLMMAG		0x4D4C4452      /* Member magic */

#define MAXMODNAMELEN	256     /* Maximum length of module name */

struct rdlm_hdr {
    uint32_t magic;        /* Must be RDLAMAG */
    uint32_t hdrsize;      /* Header size + sizeof(module_name) */
    uint32_t date;         /* Creation date */
    uint32_t owner;        /* UID */
    uint32_t group;        /* GID */
    uint32_t mode;         /* File mode */
    uint32_t size;         /* File size */
    /* NULL-terminated module name immediately follows */
};

#endif
