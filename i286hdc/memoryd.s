
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hmem.inc"

	.extern	memfn
	.extern	_i286hcore
	.extern	i286_nonram_r
	.extern	i286_nonram_rw

	.globl	_memp_read8
	.globl	_memp_read16
	.globl	_memp_write8
	.globl	_memp_write16

	.globl	_memr_read8
	.globl	_memr_read16
	.globl	_memr_write8
	.globl	_memr_write16

	.globl	i286h_memoryread
	.globl	i286h_memoryread_w
	.globl	i286h_memorywrite
	.globl	i286h_memorywrite_w

	.text
	.align	2

_memr_read8:
	mov	#4,r3
	extu.w	r5,r5
	shld	r3,r4
	add	r5,r4	
_memp_read8:
	mov.l	200f,r0
	mov.l	201f,r3
	ldc	r0,gbr
	mov.l	202f,r1
	cmp/hs	r3,r4
	bt/s	i2mr_ext
	mov	r4,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0

	.align	2
200:	.long	_i286hcore
201:	.long	I286_MEMREADMAX
202:	.long	_i286hcore + CPU_SIZE
i2mr_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2mr_himem
	mov	#-(15 - 2),r3
	mov.l	r11,@-r15		
	sts.l	pr,@-r15
	mov.l	i2mr_memfnrd8,r6
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r6
	mov.l	@(CPU_REMAINCLOCK,gbr),r0
	jsr	@r6
	mov	r0,r11
	mov	r0,r4
	mov	r11,r0
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
	rts
	mov	r4,r0

	.align	2
200:	.long	USE_HIMEM
i2mr_memfnrd8:	.long	memfn
i2mr_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bt/s	1f
	mov	#0xff,r3
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov.b	@(r0,r4),r4
	rts
	extu.b	r4,r0
1:
	rts
	extu.b	r3,r0

_memr_read16:
	mov	#4,r3
	extu.w	r5,r5
	shld	r3,r4
	add	r5,r4
_memp_read16:
	mov.l	200f,r0
	mov.l	201f,r3
	ldc	r0,gbr
	mov.l	202f,r1
	mov	r4,r0
	tst	#1,r0
	bf/s	i2mro_main
	cmp/hs	r3,r4
	bt/s	i2mre_ext
	mov	r4,r0
	mov.w	@(r0,r1),r4
	rts
	extu.w	r4,r0

	.align	2
200:	.long	_i286hcore
201:	.long	I286_MEMREADMAX
202:	.long	_i286hcore + CPU_SIZE
i2mre_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt	i2mre_himem
i2mrw_ext:
	mov.l	r11,@-r15		
	sts.l	pr,@-r15
	mov.l	i2mre_memfnrd16,r2
	mov	#-(15 - 2),r3
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r2),r6
	mov.l	@(CPU_REMAINCLOCK,gbr),r0
	jsr	@r6
	mov	r0,r11
	mov	r0,r4
	mov	r11,r0
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
	rts
	mov	r4,r0

	.align	2
200:	.long	USE_HIMEM
i2mre_memfnrd16:	.long		memfn + (32 * 4) * 2
i2mre_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bt/s	1f
	mov	#0xff,r3
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov.w	@(r0,r4),r4
	rts
	extu.w	r4,r0
1:
	rts
	extu.w	r3,r0
i2mro_main:
	mov	r4,r5
	mov.l	200f,r3
	add	#1,r5
	cmp/hs	r3,r5
	bt/s	i2mro_ext
	mov	r4,r0
	add	r1,r4
	mov.b	@r4+,r0
	mov.b	@r4,r5
	extu.b	r0,r0
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
	
	.align	2
