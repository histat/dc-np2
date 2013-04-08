
I286_MEMREADMAX		=		0xa4000
I286_MEMWRITEMAX	=		0xa0000

C_FLAG				=		0x0001
P_FLAG				=		0x0004
A_FLAG				=		0x0010
Z_FLAG				=		0x0040
S_FLAG				=		0x0080
T_FLAG				=		0x0100
I_FLAG				=		0x0200
D_FLAG				=		0x0400
O_FLAG				=		0x0800

MSW_PE				=		0x0001
MSW_MP				=		0x0002
MSW_EM				=		0x0004
MSW_TS				=		0x0008

CPU_SIZE			=		(104 + 32)
CPU_STAT			=		(0)
CPU_EXT				=		(104)

CPU_REG				=		CPU_STAT + 0
CPU_SEG				=		CPU_STAT + 16
CPU_ES_BASE			=		CPU_STAT + 28
CPU_CS_BASE			=		CPU_STAT + 32
CPU_SS_BASE			=		CPU_STAT + 36
CPU_DS_BASE			=		CPU_STAT + 40
CPU_SS_FIX			=		CPU_STAT + 44
CPU_DS_FIX			=		CPU_STAT + 48
CPU_ADRSMASK		=		CPU_STAT + 52
CPU_PREFIX			=		CPU_STAT + 56
! cpu_resetreq		=		CPU_STAT + 57
CPU_GDTR			=		CPU_STAT + 58
CPU_MSW				=		CPU_STAT + 64
CPU_IDTR			=		CPU_STAT + 66
CPU_LDTR			=		CPU_STAT + 72
CPU_LDTRC			=		CPU_STAT + 74
CPU_TR				=		CPU_STAT + 80
CPU_TRC				=		CPU_STAT + 82
! cpu_type			=		CPU_STAT + 88
CPU_ITFBANK			=		CPU_STAT + 89
! cpu_ram_d0		=		CPU_STAT + 90
CPU_REMAINCLOCK		=		CPU_STAT + 92
CPU_BASECLOCK		=		CPU_STAT + 96
! cpu_clock			=		CPU_STAT + 100
! cpu_stat_size		=		104

CPU_AL				=		CPU_STAT + 0
CPU_AH				=		CPU_STAT + 1
CPU_CL				=		CPU_STAT + 2
CPU_CH				=		CPU_STAT + 3
CPU_DL				=		CPU_STAT + 4
CPU_DH				=		CPU_STAT + 5
CPU_BL				=		CPU_STAT + 6
CPU_BH				=		CPU_STAT + 7

CPU_AX				=		CPU_STAT + 0
CPU_CX				=		CPU_STAT + 2
CPU_DX				=		CPU_STAT + 4
CPU_BX				=		CPU_STAT + 6
CPU_SP				=		CPU_STAT + 8
CPU_BP				=		CPU_STAT + 10
CPU_SI				=		CPU_STAT + 12
CPU_DI				=		CPU_STAT + 14
CPU_ES				=		CPU_STAT + 16
CPU_CS				=		CPU_STAT + 18
CPU_SS				=		CPU_STAT + 20
CPU_DS				=		CPU_STAT + 22
CPU_FLAG			=		CPU_STAT + 24
CPU_IP				=		CPU_STAT + 26


CPU_EXTMEM			=		CPU_EXT + 0
CPU_EXTMEMSIZE		=		CPU_EXT + 4
CPU_EMS				=		CPU_EXT + 8
CPU_INPUT			=		CPU_EXT + 24
MEMWAIT_TRAM		=		CPU_EXT + 28
MEMWAIT_VRAM		=		CPU_EXT + 29
MEMWAIT_GRCG		=		CPU_EXT + 30
! cpu_ext_size		=		32

MAX_PREFIX			=		8



.macro	CPUDBGS
!!	mov	r11,r0
!!	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
.endm

.macro	CPUDBGL
!!	mov.l	@(CPU_REMAINCLOCK,gbr),r0
!!	mov	r0,r11
.endm


.macro	CPUSVC
	mov	r11,r0
	mov.l	r0,@(CPU_REMAINCLOCK,gbr)
.endm

.macro	CPULDC
	mov.l	@(CPU_REMAINCLOCK,gbr),r0
	mov	r0,r11
.endm

.macro	CPUSVF
	mov	r12,r0
	mov.l	r0,@(CPU_FLAG,gbr)
.endm

.macro	CPULDF
	mov.l	@(CPU_FLAG,gbr),r0
	mov	r0,r12
.endm

.macro	CPUSV
	CPUSVF
	CPUSVC
.endm

.macro	CPULD
	CPULDF
	CPULDC
.endm


.macro	CPUWORK	clock
	CPUDBGL
	add	#-\clock,r11
	CPUDBGS
.endm

.macro	CPUWKS	clock, f
	CPUDBGL
	add	#-\clock,r11
	cmp/\f	r11
	CPUDBGS
.endm

.macro	CREMSET	clock
	mov	#\clock,r11
	CPUDBGS
.endm

.macro	NEXT_OPCODE
	mov	#1,r5
	cmp/ge	r5,r11
	bf	1000f
	jmp	@r13
	nop
1000:
	mov.l	@(CPU_BASECLOCK,gbr),r0
	sub	r11,r5
	mov	#1,r11
	add	r5,r0
	jmp	@r13
	mov.l	r0,@(CPU_BASECLOCK,gbr)
.endm

.macro	REMAIN_ADJUST	clk
	exts.b	r11,r0
	cmp/eq	#\clk,r0
	bf/s	1005f
	mov	#\clk,r5
	jmp	@r13
	nop
1005:
	mov.l	@(CPU_BASECLOCK,gbr),r0
	sub	r11,r5
	mov	#\clk,r11
	add	r5,r0
	jmp	@r13
	mov.l	r0,@(CPU_BASECLOCK,gbr)
.endm

.macro	I286IRQCHECKTERM
	cmp/pl	r11
	bt/s	1008f
	mov	r11,r5
	jmp	@r13
	nop
1008:
	mov.l	@(CPU_BASECLOCK,gbr),r0
	mov	#0,r11
	sub	r5,r0
	jmp	@r13
	mov.l	r0,@(CPU_BASECLOCK,gbr)
.endm

.macro	ACCWORD	r, l
	mov	\r,r0
	mov.l	20000f,r3
	tst	#1,r0
	bf/s	\l
	cmp/hs	r3,\r
	bt	\l
.endm

.macro _ACCWORD
	.align	2
20000:	.long	I286_MEMWRITEMAX
.endm
