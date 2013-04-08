
! r4 - tmp
! r7 - clock
! r8 - IP/flag
! r9 - i286core/mem
! r10 - iflag
! r11 - ret


	.include "../i286hdc/i286h.inc"
	.extern	i286h_memoryread
	.extern	i286h_memoryread_w
!!	.extern	ea_assert

	.extern _i286hcore

	.globl	i286h_selector
	.globl	i286h_ea
	.globl	i286h_lea
	.globl	i286h_a

	.text
	.align	2

i286h_selector:
	mov.l	r8,@-r15
	mov	r4,r0
	mov.l	r9,@-r15
	tst	#4,r0
	bf/s	1f
	sts.l	pr,@-r15
	mov.w	@((CPU_GDTR + 2),gbr),r0
	extu.w	r0,r5
	mov.b	@((CPU_GDTR + 2) + 2,gbr),r0
	bra	2f
	extu.b	r0,r6
1:
	mov.w	@((CPU_LDTRC + 2),gbr),r0
	extu.w	r0,r5
	mov.b	@((CPU_LDTRC + 2) + 2,gbr),r0
	extu.b	r0,r6
2:
	mov	#~(7),r8
	shll16	r6
	and	r4,r8
	mov.l	10001f,r3
	add	r5,r8
	add	r6,r8
	mov	r8,r4
	jsr	@r3
	add	#2,r4
	mov	r0,r9
	mov.l	10000f,r3
	mov	r8,r4
	jsr	@r3
	add	#4,r4
	shll16	r0
	add	r9,r0
	lds.l	@r15+,pr
	mov.l	@r15+,r9
	rts
	mov.l	@r15+,r8

	.align	2
10001:	.long	i286h_memoryread_w
10000:	.long	i286h_memoryread


! ---- calc_ea_dst

.macro EAR1	r, b
	mov.w	@(\r,gbr),r0
	extu.w	r0,r5
	mov.l	@(\b,gbr),r0
	rts
	add	r5,r0
.endm

.macro EAR1D8	r, b
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r4
	mov.l	10000f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r7
	mov.w	@(\r,gbr),r0
	mov	#24,r3
	extu.w	r0,r5
	mov.l	@(\b,gbr),r0
	mov	r5,r2
	shld	r3,r7
	shll16	r2
	mov	#-8,r3
	mov	r7,r5
	shad	r3,r5
	add	r2,r5
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r3,r12
	shlr16	r5
	jmp	@r8
	add	r5,r0

	.align	2
10000:	.long	i286h_memoryread
.endm

.macro	EAR1D16	r, b
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r4
	mov.l	10001f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r7
	mov.w	@(\r,gbr),r0
	mov	#((2 << 16) >> 16),r3
	extu.w	r0,r5
	shll16	r3
	mov.l	@(\b,gbr),r0
	add	r5,r7
	add	r3,r12
	swap.w	r7,r7
	mov	#~((1 << 16) >> 16),r5
	and	r7,r5
	swap.w	r5,r5
	jmp	@r8
	add	r5,r0

	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro EAR2	r1, r2, b
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	mov.l	@(\b,gbr),r0
	add	r5,r6
	swap.w	r6,r2
	mov	#~((1 << 16) >> 16),r5
	and	r5,r2
	swap.w	r2,r2
	rts
	add	r2,r0
.endm

.macro	EAR2D8	r1, r2, b
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r4
	mov.l	10000f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r2
	mov.w	@(\r1,gbr),r0
	mov	#24,r3
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	shld	r3,r2
	mov.l	@(\b,gbr),r0
	mov	#-8,r3
	shll16	r5
	shad	r3,r2
	add	r5,r2
	shll16	r6
	mov	#((1 << 16) >> 16),r3
	shll16	r3
	add	r6,r2
	add	r3,r12
	shlr16	r2
	jmp	@r8
	add	r2,r0

	.align	2
10000:	.long	i286h_memoryread
.endm

.macro EAR2D16	r1, r2, b
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r4
	mov.l	10001f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r2
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	mov.l	@(\b,gbr),r0
	mov	#((2 << 16) >> 16),r3
	add	r5,r2
	shll16	r3
	add	r6,r2
	add	r3,r12
	swap.w	r2,r2
	mov	#~((3 << 16) >> 16),r7
	and	r2,r7
	swap.w	r7,r7
	jmp	@r8
	add	r7,r0

	.align	2
