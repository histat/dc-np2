
	.include "../i286hdc/i286h.inc"

	.extern	_i286hcore
	.extern	i286h_memoryread
	.extern	i286h_memorywrite_w
	.globl	i286h_localint
	.globl	i286h_trapint
!	.extern	i286h_trapintr
!	.globl	_i286c_interrupt
	.globl	_i286h_interrupt

	.text
	.align	2

				! r6 - num / r8 - IP / r11 - ret
i286h_localint:
	CPUWORK	20
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10003f,r3
	add	#-2,r8
	mov	r0,r9
	extu.w	r8,r8
	mov	r12,r5
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_CS,gbr),r0
	add	#-2,r8
	extu.w	r8,r8
	mov.l	10003f,r3
	extu.w	r0,r5
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	add	#-2,r8
	extu.w	r8,r8
	mov	r12,r5
	shlr16	r5
	mov	r5,r3
	shll16	r3
	sub	r3,r12
	mov	r8,r4
	mov.l	10003f,r3
	add	r9,r4
	mov	r8,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	mov	r10,r0
	mov	#~((T_FLAG + I_FLAG) >> 8),r3
	shll2	r0
	mov.l	@(r0,r1),r5
	swap.b	r12,r12
	and	r3,r12
	mov	r5,r0
	swap.b	r12,r12
	shlr16	r0
	mov	#4,r3
	shll16	r5
	mov.w	r0,@(CPU_CS,gbr)
	or	r5,r12
	shld	r3,r0
	jmp	@r13
	mov.l	r0,@(CPU_CS_BASE,gbr)

	.align	2
10003:	.long	i286h_memorywrite_w

i286h_trapint:
	CPUWORK	20
	mov.w	@(CPU_SP,gbr),r0
	sts	pr,r10
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10003f,r3
	mov	r12,r5
	mov	r0,r9
	add	#-2,r8
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_CS,gbr),r0
	add	#-2,r8
	extu.w	r8,r8
	mov.l	10003f,r3
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov	r12,r5
	add	#-2,r8
	shlr16	r5
	extu.w	r8,r8
	mov	r5,r3
	mov	r8,r4
	shll16	r3
	sub	r3,r12
	add	r9,r4
	mov.l	10003f,r3
	mov	r8,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	mov	#~((T_FLAG + I_FLAG) >> 8),r3
	swap.b	r12,r12
	mov.l	@(4,r1),r5
	and	r3,r12
	swap.b	r12,r12
	mov	r5,r0
	shlr16	r0
	mov	#4,r3
	shll16	r5
	mov.w	r0,@(CPU_CS,gbr)
	or	r5,r12
	shld	r3,r0
	jmp	@r10
	mov.l	r0,@(CPU_CS_BASE,gbr)

	.align	2
10003:	.long	i286h_memorywrite_w

!!_i286c_interrupt:
_i286h_interrupt:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov.l	200f,r0
	mov.l	201f,r1
	ldc	r0,gbr
	mov	r4,r10
	CPULD
	CPUWORK	20
	mov.w	@(CPU_SP,gbr),r0
	mov	r12,r4
	extu.w	r0,r8
	mov.l	@(CPU_CS_BASE,gbr),r0
	shlr16	r4
	mov.l	10000f,r3
	add	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	jsr	@r3
	mov	r0,r9
	exts.b	r0,r0
	cmp/eq	#0xf4,r0
	bf	1f
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
1:
	mov	r12,r5
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_CS,gbr),r0
	add	#-2,r8
	extu.w	r8,r8
	mov.l	10003f,r3
	extu.w	r0,r5
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov	r12,r5
	add	#-2,r8
	shlr16	r5
	extu.w	r8,r8
	mov	r5,r3
	shll16	r3
	mov	r8,r4
	sub	r3,r12
	add	r9,r4
	mov.l	10003f,r3
	mov	r8,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	mov	r10,r0
	shll2	r0
	mov	#~((T_FLAG + I_FLAG) >> 8),r3
	mov.l	@(r0,r1),r5
	swap.b	r12,r0
	and	r3,r0
	swap.b	r0,r12
	mov	r5,r0
	shlr16	r0
	mov	#4,r3
	shll16	r5
	mov.w	r0,@(CPU_CS,gbr)
	or	r5,r12
	shld	r3,r0
	mov.l	r0,@(CPU_CS_BASE,gbr)
	CPUSV
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
200:	.long	_i286hcore
201:	.long	_i286hcore + CPU_SIZE
10000:	.long	i286h_memoryread
10003:	.long	i286h_memorywrite_w

	.end



	
