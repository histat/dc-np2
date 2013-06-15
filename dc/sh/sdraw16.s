
	.include	"../dc/sh/sdraw.inc"
	.extern		_np2_pal16
	.globl		_sdraw_getproctbl

	.text
	.align	2

sdraw16p_0:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	pal16_0,r3
	mov.l	@(S_SRC,r4),r10
	mov.l	@(S_DST,r4),r11
	mov.l	@(S_WIDTH,r4),r12
	mov.l	@(S_Y,r4),r8
	mov.l	@(S_YALIGN,r4),r9
	mov.w	@r3,r3
	mov.l	200f,r7
	mov	r4,r0
	add	#S_HDRSIZE,r0
putylp_0:
	mov.b	@(r0,r8),r2
	tst	r2,r2
	bt/s	putyed_0
	mov	#0,r6
	mov	r11,r2
putxlp_0:
	add	#2,r6
	mov.w	r3,@r2
	add	#2,r2
	cmp/hs	r12,r6
	mov.w	r3,@r2
	bf/s	putxlp_0
	add	#2,r2
putyed_0:
	add	#1,r8
	add	r7,r10
	cmp/hs	r5,r8
	bf/s	putylp_0
	add	r9,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	SURFACE_WIDTH
pal16_0:	.long		_np2_pal16 + (NP2PAL_TEXT2 * 2)


sdraw16p_1:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_1,r1	
	mov.l	@(S_Y,r4),r9
	mov.l	@(S_YALIGN,r4),r3
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_DST,r4),r12
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r9),r2
putylp_1:
	tst	r2,r2
	bt/s	putyed_1
	mov	#0,r6
	mov.l	@r11,r10		! r2 = 0
	mov	r12,r13
putxlp_1:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	putyed_1
	add	#2,r13
	mov	r6,r0
	bra	putxlp_1
	mov.l	@(r0,r11),r10
putyed_1:
	mov.l	200f,r0
	add	#1,r9
	add	r0,r11
	cmp/hs	r5,r9
	bt/s	2f
	add	r3,r12
	mov	r7,r0
	bra	putylp_1
	mov.b	@(r0,r9),r2
2:	
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	SURFACE_WIDTH
pal16_1:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_2:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_2,r1
	mov.l	@(S_Y,r4),r8
	mov.l	@(S_YALIGN,r4),r9
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_SRC2,r4),r12
	mov.l	@(S_DST,r4),r13
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r8),r2
putylp_2:
	tst	r2,r2
	bt/s	putyed_2		! r2 = 0
	mov	#0,r6
	mov.l	@r11,r2
	mov.l	@r12,r3
	mov	r13,r10
putxlp_2:
	or	r2,r3
	extu.b	r3,r9
	shlr8	r3
	extu.b	r3,r2
	shll	r9
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	add	#2,r10
	shlr8	r3
	extu.b	r3,r9
	shlr8	r3
	shll	r9
	shll	r3
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r3),r2
	cmp/hs	r14,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	bt/s	1f
	add	#2,r10
	mov	r6,r0
	mov.l	@(r0,r11),r2
	bra	putxlp_2
	mov.l	@(r0,r12),r3
1:	
	mov.l	@(S_YALIGN,r4),r9
putyed_2:
	mov.l	200f,r0
	add	#1,r8
	add	r0,r11
	add	r0,r12
	cmp/hs	r5,r8
	bt/s	2f
	add	r9,r13
	mov	r7,r0
	bra	putylp_2
	mov.b	@(r0,r8),r2
2:	
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	SURFACE_WIDTH
pal16_2:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_ti:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_ti,r1
	mov.l	@(S_Y,r4),r9
	mov.l	@(S_YALIGN,r4),r3
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_DST,r4),r12
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r9),r2
putylp_ti:
	tst	r2,r2
	bt/s	putyod_ti
	mov	#0,r6
	mov.l	@r11,r10		! r2 = 0
	mov	r12,r13
putexlp_ti:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	putyod_ti
	add	#2,r13
	mov	r6,r0
	bra	putexlp_ti
	mov.l	@(r0,r11),r10
