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
 * already there. If it was added, return the entry pointer.
 */
const struct strlist_entry *strlist_add(struct strlist *list, const char *str)
{
	struct strlist_entry *e;
	struct hash_insert hi;
	size_t size;

	if (!list)
		return NULL;

	size = strlen(str) + 1;
	if (hash_findb(&list->hash, str, size, &hi))
		return NULL;

	/* Structure already has char[1] as EOS */
	e = nasm_malloc(sizeof(*e) - 1 + size);
	e->size = size;
        e->offset = list->size;
        e->next = NULL;
	memcpy(e->str, str, size);

	*list->tailp = e;
	list->tailp = &e->next;
	list->nstr++;
	list->size += size;

	hash_add(&hi, e->str, (void *)e);
	return e;
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

/*
 * Search the string list for an entry. If found, return the entry pointer.
 * (This is basically the opposite of strlist_add_string()!)
 */
const struct strlist_entry *
strlist_find(const struct strlist *list, const char *str)
{
	void **hf;
	hf = hash_find((struct hash_table *)&list->hash, str, NULL);
	return hf ? *hf : NULL;
}

/*
 * Produce a linearized buffer containing the whole list, in order;
 * The character "sep" is the separator between strings; this is
 * typically either 0 or '\n'. strlist_size() will give the size of
 * the returned buffer.
 */
void *strlist_linearize(const struct strlist *list, char sep)
{
	const struct strlist_entry *sl;
	char *buf = nasm_malloc(list->size);
	char *p = buf;
	
	strlist_for_each(sl, list) {
		p = mempcpy(p, sl->str, sl->size);
		p[-1] = sep;
	}
	
	return buf;
}
