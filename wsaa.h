#ifndef NASM_WSAA_H
#define NASM_WSAA_H

#include "compiler.h"
#include "nasmlib.h"

#if X86_MEMORY

#define WSAACHAR(s,p,v)				\
    do {					\
	*(uint8_t *)(p) = (v);			\
	saa_wbytes(s, p, 1);			\
    } while (0)

#define WSAASHORT(s,p,v)			\
    do {					\
	*(uint16_t *)(p) = (v);			\
	saa_wbytes(s, p, 2);			\
    } while (0)

#define WSAALONG(s,p,v)				\
    do {					\
	*(uint32_t *)(p) = (v);			\
	saa_wbytes(s, p, 4);			\
    } while (0)

#define WSAADLONG(s,p,v)			\
    do {					\
	*(uint64_t *)(p) = (v);			\
	saa_wbytes(s, p, 8);			\
    } while (0)

#else /* !X86_MEMORY */

#define WSAACHAR(s,p,v) 			\
    do {					\
	*(uint8_t *)(p) = (v);			\
	saa_wbytes(s, p, 1);			\
    } while (0)

#define WSAASHORT(s,p,v) 			\
    do {					\
	uint16_t _wss_v = (v);			\
	uint8_t *_wss_p = (uint8_t *)(p);	\
	_wss_p[0] = _wss_v;			\
	_wss_p[1] = _wss_v >> 8;		\
	saa_wbytes(s, _wss_p, 2);		\
    } while (0)

#define WSAALONG(s,p,v)				\
    do {					\
	uint32_t _wsl_v = (v);			\
	uint8_t *_wsl_p = (uint8_t *)(p);	\
	_wsl_p[0] = _wsl_v;			\
	_wsl_p[1] = _wsl_v >> 8;		\
	_wsl_p[2] = _wsl_v >> 16;		\
	_wsl_p[3] = _wsl_v >> 24;		\
	saa_wbytes(s, _wsl_p, 4);		\
    } while (0)

#define WSAADLONG(s,p,v) 			\
    do {					\
	uint64_t _wsq_v = (v);			\
	uint8_t *_wsq_p = (uint8_t *)(p);	\
	_wsq_p[0] = _wsq_v;			\
	_wsq_p[1] = _wsq_v >> 8;		\
	_wsq_p[2] = _wsq_v >> 16;		\
	_wsq_p[3] = _wsq_v >> 24;		\
	_wsq_p[4] = _wsq_v >> 32;		\
	_wsq_p[5] = _wsq_v >> 40;		\
	_wsq_p[6] = _wsq_v >> 48;		\
	_wsq_p[7] = _wsq_v >> 56;		\
	saa_wbytes(s, _wsq_p, 8);		\
    } while (0)

#endif

#endif /* NASM_WSAA_H */
