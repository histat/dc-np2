
		.include	"sh/sdraw.inc"
		.globl		_sdraw_getproctbl

		.text
		.align	2

		
sdraw8p_0:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	@(S_SRC,r4),r10
		mov.l	@(S_DST,r4),r11
		mov.l	@(S_WIDTH,r4),r12
		mov.l	@(S_Y,r4),r8
		mov.l	@(S_YALIGN,r4),r9
		mov.l	200f,r7
		mov.l	pal8_0,r3
		mov		r4,r6
		add		#S_HDRSIZE,r6
		add		r8,r6
putylp_0:
		mov.b	@r6+,r2
		tst		r2,r2
		bt/s	putyed_0
		mov		#0,r0
		mov		r11,r2
putxlp_0:
		add		#4,r0
		mov.l	r3,@r2
		cmp/hs	r12,r0
		bf/s	putxlp_0
		add		#4,r2
putyed_0:
		add		#1,r8
		add		r7,r10
		cmp/hs	r5,r8
		bf/s	putylp_0
		add		r9,r11
		mov.l	@r15+,r12
		mov.l	@r15+,r11
		mov.l	@r15+,r10
		mov.l	@r15+,r9
		rts
		mov.l	@r15+,r8

		.align	2
200:	.long	SURFACE_WIDTH
pal8_0:	.long	(NP2PAL_TEXT2 << 24)|(NP2PAL_TEXT2 << 16)|(NP2PAL_TEXT2 << 8)|NP2PAL_TEXT2

sdraw8p_1:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_1,r1		
		mov.l	@(S_Y,r4),r9
		mov.l	@(S_YALIGN,r4),r3
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_DST,r4),r12
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r9,r7
putylp_1:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_1
		mov		#0,r0
		mov		r12,r13
putxlp_1:
		mov.l	@(r0,r11),r10
		add		r1,r10
		add		#4,r0
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putxlp_1
		add		#4,r13
putyed_1:
		mov.l	200f,r0
		add		#1,r9
		add		r0,r11
		cmp/hs	r5,r9
		bf/s	putylp_1
		add		r3,r12
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
pal8_1:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH
		

sdraw8p_2:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_2,r1
		mov.l	@(S_Y,r4),r8
		mov.l	@(S_YALIGN,r4),r9
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_SRC2,r4),r12
		mov.l	@(S_DST,r4),r13
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r8,r7
putylp_2:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_2		! r2 = 0
		mov		#0,r0
		mov		r13,r10
putxlp_2:
		mov.l	@(r0,r11),r2
		mov.l	@(r0,r12),r3
		or		r2,r3
		add		r1,r3
		add		#4,r0
		mov.l	r3,@r10
		cmp/hs	r14,r0
		bf/s	putxlp_2
		add		#4,r10
		mov.l	@(S_YALIGN,r4),r9
putyed_2:
		mov.l	200f,r0
		add		#1,r8
		add		r0,r11
		add		r0,r12
		cmp/hs	r5,r8
		bf/s	putylp_2
		add		r9,r13
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
pal8_2:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH

		! text + (grph:interleave)
sdraw8p_ti:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_ti,r1
		mov.l	@(S_Y,r4),r9
		mov.l	@(S_YALIGN,r4),r3
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_DST,r4),r12
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r9,r7
putylp_ti:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyod_ti
		mov		#0,r0
		mov		r12,r13
putexlp_ti:
		mov.l	@(r0,r11),r10
		add		r1,r10
		add		#4,r0
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putexlp_ti
		add		#4,r13
putyod_ti:
		add		#1,r9
		mov.b	@r7+,r2
		mov.l	200f,r0
		add		r0,r11
		tst		r2,r2
		bt/s	putyed_ti
		add		r3,r12
		mov		r12,r13
		mov		#0,r0
!		add		#-(NP2PAL_GRPH - NP2PAL_TEXT),r1
		mov.l	500f,r6
		mov		#-4,r8