10001:	.long	i286h_memoryread_w
.endm


i286h_ea:
	mov	#(0x18 << 3),r5
	and	r4,r5
	mov	#7,r6
	and	r4,r6
	shlr	r5
	mova	00f,r0
	shll2	r6
	add	r5,r0
	add	r6,r0
	jmp	@r0
	nop

	.align	2
00:	
	bra		ea_bx_si
	nop
	bra		ea_bx_di
	nop
	bra		ea_bp_si
	nop
	bra		ea_bp_di
	nop
	bra		ea_si
	nop
	bra		ea_di
	nop
	bra		ea_d16
	nop
	bra		ea_bx
	nop

	bra		ea_bx_si_d8
	nop
	bra		ea_bx_di_d8
	nop
	bra		ea_bp_si_d8
	nop
	bra		ea_bp_di_d8
	nop
	bra		ea_si_d8
	nop
	bra		ea_di_d8
	nop
	bra		ea_bp_d8
	nop
	bra		ea_bx_d8
	nop

	bra		ea_bx_si_d16
	nop
	bra		ea_bx_di_d16
	nop
	bra		ea_bp_si_d16
	nop
	bra		ea_bp_di_d16
	nop
	bra		ea_si_d16
	nop
	bra		ea_di_d16
	nop
	bra		ea_bp_d16
	nop
	bra		ea_bx_d16
	nop
	

ea_bx_si:	EAR2	CPU_BX, CPU_SI, CPU_DS_FIX
ea_bx_si_d8:	EAR2D8	CPU_BX, CPU_SI, CPU_DS_FIX
ea_bx_si_d16:	EAR2D16	CPU_BX, CPU_SI, CPU_DS_FIX
ea_bx_di:	EAR2	CPU_BX, CPU_DI, CPU_DS_FIX
ea_bx_di_d8:	EAR2D8	CPU_BX, CPU_DI, CPU_DS_FIX
ea_bx_di_d16:	EAR2D16	CPU_BX, CPU_DI, CPU_DS_FIX
ea_bp_si:	EAR2	CPU_BP, CPU_SI, CPU_SS_FIX
ea_bp_si_d8:	EAR2D8	CPU_BP, CPU_SI, CPU_SS_FIX
ea_bp_si_d16:	EAR2D16	CPU_BP, CPU_SI, CPU_SS_FIX
ea_bp_di:	EAR2	CPU_BP, CPU_DI, CPU_SS_FIX
ea_bp_di_d8:	EAR2D8	CPU_BP, CPU_DI, CPU_SS_FIX
ea_bp_di_d16:	EAR2D16	CPU_BP, CPU_DI, CPU_SS_FIX
ea_si:	EAR1	CPU_SI,	CPU_DS_FIX
ea_si_d8:	EAR1D8	CPU_SI, CPU_DS_FIX
ea_si_d16:	EAR1D16	CPU_SI, CPU_DS_FIX
ea_di:	EAR1	CPU_DI, CPU_DS_FIX
ea_di_d8:	EAR1D8	CPU_DI, CPU_DS_FIX
ea_di_d16:	EAR1D16	CPU_DI, CPU_DS_FIX
ea_bx:	EAR1	CPU_BX, CPU_DS_FIX
ea_bx_d8:	EAR1D8	CPU_BX, CPU_DS_FIX
ea_bx_d16:	EAR1D16	CPU_BX, CPU_DS_FIX
ea_bp_d8:	EAR1D8	CPU_BP, CPU_SS_FIX
ea_bp_d16:	EAR1D16	CPU_BP, CPU_SS_FIX

ea_d16:
!!	mov.l	@(CPU_CS_BASE,gbr),r0
!!	mov	r0,r4
	mov.l	10001f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	#((2 << 16) >> 16),r3
	mov	r0,r4
	shll16	r3
	mov.l	@(CPU_DS_FIX,gbr),r0
	add	r3,r12
	jmp	@r8
	add	r4,r0
	
	.align	2
10001:	.long	i286h_memoryread_w

! ---- calc_lea

.macro	LER1	r
	mov.w	@(\r,gbr),r0
	rts
	extu.w	r0,r0
.endm

