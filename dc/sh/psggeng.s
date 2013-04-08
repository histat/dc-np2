
PSGFREQPADBIT	=		12
PSGADDEDBIT		=		3
PSGADDEDCNT		=		(1 << PSGADDEDBIT)

PSGENV_INC		=		15
PSGENV_ONESHOT	=		16
PSGENV_LASTON	=		32
PSGENV_ONECYCLE	=		64

T_FREQ			=		0
T_COUNT			=		4
T_PVOL			=		8
T_PUCHI			=		12
T_PAN			=		14
T_SIZE			=		16

P_TONE			=		0
P_NOISE			=		48
PN_FREQ			=		48
PN_COUNT		=		52
PN_BASE			=		56
P_REG			=		60
P_ENVCNT		=		76
P_ENVMAX		=		78
P_MIXER			=		80
P_ENVMODE		=		81
P_ENVVOL		=		82
P_ENVVOLCNT		=		83
P_EVOL			=		84
P_PUCHICOUNT	=		88

C_VOLUME		=		0
C_VOLTBL		=		64
C_RATE			=		128
C_BASE			=		132
C_PUCHIDEC		=		136

CD_BIT31		=		0x80000000

! r0	psggen
! r1	Offset
! r2	Counter
! r3	Temporary Register
! r4	Temporary Register
! r5	Temporary Register
! r6	Temporary Register
! r7	L
! r8	R
! r9	noise
! r10	mixer
! r11	psgcfg Fix
! r12	Temporary Register
! lr	envcnt?

	.extern	__randseed
	.extern	_psggencfg

	.globl	_psggen_getpcm

	.text
	.align	2

.macro PSGCALC	o, t, n
	mov.w	100f,r0
	mov.l	@(r0,r4),r2
	mov	r14,r0
	tst	#\t,r0
	mov	#0,r7
	bt/s	33f
	mov.l	@r2,r2
	tst	r2,r2
	bf	1f
	bra	2000f
	nop
1:	
	mov.w	101f,r0
	mov.l	@(r0,r4),r8
	mov	r14,r0
	tst	#\n,r0
	mov.w	102f,r0
	bf/s	11f
	mov.l	@(r0,r4),r9
	mov	#PSGADDEDCNT,r10
00:	! .tlp
	add	r9,r8
	cmp/pz	r8
	bf/s	1f
	dt	r10
	!pl
	bra	2f
	add	r2,r7
1:	!mi
	sub	r2,r7
2:
	bf	00b ! .tlp
	mov.w	101f,r0
	mov.l	r8,@(r0,r4)
	mov.w	103f,r0
	mov.b	@(r0,r4),r10
	bra	66f	! .pan
	extu.b	r10,r10

100:	.word	(\o + T_PVOL)
101:	.word	(\o + T_COUNT)
102:	.word	(\o + T_FREQ)
103:	.word	(\o + T_PAN)

11:	! .tn
	mov	r13,r10
	add	#1,r10
22:	! .tnlp
	add	r9,r8
	mov	r8,r0
	and	r10,r0
	cmp/pz	r0	
	bf	1f
	!pl
	bra	2f
	add	r2,r7
1:	
	!mi
	sub	r2,r7
2:
	shll	r10
	mov.w	100f,r0 ! (1 << PSGADDEDCNT)
	tst	r0,r10
	bt	22b	! .tnlp
	mov.w	101f,r0 ! (\o + T_COUNT)
	mov.l	r8,@(r0,r4)
	mov.w	102f,r0 ! (\o + T_PAN)
	mov.b	@(r0,r4),r10
	bra	66f	! .pan
	extu.b	r10,r10

100:	.word	(1 << PSGADDEDCNT)
101:	.word	(\o + T_COUNT)
102:	.word	(\o + T_PAN)

33:	! .n
	tst	r2,r2
	bt/s	2000f
	mov	r14,r0
	tst	#\n,r0
	bf	44f	! .nmn
	mov.w	100f,r0 ! (\o + T_PUCHI)
	mov.b	@(r0,r4),r8
	mov.w	101f,r0 ! (\o + T_PAN)
	extu.b	r8,r8
	mov.b	@(r0,r4),r10
	add	#-1,r8
	cmp/pz	r8
	extu.b	r10,r10
	bf/s	1f
	lds	r2,macl
	! cs
	mov.w	100f,r0 ! (\o + T_PUCHI)
	mov.b	r8,@(r0,r4)
	mov	#PSGADDEDBIT,r0
	shld	r0,r2
	add	r2,r7
1:	
	bra	66f	! .pan
	sts	macl,r2

100:	.word	(\o + T_PUCHI)
101:	.word	(\o + T_PAN)
	
44:	! .nmn
	mov.w	100f,r0 ! (\o + T_PAN)
	mov.l	200f,r8 ! (1 << (32 - PSGADDEDCNT))
	mov.b	@(r0,r4),r10
	extu.b	r10,r10
55:	! .nlp
	tst	r13,r8
	bf	1f	
	! eq
	bra	2f
	add	r2,r7
1:	
	! ne
	sub	r2,r7
2:
	shll	r8
	tst	r8,r8
	bf	55b	! .nlp
66:
	! .pan
	mov	r10,r0
	tst	#1,r0
	bf/s	1f
	tst	#2,r0
	! eq
	add	r7,r11
1:
	bf	2f
	! eq
	bra	2000f
	add	r7,r12

2:
	bra	2000f
	nop

100:	.word	(\o + T_PAN)

	.align	2
