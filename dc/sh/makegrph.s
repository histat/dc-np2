
VRAM_STEP			=		0x100000
VRAM_B				=		0x0a8000
VRAM_R				=		0x0b0000
VRAM_G				=		0x0b8000
VRAM_E				=		0x0e0000

SURFACE_WIDTH		=		640
SURFACE_HEIGHT		=		480
SURFACE_SIZE		=		(SURFACE_WIDTH * SURFACE_HEIGHT)

NC_UPD72020			=		0x00
! NC_DISPSYNC		=		0x01
! NC_RASTER			=		0x02
! NC_realpal		=		0x03
! NC_LCD_MODE		=		0x04
! NC_skipline		=		0x05
! NC_skiplight		=		0x06
				! and more...

! DS_text_vbp		=		0x00
! DS_textymax		=		0x04
DS_GRPH_VBP			=		0x08
DS_GRPHYMAX			=		0x0c
! DS_scrnxpos		=		0x10
! DS_scrnxmax		=		0x14
! DS_scrnxextend	=		0x18
! DS_scrnymax		=		0x1c
! DS_textvad		=		0x20
DS_GRPHVAD			=		0x24

GDCCMD_MAX			=		32

! GDC_SYNC			=		0
! GDC_ZOOM			=		8
GDC_CSRFORM			=		9
GDC_SCROLL			=		12
! GDC_TEXTW			=		20
GDC_PITCH			=		28
! GDC_LPEN			=		29
! GDC_VECTW			=		32
! GDC_CSRW			=		43
! GDC_MASK			=		46
! GDC_CSRR			=		48
! GDC_WRITE			=		53
! GDC_CODE			=		54
! GDC_TERMDATA		=		56

GD_PARA				=		0x000
! GD_fifo			=		0x100
! GD_cnt			=		(0x100 + (GDCCMD_MAX * 2))
! GD_ptr			=		(0x102 + (GDCCMD_MAX * 2))
! GD_rcv			=		(0x103 + (GDCCMD_MAX * 2))
! GD_snd			=		(0x104 + (GDCCMD_MAX * 2))
! GD_cmd			=		(0x105 + (GDCCMD_MAX * 2))
! GD_paracb			=		(0x106 + (GDCCMD_MAX * 2))
! GD_reserved		=		(0x107 + (GDCCMD_MAX * 2))
GD_SIZE				=		(0x108 + (GDCCMD_MAX * 2))

G_MASTER			=		(GD_SIZE * -1)
G_SLAVE				=		0
G_MODE1				=		(GD_SIZE + 0x00)
! G_mode2			=		(GD_SIZE + 0x01)
G_CLOCK				=		(GD_SIZE + 0x02)
! G_crt15khz		=		(GD_SIZE + 0x03)
! G_m_drawing		=		(GD_SIZE + 0x04)
! G_s_drawing		=		(GD_SIZE + 0x05)
! G_vsync			=		(GD_SIZE + 0x06)
! G_vsyncint		=		(GD_SIZE + 0x07)
! G_display			=		(GD_SIZE + 0x08)
! G_bitac			=		(GD_SIZE + 0x09)
! G_analog			=		(GD_SIZE + 0x0c)
! G_palnum			=		(GD_SIZE + 0x10)
! G_degpal			=		(GD_SIZE + 0x14)
! G_anapal			=		(GD_SIZE + 0x18)


	.include "../i286hdc/i286h.inc"

	.extern	_np2cfg
	.extern	_i286hcore
	.extern	_np2_vram
	.extern	_dsync
	.extern	_vramupdate
	.extern	_renewal_line
	.extern	_gdc

	.globl	_grph_table0
	.globl	_makegrph_initialize
	.globl	_makegrph

	.text
	.align	2

_makegrph_initialize:
	rts
	nop

	.align	2
_grph_table0:
	.long		0x00000000
	.long		0x01000000
	.long		0x00010000
	.long		0x01010000
	.long		0x00000100
	.long		0x01000100
	.long		0x00010100
	.long		0x01010100
	.long		0x00000001
	.long		0x01000001
	.long		0x00010001
	.long		0x01010001
	.long		0x00000101
	.long		0x01000101
	.long		0x00010101
	.long		0x01010101

	! r8 = mem
	! r9 = vc
	! r10 = out
	! r11 = grph_table0
	! tmp r2, r3, r4, r5, r12