200:	.long	I286_MEMREADMAX
i2mro_ext:
	mov.l	200f,r3
	cmp/hs	r3,r5
	bt/s	i2mro_himem
	cmp/eq	r3,r5
	mov	#(32 - 15),r3
	shld	r3,r5
	tst	r5,r5
	bf/s	i2mrw_ext
	mov	r4,r0
	mov	#-(15 - 2),r3
	mov.l	r8,@-r15		! ここチェックするように…
	mov.l	r9,@-r15
	shld	r3,r0
	mov.l	r10,@-r15
	mov.l	i2mro_memfnrd8,r8
	mov.l	r11,@-r15
	and	#(0x1f << 2),r0
	sts.l	pr,@-r15
	mov.l	@(r0,r8),r6
	mov	r4,r9
	CPULDC
	jsr	@r6
	add	#1,r9
	mov	r0,r10
	mov	#-(15 - 2),r3
	mov	r9,r0
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r8),r6
	jsr	@r6
	mov	r9,r4
	mov	r0,r4
	shll8	r4
	add	r10,r4
	CPUSVC
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	mov	r4,r0
	rts
	mov.l	@r15+,r8
	
	.align	2
i2mro_memfnrd8:	.long		memfn
200:	.long	USE_HIMEM	
i2mro_himem:
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov	#(0x100000 >> 16),r3
	mov	r0,r6
	shll16	r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	sub	r3,r5
	mov	r0,r2
	bt/s	i2mro_10ffff			! = 10ffff
	add	r5,r6
	cmp/hs	r2,r5
	bt/s	i2mro_himeml			! = over
	cmp/eq	r2,r5
	add	#-1,r6
	mov.b	@r6+,r4
	mov.b	@r6,r5
	extu.b	r4,r0
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
i2mro_10ffff:
	add	r1,r4
	mov.b	@r4,r4
	cmp/hs	r2,r5
	bt/s	i2mro_himemh
	extu.b	r4,r0
	mov.b	@r6,r5
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
i2mro_himeml:
	bf/s	1f
	add	#-1,r6
	mov.b	@r6+,r4
	extu.b	r4,r0
i2mro_himemh:
	swap.b	r0,r0
	or	#(0xff00 >> 8),r0
	rts
	swap.b	r0,r0
1:
	mov	#0xff,r4
	bra	i2mro_himemh
	extu.b	r4,r0

_memr_write8:
	mov	#4,r3
	extu.w	r5,r5
	shld	r3,r4
	add	r5,r4
	mov	r6,r5
_memp_write8:
	mov.l	200f,r0
	mov.l	201f,r3
	ldc	r0,gbr
	mov.l	202f,r1
	cmp/hs	r3,r4
	bt/s	i2mw_ext
	mov	r4,r0
	rts
	mov.b	r5,@(r0,r1)

	.align	2
200:	.long	_i286hcore
201:	.long	I286_MEMWRITEMAX
202:	.long	_i286hcore + CPU_SIZE
i2mw_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2mw_himem
	mov	#-(15 - 2),r3
	mov.l	r11,@-r15		
	sts.l	pr,@-r15
	mov.l	i2mw_memfnwr8,r6
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r6
	mov.l	@(CPU_REMAINCLOCK,gbr),r0
	jsr	@r6
	mov	r0,r11
	mov	r11,r0
	lds.l	@r15+,pr
	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
	rts
	mov.l	@r15+,r11

	.align	2
200:	.long	USE_HIMEM
i2mw_memfnwr8:	.long		memfn + (32 * 4)
i2mw_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bf	1f
	rts
	nop
1:
	mov.l	@(CPU_EXTMEM,gbr),r0
	rts
	mov.b	r5,@(r0,r4)
	
_memr_write16:
	mov	#4,r3
	extu.w	r5,r5
	shld	r3,r4
	add	r5,r4
	mov	r6,r5
_memp_write16:
	mov.l	200f,r0
	mov.l	201f,r3
	ldc	r0,gbr
	mov.l	202f,r1
	mov	r4,r0
	tst	#1,r0
	bf/s	i2mwo_main
	cmp/hs	r3,r4
	bt/s	i2mwe_ext
	mov	r4,r0
	rts
	mov.w	r5,@(r0,r1)
	
	.align	2
