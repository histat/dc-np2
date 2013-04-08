
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286hsft.inc"

	.extern	i286h_ea
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w
	.extern _i286hcore

	.globl	i286hsft8_1
	.globl	i286hsft16_1
	.globl	i286hsft8_cl
	.globl	i286hsft8_d8
	.globl	i286hsft16_cl
	.globl	i286hsft16_d8

	.text
	.align	2

i286hsft8_1:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft8m
	mov	r0,r4
	CPUWORK	2
	R8SRC	r4, r9
	mov.b	@r9,r8
	shlr	r10
	mova	sft_reg8,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8m:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	sft8e
	mov	r0,r4
	mov	r4,r9
	add	r1,r9
	shlr	r10
	mova	sft_reg8,r0
	mov.b	@r9,r8
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8e:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	mova	sft_ext8,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
sft_reg8:	.long		rol_r8_1
				.long		ror_r8_1
				.long		rcl_r8_1
				.long		rcr_r8_1
				.long		shl_r8_1
				.long		shr_r8_1
				.long		shl_r8_1
				.long		sar_r8_1

sft_ext8:	.long		rol_e8_1
				.long		ror_e8_1
				.long		rcl_e8_1
				.long		rcr_e8_1
				.long		shl_e8_1
				.long		shr_e8_1
				.long		shl_e8_1
				.long		sar_e8_1

	_GETPCF8	
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread

rol_r8_1:	ROL8	r8
	jmp	@r13
	mov.b	r5,@r9
ror_r8_1:	ROR8	r8
	jmp	@r13
	mov.b	r5,@r9
rcl_r8_1:	RCL8	r8
	jmp	@r13
	mov.b	r5,@r9
rcr_r8_1:	RCR8	r8
	jmp	@r13
	mov.b	r5,@r9
shl_r8_1:	SHL8	r8
	jmp	@r13
	mov.b	r5,@r9
shr_r8_1:	SHR8	r8
	jmp	@r13
	mov.b	r5,@r9
sar_r8_1:	SAR8	r8
	jmp	@r13
	mov.b	r5,@r9
rol_e8_1:	ROL8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
ror_e8_1:	ROR8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
rcl_e8_1:	RCL8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
rcr_e8_1:	RCR8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite	
shl_e8_1:	SHL8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
shr_e8_1:	SHR8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
sar_e8_1:	SAR8	r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite


! ----

i286hsft16_1:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft16m
	mov	r0,r4
	CPUWORK	2
	R16SRC	r4, r9
	mova	sft_reg16,r0
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8
sft16m:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, sft16e
	mova	sft_reg16,r0
	mov	r4,r9
	add	r1,r9
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8
sft16e:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	mova	sft_ext16,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
sft_reg16:	.long		rol_r16_1
				.long		ror_r16_1
				.long		rcl_r16_1
				.long		rcr_r16_1
				.long		shl_r16_1
				.long		shr_r16_1
				.long		shl_r16_1
				.long		sar_r16_1

sft_ext16:	.long		rol_e16_1
				.long		ror_e16_1
				.long		rcl_e16_1
				.long		rcr_e16_1
				.long		shl_e16_1
				.long		shr_e16_1
				.long		shl_e16_1
				.long		sar_e16_1

	_GETPCF8
200:	.long	i286h_ea
	_ACCWORD
10001:	.long	i286h_memoryread_w
	

rol_r16_1:	ROL16	r8
	jmp	@r13
	mov.w	r5,@r9
ror_r16_1:	ROR16	r8
	jmp	@r13
	mov.w	r5,@r9
rcl_r16_1:	RCL16	r8
	jmp	@r13
	mov.w	r5,@r9
rcr_r16_1:	RCR16	r8
	jmp	@r13
	mov.w	r5,@r9
shl_r16_1:	SHL16	r8
	jmp	@r13
	mov.w	r5,@r9
shr_r16_1:	SHR16	r8
	jmp	@r13
	mov.w	r5,@r9
sar_r16_1:	SAR16	r8
	jmp	@r13
	mov.w	r5,@r9
rol_e16_1:	ROL16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
ror_e16_1:	ROR16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
rcl_e16_1:	RCL16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
rcr_e16_1:	RCR16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
shl_e16_1:	SHL16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
shr_e16_1:	SHR16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
sar_e16_1:	SAR16	r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w

! ----

i286hsft8_cl:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft8clm
	mov	r0,r4
	CPUWORK	2
	R8SRC	r4, r9
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:	
	mov.b	@r9,r8
	shlr	r10
	mova	sft_reg8cl,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8clm:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	sft8cle
	mov	r0,r4
	mov	r4,r9
	add	r1,r9
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	mov.b	@r9,r8
	shlr	r10
	mova	sft_reg8cl,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8cle:
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r8
	jmp	@r13
	nop
1:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	shlr	r10
	mova	sft_ext8cl,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop
	
	_GETPCF8
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread
	
