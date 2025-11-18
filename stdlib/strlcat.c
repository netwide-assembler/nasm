/*
 * Copyright (c) 2019 Garmin Ltd. or its subsidiaries
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "compiler.h"

/*
 * Concatenate src string to dest of size size. The destination buffer will
 * have no more than size-1 character when the operation finishes. Always NUL
 * terminates, unless size == 0 or dest has no NUL terminator. Returns
 * strlen(initial dest) + strlen(src); if retval >= size, truncation occurred.
 */
#ifndef HAVE_STRLCAT

size_t strlcat(char *dest, const char *src, size_t size)
{
    size_t n;

    /* find the NULL terminator in dest */
    for (n = 0; n < size && dest[n] != '\0'; n++)
        ;

    /* destination was not NULL terminated. Return the initial size */
    if (n == size)
        return size;

    return strlcpy(&dest[n], src, size - n) + n;
}

#endif

