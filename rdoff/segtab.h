typedef void *segtab;

void init_seglocations(segtab * r);
void add_seglocation(segtab * r, int localseg, int destseg, long offset);
int get_seglocation(segtab * r, int localseg, int *destseg, long *offset);
void done_seglocations(segtab * r);