putyod_ti:
	add	#1,r9
	mov	r7,r0
	mov.b	@(r0,r9),r2
	mov.l	200f,r0
	add	r0,r11
	tst	r2,r2
	bt/s	putyed_ti
	add	r3,r12
	mov	r12,r13
	mov.l	@r11,r10		! r2 = 0
	mov	#0,r6
	add	#-((NP2PAL_GRPH - NP2PAL_TEXT) << 1),r1
putoxlp_ti:
	extu.b	r10,r0
	and	#0xf0,r0
	mov	#-3,r8
	shld	r8,r0
	mov.w	@(r0,r1),r8
	shlr8	r10
	extu.b	r10,r0
	and	#0xf0,r0
	mov	#-3,r2
	shld	r2,r0
	mov.w	@(r0,r1),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r0
	and	#0xf0,r0
	mov	#-3,r8
	shld	r8,r0
	mov.w	@(r0,r1),r8
	shlr8	r10
	extu.b	r10,r0
	and	#0xf0,r0
	mov	#-3,r2
	shld	r2,r0
	mov.w	@(r0,r1),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	1f
	add	#2,r13
	mov	r6,r0
	bra	putoxlp_ti
	mov.l	@(r0,r11),r10
1:
	add	#((NP2PAL_GRPH - NP2PAL_TEXT) << 1),r1
putyed_ti:
	mov.l	200f,r0
	add	#1,r9
	add	r0,r11
	cmp/hs	r5,r9
	bt/s	2f
	add	r3,r12
	mov	r7,r0
	bra	putylp_ti
	mov.b	@(r0,r9),r2
2:	
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

		.align 2
200:	.long	SURFACE_WIDTH
pal16_ti:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_gi:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_gi,r1
	mov.l	@(S_Y,r4),r9
	mov.l	@(S_YALIGN,r4),r3
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_DST,r4),r12
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r9),r2
putylp_gi:
	tst	r2,r2
	bt/s	putyod_gi
	mov	#0,r6
	mov.l	@r11,r10		! r2 = 0
	mov	r12,r13
putexlp_gi:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	putyod_gi
	add	#2,r13
	mov	r6,r0
	bra	putexlp_gi
	mov.l	@(r0,r11),r10
putyod_gi:
	add	#1,r9
	mov	r7,r0
	mov.b	@(r0,r9),r2
	tst	r2,r2
	bt/s	putyed_gi
	add	r3,r12
	mov	#((NP2PAL_TEXT - NP2PAL_GRPH) << 1),r0
	mov.w	@(r0,r1),r8
	mov	r12,r13
	mov	#0,r6
putoxlp_gi:
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r8,@r13
	cmp/hs	r14,r6
	bf/s	putoxlp_gi
	add	#2,r13
putyed_gi:
	add	#1,r9
	mov.l	200f,r0
	add	r0,r11
	cmp/hs	r5,r9
	bt/s	2f
	add	r3,r12
	mov	r7,r0
	bra	putylp_gi
	mov.b	@(r0,r9),r2
2:
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8
	
	.align 2
200:	.long	(SURFACE_WIDTH * 2)
pal16_gi:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_2i:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_2i,r1
	mov.l	@(S_Y,r4),r8
	mov.l	@(S_YALIGN,r4),r9
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_SRC2,r4),r12
	mov.l	@(S_DST,r4),r13
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r8),r2
putylp_2i:
	tst	r2,r2
	bt/s	putyod_2i
	mov	#0,r6
	mov.l	@r11,r2		! r2 = 0
	mov.l	@r12,r3		! r2 = 0
	mov	r13,r10
putexlp_2i:
	or	r2,r3
	extu.b	r3,r9
	shlr8	r3
	extu.b	r3,r2
	shll	r9
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	add	#2,r10
	shlr8	r3
	extu.b	r3,r9
	shlr8	r3
	shll	r9
	shll	r3
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r3),r2
	cmp/hs	r14,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	bt/s	1f
	add	#2,r10
	mov	r6,r0
	mov.l	@(r0,r11),r2
	bra	putexlp_2i
	mov.l	@(r0,r12),r3
1:
	mov.l	@(S_YALIGN,r4),r9