.macro LER1D8	r
	mov.l	10000f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov	#((1 << 16) >> 16),r3
	mov.w	@(\r,gbr),r0
	shll16	r3
	extu.w	r0,r5
	mov	r4,r0
	tst	#0x80,r0
	bt/s	1f
	add	r3,r12
	swap.b	r4,r0
	or	#0xff,r0
	swap.b	r0,r0
1:
	add	r5,r0
	mov	#~((1 << 16) >> 16),r3
	swap.w	r0,r0
	and	r0,r3
	jmp	@r8
	swap.w	r3,r0

	.align	2
10000:	.long	i286h_memoryread
.endm

.macro	LER1D16	r
	mov.l	10001f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov	#((2 << 16) >> 16),r3
	mov.w	@(\r,gbr),r0
	shll16	r3
	extu.w	r0,r0
	add	r3,r12
	add	r4,r0
	swap.w	r0,r0
	mov	#~((1 << 16) >> 16),r7
	and	r0,r7
	jmp	@r8
	swap.w	r7,r0

	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro	LER2	r1, r2
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	mov	#~((1 << 16) >> 16),r3
	extu.w	r0,r4
	add	r5,r4
	swap.w	r4,r4
	and	r3,r4
	rts
	swap.w	r4,r0
.endm

.macro	LER2D8	r1, r2
	mov.l	10000f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	mov	r4,r0
	tst	#0x80,r0
	bt	1f
	swap.b	r0,r0
	or	#0xff,r0
	swap.b	r0,r0
1:
	add	r5,r0
	mov	#((1 << 16) >> 16),r4
	add	r6,r0
	shll16	r4
	swap.w	r0,r0
	mov	#~((3 << 16) >> 16),r3
	and	r3,r0
	swap.w	r0,r0
	jmp	@r8
	add	r4,r12

	.align	2
10000:	.long	i286h_memoryread
.endm

.macro	LER2D16	r1, r2
	mov.l	10001f,r3
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r9,r4
	mov	r0,r4
	mov	#((2 << 16) >> 16),r3
	mov.w	@(\r1,gbr),r0
	shll16	r3
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	add	r3,r12
	extu.w	r0,r6
	add	r5,r4
	add	r6,r4
	swap.w	r4,r0
	mov	#~((3 << 16) >> 16),r3
	and	r3,r0
	jmp	@r8
	swap.w	r0,r0
	
	.align	2
10001:	.long	i286h_memoryread_w
.endm


i286h_lea:
	mov	#(0x18 << 3),r5
	and	r4,r5
	mov	#7,r6
	and	r4,r6
	shlr	r5
	mova	00f,r0
	shll2	r6
	add	r5,r0
	add	r6,r0
	jmp	@r0
	nop

	.align	2
00:
	bra		lea_bx_si
	nop
	bra		lea_bx_di
	nop
	bra		lea_bp_si
	nop
	bra		lea_bp_di
	nop
	bra		lea_si
	nop
	bra		lea_di
	nop
	bra		lea_d16
	nop
	bra		lea_bx
	nop

	bra		lea_bx_si_d8
	nop
	bra		lea_bx_di_d8
	nop
	bra		lea_bp_si_d8
	nop
	bra		lea_bp_di_d8
	nop
	bra		lea_si_d8
	nop
	bra		lea_di_d8
	nop
	bra		lea_bp_d8
	nop
	bra		lea_bx_d8
	nop

	bra		lea_bx_si_d16
	nop
	bra		lea_bx_di_d16
	nop
	bra		lea_bp_si_d16
	nop
	bra		lea_bp_di_d16
	nop
	bra		lea_si_d16
	nop
	bra		lea_di_d16
	nop
	bra		lea_bp_d16
	nop
	bra		lea_bx_d16
	nop

