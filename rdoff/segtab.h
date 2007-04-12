#ifndef RDOFF_SEGTAB_H
#define RDOFF_SEGTAB_H 1

#include <inttypes.h>

typedef void *segtab;

void init_seglocations(segtab * r);
void add_seglocation(segtab * r, int localseg, int destseg, int32_t offset);
int get_seglocation(segtab * r, int localseg, int *destseg, int32_t *offset);
void done_seglocations(segtab * r);

#endif
