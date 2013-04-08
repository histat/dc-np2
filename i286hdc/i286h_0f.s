
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286halu.inc"

	.extern	i286h_selector
	.extern	i286h_ea
	.extern	i286h_a
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w
	
	.extern _i286hcore

	.extern	i286h_localint

	.globl	i286h_cts

	.text
	.align	2

	
i286h_cts:
	mov	r12,r10
	GETPCF8
	cmp/eq	#0,r0
	bt/s	cts_0
	cmp/eq	#1,r0
	bf/s	1f
	cmp/eq	#5,r0
	bra	cts_1
	nop
1:	
	bf	cts_intr
	bra	cts_ldall
	nop
cts_intr:
	mov	#((1 << 16) >> 16),r0
	mov	r10,r12
	mov.l	201f,r3
	shll16	r0
	mov	#6,r10
	jmp	@r3
	sub	r0,r12

	_GETPCF8
201:	.long	i286h_localint
cts_0:
	mov.w	@(CPU_MSW,gbr),r0
	extu.w	r0,r8
	GETPCF8
	mov	r0,r4
	mov	r8,r0
	mov	#(7 << 3),r2
	tst	#MSW_PE,r0
	bt/s	cts_intr
	and	r4,r2
	mova	00f,r0
	shlr	r2
	add	r2,r0
	mov	#0xc0,r2
	jmp	@r0
	extu.b	r2,r2

	.align	2
00:
	bra		sldt
	nop
	bra		_str
	nop
	bra		lldt
	nop
	bra		_ltr
	nop
	bra		verr
	nop
	bra		verw
	nop
	bra		verr
	nop
	bra		verw
	nop
sldt:
	cmp/hs	r2,r4
	bf	sldtm
	CPUWORK	2
	R16SRC	r4, r9
	mov.w	@(CPU_LDTR,gbr),r0
	jmp	@r13
	mov.w	r0,@r9

	_GETPCF8
sldtm:
	mov.l	200f,r3
	CPUWORK	3
	jsr	@r3
	nop
	lds	r13,pr
	mov	r0,r4
	mov.l	10003f,r3
	mov	r5,r0
	jmp	@r3
	mov.w	r0,@(CPU_LDTR,gbr)

	.align	2
200:	.long	i286h_ea
1003:	.long	i286h_memorywrite_w
_str:
	cmp/hs	r2,r4
	bf	_strm
	CPUWORK	3
	R16SRC	r4, r9
	mov.w	@(CPU_TR,gbr),r0
	jmp	@r13
	mov.w	r0,@r9
_strm:
	mov.l	200f,r3
	CPUWORK	6
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	10003f,r3
	mov.w	@(CPU_TR,gbr),r0
	lds	r13,pr
	jmp	@r3
	extu.w	r0,r5

	.align	2
200:	.long	i286h_ea
1003:	.long	i286h_memorywrite_w
lldt:
	cmp/hs	r2,r4
	bf	lldtm
	CPUWORK	17
	R16SRC	r4, r9
	mov.w	@r9,r4
	bra	lldte
	extu.w	r4,r0
