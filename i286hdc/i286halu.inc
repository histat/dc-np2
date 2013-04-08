
.macro ADD8	d, s
	mov	\s,r5
	mov	#24,r3
	mov	\d,r6
	shld	r3,r5
	shld	r3,r6
	mov	r5,r2
	addv	r6,r5
	bf/s	3000f
	clrt
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	mov	#(3001f - 3000f),r3
	braf	r3
	swap.b	r0,r12
3000:
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	swap.b	r12,r12
3001:
	mov	#-24,r3
	addc	r6,r2
	shld	r3,r5
	mov	\s,r2
	mov	r5,r0
	xor	r5,r2
	mov.b	@(r0,r14),r6
	xor	\d,r2
	bf/s	3002f
	extu.b	r6,r6
	add	#C_FLAG,r6
3002:
	mov	#A_FLAG,r0
	shlr8	r12
	and	r0,r2
	shll8	r12
	or	r2,r6
	add	r6,r12
.endm

.macro OR8	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	or	\d,r5
	mov	r5,r0
	and	r3,r12
	swap.b	r12,r12
	mov.b	@(r0,r14),r2
	shlr8	r12
	extu.b	r2,r2
	shll8	r12
	or	r2,r12
.endm

.macro	ADC8	d, s
	mov	#C_FLAG,r5
	and	r12,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	add	\s,r5
	add	\d,r5
	and	r3,r12
	mov	\d,r2
	swap.b	r12,r12
	xor	r5,r2
	mov	\s,r0
	xor	r5,r0
	and	r2,r0
	xor	\s,r2
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
	mov	#A_FLAG,r3
	mov	r5,r0
	and	r3,r2
	mov.b	@(r0,r14),r6
	shlr8	r12
	extu.b	r6,r6
	shll8	r12
	or	r2,r6
	or	r6,r12
.endm

.macro	SBB8	d, s
	mov	#C_FLAG,r2
	mov	\d,r5
	and	r12,r2
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	sub	\s,r5
	and	r3,r12
	sub	r2,r5
	swap.b	r12,r12
	mov	\d,r2
	xor	\s,r2
	mov	\d,r0
	xor	r5,r0
	and	r2,r0
	xor	r5,r2
	mov	#A_FLAG,r3
	and	#0x80,r0
	and	r3,r2
	mov	#4,r3
	shld	r3,r0
	or	r0,r12
	mov	#(32 - 9),r3
	mov	r5,r0
	shld	r3,r0
	mov	#-(32 - 9),r3
	shld	r3,r0
	mov.b	@(r0,r14),r6
	shlr8	r12
	extu.b	r6,r6
	shll8	r12
	or	r2,r6
	or	r6,r12
.endm
	
.macro	AND8	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	and	\d,r5
	swap.b	r12,r12
	mov	r5,r0
	and	r3,r12
	mov.b	@(r0,r14),r2
	swap.b	r12,r12
	shlr8	r12
	extu.b	r2,r2
	shll8	r12
	or	r2,r12
.endm

.macro	SUB8	d, s
	mov	\d,r5
	mov	#24,r3
	shld	r3,r5
	mov	\s,r6
	shld	r3,r6
	mov	r5,r2
	subv	r6,r5
	bf/s	3013f
	clrt
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	mov	#(3014f - 3013f),r3
	braf	r3
	swap.b	r0,r12
3013:
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	swap.b	r12,r12
3014:
	mov	#-24,r3
	subc	r6,r2
	shld	r3,r5
	mov	\s,r2
	xor	r5,r2
	mov	r5,r0
	mov.b	@(r0,r14),r0
	xor	\d,r2
	bf/s	3015f
	extu.b	r0,r0
	or	#C_FLAG,r0
3015:	
	mov	#A_FLAG,r3
	shlr8	r12
	and	r3,r2
	shll8	r12
	or	r2,r0
	or	r0,r12
.endm

.macro	XOR8	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	xor	\d,r5
	and	r3,r12
	mov	r5,r0
	swap.b	r12,r12
	mov.b	@(r0,r14),r2
	shlr8	r12
	extu.b	r2,r2
	shll8	r12
	or	r2,r12
.endm

.macro	ADD16	d, s
	mov	\s,r5
	shll16	r5
	mov	\d,r6
	shll16	r6
	mov	r5,r2
	addv	r6,r5
	bf/s	9006f
	clrt
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	mov	#(9007f - 9006f),r3
	braf	r3
	swap.b	r0,r12
