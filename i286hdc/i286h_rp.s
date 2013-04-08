
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286halu.inc"

	.extern	_iflags

	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w

	.extern	_iocore_inp8
	.extern	_iocore_inp16
	.extern	_iocore_out8
	.extern	_iocore_out16

	.globl	i286h_rep_insb
	.globl	i286h_rep_insw
	.globl	i286h_rep_outsb
	.globl	i286h_rep_outsw
	.globl	i286h_rep_movsb
	.globl	i286h_rep_movsw
	.globl	i286h_rep_lodsb
	.globl	i286h_rep_lodsw
	.globl	i286h_rep_stosb
	.globl	i286h_rep_stosw
	.globl	i286h_repe_cmpsb
	.globl	i286h_repe_cmpsw
	.globl	i286h_repne_cmpsb
	.globl	i286h_repne_cmpsw
	.globl	i286h_repe_scasb
	.globl	i286h_repe_scasw
	.globl	i286h_repne_scasb
	.globl	i286h_repne_scasw

	.text
	.align	2

	
i286h_rep_insb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0			! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	CPUSVF
	swap.b	r12,r0
	mov	#(0x10000 >> 16),r10
	tst	#(D_FLAG >> 8),r0
	bt/s	repinsblp
	shll16	r10
	neg	r10,r10
repinsblp:
	CPUSVC
	mov.w	@(CPU_DX,gbr),r0
	mov.l	201f,r3
	extu.w	r0,r4
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	mov	r0,r5
	CPULDC
	CPUWORK	4
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	10002f,r3
	mov	r9,r4
	shlr16	r4
	jsr	@r3
	add	r0,r4
	dt	r8
	bf/s	repinsblp
	add	r10,r9
	mov	r8,r0
	mov.w	r0,@(CPU_CX,gbr)
	CPULDF
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
201:	.long	_iocore_inp8
10002:	.long	i286h_memorywrite

i286h_rep_insw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0			! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	CPUSVF
	swap.b	r12,r0
	mov	#(0x20000 >> 16),r10
	tst	#(D_FLAG >> 8),r0
	bt/s	repinswlp
	shll16	r10
	neg	r10,r10
repinswlp:
	CPUSVC
	mov.w	@(CPU_DX,gbr),r0
	mov.l	201f,r3
	extu.w	r0,r4
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	mov	r0,r5
	CPULDC
	CPUWORK	4
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	1003f,r3
	mov	r9,r4
	shlr16	r4
	jsr	@r3
	add	r0,r4
	dt	r8
	bf/s	repinswlp
	add	r10,r9
	mov	r8,r0
	mov.w	r0,@(CPU_CX,gbr)
	CPULDF
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
201:	.long	_iocore_inp16
1003:	.long	i286h_memorywrite_w

i286h_rep_outsb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	extu.w	r0,r9
	jmp	@r13
	nop
1:	
	CPUSVF
	shll16	r9
	swap.b	r12,r0
	mov	#(0x10000 >> 16),r10
	tst	#(D_FLAG >> 8),r0
	shll16	r10
	bt/s	repoutsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repoutsblp:
	mov	r0,r6
	CPUWORK	4
	mov	r9,r4
	mov.l	10000f,r3
	shlr16	r4
	jsr	@r3
	add	r6,r4
	mov	r0,r5
	mov.w	@(CPU_DX,gbr),r0
	mov.l	201f,r3
	extu.w	r0,r4
	add	r10,r9
	CPUSVC
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	CPULDC
	dt	r8
	bf/s	repoutsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r8,r0
	shlr16	r9
	mov.w	r0,@(CPU_CX,gbr)
	CPULDF
	mov	r9,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread
201:	.long	_iocore_out8

i286h_rep_outsw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	extu.w	r0,r9
	jmp	@r13
	nop
1:	
	CPUSVF
	shll16	r9
	mov	#(0x20000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	bt/s	repoutswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repoutswlp:
	mov	r0,r6
	CPUWORK	4
	mov	r9,r4
	mov.l	10001f,r3
	shlr16	r4
	jsr	@r3
	add	r6,r4
	mov	r0,r5
	mov.w	@(CPU_DX,gbr),r0
	mov.l	201f,r3
	extu.w	r0,r4
	add	r10,r9
	CPUSVC
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	CPULDC
	dt	r8
	bf/s	repoutswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
