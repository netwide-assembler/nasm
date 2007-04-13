/* x86 running linux and using nasm as a.out */

#include <string.h>

#ifndef LCCDIR
#define LCCDIR "/usr/local/lib/lcc/"
#endif

#define NASMPATH "/usr/local/bin/nasm"

char *cpp[] = { LCCDIR "cpp", "-D__STDC__=1",
    "-Di386", "-D__i386", "-D__i386__",
    "-Dlinux", "-D__linux", "-D__linux__",
    "-Dunix", "-D__unix", "-D__unix__",
    "$1", "$2", "$3", 0
};
char *include[] = { "-I" LCCDIR "include", "-I/usr/local/include",
    "-I/usr/include", 0
};
char *com[] = { LCCDIR "rcc", "-target=x86/nasm",
    "$1", "$2", "$3", 0
};
char *as[] = { NASMPATH, "-a", "-faout", "-o", "$3", "$1", "$2", 0 };
char *ld[] = { "/usr/bin/ld", "-m", "i386linux",
    "-L/usr/i486-linuxaout/lib",
    "-o", "$3", "$1",
    "/usr/i486-linuxaout/lib/crt0.o",
    "$2", "", "-lc", 0
};
static char *bbexit = LCCDIR "bbexit.o";

extern char *concat(char *, char *);
extern int access(const char *, int);

int option(char *arg)
{
    if (strncmp(arg, "-lccdir=", 8) == 0) {
        cpp[0] = concat(&arg[8], "/cpp");
        include[0] = concat("-I", concat(&arg[8], "/include"));
        com[0] = concat(&arg[8], "/rcc");
        bbexit = concat(&arg[8], "/bbexit.o");
    } else if (strcmp(arg, "-g") == 0) ;
    else if (strcmp(arg, "-b") == 0 && access(bbexit, 4) == 0)
        ld[9] = bbexit;
    else
        return 0;
    return 1;
}
