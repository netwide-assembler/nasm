/******************************************************************************
   multboot.h - MultiBoot header definitions.
 ******************************************************************************/

#ifndef _MULTBOOT_H
#define _MULTBOOT_H

#define	MB_MAGIC	0x1BADB002

#define	MB_FL_PGALIGN	1			/* Align boot modules on page */
#define	MB_FL_MEMINFO	2			/* Must pass memory info to OS */
#define	MB_FL_KLUDGE	0x10000			/* a.out kludge present */

struct tMultiBootHeader {
    unsigned	Magic;
    unsigned	Flags;
    unsigned	Checksum;
    unsigned	HeaderAddr;
    unsigned	LoadAddr;
    unsigned	LoadEndAddr;
    unsigned	BSSendAddr;
    unsigned	Entry;
};

#define	MB_DEFAULTLOADADDR	0x110000	/* Default loading address */

#endif