9006:
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	swap.b	r12,r12
9007:
	shlr16	r5
	addc	r6,r2
	extu.b	r5,r0
	mov	r2,r7
	mov	\d,r2
	mov.b	@(r0,r14),r0
	xor	r5,r2
	and	#P_FLAG,r0
	xor	\s,r2
	bf/s	9008f
	tst	r7,r7
	or	#C_FLAG,r0
9008:
	bf/s	9009f
	cmp/pz	r7
	or	#Z_FLAG,r0
9009:
	bt/s	9010f
	mov	#A_FLAG,r7
	or	#S_FLAG,r0
9010:	
	shlr8	r12
	and	r2,r7
	shll8	r12
	or	r0,r7
	add	r7,r12
.endm

.macro	OR16	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	or	\d,r5
	and	r3,r12
	extu.b	r5,r0
	swap.b	r12,r12
	mov.b	@(r0,r14),r0
	shlr8	r12
	mov	r5,r6
	shll8	r12
	and	#P_FLAG,r0
	shll16	r6
	tst	r6,r6
	bf/s	9011f
	cmp/pz	r6
	or	#Z_FLAG,r0
9011:
	bt	9012f
	or	#S_FLAG,r0
9012:	
	or	r0,r12
.endm

.macro	ADC16	d, s
	mov	#C_FLAG,r5
	and	r12,r5
	add	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	add	\d,r5
	and	r3,r12
	mov	\d,r2
	swap.b	r12,r12
	xor	r5,r2
	mov	\s,r6
	xor	r5,r6
	and	r2,r6
	xor	\s,r2
	swap.b	r6,r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
	mov	r5,r7
	mov	r2,r0
	shll16	r7
	and	#A_FLAG,r0
	tst	r7,r7
	bf/s	9013f
	cmp/pz	r7
	or	#Z_FLAG,r0
9013:	
	bt/s	9014f
	shlr8	r12
	or	#S_FLAG,r0
9014:
	mov	r0,r2
	extu.b	r5,r0
	shll8	r12
	mov.b	@(r0,r14),r6
	mov	#P_FLAG,r3
	and	r3,r6
	mov	r5,r0
	or	r2,r6
	shlr16	r0
	or	r6,r12
	tst	#1,r0
	bt/s	9015f
	mov	#C_FLAG,r3
	or	r3,r12
9015:	
.endm

.macro	SBB16	d, s
	mov	#C_FLAG,r2
	mov	\d,r5
	and	r12,r2
	sub	\s,r5
	shlr8	r12
	sub	r2,r5
	shll8	r12
	cmp/pz	r5
	bt/s	9016f
	mov	\d,r2
	add	#C_FLAG,r12
9016:	
	xor	\s,r2
	mov	\d,r6
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	xor	r5,r6
	and	r3,r12
	and	r2,r6
	swap.b	r12,r12
	xor	r5,r2
	extu.b	r5,r0
	mov.b	@(r0,r14),r7
	swap.b	r6,r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	mov	#P_FLAG,r6
	or	r0,r12
	mov	#A_FLAG,r0
	and	r7,r6
	mov	r5,r7
	shll16	r7
	and	r2,r0
	tst	r7,r7
	bf/s	9017f
	cmp/pz	r7
	or	#Z_FLAG,r0
9017:	
	bt	9018f
	or	#S_FLAG,r0
9018:	
	or	r0,r6
	or	r6,r12
.endm

.macro	AND16	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	\d,r5
	and	r3,r12
	extu.b	r5,r0
	swap.b	r12,r12
	mov.b	@(r0,r14),r0
	shlr8	r12
	mov	r5,r6
	shll8	r12
	and	#P_FLAG,r0
	shll16	r6
	tst	r6,r6
	bf/s	9019f
	cmp/pz	r6
	or	#Z_FLAG,r0
9019:
	bt	9020f
	or	#S_FLAG,r0
9020:	
	or	r0,r12
.endm
	
.macro	SUB16	d, s
	mov	\d,r5
	mov	\s,r6
	shll16	r5
	shll16	r6
	mov	r5,r7
	subv	r6,r5
	bf/s	9021f
	clrt
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	mov	#(9022f - 9021f),r3
	braf	r3
	swap.b	r0,r12
9021:
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	swap.b	r12,r12
9022:
	shlr16	r5
	subc	r6,r7
	extu.b	r5,r0
	mov	\d,r2
	xor	r5,r2
	mov.b	@(r0,r14),r0
	xor	\s,r2
	and	#P_FLAG,r0
	bf/s	9023f
	tst	r7,r7
	or	#C_FLAG,r0
9023:
	bf/s	9024f
	cmp/pz	r7
	or	#Z_FLAG,r0
