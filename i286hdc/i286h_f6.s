
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286halu.inc"
	.include "../i286hdc/i286hop.inc"

	.extern	i286h_ea
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w
	.extern	i286h_localint

	.extern _i286hcore

	.globl	i286hopf6
	.globl	i286hopf7

	.text
	.align	2

i286hopf6:	GETPCF8
	mov	r0,r4
	and	#(7 << 3),r0
	mov	r0,r2
	mova	opef6tbl,r0
	shlr	r2
	mov.l	@(r0,r2),r3
	jmp	@r3
	nop

	.align	2
opef6tbl:	.long		test_ea_d8
				.long		test_ea_d8
				.long		not_ea8
				.long		neg_ea8
				.long		mul_ea8
				.long		imul_ea8
				.long		div_ea8
				.long		idiv_ea8

	_GETPCF8
	
test_ea_d8:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	test8m
	CPUWORK	2
	R8SRC	r4, r9
	mov.b	@r9,r8
	extu.b	r8,r8
	GETPC8
	mov	r0,r4
	AND8	r8, r4
	jmp	@r13
	nop
test8m:
	mov.l	200f,r3
	CPUWORK	6
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	test8e
	mov	r0,r4
	mov.b	@(r0,r1),r8
	extu.b	r8,r8
	GETPC8
	mov	r0,r4
	AND8	r8, r4
	jmp	@r13
	nop
test8e:
	mov.l	10000f,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	GETPC8
	mov	r0,r4
	AND8	r8, r4
	jmp	@r13
	nop

	_GETPC8
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread
	
not_ea8:	OP_EA8	NOT8, 2, 7
neg_ea8:	OP_EA8	NEG8, 2, 7

mul_ea8:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	mul8m
	CPUWORK	13
	R8SRC	r4, r9
	mov.b	@(CPU_AL,gbr),r0
	mov.b	@r9,r8
	extu.b	r0,r4
	extu.b	r8,r8
	MUL8	r4, r8
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
mul8m:	
	mov.l	200f,r3
	CPUWORK	16
	jsr	@r3
	nop
	mov.l	10000f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r8
	MUL8	r4, r8
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)

	.align	2
200:	.long	i286h_ea
10000:	.long	i286h_memoryread
201:	.long	I286_MEMWRITEMAX
imul_ea8:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	imul8m
	CPUWORK	13
	R8SRC	r4, r9
	mov.b	@(CPU_AL,gbr),r0
	mov.b	@r9,r8
	extu.b	r0,r4
	extu.b	r8,r8
	IMUL8	r4, r8
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
imul8m:	
	mov.l	200f,r3
	CPUWORK	16
	jsr	@r3
	nop
	mov.l	10000f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0		! ldrsb
	extu.b	r0,r8
	IMUL8	r4, r8
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)

	.align	2
200:	.long	i286h_ea
10000:	.long	i286h_memoryread
div_ea8:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	div8m
	mov	r12,r10
	CPUWORK	14
	R8SRC	r4, r9
	mov.b	@r9,r4
	bra	div8e
	extu.b	r4,r4
div8m:
	mov.l	200f,r3
	CPUWORK	17
	jsr	@r3
	nop
	mov.l	10000f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
div8e:
	tst	r4,r4
	bt	div8intr
	mov.w	@(CPU_AX,gbr),r0
	mov	r4,r3
	extu.w	r0,r5
	shll8	r3
	cmp/hs	r3,r5
	bt	div8intr			! (tmp >= ((UINT16)src << 8))
	mov	r5,r0
	mov	r4,r5
	bsr	__udiv
	mov	r0,r4
	mov	r6,r0
	mov.b	r0,@(CPU_AL,gbr)
	mov	r2,r0
	mov	r4,r0
	jmp	@r13
	mov.b	r0,@(CPU_AH,gbr)

	.align	2
200:	.long	i286h_ea
10000:	.long	i286h_memoryread

div8intr:
	mov	#((2 << 16) >> 16),r0
	mov	r10,r12
	shll16	r0
	mov.l	201f,r3
	sub	r0,r12
	jmp	@r3
	mov	#0,r10

	.align	2
