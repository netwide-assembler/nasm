/* labels.h  header file for labels.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

int lookup_label (char *label, long *segment, long *offset);
int is_extern (char *label);
void define_label (char *label, long segment, long offset, char *special,
		   int is_norm, int isextrn, struct ofmt *ofmt, efunc error);
void redefine_label (char *label, long segment, long offset, char *special,
		   int is_norm, int isextrn, struct ofmt *ofmt, efunc error);
void define_common (char *label, long segment, long size, char *special,
		    struct ofmt *ofmt, efunc error);
void declare_as_global (char *label, char *special, efunc error);
int init_labels (void);
void cleanup_labels (void);
