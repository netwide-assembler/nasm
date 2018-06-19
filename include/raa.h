/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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

#ifndef NASM_RAA_H
#define NASM_RAA_H 1

#include "compiler.h"

struct real_raa;
struct RAA;
union intorptr {
    int64_t i;
    void *p;
};

struct real_raa * never_null real_raa_init(void);
static inline struct RAA *never_null raa_init(void)
{
    return (struct RAA *)real_raa_init();
}
static inline struct RAAPTR *never_null raa_init_ptr(void)
{
    return (struct RAAPTR *)real_raa_init();
}
void real_raa_free(struct real_raa *);
static inline void raa_free(struct RAA *raa)
{
   real_raa_free((struct real_raa *)raa);
}
static inline void raa_free_ptr(struct RAAPTR *raa)
{
    real_raa_free((struct real_raa *)raa);
}
int64_t raa_read(struct RAA *, int32_t);
void *raa_read_ptr(struct RAAPTR *, int32_t);
struct real_raa * never_null
real_raa_write(struct real_raa *r, int32_t posn, union intorptr value);

static inline struct RAA * never_null
raa_write(struct RAA *r, int32_t posn, int64_t value)
{
    union intorptr ip;

    ip.i = value;
    return (struct RAA *)real_raa_write((struct real_raa *)r, posn, ip);
}

static inline struct RAAPTR * never_null
raa_write_ptr(struct RAAPTR *r, int32_t posn, void *value)
{
    union intorptr ip;

    ip.p = value;
    return (struct RAAPTR *)real_raa_write((struct real_raa *)r, posn, ip);
}

#endif                          /* NASM_RAA_H */