201:	.long	i286h_localint
idiv_ea8:
	mov	#0xc0,r3
	mov	r12,r10
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	idiv8m
	CPUWORK	17
	R8SRC	r4, r9
	mov.b	@r9,r4
	bra	idiv8e
	extu.b	r4,r4
idiv8m:	
	mov.l	200f,r3
	CPUWORK	20
	jsr	@r3
	nop
	mov.l	10000f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
idiv8e:
	mov	#24,r3
	shld	r3,r4
	tst	r4,r4
	bt	div8intr
	mov.w	@(CPU_AX,gbr),r0	! ldrsh
	mov	#-24,r3
	mov	r4,r5
	mov	r0,r4
	bsr	__div
	shad	r3,r5
	mov	r6,r0
	mov	#0x80,r6
	extu.b	r6,r6
	mov	#-24,r3
	add	r0,r6
	shld	r3,r6
	tst	r6,r6
	bf	div8intr
	mov.b	r0,@(CPU_AL,gbr)
	mov	r4,r0
	jmp	@r13
	mov.b	r0,@(CPU_AH,gbr)

	.align	2
200:	.long	i286h_ea
10000:	.long	i286h_memoryread

! ----

i286hopf7:	GETPCF8
	mov	r0,r4
	and	#(7 << 3),r0
	mov	r0,r2
	mova	opef7tbl,r0
	shlr	r2
	mov.l	@(r0,r2),r3
	jmp	@r3
	nop

	.align	2
opef7tbl:	.long		test_ea_d16
				.long		test_ea_d16
				.long		not_ea16
				.long		neg_ea16
				.long		mul_ea16
				.long		imul_ea16
				.long		div_ea16
				.long		idiv_ea16

	_GETPCF8
test_ea_d16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	test16m
	CPUWORK	2
	R16SRC	r4, r9
	mov.w	@r9,r8
	extu.w	r8,r8
	GETPC16
	mov	r0,r4
	AND16	r8, r4
	jmp	@r13
	nop
test16m:
	mov.l	200f,r3
	CPUWORK	6
	jsr	@r3
	nop
	tst	#1,r0
	bf/s	test16e
	mov	r0,r4
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt	test16e
	mov.w	@(r0,r1),r8
	extu.w	r8,r8
	GETPC16
	mov	r0,r4
	AND16	r8, r4
	jmp	@r13
	nop

	_GETPC16
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
test16e:
	mov.l	10001f,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	GETPC16
	mov	r0,r4
	AND16	r8, r4
	jmp	@r13
	nop

	_GETPC16
10001:	.long	i286h_memoryread_w
	
not_ea16:	OP_EA16	NOT16, 2, 7
neg_ea16:	OP_EA16	NEG16, 2, 7

mul_ea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	mul16m
	CPUWORK	21
	R16SRC	r4, r9
	mov.w	@(CPU_AX,gbr),r0
	mov.w	@r9,r8
	extu.w	r0,r4
	extu.w	r8,r8
	MUL16	r4, r8
	mov	r5,r0
	mov.w	r0,@(CPU_AX,gbr)
	shlr16	r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)
mul16m:	
	mov.l	200f,r3
	CPUWORK	24
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r8
	MUL16	r4, r8
	mov	r5,r0
	mov.w	r0,@(CPU_AX,gbr)
	shlr16	r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
imul_ea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	imul16m
	CPUWORK	21
	R16SRC	r4, r9
	mov.w	@(CPU_AX,gbr),r0
	mov.w	@r9,r8
	extu.w	r0,r4
	extu.w	r8,r8
	IMUL16	r4, r8
	mov	r5,r0
	mov.w	r0,@(CPU_AX,gbr)
	shlr16	r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)
imul16m:	
	mov.l	200f,r3
	CPUWORK	24
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0		! ldrsh?
	extu.w	r0,r8
	IMUL16	r4, r8
	mov	r5,r0
	mov.w	r0,@(CPU_AX,gbr)
	shlr16	r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
div_ea16:
	mov	#0xc0,r3
	mov	r12,r10
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	div16m
	CPUWORK	22
	R16SRC	r4, r9
	mov.w	@r9,r4
	bra	div16e
	extu.w	r4,r4
