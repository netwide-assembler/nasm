/* labels.h  header file for labels.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

extern int8_t lprefix[PREFIX_MAX];
extern int8_t lpostfix[PREFIX_MAX];

int lookup_label(int8_t *label, int32_t *segment, int32_t *offset);
int is_extern(int8_t *label);
void define_label(int8_t *label, int32_t segment, int32_t offset, int8_t *special,
                  int is_norm, int isextrn, struct ofmt *ofmt,
                  efunc error);
void redefine_label(int8_t *label, int32_t segment, int32_t offset, int8_t *special,
                    int is_norm, int isextrn, struct ofmt *ofmt,
                    efunc error);
void define_common(int8_t *label, int32_t segment, int32_t size, int8_t *special,
                   struct ofmt *ofmt, efunc error);
void declare_as_global(int8_t *label, int8_t *special, efunc error);
int init_labels(void);
void cleanup_labels(void);
