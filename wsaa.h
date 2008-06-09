#ifndef NASM_WSAA_H
#define NASM_WSAA_H

#include "compiler.h"
#include "nasmlib.h"

void saa_write8(struct SAA *s, uint8_t v);
void saa_write16(struct SAA *s, uint16_t v);
void saa_write32(struct SAA *s, uint32_t v);
void saa_write64(struct SAA *s, uint64_t v);

#endif /* wsaa.h */
