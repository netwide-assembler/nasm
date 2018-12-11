/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2018 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

/*
 * strlist.c - list of unique, ordered strings
 */

#include "strlist.h"

/*
 * Create a string list
 */
struct strlist *strlist_alloc(void)
{
	struct strlist *list = nasm_zalloc(sizeof(*list));
	list->tailp = &list->head;
	return list;
}

/*
 * Append a string to a string list if and only if it isn't
 * already there.  Return true if it was added.
 */
bool strlist_add(struct strlist *list, const char *str)
{
	struct strlist_entry *e;
	struct hash_insert hi;
	size_t size;

	if (!list)
		return false;

	size = strlen(str) + 1;
	if (hash_findb(&list->hash, str, size, &hi))
		return false;

	/* Structure already has char[1] as EOS */
	e = nasm_zalloc(sizeof(*e) - 1 + size);
	e->size = size;
	memcpy(e->str, str, size);

	*list->tailp = e;
	list->tailp = &e->next;

	hash_add(&hi, e->str, (void *)e);
	return true;
}

/*
 * Free a string list
 */
void strlist_free(struct strlist *list)
{
	if (list) {
		hash_free_all(&list->hash, false);
		nasm_free(list);
	}
}