.macro GRPHDATASET
	mov.l	2000f,r7
	add	r12,r7

	mov	r13,r3
	shlr16	r3
	shlr	r3
	mov	r3,r0
	mov.b	@(r0,r12),r6
	mov.b	@(r0,r7),r7
	mov.l	2001f,r0
	add	r0,r12

	mov	r6,r0
	and	#0xf0,r0
	shlr2	r0
	mov.l	@(r0,r1),r8	! 0
	mov	r6,r0
	and	#0x0f,r0
	shll2	r0
	mov.l	@(r0,r1),r9	! 0

	mov	r7,r0
	and	#0xf0,r0	! 1
	shlr2	r0
	mov.l	@(r0,r1),r2	! 1
	mov	r7,r0
	and	#0x0f,r0	! 1
	shll2	r0
	mov.l	@(r0,r1),r7	! 1

	mov	r3,r0
	mov.b	@(r0,r12),r6
	
	shll	r2
	or	r2,r8	! 1

	shll	r7
	or	r7,r9	! 1
	
	mov.l	2002f,r0
	add	r0,r12

	mov	r6,r0
	and	#0xf0,r0	! 2
	shlr2	r0
	mov.l	@(r0,r1),r2	! 2

	mov	r3,r0
	mov.b	@(r0,r12),r7
	
	mov	r6,r0
	and	#0x0f,r0	! 2
	shll2	r0
	mov.l	@(r0,r1),r6	! 2
	
	shll2	r2
	or	r2,r8		! 2

	mov	r7,r0
	and	#0xf0,r0	! 3
	shlr2	r0
	mov.l	@(r0,r1),r2	! 3
	mov	r7,r0
	and	#0x0f,r0	! 3
	shll2	r0
	mov.l	@(r0,r1),r7	! 3
	
	mov	r6,r0
	shll2	r0
	or	r0,r9		! 2

	mov	#3,r3
	mov	r2,r0
	shld	r3,r0
	or	r0,r8		! 3

	mov	r7,r0
	shld	r3,r0
	or	r0,r9		! 3
	
	mov.l	2003f,r3
	mov	r14,r0
	sub	r3,r12
	mov.l	r9,@-r0
	mov.l	r8,@-r0
.endm

! ----

	! r0 = remain:0:pitch (10:7:15)
	! r1 = mg.vm
	! r6 = liney:gdc.mode1:mul:mulorg:dsync.grphymax:0 (9:1:5:5:9:3)
	! r7 = vramupdate
	! r8 = mem
	! r9 = vc:0:flag:bit (15:1:8:8)
	! r10 = out
	! r11 = grph_table0
	! tmp r2, r3 / r4, r5, r12 (GRPHDATASET)
	! input - r2 = pos r3 = gdc

gp_all:
	mov	r2,r0
	mov	#(1 + 17),r3
	shld	r3,r0
	or	r0,r13		! (vad << 17)
	
	mov	#-(4 + 16),r0
	shld	r0,r2		! remain

	mov	r2,r0
	mov	#22,r3
	shld	r3,r0
	or	r0,r4		! (remain << 22)
	
gpa_lineylp1:
	mov	#0x1f,r2
	mov	#12,r3
	shld	r3,r2
	and	r10,r2		! mul !
	mov	r2,r0
	mov	#5,r3
	shld	r3,r0
	or	r0,r10

gpa_lineylp2:
	mov	r10,r0
	mov.w	100f,r3
	shlr16	r0
	tst	#(1 << (23 - 16)),r0
	bt/s	1f
	add	r3,r5
	mov	r10,r0
	shlr16	r0
	tst	#(1 << (22 - 16)),r0
1:
	bf	gpa_lineyed
	mov	r5,r14
	bra	gpa_pixlp
	sub	r3,r14

100:	.word	640
gpa_pixlp:
	add	#8,r14
	GRPHDATASET
	mov	#1,r0
	mov	#17,r3
	shld	r3,r0
	add	r0,r13
	cmp/hs	r5,r14
	bf	gpa_pixlp
	mov.l	3000f,r6
	mov	#((80 << 17) >> 17),r0
	mov	#17,r3
	shld	r3,r0
	sub	r0,r13
	!
	mov	r10,r0
	mov	#-23,r3
	shld	r3,r0
	mov.b	@(r0,r6),r7
	mov	#~(3),r3
	swap.b	r13,r0
	and	r3,r0
	swap.b	r0,r13
	!
	or	r13,r7
	mov	r10,r0
	mov	#-23,r3
	shld	r3,r0
	mov.b	r7,@(r0,r6)
gpa_lineyed:
	mov	#1,r0
	mov	#23,r3
	shld	r3,r0
	add	r0,r10
	mov	r10,r0
	mov	#20,r3
	shld	r3,r0
	cmp/hs	r0,r10
	bf	1f
	!cs
	bra	makegrph_ed
	nop

	.align	2