div16m:
	mov.l	200f,r3
	CPUWORK	25
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
div16e:
	tst	r4,r4
	bt	div16intr
	mov.w	@(CPU_DX,gbr),r0
	extu.w	r0,r6
	mov.w	@(CPU_AX,gbr),r0
	cmp/hs	r4,r6
	bt/s	div16intr
	mov	r4,r5
	extu.w	r0,r4
	shll16	r6
	bsr	__udiv
	add	r6,r4
	mov	r6,r0
	mov.w	r0,@(CPU_AX,gbr)
	mov	r4,r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w

div16intr:
	mov	#((2 << 16) >> 16),r0
	mov.l	201f,r3
	mov	r10,r12
	shll16	r0
	sub	r0,r12
	jmp	@r3
	mov	#0,r10

	.align	2
201:	.long	i286h_localint
idiv_ea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4	
	bf/s	idiv16m
	mov	r12,r10
	CPUWORK	25
	R16SRC	r4, r9
	mov.w	@r9,r4
	bra	idiv16e
	extu.w	r4,r4
idiv16m:
	mov.l	200f,r3
	CPUWORK	28
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
idiv16e:
	shll16	r4
	tst	r4,r4
	bt	div16intr
	mov.w	@(CPU_DX,gbr),r0
	mov	r4,r5
	extu.w	r0,r6
	mov.w	@(CPU_AX,gbr),r0
	mov	#-16,r3
	extu.w	r0,r4
	shad	r3,r5
	shll16	r6
	bsr	__div
	add	r6,r4
	mov	r6,r0
	mov	#0x08,r6
	mov	#(8 + 4),r3
	shld	r3,r6
	add	r0,r6
	shlr16	r6
	tst	r6,r6
	bf	div16intr
	mov.w	r0,@(CPU_AX,gbr)
	mov	r4,r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w


	! ! 割り算〜  unsigned r0 / unsigned r1 = r2*r1+r0 (r3==r1)
__udiv:
	tst	r5,r5
	bt/s	__udiv
	mov	r5,r7
	mov	#0,r6
1:
	mov	r4,r0
	shlr2	r0
	cmp/hi	r0,r7
	bt/s	1000f
	cmp/hs	r0,r7
	shll2	r7
1000:	
	bf	1b
	mov	r4,r0
	shlr	r0
	cmp/hi	r0,r7
	bt	3f
2:
	bf	1001f
	shlr2	r7
1001:
	mov	r7,r3
	shll	r3
	cmp/hs	r3,r4
	bf/s	1002f
	addc	r6,r6
	mov	r7,r3
	shll	r3
	sub	r3,r4
1002:	
3:
	cmp/hs	r7,r4
	bf/s	1003f
	addc	r6,r6
	sub	r7,r4
1003:	
	cmp/eq	r5,r7
	bf/s	2b
	cmp/hi	r5,r7
	rts
	nop

	! ! 割り算〜  signed r0 / signed r1 = r2*r1+r0 (r3==r1)	

__div:
	cmp/pz	r5
	bt/s	2000f
	mov	#0,r0
	neg	r5,r5
	mov	#1,r0
2000:
	cmp/pz	r4
	bt	2001f
	neg	r4,r4
	xor	#1,r0
2001:
	mov	r0,r2
	tst	r5,r5
	bt/s	__udiv
	mov	r5,r7
	mov	#0,r6
1:
	mov	r4,r0
	shlr2	r0
	cmp/hi	r0,r7
	bt/s	1000f
	cmp/hs	r0,r7
	shll2	r7
1000:	
	bf	1b
	mov	r4,r0
	shlr	r0
	cmp/hi	r0,r7
	bt	3f
2:
	bf	1001f
	shlr2	r7
1001:
	mov	r7,r3
	shll	r3
	cmp/hs	r3,r4
	bf/s	1002f
	addc	r6,r6
	mov	r7,r3
	shll	r3
	sub	r3,r4
1002:	
3:
	cmp/hs	r7,r4
	bf/s	1003f
	addc	r6,r6
	sub	r7,r4
1003:	
	cmp/eq	r5,r7
	bf/s	2b
	cmp/hi	r5,r7

	shlr	r2
	bf	2002f
	neg	r6,r6
2002:
	rts
	nop
	
	
	.end
