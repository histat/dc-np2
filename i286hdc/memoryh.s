
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hmem.inc"
	.include "../i286hdc/i286hio.inc"

	.extern	_vramupdate
	.extern	_tramupdate

	.extern	_egc_writebyte
	.extern	_egc_readbyte
	.extern	_egc_writeword
	.extern	_egc_readword

	.globl	memfn
	.globl	_i286_memorymap
	.globl	_i286_vram_dispatch

	.globl	i286_nonram_r
	.globl	i286_nonram_rw

	.text

	.align	2
memfn:	.long		i286_rdex		! 00
		.long		i286_rdex
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd			! 20
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd			! 40
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd			! 60
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd			! 80
		.long		i286_rd
		.long		i286_rd
		.long		i286_rd
		.long		tram_rd			! a0
		.long		vram_r0
		.long		vram_r0
		.long		vram_r0
		.long		emmc_rd			! c0
		.long		emmc_rd
		.long		i286_rd
		.long		i286_rd
		.long		vram_r0			! e0
		.long		i286_rd
		.long		i286_rd
		.long		i286_rb

		.long		i286_wtex		! 00
		.long		i286_wtex
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt			! 20
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt			! 40
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt			! 60
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt			! 80
		.long		i286_wt
		.long		i286_wt
		.long		i286_wt
		.long		tram_wt			! a0
		.long		vram_w0
		.long		vram_w0
		.long		vram_w0
		.long		emmc_wt			! c0
		.long		emmc_wt
		.long		i286_wn
		.long		i286_wn
		.long		vram_w0			! e0
		.long		i286_wn
		.long		i286_wn
		.long		i286_wn

		.long		i286w_rdex		! 00
		.long		i286w_rdex
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd		! 20
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd		! 40
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd		! 60
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd		! 80
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rd
		.long		tramw_rd		! a0
		.long		vramw_r0
		.long		vramw_r0
		.long		vramw_r0
		.long		emmcw_rd		! c0
		.long		emmcw_rd
		.long		i286w_rd
		.long		i286w_rd
		.long		vramw_r0		! e0
		.long		i286w_rd
		.long		i286w_rd
		.long		i286w_rb

		.long		i286w_wtex		! 00
		.long		i286w_wtex
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt		! 20
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt		! 40
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt		! 60
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt		! 80
		.long		i286w_wt
		.long		i286w_wt
		.long		i286w_wt
		.long		tramw_wt		! a0
		.long		vramw_w0
		.long		vramw_w0
		.long		vramw_w0
		.long		emmcw_wt		! c0
		.long		emmcw_wt
		.long		i286w_wn
		.long		i286w_wn
		.long		vramw_w0		! e0
		.long		i286w_wn
		.long		i286w_wn
		.long		i286w_wn

! ---- memory...

i286_rd:
	add	r1,r4
	mov.b	@r4,r4
	rts
	extu.b	r4,r0
i286_rdex:
	mov.l	@(CPU_ADRSMASK,gbr),r0
	and	r4,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0
i286w_rd:
	add	r1,r4
	mov.b	@r4+,r5
	mov.b	@r4,r7
	extu.b	r5,r5
	extu.b	r7,r0
	shll8	r0
	rts
	or	r5,r0
i286w_rdex:
	mov.l	@(CPU_ADRSMASK,gbr),r0
	and	r0,r4
	add	r1,r4
	mov.b	@r4+,r5
	mov.b	@r4,r7
	extu.b	r5,r5
	extu.b	r7,r0
	shll8	r0
	rts
	or	r5,r0
i286_wt:
	add	r1,r4
	rts
	mov.b	r5,@r4
i286_wtex:
	mov.l	@(CPU_ADRSMASK,gbr),r0
	and	r4,r0
	rts
	mov.b	r5,@(r0,r1)
i286w_wt:
	add	r1,r4
	mov.b	r5,@r4
	swap.b	r5,r0
	rts
	mov.b	r0,@(1,r4)
i286w_wtex:
	mov.l	@(CPU_ADRSMASK,gbr),r0
	and	r0,r4
	add	r1,r4
	mov.b	r5,@r4
	swap.b	r5,r0
	rts
	mov.b	r0,@(1,r4)


! ---- text ram

tram_rd:
	mov.b	@(MEMWAIT_TRAM,gbr),r0
	mov.l	200f,r3
	extu.b	r0,r2
	mov	r4,r5
	mov	#(0x1000 >> 8),r0
	shll8	r0
	sub	r3,r5
	cmp/hs	r0,r5
	sub	r2,r11
	bf/s	1f
	mov	r4,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0
1:
	mov.l	202f,r6
	tst	#1,r0
	bf/s	2f
	and	#(0xf << 1),r0
	bra	3f
	mov.l	@(CGW_LOW,r6),r7
2:
	mov.l	@(CGW_HIGH,r6),r7
3:
	mov.l	203f,r5
	shlr	r0
	add	r5,r7
	mov.b	@(r0,r7),r4
	rts
	extu.b	r4,r0
	
	.align 2
200:	.long	0xa4000
202:	.long	_cgwindow	
203:	.long	_i286hcore + CPU_SIZE + FONT_ADRS
tramw_rd:
	mov.b	@(MEMWAIT_TRAM,gbr),r0
	mov.l	200f,r2
	extu.b	r0,r6
	mov	r4,r0
	tst	#1,r0
	bf/s	tramw_rd_odd
	sub	r6,r11
	mov.l	201f,r3
	mov	r4,r5
	mov	#(0x1000 >> 8),r0
	shll8	r0
	sub	r3,r5
	cmp/hs	r0,r5
	bf/s	1f
	mov	r4,r0
	mov.w	@(r0,r1),r4
	rts
	extu.w	r4,r0
1:
	mov.l	@(CGW_LOW,r2),r6
	mov.l	@(CGW_HIGH,r2),r7
	and	#(0xf << 1),r0
	mov.l	203f,r5
	shlr	r0
	add	r5,r0
	mov.b	@(r0,r6),r4
	mov.b	@(r0,r7),r5
	extu.b	r4,r4
	extu.b	r5,r0
	shll8	r0
	rts
	or	r4,r0

	.align 2
200:	.long	_cgwindow
201:	.long	0xa4000
203:	.long	_i286hcore + CPU_SIZE + FONT_ADRS	
tramw_rd_odd:
	mov	r4,r5
	mov.l	201f,r0
	add	#1,r5
	mov	#((0xa5000 - 0xa4000) >> 8),r3
	shll8	r3
	cmp/hs	r0,r5
	bf/s	tramw_rd_oddt
	cmp/eq	r0,r5
	bt/s	tramw_rd_3fff
	add	r3,r0
	cmp/gt	r0,r5
	bf	tramw_rd_oddf