9024:
	bt/s	9025f
	mov	#A_FLAG,r3
	or	#S_FLAG,r0
9025:
	shlr8	r12
	and	r3,r2
	shll8	r12
	or	r2,r0
	add	r0,r12
.endm

.macro	XOR16	d, s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	xor	\d,r5
	and	r3,r12
	extu.b	r5,r0
	swap.b	r12,r12
	mov.b	@(r0,r14),r0
	shlr8	r12
	mov	r5,r6
	shll8	r12
	and	#P_FLAG,r0
	shll16	r6
	tst	r6,r6
	bf/s	9026f
	cmp/pz	r6
	or	#Z_FLAG,r0
9026:	
	bt	9027f
	or	#S_FLAG,r0
9027:	
	or	r0,r12
.endm

.macro	INC8	s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	add	#1,r5
	and	r3,r12
	mov	\s,r2
	swap.b	r12,r12
	mov	r12,r0
	shlr8	r12
	and	#~(0xff - C_FLAG),r0
	shll8	r12
	or	r0,r12
	xor	r5,r2
	mov	r5,r6
	mov	#A_FLAG,r3
	and	r2,r6
	extu.b	r6,r0
	tst	#0x80,r0
	bt/s	9028f
	and	r3,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r12
9028:
	extu.b	r5,r0
	mov.b	@(r0,r14),r6
	or	r2,r12
	extu.b	r6,r6
	or	r6,r12
.endm

.macro	INC16	s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	add	#1,r5
	and	r3,r12
	mov	\s,r2
	swap.b	r12,r12
	mov	r12,r0
	xor	r5,r2
	shlr8	r12
	mov	r5,r6
	and	#~(0xff - C_FLAG),r0
	mov	#A_FLAG,r3
	shll8	r12
	and	r2,r6
	or	r0,r12
	exts.w	r6,r7
	cmp/pz	r7
	bt/s	9029f
	and	r3,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r12
9029:
	extu.b	r5,r0
	mov.b	@(r0,r14),r6
	mov	r5,r7
	extu.b	r6,r6
	shll16	r7
	tst	r7,r7
	mov	r12,r0
	bf/s	9030f
	cmp/pz	r7
	or	#Z_FLAG,r0
9030:	
	bt/s	9031f
	mov	#P_FLAG,r3
	or	#S_FLAG,r0
9031:
	mov	r0,r12
	and	r3,r6
	or	r2,r12
	or	r6,r12
.endm

.macro	DEC8	s
	mov	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	add	#-1,r5
	mov	\s,r2
	and	r3,r12
	swap.b	r12,r12
	mov	r12,r0
	xor	r5,r2
	shlr8	r12
	mov	\s,r6
	and	#~(0xff - C_FLAG),r0
	mov	#A_FLAG,r3
	shll8	r12
	and	r2,r6
	or	r0,r12
	exts.w	r6,r0
	cmp/pz	r0
	bt/s	9032f
	and	r3,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r12
9032:
	extu.b	r5,r0
	mov.b	@(r0,r14),r6
	or	r2,r12
	extu.b	r6,r6
	or	r6,r12
.endm

.macro	DEC16	s
	mov	\s,r5
	mov	#~(O_FLAG >>8),r3
	swap.b	r12,r12
	add	#-1,r5
	mov	\s,r2
	and	r3,r12
	swap.b	r12,r12
	mov	r12,r0
	xor	r5,r2
	shlr8	r12
	mov	\s,r6
	and	#~(0xff - C_FLAG),r0
	mov	#A_FLAG,r3
	shll8	r12
	and	r2,r6
	or	r0,r12
	exts.w	r6,r0
	cmp/pz	r0
	bt/s	9033f
	and	r3,r2
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r12
9033:
	extu.b	r5,r0
	mov.b	@(r0,r14),r6
	mov	r5,r7
	extu.b	r6,r6
	shll16	r7
	tst	r7,r7
	mov	r2,r0
	bf/s	9034f
	cmp/pz	r7
	or	#Z_FLAG,r0
9034:
	bt/s	9035f
	mov	#P_FLAG,r3
	or	#S_FLAG,r0
9035:
	and	r3,r6
	or	r0,r12
	or	r6,r12
.endm

.macro	NOT8	s
	not	\s,r5
.endm

.macro	NOT16	s
	not	\s,r5
.endm

