/*
 * test source file for assembling to Microsoft 16-bit .OBJ
 * build with (16-bit Microsoft C):
 *    nasm -f obj objtest.asm
 *    cl /AL objtest.obj objlink.c
 * other compilers should work too, provided they handle large
 * model in the same way as MS C
 */

#include <stdio.h>

char text[] = "hello, world\n";

extern void function(char *);
extern int bsssym, commvar;
extern void *selfptr;
extern void *selfptr2;

int main(void)
{
    printf("these should be identical: %p, %p\n",
           (long)selfptr, (long)&selfptr);
    printf("these should be equivalent but different: %p, %p\n",
           (long)selfptr2, (long)&selfptr2);
    printf("you should see \"hello, world\" twice:\n");
    bsssym = 0xF00D;
    commvar = 0xD00F;
    function(text);
    printf("this should be 0xF00E: 0x%X\n", bsssym);
    printf("this should be 0xD00E: 0x%X\n", commvar);
    return 0;
}
