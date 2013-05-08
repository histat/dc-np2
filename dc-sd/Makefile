RONIN = /usr/local/ronin

RELEASE_BUILD = 0

AS = sh-elf-as -little
CC = sh-elf-gcc -ml -m4-single-only
LD = sh-elf-ld -EL

RM	= rm -f
MKDIR	= mkdir -p

OBJBASE		= ../obj
BINBASE		= ../bin
OBJ		= $(OBJBASE)/dc-sd
BIN		= $(BINBASE)/dc-sd

BASE		= ..
COMMON		= ../common
CODECNV		= ../codecnv
I286C		= ../i286c
I286H		= ../i286hdc
MEM		= ../mem
IO		= ../io
CBUS		= ../cbus
BIOS		= ../bios
SOUND		= ../sound
VERMOUTH	= ../sound/vermouth
GETSND		= ../sound/getsnd
VRAM		= ../vram
FDD		= ../fdd
LIO		= ../lio
FONT		= ../font
GENERIC		= ../generic
ZLIB		= ../zlib
TARGET		= .
MENU		= ./menu
SHASM		= ./sh
SDLIB	= ./lib


HEADERS		= \
	$(TARGET)/compiler.h $(BASE)/common.h $(COMMON)/milstr.h \
	$(COMMON)/_memory.h $(COMMON)/rect.h $(COMMON)/lstarray.h \
	$(TARGET)/trace.h

CPUCORES	=	$(I286H)/cpucore.h $(I286H)/memory.h


PCCORES		=	$(BASE)/pccore.h $(BASE)/nevent.h $(BASE)/statsave.h

IOCORES		= \
		$(IO)/iocore.h $(IO)/artic.h $(IO)/cgrom.h $(IO)/cpuio.h \
		$(IO)/crtc.h $(IO)/dipsw.h $(IO)/dmac.h $(IO)/egc.h \
		$(IO)/epsonio.h $(IO)/emsio.h $(IO)/fdc.h $(IO)/fdd320.h \
		$(IO)/gdc.h $(IO)/gdc_cmd.h $(IO)/gdc_sub.h $(IO)/mouseif.h \
		$(IO)/necio.h $(IO)/nmiio.h $(IO)/np2sysp.h $(IO)/pic.h \
		$(IO)/pit.h $(IO)/printif.h $(IO)/serial.h $(IO)/sysport.h \
		$(IO)/upd4990.h

FMBOARDS	= \
	$(SOUND)/soundrom.h $(SOUND)/tms3631.h $(SOUND)/fmtimer.h \
	$(SOUND)/opngen.h $(SOUND)/psggen.h $(SOUND)/rhythm.h \
	$(SOUND)/adpcm.h $(SOUND)/pcm86.h $(SOUND)/cs4231.h

VERMOUTHS = \
	$(VERMOUTH)/midiout.h $(VERMOUTH)/midimod.h \
	$(VERMOUTH)/midinst.h $(VERMOUTH)/midvoice.h \
	$(VERMOUTH)/midtable.h


ZLIBS	= \
	$(ZLIB)/crc32.h $(ZLIB)/inffast.h $(ZLIB)/inffixed.h \
	$(ZLIB)/inflate.h $(ZLIB)/inftrees.h $(ZLIB)/zconf.h \
	$(ZLIB)/zlib.h $(ZLIB)/zutil.h

ZLIBOBJ	= \
	$(OBJ)/arc.o $(OBJ)/arcunzip.o 				\
	$(OBJ)/adler32.o $(OBJ)/crc32.o	$(OBJ)/inffast.o	\
	$(OBJ)/inflate.o $(OBJ)/inftrees.o $(OBJ)/zutil.o


COPT	= -Wall -O8 -fomit-frame-pointer -fno-exceptions -I$(RONIN)/include -I$(TARGET)		\
	-I$(BASE) -I$(COMMON) -I$(CODECNV) -I$(I286H) -I$(MEM) -I$(IO) -I$(CBUS) -I$(BIOS) 	\
	-I$(LIO) -I$(VRAM) -I$(SOUND) -I$(VERMOUTH) -I$(GETSND) -I$(FDD) -I$(FONT) -I$(GENERIC) \
	-I$(MENU) -I$(SDLIB)

ifeq "$(RELEASE_BUILD)" "1"
COPT	+= -DNOSERIAL -DNODISP
endif


AOPT	=
LOPT	= -Wl,-Ttext,0x8c010000 -nostartfiles $(RONIN)/lib/crt0.o

I286COBJ = 	$(OBJ)/i286c.o $(OBJ)/i286c_mn.o $(OBJ)/i286c_ea.o	\
	$(OBJ)/i286c_0f.o $(OBJ)/i286c_8x.o $(OBJ)/i286c_sf.o		\
	$(OBJ)/i286c_f6.o $(OBJ)/i286c_fe.o $(OBJ)/i286c_rp.o		\
	$(OBJ)/v30patch.o $(OBJ)/memory.o $(OBJ)/dmav30.o 		\
	$(OBJ)/memtram.o $(OBJ)/memvram.o $(OBJ)/memems.o 		\
	$(OBJ)/memepp.o							\


I286AOBJ = 	$(OBJ)/i286h.o $(OBJ)/i286h_mn.oa $(OBJ)/i286h_i.oa 	\
	$(OBJ)/i286h_ea.oa $(OBJ)/i286h_fe.oa $(OBJ)/i286h_sf.oa	\
	$(OBJ)/i286h_8x.oa $(OBJ)/i286h_0f.oa $(OBJ)/i286h_f6.oa	\
	$(OBJ)/i286h_rp.oa $(OBJ)/memoryd.oa $(OBJ)/memoryh.oa		\
	$(OBJ)/memory2.o						\

