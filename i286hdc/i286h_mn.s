
	.include "../i286hdc/i286h.inc"
	.include "../i286hdc/i286hea.inc"
	.include "../i286hdc/i286halu.inc"
	.include "../i286hdc/i286hop.inc"
	.include "../i286hdc/i286hio.inc"

	.extern	_i286hcore
	.extern	_iflags
	.extern	i286h_localint
	.extern	i286h_trapint
	.extern	i286h_selector
	.extern	i286h_ea
	.extern	i286h_lea
	.extern	i286h_a

	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
	.extern	i286h_memorywrite
	.extern	i286h_memorywrite_w

	.extern	_iocore_inp8
	.extern	_iocore_inp16
	.extern	_iocore_out8
	.extern	_iocore_out16

	.extern	_dmax86
	.extern	_biosfunc

	.extern	i286h_cts

	.extern	i286hop80
	.extern	i286hop81
	.extern	i286hop83

	.extern	i286hsft8_1
	.extern	i286hsft16_1
	.extern	i286hsft8_cl
	.extern	i286hsft8_d8
	.extern	i286hsft16_cl
	.extern	i286hsft16_d8

	.extern	i286hopf6
	.extern	i286hopf7

	.extern	i286hopfe
	.extern	i286hopff

	.extern	i286h_rep_insb
	.extern	i286h_rep_insw
	.extern	i286h_rep_outsb
	.extern	i286h_rep_outsw
	.extern	i286h_rep_movsb
	.extern	i286h_rep_movsw
	.extern	i286h_rep_lodsb
	.extern	i286h_rep_lodsw
	.extern	i286h_rep_stosb
	.extern	i286h_rep_stosw
	.extern	i286h_repe_cmpsb
	.extern	i286h_repe_cmpsw
	.extern	i286h_repne_cmpsb
	.extern	i286h_repne_cmpsw
	.extern	i286h_repe_scasb
	.extern	i286h_repe_scasw
	.extern	i286h_repne_scasb
	.extern	i286h_repne_scasw

	.globl	_i286h
	.globl	_i286h_step
	.globl	optbl1

	.text
	.align	2

add_ea_r8:	OP_EA_R8	ADD8, 2, 7
add_ea_r16:	OP_EA_R16	ADD16, 2, 7
add_r8_ea:	OP_R8_EA	ADD8, 2, 7
add_r16_ea:	OP_R16_EA	ADD16, 2, 7
add_al_d8:	OP_AL_D8	ADD8, 3
add_ax_d16:	OP_AX_D16	ADD16, 3
push_es:	REGPUSH		CPU_ES, 3
pop_es:	SEGPOP		CPU_ES, CPU_ES_BASE, 5

or_ea_r8:	OP_EA_R8	OR8, 2, 7
or_ea_r16:	OP_EA_R16	OR16, 2, 7
or_r8_ea:	OP_R8_EA	OR8, 2, 7
or_r16_ea:	OP_R16_EA	OR16, 2, 7
or_al_d8:	OP_AL_D8	OR8, 3
or_ax_d16:	OP_AX_D16	OR16, 3
push_cs:	REGPUSH		CPU_CS, 3
! ope0f

adc_ea_r8:	OP_EA_R8	ADC8, 2, 7
adc_ea_r16:	OP_EA_R16	ADC16, 2, 7
adc_r8_ea:	OP_R8_EA	ADC8, 2, 7
adc_r16_ea:	OP_R16_EA	ADC16, 2, 7
adc_al_d8:	OP_AL_D8	ADC8, 3
adc_ax_d16:	OP_AX_D16	ADC16, 3
push_ss:	REGPUSH		CPU_SS, 3
! pop_ss

sbb_ea_r8:	OP_EA_R8	SBB8, 2, 7
sbb_ea_r16:	OP_EA_R16	SBB16, 2, 7
sbb_r8_ea:	OP_R8_EA	SBB8, 2, 7
sbb_r16_ea:	OP_R16_EA	SBB16, 2, 7
sbb_al_d8:	OP_AL_D8	SBB8, 3
sbb_ax_d16:	OP_AX_D16	SBB16, 3
push_ds:	REGPUSH		CPU_DS, 3
! pop_ds		SEGPOPFIX	CPU_DS, CPU_DS_BASE, CPU_DS_FIX, 5

and_ea_r8:	OP_EA_R8	AND8, 2, 7
and_ea_r16:	OP_EA_R16	AND16, 2, 7
and_r8_ea:	OP_R8_EA	AND8, 2, 7
and_r16_ea:	OP_R16_EA	AND16, 2, 7
and_al_d8:	OP_AL_D8	AND8, 3
and_ax_d16:	OP_AX_D16	AND16, 3
! segprefix_es		!
! daa			*

sub_ea_r8:	OP_EA_R8	SUB8, 2, 7
sub_ea_r16:	OP_EA_R16	SUB16, 2, 7
sub_r8_ea:	OP_R8_EA	SUB8, 2, 7
sub_r16_ea:	OP_R16_EA	SUB16, 2, 7
sub_al_d8:	OP_AL_D8	SUB8, 3
sub_ax_d16:	OP_AX_D16	SUB16, 3
! segprefix_cs		!
! das			*

xor_ea_r8:	OP_EA_R8	XOR8, 2, 7
xor_ea_r16:	OP_EA_R16	XOR16, 2, 7
xor_r8_ea:	OP_R8_EA	XOR8, 2, 7
xor_r16_ea:	OP_R16_EA	XOR16, 2, 7
xor_al_d8:	OP_AL_D8	XOR8, 3
xor_ax_d16:	OP_AX_D16	XOR16, 3
! segprefix_ss		!
! aaa			*

cmp_ea_r8:	S_EA_R8		SUB8, 2, 6
cmp_ea_r16:	S_EA_R16	SUB16, 2, 6
cmp_r8_ea:	S_R8_EA		SUB8, 2, 6
cmp_r16_ea:	S_R16_EA	SUB16, 2, 6
cmp_al_d8:	S_AL_D8		SUB8, 3
cmp_ax_d16:	S_AX_D16	SUB16, 3
! segprefix_ds		!
! aas			*

inc_ax:	OP_INC16	CPU_AX, 2
inc_cx:	OP_INC16	CPU_CX, 2
inc_dx:	OP_INC16	CPU_DX, 2
inc_bx:	OP_INC16	CPU_BX, 2
inc_sp:	OP_INC16	CPU_SP, 2
inc_bp:	OP_INC16	CPU_BP, 2
inc_si:	OP_INC16	CPU_SI, 2
inc_di:	OP_INC16	CPU_DI, 2
dec_ax:	OP_DEC16	CPU_AX, 2
dec_cx:	OP_DEC16	CPU_CX, 2
dec_dx:	OP_DEC16	CPU_DX, 2
dec_bx:	OP_DEC16	CPU_BX, 2
dec_sp:	OP_DEC16	CPU_SP, 2
dec_bp:	OP_DEC16	CPU_BP, 2
dec_si:	OP_DEC16	CPU_SI, 2
dec_di:	OP_DEC16	CPU_DI, 2

push_ax:	REGPUSH		CPU_AX, 3
push_cx:	REGPUSH		CPU_CX, 3
push_dx:	REGPUSH		CPU_DX, 3
push_bx:	REGPUSH		CPU_BX, 3
push_sp:	SP_PUSH		3
push_bp:	REGPUSH		CPU_BP, 3
push_si:	REGPUSH		CPU_SI, 3
push_di:	REGPUSH		CPU_DI, 3
pop_ax:	REGPOP		CPU_AX, 5
pop_cx:	REGPOP		CPU_CX, 5
pop_dx:	REGPOP		CPU_DX, 5
pop_bx:	REGPOP		CPU_BX, 5
pop_sp:	SP_POP		5
pop_bp:	REGPOP		CPU_BP, 5
pop_si:	REGPOP		CPU_SI, 5
pop_di:	REGPOP		CPU_DI, 5
! pusha			*
! popa			*
! bound			+
! arpl			+
! push_d16		*
! imul_r_ea_d16	+
! push_d8		*
! imul_r_ea_d8	+
! insb			*
! insw			*
! outsb			*
! outsw			*

jo_short:	JMPNE16		O_FLAG, 3, 7
jno_short:	JMPEQ16		O_FLAG, 3, 7
jc_short:	JMPNE8		C_FLAG, 3, 7
jnc_short:	JMPEQ8		C_FLAG, 3, 7
jz_short:	JMPNE8		Z_FLAG, 3, 7
jnz_short:	JMPEQ8		Z_FLAG, 3, 7
jna_short:	JMPNE8		(Z_FLAG + C_FLAG), 3, 7
ja_short:	JMPEQ8		(Z_FLAG + C_FLAG), 3, 7
js_short:	JMPNE8		S_FLAG, 3, 7
jns_short:	JMPEQ8		S_FLAG, 3, 7
jp_short:	JMPNE8		P_FLAG, 3, 7
jnp_short:	JMPEQ8		P_FLAG, 3, 7
! jl_short		+
! jnl_short		+
! jle_short		+
! jnle_short	+

! calc_ea8_i8	+
! calc_ea16_i16	+
! calc_ea16_i8	+
test_ea_r8:	S_EA_R8		AND8, 2, 6
test_ea_r16:	S_EA_R16	AND16, 2, 6
! xchg_ea_r8	*
! xchg_ea_r16	*
! mov_ea_r8		*
! mov_ea_r16	*
! mov_r8_ea		*
! mov_r16_ea	*
! mov_ea_seg	+
! lea_r16_ea	+
! mov_seg_ea		!
! pop_ea		*

! nop
xchg_ax_cx:	XCHG_AX		CPU_CX, 3
xchg_ax_dx:	XCHG_AX		CPU_DX, 3
xchg_ax_bx:	XCHG_AX		CPU_BX, 3
xchg_ax_sp:	XCHG_AX		CPU_SP, 3
xchg_ax_bp:	XCHG_AX		CPU_BP, 3
xchg_ax_si:	XCHG_AX		CPU_SI, 3
xchg_ax_di:	XCHG_AX		CPU_DI, 3
! cbw			*
! cwd			*
! call_far		*
! wait			*
! pushf			*
! popf				!
! sahf			*
! lahf			*

! mov_al_m8		*
! mov_ax_m16	*
! mov_m8_al		*
! mov_m16_ax	*
! movsb			*
! movsw			*
! cmpsb			*
! cmpsw			*
test_al_d8:	S_AL_D8		AND8, 3
test_ax_d16:	S_AX_D16	AND16, 3
! stosb			*
! stosw			*
! lodsb			*
! lodsw			*
! scasb			*
! scasw			*

mov_al_imm:	MOVIMM8		CPU_AL, 2
mov_cl_imm:	MOVIMM8		CPU_CL, 2
mov_dl_imm:	MOVIMM8		CPU_DL, 2
mov_bl_imm:	MOVIMM8		CPU_BL, 2
mov_ah_imm:	MOVIMM8		CPU_AH, 2
mov_ch_imm:	MOVIMM8		CPU_CH, 2
mov_dh_imm:	MOVIMM8		CPU_DH, 2
mov_bh_imm:	MOVIMM8		CPU_BH, 2
mov_ax_imm:	MOVIMM16	CPU_AX, 2
mov_cx_imm:	MOVIMM16	CPU_CX, 2
mov_dx_imm:	MOVIMM16	CPU_DX, 2
mov_bx_imm:	MOVIMM16	CPU_BX, 2
mov_sp_imm:	MOVIMM16	CPU_SP, 2
mov_bp_imm:	MOVIMM16	CPU_BP, 2
mov_si_imm:	MOVIMM16	CPU_SI, 2
mov_di_imm:	MOVIMM16	CPU_DI, 2
! shift_ea8_d8
! shift_ea16_d8
! ret_near_d16	+
! ret_near		+
! les_r16_ea	+
! lds_r16_ea	+
! mov_ea8_d8	*
! mov_ea16_d16	*
! enter
! leave			+
! ret_far_d16	+
! ret_far		+
! int_03		+
! int_d8		+
! into			+
! iret				!