2000:	.long	(VRAM_R - VRAM_B)
2001:	.long	(VRAM_G - VRAM_B)
2002:	.long	(VRAM_E - VRAM_G)
2003:	.long	(VRAM_E - VRAM_B)
3000:	.long		_renewal_line
1:
	mov	#1,r0
	mov	#22,r3
	shld	r3,r0
	sub	r0,r4
	mov	r4,r2
	mov	#-22,r3
	shld	r3,r2
	tst	r2,r2
	bt	gpa_break
	mov	r10,r0
	shlr16	r0
	tst	#((0x1f << 17) >> 16),r0
	bt	2f
	mov	#1,r0
	mov	#17,r3
	shld	r3,r0
	bra	gpa_lineylp2
	sub	r0,r10
2:
	mov	r4,r0
	mov	#17,r3
	shld	r3,r0
	bra	gpa_lineylp1
	add	r0,r13
gpa_break:
	mov.l	3000f,r7
	extu.b	r13,r13
	mov	#~(0x1f << (17 - 16)),r3
	swap.w	r10,r0
	and	r3,r0
	rts
	swap.w	r0,r10

	.align	2
3000:	.long		_gdc - G_MASTER
gp_indirty:
	mov	r2,r0
	mov	#(1 + 17),r3
	shld	r3,r0
	or	r0,r13		! (vad << 17)
	
	mov	#-(4 + 16),r3
	shld	r3,r2		! remain

	mov	r2,r0
	mov	#22,r3
	shld	r3,r0
	or	r0,r4		! (remain << 22)
gpi_lineylp1:
	mov	#((0x1f << 12) >> 12),r2
	mov	#12,r3
	shld	r3,r2
	and	r10,r2		! mul !
	mov	r2,r0
	mov	#5,r3
	shld	r3,r0
	or	r0,r10
gpi_lineylp2:
	mov.w	100f,r0
	add	r0,r5
	mov	r10,r0
	shlr16	r0
	tst	#(1 << (23 - 16)),r0
	bt	1f
	mov	r10,r0
	shlr16	r0
	tst	#(1 << (22 - 16)),r0
1:
	mov.w	100f,r3
	bt	2f
	bra	gpi_lineyed
	nop

100:	.word	640	
2:	
	mov	r13,r0
	shlr16	r0
	shlr	r0
	mov.b	@(r0,r11),r6
	mov	r5,r14
	sub	r3,r14
gpi_pixlp:
	add	#8,r14
	tst	r13,r6
	bt/s	gpi_pixnt
	and	r13,r6
	mov	r6,r0
	shll8	r0
	or	r0,r13
	GRPHDATASET
gpi_pixnt:
	mov	#1,r0
	mov	#17,r3
	shld	r3,r0
	cmp/hs	r5,r14
	bt/s	2f
	add	r0,r13
	mov	r13,r0	!cc
	mov	#-17,r3
	shld	r3,r0
	bra	gpi_pixlp
	mov.b	@(r0,r11),r6

	.align	2
2000:	.long	(VRAM_R - VRAM_B)
2001:	.long	(VRAM_G - VRAM_B)
2002:	.long	(VRAM_E - VRAM_G)
2003:	.long	(VRAM_E - VRAM_B)
2:
	mov	#((80 << 17) >> 17),r0
	mov	#17,r3
	shld	r3,r0
	sub	r0,r13
	mov.l	3000f,r6		! prepare

	mov	#3,r14
	shll8	r14
	tst	r13,r14
	bt/s	gpi_lineyed
	and	r13,r14
	
	mov	r10,r0
	mov	#-23,r3
	shld	r3,r0
	mov.b	@(r0,r6),r7

	mov	#~(3),r3
	swap.b	r13,r0
	and	r3,r0
	swap.b	r0,r13
	!
	mov	r14,r0
	shlr8	r0
	or	r0,r7

	mov	r10,r0
	mov	#-23,r3
	shld	r3,r0
	bra	gpi_lineyed
	mov.b	r7,@(r0,r6)
	
	.align	2
3000:	.long		_renewal_line
gpi_lineyed:
	mov	#1,r0
	mov	#23,r3
	shld	r3,r0
	add	r0,r10

	mov	r10,r0
	mov	#20,r3
	shld	r3,r0
	cmp/hs	r0,r10
	bf	1f
	bra	makegrph_ed	!cs
	nop
1:
	mov	#1,r0
	mov	#22,r3
	shld	r3,r0
	sub	r0,r4
	mov	r4,r2
	mov	#-22,r0
	shld	r0,r2
	tst	r2,r2
	bt	gpi_break
	
	mov	r10,r0
	shlr16	r0
	tst	#((0x1f << 17) >> 16),r0
	bt/s	2f
	mov	#17,r3
	mov	#1,r0	
	shld	r3,r0
	bra	gpi_lineylp2
	sub	r0,r10
2:
	mov	r4,r0
	shld	r3,r0
	bra	gpi_lineylp1
	add	r0,r13
gpi_break:
	mov.l	3000f,r7
	extu.b	r13,r13
	mov	#~(0x1f << (17 - 16)),r3
	swap.w	r10,r0
	and	r3,r0
	rts
	swap.w	r0,r10

	.align	2