putoxlp_ti:
		mov.l	@(r0,r11),r10
		and		r6,r10
		shld	r8,r10
		mov.l	r10,@r13
		add		#4,r0
		cmp/hs	r14,r0
		bf/s	putoxlp_ti
		add		#4,r13
!		add		#(NP2PAL_GRPH - NP2PAL_TEXT),r1
putyed_ti:
		mov.l	200f,r0
		add		#1,r9
		add		r0,r11
		cmp/hs	r5,r9
		bf/s	putylp_ti
		add		r3,r12
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
pal8_ti:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH
500:		.long	0xf0f0f0f0

sdraw8p_gi:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_gi,r1
		mov.l	@(S_Y,r4),r9
		mov.l	@(S_YALIGN,r4),r3
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_DST,r4),r12
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r9,r7
putylp_gi:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyod_gi
		mov		#0,r0
		mov		r12,r13
putexlp_gi:
		mov.l	@(r0,r11),r10
		add		r1,r10
		add		#4,r0
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putexlp_gi
		add		#4,r13
putyod_gi:
		add		#1,r9
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_gi
		add		r3,r12
!		mov		#(NP2PAL_TEXT - NP2PAL_GRPH),r0
		mov		#0,r8		!NP2PAL_TEXT
		mov		r12,r13
		mov		#0,r0
putoxlp_gi:
		add		#4,r0
		mov.l	r8,@r13
		cmp/hs	r14,r0
		bf/s	putoxlp_gi
		add		#4,r13
putyed_gi:
		add		#1,r9
		mov.l	200f,r0
		add		r0,r11
		cmp/hs	r5,r9
		bf/s	putylp_gi
		add		r3,r12
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
pal8_gi:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH

sdraw8p_2i:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_2i,r1
		mov.l	@(S_Y,r4),r8
		mov.l	@(S_YALIGN,r4),r9
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_SRC2,r4),r12
		mov.l	@(S_DST,r4),r13
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r8,r7
putylp_2i:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyod_2i
		mov		#0,r0
		mov		r13,r10
putexlp_2i:
		mov.l	@(r0,r11),r2
		mov.l	@(r0,r12),r3
		or		r2,r3
		add		r1,r3
		add		#4,r0
		mov.l	r3,@r10
		cmp/hs	r14,r0
		bf/s	putexlp_2i
		add		#4,r10
putyod_2i:
		add		#1,r8
		mov.b	@r7+,r2
		mov.l	200f,r0
		tst		r2,r2
		add		r9,r13
		bt/s	putyed_2i
		add		r0,r12
		mov		#0,r0
		mov		r13,r10
!		add		#-(NP2PAL_GRPH - NP2PAL_TEXT),r1
		mov.l	500f,r6
		mov		#-4,r2
putoxlp_2i:
		mov.l	@(r0,r12),r3
		and		r6,r3
		shld	r2,r3
		add		#4,r0
		mov.l	r3,@r10
		cmp/hs	r14,r0
		bf/s	putoxlp_2i
		add		#4,r10
!		add		#(NP2PAL_GRPH - NP2PAL_TEXT),r1
putyed_2i:
		mov.l	200f,r0
		add		#1,r8
		add		r0,r12
		shll	r0
		add		r0,r11
		cmp/hs	r5,r8
		bf/s	putylp_2i
		add		r9,r13
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
pal8_2i:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH
500:		.long	0xf0f0f0f0


sdraw8p_gie:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_gie,r1
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_DST,r4),r12
		mov.l	@(S_WIDTH,r4),r14
		mov.l	@(S_Y,r4),r9
		mov.l	@(S_YALIGN,r4),r3
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r9,r7
		mov.l	501f,r8
putylp_gie:
		mov.b	@r7+,r2
		add		#1,r9
		tst		r2,r2
		bt/s	putyod_gie
		mov		#0,r0
		mov.b	r2,@r7
		mov		r12,r13
