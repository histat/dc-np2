	
.macro ROL8	s
	mov	\s,r2
	mov	#-7,r3
	mov	\s,r5
	shld	r3,r2
	shll	r5
	mov	#~(C_FLAG),r3
	add	r2,r5
	and	r3,r12
	mov	\s,r0
	xor	r5,r0
	or	r2,r12
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro ROR8	s
	mov	#1,r2
	mov	\s,r5
	and	\s,r2
	shlr	r5
	mov	r2,r0
	mov	#7,r3
	shld	r3,r0
	mov	#~(C_FLAG),r3
	add	r0,r5
	mov	\s,r0
	and	r3,r12
	xor	r5,r0
	or	r2,r12
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm
	

.macro RCL8	s
	mov	#1,r2
	mov	\s,r5
	and	r12,r2
	shll	r5
	mov	#~(C_FLAG),r3
	add	r2,r5
	mov	\s,r0
	and	r3,r12
	mov	#-7,r3
	shld	r3,r0
	or	r0,r12
	mov	\s,r0
	xor	r5,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm

	
.macro RCR8	s
	mov	#1,r2
	mov	\s,r5
	and	r12,r2
	mov	#7,r3
	shlr	r5
	shld	r3,r2
	mov	#~(C_FLAG),r3
	add	r2,r5
	mov	#1,r6
	and	r3,r12
	and	\s,r6
	or	r6,r12
	mov	\s,r0
	xor	r5,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm
	

.macro SHL8	s
	mov	\s,r5
	mov	\s,r0
	shll	r5
	mov	#~(O_FLAG >> 8),r3
	xor	r5,r0
	swap.b	r12,r12
	and	#0x80,r0
	and	r3,r12
	mov	#4,r2
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
	mov	r5,r0
	mov.b	@(r0,r14),r2
	mov	#0xff,r3
	shll8	r3
	extu.b	r2,r0
	or	#A_FLAG,r0
	and	r3,r12
	or	r0,r12
.endm

.macro SHR8	s
	mov	\s,r5
	mov	#1,r6
	mov	\s,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	shlr	r5
	and	\s,r6
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
	mov	r5,r0
	mov.b	@(r0,r14),r2
	mov	#0xff,r3
	shll8	r3
	extu.b	r2,r0
	and	r3,r12
	or	r6,r0
	or	#A_FLAG,r0
	or	r0,r12
.endm
	
.macro SAR8	s
	mov	\s,r0
	mov	\s,r5
	and	#0x80,r0
	shlr	r5
	mov	#1,r6
	add	r0,r5
	and	\s,r6
	mov	r5,r0
	mov.b	@(r0,r14),r2
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	extu.b	r2,r0
	and	r3,r12
	mov	#0xff,r3
	swap.b	r12,r12
	shll8	r3
	and	r3,r12
	or	r6,r0
	or	#A_FLAG,r0
	or	r0,r12
.endm

.macro ROL16	s
	mov	\s,r2
	mov	#-15,r3
	mov	\s,r5
	shld	r3,r2
	shll	r5
	mov	#~(C_FLAG),r3
	add	r2,r5
	mov	\s,r0
	and	r3,r12
	xor	r5,r0
	or	r2,r12
	swap.b	r0,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm
	
.macro ROR16	s
	mov	#1,r2
	mov	\s,r5
	and	\s,r2
	mov	r2,r0
	shlr	r5
	mov	#15,r3
	shld	r3,r0
	mov	#~(C_FLAG),r3
	add	r0,r5
	and	r3,r12
	mov	\s,r0
	xor	r5,r0
	or	r2,r12
	swap.b	r0,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro RCL16	s
	mov	#1,r2
	mov	\s,r5
	and	r12,r2
	mov	#~(C_FLAG),r3
	shll	r5
	add	r2,r5
	and	r3,r12
	mov	\s,r0
	mov	#-15,r3
	shld	r3,r0
	or	r0,r12
	mov	\s,r0
	xor	r5,r0
	swap.b	r0,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro RCR16	s
	mov	#1,r2
	mov	\s,r5
	and	r12,r2
	mov	#15,r3
	shlr	r5
	mov	r2,r0
	shld	r3,r0
	add	r0,r5
	mov	#~(C_FLAG),r3
	mov	#1,r6
	and	r3,r12
	and	\s,r6
	or	r6,r12
	mov	\s,r0
	xor	r5,r0
	swap.b	r0,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r6
	and	r3,r12
	shld	r6,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro	SHL16	s
	mov	\s,r5
	mov	\s,r0
	shll	r5
	xor	r5,r0
	swap.b	r0,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
	extu.b	r5,r0
	shlr8	r12
	mov.b	@(r0,r14),r0
	shll8	r12
	and	#P_FLAG,r0
	mov	r5,r3
	shlr16	r3
	or	r3,r12
	or	#A_FLAG,r0
	or	r12,r0
	mov	r5,r6
	shll16	r6
	tst	r6,r6
	bf/s	7000f
	cmp/pz	r6
	or	#Z_FLAG,r0