! shift_ea8_1
! shift_ea16_1
! shift_ea8_cl
! shift_ea16_cl
! aam			+
! aad			*
! setalc		*
! xlat			*
! esc			*

! loopnz		*
! loopz			*
! loop			*
! jcxz			*
! in_al_d8		*
! in_ax_d8		*
! out_d8_al		*
! out_d8_ax		*
! call_near		*
! jmp_near		*
! jmp_far		*
jmp_short:	JMPS	7
! in_al_dx		*
! in_ax_dx		*
! out_dx_al		*
! out_dx_ax		*

! lock			*
! repne				!
! repe				!
! hlt			+
! cmc			*
! ope0xf6
! ope0xf7
! clc			*
! stc			*
! cli			*
! sti				!
! cld			*
! std			*
! ope0xfe
! ope0xff


! ----

reserved:
	mov.l	201f,r3
	mov	#((1 << 16) >> 16),r0
	mov	#6,r10
	shll16	r0
	jmp	@r3
	sub	r0,r12

	.align	2
201:	.long	i286h_localint

pop_ss:	SEGPOPFIX	CPU_SS, CPU_SS_BASE, CPU_SS_FIX, 5
				NEXT_OPCODE

	_SEGPOPFIX
	
pop_ds:	SEGPOPFIX	CPU_DS, CPU_DS_BASE, CPU_DS_FIX, 5
	jmp	@r13
	nop

	_SEGPOPFIX
	
daa:
	mov.b	@(CPU_AL,gbr),r0
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	extu.b	r0,r4
	and	r3,r12
	CPUWORK	3
	mov	#0x80,r6
	swap.b	r12,r12
	extu.b	r6,r6
	mov	r12,r0
	xor	r4,r6
	tst	#A_FLAG,r0
	bf/s	daalo2
	mov	#0x0f,r5
	mov	#10,r0
	and	r4,r5
	cmp/hs	r0,r5
	bf/s	daahi
	mov	#A_FLAG,r3
	or	r3,r12
daalo2:
	add	#6,r4
	mov	r4,r0
	shlr8	r0
	or	r0,r12
	extu.b	r4,r4
daahi:
	mov	r12,r0
	tst	#C_FLAG,r0
	bf/s	daahi2
	mov	#0xa0,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	daaflg
	mov	#C_FLAG,r0
	or	r0,r12
daahi2:
	add	#0x60,r4
	extu.b	r4,r4
daaflg:
	mov	r4,r0
	mov.b	r0,@(CPU_AL,gbr)
	mov.b	@(r0,r14),r5
	mov	r12,r0
	extu.b	r5,r5
	shlr8	r12
	and	#~(0xff - A_FLAG - C_FLAG),r0
	shll8	r12
	or	r0,r12
	and	r4,r6
	mov	r6,r0
	tst	#0x80,r0
	bt/s	1f
	or	r5,r12
	mov	#(O_FLAG >> 8),r3
	shll8	r3
	add	r3,r12
1:	
	jmp	@r13
	nop
das:
	CPUWORK	3
	mov.b	@(CPU_AL,gbr),r0
	mov	#C_FLAG,r3
	tst	r3,r12
	extu.b	r0,r4
	bf/s	dashi2
	mov	r12,r0
	mov	#0x9a,r3
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf	daslo
	or	#C_FLAG,r0
dashi2:
	add	#-0x60,r4
	extu.b	r4,r4
daslo:
	tst	#A_FLAG,r0
	bf/s	daslo2
	mov	#10,r3
	mov	#0x0f,r5
	and	r4,r5
	cmp/hs	r3,r5
	bf	dasflg
	or	#A_FLAG,r0
daslo2:
	add	#-6,r4
	mov	#-31,r3
	mov	r4,r5
	shld	r3,r5
	or	r5,r0
	extu.b	r4,r4
dasflg:
	mov	r0,r12
	mov	r4,r0
	mov.b	@(r0,r14),r5
	mov	r4,r0
	mov.b	r0,@(CPU_AL,gbr)
	mov	r12,r0
	extu.b	r5,r5
	shlr8	r12
	and	#~(0xff - A_FLAG - C_FLAG),r0
	shll8	r12
	or	r0,r12
	jmp	@r13
	or	r5,r12
	
aaa:
	CPUWORK	3
	mov.w	@(CPU_AX,gbr),r0
	mov	#A_FLAG,r3
	extu.w	r0,r4
	tst	r3,r12
	mov	#~(A_FLAG + C_FLAG),r3
	and	r3,r12
	bf/s	aaa1
	mov	r12,r0
	mov	#0xf,r5
	mov	#10,r3
	and	r4,r5
	cmp/hs	r3,r5
	bf	aaa2
aaa1:
	mov	#(0x100 >> 8),r3
	shll8	r3
	add	#6,r4
	or	#(A_FLAG + C_FLAG),r0
	add	r3,r4
aaa2:
	mov	r0,r12
	mov	r4,r0
	shlr8	r4
	and	#~(0xf0),r0
	shll8	r4
	or	r4,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
	
aas:
	CPUWORK	3
	mov.w	@(CPU_AX,gbr),r0
	mov	#A_FLAG,r3
	extu.w	r0,r4
	tst	r3,r12
	mov	r12,r0
	mov	#~(A_FLAG + C_FLAG),r3
	bf/s	aas1
	and	r3,r0
	mov	#0xf,r5
	mov	#10,r3
	and	r4,r5
	cmp/hs	r3,r5
	bt	aas1
	jmp	@r13
	mov	r0,r12
aas1:
	or	#(A_FLAG + C_FLAG),r0
	mov	r0,r12
	mov	#(0x100 >> 8),r3
	mov	r4,r0
	add	#-6,r0
	shll8	r3
	sub	r3,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
	
pusha:
	CPUWORK	17
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r8,r10
	mov	r0,r9
	mov.w	@(CPU_AX,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	extu.w	r0,r5
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_CX,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_DX,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_BX,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	extu.w	r0,r5
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov	r10,r5
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_BP,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_SI,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov.w	@(CPU_DI,gbr),r0
	add	#-2,r8
	mov.l	10003f,r3
	extu.w	r8,r8
	mov	r8,r4
	extu.w	r0,r5
	jsr	@r3
	add	r9,r4
	mov	r8,r0
	jmp	@r13
	mov.w	r0,@(CPU_SP,gbr)

	.align	2
10003:	.long	i286h_memorywrite_w

	
popa:
	CPUWORK	19
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r0,r9
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_DI,gbr)
	add	#2,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_SI,gbr)
	add	#2,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_BP,gbr)
	add	#4,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_BX,gbr)
	add	#2,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_DX,gbr)
	add	#2,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_CX,gbr)
	add	#2,r8
	mov.l	10001f,r3
	extu.w	r8,r8
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_AX,gbr)
	add	#2,r8
	mov	r8,r0
	jmp	@r13
	mov.w	r0,@(CPU_SP,gbr)	

	.align	2
10001:	.long	i286h_memoryread_w

bound:	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	bndreg
	mov	r0,r4
	R16DST	r4, r2
	mov.l	200f,r3
	CPUWORK	13
	mov.w	@r2,r9
	jsr	@r3
	extu.w	r9,r9
	mov	r0,r8
	mov	r0,r4
	mov.l	10001f,r3
	add	#2,r8
	jsr	@r3
	add	r10,r4
	cmp/hs	r0,r9
	bf/s	bndout
	mov	r0,r4
	mov	#~(1),r3
	swap.w	r8,r8
	mov	r10,r4
	and	r3,r8
	mov.l	10001f,r3
	swap.w	r8,r8
	jsr	@r3
	add	r8,r4
	cmp/hi	r0,r9
	bt/s	bndout
	mov	r0,r4
	jmp	@r13
	nop

	_GETPCF8
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
bndout:
	mov.l	200f,r3
	jmp	@r3
	mov	#5,r10
	
	.align	2
200:	.long	i286h_localint
bndreg:
	mov.l	200f,r3
	mov	#2,r0
	mov	#6,r10
	shll16	r0
	jmp	@r3
	sub	r0,r12
	
	.align	2
200:	.long	i286h_localint

push_d16:
	CPUWORK	3
	GETPC16
	mov	r0,r5
	mov.w	@(CPU_SP,gbr),r0
	mov	#2,r3
	extu.w	r0,r0
	cmp/hs	r3,r0
	bt/s	1f
	add	#-2,r0
	mov	#1,r3
	shll16	r3
	add	r3,r0
1:
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	10003f,r3
	mov	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	lds	r13,pr
	jmp	@r3
	add	r0,r4

	_GETPC16
10003:	.long	i286h_memorywrite_w

imul_r_ea_d16:
	REG16EA	r10, 21, 24
	mov	r0,r8
	shll16	r8
	GETPC16
	mov	r0,r4
	mov	#-16,r3
	shll16	r4
	shad	r3,r8
	shad	r3,r4
	mul.l	r4,r8
	mov	#0x80,r2
	extu.b	r2,r2
	shll8	r2
	sts	macl,r5
	add	r5,r2
	shlr16	r2
	tst	r2,r2
	bf/s	1f
	mov.w	r5,@r10
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	mov	#~(C_FLAG),r0
	swap.b	r12,r12
	jmp	@r13
	and	r0,r12
1:
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	jmp	@r13
	mov	r0,r12

	_REG16EA
	_GETPC16

push_d8:
	CPUWORK	3
	GETPCF8
	mov	r0,r5
	mov.w	@(CPU_SP,gbr),r0
	mov	#24,r3
	shld	r3,r5
	extu.w	r0,r0
	mov	#2,r3
	cmp/hs	r3,r0
	bt/s	1f
	add	#-2,r0
	mov	#1,r3
	shll16	r3
	add	r3,r0
1:
	mov	#-24,r3
	mov.w	r0,@(CPU_SP,gbr)
	mov	r0,r4
	shad	r3,r5
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	add	r0,r4

	_GETPCF8
10003:	.long	i286h_memorywrite_w
	

imul_r_ea_d8:	REG16EA	r10, 21, 24
	mov	r0,r8
	shll16	r8
	GETPC8
	mov	r0,r4
	mov	#24,r3
	mov	#-16,r0
	shld	r3,r4
	mov	#-24,r3
	shad	r0,r8
	shad	r3,r4
	mul.l	r4,r8
	mov	#0x80,r2
	extu.b	r2,r2
	shll8	r2
	sts	macl,r5
	add	r5,r2
	shlr16	r2
	tst	r2,r2
	bf/s	1f
	mov.w	r5,@r10
	mov	#~(O_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	mov	#~(C_FLAG),r0
	swap.b	r12,r12
	jmp	@r13
	and	r0,r12
1:
	swap.b	r12,r0
	or	#(O_FLAG >> 8),r0
	swap.b	r0,r0
	or	#C_FLAG,r0
	jmp	@r13
	mov	r0,r12

	_REG16EA
	_GETPC8

insb:
	CPUWORK	5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	mov	r0,r5
	mov.l	@r15+,r1
	CPULD
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r6
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov	r6,r4
	mov	r0,r7
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	add	r7,r4
	bf/s	1f
	mov	r6,r0
	bra	2f
	add	#1,r0
1:
	add	#-1,r0
2:
	mov.l	10002f,r3
	lds	r13,pr
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
200:	.long	_iocore_inp8
10002:	.long	i286h_memorywrite
	
insw:
	CPUWORK	5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	mov	r0,r5
	mov.l	@r15+,r1
	CPULD
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r6
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov	r6,r4
	mov	r0,r7
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	add	r7,r4
	bf/s	1f
	mov	r6,r0
	bra	2f
	add	#2,r0
1:
	add	#-2,r0
2:
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
200:	.long	_iocore_inp16
10003:	.long	i286h_memorywrite_w
	
outsb:
	CPUWORK	3
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r6
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r5,r0
	bra	2f
	add	#1,r0