DCOBJ	= $(OBJ)/strres.o $(OBJ)/milstr.o $(OBJ)/_memory.o		\
	$(OBJ)/textfile.o $(OBJ)/profile.o $(OBJ)/lstarray.o		\
	$(OBJ)/bmpdata.o $(OBJ)/mimpidef.o $(OBJ)/parts.oa		\
	$(I286AOBJ)							\
	$(OBJ)/dmax86.o	$(OBJ)/memegc.o					\
	$(OBJ)/iocore.o	$(OBJ)/artic.o	$(OBJ)/cgrom.o			\
	$(OBJ)/cpuio.o	$(OBJ)/crtc.o	$(OBJ)/dipsw.o			\
	$(OBJ)/dmac.o	$(OBJ)/egc.o	$(OBJ)/emsio.o			\
	$(OBJ)/epsonio.o $(OBJ)/fdc.o	$(OBJ)/fdd320.o			\
	$(OBJ)/gdc.o	$(OBJ)/gdc_sub.o $(OBJ)/gdc_pset.o		\
	$(OBJ)/mouseif.o $(OBJ)/necio.o	$(OBJ)/nmiio.o			\
	$(OBJ)/np2sysp.o $(OBJ)/pic.o	$(OBJ)/pit.o			\
	$(OBJ)/printif.o $(OBJ)/serial.o $(OBJ)/sysport.o		\
	$(OBJ)/upd4990.o						\
	$(OBJ)/cbuscore.o $(OBJ)/sasiio.o $(OBJ)/scsiio.o		\
	$(OBJ)/scsicmd.o $(OBJ)/pc9861k.o $(OBJ)/mpu98ii.o		\
	$(OBJ)/board14.o $(OBJ)/board26k.o $(OBJ)/board86.o		\
	$(OBJ)/boardx2.o $(OBJ)/board118.o $(OBJ)/boardspb.o		\
	$(OBJ)/amd98.o	$(OBJ)/pcm86io.o $(OBJ)/cs4231io.o		\
	$(OBJ)/midiout.o $(OBJ)/midimod.o $(OBJ)/midinst.o		\
	$(OBJ)/midvoice.o $(OBJ)/midtable.o				\
	$(OBJ)/getsnd.o	$(OBJ)/getwave.o $(OBJ)/getsmix.o		\
	$(OBJ)/bios.o	$(OBJ)/bios09.o	$(OBJ)/bios0c.o			\
	$(OBJ)/bios12.o	$(OBJ)/bios13.o	$(OBJ)/bios18.o			\
	$(OBJ)/bios19.o	$(OBJ)/bios1a.o	$(OBJ)/bios1b.o			\
	$(OBJ)/bios1c.o	$(OBJ)/bios1f.o	$(OBJ)/sxsibios.o		\
	$(OBJ)/sound.o	$(OBJ)/sndcsec.o $(OBJ)/fmboard.o		\
	$(OBJ)/fmtimer.o $(OBJ)/beepc.o	$(OBJ)/beepg.o			\
	$(OBJ)/tms3631c.o $(OBJ)/tms3631g.o $(OBJ)/opngenc.o		\
	$(OBJ)/opngeng.oa $(OBJ)/psggenc.o $(OBJ)/psggeng.oa		\
	$(OBJ)/rhythmc.o $(OBJ)/adpcmc.o $(OBJ)/adpcmg.o		\
	$(OBJ)/pcm86c.o	$(OBJ)/pcm86g.o	$(OBJ)/cs4231c.o		\
	$(OBJ)/cs4231g.o $(OBJ)/soundrom.o $(OBJ)/s98.o			\
	$(OBJ)/vram.o	$(OBJ)/scrndraw.o $(OBJ)/sdraw8.oa		\
	$(OBJ)/dispsync.o $(OBJ)/palettes.o $(OBJ)/maketext.o		\
	$(OBJ)/maketgrp.o $(OBJ)/makegrph.oa $(OBJ)/scrnbmp.o		\
	$(OBJ)/scrnsave.o $(OBJ)/diskdrv.o $(OBJ)/fddfile.o		\
	$(OBJ)/fdd_xdf.o $(OBJ)/fdd_d88.o $(OBJ)/fdd_mtr.o		\
	$(OBJ)/sxsi.o	$(OBJ)/sxsihdd.o $(OBJ)/sxsicd.o		\
	$(OBJ)/lio.o	$(OBJ)/gscreen.o $(OBJ)/gpset.o			\
	$(OBJ)/gline.o	$(OBJ)/gcircle.o $(OBJ)/gput1.o			\
	$(OBJ)/font.o	$(OBJ)/fontdata.o $(OBJ)/fontpc88.o		\
	$(OBJ)/fontpc98.o $(OBJ)/fontv98.o $(OBJ)/fontfm7.o		\
	$(OBJ)/fontx1.o	$(OBJ)/fontx68k.o $(OBJ)/fontmake.o		\
	$(OBJ)/cmjasts.o $(OBJ)/cmver.o	$(OBJ)/dipswbmp.o		\
	$(OBJ)/hostdrv.o $(OBJ)/hostdrvs.o $(OBJ)/cmndraw.o		\
	$(OBJ)/np2.o	$(OBJ)/dosio.o	$(OBJ)/trace.o			\
	$(OBJ)/commng.o	$(OBJ)/fontmng.o $(OBJ)/ini.o			\
	$(OBJ)/joymng.o	$(OBJ)/mousemng.o $(OBJ)/scrnmng.o		\
	$(OBJ)/soundmng.o $(OBJ)/sysmng.o $(OBJ)/taskmng.o		\
	$(OBJ)/timemng.o $(OBJ)/dckbd.o	$(OBJ)/dccore.o			\
	$(OBJ)/pccore.o	$(OBJ)/nevent.o	$(OBJ)/calendar.o		\
	$(OBJ)/timing.o	$(OBJ)/keystat.o $(OBJ)/statsave.o		\
	$(OBJ)/event.o $(OBJ)/dc_softkbd.o $(OBJ)/icon.o 		\
	$(OBJ)/sysmenu.o $(OBJ)/dlgabout.o $(OBJ)/filesel.o		\
	$(OBJ)/dlgcfg.o $(OBJ)/dlgscr.o  $(OBJ)/dlgsnd.o 		\
	$(OBJ)/ui.o $(OBJ)/sci.o $(OBJ)/ff.o 					\
	$(OBJ)/sd.o	$(OBJ)/crc.o $(OBJ)/cc932.o 				\