tramw_rd_oddt:
	mov	r1,r0
	mov.b	@(r0,r4),r4
	mov.b	@(r0,r5),r5
	extu.b	r4,r4
	extu.b	r5,r0
	shll8	r0
	rts
	or	r4,r0

	.align 2
201:	.long	0xa4000
tramw_rd_3fff:
	mov	#31,r3
	mov	#1,r0
	shld	r3,r0
	cmp/ge	r0,r5		! set v / clr z
tramw_rd_oddf:
	mov.l	203f,r7
	bt/s	1f
	cmp/eq	r0,r5
	mov.l	@(CGW_HIGH,r2),r6
	mov	r4,r0
	add	r7,r6
	mov	#-1,r3
	and	#(0xf << 1),r0
	shld	r3,r0
	mov.b	@(r0,r6),r4
	bra	2f
	extu.b	r4,r4
1:
	mov	r4,r0
	mov.b	@(r0,r1),r4
	extu.b	r4,r4
2:
	bt/s	3f
	mov	r5,r0
	mov.l	@(CGW_LOW,r2),r2
	and	#(0xf << 1),r0
	add	r7,r2
	shlr	r0
	mov.b	@(r0,r2),r5
	extu.b	r5,r0
	shll8	r0
	rts
	or	r4,r0
3:
	mov.b	@(r0,r1),r5
	extu.b	r5,r0
	shll8	r0
	rts
	or	r4,r0

	.align 2
200:	.long	_cgwindow
201:	.long	0xa4000
203:	.long	_i286hcore + CPU_SIZE + FONT_ADRS	
tram_wt:
	mov.l	200f,r3
	mov.b	@(MEMWAIT_TRAM,gbr),r0
	cmp/hs	r3,r4
	bt/s	twt_cgwnd
	extu.b	r0,r2
	sub	r2,r11
	mov.l	201f,r7
	mov	r4,r2
	mov	#(31 - 12),r3
	mov.l	202f,r0
	shld	r3,r2
	cmp/hs	r0,r4
	bf/s	twt_write
	mov	r4,r0
	tst	#1,r0
	bf	10f
twt_attr:
	mov.l	203f,r3
	cmp/hs	r3,r2
	bf/s	twt_write
	mov	r4,r0
	tst	#2,r0
	bt	twt_write
	mov.b	@(GDCS_MSWACC,r7),r0
	tst	r0,r0
	bt/s	10f
	mov	r4,r0
twt_write:
	mov.b	r5,@(r0,r1)
twt_dirtyupd:
	mov.l	205f,r0
	mov	#1,r5
	mov	#-(32 - 12),r3
	shld	r3,r2
	mov.b	r5,@(r0,r2)
	mov.b	@(GDCS_TEXTDISP,r7),r0
	or	#1,r0
	mov.b	r0,@(GDCS_TEXTDISP,r7)
10:
	rts
	nop

	.align	2
200:	.long	0xa4000
201:	.long	_gdcs
202:	.long	0xa2000	
203:	.long	(0x1fe0 << (31 - 12))
205:	.long	_tramupdate
tramw_wt:
	mov.l	200f,r3
	mov.b	@(MEMWAIT_TRAM,gbr),r0
	cmp/hs	r3,r4
	bt/s	twwt_cgwnd
	extu.b	r0,r2
	sub	r2,r11
	mov.l	201f,r7
	mov	r4,r2
	mov	#(31 - 12),r3
	mov	r4,r0
	tst	#1,r0
	bf/s	twwto_main
	shld	r3,r2
	mov.l	202f,r0
	cmp/hs	r0,r4
	bt/s	twt_attr
	mov	r4,r0
	bf/s	twt_dirtyupd
	mov.w	r5,@(r0,r1)
twwto_main:
	mov.l	202f,r3
	mov	r4,r6
	add	#1,r4
	cmp/gt	r3,r4
	bt/s	1f
	mov	r6,r0
	mov.b	r5,@(r0,r1)
1:
	bt/s	twt_attr
	shlr8	r5
	mov	r4,r0
	mov.b	r5,@(r0,r1)
	mov.b	@(GDCS_TEXTDISP,r7),r0
	or	#1,r0
	mov.b	r0,@(GDCS_TEXTDISP,r7)
	mov.l	204f,r6
	mov	#1,r4
	mov	r2,r0
	mov	#-(31 - 12),r3
	shld	r3,r0
	mov.b	r4,@(r0,r6)
	mov.l	205f,r0
	add	r2,r0
	shld	r3,r0
	rts
	mov.b	r4,@(r0,r6)

	.align	2
200:	.long	0xa4000
201:	.long	_gdcs
202:	.long	0xa2000	
204:	.long	_tramupdate
205:	.long	(1 << (32 - 12))
twt_cgwnd:
	mov.l	200f,r3
	mov.l	201f,r7
	cmp/hs	r3,r4
	bt/s	10f
	sub	r2,r11
1:
	mov	r4,r0
	and	#0x1f,r0
	mov	r0,r4
	tst	#1,r0
	bt/s	10f
	mov.b	@(CGW_WRITABLE,r7),r0
	tst	#1,r0
	bt	10f
2:
	or	#0x80,r0
	mov.l	202f,r2
	mov.b	r0,@(CGW_WRITABLE,r7)
	mov.l	@(CGW_HIGH,r7),r0
	shlr	r4
	add	r4,r2
	mov.b	r5,@(r0,r2)
10:
	rts
	nop

	.align	2
200:	.long	0xa5000	
201:	.long	_cgwindow
202:	.long	_i286hcore + CPU_SIZE + FONT_ADRS
twwt_cgwnd:
	mov.l	200f,r3
	mov.l	201f,r7
	cmp/hs	r3,r4
	bt/s	10f
	sub	r2,r11
1:
	mov	r4,r0
	tst	#1,r0
	mov.b	@(CGW_WRITABLE,r7),r0
	bf/s	2f
	tst	#1,r0
	shlr8	r5
2:
	bt/s	10f
	or	#0x80,r0
	mov.l	202f,r2
	mov.b	r0,@(CGW_WRITABLE,r7)
	mov.l	@(CGW_HIGH,r7),r0
	mov	#(0xf << 1),r3
	and	r3,r4
	shlr	r4
	add	r4,r2
	mov.b	r5,@(r0,r2)
10:
	rts
	nop

	.align	2
200:	.long	0xa5000
201:	.long	_cgwindow
202:	.long	_i286hcore + CPU_SIZE + FONT_ADRS

	
! ---- vram normal

vram_r1:
	mov.l	200f,r0
	add	r0,r4
vram_r0:
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	add	r1,r4
	extu.b	r0,r7
	mov.b	@r4,r4
	sub	r7,r11
	rts
	extu.b	r4,r0
vramw_r1:
	mov.l	200f,r0
	add	r0,r4
