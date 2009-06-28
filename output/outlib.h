#ifndef NASM_OUTLIB_H
#define NASM_OUTLIB_H

#include "nasm.h"

uint64_t realsize(enum out_type type, uint64_t size);

/* Do-nothing versions of all the debug routines */
struct ofmt;
void null_debug_init(struct ofmt *of, void *id, FILE * fp, efunc error);
void null_debug_linenum(const char *filename, int32_t linenumber,
			int32_t segto);
void null_debug_deflabel(char *name, int32_t segment, int64_t offset,
                         int is_global, char *special);
void null_debug_routine(const char *directive, const char *params);
void null_debug_typevalue(int32_t type);
void null_debug_output(int type, void *param);
void null_debug_cleanup(void);
extern struct dfmt *null_debug_arr[2];

#endif /* NASM_OUTLIB_H */