lea_bx_si:	LER2	CPU_BX, CPU_SI
lea_bx_si_d8:	LER2D8	CPU_BX, CPU_SI
lea_bx_si_d16:	LER2D16	CPU_BX, CPU_SI
lea_bx_di:	LER2	CPU_BX, CPU_DI
lea_bx_di_d8:	LER2D8	CPU_BX, CPU_DI
lea_bx_di_d16:	LER2D16	CPU_BX, CPU_DI
lea_bp_si:	LER2	CPU_BP, CPU_SI
lea_bp_si_d8:	LER2D8	CPU_BP, CPU_SI
lea_bp_si_d16:	LER2D16	CPU_BP, CPU_SI
lea_bp_di:	LER2	CPU_BP, CPU_DI
lea_bp_di_d8:	LER2D8	CPU_BP, CPU_DI
lea_bp_di_d16:	LER2D16	CPU_BP, CPU_DI
lea_si:	LER1	CPU_SI
lea_si_d8:	LER1D8	CPU_SI
lea_si_d16:	LER1D16	CPU_SI
lea_di:	LER1	CPU_DI
lea_di_d8:	LER1D8	CPU_DI
lea_di_d16:	LER1D16	CPU_DI
lea_bx:	LER1	CPU_BX
lea_bx_d8:	LER1D8	CPU_BX
lea_bx_d16:	LER1D16	CPU_BX
lea_bp_d8:	LER1D8	CPU_BP
lea_bp_d16:	LER1D16	CPU_BP

lea_d16:
	mov	#((2 << 16) >> 16),r0
	mov	r12,r4
	shll16	r0
	mov.l	10001f,r3
	shlr16	r4
	add	r9,r4
	jmp	@r3
	add	r0,r12

	.align	2
10001:	.long	i286h_memoryread_w

! ---- calc_a

.macro AR1	r, b
	mov.l	@(\b,gbr),r0
	mov	r0,r10
	mov.w	@(\r,gbr),r0
	rts
	extu.w	r0,r0
.endm

.macro AR1D8	r, b
	mov.l	10000f,r3
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	mov.w	@(\r,gbr),r0
	mov	#((1 << 16) >> 16),r3
	extu.w	r0,r5
	mov.l	@(\b,gbr),r0
	shll16	r3
	mov	r0,r10
	mov	r4,r0
	tst	#0x80,r0
	bt/s	1f
	add	r3,r12
	swap.b	r0,r0
	or	#0xff,r0
	swap.b	r0,r0
1:
	add	r5,r0
	swap.w	r0,r0
	mov	#~((1 << 16) >> 16),r3
	and	r3,r0
	jmp	@r8
	swap.w	r0,r0
	
	.align	2
10000:	.long	i286h_memoryread	
.endm

.macro	AR1D16	r, b
	mov.l	10001f,r3
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	mov.w	@(\r,gbr),r0
	mov	#((2 << 16) >> 16),r3
	extu.w	r0,r5
	mov.l	@(\b,gbr),r0
	shll16	r3
	mov	r0,r10
	add	r3,r12
	add	r5,r4
	swap.w	r4,r0
	mov	#~((1 << 16) >> 16),r3
	and	r3,r0
	jmp	@r8
	swap.w	r0,r0

	.align	2
10001:	.long	i286h_memoryread_w
.endm

.macro	AR2	r1, r2, b
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	mov.l	@(\b,gbr),r0
	mov	r0,r10
	add	r6,r5
	swap.w	r5,r0
	mov	#~((1 << 16) >> 16),r3
	and	r3,r0
	rts
	swap.w	r0,r0
.endm

.macro	AR2D8	r1, r2, b
	mov.l	10000f,r3
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	mov.w	@(\r1,gbr),r0
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	extu.w	r0,r6
	mov.l	@(\b,gbr),r0
	mov	r0,r10
	mov	r4,r0
	tst	#0x80,r0
	bt	1f
	swap.b	r0,r0
	or	#0xff,r0
	swap.b	r0,r0
1:
	mov	#((1 << 16) >> 16),r3
	add	r5,r0
	shll16	r3
	add	r6,r0
	add	r3,r12
	mov	#~((3 << 16) >> 16),r4
	swap.w	r0,r0
	and	r4,r0
	jmp	@r8
	swap.w	r0,r0
	
	.align	2
10000:	.long	i286h_memoryread
.endm