200:	.long	(1 << (32 - PSGADDEDCNT))
2000:
.endm

	
_psggen_getpcm:
	mov	#P_MIXER,r0
	mov.b	@(r0,r4),r0
	tst	#0x3f,r0
	bf/s	countcheck
	extu.b	r0,r2
	mov	#P_PUCHICOUNT,r0
	mov.l	@(r0,r4),r7
	cmp/hs	r7,r6
	bf/s	1f
	mov	#P_PUCHICOUNT,r0
	! cs
	mov	r7,r6
1:	
	sub	r6,r7
	mov.l	r7,@(r0,r4)
countcheck:
	tst	r6,r6
	bf	.start
	! eq
	rts
	nop
.start:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	mov.l	r14,@-r15
	mov.l	psgvoltbl,r1
	mov	#P_ENVCNT,r0
	mov.w	@(r0,r4),r3
	bra	psgmake_lp
	extu.w	r3,r3

	.align	2
psgvoltbl:	.long	_psggencfg + C_VOLUME

psgmake_lp:
	mov	#P_MIXER,r0
	tst	r3,r3
	! eq
	bt/s	makenoise
	mov.l	@(r0,r4),r14
	dt	r3
	! ne
	bf	makenoise
	mov.l	200f,r0
	and	r0,r14
	mov.l	201f,r0
	cmp/hs	r0,r14
	!cs
	bt/s	calcenvnext
	sub	r0,r14
	
	mov.w	100f,r0
	tst	r0,r14
	!eq
	bt	calcenvcyc
	mov.w	101f,r0
	tst	r0,r14
	bf	1f
	!eq
	bt/s	calcenvvstr
	mov.l	@r1,r10
1:	
	!ne
	mov.l	@(15 * 4,r1),r10
	mov.l	202f,r0
	bra	calcenvvstr
	or	r0,r14

100:	.word	(PSGENV_ONESHOT << 8)
101:	.word	(PSGENV_LASTON << 8)
	
	.align	2
200:	.long	~(255 << 16)
201:	.long	(1 << 24)
202:	.long	(15 << 16)

calcenvcyc:
	mov.l	200f,r0 ! ~(240 << 24)
	and	r0,r14
	mov.w	100f,r0
	tst	r0,r14
	bf	calcenvnext
	!eq
	mov.w	101f,r0
	bra	calcenvnext
	xor	r0,r14

100:	.word	(PSGENV_ONECYCLE << 8)
101:	.word	(PSGENV_INC << 8)

	.align	2
200:	.long	0x0fffffff

calcenvnext:
	mov	#P_ENVMAX,r0
	mov.w	@(r0,r4),r3
	extu.w	r3,r3
	mov	r14,r0
	mov	r14,r7
	shlr16	r0
	xor	r0,r7
	mov.w	100f,r0 ! (15 << 8)
	and	r0,r7
	mov	r7,r0
	mov	#-(8 - 2),r10
	shld	r10,r0
	mov.l	@(r0,r1),r10
	mov	r7,r0
	shll8	r0
	bra	calcenvvstr
	or	r0,r14

100:	.word	(15 << 8)

calcenvvstr:
	mov	#P_EVOL,r0
	mov.l	r10,@(r0,r4)
calcenvstr:
	mov	#P_MIXER,r0
	mov.l	r14,@(r0,r4)
makenoise:
	mov	r14,r0
	tst	#0x38,r0
	! eq
	bt	makesamp
	mov.l	@(PN_FREQ,r4),r10
	mov.l	@(PN_COUNT,r4),r11
	mov.l	@(PN_BASE,r4),r12
	mov	#0,r13
	mov	#PSGADDEDCNT,r7
mknoise_lp:
	cmp/hs	r10,r11
	bt/s	updatenoiseret
	sub	r10,r11
	!cc
	bra	updatenoise
	nop
updatenoiseret:
	shll	r13
	dt	r7
	! ne
	bf/s	mknoise_lp
	add	r12,r13
	mov	#PN_COUNT,r0
	mov.l	r11,@(r0,r4)
makesamp:
	mov	#0,r11
	mov	#0,r12
psgcalc0:	PSGCALC	(T_SIZE * 0), 0x01, 0x08
psgcalc1:	PSGCALC	(T_SIZE * 1), 0x02, 0x10
psgcalc2:	PSGCALC	(T_SIZE * 2), 0x04, 0x20

	mov.l	@r5,r8
	mov.l	@(4,r5),r7
	dt	r6
	add	r11,r8
	mov.l	r8,@r5
	add	#4,r5
	add	r12,r7
	mov.l	r7,@r5
	bt/s	1f
	add	#4,r5
	!ne
	bra	psgmake_lp
	nop
1:	
	mov	#P_ENVCNT,r0
	mov.w	r3,@(r0,r4)
	mov.l	@r15+,r14
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8
updatenoise:
	mov.l	randdcd,r8
	mov.l	@r8,r12
	mov.l	randdcd1,r2
	mul.l	r2,r12
	mov.l	randdcd2,r12
	sts	macl,r2
	add	r2,r12
	mov.l	r12,@r8
	mov.l	200f,r0 ! (1 << (32 - PSGADDEDCNT))
	and	r0,r12
	bra	updatenoiseret
	mov.l	r12,@(PN_BASE,r4)

	.align	2
200:	.long	(1 << (32 - PSGADDEDCNT))
	
randdcd:	.long		__randseed
randdcd1:	.long		0x343fd
randdcd2:	.long		0x269ec3

	.end