vramw_r0:
	add	r1,r4
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.b	@r4+,r6
	extu.b	r0,r7
	mov.b	@r4,r5
	extu.b	r6,r6
	sub	r7,r11
	extu.b	r5,r0
	shll8	r0
	rts
	or	r6,r0

	.align	2
200:	.long	VRAM_STEP
vram_w0:
	mov	r4,r0
	mov.l	200f,r6
	mov.b	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.l	202f,r7
	shll	r4
	extu.b	r0,r2
	extu.w	r4,r4
	sub	r2,r11
	mov.b	@r6,r0
	shlr	r4
	or	#1,r0
	add	r4,r7
	mov.b	r0,@r6
	mov.b	@r7,r0
	or	#1,r0
	rts
	mov.b	r0,@r7

	.align	2
200:	.long	_gdcs + GDCS_GRPHDISP	
202:	.long	_vramupdate
vram_w1:
	mov.l	200f,r3
	mov.l	201f,r6
	add	r3,r4
	mov	r4,r0
	mov.l	203f,r7
	mov.b	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	shll	r4
	extu.b	r0,r2
	extu.w	r4,r4
	sub	r2,r11
	mov.b	@r6,r0
	shlr	r4
	or	#2,r0
	add	r4,r7
	mov.b	r0,@r6
	mov.b	@r7,r0
	or	#2,r0
	rts
	mov.b	r0,@r7

	.align	2
200:	.long	VRAM_STEP
201:	.long	_gdcs + GDCS_GRPHDISP
203:	.long	_vramupdate
vramw_w0:
	mov.l	200f,r6
	mov	r4,r0
	tst	#1,r0
	bf	vww0_odd
	mov.w	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.l	201f,r7
	shll	r4
	extu.b	r0,r5
	extu.w	r4,r4
	sub	r5,r11
	shlr	r4
	mov.b	@r6,r0
	add	r4,r7
	or	#1,r0
	mov	#1,r3
	mov.b	r0,@r6
	shll8	r3
	mov.w	@r7,r0
	or	#1,r0
	or	r3,r0
	rts
	mov.w	r0,@r7
vww0_odd:
	mov.b	r5,@(r0,r1)
	add	#1,r0
	shlr8	r5
	mov.b	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.l	201f,r7
	shll	r4
	extu.b	r0,r5
	extu.w	r4,r4
	sub	r5,r11
	mov.b	@r6,r0
	shlr	r4
	or	#1,r0
	add	r4,r7
	mov.b	r0,@r6
	mov.b	@r7,r0
	or	#1,r0
	mov.b	r0,@r7
	mov.b	@(1,r7),r0
	or	#1,r0
	rts
	mov.b	r0,@(1,r7)

	.align	2
200:	.long	_gdcs + GDCS_GRPHDISP
201:	.long	_vramupdate
vramw_w1:
	mov.l	200f,r3
	mov.l	201f,r6
	add	r3,r4
	mov	r4,r0
	tst	#1,r0
	bf	vww1_odd
	mov.w	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.l	202f,r7
	shll	r4
	extu.b	r0,r5
	extu.w	r4,r4
	mov.b	@r6,r0
	shlr	r4
	or	#2,r0
	mov.b	r0,@r6
	add	r4,r7
	sub	r5,r11
	mov	#2,r3
	mov.w	@r7,r0
	shll8	r3
	or	#2,r0
	or	r3,r0
	rts
	mov.w	r0,@r7
vww1_odd:
	mov.b	r5,@(r0,r1)
	add	#1,r0
	shlr8	r5
	mov.b	r5,@(r0,r1)
	mov.b	@(MEMWAIT_VRAM,gbr),r0
	mov.l	202f,r7
	shll	r4
	extu.b	r0,r5
	extu.w	r4,r4
	mov.b	@r6,r0
	shlr	r4
	or	#2,r0
	mov.b	r0,@r6
	add	r4,r7
	sub	r5,r11
	mov.b	@r7,r0
	or	#2,r0
	mov.b	r0,@r7
	mov.b	@(1,r7),r0
	or	#2,r0
	rts
	mov.b	r0,@(1,r7)
	
	.align	2
200:	.long	VRAM_STEP
201:	.long	_gdcs + GDCS_GRPHDISP
202:	.long	_vramupdate	


! ---- grcg...
	
grcg_tcr1:
	mov.l	200f,r0
	add	r0,r4
grcg_tcr0:
	mov.l	201f,r7
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	mov.l	202f,r3
	extu.b	r0,r6
	and	r3,r4
	mov.b	@(GRCG_MODEREG,r7),r0
	sub	r6,r11
	mov	#28,r3
	shld	r3,r0
	mov	r0,r2
	mov	#28,r0
	mov	#((1 << 28) >> 28),r3
	shld	r0,r3
	mov.l	204f,r0
	tst	r2,r3
	add	r0,r4
	bf/s	1f
	shll	r3
	mov.b	@(GRCG_TILE + 0,r7),r0
	mov.b	@r4,r6
	extu.b	r0,r5
	extu.b	r6,r6
	xor	r6,r5
	or	r5,r2
1:
	mov.l	205f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	2f
	shll	r3
	mov.b	@(GRCG_TILE + 2,r7),r0
	mov.b	@r4,r6
	extu.b	r0,r5
	extu.b	r6,r6
	xor	r6,r5
	or	r5,r2
2:
	mov.l	206f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	3f
	shll	r3
	mov.b	@(GRCG_TILE + 4,r7),r0
	mov.b	@r4,r6
	extu.b	r0,r5
	extu.b	r6,r6
	xor	r6,r5
	or	r5,r2
3:
	mov.l	207f,r0
	tst	r3,r2
	bf/s	4f
	add	r0,r4
	mov.b	@(GRCG_TILE + 6,r7),r0
	mov.b	@r4,r6
	extu.b	r0,r5
	extu.b	r6,r6
	xor	r6,r5
	or	r5,r2
4:
	mov	#0xff,r0
	xor	r2,r0
	rts
	extu.b	r0,r0

	.align	2
200:	.long	VRAM_STEP
201:	.long	_grcg
202:	.long	~(0xf8000)
204:	.long	_i286hcore + CPU_SIZE + VRAM_B
205:	.long	(VRAM_R - VRAM_B)
206:	.long	(VRAM_G - VRAM_R)
207:	.long	(VRAM_E - VRAM_G)
grcgw_tcr1:
	mov.l	200f,r0
	add	r0,r4
grcgw_tcr0:
	mov.l	201f,r7
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	mov.l	202f,r3
	extu.b	r0,r6
	and	r3,r4
	mov.b	@(GRCG_MODEREG,r7),r0
	sub	r6,r11
	extu.b	r0,r2
	mov	r4,r0
	mov	#28,r3
	tst	#1,r0
	bf/s	tcrw_odd
	shld	r3,r2
