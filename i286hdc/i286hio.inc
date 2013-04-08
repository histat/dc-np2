
! ---- cgwindow

	.extern	_cgwindow

CGW_LOW				=		0
CGW_HIGH			=		4
CGW_WRITABLE		=		8


! ---- dmac

	.extern	_dmac

! DMACH_adrs		=		0
! DMACH_leng		=		4
! DMACH_adrsorg		=		6
! DMACH_lengorg		=		8
! DMACH_action		=		10
! DMACH_outproc		=		12
! DMACH_inproc		=		16
! DMACH_extproc		=		20
! DMACH_mode		=		24
! DMACH_sreq		=		25
! DMACH_ready		=		26
! DMACH_mask		=		27
DMACH_SIZE			=		28

! dmac_dmach		=		0
! dmac_lh			=		(DMACH_SIZE * 4) + 0
! dmac_work			=		(DMACH_SIZE * 4) + 4
DMAC_WORKING		=		(DMACH_SIZE * 4) + 5
! dmac_mask			=		(DMACH_SIZE * 4) + 6
! dmac_stat			=		(DMACH_SIZE * 4) + 7
! dmac_devices		=		(DMACH_SIZE * 4) + 8
! dmac_device		=		(DMACH_SIZE * 4) + 12


! ---- egc

	.extern	_egc

! egc_access		=		0
! egc_fgbg			=		2
! egc_ope			=		4
! egc_fg			=		6
! egc_mask			=		8
! egc_bg			=		10
EGC_SFT				=		12
! egc_leng			=		14
! egc_lastvram		=		16
! egc_patreg		=		24
! egc_fgc			=		32
! egc_bgc			=		40
!							and more..


! ---- gdc

	.extern	_gdcs

! gdcs_access		=		0
! gdcs_disp			=		1
GDCS_TEXTDISP		=		2
GDCS_MSWACC			=		3
GDCS_GRPHDISP		=		4
! gdcs_palchange	=		5
! gdcs_mode2		=		6


! ---- grcg

	.extern	_grcg

! grcg_counter		=		0
! grcg_mode			=		4
GRCG_MODEREG		=		6
GRCG_TILE			=		8
! grcg_gdcwithgrcg	=		16
! grcg_chip			=		20


! ---- pic

	.extern	_pic

! PI_icw			=		0
PI_IMR				=		4
! PI_isr			=		5
! PI_irr			=		6
! PI_ocw3			=		7
! PI_pry			=		8
! PI_writeicw		=		9
! PI_padding		=		10
PI_SIZE				=		12

PIC_MASTER			=		0
PIC_SLAVE			=		PI_SIZE

.macro NOINTREXIT
	swap.b	r12,r0
	tst	#(I_FLAG >> 8),r0
	bf/s	1010f
	mov	#24,r3
	jmp	@r13
	nop
1010:
	mov.l	@((PIC_MASTER + PI_IMR),r4),r6
	mov	#0xff,r2
	mov.l	@((PIC_SLAVE + PI_IMR),r4),r7
	mov	r6,r4
	shld	r3,r2
	shld	r3,r4
	shll8	r6
	xor	r2,r4
	tst	r6,r4
	bf	1011f
	mov	r7,r4
	shld	r3,r4
	xor	r2,r4
	shll8	r7
	tst	r7,r4
	bf	1011f
	jmp	@r13
	nop
1011:	
.endm

.macro PICEXISTINTR
	mov.l	@((PIC_MASTER + PI_IMR),r4),r6
	mov.l	@((PIC_SLAVE + PI_IMR),r4),r7
	mov	#24,r3
	mov	#0xff,r2
	shld	r3,r2
	mov	r6,r4
	shld	r3,r4
	xor	r2,r4
	shll8	r6
	tst	r6,r4
	bf	1012f
	mov	r7,r4
	shld	r3,r4
	xor	r2,r4
	shll8	r7
	tst	r7,r4
1012:	
.endm
