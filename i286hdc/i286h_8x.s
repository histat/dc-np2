
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286halu.inc"

	.extern	i286h_ea
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w

	.extern _i286hcore

	.globl	i286hop80
	.globl	i286hop81
	.globl	i286hop83

	.text
	.align	2

	
i286hop80:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	cmp/hs	r3,r0
	and	r0,r10
	bf/s	ope80m
	mov	r0,r4
	CPUWORK	3
	R8SRC	r4, r8
	GETPC8
	mov	r0,r4
	mova	op8x_reg8,r0
	mov.b	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r9,r9
ope80m:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	ope80e
	mov	r0,r4
	mov	r1,r8
	add	r4,r8
	GETPC8
	mov	r0,r4
	mova	op8x_reg8,r0
	mov.b	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.b	r9,r9
ope80e:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r8
	GETPC8
	mov	r0,r4
	mova	op8x_ext8,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
op8x_reg8:	.long		add_r8_i
				.long		or_r8_i
				.long		adc_r8_i
				.long		sbb_r8_i
				.long		and_r8_i
				.long		sub_r8_i
				.long		xor_r8_i
				.long		cmp_r8_i

op8x_ext8:	.long		add_r8_e
				.long		or_r8_e
				.long		adc_r8_e
				.long		sbb_r8_e
				.long		and_r8_e
				.long		sub_r8_e
				.long		xor_r8_e
				.long		cmp_r8_e

	_GETPCF8
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
	_GETPC8
10000:	.long	i286h_memoryread

add_r8_i:	ADD8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
or_r8_i:	OR8		r9, r4
	jmp	@r13
	mov.b	r5,@r8
adc_r8_i:	ADC8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
sbb_r8_i:	SBB8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
and_r8_i:	AND8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
sub_r8_i:	SUB8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
xor_r8_i:	XOR8	r9, r4
	jmp	@r13
	mov.b	r5,@r8
cmp_r8_i:	SUB8	r9, r4
	jmp	@r13
	nop
add_r8_e:	ADD8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
or_r8_e:	OR8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
adc_r8_e:	ADC8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
sbb_r8_e:	SBB8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
and_r8_e:	AND8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
sub_r8_e:	SUB8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
xor_r8_e:	XOR8	r8, r4
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10002:	.long	i286h_memorywrite
cmp_r8_e:	SUB8	r8, r4
	jmp	@r13
	nop

! ----

i286hop81:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	ope81m
	mov	r0,r4
	CPUWORK	3
	R16SRC	r4, r8
	GETPC16
	mov	r0,r4
	mova	op8x_reg16,r0
	mov.w	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r9,r9
ope81m:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, ope81e
	mov	r1,r8
	add	r4,r8
	GETPC16
	mov	r0,r4
	mova	op8x_reg16,r0
	mov.w	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r9,r9
ope81e:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r4
	mov	r0,r8
	GETPC16
	mov	r0,r4
	mova	op8x_ext16,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	_GETPCF8
200:	.long	i286h_ea
	_ACCWORD
	_GETPC16
10001:	.long	i286h_memoryread_w


i286hop83:	GETPCF8
	mov	#0xc0,r3
	mov	#(7 << 3),r10
	extu.b	r3,r3
	and	r0,r10
	cmp/hs	r3,r0
	bf/s	ope83m
	mov	r0,r4
	CPUWORK	3
	R16SRC	r4, r8
	GETPC8
	tst	#(1 << 7),r0
	bt/s	1f
	mov	r0,r4
	swap.b	r4,r0
	or	#0xff,r0
	swap.b	r0,r4
1:	
	mova	op8x_reg16,r0
	mov.w	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r9,r9
ope83m:
	mov.l	200f,r3
	CPUWORK	7
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, ope83e
	mov	r1,r8
	add	r4,r8
	GETPC8
	tst	#(1 << 7),r0
	bt/s	1f
	mov	r0,r4
	swap.b	r4,r0
	or	#0xff,r0
	swap.b	r0,r4
1:
	mova	op8x_reg16,r0
	mov.w	@r8,r9
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	extu.w	r9,r9
ope83e:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov	r0,r8
	GETPC8
	tst	#(1 << 7),r0
	bt/s	1f
	mov	r0,r4
	swap.b	r4,r0
	or	#0xff,r0
	swap.b	r0,r4
1:
	mova	op8x_ext16,r0
	shlr	r10
	mov.l	@(r0,r10),r3
	jmp	@r3
	nop

	.align	2
op8x_reg16:	.long		add_r16_i
				.long		or_r16_i
				.long		adc_r16_i
				.long		sbb_r16_i
				.long		and_r16_i
				.long		sub_r16_i
				.long		xor_r16_i
				.long		cmp_r16_i

op8x_ext16:	.long		add_r16_e
				.long		or_r16_e
				.long		adc_r16_e
				.long		sbb_r16_e
				.long		and_r16_e
				.long		sub_r16_e
				.long		xor_r16_e
				.long		cmp_r16_e

	_GETPCF8
	_GETPC8
200:	.long	i286h_ea
	_ACCWORD
10001:	.long	i286h_memoryread_w

add_r16_i:	ADD16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
or_r16_i:	OR16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
adc_r16_i:	ADC16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
sbb_r16_i:	SBB16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
and_r16_i:	AND16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
sub_r16_i:	SUB16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
xor_r16_i:	XOR16	r9, r4
	jmp	@r13
	mov.w	r5,@r8
cmp_r16_i:	SUB16	r9, r4
	jmp	@r13
	nop
add_r16_e:	ADD16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
or_r16_e:	OR16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
adc_r16_e:	ADC16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
sbb_r16_e:	SBB16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
and_r16_e:	AND16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
sub_r16_e:	SUB16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
xor_r16_e:	XOR16	r8, r4
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r9,r4

	.align	2
10003:	.long	i286h_memorywrite_w
cmp_r16_e:	SUB16	r8, r4
	jmp	@r13
	nop
	
	.end