1:
	mov	#28,r0
	mov	#1,r3
	shld	r0,r3
	mov.l	204f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	1f
	shll	r3
	mov.w	@(GRCG_TILE + 0,r7),r0
	mov.w	@r4,r6
	extu.w	r0,r5
	extu.w	r6,r6
	xor	r6,r5
	or	r5,r2
1:
	mov.l	205f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	2f
	shll	r3
	mov.w	@(GRCG_TILE + 2,r7),r0
	mov.w	@r4,r6
	extu.w	r0,r5
	extu.w	r6,r6
	xor	r6,r5
	or	r5,r2
2:
	mov.l	206f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	3f
	shll	r3
	mov.w	@(GRCG_TILE + 4,r7),r0
	mov.w	@r4,r6
	extu.w	r0,r5
	extu.w	r6,r6
	xor	r6,r5
	or	r5,r2
3:
	mov.l	207f,r0
	tst	r3,r2
	bf/s	4f
	add	r0,r4
	mov.w	@(GRCG_TILE + 6,r7),r0
	mov.w	@r4,r6
	extu.w	r0,r5
	extu.w	r6,r6
	xor	r6,r5
	or	r5,r2
4:
	not	r2,r2
	rts
	extu.w	r2,r0

	.align	2
200:	.long	VRAM_STEP
201:	.long	_grcg
202:	.long	~(0xf8000)
204:	.long	_i286hcore + CPU_SIZE + VRAM_B
205:	.long	(VRAM_R - VRAM_B)
206:	.long	(VRAM_G - VRAM_R)
207:	.long	(VRAM_E - VRAM_G)
tcrw_odd:
	mov	#28,r0
	mov	#((1 << 28) >> 28),r3
	shld	r0,r3
	mov.l	200f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	1f
	shll	r3
	mov.b	@r4,r5
	mov.b	@(1,r4),r0
	extu.b	r5,r5
	extu.b	r0,r6
	mov.w	@(GRCG_TILE + 0,r7),r0
	shll8	r6
	extu.w	r0,r0
	or	r6,r5
	xor	r0,r5
	or	r5,r2
1:
	mov.l	202f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	2f
	shll	r3
	mov.b	@r4,r5
	mov.b	@(1,r4),r0
	extu.b	r5,r5
	extu.b	r0,r6
	mov.w	@(GRCG_TILE + 2,r7),r0
	shll8	r6
	extu.w	r0,r0
	or	r6,r5
	xor	r0,r5
	or	r5,r2
2:
	mov.l	203f,r0
	tst	r3,r2
	add	r0,r4
	bf/s	3f
	shll	r3
	mov.b	@r4,r5
	mov.b	@(1,r4),r0
	extu.b	r5,r5
	extu.b	r0,r6
	mov.w	@(GRCG_TILE + 4,r7),r0
	shll8	r6
	extu.w	r0,r0
	or	r6,r5
	xor	r0,r5
	or	r5,r2
3:
	mov.l	204f,r0
	tst	r3,r2
	bf/s	4f
	add	r0,r4
	mov.b	@r4,r5
	mov.b	@(1,r4),r0
	extu.b	r5,r5
	extu.b	r0,r6
	mov.w	@(GRCG_TILE + 6,r7),r0
	shll8	r6
	extu.w	r0,r0
	or	r6,r5
	xor	r0,r5
	or	r5,r2
4:
	not	r2,r2
	rts
	extu.w	r2,r0

	.align	2
200:	.long	_i286hcore + CPU_SIZE + VRAM_B
202:	.long	(VRAM_R - VRAM_B)
203:	.long	(VRAM_G - VRAM_R)
204:	.long	(VRAM_E - VRAM_G)
grcg_tdw0:
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	200f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#1,r0
	bra	grcg_tdw
	mov.b	r0,@r6
grcg_tdw1:
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	200f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.l	202f,r0
	add	r0,r4
grcg_tdw:
	mov.l	203f,r0
	mov	#((1 << 16) >> 16),r3
	mov.l	204f,r7
	add	r0,r4
	shll16	r3
	mov.b	@(GRCG_MODEREG,r7),r0
	extu.b	r0,r6
	shll16	r6
	or	r6,r5
	tst	r3,r5
	bf/s	1f
	shll	r3
	mov.b	@(GRCG_TILE + 0,r7),r0
	mov.b	r0,@r4
1:
	mov.l	206f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	2f
	shll	r3
	mov.b	@(GRCG_TILE + 2,r7),r0
	mov.b	r0,@r4
2:
	mov.l	207f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	3f
	shll	r3
	mov.b	@(GRCG_TILE + 4,r7),r0
	mov.b	r0,@r4
3:
	mov.l	208f,r0
	tst	r3,r5
	bf/s	4f
	add	r0,r4
	mov.b	@(GRCG_TILE + 6,r7),r0
	mov.b	r0,@r4
4:	
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	rts
	sub	r7,r11

	.align	2
200:	.long	_vramupdate
201:	.long	_gdcs + GDCS_GRPHDISP
202:	.long	VRAM_STEP
203:	.long	_i286hcore + CPU_SIZE + VRAM_B
204:	.long	_grcg
206:	.long	(VRAM_R - VRAM_B)
207:	.long	(VRAM_G - VRAM_R)
208:	.long	(VRAM_E - VRAM_G)
grcg_rmw0:
	mov	#0xff,r3
	extu.b	r3,r3
	cmp/eq	r3,r5
	bt/s	grcg_tdw0
	tst	r5,r5
	bt/s	grcg_clock
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	200f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#1,r0
	bra	grcg_rmw
	mov.b	r0,@r6
grcg_rmw1:
	mov	#0xff,r3
	extu.b	r3,r3
	cmp/eq	r3,r5
	bt/s	grcg_tdw1
	tst	r5,r5
	bt/s	grcg_clock
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	200f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.l	202f,r0
	add	r0,r4
grcg_rmw:
	mov.l	203f,r0
	mov	#((1 << 16 >> 16)),r3
	mov.l	204f,r7
	add	r0,r4
	shll16	r3
	mov.b	@(GRCG_MODEREG,r7),r0
	extu.b	r0,r6
	shll16	r6
	or	r6,r5
	tst	r3,r5
	bf/s	grmw_bed
	shll	r3
	mov.b	@r4,r2
	mov.b	@(GRCG_TILE + 0,r7),r0
	and	r5,r0
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.b	r2,@r4
grmw_bed:
	mov.l	206f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	grmw_red
	shll	r3
	mov.b	@r4,r2
	mov.b	@(GRCG_TILE + 2,r7),r0
	and	r5,r0
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.b	r2,@r4
grmw_red:
	mov.l	207f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	grmw_ged
	shll	r3
	mov.b	@r4,r2
	mov.b	@(GRCG_TILE + 4,r7),r0
	and	r5,r0
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.b	r2,@r4
grmw_ged:
	mov.l	208f,r0
	tst	r3,r5
	bf/s	grcg_clock
	add	r0,r4
	mov.b	@r4,r2
	mov.b	@(GRCG_TILE + 6,r7),r0
	and	r5,r0
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.b	r2,@r4
grcg_clock:
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	rts
	sub	r7,r11
	
	.align	2