putyod_2i:
	add	#1,r8
	mov	r7,r0
	mov.b	@(r0,r8),r2
	mov.l	200f,r0
	tst	r2,r2
	add	r9,r13
	bt/s	putyed_2i
	add	r0,r12
	mov	#0,r6
	mov.l	@r12,r3		! r2 = 0
	mov	r13,r10
	add	#-((NP2PAL_GRPH - NP2PAL_TEXT) << 1),r1
putoxlp_2i:
	mov	r3,r0
	and	#0xf0,r0
	mov	#-3,r9
	shld	r9,r0
	mov.w	@(r0,r1),r9
	shlr8	r3
	mov	r3,r0
	and	#0xf0,r0
	mov	#-3,r2
	shld	r2,r0
	mov.w	@(r0,r1),r2
	add	#4,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	add	#2,r10
	shlr8	r3
	mov	r3,r0
	and	#0xf0,r0
	mov	#-3,r9
	shld	r9,r0
	mov.w	@(r0,r1),r9
	shlr8	r3
	mov	r3,r0
	and	#0xf0,r0
	mov	#-3,r2
	shld	r2,r0
	mov.w	@(r0,r1),r2
	cmp/hs	r14,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	bt/s	2f
	add	#2,r10
	mov	r6,r0
	bra	putoxlp_2i
	mov.l	@(r0,r12),r3
2:
	mov.l	@(S_YALIGN,r4),r9
	add	#((NP2PAL_GRPH - NP2PAL_TEXT) << 1),r1
putyed_2i:
	mov.l	200f,r0
	add	#1,r8
	add	r0,r12
	shll	r0
	add	r0,r11
	cmp/hs	r5,r8
	bt/s	3f
	add	r9,r13
	mov	r7,r0
	bra	putylp_2i
	mov.b	@(r0,r8),r2
3:
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.align 2
200:	.long	SURFACE_WIDTH
pal16_2i:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_gie:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_gie,r1
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_DST,r4),r12
	mov.l	@(S_WIDTH,r4),r14
	mov.l	@(S_Y,r4),r9
	mov.l	@(S_YALIGN,r4),r3
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r9),r2
putylp_gie:
	add	#1,r9
	tst	r2,r2
	bt/s	putyod_gie
	mov	#0,r6
	mov.b	r2,@(r0,r9)
	mov.l	@r11,r10		! r2 = 0
	mov	r12,r13
putexlp_gie:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	putyod_gie
	add	#2,r13
	mov	r6,r0
	bra	putexlp_gie
	mov.l	@(r0,r11),r10
putyod_gie:
	mov	r7,r0
	mov.b	@(r0,r9),r2
	tst	r2,r2
	bt/s	putyed_gie
	add	r3,r12
	mov	r12,r13
	mov.l	@r11,r10	! r2 = 0
	mov	#0,r6
	add	#-((NP2PAL_GRPH - NP2PAL_SKIP) << 1),r1
putoxlp_gie:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	1f
	add	#2,r13
	mov	r6,r0
	bra	putoxlp_gie
	mov.l	@(r0,r11),r10
1:
	add	#((NP2PAL_GRPH - NP2PAL_SKIP) << 1),r1
putyed_gie:
	mov.l	200f,r0
	add	#1,r9
	add	r0,r11
	cmp/hs	r5,r9
	bt/s	2f
	add	r3,r12
	mov	r7,r0
	bra	putylp_gie
	mov.b	@(r0,r9),r2
2:	
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8
	
	.align 2
200:	.long	(SURFACE_WIDTH * 2)
pal16_gie:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


sdraw16p_2ie:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_2ie,r1
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_SRC2,r4),r12
	mov.l	@(S_DST,r4),r13
	mov.l	@(S_WIDTH,r4),r14
	mov.l	@(S_Y,r4),r8
	mov.l	@(S_YALIGN,r4),r9
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r8),r2
putylp_2ie:
	tst	r2,r2
	bt/s	putyod_2ie
	add	#1,r8
	mov	r7,r0
	mov.b	r2,@(r0,r8)
	mov.l	@r12,r3		! r2 = 0
	mov.l	@r11,r2		! r2 = 0
	mov	#0,r6
	mov	r13,r10		