1:
	mov	r8,r0
	shlr16	r9
	mov.w	r0,@(CPU_CX,gbr)
	CPULDF
	mov	r9,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
201:	.long	_iocore_out16

i286h_rep_movsb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	r9,r13
	mov	#(0x10000 >> 16),r10
	shll16	r13
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	bt/s	repmovsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repmovsblp:
	mov	r13,r4
	mov.l	10000f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r5
	mov.l	@(CPU_ES_BASE,gbr),r0
	add	r10,r13
	mov	r9,r4
	mov.l	10002f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	CPUWKS	4, pz
	bf/s	repmovsbbreak
	add	r10,r9
	dt	r8
	bf/s	repmovsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	shlr16	r9
	mov	r8,r0
	shlr16	r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)
repmovsbbreak:
	mov.b	@(CPU_PREFIX,gbr),r0
	shlr16	r9
	extu.b	r0,r5
	shlr16	r13
	dt	r8
	bt/s	1f
	add	#1,r5
	shll16	r5
	sub	r5,r12
1:
	mov	r8,r0
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite

i286h_rep_movsw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	r9,r13
	mov	#(0x20000 >> 16),r10
	shll16	r13
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	bt/s	repmovswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repmovswlp:
	mov	r13,r4
	mov.l	10001f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r5
	mov.l	@(CPU_ES_BASE,gbr),r0
	add	r10,r13
	mov	r9,r4
	mov.l	10003f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	CPUWKS	4, pz
	bf/s	repmovswbreak
	add	r10,r9
	dt	r8
	bf/s	repmovswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
	shlr16	r9
	mov	r8,r0
	shlr16	r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)
repmovswbreak:
	mov.b	@(CPU_PREFIX,gbr),r0
	shlr16	r9
	extu.b	r0,r5
	dt	r8
	shlr16	r13
	bt/s	1f
	add	#1,r5
	shll16	r5
	sub	r5,r12
1:
	mov	r8,r0
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w

i286h_rep_lodsb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	extu.w	r0,r9
	jmp	@r13
	nop
1:	
	mov.l	r13,@-r15
	mov	#(0x10000 >> 16),r10
	shll16	r9
	shll16	r10
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_DS_FIX,gbr),r0
	bt/s	replodsblp
	mov	r0,r13
	neg	r10,r10
replodsblp:
	mov	r9,r4
	mov.l	10000f,r3
	shlr16	r4
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	4
	dt	r8
	bf/s	replodsblp
	mov	r4,r0
	shlr16	r9
	mov.b	r0,@(CPU_AL,gbr)
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread

i286h_rep_lodsw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	extu.w	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x20000 >> 16),r10
	shll16	r9
	shll16	r10
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_DS_FIX,gbr),r0
	bt/s	replodswlp
	mov	r0,r13
	neg	r10,r10
replodswlp:
	mov	r9,r4
	mov.l	10001f,r3
	shlr16	r4
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	4
	dt	r8
	bf/s	replodswlp
	mov	r4,r0
	shlr16	r9
	mov.w	r0,@(CPU_AX,gbr)
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)
	
	.align	2
10001:	.long	i286h_memoryread_w

i286h_rep_stosb:
	CPUWORK	4
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x10000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repstosblp
	mov	r0,r13
	neg	r10,r10
repstosblp:
	mov.b	@(CPU_AL,gbr),r0
	mov	r9,r4
	extu.b	r0,r5
	shlr16	r4
	mov.l	10002f,r3
	add	r13,r4
	jsr	@r3
	add	r10,r9
	CPUWKS	3, pl
	bf	repstosbbreak
	dt	r8
	bf/s	repstosblp
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)
repstosbbreak:
	mov.b	@(CPU_PREFIX,gbr),r0
	dt	r8
	extu.b	r0,r5
	mov	r9,r0
	add	#1,r5
	bt/s	1f
	mov.l	r0,@(CPU_SI,gbr)
	shll16	r5
	sub	r5,r12