1:
	add	#-1,r0
2:
	mov.w	r0,@(CPU_SI,gbr)
	mov.l	10000f,r3
	mov	r5,r4
	jsr	@r3
	add	r6,r4
	mov	r0,r5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.l	@(CPU_DX,gbr),r0
	jsr	@r3
	mov	r0,r4
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	.align	2
10000:	.long	i286h_memoryread
200:	.long	_iocore_out8
	
outsw:
	CPUWORK	3
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r6
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r5,r0
	bra	2f
	add	#2,r0
1:
	add	#-2,r0
2:
	mov.w	r0,@(CPU_SI,gbr)
	mov.l	10001f,r3
	mov	r5,r4
	jsr	@r3
	add	r6,r4
	mov	r0,r5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.l	@(CPU_DX,gbr),r0
	jsr	@r3
	mov	r0,r4
	CPULD
	jmp	@r13
	mov.l	@r15+,r1
	
	.align	2
10001:	.long	i286h_memoryread_w
200:	.long	_iocore_out16

jle_short:
	mov	r12,r0
	tst	#Z_FLAG,r0
	bf	jmps
jl_short:
	mov	r12,r4
	mov	#-4,r3
	shld	r3,r4
	xor	r12,r4
	mov	r4,r0
	tst	#S_FLAG,r0
	bf	jmps
nojmps:
	CPUWORK	3
	mov	#1,r3
	shll16	r3
	jmp	@r13
	add	r3,r12
jnle_short:
	mov	r12,r0
	tst	#Z_FLAG,r0
	bf	nojmps
jnl_short:
	mov	r12,r4
	mov	#-4,r3
	shld	r3,r4
	xor	r12,r4
	mov	r4,r0
	tst	#S_FLAG,r0
	bf	nojmps
jmps:
	JMPS	7
	
xchg_ea_r8:
	EAREG8	r10
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bf/s		xchgear8_1
	mov	r0,r4
	R8SRC	r4, r6
	CPUWORK	3
	mov.b	@r10,r4
	mov.b	@r6,r5
	mov.b	r4,@r6
	jmp	@r13
	mov.b	r5,@r10
xchgear8_1:
	mov.l	200f,r3
	jsr	@r3
	nop
	mov.l	201f,r3
	cmp/hs	r3,r0
	bt/s	xchgear8_2
	mov	r0,r4
	CPUWORK	5
	add	r1,r4
	mov.b	@r10,r5
	mov.b	@r4,r8
	mov.b	r5,@r4
	jmp	@r13
	mov.b	r8,@r10

	.align	2
200:	.long	i286h_ea
201:	.long	I286_MEMWRITEMAX
xchgear8_2:
	mov.l	10000f,r3
	jsr	@r3
	mov	r4,r9
	mov.b	@r10,r5
	mov.b	r0,@r10
	mov.l	10002f,r3
	extu.b	r5,r5
	lds	r13,pr
	CPUWORK	5
	jmp	@r3
	mov	r9,r4
	
	.align	2
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite
	
xchg_ea_r16:
	EAREG16	r10
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bf/s	xchgear16_1
	mov	r0,r4
	R16SRC	r4, r6
	mov.w	@r10,r4
	mov.w	@r6,r5
	CPUWORK	3
	mov.w	r4,@r6
	jmp	@r13	
	mov.w	r5,@r10
xchgear16_1:
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r0,r4
	ACCWORD	r4, xchgear16_2
	mov.w	@r10,r5
	add	r1,r4
	mov.w	@r4,r8
	CPUWORK	5
	mov.w	r5,@r4
	jmp	@r13
	mov.w	r8,@r10	

	_ACCWORD
200:	.long	i286h_ea
	
	
xchgear16_2:
	mov.l	10001f,r3
	jsr	@r3
	mov	r4,r9
	mov.w	@r10,r5
	mov.w	r0,@r10
	mov.l	10003f,r3
	lds	r13,pr
	CPUWORK	5
	jmp	@r3
	mov	r9,r4

	.align	2
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w
	
mov_ea_r8:
	EAREG8	r10
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bf/s	movear8_1
	mov	r0,r4
	mov.b	@r10,r5
	R8SRC	r4, r6
	CPUWORK	3
	jmp	@r13
	mov.b	r5,@r6
movear8_1:	
	mov.l	200f,r3
	CPUWORK	5
	jsr	@r3
	nop
	mov.l	10002f,r3
	mov.b	@r10,r5
	lds	r13,pr
	mov	r0,r4
	jmp	@r3
	extu.b	r5,r5

	.align	2
200:	.long	i286h_ea
10002:	.long	i286h_memorywrite
	
mov_ea_r16:
	EAREG16	r10
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bf/s	movear16_1
	mov	r0,r4
	mov.w	@r10,r5
	R16SRC	r4, r6
	CPUWORK	3
	jmp	@r13
	mov.w	r5,@r6
movear16_1:
	mov.l	200f,r3
	CPUWORK	5
	jsr	@r3
	nop
	mov.l	10003f,r3
	mov.w	@r10,r5
	lds	r13,pr
	mov	r0,r4
	jmp	@r3
	extu.w	r5,r5

	.align	2
200:	.long	i286h_ea
10003:	.long	i286h_memorywrite_w
	
mov_r8_ea:
	REG8EA	r10, 2, 5
	jmp	@r13
	mov.b	r0,@r10
mov_r16_ea:
	REG16EA	r10, 2, 5
	jmp	@r13
	mov.w	r0,@r10
mov_ea_seg:
	GETPCF8
	mov	r0,r4
	mov	#(3 << 3),r5
	stc	gbr,r0
	mov	#0xc0,r3
	and	r4,r5
	shlr2	r5
	extu.b	r3,r3
	add	#CPU_SEG,r5
	mov.w	@(r0,r5),r10
	cmp/hs	r3,r4
	bf/s	measegm
	extu.w	r10,r10
	R16SRC	r4, r6
	CPUWORK	2
	jmp	@r13
	mov.w	r10,@r6
measegm:	
	mov.l	200f,r3
	CPUWORK	3
	jsr	@r3
	nop
	mov.l	10003f,r3
	mov	r0,r4
	lds	r13,pr
	jmp	@r3
	mov	r10,r5

	_GETPCF8
	_REG16EA
200:	.long	i286h_ea
10003:	.long	i286h_memorywrite_w
	
lea_r16_ea:	CPUWORK	3
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	leareg
	mov	r0,r4
	R16DST	r4, r10
	mov.l	200f,r3
	jsr	@r3
	nop
	jmp	@r13
	mov.w	r0,@r10

	_GETPCF8
200:	.long	i286h_lea
leareg:
	mov.l	200f,r3
	mov	#((2 << 16) >> 16),r0
	mov	#6,r10
	shll16	r0
	jmp	@r3
	sub	r0,r12
	
	.align	2
200:	.long	i286h_localint
mov_seg_ea:
	mov.b	@(CPU_MSW,gbr),r0
	extu.b	r0,r10
	GETPCF8
	mov.l	200f,r6
	mov	#MSW_PE,r3
	mov	r0,r4
	tst	r3,r10
	bt/s	1f
	and	#(3 << 3),r0
	or	#(4 << 3),r0
1:
	mov	r12,r10
	mov	#0xc0,r3
	shlr	r0
	extu.b	r3,r3
	cmp/hs	r3,r4
	bf/s	msegeam
	mov.l	@(r0,r6),r6
	R16SRC	r4, r8
	CPUWORK	2
	mov.w	@r8,r4
	jmp	@r6
	extu.w	r4,r0

	.align	2
200:	.long	msegea_tbl
msegeam:
	mov.l	200f,r3
	CPUWORK	5
	jsr	@r3
	mov.l	r6,@-r15
	mov.l	10001f,r3
	lds.l	@r15+,pr
	jmp	@r3
	mov	r0,r4
	
	.align	2
msegea_tbl:	.long		msegea_es
				.long		msegea_cs
				.long		msegea_ss
				.long		msegea_ds
				.long		msegea_es_p
				.long		msegea_cs
				.long		msegea_ss_p
				.long		msegea_ds_p

	_GETPCF8
200:	.long	i286h_ea
10001:	.long	i286h_memoryread_w
msegea_es:
	mov.w	r0,@(CPU_ES,gbr)
	mov	#4,r3
	shld	r3,r0
	jmp	@r13
	mov.l	r0,@(CPU_ES_BASE,gbr)
msegea_ds:
	mov.w	r0,@(CPU_DS,gbr)
	mov	#4,r3
	shld	r3,r0
	mov.l	r0,@(CPU_DS_BASE,gbr)
	jmp	@r13
	mov.l	r0,@(CPU_DS_FIX,gbr)
msegea_ss:
	mov.w	r0,@(CPU_SS,gbr)
	mov	#4,r3
	shld	r3,r0
	mov.l	r0,@(CPU_SS_BASE,gbr)
	mov.l	r0,@(CPU_SS_FIX,gbr)
	NEXT_OPCODE

msegea_es_p:
	mov.l	200f,r3
	jsr	@r3
	mov.w	r0,@(CPU_ES,gbr)
	jmp	@r13
	mov.l	r0,@(CPU_ES_BASE,gbr)

	.align	2
200:	.long	i286h_selector
msegea_ds_p:
	mov.l	200f,r3
	jsr	@r3
	mov.w	r0,@(CPU_DS,gbr)
	mov.l	r0,@(CPU_DS_BASE,gbr)
	jmp	@r13
	mov.l	r0,@(CPU_DS_FIX,gbr)

	.align	2
200:	.long	i286h_selector
msegea_ss_p:
	mov.l	200f,r3
	jsr	@r3
	mov.w	r0,@(CPU_SS,gbr)
	mov.l	r0,@(CPU_SS_BASE,gbr)
	mov.l	r0,@(CPU_SS_FIX,gbr)
	NEXT_OPCODE

	.align	2
200:	.long	i286h_selector
msegea_cs:
	mov	#((2 << 16) >> 16),r0
	mov	r10,r12
	mov.l	200f,r3
	shll16	r0
	mov	#6,r10
	jmp	@r3
	sub	r0,r12

	.align	2
200:	.long	i286h_localint
pop_ea:
	POP	5
	mov	r0,r10
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	popreg
	mov	r0,r4
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r10,r5
	mov.l	10003f,r3
	lds	r13,pr
	jmp	@r3
	mov	r0,r4

	_POP
200:	.long	i286h_ea
10003:	.long	i286h_memorywrite_w
	_GETPCF8
popreg:
	R16SRC	r4, r5
	jmp	@r13
	mov.w	r8,@r5

	
nopandbios:
	mov	r12,r4
	shlr16	r4
	add	#-1,r4
	extu.w	r4,r4
	CPUWORK	3
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r9
	mov.l	201f,r3
	add	r9,r4
	cmp/hs	r3,r4
	mov	#(0x100000 >> 16),r3
	bt/s	1f
	shll16	r3
	jmp	@r13
	nop
1:	
	cmp/hs	r3,r4
	bf	2f
	jmp	@r13
	nop
2:
	mov.l	203f,r3
	CPUSV
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	CPULD
	mov	#4,r3
	mov.w	@(CPU_ES,gbr),r0
	extu.w	r0,r0
	shld	r3,r0
	mov.l	r0,@(CPU_ES_BASE,gbr)
	mov.w	@(CPU_CS,gbr),r0
	extu.w	r0,r0
	shld	r3,r0
	mov.l	r0,@(CPU_CS_BASE,gbr)
	mov.w	@(CPU_SS,gbr),r0
	extu.w	r0,r0
	shld	r3,r0
	mov.l	r0,@(CPU_SS_BASE,gbr)
	mov.l	r0,@(CPU_SS_FIX,gbr)
	mov.w	@(CPU_DS,gbr),r0
	extu.w	r0,r0
	shld	r3,r0
	mov.l	r0,@(CPU_DS_BASE,gbr)
	jmp	@r13
	mov.l	r0,@(CPU_DS_FIX,gbr)

	.align	2
