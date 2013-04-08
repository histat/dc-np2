
.macro GETPC8
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	mov.l	10000f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
.endm

.macro _GETPC8
	.align	2
10000:	.long	i286h_memoryread
.endm
	

.macro GETPC16
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	mov.l	10001f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	#((2 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
.endm

.macro _GETPC16
	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro GETR0
	mov.l	20000f,r3
	cmp/hs	r3,r4
	bt/s	6000f
	mov	r4,r0
	mov.b	@(r0,r1),r4
	mov	#(6001f - 6000f),r3
	braf	r3
	extu.b	r4,r0
6000:	
	mov.l	10000f,r3
	jsr	@r3
	nop
6001:
.endm

.macro _GETR0
	.align	2
20000:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread	
.endm

.macro GETPCF8
	mov.l	20000f,r3
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	cmp/hs	r3,r4
	bt	6002f
	mov	r4,r0
	mov.b	@(r0,r1),r4
	mov	#(6003f - 6002f),r3
	braf	r3
	extu.b	r4,r0
6002:
	mov.l	10000f,r3
	jsr	@r3
	nop
6003:
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
.endm
	
.macro _GETPCF8
	.align	2
20000:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread	
.endm
	
	

.macro GETPCF16
	mov.l	10001f,r3
	mov	r12,r4
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	#((2 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
.endm

.macro _GETPCF16
	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro R8SRC	op, out
	stc	gbr,r0
	mov	#3,\out
	mov	#(1 << 2),r3
	and	\op,\out
	tst	r3,\op
	mov	#1,r3
	shld	r3,\out
	bt/s	6004f
	add	r0,\out
	add	#1,\out
6004:
.endm


.macro R8DST	op, out
	stc	gbr,r0
	mov	#(6 << 2),\out
	mov	#(1 << 5),r3
	and	\op,\out
	tst	r3,\op
	shlr2	\out
	bt/s	6005f
	add	r0,\out
	add	#1,\out
6005:	
.endm

.macro EAREG8	src
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	stc	gbr,r4
	mov	#1,r3
	mov	#(6 << 2),\src
	shll16	r3
	and	r0,\src
	shlr2	\src
	add	r4,\src
	tst	#(1 << 5),r0
	bt/s	6006f
	add	r3,r12
	add	#1,\src
6006:
.endm

.macro _EAREG8
	_GETR0
.endm
	
	

.macro REG8EA	dst, regclk, memclk
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	mov	#1,r3
	mov	r0,r4
	shll16	r3
	add	r3,r12
	R8DST	r4, \dst
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	6007f
	CPUWORK	\regclk
	R8SRC	r4, r2
	mov.b	@r2,r4
	mov	#(6008f - 6007f),r3
	braf	r3
	extu.b	r4,r0
6007:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov.l	10000f,r3
	jsr	@r3
	mov	r0,r4
6008:
.endm

.macro _REG8EA
	_GETR0
10004:	.long	i286h_ea
10000:	.long	i286h_memoryread
.endm

.macro R16SRC	op, out
	stc	gbr,r0
	mov	#7,\out
	and	\op,\out
	shll	\out
	add	r0,\out
.endm

.macro R16DST	op, out
	stc	gbr,r0
	mov	#(7 << 3),\out
	and	\op,\out
	shlr2	\out
	add	r0,\out
.endm

.macro EAREG16	src
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	stc	gbr,r4
	mov	#1,r3
	mov	#(7 << 3),\src
	shll16	r3
	and	r0,\src
	add	r3,r12
	shlr2	\src
	add	r4,\src
.endm

.macro _EAREG16
	_GETR0
.endm

.macro REG16EA	dst, regclk, memclk
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	mov	r0,r4
	stc	gbr,r0
	mov	#1,r3
	mov	#(7 << 3),\dst
	shll16	r3
	and	r4,\dst
	add	r3,r12
	shlr2	\dst
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	6010f
	add	r0,\dst
	CPUWORK	\regclk
	R16SRC	r4, r2
	mov	#(6011f - 6010f),r3
	mov.w	@r2,r4
	braf	r3
	extu.w	r4,r0
6010:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
6011:	
.endm


.macro _REG16EA
	_GETR0
10004:	.long	i286h_ea
10001:	.long	i286h_memoryread_w	
.endm







	