1:
	mov.l	@r15+,r13
	mov	r8,r0
	jmp	@r13
	mov.w	r0,@(CPU_CX,gbr)

	.align	2
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite
	
i286h_rep_stosw:
	CPUWORK	4
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x20000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repstoswlp
	mov	r0,r13
	neg	r10,r10
repstoswlp:
	mov.w	@(CPU_AX,gbr),r0
	mov	r9,r4
	extu.w	r0,r5
	shlr16	r4
	mov.l	10003f,r3
	add	r13,r4
	jsr	@r3
	add	r10,r9
	CPUWKS	3, pz
	bf	repstoswbreak
	dt	r8
	bf/s	repstoswlp
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)
repstoswbreak:
	mov.b	@(CPU_PREFIX,gbr),r0
	dt	r8
	extu.b	r0,r5
	mov	r9,r0
	add	#1,r5
	bt/s	1f
	mov.l	r0,@(CPU_SI,gbr)
	shll16	r5
	sub	r5,r12
1:
	mov.l	@r15+,r13
	mov	r8,r0
	jmp	@r13
	mov.w	r0,@(CPU_CX,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w

i286h_repe_cmpsb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	r9,r13
	mov	#(0x10000 >> 16),r10
	shll16	r13
	shll16	r10
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bt/s	repecmpsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repecmpsblp:
	mov	r13,r4
	mov.l	10000f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r14
	mov	#24,r3
	mov.l	@(CPU_ES_BASE,gbr),r0
	shld	r3,r14
	add	r10,r13
	mov	r9,r4
	mov.l	10000f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	add	r10,r9
	CPUWORK	9
	mov	#24,r3
	dt	r8
	shld	r3,r4
	bt/s	repecmpsbbreak
	mov.l	@(CPU_DS_FIX,gbr),r0
	cmp/eq	r4,r14
	bt	repecmpsblp
repecmpsbbreak:
	shlr8	r12
	mov	r14,r5
	shll8	r12
	mov	r5,r3
	subv	r4,r5
	mov	r14,r2
	mov.l	repecmpsb_flag,r14
	bf/s	1f
	xor	r5,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	bra	2f
	swap.b	r0,r12
1:
	mov	#~(O_FLAG >> 8),r0
	swap.b	r12,r12
	and	r0,r12
	swap.b	r12,r12
2:
	clrt
	subc	r4,r3
	bf	3f
	add	#C_FLAG,r12
3:
	mov	r5,r0
	mov	#-24,r3
	shld	r3,r0
	mov.b	@(r0,r14),r6
	mov	r4,r2
	xor	r5,r2
	extu.b	r6,r6
	mov	#24,r4
	mov	#A_FLAG,r0
	shld	r4,r0
	and	r0,r2
	or	r6,r12
	shld	r3,r2
	or	r2,r12
	shlr16	r9
	shlr16	r13
	mov	r9,r4
	shll16	r4
	or	r13,r4
	mov	r8,r0
	mov.w	r0,@(CPU_CX,gbr)
	mov	r4,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)
	
	.align	2
10000:	.long	i286h_memoryread
repecmpsb_flag:	.long		_iflags	

i286h_repe_cmpsw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	r9,r13
	mov	#(0x20000 >> 16),r10
	shll16	r13
	shll16	r10
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bt/s	repecmpswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repecmpswlp:
	mov	r13,r4
	mov.l	10001f,r3
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r14
	mov.l	@(CPU_ES_BASE,gbr),r0
	shll16	r14
	mov.l	10001f,r3
	add	r10,r13
	mov	r9,r4
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	add	r10,r9
	CPUWORK	9
	dt	r8
	shll16	r4
	bt/s	repecmpswbreak
	mov.l	@(CPU_DS_FIX,gbr),r0
	cmp/eq	r4,r14
	bt	repecmpswlp