putexlp_gie:
		mov.l	@(r0,r11),r10
		add		r1,r10
		add		#4,r0
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putexlp_gie
		add		#4,r13
putyod_gie:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_gie
		add		r3,r12
		mov		r12,r13
		mov		#0,r0
!		add		#-(NP2PAL_GRPH - NP2PAL_SKIP),r1
putoxlp_gie:
		mov.l	@(r0,r11),r10
		add		r8,r10
		add		#4,r0
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putoxlp_gie
		add		#4,r13
!		add		#(NP2PAL_GRPH - NP2PAL_SKIP),r1
putyed_gie:
		mov.l	200f,r0
		add		#1,r9
		add		r0,r11
		cmp/hs	r5,r9
		bf/s	putylp_gie
		add		r3,r12
		mov		r7,r0
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
pal8_gie:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH
501:	.long (NP2PAL_SKIP << 24)|(NP2PAL_SKIP << 16)|(NP2PAL_SKIP << 8)|(NP2PAL_SKIP)
		
		!bug 
sdraw8p_2ie:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_2ie,r1
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_SRC2,r4),r12
		mov.l	@(S_DST,r4),r13
		mov.l	@(S_WIDTH,r4),r14
		mov.l	@(S_Y,r4),r8
		mov.l	@(S_YALIGN,r4),r9
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r8,r7
putylp_2ie:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyod_2ie
		add		#1,r8
		mov.b	r2,@r7
		mov		#0,r0
		mov		r13,r10		
putexlp_2ie:
		mov.l	@(r0,r12),r3
		mov.l	@(r0,r11),r2
		or		r2,r3
		add		r1,r3
		add		#4,r0
		mov.l	r3,@r10
		cmp/hs	r14,r0
		bf/s	putexlp_2ie
		add		#4,r10
putyod_2ie:
		mov.b	@r7+,r2
		mov.l	200f,r0
		tst		r2,r2
		add		r0,r12
		bt/s	putyed_2ie
		add		r9,r13
		mov		#0,r0
		mov.l	r13,@(S_DST,r4)
!		add		#-(NP2PAL_GRPH - (NP2PALS_TXT + NP2PAL_TEXT)),r1
putoxlp_2ie:
		mov.l	400f,r10
		mov		#-4,r9
		mov.l	@(r0,r11),r2
		mov.l	@(r0,r12),r3
		mov.l	500f,r6
		and		r6,r3
		shld	r9,r6
		and		r6,r2
		shld	r9,r3
		extu.b	r3,r6
		tst		r6,r6
		bt/s	1f
		shlr8	r3
		mov.l	600f,r9
		and		r9,r10
		and		r9,r2
		or		r6,r2
1:
		extu.b	r3,r6
		tst		r6,r6
		bt/s	2f
		shlr8	r3
		mov.l	601f,r9
		and		r9,r10
		and		r9,r2
		shll8	r6
		or		r6,r2
2:
		extu.b	r3,r6
		tst		r6,r6
		bt/s	3f
		shlr8	r3
		mov.l	602f,r9
		and		r9,r10
		and		r9,r2
		shll16	r6
		or		r6,r2
3:
		extu.b	r3,r6
		tst		r6,r6
		bt/s	4f
		add		#4,r0
		mov.l	603f,r9
		and		r9,r10
		and		r9,r2
		shll16	r6
		shll8	r6
		or		r6,r2
4:
		add		r10,r2
		mov.l	r2,@r13
		cmp/hs	r14,r0
		bf/s	putoxlp_2ie
		add		#4,r13
		mov.l	@(S_YALIGN,r4),r9
		mov.l	@(S_DST,r4),r13