200:	.long	_i286hcore
201:	.long	I286_MEMWRITEMAX
202:	.long	_i286hcore + CPU_SIZE
i2mwe_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt	i2mwe_himem
i2mww_ext:
	mov.l	r11,@-r15		
	sts.l	pr,@-r15
	mov	#-(15 - 2),r3
	mov.l	i2mwe_memfnwr16,r6
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r6
	mov.l	@(CPU_REMAINCLOCK,gbr),r0
	jsr	@r6
	mov	r0,r11
	mov	r11,r0
	lds.l	@r15+,pr
	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
	rts
	mov.l	@r15+,r11

	.align	2
200:	.long	USE_HIMEM
i2mwe_memfnwr16:	.long		memfn + (32 * 4) * 3
i2mwe_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bf	1f
	rts
	nop
1:
	mov.l	@(CPU_EXTMEM,gbr),r0
	rts
	mov.w	r5,@(r0,r4)
i2mwo_main:
	mov	r4,r6
	mov.l	200f,r3
	add	#1,r6
	cmp/hs	r3,r6
	bt	i2mwo_ext
	add	r1,r4
	swap.b	r5,r0
	mov.b	r5,@r4
	rts
	mov.b	r0,@(1,r4)

	.align	2
200:	.long	I286_MEMWRITEMAX
i2mwo_ext:
	mov.l	200f,r3
	cmp/hs	r3,r6
	bt/s	i2mwo_himem
	cmp/eq	r3,r6
	mov	#(32 - 15),r3
	shld	r3,r6
	tst	r6,r6
	bf/s	i2mww_ext
	mov	#-(15 - 2),r3
	mov.l	r8,@-r15		
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	sts.l	pr,@-r15		! ここチェックするように…
	shld	r3,r0
	mov.l	i2mwo_memfnwr8,r8
	and	#(0x1f << 2),r0
	mov	r4,r9
	mov.l	@(r0,r8),r6
	CPULDC
	mov	r5,r10
	add	#1,r9
	jsr	@r6
	shlr8	r10
	mov	r9,r4
	mov	#-(15 - 2),r3
	mov	r4,r0
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r8),r6
	jsr	@r6
	mov	r10,r5
	CPUSVC
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	USE_HIMEM
i2mwo_memfnwr8:	.long	memfn + (32 * 4)
i2mwo_himem:
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov	#(0x100000 >> 16),r3
	mov	r0,r2
	shll16	r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	sub	r3,r6
	bt/s	i2mwo_10ffff			! = 10ffff
	add	r6,r2
	cmp/hi	r0,r6
	bt/s	1f
	cmp/hs	r0,r6
	mov.b	r5,@-r2
	add	#1,r2
1:
	bf/s	2f
	shlr8	r5
	rts
	nop
2:	
	rts
	mov.b	r5,@r2
i2mwo_10ffff:
	mov.l	200f,r7
	tst	r4,r4
	add	r1,r7
	bf/s	1f
	mov.b	r5,@-r7
	rts
	nop
1:
	shlr8	r5
	rts
	mov.b	r5,@r2

	.align	2
200:	.long	USE_HIMEM

! ---- from asm

i286h_memoryread:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2hmr_ext
	mov	r4,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0

	.align	2
200:	.long	I286_MEMREADMAX	
i2hmr_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2hmr_himem
	mov	#-(15 - 2),r3
	mov.l	i2hmr_memfnrd8,r2
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r2),r3
	jmp	@r3
	nop

	.align	2
200:	.long	USE_HIMEM
i2hmr_memfnrd8:	.long		memfn
i2hmr_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bt/s	1f
	mov	#0xff,r3
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov.b	@(r0,r4),r4
	rts
	extu.b	r4,r0
1:
	rts
	extu.b	r3,r0

i286h_memoryread_w:
	mov.l	200f,r3
	mov	r4,r0
	tst	#1,r0
	bf/s	i2hmro_main
	cmp/hs	r3,r4
	bt/s	i2hmre_ext
	mov	r4,r0
	mov.w	@(r0,r1),r4
	rts
	extu.w	r4,r0

	.align	2
