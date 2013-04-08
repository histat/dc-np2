
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286halu.inc"
	.include "../i286hdc/i286hop.inc"

	.extern	i286h_ea
	.extern	i286h_a
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w
	.extern	i286h_localint

	.globl	i286hopfe
	.globl	i286hopff

	.text
	.align	2
	
i286hopfe:	GETPCF8
	tst	#(1 << 3),r0
	bt/s	incea8
	mov	r0,r4
	bra	decea8
	nop

	_GETPCF8

incea8:	OP_EA8	INC8, 2, 7
decea8:	OP_EA8	DEC8, 2, 7
	
! ----

i286hopff:
	GETPCF8
	mov	r0,r4
	and	#(7 << 3),r0
	mov	r0,r2
	mova	opefftbl,r0
	shlr	r2
	mov.l	@(r0,r2),r3
	jmp	@r3
	nop

	.align	2
opefftbl:	.long		incea16
				.long		decea16
				.long		callea16
				.long		callfarea16
				.long		jmpea16
				.long		jmpfarea16
				.long		pushea16
				.long		popea16

	_GETPCF8
incea16:	OP_EA16	INC16, 2, 7
decea16:	OP_EA16	DEC16, 2, 7
	
callea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	call16m
	CPUWORK	7
	R16SRC	r4, r9
	mov.w	@r9,r4
	mov	r12,r5
	shlr16	r5
	mov	r5,r0
	shll16	r0
	mov	r4,r3
	sub	r0,r12
	shll16	r3
	bra	call16e
	or	r3,r12
call16m:
	mov.l	200f,r3
	CPUWORK	11
	jsr	@r3
	nop
	mov.l	1001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r12,r5
	mov	r0,r4
	mov	r0,r3
	shlr16	r5
	mov	r5,r0
	shll16	r0
	shll16	r3
	sub	r0,r12
	or	r3,r12
call16e:
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	#(0x10000 >> 16),r3
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	shll16	r3
	extu.w	r0,r0
	add	#-2,r0
	cmp/pz	r0
	bt/s	1f
	lds	r13,pr
	add	r3,r0
1:
	mov.l	1003f,r3
	add	r0,r4
	jmp	@r3
	mov.w	r0,@(CPU_SP,gbr)

	.align	2
200:	.long	i286h_ea
1001:	.long	i286h_memoryread_w
1003:	.long	i286h_memorywrite_w	
callfarea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bt	callfar16r
	mov.l	200f,r3
	CPUWORK	16
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	mov.l	10001f,r0
	add	#2,r8
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	add	r10,r4
	and	r3,r8
	jsr	@r0			! ip
	swap.w	r8,r8
	mov	r12,r9
	shlr16	r9
	shll16	r0
	add	r0,r12
	mov	r9,r3
	shll16	r3
	sub	r3,r12
	mov.l	10001f,r3
	mov	r10,r4
	jsr	@r3			! cs
	add	r8,r4
	mov	r0,r4
	shll2	r0
	shll2	r0
	mov.l	r0,@(CPU_CS_BASE,gbr)
	mov.w	@(CPU_CS,gbr),r0
	extu.w	r0,r5
	mov	r4,r0
	mov.w	r0,@(CPU_CS,gbr)
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	add	#-2,r8
	cmp/pz	r8
	bt/s	1f
	mov	r0,r10
	mov	#1,r3
	shll16	r3
	add	r3,r8
1:
	mov.l	10003f,r3	
	mov	r10,r4
	jsr	@r3		! cs
	add	r8,r4
	add	#-2,r8
	cmp/pz	r8
	bt/s	2f
	mov	#(0x10000 >> 16),r3
	shll16	r3
	add	r3,r8
2:
	mov.l	10003f,r3
	mov	r8,r0
	mov	r9,r5
	mov.w	r0,@(CPU_SP,gbr)
	lds	r13,pr
	mov	r10,r4
	jmp	@r3			! ip
	add	r8,r4

	.align	2
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w	
callfar16r:
	mov	#((2 << 16) >> 16),r0
	mov.l	201f,r3
	shll16	r0
	mov	#6,r10
	jmp	@r3
	sub	r0,r12

	.align	2
201:	.long	i286h_localint
jmpea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	jmp16m
	CPUWORK	7
	R16SRC	r4, r9
	mov.w	@r9,r4
	extu.w	r12,r12
	shll16	r4
	jmp	@r13
	or	r4,r12
jmp16m:
	mov.l	200f,r3
	CPUWORK	11
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	extu.w	r12,r12
	shll16	r0
	jmp	@r13
	or	r0,r12

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
jmpfarea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bt	jmpfar16r
	mov.l	200f,r3
	CPUWORK	11
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	mov.l	10001f,r3
	add	#2,r8
	mov	#~((1 << 16) >> 16),r0
	swap.w	r8,r8
	add	r10,r4
	and	r0,r8
	jsr	@r3
	swap.w	r8,r8
	mov.l	10001f,r3
	extu.w	r12,r12
	shll16	r0
	mov	r10,r4
	or	r0,r12
	jsr	@r3
	add	r8,r4
	mov	#4,r3
	mov.w	r0,@(CPU_CS,gbr)
	shld	r3,r0
	jmp	@r13
	mov.l	r0,@(CPU_CS_BASE,gbr)

	.align	2
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
jmpfar16r:
	mov	#2,r0
	mov.l	201f,r3
	shll16	r0
	mov	#6,r10
	jmp	@r3
	sub	r0,r12
	
	.align	2
201:	.long	i286h_localint
pushea16:
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	push16m
	CPUWORK	3
	R16SRC	r4, r9
	mov.w	@r9,r5
	bra	push16e
	extu.w	r5,r5
push16m:
	mov.l	200f,r3
	CPUWORK	5
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r5
push16e:
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	#1,r3
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	shll16	r3
	extu.w	r0,r0
	add	#-2,r0
	cmp/pz	r0
	bt/s	1f
	lds	r13,pr
	add	r3,r0
1:
	mov.l	10002f,r3
	add	r0,r4
	jmp	@r3
	mov.w	r0,@(CPU_SP,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
10002:	.long	i286h_memorywrite_w
popea16:
	CPUWORK	5
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r4,r8
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	mov	#~(0x10000 >> 16),r3
	extu.w	r0,r0
	add	r0,r4
	add	#2,r0
	swap.w	r0,r0
	and	r3,r0
	mov.l	10001f,r3
	swap.w	r0,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r8
	bf/s	pop16m
	mov	r0,r4
	R16SRC	r8, r5
	jmp	@r13
	mov.w	r4,@r5

	.align	2
10001:	.long	i286h_memoryread_w
pop16m:
	mov.l	200f,r3
	mov	r4,r10
	jsr	@r3
	mov	r8,r4
	mov.l	10002f,r3
	lds	r13,pr
	mov	r0,r4
	jmp	@r3
	mov	r10,r5

	.align	2
200:	.long	i286h_ea
10002:	.long	i286h_memorywrite_w
	
	.end
