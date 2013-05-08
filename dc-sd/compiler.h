#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ronin/common.h>
#include <ronin/report.h>
#include "ff.h"
#include "dccore.h"

#define __SDCARD__

#define	BYTESEX_LITTLE
#define	OSLANG_SJIS
#define	OSLINEBREAK_CRLF

typedef signed int	SINT;
//typedef	unsigned int	UINT;
typedef signed char	SINT8;
typedef unsigned char	UINT8;
typedef	signed short	SINT16;
typedef	unsigned short	UINT16;
typedef	signed int	SINT32;
typedef	unsigned int	UINT32;
typedef signed long long	SINT64;
typedef unsigned long long	UINT64;

#include "integer.h"

#define	INLINE		inline

#ifndef	max
#define	max(a,b)	(((a) > (b)) ? (a) : (b))
#endif
#ifndef	min
#define	min(a,b)	(((a) < (b)) ? (a) : (b))
#endif

#ifndef	ZeroMemory
#define	ZeroMemory(d,n)		memset((d), 0, (n))
#endif
#ifndef	CopyMemory
#define	CopyMemory(d,s,n)	memcpy((d),(s),(n))
#endif
#ifndef	FillMemory
#define	FillMemory(a, b, c)	memset((a),(c),(b))
#endif

#define	TRUE	1
#define	FALSE	0

#define	MAX_PATH	255

#define	BRESULT				UINT
#define	OEMCHAR				char
#define	OEMTEXT(string)		string
#define	OEMSPRINTF			sprintf
#define	OEMSTRLEN			strlen

#include "common.h"
#include "milstr.h"
#include "_memory.h"
#include "rect.h"
#include "lstarray.h"
#include "trace.h"

#define	GETTICK()			dccore_gettick()
#define	__ASSERT(s)
#define	SPRINTF				sprintf
#define	STRLEN				strlen
#define Sleep(ms)

// FIXME: this allows assembler sound even on sh4 assembler
#define	OPNGENARM

#define	SUPPORT_8BPP
//#define	SUPPORT_16BPP
#define	MEMOPTIMIZE 	2


#if defined(OSLANG_SJIS)
#define	SUPPORT_SJIS
#elif defined(OSLANG_UTF8)
#define	SUPPORT_UTF8
#else
#define	SUPPORT_ANK
#endif

#define	SUPPORT_HOSTDRV
//#define VERMOUTH_LIB
#define SUPPORT_CRT15KHZ
#define SUPPORT_SWSEEKSND

#define CPUSTRUC_MEMWAIT