!		add		#(NP2PAL_GRPH - (NP2PALS_TXT + NP2PAL_TEXT)),r1
putyed_2ie:
		mov.l	200f,r0
		add		#1,r8
		add		r0,r12
		shll	r0
		add		r0,r11
		cmp/hs	r5,r8
		bf/s	putylp_2ie
		add		r9,r13
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
pal8_2ie:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH
400:	.long (NP2PALS_TXT << 24)|(NP2PALS_TXT << 16)|(NP2PALS_TXT << 8)|NP2PALS_TXT
500:	.long	0xf0f0f0f0
600:	.long	0xffffff00
601:	.long	0xffff00ff
602:	.long	0xff00ffff
603:	.long	0x00ffffff
		

sdraw8p_1d:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_1d,r1
		mov.l	@(S_Y,r4),r9
		mov.l	@(S_YALIGN,r4),r3
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_DST,r4),r12
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r9,r7
putylp_1d:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_1d
		mov		#0,r0
		mov.l	r12,@(S_DST,r4)
		mov		r12,r13
		add		r3,r13
putxlp_1d:
		mov.l	@(r0,r11),r10
		add		r1,r10
		add		#4,r0
		mov.l	r10,@r12
		add		#4,r12
		mov.l	r10,@r13
		cmp/hs	r14,r0
		bf/s	putxlp_1d
		add		#4,r13
		mov.l	@(S_DST,r4),r12	
putyed_1d:
		mov.l	200f,r0
		add		#1,r9
		add		r0,r11
		mov		r3,r0
		shll	r0
		cmp/hs	r5,r9
		bf/s	putylp_1d
		add		r0,r12
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
pal8_1d:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH

sdraw8p_2d:
		mov.l	r8,@-r15
		mov.l	r9,@-r15
		mov.l	r10,@-r15
		mov.l	r11,@-r15
		mov.l	r12,@-r15
		mov.l	r13,@-r15
		mov.l	r14,@-r15
		mov.l	pal8_2d,r1
		mov.l	@(S_Y,r4),r8
		mov.l	@(S_YALIGN,r4),r9
		mov.l	@(S_SRC,r4),r11
		mov.l	@(S_SRC2,r4),r12
		mov.l	@(S_DST,r4),r13
		mov.l	@(S_WIDTH,r4),r14
		mov		r4,r7
		add		#S_HDRSIZE,r7
		add		r8,r7
putylp_2d:
		mov.b	@r7+,r2
		tst		r2,r2
		bt/s	putyed_2d
		mov		#0,r0
		mov.l	r13,@(S_DST,r4)
		mov		r9,r10
		add		r13,r10
putxlp_2d:
		mov.l	@(r0,r11),r2
		mov.l	@(r0,r12),r3
		or		r2,r3
		add		r1,r3
		add		#4,r0
		mov.l	r3,@r13
		add		#4,r13
		mov.l	r3,@r10
		cmp/hs	r14,r0
		bf/s	putxlp_2d
		add		#4,r10
		mov.l	@(S_YALIGN,r4),r9
		mov.l	@(S_DST,r4),r13
putyed_2d:
		mov.l	200f,r0
		add		#1,r8
		add		r0,r11
		add		r0,r12
		mov		r9,r0
		shll	r0
		cmp/hs	r5,r8
		bf/s	putylp_2d
		add		r0,r13
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
pal8_2d:	.long	(NP2PAL_GRPH << 24)|(NP2PAL_GRPH << 16)|(NP2PAL_GRPH << 8)|NP2PAL_GRPH

		.align 2
_sdraw_getproctbl:
		mova	1000f,r0
		rts
		nop
	
		.align	2
1000:	
		.long		sdraw8p_0
		.long		sdraw8p_1
		.long		sdraw8p_1
		.long		sdraw8p_2
		.long		sdraw8p_0
		.long		sdraw8p_ti
		.long		sdraw8p_gi
		.long		sdraw8p_2i
		.long		sdraw8p_0
		.long		sdraw8p_ti
		.long		sdraw8p_gie
		.long		sdraw8p_2ie
		.long		sdraw8p_0
		.long		sdraw8p_1d
		.long		sdraw8p_1d
		.long		sdraw8p_2d
	
		.end