i286hsft8_d8:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft8d8m
	mov	r0,r4
	CPUWORK	2
	R8SRC	r4, r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:	
	mov.b	@r9,r8
	shlr	r10
	mova	sft_reg8cl,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8d8m:	CPUWORK	7
	mov.l	200f,r3
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	sft8d8e
	mov	r0,r4
	mov	r4,r9
	add	r1,r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	mov.b	@r9,r8
	shlr	r10
	mova	sft_reg8cl,r0
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r8,r8
sft8d8e:
	mov	r4,r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r8
	jmp	@r13
	nop
1:
	mov.l	10000f,r3
	jsr	@r3
	mov	r9,r4
	mov	r0,r4
	mova	sft_ext8cl,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
sft_reg8cl:	.long		rol_r8_cl
				.long		ror_r8_cl
				.long		rcl_r8_cl
				.long		rcr_r8_cl
				.long		shl_r8_cl
				.long		shr_r8_cl
				.long		shl_r8_cl
				.long		sar_r8_cl

sft_ext8cl:	.long		rol_e8_cl
				.long		ror_e8_cl
				.long		rcl_e8_cl
				.long		rcr_e8_cl
				.long		shl_e8_cl
				.long		shr_e8_cl
				.long		shl_e8_cl
				.long		sar_e8_cl

	_GETPCF8
	_GETPC8
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
10000:	.long	i286h_memoryread

rol_r8_cl:	ROL8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
ror_r8_cl:	ROR8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
rcl_r8_cl:	RCL8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
rcr_r8_cl:	RCR8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
shl_r8_cl:	SHL8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
shr_r8_cl:	SHR8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
sar_r8_cl:	SAR8CL	r8, r4
	jmp	@r13
	mov.b	r5,@r9
rol_e8_cl:	ROL8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
ror_e8_cl:	ROR8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
rcl_e8_cl:	RCL8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
rcr_e8_cl:	RCR8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
shl_e8_cl:	SHL8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
shr_e8_cl:	SHR8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
sar_e8_cl:	SAR8CL	r4, r8
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite

! ----

i286hsft16_cl:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft16clm
	mov	r0,r4
	CPUWORK	5
	R16SRC	r4, r9
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	sub	r4,r11
	mova	sft_reg16cl,r0
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8
sft16clm:
	mov.l	200f,r3
	CPUWORK	8
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, sft16cle
	mov	r4,r9
	add	r1,r9
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	sub	r4,r11
	mova	sft_reg16cl,r0
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8
sft16cle:
	mov.b	@(CPU_CL,gbr),r0
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r8
	jmp	@r13
	nop
1:
	mov.l	10001f,r3
	sub	r8,r11
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	mova	sft_ext16cl,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	_GETPCF8
200:	.long	i286h_ea
	_ACCWORD
10001:	.long	i286h_memoryread_w
	
i286hsft16_d8:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	sft16d8m
	mov	r0,r4
	CPUWORK	5
	R16SRC	r4, r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	sub	r4,r11
	mova	sft_reg16cl,r0
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8
sft16d8m:
	mov.l	200f,r3
	CPUWORK	8
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, sft16d8e
	mov	r4,r9
	add	r1,r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	sub	r4,r11
	mova	sft_reg16cl,r0
	mov.w	@r9,r8
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r8,r8

sft16d8e:
	mov	r4,r9
	GETPC8
	and	#0x1f,r0
	tst	r0,r0
	bf/s	1f
	mov	r0,r8
	jmp	@r13
	nop
1:
	mov.l	10001f,r3
	sub	r8,r11
	jsr	@r3
	mov	r9,r4
	mov	r0,r4
	mova	sft_ext16cl,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
sft_reg16cl:	.long		rol_r16_cl
				.long		ror_r16_cl
				.long		rcl_r16_cl
				.long		rcr_r16_cl
				.long		shl_r16_cl
				.long		shr_r16_cl
				.long		shl_r16_cl
				.long		sar_r16_cl

sft_ext16cl:	.long		rol_e16_cl
				.long		ror_e16_cl
				.long		rcl_e16_cl
				.long		rcr_e16_cl
				.long		shl_e16_cl
				.long		shr_e16_cl
				.long		shl_e16_cl
				.long		sar_e16_cl

	_GETPCF8
	_GETPC8
200:	.long	i286h_ea
	_ACCWORD	
10001:	.long	i286h_memoryread_w
	
rol_r16_cl:	ROL16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
ror_r16_cl:	ROR16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
rcl_r16_cl:	RCL16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
rcr_r16_cl:	RCR16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
shl_r16_cl:	SHL16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
shr_r16_cl:	SHR16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
sar_r16_cl:	SAR16CL	r8, r4
	jmp	@r13
	mov.w	r5,@r9
rol_e16_cl:	ROL16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
ror_e16_cl:	ROR16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
rcl_e16_cl:	RCL16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
rcr_e16_cl:	RCR16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
shl_e16_cl:	SHL16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
shr_e16_cl:	SHR16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
sar_e16_cl:	SAR16CL	r4, r8
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w

	.end