3000:	.long		_gdc - G_MASTER

	
_makegrph:
	mov.l	r8,@-r15
	mov.l	r9,@-r15
	mov.l	r10,@-r15
	mov.l	r11,@-r15
	mov.l	r12,@-r15
	mov.l	r13,@-r15
	sts.l	pr,@-r15
	mov.l	r14,@-r15
	mov.l	gp_dsync,r8
	mov.l	gp_vramupdate,r11
	mov.l	gp_vmem,r12
	mov	r4,r0
	tst	#1,r0
	bt/s	1f
	mov.l	@(DS_GRPHVAD,r8),r6
	mov.l	200f,r3
	mov.l	201f,r0
	add	r3,r12
	add	r0,r6
1:	
	mov.l	3000f,r7
	mov.l	gp_gtable0,r1
	mov.w	100f,r0
	mov	#1,r13
	extu.b	r4,r3
	mov.b	@(r0,r7),r9
	mov	#G_SLAVE + GD_PARA + GDC_PITCH,r0
	shld	r3,r13
	mov.b	@(r0,r7),r4
	mov	r9,r0
	tst	#0x80,r0
	bf/s	2f
	extu.b	r4,r4
	bra	2f
	shll	r4

100:	.word	G_CLOCK

	.align	2
gp_vmem:	.long		_i286hcore + CPU_SIZE + VRAM_B
gp_vramupdate:	.long		_vramupdate
gp_dsync:	.long		_dsync
gp_gtable0:	.long		_grph_table0
200:	.long	VRAM_STEP
201:	.long	SURFACE_SIZE
3000:	.long		_gdc - G_MASTER
2:
	mov	#0xfe,r3
	mov.l	@(DS_GRPH_VBP,r8),r10
	mov.w	101f,r0
	and	r3,r4 ! mg.pitch
	mov.b	@(r0,r7),r2
	mov	#G_SLAVE + GD_PARA + GDC_CSRFORM,r0
	mov.b	@(r0,r7),r9
	mov	#23,r0
	extu.b	r9,r9
	shld	r0,r10  ! mg.liney << 23

	mov	r2,r0
	and	#0x10,r0
	mov	#(22 - 4),r3
	shld	r3,r0 	! gdc.mode1:bit4 << 22
	or	r0,r10
	
	mov	#0x1f,r3
	mov.l	@(DS_GRPHYMAX,r8),r2
	and	r3,r9
	mov	r9,r0
	mov	#12,r3
	shld	r3,r0  	! mg.lr << 12
	or	r0,r10
	
	mov.l	gp_np2vram,r9
	mov	r2,r0
	mov	#3,r3
	shld	r3,r0
	or	r0,r10 	! dsync.grphymax << 3
	tst	r5,r5
	mov	r9,r5
	bf/s	mg_alp
	add	r6,r5
mg_ilp:
	bsr	gp_indirty
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 0,r7),r2
	
	bsr	gp_indirty
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 4,r7),r2
	
	mov.l	3000f,r2
	mov.b	@r2,r2 ! NC_UPD72020
	tst	r2,r2
	bf	mg_ilp
	
	bsr	gp_indirty
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 8,r7),r2

	bsr	gp_indirty
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 12,r7),r2
	
	bra	mg_ilp
	nop

101:	.word	G_MODE1
	
	.align	2
3000:	.long		_np2cfg
gp_np2vram:	.long		_np2_vram

mg_alp:
	bsr	gp_all
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 0,r7),r2
	
	bsr	gp_all
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 4,r7),r2
	
	mov.l	3000f,r2
	mov.b	@r2,r2 ! NC_UPD72020
	tst	r2,r2
	bf	mg_alp
	
	bsr	gp_all
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 8,r7),r2
	
	bsr	gp_all
	mov.l	@(G_SLAVE + GD_PARA + GDC_SCROLL + 12,r7),r2
	
	bra	mg_alp
	nop

	.align	2
3000:	.long		_np2cfg

makegrph_ed:
	extu.b	r13,r7
	mov	r11,r12
	mov	r7,r0
	add	#-4,r12
	shll8	r0
	mov	#0,r8
	or	r0,r7
	mov	r7,r0
	mov	#(0x8000 >> 8),r3
	shll16	r0
	extu.b	r3,r3
	or	r0,r7
	shll8	r3
mg_updclear:
	add	#4,r8
	mov.l	@r11+,r2
	not	r7,r0
	cmp/hs	r3,r8
	and	r0,r2
	mov	r8,r0
	bf/s	mg_updclear
	mov.l	r2,@(r0,r12)
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	mov.l	@r15+,r12
	mov.l	@r15+,r11
	mov.l	@r15+,r10
	mov.l	@r15+,r9
	rts	
	mov.l	@r15+,r8

	.end