lldtm:
	mov.l	200f,r3
	CPUWORK	19
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
lldte:
	mov.l	201f,r3
	mov	r0,r4
	jsr	@r3
	mov.w	r0,@(CPU_LDTR,gbr)
	mov.l	10001f,r3
	mov	r0,r4
	jsr	@r3
	mov	r0,r8
	mov.l	10001f,r3
	mov.w	r0,@(CPU_LDTRC + 0,gbr)
	mov	r8,r4
	jsr	@r3
	add	#2,r4
	mov.l	10000f,r3
	mov.w	r0,@(CPU_LDTRC + 2,gbr)
	mov	r8,r4
	jsr	@r3
	add	#4,r4
	jmp	@r13
	mov.b	r0,@(CPU_LDTRC + 4,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
201:	.long	i286h_selector
10000:	.long	i286h_memoryread
_ltr:
	cmp/hs	r2,r4
	bf	_ltrm
	CPUWORK	17
	R16SRC	r4, r9
	mov.w	@r9,r4
	bra	_ltre
	extu.w	r4,r0
_ltrm:
	mov.l	200f,r3
	CPUWORK	19
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
_ltre:
	mov.l	201f,r3
	mov.w	r0,@(CPU_TR,gbr)
	jsr	@r3
	mov	r0,r4
	mov.l	10001f,r3
	mov	r0,r4
	jsr	@r3
	mov	r0,r8
	mov.l	10001f,r3
	mov.w	r0,@((CPU_TRC + 0),gbr)
	mov	r8,r4
	jsr	@r3
	add	#2,r4
	mov.l	10000f,r3
	mov.w	r0,@((CPU_TRC + 2),gbr)
	mov	r8,r4
	jsr	@r3
	add	#4,r4
	jmp	@r13
	mov.w	r0,@((CPU_TRC + 4),gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
201:	.long	i286h_selector
10000:	.long	i286h_memoryread	
verr:
	cmp/hs	r2,r4
	bf	verrm
	CPUWORK	14
	jmp	@r13
	nop
verrm:
	mov.l	200f,r3
	CPUWORK	16
.if 0
	jsr	@r3
	nop
	jmp	@r13
	nop
.else
	jmp	@r3
	lds	r13,pr
.endif

	.align	2
200:	.long	i286h_ea
verw:
	cmp/hs	r2,r4
	bf	verwm
	CPUWORK	14
	jmp	@r13
	nop
verwm:
	mov.l	200f,r3
	CPUWORK	16
.if 0
	jsr	@r3
	nop
	jmp	@r13
	nop
.else
	jmp	@r3
	lds	r13,pr
.endif
	
	.align	2
200:	.long	i286h_ea
cts_1:	GETPCF8
	mov	r0,r4
	mov	#(7 << 3),r2
	and	r4,r2
	mova	00f,r0
	shlr	r2
	add	r2,r0
	mov	#0xc0,r2
	jmp	@r0
	extu.b	r2,r2

	.align	2
00:
	bra		sgdt
	nop
	bra		sidt
	nop
	bra		lgdt
	nop
	bra		lidt
	nop
	bra		smsw
	nop
	bra		smsw
	nop
	bra		lmsw
	nop
	bra		lmsw
	nop
sgdt:
	cmp/hs	r2,r4
	bf	1f
	bra	cts_intr
	nop

	_GETPCF8
1:
	mov.l	200f,r3
	CPUWORK	11
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	mov.w	@((CPU_GDTR + 0),gbr),r0
	add	#2,r8
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	swap.w	r8,r8
	mov.l	10003f,r3
	extu.w	r0,r5
	jsr	@r3
	add	r10,r4
	mov	r10,r4
	mov.w	@((CPU_GDTR + 2),gbr),r0
	add	r8,r4
	mov.l	10003f,r3
	add	#2,r8
	jsr	@r3
	extu.w	r0,r5
	mov.b	@((CPU_GDTR + 4),gbr),r0
	mov	#~((1 << 16) >> 16),r3
	extu.b	r0,r0
	shll8	r0
	swap.w	r8,r8
	or	#0xff,r0
	and	r3,r8
	swap.b	r0,r5
	mov.l	10003f,r3
	swap.w	r8,r8
	lds	r13,pr
	mov	r10,r4
	jmp	@r3
	add	r8,r4

	.align	2
200:	.long	i286h_a
10003:	.long	i286h_memorywrite_w
sidt:
	cmp/hs	r2,r4
	bf	1f
	bra	cts_intr
	nop
1:
	mov.l	200f,r3
	CPUWORK	12
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	mov.w	@((CPU_IDTR + 0),gbr),r0
	add	#2,r8
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	swap.b	r8,r8
	mov.l	10003f,r3
	extu.w	r0,r5
	jsr	@r3
	add	r10,r4
	mov	r10,r4
	mov.w	@((CPU_IDTR + 2),gbr),r0
	mov.l	10003f,r3
	add	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	#2,r8
	mov.b	@((CPU_IDTR + 4),gbr),r0
	mov	#~((1 << 16) >> 16),r3
	extu.b	r0,r0
	shll8	r0
	swap.w	r8,r8
	or	#0xff,r0
	and	r3,r8
	swap.b	r0,r5
	mov.l	10003f,r3
	swap.w	r8,r8
	lds	r13,pr
	mov	r10,r4
	jmp	@r3
	add	r8,r4

	.align	2
200:	.long	i286h_a
10003:	.long	i286h_memorywrite_w
lgdt:
	cmp/hs	r2,r4
	bf	1f
	bra	cts_intr
	nop
1:
	mov.l	200f,r3
	CPUWORK	11
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	add	#2,r8
	mov.l	10001f,r3
	jsr	@r3
	add	r10,r4
	mov.w	r0,@((CPU_GDTR + 0),gbr)
	mov.l	10001f,r3
	mov	r10,r4
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov.w	r0,@((CPU_GDTR + 2),gbr)
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	mov.l	10001f,r3
	swap.w	r8,r8
	mov	r10,r4
	jsr	@r3
	add	r8,r4
	jmp	@r13
	mov.w	r0,@((CPU_GDTR + 4),gbr)	

	.align	2
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w	

lidt:
	cmp/hs	r2,r4
	bf	1f
	bra	cts_intr
	nop
1:
	mov.l	200f,r3
	CPUWORK	12
	jsr	@r3
	nop
	mov	r0,r4
	mov	r0,r8
	add	#2,r8
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	swap.w	r8,r8
	mov.l	10001f,r3
	jsr	@r3
	add	r10,r4
	mov.w	r0,@((CPU_IDTR + 0),gbr)
	mov	r10,r4
	mov.l	10001f,r3
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov.w	r0,@((CPU_IDTR + 2),gbr)
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	mov.l	10001f,r3
	swap.w	r8,r8
	mov	r10,r4
	jsr	@r3
	add	r8,r4
	jmp	@r13
	mov.w	r0,@((CPU_IDTR + 4),gbr)

	.align	2
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
smsw:
	cmp/hs	r2,r4
	bf	smswm
	CPUWORK	3
	mov.w	@(CPU_MSW,gbr),r0
	extu.w	r0,r5
	R16SRC	r4, r9
	jmp	@r13
	mov.w	r5,@r9
smswm:
	mov.l	200f,r3
	CPUWORK	6
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	10003f,r3
	mov.w	@(CPU_MSW,gbr),r0
	lds	r13,pr
	jmp	@r3
	extu.w	r0,r5

	.align	2
200:	.long	i286h_ea
10003:	.long	i286h_memorywrite_w
lmsw:
	mov.w	@(CPU_MSW,gbr),r0
	cmp/hs	r2,r4
	bf/s	lmswm
	extu.w	r0,r10
	CPUWORK	3
	R16SRC	r4, r9
	mov.w	@r9,r0
	mov	#MSW_PE,r4
	and	r4,r10
	or	r10,r0
	jmp	@r13
	mov.w	r0,@(CPU_MSW,gbr)
lmswm:
	mov.l	200f,r3
	CPUWORK	6
	jsr	@r3
	nop
	mov.l	10001f,r3
	jsr	@r3
	mov	r0,r4
	mov	#MSW_PE,r4
	and	r4,r10
	or	r10,r0
	jmp	@r13
	mov.w	r0,@(CPU_MSW,gbr)

	.align	2
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w

	
cts_ldall:
	mov	r4,r0
	cmp/eq	#5,r0
	bt	1f
	bra	cts_intr
	nop
1:
	mov	#(0x800 >> 8),r10
	CPUWORK	100
	shll8	r10
	CPUWORK	95
	add	r1,r10
	mov.w	@(0x04,r10),r0		! MSW
	mov.w	r0,@(CPU_MSW,gbr)
	mov.w	@(0x16,r10),r0		! TR
	mov.w	r0,@(CPU_TR,gbr)
	mov.l	@(0x18,r10),r0		! IP:flag
	swap.w	r0,r12
	shll8	r12
	shlr8	r12
	swap.w	r12,r12
	mov.l	@(0x1c,r10),r0		! DS:LDTR
	mov.w	r0,@(CPU_LDTR,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_DS,gbr)
	mov.l	@(0x20,r10),r0		! CS:SS
	mov.w	r0,@(CPU_SS,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_CS,gbr)
	mov.l	@(0x24,r10),r0		! DI:ES
	mov.w	r0,@(CPU_ES,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_DI,gbr)

	mov.l	@(0x28,r10),r0		! BP:SI
	mov.w	r0,@(CPU_SI,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_BP,gbr)
	mov.l	@(0x2c,r10),r0		! BX:SP
	mov.w	r0,@(CPU_SP,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_BX,gbr)
	mov.l	@(0x30,r10),r0		! CX:DX
	mov.w	r0,@(CPU_DX,gbr)
	shlr16	r0
	mov.w	r0,@(CPU_CX,gbr)
	mov.l	@(0x34,r10),r0		! ES:AX
	mov.w	r0,@(CPU_AX,gbr)

	mov	r0,r4
	mov	#0x38,r0
	shlr16	r4
	mov.b	@(r0,r10),r5		! ES
	extu.b	r5,r0
	shll16	r0
	or	r4,r0
	mov.l	r0,@(CPU_ES_BASE,gbr)
	mov.l	@(0x3c,r10),r0		! CS
	mov	#0xff,r3
	shll8	r3
	shlr8	r3
	and	r3,r0
	mov.l	r0,@(CPU_CS_BASE,gbr)
	mov	#0x42,r0
	mov.w	@(r0,r10),r7		! SS
	mov	#0x44,r0
	extu.w	r7,r7
	mov.b	@(r0,r10),r8		! SS
	extu.b	r8,r0
	shll16	r0
	or	r7,r0
	mov.l	r0,@(CPU_SS_BASE,gbr)
	mov.l	r0,@(CPU_SS_FIX,gbr)
	mov	#0x48,r0
	mov.l	@(r0,r10),r0		! DS
	and	r3,r0
	mov.l	r0,@(CPU_DS_BASE,gbr)
	mov.l	r0,@(CPU_DS_FIX,gbr)
	mov	#0x4e,r0
	mov.w	@(r0,r10),r0			! GDTR.base
	mov.w	r0,@((CPU_GDTR + 2),gbr)
	mov	#0x50,r0
	mov.l	@(r0,r10),r0			! GDTR.limit:ar:base24
	mov.w	r0,@((CPU_GDTR + 4),gbr)
	
	shlr16	r0
	mov.w	r0,@((CPU_GDTR + 0),gbr)
	mov	#0x54,r0
	mov.l	@(r0,r10),r0			! LDTRC.ar:base24:base
	mov.w	r0,@((CPU_LDTRC + 2),gbr)
	shlr16	r0

	mov.w	r0,@((CPU_LDTRC + 4),gbr)
	mov	#0x58,r0
	mov.l	@(r0,r10),r0			! IDTR.base:LDTRC.limit
	mov.w	r0,@((CPU_LDTRC + 0),gbr)
	shlr16	r0
	mov.w	r0,@((CPU_IDTR + 2),gbr)
	mov	#0x5c,r0
	mov.l	@(r0,r10),r0		! IDTR.limit:ar:base24
	mov.w	r0,@((CPU_IDTR + 4),gbr)
	shlr16	r0
	mov.w	r0,@((CPU_IDTR + 0),gbr)
	mov	#0x60,r0
	mov.l	@(r0,r10),r0		! TRC.ar:base24:base
	mov.w	r0,@((CPU_TRC + 2),gbr)
	shlr16	r0
	mov.w	r0,@((CPU_TRC + 4),gbr)
	mov	#0x64,r0
	mov.w	@(r0,r10),r0		! TRC.limit
	mov.w	r0,@((CPU_TRC + 0),gbr)
	I286IRQCHECKTERM
	
	.end
