
.macro OP_EA_R8	alu, regclk, memclk
	EAREG8	r2
	mov	#0xc0,r3
	mov.b	@r2,r10
	extu.b	r3,r3
	mov	r0,r4
	cmp/hs	r3,r4
	bf/s	8000f
	extu.b	r10,r10
	R8SRC	r4, r9
	CPUWORK	\regclk
	mov.b	@r9,r8
	extu.b	r8,r8
	\alu	r8, r10
	jmp	@r13
	mov.b	r5,@r9
8000:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov.l	20000f,r3
	cmp/hs	r3,r0
	bt/s	8001f
	mov	r0,r4
	add	r1,r4
	mov.b	@r4,r8
	extu.b	r8,r8
	\alu	r8, r10
	jmp	@r13
	mov.b	r5,@r4
8001:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	\alu	r4, r10
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10004:	.long	i286h_ea
20000:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite	
.endm

.macro OP_EA_R16	alu, regclk, memclk
	EAREG16	r2
	mov	#0xc0,r3
	mov.w	@r2,r10
	mov	r0,r4
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	8002f
	extu.w	r10,r10
	CPUWORK	\regclk
	R16SRC	r4, r9
	mov.w	@r9,r8
	extu.w	r8,r8
	\alu	r8, r10
	jmp	@r13
	mov.w	r5,@r9
8002:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4,8003f
	add	r1,r4
	mov.w	@r4,r8
	extu.w	r8,r8
	\alu	r8, r10
	jmp	@r13
	mov.w	r5,@r4
8003:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	\alu	r4, r10
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	_EAREG16
	_ACCWORD
10004:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w
.endm

.macro	OP_R8_EA	alu, regclk, memclk
	REG8EA	r10, \regclk, \memclk
	mov.b	@r10,r8
	mov	r0,r4
	extu.b	r8,r8
	\alu	r8, r4
	jmp	@r13
	mov.b	r5,@r10

	_REG8EA
.endm

.macro OP_R16_EA	alu, regclk, memclk
	REG16EA	r10, \regclk, \memclk
	mov.w	@r10,r8
	mov	r0,r4
	extu.w	r8,r8
	\alu	r8, r4
	jmp	@r13
	mov.w	r5,@r10

	_REG16EA
.endm

.macro OP_AL_D8	alu, clk
	CPUWORK	\clk
	GETPCF8
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r8
	\alu	r8, r4
	mov	r5,r0
	jmp	@r13
	mov.b	r0,@(CPU_AL,gbr)

	_GETPCF8
.endm
	
.macro OP_AX_D16	alu, clk
	CPUWORK	\clk
	GETPC16
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r8
	\alu	r8, r4
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)

	_GETPC16
.endm
	
.macro S_EA_R8		alu, regclk, memclk
	EAREG8	r2
	mov.b	@r2,r10
	mov	#0xc0,r3
	mov	r0,r4
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	8004f
	extu.b	r10,r10
	CPUWORK	\regclk
	R8SRC	r4, r9
	mov.b	@r9,r8
	extu.b	r8,r8
	\alu	r8, r10
	jmp	@r13
	nop
8004:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov.l	20000f,r3
	cmp/hs	r3,r0
	bt/s	8005f
	mov	r0,r4
	mov.b	@(r0,r1),r8
	extu.b	r8,r8
	\alu	r8, r10
	jmp	@r13
	nop
8005:
	mov.l	10000f,r3
	jsr	@r3
	nop
	mov	r0,r4
	\alu	r4, r10
	jmp	@r13
	nop

	_EAREG8	
10004:	.long	i286h_ea
20000:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread
.endm

.macro	S_EA_R16	alu, regclk, memclk
	EAREG16	r2
	mov	#0xc0,r3
	mov.w	@r2,r10
	mov	r0,r4
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	8006f
	extu.w	r10,r10
	CPUWORK	\regclk
	R16SRC	r4, r9
	mov.w	@r9,r8
	extu.w	r8,r8
	\alu	r8, r10
	jmp	@r13
	nop
8006:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4,8007f
	mov	r1,r0
	mov.w	@(r0,r4),r8
	extu.w	r8,r8
	\alu	r8, r10
	jmp	@r13
	nop
8007:
	mov.l	10001f,r3
	jsr	@r3
	nop
	mov	r0,r4
	\alu	r4, r10
	jmp	@r13
	nop

	_EAREG16
10004:	.long	i286h_ea
	_ACCWORD
10001:	.long	i286h_memoryread_w
.endm
	
.macro	S_R8_EA		alu, regclk, memclk
	REG8EA	r10, \regclk, \memclk
	mov.b	@r10,r8
	mov	r0,r4
	extu.b	r8,r8
	\alu	r8, r4
	jmp	@r13
	nop

	_REG8EA
.endm
	
.macro	S_R16_EA	alu, regclk, memclk
	REG16EA	r10, \regclk, \memclk
	mov.w	@r10,r8
	mov	r0,r4
	extu.w	r8,r8
	\alu	r8, r4
	jmp	@r13
	nop

	_REG16EA
.endm
	
.macro	S_AL_D8		alu, clk
	CPUWORK	\clk
	GETPC8
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r8
	\alu	r8, r4
	jmp	@r13
	nop

	_GETPC8
.endm
	
.macro	S_AX_D16	alu, clk
	CPUWORK	\clk
	GETPC16
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r8
	\alu	r8, r4
	jmp	@r13
	nop

	_GETPC16
.endm

.macro	OP_EA8		alu, regclk, memclk
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	8008f
	CPUWORK	\regclk
	R8SRC	r4, r9
	mov.b	@r9,r8
	extu.b	r8,r8
	\alu	r8
	jmp	@r13
	mov.b	r5,@r9
