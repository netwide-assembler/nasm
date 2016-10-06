/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2016 The NASM Authors - All Rights Reserved
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
 * output/legacy.c
 *
 * Mangle a struct out_data to match the rather bizarre legacy
 * backend interface.
 */

#include "nasm.h"
#include "outlib.h"

void nasm_do_legacy_output(const struct out_data *data)
{
    const void *dptr = data->data;
    enum out_type type = data->type;
    int32_t tsegment = data->tsegment;
    int32_t twrt = data->twrt;
    uint64_t size = data->size;

    switch (data->type) {
    case OUT_RELADDR:
        switch (data->size) {
        case 1:
            type = OUT_REL1ADR;
            break;
        case 2:
            type = OUT_REL2ADR;
            break;
        case 4:
            type = OUT_REL4ADR;
            break;
        case 8:
            type = OUT_REL8ADR;
            break;
        default:
            panic();
            break;
        }

        dptr = &data->toffset;
        size = data->inslen - data->insoffs;
        break;

    case OUT_SEGMENT:
        type = OUT_ADDRESS;
        /* fall through */

    case OUT_ADDRESS:
        dptr = &data->toffset;
        size = (data->sign == OUT_SIGNED) ? -data->size : data->size;
        break;

    case OUT_RAWDATA:
    case OUT_RESERVE:
        tsegment = twrt = NO_SEG;
        break;

    default:
        panic();
        break;
    }

    ofmt->legacy_output(data->segment, dptr, type, size, tsegment, twrt);
}