putexlp_2ie:
	or	r2,r3
	extu.b	r3,r9
	shlr8	r3
	extu.b	r3,r2
	shll	r9
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	add	#2,r10
	shlr8	r3
	extu.b	r3,r9
	shlr8	r3
	shll	r9
	shll	r3
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r3),r2
	cmp/hs	r14,r6
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	bt/s	1f
	add	#2,r10
	mov	r6,r0
	mov.l	@(r0,r12),r3
	bra	putexlp_2ie
	mov.l	@(r0,r11),r2
1:
	mov.l	@(S_YALIGN,r4),r9
putyod_2ie:
	mov	r7,r0
	mov.b	@(r0,r8),r2
	mov.l	200f,r0
	tst	r2,r2
	add	r0,r12
	bt/s	putyed_2ie
	add	r9,r13
	mov	#0,r6
	mov.l	r13,@(S_DST,r4)
	add	#-((NP2PAL_GRPH - (NP2PALS_TXT + NP2PAL_TEXT)) << 1),r1
	mov.l	@r12,r3			! r2 = 0
putoxlp_2ie:
	mov	r6,r0
	mov.l	@(r0,r11),r2
	mov	r3,r0
	and	#0xf0,r0
	tst	r0,r0
	bt	1f
	mov	#-3,r9
	shld	r9,r0
	mov	r0,r9
	bra	2f
	add	#-(NP2PALS_TXT << 1),r9
1:
	mov	#0x0f,r9
	and	r2,r9
	shll	r9
2:	
	shlr8	r3
	shlr8	r2
	mov	r3,r0
	and	#0xf0,r0
	tst	r0,r0
	add	r1,r9
	bt/s	3f
	mov.w	@r9,r9
	mov	r0,r10
	mov	#-3,r0
	shld	r0,r10
	bra	4f
	add	#-(NP2PALS_TXT << 1),r10
3:
	mov	#0x0f,r10
	and	r2,r10
	shll	r10
4:	
	mov.w	r9,@r13
	add	#2,r13
	shlr8	r3
	shlr8	r2
	mov	r3,r0
	and	#0xf0,r0
	tst	r0,r0
	add	r1,r10
	bt/s	5f
	mov.w	@r10,r10
	mov	r0,r9
	mov	#-3,r0
	shld	r0,r9
	bra	6f
	add	#-(NP2PALS_TXT << 1),r9
5:
	mov	#0x0f,r9
	and	r2,r9
	shll	r9
6:
	mov.w	r10,@r13
	add	#2,r13
	shlr8	r3
	shlr8	r2
	mov	r3,r0
	and	#0xf0,r0
	tst	r0,r0
	add	r1,r9
	bt/s	7f
	mov.w	@r9,r9
	mov	r0,r10
	mov	#-3,r0
	shld	r0,r10
	bra	8f
	add	#-(NP2PALS_TXT << 1),r10
7:
	mov	#0x0f,r10
	and	r2,r10
	shll	r10
8:
	add	r1,r10
	mov.w	@r10,r10
	mov.w	r9,@r13
	add	#2,r13
	add	#4,r6
	mov.w	r10,@r13
	cmp/hs	r14,r6
	bt/s	9f
	add	#2,r13
	mov	r6,r0
	bra	putoxlp_2ie
	mov.l	@(r0,r12),r3
9:
	mov.l	@(S_YALIGN,r4),r9
	mov.l	@(S_DST,r4),r13
	add	#((NP2PAL_GRPH - (NP2PALS_TXT + NP2PAL_TEXT)) << 1),r1
putyed_2ie:
	mov.l	200f,r0
	add	#1,r8
	add	r0,r12
	shll	r0
	add	r0,r11
	cmp/hs	r5,r8
	bt/s	10f
	add	r9,r13
	mov	r7,r0
	bra	putylp_2ie
	mov.b	@(r0,r8),r2
10:	
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.align 2
200:	.long	SURFACE_WIDTH
pal16_2ie:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)

sdraw16p_1d:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_1d,r1
	mov.l	@(S_Y,r4),r9
	mov.l	@(S_YALIGN,r4),r3
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_DST,r4),r12
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r9),r2
putylp_1d:
	tst	r2,r2
	bt/s	putyed_1d
	mov	#0,r6
	mov.l	r12,@(S_DST,r4)
	mov.l	@r11,r10		! r2 = 0
	mov	r12,r13
	add	r3,r13