200:	.long	_vramupdate
201:	.long	_gdcs + GDCS_GRPHDISP
202:	.long	VRAM_STEP
203:	.long	_i286hcore + CPU_SIZE + VRAM_B
204:	.long	_grcg
206:	.long	(VRAM_R - VRAM_B)
207:	.long	(VRAM_G - VRAM_R)
208:	.long	(VRAM_E - VRAM_G)
grcgw_tdw0:
	mov.l	200f,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	201f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov.b	@(1,r6),r0
	or	#1,r0
	bra	grcgw_tdw
	mov.b	r0,@(1,r6)
grcgw_tdw1:
	mov.l	200f,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov.l	201f,r6
	add	r4,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.b	@(1,r6),r0
	or	#2,r0
	mov.b	r0,@(1,r6)
	mov.l	202f,r0
	add	r0,r4
grcgw_tdw:
	mov.l	203f,r6
	mov	#((1 << 16) >> 16),r3
	mov.l	204f,r7
	add	r6,r4
	shll16	r3
	mov.b	@(GRCG_MODEREG,r7),r0
	extu.b	r0,r6
	shll16	r6
	or	r6,r5
	tst	r3,r5
	bf/s	1f
	shll	r3
	mov.b	@(GRCG_TILE + 0,r7),r0
	mov.b	r0,@r4
	mov.b	r0,@(1,r4)
1:
	mov.l	206f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	2f
	shll	r3
	mov.b	@(GRCG_TILE + 2,r7),r0
	mov.b	r0,@r4
	mov.b	r0,@(1,r4)
2:
	mov.l	207f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	3f
	shll	r3
	mov.b	@(GRCG_TILE + 4,r7),r0
	mov.b	r0,@r4
	mov.b	r0,@(1,r4)
3:
	mov.l	208f,r0
	tst	r3,r5
	bf/s	4f
	add	r0,r4
	mov.b	@(GRCG_TILE + 6,r7),r0
	mov.b	r0,@r4
	mov.b	r0,@(1,r4)
4:	
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	rts
	sub	r7,r11

	.align	2
200:	.long	_gdcs + GDCS_GRPHDISP
201:	.long	_vramupdate
202:	.long	VRAM_STEP
203:	.long	_i286hcore + CPU_SIZE + VRAM_B
204:	.long	_grcg
206:	.long	(VRAM_R - VRAM_B)
207:	.long	(VRAM_G - VRAM_R)
208:	.long	(VRAM_E - VRAM_G)
grcgw_rmw0:
	mov	r5,r6
	mov	#1,r0
	shll16	r0
	add	#1,r6
	cmp/eq	r0,r6
	bt/s	grcgw_tdw0
	tst	r5,r5
	bf	1f
	bra	grcgw_clock
	nop
1:	
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov	r4,r0
	mov.l	202f,r6
	tst	#1,r0
	bf	grcgo_rmw0
	add	r4,r6
	mov	#1,r3
	mov.w	@r6,r0
	shll8	r3
	or	#1,r0
	or	r3,r0
	bra	grcge_rmw
	mov.w	r0,@r6
grcgw_rmw1:
	mov	r5,r6
	mov	#1,r0
	shll16	r0
	add	#1,r6
	cmp/eq	r0,r6
	bt	grcgw_tdw1
	tst	r5,r5
	bf	1f
	bra	grcgw_clock
	nop
1:	
	mov.l	201f,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov	#(32 - 15),r3
	shld	r3,r4
	mov	#-(32 - 15),r3
	shld	r3,r4
	mov	r4,r0
	mov.l	202f,r6
	tst	#1,r0
	bf	grcgo_rmw1
	add	r4,r6
	mov	#2,r3
	mov.w	@r6,r0
	shll8	r3
	or	#2,r0
	or	r3,r0
	mov.w	r0,@r6
	mov.l	203f,r0
	add	r0,r4
grcge_rmw:
	mov.l	204f,r6
	mov	#((1 << 16) >> 16),r3
	mov.l	205f,r7
	add	r6,r4
	shll16	r3
	mov.b	@(GRCG_MODEREG,r7),r0
	extu.b	r0,r6
	shll16	r6
	or	r6,r5
	tst	r3,r5
	bf/s	grmwo_bed
	shll	r3
	mov.w	@(GRCG_TILE + 0,r7),r0
	and	r5,r0
	mov.w	@r4,r2
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.w	r2,@r4
grmwe_bed:
	mov.l	207f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	grmwo_red
	shll	r3
	mov.w	@(GRCG_TILE + 2,r7),r0
	and	r5,r0
	mov.w	@r4,r2
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.w	r2,@r4
grmwe_red:
	mov.l	208f,r0
	tst	r3,r5
	add	r0,r4
	bt/s	1f
	shll	r3
	bra	grmwo_ged
	nop
1:
	mov.w	@(GRCG_TILE + 4,r7),r0
	and	r5,r0
	mov.w	@r4,r2
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.w	r2,@r4
grmwe_ged:
	mov.l	209f,r0
	tst	r3,r5
	bf/s	grmwe_eed
	add	r0,r4
	mov.w	@(GRCG_TILE + 6,r7),r0
	and	r5,r0
	mov.w	@r4,r2
	not	r5,r6
	and	r6,r2
	or	r0,r2
	mov.w	r2,@r4
grmwe_eed:
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	rts
	sub	r7,r11

	.align	2
201:	.long	_gdcs + GDCS_GRPHDISP
202:	.long	_vramupdate
203:	.long	VRAM_STEP
204:	.long	_i286hcore + CPU_SIZE + VRAM_B
205:	.long	_grcg
207:	.long	(VRAM_R - VRAM_B)
208:	.long	(VRAM_G - VRAM_R)
209:	.long	(VRAM_E - VRAM_G)
grcgo_rmw0:
	add	r4,r6
	mov.b	@r6,r0
	or	#1,r0
	mov.b	r0,@r6
	mov.b	@(1,r6),r0
	or	#1,r0
	bra	grcgo_rmw
	mov.b	r0,@(1,r6)
grcgo_rmw1:
	add	r4,r6
	mov.b	@r6,r0
	or	#2,r0
	mov.b	r0,@r6
	mov.b	@(1,r6),r0
	or	#2,r0
	mov.b	r0,@(1,r6)
	mov.l	200f,r3
	add	r3,r4