repecmpswbreak:
	shlr8	r12
	mov	r14,r5
	shll8	r12
	mov	r5,r3
	subv	r4,r5
	mov	r14,r2
	xor	r5,r2
	mov.l	repecmpsw_flag,r14
	swap.w	r5,r7
	bf/s	1f
	extu.b	r7,r7
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	bra	2f
	swap.b	r0,r0
1:
	mov	#~(O_FLAG >> 8),r0
	swap.b	r12,r12
	and	r0,r12
	swap.b	r12,r0
2:
	clrt
	subc	r4,r3
	bf/s	3f
	cmp/pz	r5
	or	#C_FLAG,r0
3:
	bt/s	4f
	tst	r5,r5
	or	#S_FLAG,r0
4:
	bf	5f
	or	#Z_FLAG,r0
5:
	mov	r0,r12
	mov	r7,r0
	shlr16	r0
	mov.b	@(r0,r14),r6
	mov	r4,r2
	xor	r5,r2
	swap.w	r2,r0
	mov	#P_FLAG,r3
	and	#A_FLAG,r0
	and	r3,r6
	or	r6,r12
	or	r0,r12
	shlr16	r9
	mov	r8,r0
	shlr16	r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
repecmpsw_flag:	.long		_iflags

i286h_repne_cmpsb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x10000 >> 16),r10
	mov	r9,r13
	shll16	r10
	shll16	r13
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bt/s	repnecmpsblp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repnecmpsblp:
	mov.l	10000f,r3
	mov	r13,r4
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r14
	mov	#24,r3
	mov.l	@(CPU_ES_BASE,gbr),r0
	shld	r3,r14
	mov.l	10000f,r3
	mov	r9,r4
	add	r10,r13
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	add	r10,r9
	CPUWORK	9
	mov	#24,r3
	dt	r8
	shld	r3,r4
	bt/s	repnecmpsbbreak
	mov.l	@(CPU_DS_FIX,gbr),r0
	cmp/eq	r4,r14
	bf	repnecmpsblp
repnecmpsbbreak:
	shlr8	r12
	mov	r14,r5
	shll8	r12
	mov	r5,r3
	subv	r4,r5
	mov	r14,r2
	mov.l	repnecmpsb_flag,r14
	bf/s	1f
	xor	r5,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	bra	2f
	swap.b	r0,r12
1:
	mov	#~(O_FLAG >> 8),r0
	swap.b	r12,r12
	and	r0,r12
	swap.b	r12,r12
2:
	clrt
	subc	r4,r3
	bf	3f
	add	#C_FLAG,r12
3:	
	mov	r5,r0
	mov	#-24,r3
	shld	r3,r0
	mov.b	@(r0,r14),r6
	mov	r4,r0
	xor	r5,r0
	shld	r3,r0
	and	#A_FLAG,r0
	or	r6,r12
	or	r0,r12
	shlr16	r9
	mov	r8,r0
	shlr16	r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread
repnecmpsb_flag:	.long		_iflags

i286h_repne_cmpsw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	tst	r8,r8
	mov.l	@(CPU_SI,gbr),r0	! DI:SI
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x20000 >> 16),r10
	mov	r9,r13
	shll16	r10
	shll16	r13
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bt/s	repnecmpswlp
	mov.l	@(CPU_DS_FIX,gbr),r0
	neg	r10,r10
repnecmpswlp:
	mov.l	10001f,r3
	mov	r13,r4
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r14
	mov.l	@(CPU_ES_BASE,gbr),r0
	shll16	r14
	mov.l	10001f,r3
	mov	r9,r4
	add	r10,r13
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	add	r10,r9
	CPUWORK	9
	dt	r8
	shll16	r4
	bt/s	repnecmpswbreak
	mov.l	@(CPU_DS_FIX,gbr),r0
	cmp/eq	r4,r14
	bf	repnecmpswlp
repnecmpswbreak:
	shlr8	r12
	mov	r14,r5
	shll8	r12
	mov	r5,r3
	subv	r4,r5
	mov	r14,r2
	swap.w	r5,r7
	xor	r5,r2
	mov.l	repnecmpsw_flag,r14
	bf/s	1f
	extu.b	r7,r7
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	bra	2f
	swap.b	r0,r0