.macro	NEG8	s
	neg	\s,r5
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov	\s,r2
	and	r3,r12
	mov	\s,r6
	swap.b	r12,r12
	and	r5,r2
	shlr8	r12
	xor	r5,r6
	shll8	r12
	mov	r2,r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
	mov	#A_FLAG,r3
	and	r3,r6
	mov	r5,r0
	or	r6,r12
	mov	#(32 - 9),r3
	shld	r3,r0
	mov	#-(32 - 9),r3
	shld	r3,r0
	mov.b	@(r0,r14),r6
	extu.b	r6,r6
	or	r6,r12
.endm

.macro	NEG16	s
	neg	\s,r5
	shlr8	r12
	cmp/pz	r5
	bt/s	9036f
	shll8	r12
	add	#C_FLAG,r12
9036:
	mov	\s,r2
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r5,r2
	mov	\s,r6
	and	r3,r12
	xor	r5,r6
	swap.b	r12,r12
	swap.b	r2,r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	mov	#A_FLAG,r3
	or	r0,r12
	and	r3,r6
	extu.b	r5,r0
	or	r6,r12
	mov.b	@(r0,r14),r0
	and	#P_FLAG,r0
	mov	r5,r2
	or	r12,r0
	shll16	r2
	tst	r2,r2
	bf/s	9037f
	cmp/pz	r2
	or	#Z_FLAG,r0
9037:
	bt	9038f
	or	#S_FLAG,r0
9038:
	mov	r0,r12
.endm

.macro	MUL8	d, s
	mul.l	\d,\s
	sts	macl,r5
	mov	r5,r0
	shlr8	r0
	tst	r0,r0
	bf/s	9039f
	swap.b	r12,r0
	mov	#~(O_FLAG >> 8),r2
	mov	#~(C_FLAG),r12
	and	r2,r0
	mov	#(9040f - 9039f),r3
	swap.b	r0,r0
	braf	r3
	and	r0,r12
9039:
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	mov	r0,r12
9040:	
.endm

.macro	MUL16	d, s
	mul.l	\d,\s
	sts	macl,r5
	mov	r5,r0
	shlr16	r0
	tst	r0,r0
	bf/s	9041f
	mov	#~(O_FLAG >> 8),r2
	swap.b	r12,r12
	mov	#~(C_FLAG),r3
	and	r2,r12
	mov	#(9042f - 9041f),r0
	swap.b	r12,r12
	braf	r0
	and	r3,r12
9041:
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	mov	r0,r12
9042:	
.endm

.macro	IMUL8	d, s
	mov	#24,r3
	mov	\d,r5
	shld	r3,r5
	mov	\s,r2
	shld	r3,r2
	mov	#-24,r3
	shad	r3,r5
	shad	r3,r2
	mul.l	r2,r5
	mov	#0x80,r0
	extu.b	r0,r0
	sts	macl,r5
	add	r5,r0
	shlr8	r0
	tst	r0,r0
	bf/s	9043f
	mov	#~(O_FLAG >> 8),r2
	swap.b	r12,r12
	mov	#~(C_FLAG),r3
	and	r2,r12
	mov	#(9044f - 9043f),r0
	swap.b	r12,r12
	braf	r0
	and	r3,r12
9043:
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	mov	r0,r12
9044:	
.endm

.macro	IMUL16	d, s
	mov	\d,r5
	shll16	r5
	mov	\s,r2
	shll16	r2
	mov	#-16,r3
	shad	r3,r5
	shad	r3,r2
	mul.l	r2,r5
	mov	#(8 + 4),r3
	mov	#0x08,r0
	shld	r3,r0
	sts	macl,r5
	add	r5,r0
	shlr16	r0
	tst	r0,r0
	bf/s	9045f
	mov	#~(O_FLAG >> 8),r2
	swap.b	r12,r12
	mov	#~(C_FLAG),r3
	and	r2,r12
	mov	#(9046f - 9045f),r0
	swap.b	r12,r12
	braf	r0
	and	r3,r12
9045:
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	mov	r0,r12
9046:	
.endm

.macro	REGPUSH	r, clk
	CPUWORK	\clk
	mov.w	@(\r,gbr),r0
	extu.w	r0,r5
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r0
	add	#-2,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	10003f,r3
	extu.w	r0,r4
	lds	r13,pr
	mov.l	@(CPU_SS_BASE,gbr),r0
	jmp	@r3
	add	r0,r4

	.align	2
10003:	.long	i286h_memorywrite_w
.endm

.macro POP	clk
	CPUWORK	\clk
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r0
	add	r0,r4
	add	#2,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
.endm

.macro _POP
	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro REGPOP	r, clk
	POP	\clk
	jmp	@r13
	mov.w	r0,@(\r,gbr)

	_POP
.endm