grcgo_rmw:
	mov.l	201f,r6
	mov	#((1 << 16) >> 16),r3
	mov.l	202f,r7
	add	r6,r4
	shll16	r3
	mov.b	@(GRCG_MODEREG,r7),r0
	extu.b	r0,r6
	shll16	r6
	or	r6,r5
	tst	r3,r5
	bf/s	grmwo_bed
	shll	r3
	mov.w	@(GRCG_TILE + 0,r7),r0
	extu.w	r0,r6
	and	r5,r6
	mov.b	@r4,r2
	not	r5,r0
	and	r0,r2
	or	r6,r2
	mov.b	r2,@r4
	mov.b	@(1,r4),r0
	mov	r5,r2
	shlr8	r2
	not	r2,r2
	and	r2,r0
	shlr8	r6
	or	r6,r0
	mov.b	r0,@(1,r4)
grmwo_bed:
	mov.l	204f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	grmwo_red
	shll	r3
	mov.w	@(GRCG_TILE + 2,r7),r0
	extu.w	r0,r6
	and	r5,r6
	mov.b	@r4,r2
	not	r5,r0
	and	r0,r2
	or	r6,r2
	mov.b	r2,@r4
	mov.b	@(1,r4),r0
	mov	r5,r2
	shlr8	r2
	not	r2,r2
	and	r2,r0
	shlr8	r6
	or	r6,r0
	mov.b	r0,@(1,r4)
grmwo_red:
	mov.l	205f,r0
	tst	r3,r5
	add	r0,r4
	bf/s	grmwo_ged
	shll	r3
	mov.w	@(GRCG_TILE + 4,r7),r0
	extu.w	r0,r6
	and	r5,r6
	mov.b	@r4,r2
	not	r5,r0
	and	r0,r2
	or	r6,r2
	mov.b	r2,@r4
	mov.b	@(1,r4),r0
	mov	r5,r2
	shlr8	r2
	not	r2,r2
	and	r2,r0
	shlr8	r6
	or	r6,r0
	mov.b	r0,@(1,r4)
grmwo_ged:
	mov.l	206f,r0
	tst	r3,r5
	bf/s	grcgw_clock
	add	r0,r4
	mov.w	@(GRCG_TILE + 6,r7),r0
	extu.w	r0,r6
	and	r5,r6
	mov.b	@r4,r2
	not	r5,r0
	and	r0,r2
	or	r6,r2
	mov.b	r2,@r4
	mov.b	@(1,r4),r0
	mov	r5,r2
	shlr8	r2
	not	r2,r2
	and	r2,r0
	shlr8	r6
	or	r6,r0
	mov.b	r0,@(1,r4)
grcgw_clock:
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	rts
	sub	r7,r11

	.align	2
200:	.long	VRAM_STEP
201:	.long	_i286hcore + CPU_SIZE + VRAM_B
202:	.long	_grcg
204:	.long	(VRAM_R - VRAM_B)
205:	.long	(VRAM_G - VRAM_R)
206:	.long	(VRAM_E - VRAM_G)

! ---- egc

egc_rd:
	mov.l	200f,r3
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	extu.b	r0,r7
	jsr	@r3
	sub	r7,r11
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1

	.align	2
200:	.long	_egc_readbyte

egcw_rd:
	mov.l	200f,r6
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	mov.b	@r6,r6
	extu.b	r0,r7
	mov	r4,r0
	tst	#1,r0
	sub	r7,r11
	bf/s	1f
	extu.b	r6,r6
	mov.l	201f,r3
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1
1:	
	mov.w	@(EGC_SFT,r6),r0
	shlr8	r0
	tst	#0x10,r0
	bf	egcwrd_std
	mov	r4,r6
	add	#1,r6
	mov	r5,r7
	shlr8	r7
	mov.l	202f,r3
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	mov.l	r7,@-r15
	jsr	@r3
	mov.l	r6,@-r15
	mov.l	202f,r3
	mov.l	@r15+,r4
	jsr	@r3
	mov.l	@r15+,r5
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1

egcwrd_std:
	mov.l	202f,r3
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	mov.l	r5,@-r15
	add	#1,r4
	mov.l	r4,@-r15
	jsr	@r3
	shlr8	r5
	mov.l	202f,r3
	mov.l	@r15+,r4
	jsr	@r3
	mov.l	@r15+,r5
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1

	.align	2
200:	.long	_egc
201:	.long	_egc_readword	
202:	.long	_egc_writebyte

egc_wt:
	mov.l	200f,r3
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	extu.b	r0,r7
	jsr	@r3
	sub	r7,r11
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1

	.align	2
200:	.long	_egc_writebyte

egcw_wt:
	mov.b	@(MEMWAIT_GRCG,gbr),r0
	mov.l	200f,r6
	extu.b	r0,r7
	sub	r7,r11
	mov.b	@r6,r6
	mov	r4,r0
	tst	#1,r0
	sub	r7,r11
	bf/s	1f
	extu.b	r6,r6
	mov.l	201f,r3
	mov.l	r1,@-r15
	sts.l	pr,@-r15
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r1
1:	
	mov.w	@(EGC_SFT,r6),r0
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	sts.l	pr,@-r15
	mov.l	r1,@-r15
	shlr8	r0
	tst	#0x10,r0
	bf	egcwwt_std
	mov	r4,r8
	mov.l	202f,r3
	add	#1,r8
	mov	r5,r9
	jsr	@r3
	shlr8	r9
	mov.l	202f,r3
	mov	r9,r5
	mov	r0,r9
	jsr	@r3	
	mov	r8,r4
	shll8	r0
	or	r9,r0
	mov.l	@r15+,r1
	lds.l	@r15+,pr
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8
egcwwt_std:
	mov.l	202f,r3
	mov	r4,r8
	mov	r5,r9
	add	#1,r4
	jsr	@r3
	shlr8	r5
	mov.l	202f,r3
	mov	r9,r5
	mov	r0,r9
	jsr	@r3
	mov	r8,r4
	shll8	r0
	or	r9,r0
	mov.l	@r15+,r1
	lds.l	@r15+,pr
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	_egc
201:	.long	_egc_writeword
202:	.long	_egc_readbyte


! ---- emmc

emmc_rd:
	mov	r1,r6
	add	#(104 - (104 + 32) + 8),r6 ! CPU_EMS
	mov	r4,r0
	mov	#-(14 - 2),r3
	shld	r3,r0	
	and	#(3 << 2),r0
	mov.l	@(r0,r6),r0
	mov	#(32 - 14),r3
	shld	r3,r4
	mov	#-(32 - 14),r3
	shld	r3,r4
	mov.b	@(r0,r4),r4
	rts
	extu.b	r4,r0
