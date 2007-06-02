/*
 * i32l64/inttypes.h
 *
 * Small subset of <inttypes.h>
 * for the short 16, int 32, long 64 model.
 */

#ifndef INTTYPES_H
#define INTTYPES_H

typedef signed char		int8_t;
typedef signed short		int16_t;
typedef signed int		int32_t;
typedef signed long		int64_t;

typedef unsigned char		uint8_t;
typedef unsigned short		uint16_t;
typedef unsigned int		uint32_t;
typedef unsigned long		uint64_t;

#define _scn8	"hh"
#define _scn16	"h"
#define _scn32	""
#define _scn64	"l"

#define _pri8	""
#define _pri16	""
#define _pri32	""
#define _pri64	"l"

#define INT8_C(x)	x
#define INT16_C(x)	x
#define INT32_C(x)	x
#define INT64_C(x)	x ## L

#define UINT8_C(x)	x ## U
#define UINT16_C(x)	x ## U
#define UINT32_C(x)	x ## U
#define UINT64_C(x)	x ## UL

/* The rest of this is common to all models */

#define PRId8		_pri8  "d"
#define PRId16		_pri16 "d"
#define PRId32		_pri32 "d"
#define PRId64		_pri64 "d"

#define PRIi8		_pri8  "i"
#define PRIi16		_pri16 "i"
#define PRIi32		_pri32 "i"
#define PRIi64		_pri64 "i"

#define PRIo8		_pri8  "o"
#define PRIo16		_pri16 "o"
#define PRIo32		_pri32 "o"
#define PRIo64		_pri64 "o"

#define PRIu8		_pri8  "u"
#define PRIu16		_pri16 "u"
#define PRIu32		_pri32 "u"
#define PRIu64		_pri64 "u"

#define PRIx8		_pri8  "x"
#define PRIx16		_pri16 "x"
#define PRIx32		_pri32 "x"
#define PRIx64		_pri64 "x"

#define PRIX8		_pri8  "X"
#define PRIX16		_pri16 "X"
#define PRIX32		_pri32 "X"
#define PRIX64		_pri64 "X"

#define SCNd8		_scn8  "d"
#define SCNd16		_scn16 "d"
#define SCNd32		_scn32 "d"
#define SCNd64		_scn64 "d"

#define SCNi8		_scn8  "i"
#define SCNi16		_scn16 "i"
#define SCNi32		_scn32 "i"
#define SCNi64		_scn64 "i"

#define SCNo8		_scn8  "o"
#define SCNo16		_scn16 "o"
#define SCNo32		_scn32 "o"
#define SCNo64		_scn64 "o"

#define SCNu8		_scn8  "u"
#define SCNu16		_scn16 "u"
#define SCNu32		_scn32 "u"
#define SCNu64		_scn64 "u"

#define SCNx8		_scn8  "x"
#define SCNx16		_scn16 "x"
#define SCNx32		_scn32 "x"
#define SCNx64		_scn64 "x"

#endif /* INTTYPES_H */
