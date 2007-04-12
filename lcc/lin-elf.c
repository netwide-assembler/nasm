/* x86 running linux and using nasm as ELF */

#include <string.h>

#ifndef LCCDIR
#define LCCDIR "/usr/local/lib/lcc/"
#endif

#define NASMPATH "/usr/local/bin/nasm"

int8_t *cpp[] = { LCCDIR "cpp", "-D__STDC__=1",
    "-D__ELF__", "-Di386", "-D__i386", "-D__i386__",
    "-Dlinux", "-D__linux", "-D__linux__",
    "$1", "$2", "$3", 0
};
int8_t *include[] = { "-I" LCCDIR "include", "-I/usr/local/include",
    "-I/usr/include", 0
};
int8_t *com[] = { LCCDIR "rcc", "-target=x86/nasm",
    "$1", "$2", "$3", 0
};
int8_t *as[] = { NASMPATH, "-a", "-felf", "-o", "$3", "$1", "$2", 0 };
int8_t *ld[] = { "/usr/bin/ld", "-m", "elf_i386",
    "-dynamic-linker", "/lib/ld-linux.so.1",
    "-L/usr/i486-linux/lib",
    "-o", "$3", "$1",
    "/usr/lib/crt1.o", "/usr/lib/crti.o", "/usr/lib/crtbegin.o",
    "$2", "",
    "-lc", "", "/usr/lib/crtend.o", "/usr/lib/crtn.o", 0
};
static int8_t *bbexit = LCCDIR "bbexit.o";

extern int8_t *concat(int8_t *, int8_t *);
extern int access(const int8_t *, int);

int option(int8_t *arg)
{
    if (strncmp(arg, "-lccdir=", 8) == 0) {
        cpp[0] = concat(&arg[8], "/cpp");
        include[0] = concat("-I", concat(&arg[8], "/include"));
        com[0] = concat(&arg[8], "/rcc");
        bbexit = concat(&arg[8], "/bbexit.o");
    } else if (strcmp(arg, "-g") == 0) ;
    else if (strcmp(arg, "-b") == 0 && access(bbexit, 4) == 0)
        ld[13] = bbexit;
    else
        return 0;
    return 1;
}