emmc_wt:
	mov	r1,r6
	add	#(104 - (104 + 32) + 8),r6 ! CPU_EMS
	mov	r4,r0
	mov	#-(14 - 2),r3
	shld	r3,r0
	and	#(3 << 2),r0
	mov.l	@(r0,r6),r0
	mov	#(32 - 14),r3
	shld	r3,r4
	mov	#-(32 - 14),r3
	shld	r3,r4
	rts
	mov.b	r5,@(r0,r4)
emmcw_rd:
	mov	r1,r6
	add	#(104 - (104 + 32) + 8),r6 ! CPU_EMS
	mov	#3,r2
	mov	#14,r3
	shld	r3,r2
	and	r4,r2
	mov	#(32 - 14),r3
	shld	r3,r4
	mov	r2,r0
	mov	#-(14 - 2),r3
	shld	r3,r0
	mov.l	@(r0,r6),r7
	mov	r4,r0
	mov	#-(32 - 14),r3
	shld	r3,r0
	tst	#1,r0
	bf/s	emmcw_rd_odd
	mov	r4,r0
	shld	r3,r0
	mov.w	@(r0,r7),r4
	rts
	extu.w	r4,r0
emmcw_rd_odd:
	mov	#-(32 - 14),r3
	shld	r3,r0
	mov.b	@(r0,r7),r5
	mov	#1,r0
	mov	#(32 - 14),r3
	shld	r3,r0
	add	r4,r0
	tst	r0,r0
	bt/s	emmcw_rd_3fff
	extu.b	r5,r5
	mov	#-(32 - 14),r3
	shld	r3,r0
	mov.b	@(r0,r7),r4
	extu.b	r4,r0
	shll8	r0
	rts
	add	r5,r0
emmcw_rd_3fff:
	mov	#14,r3
	mov	#1,r0
	shld	r3,r0
	xor	r2,r0
	mov	#-(14 - 2),r3
	shld	r3,r0
	mov.l	@(r0,r6),r4
	mov.b	@r4,r4
	extu.b	r4,r0
	shll8	r0
	rts
	add	r5,r0
emmcw_wt:
	mov	r1,r6
	add	#(104 - (104 + 32) + 8),r6 ! CPU_EMS
	mov	#3,r2
	mov	#14,r3
	shld	r3,r2
	and	r4,r2
	mov	#(32 - 14),r3
	shld	r3,r4
	mov	r2,r0
	mov	#-(14 - 2),r3
	shld	r3,r0
	mov.l	@(r0,r6),r7
	mov	r4,r0
	mov	#-(32 - 14),r3
	shld	r3,r0
	tst	#1,r0
	bf/s	emmcw_wt_odd
	mov	r4,r0
	mov	#-(32 - 14),r3
	shld	r3,r4
	add	r4,r7
	rts
	mov.w	r5,@r7

emmcw_wt_odd:
	mov	#-(32 - 14),r3
	shld	r3,r0
	mov.b	r5,@(r0,r7)
	mov	#1,r0
	mov	#(32 - 14),r3
	shld	r3,r0
	add	r4,r0
	tst	r0,r0
	bt/s	emmcw_wt_3fff
	shlr8	r5
	mov	#-(32 - 14),r3
	shld	r3,r0
	rts
	mov.b	r5,@(r0,r7)
emmcw_wt_3fff:
	mov	#1,r0
	mov	#14,r3
	shld	r3,r0
	xor	r2,r0
	mov	#-(14 - 2),r3
	shld	r3,r0
	mov.l	@(r0,r6),r4
	rts
	mov.b	r5,@r4

	
! ---- itf
	
i286_rb:
	mov.b	@(CPU_ITFBANK,gbr),r0
	tst	r0,r0
	bf/s	1f
	mov	r4,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0
1:
	mov.l	200f,r2
	or	r2,r0
	mov.b	@(r0,r1),r4
	rts
	extu.b	r4,r0
	
	.align 2
200:	.long	VRAM_STEP
i286_wb:
	mov.b	@(CPU_ITFBANK,gbr),r0
	tst	r0,r0
	bf/s	1f
	mov	r4,r0
	rts
	mov.b	r5,@(r0,r1)
1:
	mov.l	200f,r2
	or	r2,r0
	rts
	mov.b	r5,@(r0,r1)

	.align 2
200:	.long	(0x1c8000 - 0x0e8000)
i286w_rb:
	mov.b	@(CPU_ITFBANK,gbr),r0
	extu.b	r0,r6
	mov	r4,r0
	tst	#1,r0
	bf/s	i286w_rb_odd
	tst	r6,r6
	bt/s	1f
	mov	r4,r0
	mov.l	200f,r3
	or	r3,r0
1:
	mov.w	@(r0,r1),r4
	rts
	extu.w	r4,r0

	.align	2
200:	.long	VRAM_STEP
i286w_rb_odd:
	bt/s	1f
	mov	r4,r0
	mov.l	200f,r3
	or	r3,r0
1:
	mov.b	@(r0,r1),r4
	add	#1,r0
	extu.b	r4,r4
	mov.b	@(r0,r1),r5
	extu.b	r5,r0
	shll8	r0
	rts
	or	r4,r0

	.align	2
200:	.long	VRAM_STEP
i286w_wb:
	mov.b	@(CPU_ITFBANK,gbr),r0
	extu.b	r0,r6
	mov	r4,r0
	tst	#1,r0
	bf/s	i286w_wb_odd
	tst	r6,r6
	bt/s	1f
	mov	r4,r0
	mov.l	200f,r3
	add	r3,r0
1:
	rts
	mov.w	r5,@(r0,r1)

	.align	2
200:	.long	(0x1c8000 - 0x0e8000)
i286w_wb_odd:
	bt/s	1f
	mov	r4,r0
	mov.l	200f,r3
	or	r3,r0
1:
	mov.b	r5,@(r0,r1)
	add	#1,r0
	shlr8	r5
	rts
	mov.b	r5,@(r0,r1)

	.align	2
200:	.long	(0x1c8000 - 0x0e8000)


! ---- other

i286_nonram_rw:
	mov	#0xff,r0
	extu.w	r0,r0
	rts
	or	r4,r0
i286_nonram_r:
	mov	#0xff,r0
	rts
	extu.b	r0,r0
i286w_wn:	
i286_wn:
	rts
	nop


! ---- dispatch