200:	.long	I286_MEMREADMAX
i2hmre_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt	i2hmre_himem
i2hmrw_ext:
	mov.l	i2hmre_memfnrdw,r6
	mov	#-(15 - 2),r3
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r6
	jmp	@r6
	nop

	.align	2
200:	.long		USE_HIMEM	
i2hmre_memfnrdw:	.long		memfn + (32 * 4) * 2
i2hmre_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bt/s	1f
	mov	#0xff,r3
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov.w	@(r0,r4),r4
	rts
	extu.w	r4,r0
1:
	rts
	extu.w	r3,r0
i2hmro_main:
	mov	r4,r5
	mov.l	200f,r3
	add	#1,r5
	cmp/hs	r3,r5
	bt	i2hmro_ext
	add	r1,r4
	mov.b	@r4+,r0
	mov.b	@r4,r5
	extu.b	r0,r0
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
	
	.align	2
200:	.long	I286_MEMREADMAX
i2hmro_ext:
	mov.l	200f,r3
	cmp/hs	r3,r5
	bt/s	i2hmro_himem
	cmp/eq	r3,r5
	mov	#(32 - 15),r3
	shld	r3,r5
	tst	r5,r5
	bf/s	i2hmrw_ext
	mov	r4,r0
	mov	#-(15 - 2),r3
	mov.l	r9,@-r15			! ここチェックするように…
	mov.l	i2hmro_memfnrdb,r7
	shld	r3,r0
	mov.l	r10,@-r15
	and	#(0x1f << 2),r0
	sts.l	pr,@-r15
	mov.l	@(r0,r7),r6
	mov	r4,r9
	jsr	@r6
	add	#1,r9
	mov	r0,r10
	mov.l	i2hmro_memfnrdb,r7
	mov	r9,r0
	mov	#-(15 - 2),r3
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r7),r6
	jsr	@r6
	mov	r9,r4
	shll8	r0
	lds.l	@r15+,pr
	add	r10,r0
	mov.l	@r15+,r10
	rts
	mov.l	@r15+,r9

	.align	2
i2hmro_memfnrdb:	.long		memfn
200:	.long	USE_HIMEM	
i2hmro_himem:
	mov.l	@(CPU_EXTMEM,gbr),r0
	mov	#(0x100000 >> 16),r3
	mov	r0,r6
	shll16	r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	sub	r3,r5
	mov	r0,r2
	bt/s	i2hmro_10ffff			! = 10ffff
	add	r5,r6
	cmp/hs	r2,r5
	bt/s	i2hmro_himeml			! = over
	cmp/eq	r2,r5
	add	#-1,r6
	mov.b	@r6+,r4
	mov.b	@r6,r5
	extu.b	r4,r0
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
i2hmro_10ffff:
	add	r1,r4
	mov.b	@r4,r4
	cmp/hs	r2,r5
	bt/s	i2hmro_himemh
	extu.b	r4,r0
	mov.b	@r6,r5
	extu.b	r5,r5
	shll8	r5
	rts
	add	r5,r0
i2hmro_himeml:
	bf/s	1f
	add	#-1,r6
	mov.b	@r6+,r4
	extu.b	r4,r0
i2hmro_himemh:
	swap.b	r0,r0
	or	#(0xff00 >> 8),r0
	rts
	swap.b	r0,r0
1:
	mov	#0xff,r4
	bra	i2hmro_himemh
	extu.b	r4,r0


i286h_memorywrite:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2hmw_ext
	mov	r4,r0
	rts
	mov.b	r5,@(r0,r1)

	.align	2
200:	.long	I286_MEMWRITEMAX
i2hmw_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt/s	i2hmw_himem
	mov	#-(15 - 2),r3
	mov.l	i2hmw_memfnwrb,r6
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r3
	jmp	@r3
	nop

	.align	2