201:	.long	0x0f8000
203:	.long	_biosfunc
	
cbw:
	CPUWORK	2
	mov.b	@(CPU_AL,gbr),r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)	
cwd:
	CPUWORK	2
	mov.b	@(CPU_AH,gbr),r0
	mov	#24,r3
	shld	r3,r0
	mov	#-31,r3
	shad	r3,r0
	jmp	@r13
	mov.w	r0,@(CPU_DX,gbr)	
call_far:
	CPUWORK	13
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_CS,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10003f,r3	! cs
	add	#-2,r8
	extu.w	r8,r8
	mov	r0,r9
	mov	r8,r4
	jsr	@r3
	add	r9,r4
	add	#-2,r8
	extu.w	r8,r8
	mov.l	10003f,r3
	mov	r12,r5
	shlr16	r5
	add	#4,r5
	mov	r9,r4
	mov.l	@(CPU_CS_BASE,gbr),r0
	add	r8,r4
	jsr	@r3		! ip
	mov	r0,r9
	mov	r8,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	10001f,r3
	mov	r12,r4
	shlr16	r4
	jsr	@r3		! newip
	add	r9,r4
	mov	#2,r3
	mov	r0,r8
	shll16	r3
	mov.b	@(CPU_MSW,gbr),r0
	add	r3,r12
	shll16	r8
	mov	r12,r4
	mov.l	10001f,r3
	shlr16	r4
	add	r9,r4
	jsr	@r3
	extu.b	r0,r9
	mov	#MSW_PE,r3
	tst	r3,r9
	bf/s	1f
	mov.w	r0,@(CPU_CS,gbr)
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	202f,r3
	jsr	@r3
	nop
2:
	mov.l	r0,@(CPU_CS_BASE,gbr)
	extu.w	r12,r12
	jmp	@r13
	or	r8,r12

	.align	2
10003:	.long	i286h_memorywrite_w
10001:	.long	i286h_memoryread_w
202:	.long	i286h_selector
	
wait:
	CPUWORK	2
	jmp	@r13
	nop
pushf:
	CPUWORK	3
	mov.w	@(CPU_SP,gbr),r0
	mov	r12,r5
	mov	#2,r3
	extu.w	r0,r0
	cmp/hs	r3,r0
	bt/s	1f
	add	#-2,r0
	mov	#1,r3
	shll16	r3
	add	r3,r0
1:
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	10003f,r3
	mov	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	lds	r13,pr
	jmp	@r3
	add	r0,r4

	.align	2
10003:	.long	i286h_memorywrite_w
popf:
	POP	5
.if 1
	shlr16	r12
	mov	r0,r4
	mov	#4,r3
	swap.w	r0,r5
	shld	r3,r5
	mov	#-4,r3
	shld	r3,r5
	swap.w	r5,r5
	mov	#((I_FLAG + T_FLAG) >> 8),r3
	swap.b	r4,r6
	shll16	r12
	and	r3,r6
	cmp/eq	r3,r6
	bt/s	popf_withirq
	or	r5,r12
.else
.endif

	mov.l	popf_pic,r4
	NOINTREXIT
popf_withirq:	I286IRQCHECKTERM

	_POP
popf_pic:	.long		_pic

sahf:
	CPUWORK	2
	shlr8	r12
	mov.b	@(CPU_AH,gbr),r0
	shll8	r12
	extu.b	r0,r4
	jmp	@r13
	or	r4,r12
lahf:
	CPUWORK	2
	mov	r12,r0
	jmp	@r13
	mov.b	r0,@(CPU_AH,gbr)
mov_al_m8:
	CPUWORK	5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r10
	GETPC16
	mov.l	10000f,r3
	mov	r0,r4
	jsr	@r3
	add	r10,r4
	jmp	@r13
	mov.b	r0,@(CPU_AL,gbr)

	_GETPC16
10000:	.long	i286h_memoryread
	
mov_ax_m16:
	CPUWORK	5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r10
	GETPC16
	mov.l	10001f,r3
	mov	r0,r4
	jsr	@r3
	add	r10,r4
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)

	_GETPC16
10001:	.long	i286h_memoryread_w
	
mov_m8_al:
	CPUWORK	5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r10
	GETPC16
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	mov.l	10002f,r3
	lds	r13,pr
	add	r10,r4
	jmp	@r3
	extu.b	r0,r5

	_GETPC16
10002:	.long	i286h_memorywrite
	
mov_m16_ax:
	CPUWORK	5
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r10
	GETPC16
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0
	mov.l	10003f,r3
	lds	r13,pr
	add	r10,r4
	jmp	@r3
	extu.w	r0,r5

	_GETPC16
10003:	.long	i286h_memorywrite_w
	
movsb:	CPUWORK	5
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r10
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov.l	10000f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf	1f
	bra	2f
	mov	#1,r8
1:
	mov	#-1,r8
2:	
	jsr	@r3
	add	r10,r4
	mov	r0,r5
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r7
	mov.l	@(CPU_ES_BASE,gbr),r0
	add	r8,r10
	mov	r0,r4
	add	r7,r4
	add	r8,r7
	mov.l	10002f,r3
	mov	r10,r0
	lds	r13,pr
	mov.w	r0,@(CPU_SI,gbr)
	mov	r7,r0
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
10000:	.long	i286h_memoryread
10002:	.long	i286h_memorywrite

movsw:
	CPUWORK	5
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r10
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov.l	10001f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf	1f
	bra	2f
	mov	#2,r8
1:
	mov	#-2,r8
2:	
	jsr	@r3
	add	r10,r4
	mov	r0,r5
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r7
	mov.l	@(CPU_ES_BASE,gbr),r0
	add	r8,r10
	mov	r0,r4
	add	r7,r4
	add	r8,r7
	mov.l	10003f,r3
	lds	r13,pr
	mov	r10,r0
	mov.w	r0,@(CPU_SI,gbr)
	mov	r7,r0
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
10003:	.long	i286h_memorywrite_w

cmpsb:
	CPUWORK	8
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r4
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	10000f,r3
	mov	r0,r8
	jsr	@r3
	add	r9,r4
	mov	r0,r10
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r7
	swap.b	r12,r0
	and	#(D_FLAG >> 8),r0
	mov	#-(10 - 1),r3
	swap.b	r0,r2
	shld	r3,r2
	mov	r8,r4
	mov	#1,r6
	add	r7,r4
	sub	r2,r6
	add	r6,r9
	mov.l	10000f,r3
	add	r6,r7
	mov	r9,r0
	mov.w	r0,@(CPU_SI,gbr)
	mov	r7,r0
	jsr	@r3
	mov.w	r0,@(CPU_DI,gbr)
	mov	r0,r4
	SUB8	r10, r4
	jmp	@r13
	nop

	.align	2
10000:	.long	i286h_memoryread
	
cmpsw:
	CPUWORK	8
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov	r0,r4
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r0,r8
	jsr	@r3
	add	r9,r4
	mov	r0,r10
	mov.w	@(CPU_DI,gbr),r0
	mov	#-(10 - 2),r3
	extu.w	r0,r7
	swap.b	r12,r0
	and	#(D_FLAG >> 8),r0
	mov	r8,r4
	swap.b	r0,r2
	mov	#2,r6
	shld	r3,r2
	add	r7,r4
	sub	r2,r6
	mov.l	10001f,r3
	add	r6,r9
	mov	r9,r0
	add	r6,r7
	mov.w	r0,@(CPU_SI,gbr)
	mov	r7,r0
	jsr	@r3
	mov.w	r0,@(CPU_DI,gbr)
	mov	r0,r4
	SUB16	r10, r4
	jmp	@r13
	nop

	.align	2
10001:	.long	i286h_memoryread_w

stosb:
	CPUWORK	3
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r5
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r6
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r6,r0
	bra	2f
	add	#1,r0
1:
	add	#-1,r0
2:
	mov.l	10002f,r3
	lds	r13,pr
	add	r6,r4
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
10002:	.long	i286h_memorywrite

stosw:
	CPUWORK	3
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r5
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r6
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r6,r0
	bra	2f
	add	#2,r0
1:
	add	#-2,r0
2:
	mov.l	10003f,r3
	lds	r13,pr
	add	r6,r4
	jmp	@r3
	mov.w	r0,@(CPU_DI,gbr)

	.align	2
10003:	.long	i286h_memorywrite_w

lodsb:	CPUWORK	5
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov.l	10000f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r9,r10
	bra	2f
	add	#1,r10
1:
	add	#-1,r10
2:
	jsr	@r3
	add	r9,r4
	mov.b	r0,@(CPU_AL,gbr)
	mov	r10,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)

	.align	2
10000:	.long	i286h_memoryread

