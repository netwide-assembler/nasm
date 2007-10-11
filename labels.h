/* labels.h  header file for labels.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef LABELS_H
#define LABELS_H

extern char lprefix[PREFIX_MAX];
extern char lpostfix[PREFIX_MAX];

bool lookup_label(char *label, int32_t *segment, int32_t *offset);
bool is_extern(char *label);
void define_label(char *label, int32_t segment, int32_t offset, char *special,
		  bool is_norm, bool isextrn, struct ofmt *ofmt,
                  efunc error);
void redefine_label(char *label, int32_t segment, int32_t offset, char *special,
                    bool is_norm, bool isextrn, struct ofmt *ofmt,
                    efunc error);
void define_common(char *label, int32_t segment, int32_t size, char *special,
                   struct ofmt *ofmt, efunc error);
void declare_as_global(char *label, char *special, efunc error);
int init_labels(void);
void cleanup_labels(void);

#endif /* LABELS_H */
