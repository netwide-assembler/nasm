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
    unsigned long magic;        /* Must be RDLAMAG */
    unsigned long hdrsize;      /* Header size + sizeof(module_name) */
    unsigned long date;         /* Creation date */
    unsigned long owner;        /* UID */
    unsigned long group;        /* GID */
    unsigned long mode;         /* File mode */
    unsigned long size;         /* File size */
    /* NULL-terminated module name immediately follows */
};

#endif