_i286_memorymap:
	stc.l	gbr,@-r15
	mov.l	i2mm_memfn,r7
	mov	#1,r5
	ldc	r7,gbr
	and	r4,r5
	mova	 mmaptbl,r0
	mov	r5,r2
	mov	#5,r3
	shld	r3,r2
	add	r0,r2
	shld	r3,r5
	mov.l	@(r0,r5),r0
	mov.l	@(4,r2),r6
	mov.l	r0,@(((0 * 32) + (0xe8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((0 * 32) + (0xf0000 >> (15 - 2))),gbr)
	mov	r6,r0
	mov.l	r0,@(((0 * 32) + (0xf8000 >> (15 - 2))),gbr)
	mov.l	@(8,r2),r0
	mov.l	@(12,r2),r6
	mov.l	r0,@(((4 * 32) + (0xd0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((4 * 32) + (0xd8000 >> (15 - 2))),gbr)
	mov	r6,r0
	mov.l	r0,@(((4 * 32) + (0xe8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((4 * 32) + (0xf0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((4 * 32) + (0xf8000 >> (15 - 2))),gbr)
	mov.l	@(16,r2),r0
	mov.l	@(20,r2),r6
	mov.l	r0,@(((8 * 32) + (0xe8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((8 * 32) + (0xf0000 >> (15 - 2))),gbr)
	mov	r6,r0
	mov.l	r0,@(((8 * 32) + (0xf8000 >> (15 - 2))),gbr)
	mov.l	@(24,r2),r0
	mov.l	@(28,r2),r6
	
	mov.l	r0,@(((12 * 32) + (0xd0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((12 * 32) + (0xd8000 >> (15 - 2))),gbr)
	mov	r6,r0
	mov.l	r0,@(((12 * 32) + (0xe8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((12 * 32) + (0xf0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((12 * 32) + (0xf8000 >> (15 - 2))),gbr)
	rts
	ldc.l	@r15+,gbr

	.align 2
i2mm_memfn:	.long		memfn

mmaptbl:	.long		i286_rd		! NEC
				.long		i286_rb
				.long		i286_wn
				.long		i286_wn
				.long		i286w_rd
				.long		i286w_rb
				.long		i286_wn
				.long		i286_wn
				.long		i286_rb		! EPSON
				.long		i286_rb
				.long		i286_wt
				.long		i286_wb
				.long		i286w_rb
				.long		i286w_rb
				.long		i286w_wt
				.long		i286w_wb


_i286_vram_dispatch:
	stc.l	gbr,@-r15
	mov.l	i2vd_memfn,r7
	mov	#15,r5
	ldc	r7,gbr
	and	r4,r5
	mova	vacctbl,r0
	mov	#4,r3
	mov	r0,r6
	shld	r3,r5
	add	r5,r6
	mov.l	@r6,r5
	mov.l	@(4,r6),r2
	mov	r4,r0
	tst	#0x10,r0
	mov	r5,r0
	mov.l	r0,@(((0 * 32) + (0xa8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((0 * 32) + (0xb0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((0 * 32) + (0xb8000 >> (15 - 2))),gbr)
	mov	r2,r0
	bt/s	1f
	mov.l	r0,@(((4 * 32) + (0xa8000 >> (15 - 2))),gbr)
	mov	r5,r0
	mov.l	r0,@(((0 * 32) + (0xe0000 >> (15 - 2))),gbr)
1:
	mov.l	@(8,r6),r5
	mov	r2,r0
	mov.l	r0,@(((4 * 32) + (0xb0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((4 * 32) + (0xb8000 >> (15 - 2))),gbr)
	mov	r5,r0
	bt/s	2f
	mov.l	r0,@(((8 * 32) + (0xa8000 >> (15 - 2))),gbr)
	mov	r2,r0
	mov.l	r0,@(((4 * 32) + (0xe0000 >> (15 - 2))),gbr)
2:	
	mov.l	@(12,r6),r2
	mov	r5,r0
	mov.l	r0,@(((8 * 32) + (0xb0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((8 * 32) + (0xb8000 >> (15 - 2))),gbr)
	mov	r2,r0
	mov.l	r0,@(((12 * 32) + (0xa8000 >> (15 - 2))),gbr)
	mov.l	r0,@(((12 * 32) + (0xb0000 >> (15 - 2))),gbr)
	bt/s	3f
	mov.l	r0,@(((12 * 32) + (0xb8000 >> (15 - 2))),gbr)

	mov.l	r0,@(((12 * 32) + (0xe0000 >> (15 - 2))),gbr)
	mov	r5,r0
	mov.l	r0,@(((8 * 32) + (0xe0000 >> (15 - 2))),gbr)
	rts
	ldc.l	@r15+,gbr
3:
	mov.l	300f,r0
	mov.l	301f,r6
	mov.l	r0,@(((0 * 32) + (0xe0000 >> (15 - 2))),gbr)
	mov.l	302f,r7
	mov	r6,r0
	mov.l	r0,@(((4 * 32) + (0xe0000 >> (15 - 2))),gbr)
	mov.l	r0,@(((12 * 32) + (0xe0000 >> (15 - 2))),gbr)
	mov	r7,r0
	mov.l	r0,@(((8 * 32) + (0xe0000 >> (15 - 2))),gbr)
	rts
	ldc.l	@r15+,gbr

	.align	2
i2vd_memfn:	.long		memfn
300:	.long	i286_nonram_r
301:	.long	i286_wn	
302:	.long	i286_nonram_rw

vacctbl:	.long		vram_r0			! 00
				.long		vram_w0
				.long		vramw_r0
				.long		vramw_w0
				.long		vram_r1			! 10
				.long		vram_w1
				.long		vramw_r1
				.long		vramw_w1
				.long		vram_r0			! 20
				.long		vram_w0
				.long		vramw_r0
				.long		vramw_w0
				.long		vram_r1			! 30
				.long		vram_w1
				.long		vramw_r1
				.long		vramw_w1
				.long		vram_r0			! 40
				.long		vram_w0
				.long		vramw_r0
				.long		vramw_w0
				.long		vram_r1			! 50
				.long		vram_w1
				.long		vramw_r1
				.long		vramw_w1
				.long		vram_r0			! 60
				.long		vram_w0
				.long		vramw_r0
				.long		vramw_w0
				.long		vram_r1			! 70
				.long		vram_w1
				.long		vramw_r1
				.long		vramw_w1
				.long		grcg_tcr0		! 80
				.long		grcg_tdw0
				.long		grcgw_tcr0
				.long		grcgw_tdw0
				.long		grcg_tcr1		! 90
				.long		grcg_tdw1
				.long		grcgw_tcr1
				.long		grcgw_tdw1
				.long		egc_rd			! a0
				.long		egc_wt
				.long		egcw_rd
				.long		egcw_wt
				.long		egc_rd			! b0
				.long		egc_wt
				.long		egcw_rd
				.long		egcw_wt
				.long		vram_r0			! c0
				.long		grcg_rmw0
				.long		vramw_r0
				.long		grcgw_rmw0
				.long		vram_r1			! d0
				.long		grcg_rmw1
				.long		vramw_r1
				.long		grcgw_rmw1
				.long		egc_rd			! e0
				.long		egc_wt
				.long		egcw_rd
				.long		egcw_wt
				.long		egc_rd			! f0
				.long		egc_wt
				.long		egcw_rd
				.long		egcw_wt

	.end
	