8008:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov.l	20000f,r3
	cmp/hs	r3,r0
	bt/s	8009f
	mov	r0,r4
	mov.b	@(r0,r1),r8
	extu.b	r8,r8
	\alu	r8
	mov	r4,r0
	jmp	@r13
	mov.b	r5,@(r0,r1)
8009:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	\alu	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10004:	.long	i286h_ea
20000:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite
.endm
	
.macro	OP_EA16		alu, regclk, memclk
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	8010f
	CPUWORK	\regclk
	R16SRC	r4, r9
	mov.w	@r9,r8
	extu.w	r8,r8
	\alu	r8
	jmp	@r13
	mov.w	r5,@r9
8010:
	mov.l	10004f,r3
	CPUWORK	\memclk
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4,8011f
	add	r1,r4
	mov.w	@r4,r8
	extu.w	r8,r8
	\alu	r8
	jmp	@r13
	mov.w	r5,@r4
8011:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	\alu	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	_ACCWORD
10004:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w
.endm
	
.macro	OP_INC16	r, clk
	CPUWORK	\clk
	mov.w	@(\r,gbr),r0
	extu.w	r0,r6
	INC16	r6
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(\r,gbr)
.endm

	
.macro	OP_DEC16	r, clk
	CPUWORK	\clk
	mov.w	@(\r,gbr),r0
	extu.w	r0,r6
	DEC16	r6
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(\r,gbr)
.endm


	
.macro	XCHG_AX		r, clk
	CPUWORK	\clk
	mov.w	@(\r,gbr),r0
	extu.w	r0,r5
	mov.w	@(CPU_AX,gbr),r0
	mov.w	r0,@(\r,gbr)
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
.endm



.macro	MOVIMM8		r, clk
	CPUWORK	\clk
	GETPCF8
	jmp	@r13
	mov.b	r0,@(\r,gbr)

	_GETPCF8
.endm
	
.macro	MOVIMM16	r, clk
	CPUWORK	\clk
	GETPCF16
	jmp	@r13
	mov.w	r0,@(\r,gbr)

	_GETPCF16
.endm
	
.macro	SP_PUSH		clk
	CPUWORK	\clk
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10003f,r3
	mov	r0,r6
	mov	r5,r0
	add	#-2,r0
	mov	r0,r4
	extu.w	r4,r4
	mov.w	r0,@(CPU_SP,gbr)
	lds	r13,pr
	jmp	@r3
	add	r6,r4

	.align	2
10003:	.long	i286h_memorywrite_w
.endm
	
.macro	SP_POP		clk
	CPUWORK	\clk
	mov.l	10001f,r3
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	jsr	@r3
	add	r0,r4
	jmp	@r13
	mov.w	r0,@(CPU_SP,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
.endm
	
.macro	SEGPOP		s, b, clk
	mov.w	@(CPU_MSW,gbr),r0
	extu.w	r0,r10
	POP	\clk
	mov.w	r0,@(\s,gbr)
	mov	#MSW_PE,r3
	tst	r3,r10
	bf/s	8012f
	mov	r0,r4
	mov	#(8013f - 8012f),r3
	mov	#4,r4
	braf	r3
	shld	r4,r0
8012:
	mov.l	10005f,r3
	jsr	@r3
	nop
8013:
	jmp	@r13
	mov.l	r0,@(\b,gbr)

	_POP
10005:	.long	i286h_selector
.endm
	
.macro	SEGPOPFIX	s, b, f, clk
	mov.w	@(CPU_MSW,gbr),r0
	extu.w	r0,r10
	POP	\clk
	mov.w	r0,@(\s,gbr)
	mov	#MSW_PE,r3
	tst	r3,r10
	bf/s	8014f
	mov	r0,r4
	mov	#(8015f - 8014f),r3
	mov	#4,r4
	braf	r3
	shld	r4,r0
8014:
	mov.l	10005f,r3
	jsr	@r3
	nop
8015:
	mov.l	r0,@(\b,gbr)
	mov.l	r0,@(\f,gbr)
.endm

.macro	_SEGPOPFIX
	_POP
10005:	.long	i286h_selector
.endm

.macro	JMPS	jmpclk
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r9
	CPUWORK	\jmpclk
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	mov	#24,r3
	mov	#((1 << 16) >> 16),r4
	shld	r3,r0
	shll16	r4
	mov	#-8,r3
	add	r4,r12
	shad	r3,r0
	jmp	@r13
	add	r0,r12

	_GETR0
.endm

.macro	JMPNE8		f, nojclk, jmpclk
	mov	r12,r0
	tst	#\f,r0
	bf/s	8016f
	mov	#1,r3
	CPUWORK	\nojclk
	shll16	r3
	jmp	@r13
	add	r3,r12
8016:
	JMPS	\jmpclk
.endm

.macro	JMPNE16		f, nojclk, jmpclk
	swap.b	r12,r0	
	tst	#(\f >> 8),r0
	bf/s	8017f
	mov	#1,r3
	CPUWORK	\nojclk
	shll16	r3
	jmp	@r13
	add	r3,r12
8017:
	JMPS	\jmpclk
.endm
	
.macro	JMPEQ8		f, nojclk, jmpclk
	mov	r12,r0
	tst	#\f,r0
	bt/s	8018f
	mov	#1,r3
	CPUWORK	\nojclk
	shll16	r3
	jmp	@r13
	add	r3,r12
8018:
	JMPS	\jmpclk
.endm

.macro	JMPEQ16		f, nojclk, jmpclk
	swap.b	r12,r0
	tst	#(\f >> 8),r0
	bt/s	8019f
	mov	#1,r3
	CPUWORK	\nojclk
	shll16	r3
	jmp	@r13
	add	r3,r12
8019:
	JMPS	\jmpclk
.endm

	