.macro AR2D16	r1, r2, b
	mov.l	10001f,r3
	mov.l	@(CPU_CS_BASE,gbr),r0
	mov	r12,r4
	sts	pr,r8
	shlr16	r4
	jsr	@r3
	add	r0,r4
	mov	r0,r4
	mov.w	@(\r1,gbr),r0
	mov	#((2 << 16) >> 16),r3
	extu.w	r0,r5
	mov.w	@(\r2,gbr),r0
	shll16	r3
	extu.w	r0,r6
	mov.l	@(\b,gbr),r0
	add	r3,r12
	mov	r0,r10
	add	r5,r4
	add	r6,r4
	swap.w	r4,r0
	mov	#~((3 << 16) >> 16),r3
	and	r3,r0
	jmp	@r8
	swap.w	r0,r0

	.align	2
10001:	.long	i286h_memoryread_w
.endm


i286h_a:
	mov	#(0x18 << 3),r5
	and	r4,r5
	mov	#7,r6
	and	r4,r6
	shlr	r5
	mova	00f,r0
	shll2	r6
	add	r5,r0
	add	r6,r0
	jmp	@r0
	nop

	.align	2
00:	
	bra		a_bx_si
	nop
	bra		a_bx_di
	nop
	bra		a_bp_si
	nop
	bra		a_bp_di
	nop
	bra		a_si
	nop
	bra		a_di
	nop
	bra		a_d16
	nop
	bra		a_bx
	nop

	bra		a_bx_si_d8
	nop
	bra		a_bx_di_d8
	nop
	bra		a_bp_si_d8
	nop
	bra		a_bp_di_d8
	nop
	bra		a_si_d8
	nop
	bra		a_di_d8
	nop
	bra		a_bp_d8
	nop
	bra		a_bx_d8
	nop

	bra		a_bx_si_d16
	nop
	bra		a_bx_di_d16
	nop
	bra		a_bp_si_d16
	nop
	bra		a_bp_di_d16
	nop
	bra		a_si_d16
	nop
	bra		a_di_d16
	nop
	bra		a_bp_d16
	nop
	bra		a_bx_d16
	nop

a_bx_si:	AR2		CPU_BX, CPU_SI, CPU_DS_FIX
a_bx_si_d8:	AR2D8	CPU_BX, CPU_SI, CPU_DS_FIX
a_bx_si_d16:	AR2D16	CPU_BX, CPU_SI, CPU_DS_FIX
a_bx_di:	AR2		CPU_BX, CPU_DI, CPU_DS_FIX
a_bx_di_d8:	AR2D8	CPU_BX, CPU_DI, CPU_DS_FIX
a_bx_di_d16:	AR2D16	CPU_BX, CPU_DI, CPU_DS_FIX
a_bp_si:	AR2		CPU_BP, CPU_SI, CPU_SS_FIX
a_bp_si_d8:	AR2D8	CPU_BP, CPU_SI, CPU_SS_FIX
a_bp_si_d16:	AR2D16	CPU_BP, CPU_SI, CPU_SS_FIX
a_bp_di:	AR2		CPU_BP, CPU_DI, CPU_SS_FIX
a_bp_di_d8:	AR2D8	CPU_BP, CPU_DI, CPU_SS_FIX
a_bp_di_d16:	AR2D16	CPU_BP, CPU_DI, CPU_SS_FIX
a_si:	AR1		CPU_SI, CPU_DS_FIX
a_si_d8:	AR1D8	CPU_SI, CPU_DS_FIX
a_si_d16:	AR1D16	CPU_SI, CPU_DS_FIX
a_di:	AR1		CPU_DI, CPU_DS_FIX
a_di_d8:	AR1D8	CPU_DI, CPU_DS_FIX
a_di_d16:	AR1D16	CPU_DI, CPU_DS_FIX
a_bx:	AR1		CPU_BX, CPU_DS_FIX
a_bx_d8:	AR1D8	CPU_BX, CPU_DS_FIX
a_bx_d16:	AR1D16	CPU_BX, CPU_DS_FIX
a_bp_d8:	AR1D8	CPU_BP, CPU_SS_FIX
a_bp_d16:	AR1D16	CPU_BP, CPU_SS_FIX

a_d16:
	mov	r12,r4
	mov.l	@(CPU_CS_BASE,gbr),r0
	shlr16	r4
	add	r0,r4
	mov.l	@(CPU_DS_FIX,gbr),r0
	mov.l	10001f,r3
	mov	r0,r10
	mov	#((2 << 16) >> 16),r0
	shll16	r0
	jmp	@r3
	add	r0,r12
	
	.align	2
10001:	.long	i286h_memoryread_w

	.end