1:
	mov	#~(O_FLAG >> 8),r0
	swap.b	r12,r12
	and	r0,r12
	swap.b	r12,r0
2:
	clrt
	subc	r4,r3
	bf/s	3f
	cmp/pz	r5
	or	#C_FLAG,r0
3:	
	bt/s	4f
	tst	r5,r5
	or	#S_FLAG,r0
4:	
	bf	5f
	or	#Z_FLAG,r0
5:
	mov	r0,r12
	mov	r7,r0
	shlr16	r0
	mov.b	@(r0,r14),r6
	mov	r4,r0
	xor	r5,r0
	shlr16	r0
	and	#A_FLAG,r0
	mov	#P_FLAG,r3
	and	r3,r6
	or	r6,r12
	or	r0,r12
	shlr16	r9
	mov	r8,r0
	shlr16	r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	shll16	r0
	or	r13,r0
	mov.l	@r15+,r13
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
repnecmpsw_flag:	.long		_iflags
10001:	.long	i286h_memoryread_w

i286h_repe_scasb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	tst	r8,r8
	mov.l	@(CPU_SI,gbr),r0
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x10000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repescasblp
	mov	r0,r13
	neg	r10,r10
repescasblp:
	mov	r9,r4
	mov.l	10000f,r3
	shlr16	r4
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	8
	mov.b	@(CPU_AL,gbr),r0
	dt	r8
	bt/s	repescasbbreak
	extu.b	r0,r6
	cmp/eq	r4,r6	
	bt	repescasblp
repescasbbreak:	SUB8	r6, r4
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread
	
i286h_repe_scasw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	tst	r8,r8
	mov.l	@(CPU_SI,gbr),r0
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x20000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repescaswlp
	mov	r0,r13
	neg	r10,r10
repescaswlp:
	mov	r9,r4
	mov.l	10001f,r3
	shlr16	r4
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	8
	mov.w	@(CPU_AX,gbr),r0
	dt	r8
	bt/s	repescaswbreak
	extu.w	r0,r6
	cmp/eq	r4,r6	
	bt	repescaswlp
repescaswbreak:	SUB16	r6, r4
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
1001:	.long	i286h_memoryread_w

i286h_repne_scasb:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x10000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repnescasblp
	mov	r0,r13
	neg	r10,r10
repnescasblp:
	mov	r9,r4
	shlr16	r4
	mov.l	10000f,r3
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	8
	mov.b	@(CPU_AL,gbr),r0
	dt	r8
	bt/s	repnescasbbreak
	extu.b	r0,r6
	cmp/eq	r4,r6
	bf	repnescasblp
repnescasbbreak:	SUB8	r6, r4
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread

i286h_repne_scasw:
	CPUWORK	5
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SI,gbr),r0
	tst	r8,r8
	bf/s	1f
	mov	r0,r9
	jmp	@r13
	nop
1:
	mov.l	r13,@-r15
	mov	#(0x20000 >> 16),r10
	swap.b	r12,r0
	shll16	r10
	tst	#(D_FLAG >> 8),r0
	mov.l	@(CPU_ES_BASE,gbr),r0
	bt/s	repnescaswlp
	mov	r0,r13
	neg	r10,r10
repnescaswlp:
	mov	r9,r4
	shlr16	r4
	mov.l	10001f,r3
	add	r13,r4
	jsr	@r3
	add	r10,r9
	mov	r0,r4
	CPUWORK	8
	mov.w	@(CPU_AX,gbr),r0
	dt	r8
	bt/s	repnescaswbreak
	extu.w	r0,r6
	cmp/eq	r4,r6	
	bf	repnescaswlp
repnescaswbreak:	SUB16	r6, r4
	mov	r8,r0
	mov.l	@r15+,r13
	mov.w	r0,@(CPU_CX,gbr)
	mov	r9,r0
	jmp	@r13
	mov.l	r0,@(CPU_SI,gbr)

	.align	2
10001:	.long	i286h_memoryread_w

	.end