ifeq "$(RELEASE_BUILD)" "1"
DCLIB	= -L$(RONIN)/lib -lronin-noserial -lz -lm
else
DCLIB	= -L$(RONIN)/lib -lronin -lz -lm
endif

DCELF	= $(BIN)/np2.elf


all: $(OBJBASE) $(BINBASE) $(OBJ) $(BIN) np2.strip.elf


$(OBJBASE):
	$(MKDIR) $(OBJBASE)

$(BINBASE):
	$(MKDIR) $(BINBASE)

$(OBJ):
	$(MKDIR) $(OBJ)

$(BIN):
	$(MKDIR) $(BIN)


$(DCELF): $(DCOBJ) 
	$(CC) $(LOPT) $(DCOBJ) $(DCLIB) -o $@

np2.strip.elf: $(DCELF)
	sh-elf-strip -o $@ $<

np2.bin: $(DCELF)
	sh-elf-objcopy -S -R .stack -O binary $< $@

NP2.BIN: np2.bin
	scramble $< $@

NP2VER=$(shell grep 'NP2VER_CORE' ../np2ver.h | sed -e 's/[^"]*"\([^"]*\)".*/\1/' | sed -e 's/ver\.//' | sed -e 's/[^0-9]//')

ip.txt: ip.txt.in
	if [ $(shell echo $(NP2VER)) -ge 082 ]; then \
	 ver=V$(NP2VER); \
	else ver=git; fi; \
	sed -e 's/[@]VERSION[@]/'"$$ver"/ -e 's/[@]DATE[@]/$(shell date '+%Y%m%d')/' < $< > $@ 

IP.BIN: ip.txt
	makeip ip.txt IP.BIN

ifeq "$(RELEASE_BUILD)" "1"
dist: all NP2.BIN IP.BIN
	make clean
	make
	sh release.sh all
else
dist:
	@echo "set RELEASE_BUILD = 1"
endif

distclean:
	$(RM) $(OBJBASE) $(BINBASE)

clean:
	$(RM) $(DCOBJ) $(DCELF) np2.bin np2.strip.elf IP.BIN ip.txt NP2.BIN