lodsw:	CPUWORK	5
	mov.w	@(CPU_SI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov.l	10001f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r9,r10
	bra	2f
	add	#2,r10
1:
	add	#-2,r10
2:	
	jsr	@r3
	add	r9,r4
	mov.w	r0,@(CPU_AX,gbr)
	mov	r10,r0
	jmp	@r13
	mov.w	r0,@(CPU_SI,gbr)

	.align	2
10003:	.long	i286h_memoryread_w

scasb:
	CPUWORK	7
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	10000f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r9,r10
	bra	2f
	add	#1,r10
1:
	add	#-1,r10
2:
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r9
	mov	r10,r0
	mov.w	r0,@(CPU_DI,gbr)
	SUB8	r9, r4
	jmp	@r13
	nop

	.align	2
10000:	.long	i286h_memoryread
	
scasw:
	CPUWORK	7
	mov.w	@(CPU_DI,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_ES_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r0,r4
	swap.b	r12,r0
	tst	#(D_FLAG >> 8),r0
	bf/s	1f
	mov	r9,r10
	bra	2f
	add	#2,r10
1:
	add	#-2,r10
2:	
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r9
	mov	r10,r0
	mov.w	r0,@(CPU_DI,gbr)
	SUB16	r9, r4
	jmp	@r13
	nop

	.align	2
10003:	.long	i286h_memoryread_w

ret_near_d16:
	CPUWORK	11
	GETPC16
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r5,r7
	add	r4,r7
	mov	r0,r4
	add	r5,r4
	mov.l	10001f,r3
	add	#2,r7
	mov	r7,r0
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	extu.w	r12,r12
	shll16	r0
	jmp	@r13
	or	r0,r12

	_GETPC16
10003:	.long	i286h_memoryread_w
ret_near:
	CPUWORK	11
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_SS_BASE,gbr),r0
	extu.w	r12,r12
	mov.l	10001f,r3
	mov	r0,r4
	mov	r5,r0
	add	#2,r0
	add	r5,r4
	jsr	@r3
	mov.w	r0,@(CPU_SP,gbr)
	shll16	r0
	jmp	@r13
	or	r0,r12
	
	.align	2
10003:	.long	i286h_memoryread_w

les_r16_ea:
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	lr16_r
	mov	r0,r4
	CPUWORK	3
	R16DST	r4, r9
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#~((1 << 16) >> 16),r3
	mov	r0,r8
	add	#2,r8
	mov.l	10001f,r0
	swap.w	r8,r8
	add	r10,r4
	and	r3,r8
	jsr	@r0
	swap.w	r8,r8
	mov.w	r0,@r9
	mov.l	10001f,r3
	mov	r10,r4
	mov.b	@(CPU_MSW,gbr),r0
	add	r8,r4
	jsr	@r3
	extu.b	r0,r8
	mov	#MSW_PE,r3
	tst	r3,r8
	bf/s	1f
	mov.w	r0,@(CPU_ES,gbr)
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	202f,r3
	jsr	@r3
	mov	r0,r4
2:
	jmp	@r13
	mov.l	r0,@(CPU_ES_BASE,gbr)
lr16_r:
	mov	#((2 << 16) >> 16),r0
	mov.l	201f,r3
	mov	#6,r10
	shll16	r0
	jmp	@r3
	sub	r0,r12

	_GETPCF8
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
202:	.long	i286h_selector
201:	.long	i286h_localint
	
lds_r16_ea:
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	lr16_r
	mov	r0,r4
	CPUWORK	3
	R16DST	r4, r9
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#~((1 << 16) >> 16),r3
	mov	r0,r8
	mov.l	10001f,r0
	add	#2,r8
	swap.w	r8,r8
	add	r10,r4
	and	r3,r8
	jsr	@r0
	swap.w	r8,r8
	mov.w	r0,@r9
	mov	r10,r4
	mov.l	10001f,r3
	add	r8,r4
	mov.b	@(CPU_MSW,gbr),r0
	jsr	@r3
	extu.b	r0,r8
	mov	#MSW_PE,r3
	tst	r3,r8
	bf/s	1f
	mov.w	r0,@(CPU_DS,gbr)
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	203f,r3
	jsr	@r3
	nop
2:	
	mov.l	r0,@(CPU_DS_BASE,gbr)
	jmp	@r13
	mov.l	r0,@(CPU_DS_FIX,gbr)

	_GETPCF8
200:	.long	i286h_a
10001:	.long	i286h_memoryread_w
203:	.long	i286h_selector
	
mov_ea8_d8:
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	med8_r
	mov	r0,r4
	CPUWORK	3
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r0,r8
	GETPCF8
	mov.l	10002f,r3
	lds	r13,pr
	mov	r0,r5
	jmp	@r3
	mov	r8,r4
med8_r:
	CPUWORK	2
	R8DST	r4, r8
	GETPCF8
	jmp	@r13
	mov.b	r0,@r8

	_GETPCF8
200:	.long	i286h_ea
10002:	.long	i286h_memorywrite
	_GETPCF8

	
mov_ea16_d16:
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bt/s	med16_r
	mov	r0,r4
	CPUWORK	3
	mov.l	200f,r3
	jsr	@r3
	nop
	mov	r0,r8
	GETPC16
	mov.l	10003f,r3
	lds	r13,pr
	mov	r0,r5
	jmp	@r3
	mov	r8,r4
med16_r:
	CPUWORK	2
	R16DST	r4, r8
	GETPC16
	jmp	@r13
	mov.w	r0,@r8

	_GETPCF8
200:	.long	i286h_ea
10003:	.long	i286h_memorywrite_w
	_GETPC16

enter:
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r8
	mov.w	@(CPU_BP,gbr),r0
	extu.w	r0,r9
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	#2,r3
	mov	r0,r4
	cmp/hs	r3,r8
	bt/s	1f
	add	#-2,r8
	mov	#(0x10000 >> 16),r3
	shll16	r3
	add	r3,r8
1:
	mov.l	10003f,r3
	mov	r9,r5
	jsr	@r3
	add	r8,r4
	GETPC16
	mov	r0,r10
	GETPC8
	tst	#0x1f,r0
	bf/s	enterlv1
	mov	r0,r4
	CPUWORK	11
	mov	r8,r0
	mov.w	r0,@(CPU_BP,gbr)
	sub	r10,r0
	jmp	@r13
	mov.w	r0,@(CPU_SP,gbr)
enterlv1:
	cmp/eq	#1,r0
	bf	enterlv2
	CPUWORK	15
	mov	r8,r0
	mov	#2,r3
	mov.w	r0,@(CPU_BP,gbr)
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r8,r5
	mov	r0,r4
	cmp/hs	r3,r8
	bt/s	1f
	add	#-2,r8
	mov	#(0x10000 >> 16),r3
	shll16	r3
	add	r3,r8
1:	
	add	r8,r4
	mov.l	10003f,r3
	mov	r8,r0
	lds	r13,pr
	sub	r10,r0
	jmp	@r3
	mov.w	r0,@(CPU_SP,gbr)
enterlv2:
	mov	r4,r5
	shll2	r5
	add	#(12 + 4),r5
	mov	r8,r0
	sub	r5,r11
	mov.w	r0,@(CPU_BP,gbr)
	mov.l	r13,@-r15

	mov	r8,r6
	add	#-2,r6
	extu.w	r6,r6
	mov	r6,r0
	sub	r10,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r4,r10
	mov	r9,r5
	mov	r0,r13
	mov.l	10003f,r3
	mov	r6,r4
	jsr	@r3
	add	r13,r4
entlv2lp:
	add	#-2,r9
	extu.w	r9,r9
	add	#-2,r8
	mov	r9,r4
	mov.l	10001f,r3
	extu.w	r8,r8
	jsr	@r3
	add	r13,r4
	mov	r0,r5
	mov.l	10003f,r3
	mov	r8,r4
	jsr	@r3
	add	r13,r4
	dt	r10
	bf	entlv2lp
	mov.l	@r15+,r13
	jmp	@r13
	nop

	_GETPC16
10003:	.long	i286h_memorywrite_w
	_GETPC8
	
leave:
	CPUWORK	5
	mov.w	@(CPU_BP,gbr),r0
	mov.l	10001f,r3
	extu.w	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r4,r8
	add	#2,r8
	jsr	@r3
	add	r0,r4
	mov.w	r0,@(CPU_BP,gbr)
	mov	r8,r0
	jmp	@r13
	mov.w	r0,@(CPU_SP,gbr)

	.align	2
10001:	.long	i286h_memoryread_w

ret_far_d16:
	CPUWORK	15
	GETPC16
	mov	r0,r4
	mov.w	@(CPU_SP,gbr),r0
	mov.l	10001f,r3
	extu.w	r0,r8
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r4,r10
	mov	r0,r9
	mov	r8,r4
	add	r9,r4
	jsr	@r3
	add	#2,r8
	extu.w	r12,r12
	shll16	r0
	mov	#~((1 << 16) >> 16),r3
	or	r0,r12
	swap.w	r8,r8
	and	r3,r8
	mov	r9,r4
	swap.w	r8,r8
	mov.l	10001f,r3
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov	r0,r4
	add	r10,r8
	mov.w	r0,@(CPU_CS,gbr)
	mov	r8,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.b	@(CPU_MSW,gbr),r0
	tst	#MSW_PE,r0
	bf/s	1f
	extu.b	r0,r5
	mov	r4,r0
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	201f,r3
	jsr	@r3
	nop
2:
	jmp	@r13
	mov.l	r0,@(CPU_CS_BASE,gbr)

	_GETPC16
201:	.long	i286h_selector
10001:	.long	i286h_memoryread_w	
	

ret_far:
	CPUWORK	15
	mov.w	@(CPU_SP,gbr),r0
	mov.l	10001f,r3
	extu.w	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov	r4,r8
	mov	r0,r9
	add	#2,r8
	jsr	@r3
	add	r9,r4
	extu.w	r12,r12
	shll16	r0
	or	r0,r12
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	and	r3,r8
	mov	r9,r4
	swap.w	r8,r8
	mov.l	10001f,r3
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov	r0,r4
	mov.w	r0,@(CPU_CS,gbr)
	mov	r8,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.b	@(CPU_MSW,gbr),r0
	tst	#MSW_PE,r0
	bf/s	1f
	extu.b	r0,r5
	mov	r4,r0
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	201f,r3
	jsr	@r3
	nop
2:
	jmp	@r13
	mov.l	r0,@(CPU_CS_BASE,gbr)

	.align	2
201:	.long	i286h_selector
10001:	.long	i286h_memoryread_w	
	
int_03:
	CPUWORK	3
	mov.l	200f,r3
	jmp	@r3
	mov	#3,r10
	
	.align	2
200:	.long	i286h_localint
int_d8:
	CPUWORK	3
	GETPCF8
	mov.l	200f,r3
	jmp	@r3
	mov	r0,r10

	_GETPCF8
200:	.long	i286h_localint
into:
	CPUWORK	4
	swap.b	r12,r0
	tst	#(O_FLAG >> 8),r0
	bf	1f
	jmp	@r13
	nop
1:	
	mov.l	200f,r3
	jmp	@r3
	mov	#4,r10

	.align	2
200:	.long	i286h_localint
	
iret:
	CPUWORK	31
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r0,r9
	mov.w	@(CPU_SP,gbr),r0
	extu.w	r0,r4
	mov	r4,r8
	add	#2,r8
	jsr	@r3
	add	r9,r4
	mov	r0,r12
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	shll16	r12
	and	r3,r8
	mov	r9,r4
	swap.w	r8,r8
	mov.l	10001f,r3
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov	#4,r3
	mov.w	r0,@(CPU_CS,gbr)
	shld	r3,r0
	mov.l	r0,@(CPU_CS_BASE,gbr)
	mov	#~((1 << 16) >> 16),r3
	swap.w	r8,r8
	mov	r9,r4
	and	r3,r8
	swap.w	r8,r8
	mov.l	10001f,r3
	add	r8,r4
	jsr	@r3
	add	#2,r8
	mov	r0,r4
	mov	r8,r0
	mov.w	r0,@(CPU_SP,gbr)
.if 1
	swap.b	r4,r5
	mov	r5,r0
	shlr8	r5
	and	#~(0xf000 >> 8),r0
	shll8	r5
	or	r0,r5
	swap.b	r5,r5
	mov	#((I_FLAG + T_FLAG) >> 8),r3
	swap.b	r4,r6
	and	r3,r6
	cmp/eq	r3,r6
	bt/s	iret_withirq
	or	r5,r12
.else
.endif
	mov.l	iret_pic,r4
	NOINTREXIT
iret_withirq:	I286IRQCHECKTERM
	
	.align	2
10001:	.long	i286h_memoryread_w
iret_pic:	.long		_pic

aam:
	CPUWORK	16
	GETPCF8
	mov	#7,r3
	shld	r3,r0
	tst	r0,r0
	bt/s	aamzero
	mov	r0,r4
	mov.b	@(CPU_AL,gbr),r0
	mov	#0x80,r6
	extu.b	r0,r5
	mov	#0,r7
	extu.b	r6,r6
aamlp:
	cmp/hs	r4,r5
	bf	1f
	sub	r4,r5
	or	r6,r7
1:
	shlr	r6
	tst	r6,r6
	bf/s	aamlp
	shlr	r4
	mov	r5,r0
	mov.b	@(r0,r14),r6
	shll8	r7
	mov	r12,r0
	shlr8	r12
	and	#~(S_FLAG + Z_FLAG + P_FLAG),r0
	add	r7,r5
	shll8	r12
	mov	r5,r7
	or	r12,r0
	shll16	r7
	tst	r7,r7
	bf/s	1f
	cmp/pz	r7
	or	#Z_FLAG,r0
1:		
	bt	2f
	or	#S_FLAG,r0
2:
	mov	#P_FLAG,r3
	mov	r0,r12
	and	r3,r6
	or	r6,r12
	mov	r5,r0
	jmp	@r13
	mov.w	r0,@(CPU_AX,gbr)
aamzero:
	mov.l	200f,r3
	mov	#((2 << 16) >> 16),r0
	mov	#0,r10
	shll16	r0
	jmp	@r3
	sub	r0,r12

	_GETPCF8
200:	.long	i286h_localint
	
aad:
	mov.w	@(CPU_AX,gbr),r0
	extu.w	r0,r10
	GETPCF8
	mov	r10,r6
	shlr8	r6
	mul.l	r6,r0
	mov	r12,r0
	shlr8	r12
	and	#~(S_FLAG + Z_FLAG + P_FLAG),r0
	shll8	r12
	or	r0,r12
	sts	macl,r7
	add	r10,r7
	extu.b	r7,r0
	mov.b	@(r0,r14),r6
	mov.w	r0,@(CPU_AX,gbr)
	extu.b	r6,r6
	CPUWORK	14
	jmp	@r13
	or	r6,r12

	_GETPCF8
	
setalc:
	CPUWORK	2
	mov	#31,r3
	mov	r12,r0
	shld	r3,r0
	mov	#-31,r3
	shad	r3,r0
	jmp	@r13
	mov.b	r0,@(CPU_AL,gbr)
	
xlat:
	CPUWORK	5
	mov.b	@(CPU_AL,gbr),r0
	extu.b	r0,r4
	mov.w	@(CPU_BX,gbr),r0
	extu.w	r0,r5
	mov.l	@(CPU_DS_FIX,gbr),r0
	add	r5,r4
	mov	#~((1 << 16) >> 16),r3
	swap.w	r4,r4
	and	r3,r4
	mov.l	10000f,r3
	swap.w	r4,r4
	jsr	@r3
	add	r0,r4
	jmp	@r13
	mov.b	r0,@(CPU_AL,gbr)

	.align	2
10000:	.long	i286h_memoryread

esc:
	CPUWORK	2
	GETPCF8
	mov	#0xc0,r3
	extu.b	r3,r3
	cmp/hs	r3,r0
	bf/s	1f
	mov	r0,r4
	jmp	@r13
	nop
1:
	mov.l	200f,r3
	jmp	@r3
	lds	r13,pr

	_GETPCF8
200:	.long	i286h_ea
	
loopnz:
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r0
	!
	!
	dt	r0
	bt/s	lpnznoj
	mov.w	r0,@(CPU_CX,gbr)
	mov	r12,r0
	tst	#Z_FLAG,r0
	bf	lpnznoj
	JMPS	8
lpnznoj:
	CPUWORK	4
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	jmp	@r13
	add	r3,r12
	
loopz:
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r0
	!
	!
	dt	r0
	bt/s	lpznoj
	mov.w	r0,@(CPU_CX,gbr)
	mov	r12,r0
	tst	#Z_FLAG,r0
	bt	lpznoj
	JMPS	8
lpznoj:
	CPUWORK	4
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	jmp	@r13
	add	r3,r12
	
loop:
	mov.w	@(CPU_CX,gbr),r0
	extu.w	r0,r0
	!
	!
	dt	r0
	bt/s	lpnoj
	mov.w	r0,@(CPU_CX,gbr)
	JMPS	8
lpnoj:
	CPUWORK	4
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	jmp	@r13
	add	r3,r12
	
jcxz:
	mov.w	@(CPU_CX,gbr),r0
	!
	!
	tst	r0,r0
	bt	jcxzj
	CPUWORK	4
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	jmp	@r13
	add	r3,r12
jcxzj:
	JMPS	8

in_al_d8:
	CPUWORK	5
	GETPCF8
	mov	r0,r4
	CPUSV
	mov	r12,r0
	mov.l	r1,@-r15
	shlr16	r0
	mov.l	200f,r3
	add	r9,r0
	jsr	@r3
	mov.l	r0,@(CPU_INPUT,gbr)
	mov.b	r0,@(CPU_AL,gbr)
	mov.l	@r15+,r1
	CPULD
	mov	#0,r0
	jmp	@r13
	mov.l	r0,@(CPU_INPUT,gbr)

	_GETPCF8
200:	.long	_iocore_inp8
	
in_ax_d8:
	CPUWORK	5
	GETPCF8
	mov	r0,r4
	mov.l	200f,r3
	CPUSV
	jsr	@r3
	mov.l	r1,@-r15
	mov.w	r0,@(CPU_AX,gbr)
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	_GETPCF8
200:	.long	_iocore_inp16
	
out_d8_al:
	CPUWORK	3
	GETPCF8
	mov	r0,r4
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.b	@(CPU_AL,gbr),r0
	jsr	@r3
	extu.b	r0,r5
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	_GETPCF8
200:	.long	_iocore_out8

out_d8_ax:
	CPUWORK	3
	GETPCF8
	mov	r0,r4
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.w	@(CPU_AX,gbr),r0
	jsr	@r3
	extu.w	r0,r5
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	_GETPCF8
200:	.long	_iocore_out16

	
call_near:
	CPUWORK	7
	GETPC16
	shll16	r0
	mov	r12,r5
	add	r0,r12
	mov.w	@(CPU_SP,gbr),r0
	shlr16	r5
	extu.w	r0,r0
	add	#-2,r0
	mov.w	r0,@(CPU_SP,gbr)
	mov.l	10003f,r3
	extu.w	r0,r4
	mov.l	@(CPU_SS_BASE,gbr),r0
	lds	r13,pr
	jmp	@r3
	add	r0,r4

	_GETPC16
10003:	.long	i286h_memorywrite_w
	
jmp_near:
	CPUWORK	7
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	#((2 << 16) >> 16),r9
	shll16	r9
	mov	r0,r8
	add	r12,r9
	mov.l	10001f,r3
	mov	r12,r4
	shlr16	r4
	jsr	@r3
	add	r8,r4
	mov	r0,r12
	shll16	r12
	jmp	@r13
	add	r9,r12

	.align	2
10001:	.long	i286h_memoryread_w
	
jmp_far:
	CPUWORK	11
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov.l	10001f,r3
	mov	r12,r9
	shlr16	r9
	mov	r0,r8
	add	#((2 << 16) >> 16),r9
	extu.w	r12,r10
	extu.w	r9,r9
	mov	r12,r4
	shlr16	r4
	jsr	@r3
	add	r8,r4
	mov	r0,r12
	mov.l	10001f,r3
	shll16	r12
	mov	r9,r4
	jsr	@r3
	add	r8,r4
	mov.w	r0,@(CPU_CS,gbr)
	mov	r0,r4
	mov.b	@(CPU_MSW,gbr),r0
	add	r10,r12
	tst	#MSW_PE,r0
	bf/s	1f
	extu.b	r0,r5
	mov	r4,r0
	mov	#4,r3
	bra	2f
	shld	r3,r0
1:
	mov.l	201f,r3
	jsr	@r3
	nop
2:
	jmp	@r13
	mov.l	r0,@(CPU_CS_BASE,gbr)

	.align	2
10001:	.long	i286h_memoryread_w
201:	.long	i286h_selector

in_al_dx:
	CPUWORK	5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	mov.b	r0,@(CPU_AL,gbr)
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	.align	2
200:	.long	_iocore_inp8
	
in_ax_dx:
	CPUWORK	5
	CPUSV
	mov.l	r1,@-r15
	mov.l	200f,r3
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	mov.w	r0,@(CPU_AX,gbr)
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	.align	2
200:	.long	_iocore_inp16
	
out_dx_al:
	CPUWORK	3
	CPUSV
	mov.l	r1,@-r15
	mov.b	@(CPU_AL,gbr),r0
	mov.l	200f,r3
	extu.b	r0,r5
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	.align	2
200:	.long	_iocore_out8
	
out_dx_ax:
	CPUWORK	3
	CPUSV
	mov.l	r1,@-r15
	mov.w	@(CPU_AX,gbr),r0
	mov.l	200f,r3
	extu.w	r0,r5
	mov.w	@(CPU_DX,gbr),r0
	jsr	@r3
	extu.w	r0,r4
	CPULD
	jmp	@r13
	mov.l	@r15+,r1

	.align	2
200:	.long	_iocore_out16
	
lock:	CPUWORK	2
	jmp	@r13
	nop

hlt:	CREMSET	-1
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	jmp	@r13
	sub	r3,r12
	
cmc:
	CPUWORK	2
	mov	#C_FLAG,r0
	jmp	@r13
	xor	r0,r12

clc:
	CPUWORK	2
	mov	#~(C_FLAG),r3
	jmp	@r13
	and	r3,r12
stc:
	CPUWORK	2
	mov	#C_FLAG,r0
	jmp	@r13
	or	r0,r12

cli:
	CPUWORK	2
	mov	#~(I_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	jmp	@r13
	swap.b	r12,r12
	
sti:
	CPUWORK	2
	swap.b	r12,r0
	tst	#(I_FLAG >> 8),r0
	bf	sti_noirq
sti_set:
.if 1
	swap.b	r12,r0
	or	#(I_FLAG >> 8),r0
	mov.l	sti_pic,r4
	tst	#(T_FLAG >> 8),r0
	bf/s	sti_withirq
	swap.b	r0,r12
.else
.endif
	PICEXISTINTR
	bf	sti_withirq
sti_noirq:	NEXT_OPCODE

	.align	2
sti_pic:	.long		_pic
sti_withirq:	REMAIN_ADJUST	1

cld:
	CPUWORK	2
	mov	#~(D_FLAG >> 8),r3
	swap.b	r12,r12
	and	r3,r12
	jmp	@r13
	swap.b	r12,r12
std:
	CPUWORK	2
	swap.b	r12,r0
	or	#(D_FLAG >> 8),r0
	jmp	@r13
	swap.b	r0,r12


	
! ---- cpu execute

_i286h_step:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	sts.l	pr,@-r15
	mov.l	r14,@-r15
	mov.l	200f,r0
	ldc	r0,gbr
	mov.l	201f,r1
	mov.l	202f,r14
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r0,r9
	CPULD
	mov.l	203f,r8
	mov	r12,r4
	mov.l	1000f,r3
	shlr16	r4
	jsr	@r3
	add	r9,r4
	shll2	r0
	mov.l	@(r0,r8),r5
	jsr	@r5
	sts	pr,r13
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
	CPUSV
	mov.l	204f,r3
	jsr	@r3
	nop
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.align	2
200:	.long	_i286hcore
201:	.long	_i286hcore + CPU_SIZE
202:	.long	_iflags
203:	.long	optbl1
1000:	.long	i286h_memoryread
204:	.long	_dmax86

_i286h:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	sts.l	pr,@-r15
	mov.l	r14,@-r15
	mov.l	200f,r0
	ldc	r0,gbr
	mov.l	201f,r1
	mov.l	202f,r6
	mov.l	203f,r14
	CPULD
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov.b	@r6,r5
	mov	r0,r9
	mov	#((I_FLAG + T_FLAG) >> 8),r3
	swap.b	r12,r4
	and	r3,r4
	cmp/eq	r3,r4
	extu.b	r5,r0
	bt/s	i286hwithtrap
	cmp/eq	#0,r0
	bf	i286hwithdma
i286h_lp:
	mov.l	204f,r8
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	add	r3,r12
	jsr	@r5
	sts	pr,r13
	CPUDBGL
	mov.l	@(CPU_CS_BASE,gbr),r0
	cmp/pl	r11
	bt/s	i286h_lp
	mov	r0,r9
	CPUSV
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.align	2
200:	.long	_i286hcore
201:	.long	_i286hcore + CPU_SIZE
202:	.long	_dmac + DMAC_WORKING
203:	.long	_iflags
204:	.long	optbl1

i286hwithdma:
	mov.l	202f,r8
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	add	r3,r12
	jsr	@r5
	sts	pr,r13
	mov.l	203f,r3
	jsr	@r3
	mov.l	r1,@-r15
	mov.l	@r15+,r1
	CPUDBGL
	mov.l	@(CPU_CS_BASE,gbr),r0
	cmp/pl	r11
	bt/s	i286hwithdma
	mov	r0,r9
	CPUSV
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

i286hwithtrap:
	mov.l	202f,r8
	mov	r12,r4
	shlr16	r4
	add	r9,r4
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	add	r3,r12
	jsr	@r5
	sts	pr,r13
	mov.l	203f,r3
	jsr	@r3
	mov.l	r1,@-r15
	mov	#((I_FLAG + T_FLAG) >> 8),r3
	swap.b	r12,r4
	and	r3,r4
	cmp/eq	r3,r4
	bf/s	1f
	mov.l	@r15+,r1
	mov.l	204f,r3
	jsr	@r3
	nop
1:	
	CPUSV
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	_GETR0
202:	.long	optbl1
203:	.long	_dmax86
204:	.long	i286h_trapint
	
	.align	2
optbl1:	.long		add_ea_r8			! 00
				.long		add_ea_r16
				.long		add_r8_ea
				.long		add_r16_ea
				.long		add_al_d8
				.long		add_ax_d16
				.long		push_es
				.long		pop_es
				.long		or_ea_r8
				.long		or_ea_r16
				.long		or_r8_ea
				.long		or_r16_ea
				.long		or_al_d8
				.long		or_ax_d16
				.long		push_cs
				.long		i286h_cts

				.long		adc_ea_r8			! 10
				.long		adc_ea_r16
				.long		adc_r8_ea
				.long		adc_r16_ea
				.long		adc_al_d8
				.long		adc_ax_d16
				.long		push_ss
				.long		pop_ss
				.long		sbb_ea_r8
				.long		sbb_ea_r16
				.long		sbb_r8_ea
				.long		sbb_r16_ea
				.long		sbb_al_d8
				.long		sbb_ax_d16
				.long		push_ds
				.long		pop_ds

				.long		and_ea_r8			! 20
				.long		and_ea_r16
				.long		and_r8_ea
				.long		and_r16_ea
				.long		and_al_d8
				.long		and_ax_d16
				.long		segprefix_es
				.long		daa
				.long		sub_ea_r8
				.long		sub_ea_r16
				.long		sub_r8_ea
				.long		sub_r16_ea
				.long		sub_al_d8
				.long		sub_ax_d16
				.long		segprefix_cs
				.long		das

				.long		xor_ea_r8			! 30
				.long		xor_ea_r16
				.long		xor_r8_ea
				.long		xor_r16_ea
				.long		xor_al_d8
				.long		xor_ax_d16
				.long		segprefix_ss
				.long		aaa
				.long		cmp_ea_r8
				.long		cmp_ea_r16
				.long		cmp_r8_ea
				.long		cmp_r16_ea
				.long		cmp_al_d8
				.long		cmp_ax_d16
				.long		segprefix_ds
				.long		aas

				.long		inc_ax				! 40
				.long		inc_cx
				.long		inc_dx
				.long		inc_bx
				.long		inc_sp
				.long		inc_bp
				.long		inc_si
				.long		inc_di
				.long		dec_ax
				.long		dec_cx
				.long		dec_dx
				.long		dec_bx
				.long		dec_sp
				.long		dec_bp
				.long		dec_si
				.long		dec_di

				.long		push_ax				! 50
				.long		push_cx
				.long		push_dx
				.long		push_bx
				.long		push_sp
				.long		push_bp
				.long		push_si
				.long		push_di
				.long		pop_ax
				.long		pop_cx
				.long		pop_dx
				.long		pop_bx
				.long		pop_sp
				.long		pop_bp
				.long		pop_si
				.long		pop_di

				.long		pusha				! 60
				.long		popa
				.long		bound
				.long		reserved			! arpl(reserved)
				.long		reserved
				.long		reserved
				.long		reserved
				.long		reserved
				.long			push_d16
				.long			imul_r_ea_d16
				.long			push_d8
				.long			imul_r_ea_d8
				.long			insb
				.long			insw
				.long		outsb
				.long		outsw

				.long		jo_short			! 70
				.long		jno_short
				.long		jc_short
				.long		jnc_short
				.long		jz_short
				.long		jnz_short
				.long		jna_short
				.long		ja_short
				.long		js_short
				.long		jns_short
				.long		jp_short
				.long		jnp_short
				.long		jl_short
				.long		jnl_short
				.long		jle_short
				.long		jnle_short

				.long		i286hop80			! 80
				.long		i286hop81
				.long		i286hop80
				.long		i286hop83
				.long		test_ea_r8
				.long		test_ea_r16
				.long		xchg_ea_r8
				.long		xchg_ea_r16
				.long		mov_ea_r8
				.long		mov_ea_r16
				.long		mov_r8_ea
				.long		mov_r16_ea
				.long		mov_ea_seg
				.long		lea_r16_ea
				.long		mov_seg_ea
				.long		pop_ea

				.long		nopandbios			! 90
				.long		xchg_ax_cx
				.long		xchg_ax_dx
				.long		xchg_ax_bx
				.long		xchg_ax_sp
				.long		xchg_ax_bp
				.long		xchg_ax_si
				.long		xchg_ax_di
				.long		cbw
				.long		cwd
				.long		call_far
				.long		wait
				.long		pushf
				.long		popf
				.long		sahf
				.long		lahf

				.long		mov_al_m8			! a0
				.long		mov_ax_m16
				.long		mov_m8_al
				.long		mov_m16_ax
				.long		movsb
				.long		movsw
				.long		cmpsb
				.long		cmpsw
				.long		test_al_d8
				.long		test_ax_d16
				.long		stosb
				.long		stosw
				.long		lodsb
				.long		lodsw
				.long		scasb
				.long		scasw

				.long		mov_al_imm			! b0
				.long		mov_cl_imm
				.long		mov_dl_imm
				.long		mov_bl_imm
				.long		mov_ah_imm
				.long		mov_ch_imm
				.long		mov_dh_imm
				.long		mov_bh_imm
				.long		mov_ax_imm
				.long		mov_cx_imm
				.long		mov_dx_imm
				.long		mov_bx_imm
				.long		mov_sp_imm
				.long		mov_bp_imm
				.long		mov_si_imm
				.long		mov_di_imm

				.long		i286hsft8_d8		! c0
				.long		i286hsft16_d8
				.long		ret_near_d16
				.long		ret_near
				.long		les_r16_ea
				.long		lds_r16_ea
				.long		mov_ea8_d8
				.long		mov_ea16_d16
				.long		enter
				.long		leave
				.long		ret_far_d16
				.long		ret_far
				.long		int_03
				.long		int_d8
				.long		into
				.long		iret

				.long		i286hsft8_1			! d0
				.long		i286hsft16_1
				.long		i286hsft8_cl
				.long		i286hsft16_cl
				.long		aam
				.long		aad
				.long		setalc
				.long		xlat
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc

				.long		loopnz				! e0
				.long		loopz
				.long		loop
				.long		jcxz
				.long		in_al_d8
				.long		in_ax_d8
				.long		out_d8_al
				.long		out_d8_ax
				.long		call_near
				.long		jmp_near
				.long		jmp_far
				.long		jmp_short
				.long		in_al_dx
				.long		in_ax_dx
				.long		out_dx_al
				.long		out_dx_ax

				.long		lock				! f0
				.long		lock
				.long		repne
				.long		repe
				.long		hlt
				.long		cmc
				.long		i286hopf6
				.long		i286hopf7
				.long		clc
				.long		stc
				.long		cli
				.long		sti
				.long		cld
				.long		std
				.long		i286hopfe
				.long		i286hopff


.macro SEGPREFIX	b
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r9
	mov	r12,r4
	mov.b	@(CPU_PREFIX,gbr),r0
	shlr16	r4
	add	r9,r4
	extu.b	r0,r10
	mov.l	@(\b,gbr),r0
	mov.l	r0,@(CPU_SS_FIX,gbr)
	tst	r10,r10
	bf/s	1f
	mov.l	r0,@(CPU_DS_FIX,gbr)
	mov.l	r13,@-r15
	mov.l	200f,r13
1:
	mov	#MAX_PREFIX,r3
	add	#1,r10
	cmp/hs	r3,r10
	bt	2000f
1:	
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	mov	r10,r0
	add	r3,r12
	jmp	@r5
	mov.b	r0,@(CPU_PREFIX,gbr)
2000:	
	bra	prefix_fault
	nop
	
	_GETR0
200:	.long	prefix1_remove
.endm

segprefix_es:	SEGPREFIX	CPU_ES_BASE
segprefix_cs:	SEGPREFIX	CPU_CS_BASE
segprefix_ss:	SEGPREFIX	CPU_SS_BASE
segprefix_ds:	SEGPREFIX	CPU_DS_BASE

prefix_fault:
	mov.l	201f,r3
	mov	#(MAX_PREFIX - 1),r0
	mov	#6,r10
	shll16	r0
	sub	r0,r12
	jsr	@r3
	sts	pr,r13
prefix1_remove:
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	r0,@(CPU_SS_FIX,gbr)
	mov.l	@(CPU_DS_BASE,gbr),r0
	mov.l	@r15+,r3
	mov.l	r0,@(CPU_DS_FIX,gbr)
	mov	#0,r0
	jmp	@r3
	mov.b	r0,@(CPU_PREFIX,gbr)

	.align	2
201:	.long	i286h_localint

! ---- repne

repne:
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r9
	mov.b	@(CPU_PREFIX,gbr),r0
	mov	r12,r4
	extu.b	r0,r10
	shlr16	r4
	tst	r10,r10
	mova	optblne,r0
	add	r9,r4
	bf/s	1f
	mov	r0,r8
	mov.l	r13,@-r15
	mov.l	201f,r13
1:
	mov	#MAX_PREFIX,r3
	add	#1,r10
	cmp/hs	r3,r10
	bt	prefix_fault
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	mov	r10,r0
	add	r3,r12
	jmp	@r5
	mov.b	r0,@(CPU_PREFIX,gbr)

	_GETR0
201:	.long	prefix1_remove
	
	.align	2
optblne:	.long		add_ea_r8			! 00
				.long		add_ea_r16
				.long		add_r8_ea
				.long		add_r16_ea
				.long		add_al_d8
				.long		add_ax_d16
				.long		push_es
				.long		pop_es
				.long		or_ea_r8
				.long		or_ea_r16
				.long		or_r8_ea
				.long		or_r16_ea
				.long		or_al_d8
				.long		or_ax_d16
				.long		push_cs
				.long		i286h_cts

				.long		adc_ea_r8			! 10
				.long		adc_ea_r16
				.long		adc_r8_ea
				.long		adc_r16_ea
				.long		adc_al_d8
				.long		adc_ax_d16
				.long		push_ss
				.long		pop_ss
				.long		sbb_ea_r8
				.long		sbb_ea_r16
				.long		sbb_r8_ea
				.long		sbb_r16_ea
				.long		sbb_al_d8
				.long		sbb_ax_d16
				.long		push_ds
				.long		pop_ds

				.long		and_ea_r8			! 20
				.long		and_ea_r16
				.long		and_r8_ea
				.long		and_r16_ea
				.long		and_al_d8
				.long		and_ax_d16
				.long		segprefix_es
				.long		daa
				.long		sub_ea_r8
				.long		sub_ea_r16
				.long		sub_r8_ea
				.long		sub_r16_ea
				.long		sub_al_d8
				.long		sub_ax_d16
				.long		segprefix_cs
				.long		das

				.long		xor_ea_r8			! 30
				.long		xor_ea_r16
				.long		xor_r8_ea
				.long		xor_r16_ea
				.long		xor_al_d8
				.long		xor_ax_d16
				.long		segprefix_ss
				.long		aaa
				.long		cmp_ea_r8
				.long		cmp_ea_r16
				.long		cmp_r8_ea
				.long		cmp_r16_ea
				.long		cmp_al_d8
				.long		cmp_ax_d16
				.long		segprefix_ds
				.long		aas

				.long		inc_ax				! 40
				.long		inc_cx
				.long		inc_dx
				.long		inc_bx
				.long		inc_sp
				.long		inc_bp
				.long		inc_si
				.long		inc_di
				.long		dec_ax
				.long		dec_cx
				.long		dec_dx
				.long		dec_bx
				.long		dec_sp
				.long		dec_bp
				.long		dec_si
				.long		dec_di

				.long		push_ax				! 50
				.long		push_cx
				.long		push_dx
				.long		push_bx
				.long		push_sp
				.long		push_bp
				.long		push_si
				.long		push_di
				.long		pop_ax
				.long		pop_cx
				.long		pop_dx
				.long		pop_bx
				.long		pop_sp
				.long		pop_bp
				.long		pop_si
				.long		pop_di

				.long		pusha				! 60
				.long		popa
				.long		bound
				.long		reserved			! arpl(reserved)
				.long		reserved
				.long		reserved
				.long		reserved
				.long		reserved
				.long		push_d16
				.long		imul_r_ea_d16
				.long		push_d8
				.long		imul_r_ea_d8
				.long		i286h_rep_insb
				.long		i286h_rep_insw
				.long		i286h_rep_outsb
				.long		i286h_rep_outsw

				.long		jo_short			! 70
				.long		jno_short
				.long		jc_short
				.long		jnc_short
				.long		jz_short
				.long		jnz_short
				.long		jna_short
				.long		ja_short
				.long		js_short
				.long		jns_short
				.long		jp_short
				.long		jnp_short
				.long		jl_short
				.long		jnl_short
				.long		jle_short
				.long		jnle_short

				.long		i286hop80			! 80
				.long		i286hop81
				.long		i286hop80
				.long		i286hop83
				.long		test_ea_r8
				.long		test_ea_r16
				.long		xchg_ea_r8
				.long		xchg_ea_r16
				.long		mov_ea_r8
				.long		mov_ea_r16
				.long		mov_r8_ea
				.long		mov_r16_ea
				.long		mov_ea_seg
				.long		lea_r16_ea
				.long		mov_seg_ea
				.long		pop_ea

				.long		nopandbios			! 90
				.long		xchg_ax_cx
				.long		xchg_ax_dx
				.long		xchg_ax_bx
				.long		xchg_ax_sp
				.long		xchg_ax_bp
				.long		xchg_ax_si
				.long		xchg_ax_di
				.long		cbw
				.long		cwd
				.long		call_far
				.long		wait
				.long		pushf
				.long		popf
				.long		sahf
				.long		lahf

				.long		mov_al_m8			! a0
				.long		mov_ax_m16
				.long		mov_m8_al
				.long		mov_m16_ax
				.long		i286h_rep_movsb
				.long		i286h_rep_movsw
				.long		i286h_repne_cmpsb
				.long		i286h_repne_cmpsw
				.long		test_al_d8
				.long		test_ax_d16
				.long		i286h_rep_stosb
				.long		i286h_rep_stosw
				.long		i286h_rep_lodsb
				.long		i286h_rep_lodsw
				.long		i286h_repne_scasb
				.long		i286h_repne_scasw

				.long		mov_al_imm			! b0
				.long		mov_cl_imm
				.long		mov_dl_imm
				.long		mov_bl_imm
				.long		mov_ah_imm
				.long		mov_ch_imm
				.long		mov_dh_imm
				.long		mov_bh_imm
				.long		mov_ax_imm
				.long		mov_cx_imm
				.long		mov_dx_imm
				.long		mov_bx_imm
				.long		mov_sp_imm
				.long		mov_bp_imm
				.long		mov_si_imm
				.long		mov_di_imm

				.long		i286hsft8_d8		! c0
				.long		i286hsft16_d8
				.long		ret_near_d16
				.long		ret_near
				.long		les_r16_ea
				.long		lds_r16_ea
				.long		mov_ea8_d8
				.long		mov_ea16_d16
				.long		enter
				.long		leave
				.long		ret_far_d16
				.long		ret_far
				.long		int_03
				.long		int_d8
				.long		into
				.long		iret

				.long		i286hsft8_1			! d0
				.long		i286hsft16_1
				.long		i286hsft8_cl
				.long		i286hsft16_cl
				.long		aam
				.long		aad
				.long		setalc
				.long		xlat
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc

				.long		loopnz				! e0
				.long		loopz
				.long		loop
				.long		jcxz
				.long		in_al_d8
				.long		in_ax_d8
				.long		out_d8_al
				.long		out_d8_ax
				.long		call_near
				.long		jmp_near
				.long		jmp_far
				.long		jmp_short
				.long		in_al_dx
				.long		in_ax_dx
				.long		out_dx_al
				.long		out_dx_ax

				.long		lock				! f0
				.long		lock
				.long		repne
				.long		repe
				.long		hlt
				.long		cmc
				.long		i286hopf6
				.long		i286hopf7
				.long		clc
				.long		stc
				.long		cli
				.long		sti
				.long		cld
				.long		std
				.long		i286hopfe
				.long		i286hopff

! ---- repe

repe:
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r9
	mov.b	@(CPU_PREFIX,gbr),r0
	mov	r12,r4
	extu.b	r0,r10
	shlr16	r4
	tst	r10,r10
	mova	optble,r0
	add	r9,r4
	bf/s	1f
	mov	r0,r8
	mov.l	r13,@-r15
	mov.l	201f,r13
1:
	mov	#MAX_PREFIX,r3
	add	#1,r10
	cmp/hs	r3,r10
	bt	2000f
1:	
	GETR0
	shll2	r0
	mov	#((1 << 16) >> 16),r3
	mov.l	@(r0,r8),r5
	shll16	r3
	mov	r10,r0
	add	r3,r12
	jmp	@r5
	mov.b	r0,@(CPU_PREFIX,gbr)
2000:
	bra	prefix_fault
	nop

	_GETR0
201:	.long	prefix2_remove
	
prefix2_remove:
	mov.l	@(CPU_SS_BASE,gbr),r0
	mov.l	r0,@(CPU_SS_FIX,gbr)
	mov.l	@(CPU_DS_BASE,gbr),r0
	mov.l	@r15+,r3
	mov.l	r0,@(CPU_DS_FIX,gbr)
	mov	#0,r0
	jmp	@r3
	mov.b	r0,@(CPU_PREFIX,gbr)

	.align	2
optble:	.long		add_ea_r8			! 00
				.long		add_ea_r16
				.long		add_r8_ea
				.long		add_r16_ea
				.long		add_al_d8
				.long		add_ax_d16
				.long		push_es
				.long		pop_es
				.long		or_ea_r8
				.long		or_ea_r16
				.long		or_r8_ea
				.long		or_r16_ea
				.long		or_al_d8
				.long		or_ax_d16
				.long		push_cs
				.long		i286h_cts

				.long		adc_ea_r8			! 10
				.long		adc_ea_r16
				.long		adc_r8_ea
				.long		adc_r16_ea
				.long		adc_al_d8
				.long		adc_ax_d16
				.long		push_ss
				.long		pop_ss
				.long		sbb_ea_r8
				.long		sbb_ea_r16
				.long		sbb_r8_ea
				.long		sbb_r16_ea
				.long		sbb_al_d8
				.long		sbb_ax_d16
				.long		push_ds
				.long		pop_ds

				.long		and_ea_r8			! 20
				.long		and_ea_r16
				.long		and_r8_ea
				.long		and_r16_ea
				.long		and_al_d8
				.long		and_ax_d16
				.long		segprefix_es
				.long		daa
				.long		sub_ea_r8
				.long		sub_ea_r16
				.long		sub_r8_ea
				.long		sub_r16_ea
				.long		sub_al_d8
				.long		sub_ax_d16
				.long		segprefix_cs
				.long		das

				.long		xor_ea_r8			! 30
				.long		xor_ea_r16
				.long		xor_r8_ea
				.long		xor_r16_ea
				.long		xor_al_d8
				.long		xor_ax_d16
				.long		segprefix_ss
				.long		aaa
				.long		cmp_ea_r8
				.long		cmp_ea_r16
				.long		cmp_r8_ea
				.long		cmp_r16_ea
				.long		cmp_al_d8
				.long		cmp_ax_d16
				.long		segprefix_ds
				.long		aas

				.long		inc_ax				! 40
				.long		inc_cx
				.long		inc_dx
				.long		inc_bx
				.long		inc_sp
				.long		inc_bp
				.long		inc_si
				.long		inc_di
				.long		dec_ax
				.long		dec_cx
				.long		dec_dx
				.long		dec_bx
				.long		dec_sp
				.long		dec_bp
				.long		dec_si
				.long		dec_di

				.long		push_ax				! 50
				.long		push_cx
				.long		push_dx
				.long		push_bx
				.long		push_sp
				.long		push_bp
				.long		push_si
				.long		push_di
				.long		pop_ax
				.long		pop_cx
				.long		pop_dx
				.long		pop_bx
				.long		pop_sp
				.long		pop_bp
				.long		pop_si
				.long		pop_di

				.long		pusha				! 60
				.long		popa
				.long		bound
				.long		reserved			! arpl(reserved)
				.long		reserved
				.long		reserved
				.long		reserved
				.long		reserved
				.long		push_d16
				.long		imul_r_ea_d16
				.long		push_d8
				.long		imul_r_ea_d8
				.long		i286h_rep_insb
				.long		i286h_rep_insw
				.long		i286h_rep_outsb
				.long		i286h_rep_outsw

				.long		jo_short			! 70
				.long		jno_short
				.long		jc_short
				.long		jnc_short
				.long		jz_short
				.long		jnz_short
				.long		jna_short
				.long		ja_short
				.long		js_short
				.long		jns_short
				.long		jp_short
				.long		jnp_short
				.long		jl_short
				.long		jnl_short
				.long		jle_short
				.long		jnle_short

				.long		i286hop80			! 80
				.long		i286hop81
				.long		i286hop80
				.long		i286hop83
				.long		test_ea_r8
				.long		test_ea_r16
				.long		xchg_ea_r8
				.long		xchg_ea_r16
				.long		mov_ea_r8
				.long		mov_ea_r16
				.long		mov_r8_ea
				.long		mov_r16_ea
				.long		mov_ea_seg
				.long		lea_r16_ea
				.long		mov_seg_ea
				.long		pop_ea

				.long		nopandbios			! 90
				.long		xchg_ax_cx
				.long		xchg_ax_dx
				.long		xchg_ax_bx
				.long		xchg_ax_sp
				.long		xchg_ax_bp
				.long		xchg_ax_si
				.long		xchg_ax_di
				.long		cbw
				.long		cwd
				.long		call_far
				.long		wait
				.long		pushf
				.long		popf
				.long		sahf
				.long		lahf

				.long		mov_al_m8			! a0
				.long		mov_ax_m16
				.long		mov_m8_al
				.long		mov_m16_ax
				.long		i286h_rep_movsb
				.long		i286h_rep_movsw
				.long		i286h_repe_cmpsb
				.long		i286h_repe_cmpsw
				.long		test_al_d8
				.long		test_ax_d16
				.long		i286h_rep_stosb
				.long		i286h_rep_stosw
				.long		i286h_rep_lodsb
				.long		i286h_rep_lodsw
				.long		i286h_repe_scasb
				.long		i286h_repe_scasw

				.long		mov_al_imm			! b0
				.long		mov_cl_imm
				.long		mov_dl_imm
				.long		mov_bl_imm
				.long		mov_ah_imm
				.long		mov_ch_imm
				.long		mov_dh_imm
				.long		mov_bh_imm
				.long		mov_ax_imm
				.long		mov_cx_imm
				.long		mov_dx_imm
				.long		mov_bx_imm
				.long		mov_sp_imm
				.long		mov_bp_imm
				.long		mov_si_imm
				.long		mov_di_imm

				.long		i286hsft8_d8		! c0
				.long		i286hsft16_d8
				.long		ret_near_d16
				.long		ret_near
				.long		les_r16_ea
				.long		lds_r16_ea
				.long		mov_ea8_d8
				.long		mov_ea16_d16
				.long		enter
				.long		leave
				.long		ret_far_d16
				.long		ret_far
				.long		int_03
				.long		int_d8
				.long		into
				.long		iret

				.long		i286hsft8_1			! d0
				.long		i286hsft16_1
				.long		i286hsft8_cl
				.long		i286hsft16_cl
				.long		aam
				.long		aad
				.long		setalc
				.long		xlat
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc
				.long		esc

				.long		loopnz				! e0
				.long		loopz
				.long		loop
				.long		jcxz
				.long		in_al_d8
				.long		in_ax_d8
				.long		out_d8_al
				.long		out_d8_ax
				.long		call_near
				.long		jmp_near
				.long		jmp_far
				.long		jmp_short
				.long		in_al_dx
				.long		in_ax_dx
				.long		out_dx_al
				.long		out_dx_ax

				.long		lock				! f0
				.long		lock
				.long		repne
				.long		repe
				.long		hlt
				.long		cmc
				.long		i286hopf6
				.long		i286hopf7
				.long		clc
				.long		stc
				.long		cli
				.long		sti
				.long		cld
				.long		std
				.long		i286hopfe
				.long		i286hopff

	.end
