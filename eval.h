/* eval.h   header file for eval.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_EVAL_H
#define NASM_EVAL_H

/*
 * Called once to tell the evaluator what output format is
 * providing segment-base details, and what function can be used to
 * look labels up.
 */
void eval_global_info (struct ofmt *output, lfunc lookup_label, loc_t *locp);

/*
 * The evaluator itself.
 */
expr *evaluate (scanner sc, void *scprivate, struct tokenval *tv,
		int *fwref, int critical, efunc report_error,
		struct eval_hints *hints);

void eval_cleanup(void);

#endif