7000:	
	bt	7001f
	or	#S_FLAG,r0
7001:
	mov	r0,r12
.endm

.macro	SHR16	s
	mov	\s,r5
	swap.b	\s,r0
	shlr	r5
	and	#0x80,r0
	mov	#1,r6
	mov	#~(O_FLAG >> 8),r3
	and	\s,r6
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
	extu.b	r5,r0
	shlr8	r12
	mov.b	@(r0,r14),r0
	shll8	r12
	and	#P_FLAG,r0
	or	r6,r0
	or	#A_FLAG,r0
	or	r12,r0
	mov	r5,r6
	shll16	r6
	tst	r6,r6
	bf/s	7002f
	cmp/pz	r6
	or	#Z_FLAG,r0
7002:
	bt	7003f
	or	#S_FLAG,r0
7003:
	mov	r0,r12
.endm

.macro	SAR16	s
	swap.b	\s,r0
	mov	\s,r5
	and	#0x80,r0
	shlr	r5
	swap.b	r0,r2
	mov	#1,r6
	add	r2,r5
	and	\s,r6
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	extu.b	r5,r0
	and	r3,r12
	mov.b	@(r0,r14),r0
	swap.b	r12,r12
	shlr8	r12
	and	#P_FLAG,r0
	shll8	r12
	or	r6,r0
	or	#A_FLAG,r0
	or	r12,r0
	mov	r5,r6
	shll16	r6
	tst	r6,r6
	bf/s	7004f
	cmp/pz	r6
	or	#Z_FLAG,r0
7004:	
	bt	7005f
	or	#S_FLAG,r0
7005:
	mov	r0,r12
.endm

.macro	ROL8CL	s, cl
	mov	#7,r3
	neg	\cl,r5
	mov	\s,r7
	and	r3,r5
	shll8	r7
	or	\s,r7
	neg	r5,r3
	shld	r3,r7
	extu.b	r7,r5
	mov	#1,r2
	mov	#~(C_FLAG),r3
	and	r5,r2
	and	r3,r12
	or	r2,r12
	mov	#-7,r3
	mov	r5,r0
	shld	r3,r0
	xor	r0,r2
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov	#11,r0
	and	r3,r12
	shld	r0,r2
	swap.b	r12,r12
	or	r2,r12
.endm

.macro	ROR8CL	s, cl
	mov	#7,r5
	mov	\s,r7
	and	\cl,r5
	shll8	r7
	or	\s,r7
	neg	r5,r3
	shld	r3,r7
	mov	#~(C_FLAG),r3
	extu.b	r7,r5
	and	r3,r12
	mov	r5,r0
	mov	#-7,r3
	shld	r3,r0
	or	r0,r12
	mov	r5,r0
	shll	r0
	xor	r5,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro	RCL8CL	s, cl
	mov	\cl,r5
7006:
	add	#-9,r5
	cmp/pz	r5
	bt	7006b
	mov	#1,r2
	neg	r5,r5
	and	r12,r2
	shll8	r2
	or	\s,r2
	mov	#9,r3
	mov	r2,r0
	shld	r3,r0
	or	r0,r2
	mov	r2,r7
	neg	r5,r3
	mov	#1,r2
	shld	r3,r7
	shll8	r2
	extu.b	r7,r5
	and	r7,r2
	mov	#~(C_FLAG),r3
	shlr8	r2
	and	r3,r12
	or	r2,r12
	mov	r7,r0
	shlr	r0
	xor	r7,r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro	RCR8CL	s, cl
	mov	\cl,r5
7007:
	add	#-9,r5
	cmp/pz	r5
	bt	7007b
	mov	#1,r2
	add	#9,r5
	and	r12,r2
	shll8	r2
	mov	#9,r3
	or	\s,r2
	mov	r2,r0
	shld	r3,r0
	or	r0,r2
	neg	r5,r3
	mov	r2,r7
	shld	r3,r7
	mov	#1,r2
	extu.b	r7,r5
	shll8	r2
	mov	#~(C_FLAG),r3
	and	r7,r2
	and	r3,r12
	shlr8	r2
	mov	r7,r0
	or	r2,r12
	shll	r0
	mov	#~(O_FLAG >> 8),r3
	xor	r7,r0
	swap.b	r12,r12
	and	#0x80,r0
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
.endm