200:	.long	USE_HIMEM
i2hmw_memfnwrb:	.long		memfn + (32 * 4)
i2hmw_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bf	1f
	rts
	nop
1:
	mov.l	@(CPU_EXTMEM,gbr),r0
	rts
	mov.b	r5,@(r0,r4)


i286h_memorywrite_w:
	mov.l	200f,r3
	mov	r4,r0
	tst	#1,r0
	bf/s	i2hmwo_main
	cmp/hs	r3,r4
	bt/s	i2hmwe_ext
	mov	r4,r0
	rts
	mov.w	r5,@(r0,r1)

	.align	2
200:	.long	I286_MEMWRITEMAX
i2hmwe_ext:
	mov.l	200f,r3
	cmp/hs	r3,r4
	bt	i2hmwe_himem
i2hmww_ext:
	mov	#-(15 - 2),r3
	mov.l	i2hmwe_memfnwrw,r6
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r6),r6
	jmp	@r6
	nop

	.align	2
200:	.long	USE_HIMEM
i2hmwe_memfnwrw:	.long		memfn + (32 * 4) * 3
i2hmwe_himem:
	mov	#(0x100000 >> 16),r3
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	shll16	r3
	sub	r3,r4
	cmp/hs	r0,r4
	bf	1f
	rts
	nop
1:
	mov.l	@(CPU_EXTMEM,gbr),r0
	rts
	mov.w	r5,@(r0,r4)
i2hmwo_main:
	mov	r4,r6
	mov.l	200f,r3
	add	#1,r6
	cmp/hs	r3,r6
	bt	i2hmwo_ext
	add	r1,r4
	swap.b	r5,r0
	mov.b	r5,@r4
	rts
	mov.b	r0,@(1,r4)
	
	.align	2
200:	.long	I286_MEMWRITEMAX
i2hmwo_ext:
	mov.l	200f,r0
	cmp/hs	r0,r6
	bt/s	i2hmwo_himem
	cmp/eq	r0,r6
	mov	#(32 - 15),r3
	shld	r3,r6
	tst	r6,r6
	bf/s	i2hmww_ext
	mov	r4,r0
	mov.l	i2hmwo_memfnwrb,r2
	mov	#-(15 - 2),r3
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov	r4,r6
	mov	r5,r7
	add	#1,r6
	mov.l	@(r0,r2),r2
	shlr8	r7
	sts.l	pr,@-r15			! ここチェックするように…
	mov.l	r7,@-r15
	jsr	@r2
	mov.l	r6,@-r15
	mov.l	i2hmwo_memfnwrb,r2
	mov	r4,r0
	mov	#-(15 - 2),r3
	shld	r3,r0
	and	#(0x1f << 2),r0
	mov.l	@(r0,r2),r3
	mov.l	@r15+,r4
	mov.l	@r15+,r5
	jmp	@r3
	lds.l	@r15+,pr
	
	.align	2
i2hmwo_memfnwrb:	.long		memfn + (32 * 4)
200:	.long	USE_HIMEM
i2hmwo_himem:
	
	mov.l	@(CPU_EXTMEMSIZE,gbr),r0
	mov	#(0x100000 >> 16),r3
	mov	r0,r2
	shll16	r3
	mov.l	@(CPU_EXTMEM,gbr),r0
	sub	r3,r6
	bt/s	i2hmwo_10ffff			! = 10ffff
	add	r6,r2
	cmp/hi	r0,r6
	bt/s	1f
	cmp/hs	r0,r6
	mov.b	r5,@-r2
	add	#1,r2
1:
	bf/s	2f
	shlr8	r5
	rts
	nop
2:	
	rts
	mov.b	r5,@r2
i2hmwo_10ffff:
	mov.l	200f,r7
	tst	r4,r4
	add	r1,r7
	bf/s	1f
	mov.b	r5,@-r7
	rts
	nop
1:	
	shlr8	r5
	rts
	mov.b	r5,@r2

	.align	2
200:	.long	USE_HIMEM
	
	
	.end