putxlp_1d:
	extu.b	r10,r8
	shlr8	r10
	extu.b	r10,r2
	shll	r8
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r8,@r12
	add	#2,r12
	mov.w	r2,@r12
	add	#2,r12
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	shlr8	r10
	extu.b	r10,r8
	shlr8	r10
	shll	r8
	shll	r10
	mov.w	@(r0,r8),r8
	mov.w	@(r0,r10),r2
	cmp/hs	r14,r6
	mov.w	r8,@r12
	add	#2,r12
	mov.w	r2,@r12
	add	#2,r12
	mov.w	r8,@r13
	add	#2,r13
	mov.w	r2,@r13
	bt/s	1f
	add	#2,r13
	mov	r6,r0
	bra	putxlp_1d
	mov.l	@(r0,r11),r10
1:
	mov.l	@(S_DST,r4),r12	
putyed_1d:
	mov.l	200f,r0
	add	#1,r9
	add	r0,r11
	mov	r3,r0
	shll	r0
	cmp/hs	r5,r9
	bt/s	2f
	add	r0,r12
	mov	r7,r0
	bra	putylp_1d
	mov.b	@(r0,r9),r2
2:
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8
	
	.align 2
200:	.long	SURFACE_WIDTH	
pal16_1d:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)

sdraw16p_2d:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	pal16_2d,r1
	mov.l	@(S_Y,r4),r8
	mov.l	@(S_YALIGN,r4),r9
	mov.l	@(S_SRC,r4),r11
	mov.l	@(S_SRC2,r4),r12
	mov.l	@(S_DST,r4),r13
	mov.l	@(S_WIDTH,r4),r14
	mov	r4,r7
	add	#S_HDRSIZE,r7
	mov	r7,r0
	mov.b	@(r0,r8),r2
putylp_2d:
	tst	r2,r2
	bt/s	putyed_2d
	mov	#0,r6
	mov.l	@r11,r2			! r2 = 0
	mov.l	@r12,r3
	mov.l	r13,@(S_DST,r4)
	mov	r9,r10
	add	r13,r10
putxlp_2d:
	or	r2,r3
	extu.b	r3,r9
	shlr8	r3
	extu.b	r3,r2
	shll	r9
	shll	r2
	mov	r1,r0
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r2),r2
	add	#4,r6
	mov.w	r9,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	add	#2,r10
	shlr8	r3
	extu.b	r3,r9
	shlr8	r3
	shll	r9
	shll	r3
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r3),r2
	cmp/hs	r14,r6
	mov.w	r9,@r13
	add	#2,r13
	mov.w	r2,@r13
	add	#2,r13
	mov.w	r9,@r10
	add	#2,r10
	mov.w	r2,@r10
	bt/s	2f
	add	#2,r10
	mov	r6,r0
	mov.l	@(r0,r11),r2
	bra	putxlp_2d
	mov.l	@(r0,r12),r3
2:
	mov.l	@(S_YALIGN,r4),r9
	mov.l	@(S_DST,r4),r13
putyed_2d:
	mov.l	200f,r0
	add	#1,r8
	add	r0,r11
	add	r0,r12
	mov	r9,r0
	shll	r0
	cmp/hs	r5,r8
	bt/s	3f
	add	r0,r13
	mov	r7,r0
	bra	putylp_2d
	mov.b	@(r0,r8),r2
3:
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.align 2
200:	.long	SURFACE_WIDTH
pal16_2d:	.long		_np2_pal16 + (NP2PAL_GRPH * 2)


_sdraw_getproctbl:
	mova	1000f,r0
	rts
	nop
	
	.align	2
1000:	
	.long		sdraw16p_0
	.long		sdraw16p_1
	.long		sdraw16p_1
	.long		sdraw16p_2
	.long		sdraw16p_0
	.long		sdraw16p_ti
	.long		sdraw16p_gi
	.long		sdraw16p_2i
	.long		sdraw16p_0
	.long		sdraw16p_ti
	.long		sdraw16p_gie
	.long		sdraw16p_2ie
	.long		sdraw16p_0
	.long		sdraw16p_1d
	.long		sdraw16p_1d
	.long		sdraw16p_2d
	
	.end