.macro	SHL8CL	s, cl
	mov	\s,r5
	mov	#~(O_FLAG >>8),r3
	swap.b	r12,r12
	shld	\cl,r5
	and	r3,r12
	mov	r5,r0
	swap.b	r12,r12
	shlr	r0
	mov	#4,r3
	xor	r5,r0
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
	mov	#(32 - 9),r2
	mov	r5,r0
	mov	#-(32 - 9),r3
	shld	r2,r0
	mov	#0xff,r6
	shld	r3,r0
	shll8	r6
	mov.b	@(r0,r14),r0
	and	r6,r12
	extu.b	r0,r0
	or	#A_FLAG,r0
	or	r0,r12
.endm

.macro	SHR8CL	s, cl
	mov	\cl,r2
	shlr8	r12
	add	#-1,r2
	shll8	r12
	neg	r2,r3
	mov	\s,r5
	shld	r3,r5
	mov	#1,r2
	and	r5,r2
	neg	\cl,r3
	mov	\s,r5
	shld	r3,r5
	or	r2,r12
	mov	#0x40,r2
	and	r5,r2
	mov	#5,r3
	shld	r3,r2
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov	r5,r0
	and	r3,r12
	swap.b	r12,r12
	or	r2,r12
	mov.b	@(r0,r14),r0
	extu.b	r0,r0
	or	#A_FLAG,r0
	or	r0,r12
.endm

.macro SAR8CL	s, cl
	mov	\s,r5
	mov	#24,r3
	mov	#-24,r0
	shld	r3,r5
	mov	\cl,r2
	shad	r0,r5
	add	#-1,r2
	shlr8	r12
	extu.b	r2,r3
	shll8	r12
	neg	r3,r3
	mov	#1,r2
	shad	r3,r5
	and	r5,r2
	shar	r5
	mov	#~(O_FLAG >> 8),r3
	or	r2,r12
	swap.b	r12,r12
	extu.b	r5,r5
	and	r3,r12
	mov	r5,r0
	swap.b	r12,r12
	mov.b	@(r0,r14),r0
	extu.b	r0,r0
	or	#A_FLAG,r0
	or	r0,r12
.endm

.macro ROL16CL	s, cl
	mov	\cl,r0
	cmp/eq	#1,r0
	bf/s	7008f
	mov	#15,r5
	mov	\s,r0
	shll	r0
	xor	\s,r0
	mov	#4,r2
	mov	#~(O_FLAG >> 8),r3
	shlr8	r0
	swap.b	r12,r12
	and	#0x80,r0
	shld	r2,r0
	and	r3,r12
	swap.b	r12,r12
	or	r0,r12
7008:
	mov	\s,r2
	and	\cl,r5
	shll16	r2
	or	\s,r2
	shld	r5,r2
	mov	r2,r5
	shlr16	r5
	mov	#1,r2
	mov	#~(C_FLAG),r3
	and	r5,r2
	and	r3,r12
	or	r2,r12
.endm
	
.macro ROR16CL	s, cl
	mov	\cl,r0
	cmp/eq	#1,r0
	bf/s	7009f
	mov	#15,r5
	mov	\s,r0
	shld	r3,r0
	xor	\s,r0
	shlr8	r0
	mov	#~(O_FLAG >> 8),r3
	and	#0x80,r0
	swap.b	r12,r12
	mov	#4,r2
	and	r3,r12
	shld	r2,r0
	swap.b	r12,r12
	or	r0,r12
7009:
	neg	\cl,r7
	mov	\s,r2
	and	r7,r5
	shll16	r2
	or	\s,r2
	shld	r5,r2
	mov	r2,r5
	shlr16	r5
	mov	#~(C_FLAG),r3
	mov	#-15,r7
	and	r3,r12
	mov	r5,r0
	shld	r7,r0
	or	r0,r12
.endm

.macro	RCL16CL	s, cl
	mov	\cl,r0
	cmp/eq	#1,r0
	bf/s	7010f
	mov	\cl,r5
	mov	\s,r0
	shll	r0
	xor	\s,r0
	shlr8	r0
	and	#0x80,r0
	mov	#~(O_FLAG >> 8),r3
	mov	#4,r2
	swap.b	r12,r12
	shld	r2,r0
	and	r3,r12
	swap.b	r12,r12
	or	r0,r12