$(OBJ)/strres.o		:	$(COMMON)/strres.c $(COMMON)/strres.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/milstr.o		:	$(COMMON)/milstr.c $(HEADERS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/_memory.o	:	$(COMMON)/_memory.c $(HEADERS) $(TARGET)/dosio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/textfile.o	:	$(COMMON)/textfile.c $(HEADERS) $(TARGET)/dosio.h \
						$(COMMON)/textfile.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/profile.o	:	$(COMMON)/profile.c $(HEADERS) $(TARGET)/dosio.h \
						$(COMMON)/textfile.h $(COMMON)/profile.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/rect.o		:	$(COMMON)/rect.c $(HEADERS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/lstarray.o	:	$(COMMON)/lstarray.c $(HEADERS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bmpdata.o	:	$(COMMON)/bmpdata.c $(HEADERS) $(COMMON)/bmpdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/mimpidef.o	:	$(COMMON)/mimpidef.c $(HEADERS) $(TARGET)/dosio.h \
						$(COMMON)/textfile.h $(COMMON)/mimpidef.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/parts.o		:	$(COMMON)/parts.c $(HEADERS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/parts.oa		:	$(SHASM)/parts.s
	$(AS) $(AOPT) $< -o $@

$(OBJ)/arc.o		:	$(COMMON)/arc.c $(HEADERS) $(TARGET)/dosio.h \
						$(COMMON)/arc.h $(COMMON)/arcunzip.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/arcunzip.o	:	$(COMMON)/arcunzip.c $(HEADERS) $(TARGET)/dosio.h \
						$(COMMON)/arc.h $(COMMON)/arcunzip.h $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@


$(OBJ)/adler32.o	:	$(ZLIB)/adler32.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/crc32.o		:	$(ZLIB)/crc32.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/inffast.o	:	$(ZLIB)/inffast.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/inflate.o	:	$(ZLIB)/inflate.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/inftrees.o	:	$(ZLIB)/inftrees.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/zutil.o		:	$(ZLIB)/zutil.c $(ZLIBS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/resize.o		:	$(COMMON)/resize.c $(HEADERS) $(COMMON)/resize.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sjiseuc.o	:	$(CODECNV)/sjiseuc.c $(HEADERS) $(CODECNV)/codecnv.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/eucsjis.o	:	$(CODECNV)/eucsjis.c $(HEADERS) $(CODECNV)/codecnv.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/eucucs2.o	:	$(CODECNV)/eucucs2.c $(HEADERS) $(CODECNV)/codecnv.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c.o		:	$(I286C)/i286c.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(I286C)/i286c.h $(I286C)/v30patch.h \
						$(MEM)/dmax86.h $(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_mn.o	:	$(I286C)/i286c_mn.c $(HEADERS) $(CPUCORES) \
						$(PCCORES) $(IOCORES) $(I286C)/i286c.h \
						$(I286C)/i286c.mcr $(BIOS)/bios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_ea.o	:	$(I286C)/i286c_ea.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.h $(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_0f.o	:	$(I286C)/i286c_0f.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.h $(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_8x.o	:	$(I286C)/i286c_8x.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.h $(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_sf.o	:	$(I286C)/i286c_sf.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.h $(I286C)/i286c.mcr \
						$(I286C)/i286c_sf.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_f6.o	:	$(I286C)/i286c_f6.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_fe.o	:	$(I286C)/i286c_fe.c $(HEADERS) $(CPUCORES) \
						$(I286C)/i286c.h $(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286c_rp.o	:	$(I286C)/i286c_rp.c $(HEADERS) $(CPUCORES) \
						$(PCCORES) $(IOCORES) $(I286C)/i286c.h \
						$(I286C)/i286c.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/v30patch.o	:	$(I286C)/v30patch.c $(HEADERS) $(CPUCORES) \
						$(PCCORES) $(IOCORES) $(I286C)/i286c.h \
						$(I286C)/v30patch.h $(MEM)/dmav30.h \
						$(I286C)/i286c.mcr $(BIOS)/bios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/memory.o		:	$(I286C)/memory.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/memegc.h $(VRAM)/vram.h \
						$(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@


$(OBJ)/i286h.o		:	$(I286H)/i286h.c $(I286H)/cpucore.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/i286h_mn.oa	:	$(I286H)/i286h_mn.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286halu.inc $(I286H)/i286hop.inc $(I286H)/i286hio.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_ea.oa	:	$(I286H)/i286h_ea.s $(I286H)/i286h.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_0f.oa	:	$(I286H)/i286h_0f.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286halu.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_8x.oa	:	$(I286H)/i286h_8x.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286halu.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_sf.oa	:	$(I286H)/i286h_sf.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286hsft.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_f6.oa	:	$(I286H)/i286h_f6.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286halu.inc $(I286H)/i286hop.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_fe.oa	:	$(I286H)/i286h_fe.s $(I286H)/i286h.inc $(I286H)/i286hea.inc $(I286H)/i286halu.inc $(I286H)/i286hop.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_rp.oa	:	$(I286H)/i286h_rp.s $(I286H)/i286h.inc $(I286H)/i286halu.inc 
	$(AS) $(AOPT) $< -o $@

$(OBJ)/i286h_i.oa	:	$(I286H)/i286h_i.s $(I286H)/i286h.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/memoryd.oa	:	$(I286H)/memoryd.s $(I286H)/i286h.inc $(I286H)/i286hmem.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/memoryh.oa	:	$(I286H)/memoryh.s $(I286H)/i286h.inc $(I286H)/i286hmem.inc $(I286H)/i286hio.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/memory2.o	:	$(I286H)/memory2.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/memegc.h $(VRAM)/vram.h \
						$(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dmax86.o		:	$(MEM)/dmax86.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/dmax86.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/memtram.o	:	$(MEM)/memtram.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/memtram.h $(VRAM)/vram.h \
						$(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/memegc.o		:	$(MEM)/memegc.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/memegc.h $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/iocore.o		:	$(IO)/iocore.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(IO)/iocore16.tbl \
						$(SOUND)/sound.h $(CBUS)/cs4231io.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/artic.o		:	$(IO)/artic.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cgrom.o		:	$(IO)/cgrom.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cpuio.o		:	$(IO)/cpuio.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/crtc.o		:	$(IO)/crtc.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dipsw.o		:	$(IO)/dipsw.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/sysmng.h \
						$(SOUND)/sound.h $(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dmac.o		:	$(IO)/dmac.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(SOUND)/sound.h $(SOUND)/cs4231.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/egc.o		:	$(IO)/egc.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(MEM)/memegc.h $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/emsio.o		:	$(IO)/emsio.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/epsonio.o	:	$(IO)/epsonio.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fdc.o		:	$(IO)/fdc.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FDD)/fddfile.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fdd320.o		:	$(IO)/fdd320.c $(HEADERS) $(PCCORES) $(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gdc.o		:	$(IO)/gdc.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/scrnmng.h $(IO)/gdc_cmd.tbl \
						$(VRAM)/vram.h $(VRAM)/palettes.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gdc_sub.o	:	$(IO)/gdc_sub.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(IO)/gdc_pset.h $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gdc_pset.o	:	$(IO)/gdc_pset.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(IO)/gdc_pset.h $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/mouseif.o	:	$(IO)/mouseif.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/mousemng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/necio.o		:	$(IO)/necio.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/nmiio.o		:	$(IO)/nmiio.c $(HEADERS) $(PCCORES) $(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/np2sysp.o	:	$(IO)/np2sysp.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(COMMON)/strres.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pic.o		:	$(IO)/pic.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pit.o		:	$(IO)/pit.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(SOUND)/sound.h $(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/printif.o	:	$(IO)/printif.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/commng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/serial.o		:	$(IO)/serial.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/commng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sysport.o	:	$(IO)/sysport.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(SOUND)/sound.h $(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/upd4990.o	:	$(IO)/upd4990.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/timemng.h $(BASE)/calendar.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/cbuscore.o	:	$(CBUS)/cbuscore.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(CBUS)/cbuscore.h $(CBUS)/pc9861k.h $(CBUS)/mpu98ii.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sasiio.o		:	$(CBUS)/sasiio.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(CBUS)/cbuscore.h \
						$(CBUS)/sasiio.h $(FDD)/sxsi.h $(CBUS)/sasibios.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/scsiio.o		:	$(CBUS)/scsiio.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(CBUS)/cbuscore.h \
						$(CBUS)/scsiio.h $(CBUS)/scsiio.tbl \
						$(CBUS)/scsicmd.h $(CBUS)/scsibios.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/scsicmd.o	:	$(CBUS)/scsicmd.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(CBUS)/cbuscore.h \
						$(CBUS)/scsiio.h $(CBUS)/scsiio.tbl \
						$(CBUS)/scsicmd.h $(FDD)/sxsi.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pc9861k.o	:	$(CBUS)/pc9861k.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/commng.h $(CBUS)/cbuscore.h \
						$(CBUS)/pc9861k.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/mpu98ii.o	:	$(CBUS)/mpu98ii.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/commng.h $(CBUS)/cbuscore.h \
						$(CBUS)/mpu98ii.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/board14.o	:	$(CBUS)/board14.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/board14.h \
						$(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/board26k.o	:	$(CBUS)/board26k.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/board26k.h \
						$(SOUND)/sound.h $(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/board86.o	:	$(CBUS)/board86.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/board86.h \
						$(CBUS)/pcm86io.h $(SOUND)/sound.h $(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/boardx2.o	:	$(CBUS)/boardx2.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/boardx2.h \
						$(CBUS)/pcm86io.h $(SOUND)/sound.h $(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/board118.o	:	$(CBUS)/board118.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/board118.h \
						$(CBUS)/cs4231io.h $(SOUND)/sound.h $(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/boardspb.o	:	$(CBUS)/boardspb.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/boardspb.h \
						$(SOUND)/sound.h $(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/amd98.o		:	$(CBUS)/amd98.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(CBUS)/cbuscore.h $(CBUS)/amd98.h \
						$(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pcm86io.o	:	$(CBUS)/pcm86io.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(CBUS)/pcm86io.h \
						$(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cs4231io.o	:	$(CBUS)/cs4231io.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(CBUS)/cs4231io.h \
						$(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/bios.o		:	$(BIOS)/bios.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/dosio.h $(BIOS)/bios.h \
						$(BIOS)/biosmem.h $(BIOS)/fdfmt.h \
						$(BIOS)/keytable.res $(BIOS)/itfrom.res \
						$(BIOS)/startup.res $(BIOS)/biosfd80.res \
						$(LIO)/lio.h $(FDD)/fddfile.h $(FDD)/fdd_mtr.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios09.o		:	$(BIOS)/bios09.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios0c.o		:	$(BIOS)/bios0c.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h \
						$(BIOS)/rsbios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios12.o		:	$(BIOS)/bios12.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios13.o		:	$(BIOS)/bios13.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios18.o		:	$(BIOS)/bios18.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h \
						$(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios19.o		:	$(BIOS)/bios19.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h \
						$(BIOS)/rsbios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios1a.o		:	$(BIOS)/bios1a.c $(HEADERS) $(CPUCORE) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios1b.o		:	$(BIOS)/bios1b.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(CBUS)/scsicmd.h $(BIOS)/bios.h \
						$(BIOS)/biosmem.h $(BIOS)/sxsibios.h \
						$(FDD)/fddfile.h $(FDD)/fdd_mtr.h $(FDD)/sxsi.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios1c.o		:	$(BIOS)/bios1c.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/timemng.h $(BASE)/calendar.h \
						$(BIOS)/bios.h $(BIOS)/biosmem.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/bios1f.o		:	$(BIOS)/bios1f.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sxsibios.o	:	$(BIOS)/sxsibios.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(BIOS)/bios.h $(BIOS)/biosmem.h $(BIOS)/sxsibios.h \
						$(CBUS)/scsicmd.h $(FDD)/sxsi.h $(BASE)/timing.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/sound.o		:	$(SOUND)/sound.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/soundmng.h $(SOUND)/sound.h \
						$(SOUND)/sndcsec.h $(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sndcsec.o	:	$(SOUND)/sndcsec.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/sndcsec.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fmboard.o	:	$(SOUND)/fmboard.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(TARGET)/joymng.h $(TARGET)/soundmng.h \
						$(CBUS)/cbuscore.h $(CBUS)/board14.h \
						$(CBUS)/board26k.h $(CBUS)/board86.h \
						$(CBUS)/boardx2.h $(CBUS)/board118.h \
						$(CBUS)/boardspb.h $(CBUS)/amd98.h $(CBUS)/pcm86io.h \
						$(CBUS)/cs4231io.h $(SOUND)/sound.h $(SOUND)/beep.h \
						$(GENERIC)/keydisp.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fmtimer.o	:	$(SOUND)/fmtimer.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/beepc.o		:	$(SOUND)/beepc.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(SOUND)/sound.h \
						$(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/beepg.o		:	$(SOUND)/beepg.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/beep.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/tms3631c.o	:	$(SOUND)/tms3631c.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/tms3631.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/tms3631g.o	:	$(SOUND)/tms3631g.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/tms3631.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/opngenc.o	:	$(SOUND)/opngenc.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(SOUND)/sound.h $(GENERIC)/keydisp.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/opngeng.o	:	$(SOUND)/opngeng.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/opngeng.oa	:	$(SHASM)/opngeng.s
	$(AS) $(AOPT) $< -o $@

$(OBJ)/psggenc.o	:	$(SOUND)/psggenc.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/psggen.h $(GENERIC)/keydisp.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/psggeng.o	:	$(SOUND)/psggeng.c $(HEADERS) $(COMMON)/parts.h \
						$(SOUND)/sound.h $(SOUND)/psggen.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/psggeng.oa	:	$(SHASM)/psggeng.s
	$(AS) $(AOPT) $< -o $@

$(OBJ)/rhythmc.o	:	$(SOUND)/rhythmc.c $(HEADERS) $(PCCORES) \
						$(COMMON)/wavefile.h $(TARGET)/dosio.h \
						$(SOUND)/sound.h $(SOUND)/rhythm.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/adpcmc.o		:	$(SOUND)/adpcmc.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/opngen.h $(SOUND)/adpcm.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/adpcmg.o		:	$(SOUND)/adpcmg.c $(HEADERS) $(SOUND)/sound.h \
						$(SOUND)/adpcm.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pcm86c.o		:	$(SOUND)/pcm86c.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/pcm86g.o		:	$(SOUND)/pcm86g.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cs4231c.o	:	$(SOUND)/cs4231c.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cs4231g.o	:	$(SOUND)/cs4231g.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(SOUND)/sound.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/soundrom.o	:	$(SOUND)/soundrom.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/dosio.h $(SOUND)/soundrom.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/s98.o		:	$(SOUND)/s98.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(FMBOARDS) $(TARGET)/dosio.h $(SOUND)/sound.h \
						$(SOUND)/s98.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/midiout.o	:	$(VERMOUTH)/midiout.c $(HEADERS) $(VERMOUTHS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/midimod.o	:	$(VERMOUTH)/midimod.c $(HEADERS) $(VERMOUTHS) \
						$(COMMON)/textfile.h $(TARGET)/dosio.h 
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/midinst.o	:	$(VERMOUTH)/midinst.c $(HEADERS) $(VERMOUTHS) \
						$(TARGET)/dosio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/midvoice.o	:	$(VERMOUTH)/midvoice.c $(HEADERS) $(VERMOUTHS)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/midtable.o	:	$(VERMOUTH)/midtable.c $(HEADERS) $(VERMOUTHS)
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/getsnd.o		:	$(GETSND)/getsnd.c $(HEADERS) $(GETSND)/getsnd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/getwave.o	:	$(GETSND)/getwave.c $(HEADERS) $(GETSND)/getsnd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/getmp3.o		:	$(GETSND)/getmp3.c $(HEADERS) $(GETSND)/getsnd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/getogg.o		:	$(GETSND)/getogg.c $(HEADERS) $(GETSND)/getsnd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/getsmix.o	:	$(GETSND)/getsmix.c $(HEADERS) $(GETSND)/getsnd.h \
						$(GETSND)/getsndmn.mcr $(GETSND)/getsndst.mcr
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/vram.o		:	$(VRAM)/vram.c $(HEADERS) $(CPUCORES) $(VRAM)/vram.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/scrndraw.o	:	$(VRAM)/scrndraw.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/scrnmng.h $(VRAM)/scrndraw.h \
						$(VRAM)/sdraw.h $(VRAM)/dispsync.h $(VRAM)/palettes.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sdraw.o		:	$(VRAM)/sdraw.c $(HEADERS) $(TARGET)/scrnmng.h \
						$(VRAM)/scrndraw.h $(VRAM)/sdraw.h \
						$(VRAM)/palettes.h $(VRAM)/sdraw.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sdraw8.oa		:	$(SHASM)/sdraw8.s $(SHASM)/sdraw.inc
	$(AS) $(AOPT) $< -o $@


$(OBJ)/sdraw16.oa		:	$(SHASM)/sdraw16.s $(SHASM)/sdraw.inc
	$(AS) $(AOPT) $< -o $@

$(OBJ)/sdrawq16.o	:	$(VRAM)/sdrawq16.c $(HEADERS) $(TARGET)/scrnmng.h \
						$(VRAM)/scrndraw.h $(VRAM)/sdraw.h \
						$(VRAM)/palettes.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sdrawq16.oa	:	$(SHASM)/sdrawq16.s $(SHASM)/sdraw.inc
	$(AS) $(AOPT) $< -o $@


$(OBJ)/dispsync.o	:	$(VRAM)/dispsync.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(TARGET)/scrnmng.h $(VRAM)/scrndraw.h \
						$(VRAM)/dispsync.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/palettes.o	:	$(VRAM)/palettes.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/scrnmng.h $(VRAM)/scrndraw.h \
						$(VRAM)/palettes.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/maketext.o	:	$(VRAM)/maketext.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(VRAM)/vram.h $(VRAM)/scrndraw.h \
						$(VRAM)/dispsync.h $(VRAM)/maketext.h $(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/maketgrp.o	:	$(VRAM)/maketgrp.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(VRAM)/vram.h $(VRAM)/scrndraw.h \
						$(VRAM)/dispsync.h $(VRAM)/palettes.h \
						$(VRAM)/maketext.h $(VRAM)/maketgrp.h \
						$(VRAM)/makegrph.h $(VRAM)/makegrph.mcr $(FONT)/font.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/makegrph.o	:	$(VRAM)/makegrph.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(VRAM)/vram.h $(VRAM)/scrndraw.h \
						$(VRAM)/dispsync.h $(VRAM)/makegrph.h \
						$(VRAM)/makegrph.mcr
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/makegrph.oa	:	$(SHASM)/makegrph.s $(I286H)/i286h.inc
	$(AS) $(AOPT) $< -o $@



$(OBJ)/scrnbmp.o	:	$(VRAM)/scrnbmp.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(COMMON)/bmpdata.h $(VRAM)/scrndraw.h \
						$(VRAM)/dispsync.h $(VRAM)/palettes.h \
						$(VRAM)/scrnbmp.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/scrnsave.o	:	$(VRAM)/scrnsave.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(COMMON)/bmpdata.h $(VRAM)/scrndraw.h \
						$(VRAM)/palettes.h \
						$(VRAM)/scrnsave.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/diskdrv.o	:	$(FDD)/diskdrv.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(TARGET)/sysmng.h \
						$(FDD)/diskdrv.h $(FDD)/fddfile.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/newdisk.o	:	$(FDD)/newdisk.c $(HEADERS) $(TARGET)/dosio.h \
						$(FDD)/newdisk.h $(FDD)/fddfile.h $(FDD)/sxsi.h \
						$(FDD)/hddboot.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fddfile.o	:	$(FDD)/fddfile.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(COMMON)/strres.h $(TARGET)/dosio.h \
						$(TARGET)/sysmng.h $(FDD)/fddfile.h \
						$(FDD)/fdd_xdf.h $(FDD)/fdd_d88.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fdd_xdf.o	:	$(FDD)/fdd_xdf.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(FDD)/fddfile.h $(FDD)/fdd_xdf.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fdd_d88.o	:	$(FDD)/fdd_d88.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(TARGET)/dosio.h $(FDD)/fddfile.h $(FDD)/fdd_d88.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fdd_mtr.o	:	$(FDD)/fdd_mtr.c $(HEADERS) $(PCCORES) \
						$(TARGET)/soundmng.h $(FDD)/fdd_mtr.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sxsi.o		:	$(FDD)/sxsi.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(COMMON)/strres.h $(TARGET)/dosio.h \
						$(TARGET)/sysmng.h $(FDD)/sxsi.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sxsihdd.o	:	$(FDD)/sxsihdd.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(COMMON)/strres.h $(TARGET)/dosio.h \
						$(TARGET)/sysmng.h $(FDD)/sxsi.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sxsicd.o		:	$(FDD)/sxsicd.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(COMMON)/strres.h $(TARGET)/dosio.h \
						$(TARGET)/sysmng.h $(FDD)/sxsi.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/lio.o		:	$(LIO)/lio.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(BIOS)/bios.h $(BIOS)/biosmem.h \
						$(VRAM)/vram.h $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gscreen.o	:	$(LIO)/gscreen.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gview.o		:	$(LIO)/gview.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gcolor1.o	:	$(LIO)/gcolor1.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gcolor2.o	:	$(LIO)/gcolor2.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gcls.o		:	$(LIO)/gcls.c $(HEADERS) $(CPUCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gpset.o		:	$(LIO)/gpset.c $(HEADERS) $(CPUCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gline.o		:	$(LIO)/gline.c $(HEADERS) $(CPUCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gcircle.o	:	$(LIO)/gcircle.c $(HEADERS) $(CPUCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/gput1.o		:	$(LIO)/gput1.c $(HEADERS) $(CPUCORES) $(LIO)/lio.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/font.o		:	$(FONT)/font.c $(HEADERS) $(CPUCORES) \
						$(COMMON)/strres.h $(TARGET)/dosio.h $(FONT)/font.h \
						$(FONT)/fontdata.h $(FONT)/fontmake.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontdata.o	:	$(FONT)/fontdata.c $(HEADERS) $(CPUCORES) \
						$(FONT)/font.h $(FONT)/fontdata.h $(FONT)/fontdata.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontpc88.o	:	$(FONT)/fontpc88.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/dosio.h $(FONT)/font.h $(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontpc98.o	:	$(FONT)/fontpc98.c $(HEADERS) $(CPUCORES) \
						$(COMMON)/bmpdata.h $(TARGET)/dosio.h \
						$(FONT)/font.h $(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontv98.o	:	$(FONT)/fontv98.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/dosio.h $(FONT)/font.h $(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontfm7.o	:	$(FONT)/fontfm7.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/dosio.h $(FONT)/font.h $(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontx1.o		:	$(FONT)/fontx1.c $(HEADERS) $(CPUCORES) \
						$(COMMON)/parts.h $(TARGET)/dosio.h $(FONT)/font.h \
						$(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontx68k.o	:	$(FONT)/fontx68k.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/dosio.h $(FONT)/font.h $(FONT)/fontdata.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontmake.o	:	$(FONT)/fontmake.c $(HEADERS) $(COMMON)/bmpdata.h \
						$(COMMON)/parts.h $(TARGET)/dosio.h \
						$(TARGET)/fontmng.h $(FONT)/font.h \
						$(FONT)/fontdata.h $(FONT)/fontmake.h
	$(CC) $(COPT) -c $< -o $@



$(OBJ)/cmndraw.o	:	$(GENERIC)/cmndraw.c $(HEADERS) \
						$(TARGET)/scrnmng.h $(GENERIC)/cmndraw.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/keydisp.o	:	$(GENERIC)/keydisp.c $(HEADERS) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(SOUND)/sound.h \
						$(GENERIC)/keydisp.h $(GENERIC)/keydisp.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/softkbd.o	:	$(GENERIC)/softkbd.c $(HEADERS) \
						$(COMMON)/bmpdata.h $(BASE)/keystat.h \
						$(GENERIC)/softkbd.h $(GENERIC)/softkbd.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dipswbmp.o	:	$(GENERIC)/dipswbmp.c $(HEADERS) $(COMMON)/bmpdata.h \
						$(GENERIC)/dipswbmp.h $(GENERIC)/dipswbmp.res
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cmver.o		:	$(GENERIC)/cmver.c $(HEADERS) $(TARGET)/commng.h \
						$(SOUND)/sound.h $(VERMOUTH)/vermouth.h \
						$(GENERIC)/keydisp.h $(GENERIC)/cmver.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cmjasts.o	:	$(GENERIC)/cmjasts.c $(HEADERS) $(CPUCORES) \
						$(TARGET)/commng.h $(SOUND)/sound.h \
						$(GENERIC)/cmjasts.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/hostdrv.o	:	$(GENERIC)/hostdrv.c $(HEADERS) $(CPUCORES) \
						$(PCCORES) $(IOCORES) $(GENERIC)/hostdrv.h \
						$(GENERIC)/hostdrv.tbl $(GENERIC)/hostdrvs.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/hostdrvs.o	:	$(GENERIC)/hostdrvs.c $(HEADERS) $(PCCORES) \
						$(CODECNV)/codecnv.h $(TARGET)/dosio.h \
						$(GENERIC)/hostdrv.h $(GENERIC)/hostdrvs.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/unasm.o		:	$(GENERIC)/unasm.c $(HEADER) $(GENERIC)/unasm.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/np2info.o	:	$(GENERIC)/np2info.c $(HEADERS) $(CPUCORES) \
						$(PCCORES) $(IOCORES) $(FMBOARDS) $(COMMON)/strres.h \
						$(TARGET)/scrnmng.h $(BIOS)/bios.h \
						$(GENERIC)/np2info.h
	$(CC) $(COPT) -c $< -o $@




$(OBJ)/np2.o		:	$(TARGET)/np2.cpp $(HEADERS) $(PCCORES) $(IOCORES) \
						$(EMBEDS) $(COMMON)/strres.h $(TARGET)/np2.h \
						$(TARGET)/dosio.h $(TARGET)/commng.h \
						$(TARGET)/scrnmng.h \
						$(TARGET)/soundmng.h $(TARGET)/sysmng.h \
						$(TARGET)/taskmng.h $(TARGET)/dckbd.h \
						$(TARGET)/ini.h \
						$(VRAM)/scrndraw.h $(SOUND)/s98.h $(FDD)/diskdrv.h \
						$(BASE)/timing.h $(BASE)/statsave.h
	$(CC) $(COPT) -c $< -o $@


$(OBJ)/dosio.o		:	$(TARGET)/dosio.cpp $(HEADERS) $(TARGET)/dosio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/trace.o		:	$(TARGET)/trace.cpp $(HEADERS) $(COMMON)/strres.h \
						$(TARGET)/dosio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/commng.o		:	$(TARGET)/commng.cpp $(HEADERS) $(TARGET)/commng.h \
						$(GENERIC)/cmver.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/fontmng.o	:	$(TARGET)/fontmng.cpp $(HEADERS) $(CODECNV)/codecnv.h \
						$(TARGET)/fontmng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/joymng.o		:	$(TARGET)/joymng.cpp $(HEADERS) $(TARGET)/joymng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/mousemng.o	:	$(TARGET)/mousemng.cpp $(HEADERS) $(TARGET)/mousemng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/scrnmng.o	:	$(TARGET)/scrnmng.cpp $(HEADERS)  \
						$(TARGET)/scrnmng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/soundmng.o	:	$(TARGET)/soundmng.cpp $(HEADERS) $(COMMON)/parts.h \
						$(TARGET)/commng.h $(TARGET)/soundmng.h \
						$(SOUND)/sound.h $(VERMOUTH)/vermouth.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sysmng.o		:	$(TARGET)/sysmng.cpp $(HEADERS) $(TARGET)/sysmng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/timemng.o	:	$(TARGET)/timemng.cpp $(HEADERS) $(TARGET)/timemng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dckbd.o		:	$(TARGET)/dckbd.cpp $(HEADERS) $(PCCORES) \
						$(IOCORES) $(TARGET)/np2.h $(TARGET)/dckbd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/ini.o		:	$(TARGET)/ini.cpp $(HEADERS) $(PCCORES) \
						$(COMMON)/strres.h $(COMMON)/profile.h \
						$(TARGET)/np2.h $(TARGET)/dosio.h $(TARGET)/ini.h
	$(CC) $(COPT) -c $< -o $@


$(OBJ)/pccore.o		:	$(BASE)/pccore.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(COMMON)/strres.h \
						$(TARGET)/dosio.h $(TARGET)/soundmng.h \
						$(TARGET)/sysmng.h $(TARGET)/timemng.h \
						$(CBUS)/cbuscore.h $(CBUS)/pc9861k.h \
						$(CBUS)/mpu98ii.h $(BIOS)/bios.h $(BIOS)/biosmem.h \
						$(VRAM)/vram.h $(VRAM)/scrndraw.h $(VRAM)/dispsync.h \
						$(VRAM)/palettes.h $(VRAM)/maketext.h \
						$(VRAM)/maketgrp.h $(VRAM)/makegrph.h \
						$(SOUND)/sound.h $(SOUND)/beep.h $(SOUND)/s98.h \
						$(FONT)/font.h $(FDD)/diskdrv.h $(FDD)/fddfile.h \
						$(FDD)/fdd_mtr.h $(FDD)/sxsi.h $(GENERIC)/hostdrv.h \
						$(BASE)/np2ver.h $(BASE)/calendar.h $(BASE)/timing.h \
						$(BASE)/debugsub.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/nevent.o		:	$(BASE)/nevent.c $(HEADERS) $(CPUCORES) $(PCCORES)
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/calendar.o	:	$(BASE)/calendar.c $(HEADERS) $(PCCORES) \
						$(COMMON)/parts.h $(TARGET)/timemng.h \
						$(BASE)/calendar.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/timing.o		:	$(BASE)/timing.c $(HEADERS) $(PCCORES) \
						$(FDD)/diskdrv.h $(FDD)/fdd_mtr.h $(BASE)/timing.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/keystat.o	:	$(BASE)/keystat.c $(HEADERS) $(PCCORES) $(IOCORES) \
						$(BASE)/keystat.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/statsave.o	:	$(BASE)/statsave.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(FMBOARDS) $(COMMON)/strres.h \
						$(TARGET)/dosio.h $(TARGET)/commng.h \
						$(TARGET)/scrnmng.h $(TARGET)/soundmng.h \
						$(TARGET)/timemng.h $(CBUS)/cbuscore.h \
						$(CBUS)/sasiio.h $(CBUS)/scsiio.h $(CBUS)/pc9861k.h \
						$(CBUS)/mpu98ii.h $(CBUS)/board14.h $(CBUS)/amd98.h \
						$(BIOS)/bios.h $(VRAM)/vram.h $(VRAM)/palettes.h \
						$(VRAM)/maketext.h $(SOUND)/sound.h $(SOUND)/beep.h \
						$(FONT)/font.h $(FDD)/fddfile.h $(FDD)/fdd_mtr.h \
						$(FDD)/sxsi.h $(GENERIC)/keydisp.h \
						$(GENERIC)/hostdrv.h $(BASE)/calendar.h \
						$(BASE)/statsave.tbl
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/debugsub.o	:	$(BASE)/debugsub.c $(HEADERS) $(CPUCORES) $(PCCORES) \
						$(IOCORES) $(COMMON)/strres.h $(TARGET)/dosio.h \
						$(BASE)/debugsub.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/taskmng.o		:	 $(TARGET)/taskmng.cpp $(TARGET)/taskmng.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dccore.o		:	 $(TARGET)/dccore.cpp $(TARGET)/dccore.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/event.o		:	 $(TARGET)/event.cpp $(TARGET)/event.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/icon.o		:	 $(TARGET)/icon.cpp $(TARGET)/icon.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/ui.o		:	 $(TARGET)/ui.cpp $(TARGET)/ui.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dc_softkbd.o		:	 $(TARGET)/dc_softkbd.cpp $(TARGET)/dc_softkbd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/vmu.o		:	 $(TARGET)/vmu.cpp $(TARGET)/vmu.h $(TARGET)/m4x8.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sysmenu.o		:	 $(TARGET)/sysmenu.cpp $(TARGET)/sysmenu.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dlgcfg.o		:	 $(MENU)/dlgcfg.cpp $(MENU)/dlgcfg.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dlgscr.o		:	 $(MENU)/dlgscr.cpp $(MENU)/dlgscr.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dlgsnd.o		:	 $(MENU)/dlgsnd.cpp $(MENU)/dlgsnd.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/dlgabout.o		:	 $(MENU)/dlgabout.cpp $(MENU)/dlgabout.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/filesel.o		:	 $(MENU)/filesel.cpp $(MENU)/filesel.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sci.o		:	 $(SDLIB)/sci.c $(SDLIB)/sci.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/sd.o		:	 $(SDLIB)/sd.c $(SDLIB)/diskio.h $(SDLIB)/sci.h $(SDLIB)/crc.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/ff.o		:	 $(SDLIB)/ff.c $(SDLIB)/ff.h $(SDLIB)/diskio.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/crc.o		:	 $(SDLIB)/crc.c $(SDLIB)/crc.h
	$(CC) $(COPT) -c $< -o $@

$(OBJ)/cc932.o		:	 $(SDLIB)/cc932.c $(SDLIB)/ff.h
	$(CC) $(COPT) -c $< -o $@

