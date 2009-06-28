#include "nasm.h"
#include "nasmlib.h"

void null_debug_init(struct ofmt *of, void *id, FILE * fp, efunc error)
{
	(void)of;
	(void)id;
	(void)fp;
	(void)error;
}
void null_debug_linenum(const char *filename, int32_t linenumber, int32_t segto)
{
	(void)filename;
	(void)linenumber;
	(void)segto;
}
void null_debug_deflabel(char *name, int32_t segment, int64_t offset,
                         int is_global, char *special)
{
	(void)name;
	(void)segment;
	(void)offset;
	(void)is_global;
	(void)special;
}
void null_debug_routine(const char *directive, const char *params)
{
	(void)directive;
	(void)params;
}
void null_debug_typevalue(int32_t type)
{
	(void)type;
}
void null_debug_output(int type, void *param)
{
	(void)type;
	(void)param;
}
void null_debug_cleanup(void)
{
}

struct dfmt null_debug_form = {
    "Null debug format",
    "null",
    null_debug_init,
    null_debug_linenum,
    null_debug_deflabel,
    null_debug_routine,
    null_debug_typevalue,
    null_debug_output,
    null_debug_cleanup
};

struct dfmt *null_debug_arr[2] = { &null_debug_form, NULL };