7010:
	mov	#17,r3
	cmp/hs	r3,r5
	bf/s	7011f
	mov	#1,r2
	add	#-17,r5
7011:
	and	r12,r2
	mov	r2,r7
	shll16	r7
	or	\s,r7
	mov	r7,r2
	shld	r5,r2
	mov	r5,r0
	mov	#17,r5
	sub	r0,r5
	neg	r5,r3
	shld	r3,r7
	mov	r2,r5
	mov	#1,r2
	shll16	r2
	or	r7,r5
	and	r5,r2
	mov	#~(C_FLAG),r3
	shlr16	r2
	and	r3,r12
	or	r2,r12
.endm

.macro RCR16CL	s, cl
	mov	\cl,r0
	cmp/eq	#1,r0
	bf/s	7012f
	mov	\cl,r5
	mov	#-15,r3
	mov	\s,r0
	shld	r3,r0
	xor	r12,r0
	mov	#~(O_FLAG >> 8),r3
	and	#1,r0
	swap.b	r12,r12
	mov	#11,r7
	and	r3,r12
	shld	r7,r0
	swap.b	r12,r12
	or	r0,r12
7012:
	mov	#17,r3
	cmp/hs	r3,r5
	bf/s	7013f
	mov	#1,r2
	add	#-17,r5
7013:	
	and	r12,r2
	shll16	r2
	or	\s,r2
	neg	r5,r3
	mov	r2,r7
	shld	r3,r7
	mov	r5,r0
	mov	#17,r5
	sub	r0,r5
	shld	r5,r2
	mov	r7,r5
	or	r2,r5
	mov	#1,r2
	shll16	r2
	mov	#~(C_FLAG),r3
	and	r5,r2
	and	r3,r12
	shlr16	r2
	or	r2,r12
.endm

.macro SHL16CL	s, cl
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov	\cl,r0
	and	r3,r12
	swap.b	r12,r12
	cmp/eq	#1,r0
	bf/s	7014f
	mov	\s,r5
	mov	\s,r0
	shll	r0
	xor	\s,r0
	shlr8	r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
7014:	
	shld	\cl,r5
	extu.b	r5,r0
	shlr8	r12
	mov.b	@(r0,r14),r0
	shll8	r12
	and	#P_FLAG,r0
	or	r12,r0
	mov	r5,r6
	shll16	r6
	tst	r6,r6
	bf/s	7015f
	cmp/pz	r6
	or	#Z_FLAG,r0
7015:	
	bt	7016f
	or	#S_FLAG,r0
7016:
	mov	r0,r12
	mov	r5,r0
	shlr16	r0
	and	#1,r0
	or	r0,r12
.endm

.macro SHR16CL	s, cl
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov	\cl,r0
	and	r3,r12
	swap.b	r12,r12
	cmp/eq	#1,r0
	bf/s	7017f
	mov	\cl,r2
	mov	\s,r0
	shlr8	r0
	mov	#4,r3
	and	#0x80,r0
	shld	r3,r0
	or	r0,r12
7017:
	shlr8	r12
	add	#-1,r2
	mov	\s,r5
	shll8	r12
	neg	r2,r3
	mov	#1,r2
	shld	r3,r5
	and	r5,r2
	shlr	r5
	extu.b	r5,r0
	or	r2,r12
	mov.b	@(r0,r14),r0
	and	#P_FLAG,r0
	mov	r5,r6
	or	r12,r0
	shll16	r6
	tst	r6,r6
	bf/s	7018f
	cmp/pz	r6
	or	#Z_FLAG,r0
7018:	
	bt	7019f
	or	#S_FLAG,r0
7019:
	mov	r0,r12
.endm

.macro	SAR16CL	s, cl
	mov	\s,r5
	mov	#-16,r3
	shll16	r5
	shad	r3,r5
	mov	\cl,r2
	shlr8	r12
	add	#-1,r2
	shll8	r12
	neg	r2,r3
	mov	#1,r2
	shad	r3,r5
	and	r5,r2
	shar	r5
	or	r2,r12
	extu.b	r5,r0
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	mov.b	@(r0,r14),r0
	and	r3,r12
	swap.b	r12,r12
	and	#P_FLAG,r0
	or	r12,r0
	mov	r5,r6
	shll16	r6
	tst	r6,r6
	bf/s	7020f
	cmp/pz	r6
	or	#Z_FLAG,r0
7020:	
	bt	7021f
	or	#S_FLAG,r0
7021:
	mov	r0,r12
.endm
