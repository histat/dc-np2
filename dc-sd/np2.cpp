#include "compiler.h"
#include <time.h>
#include "strres.h"
#include "parts.h"
#include "np2.h"
#include "dosio.h"
#include "commng.h"
#include "joymng.h"
#include "mousemng.h"
#include "scrnmng.h"
#include "soundmng.h"
#include "sysmng.h"
#include "dckbd.h"
#include "ini.h"
#include "cpucore.h"
#include "pccore.h"
#include "iocore.h"
#include "pc9861k.h"
#include "mpu98ii.h"
#include "bios.h"
#include "scrndraw.h"
#include "sound.h"
#include "beep.h"
#include "s98.h"
#include "diskdrv.h"
#include "fddfile.h"
#include "timing.h"
#include "keystat.h"
#include "debugsub.h"
#include "taskmng.h"
#include "sysmenu.h"
#include "dcsys.h"
#include "event.h"
#include "ui.h"
#include "dc_softkbd.h"
#include <ronin/serial.h>
#include <ronin/maple.h>
#include <ronin/notlibc.h>
#include <ronin/dc_time.h>
#include <ronin/video.h>
#include <ronin/sound.h>
#include <ronin/ta.h>


bool	__dc_avail;

unsigned int dc_savedtimes;

unsigned short dc_joyinput;

short dc_mouseaxis1;
short dc_mouseaxis2;


static char modulefile[MAX_PATH] = "\\NP2\\NP2.BIN";


NP2OSCFG	np2oscfg = {0, 0, 0, 0,
						0, 0, {1, 2, 2, 1},
						0, 0,
						0};


#define	MAX_FRAMESKIP		4

struct tagNp2Main {
	UINT uFrameCount;
	UINT uWaitCount;
	UINT uFrameMax;
};

typedef struct tagNp2Main NP2MAIN;
typedef struct tagNp2Main *PNP2MAIN;

static void framereset(NP2MAIN &np2m, UINT uCount)
{
	np2m.uFrameCount = 0;
	sysmng_updatecaption();
}

static void processwait(NP2MAIN &np2m, UINT uCount)
{
	if (timing_getcount() >= uCount) {
		timing_setcount(0);
		framereset(np2m, uCount);
	} else {
		Sleep(960);
	}
}

static void exec1frame(NP2MAIN &np2m)
{
	joymng_sync();
	pccore_exec((BRESULT)(np2m.uFrameCount == 0));
	np2m.uFrameCount++;

	mousemng_sync();
	softkbddc_sync();
}



// ---- resume
#if 0
static void getstatfilename(OEMCHAR *path, const OEMCHAR *ext, int size) {

	file_cpyname(path, modulefile, size);
	file_cutext(path);
	file_catname(path, str_dot, size);
	file_catname(path, ext, size);
}

static int flagsave(const OEMCHAR *ext) {

	int		ret;
	OEMCHAR	path[MAX_PATH];

	getstatfilename(path, ext, NELEMENTS(path));
	ret = statsave_save(path);
	if (ret) {
		file_delete(path);
	}
	return(ret);
}

static void flagdelete(const OEMCHAR *ext) {

	OEMCHAR	path[MAX_PATH];

	getstatfilename(path, ext, NELEMENTS(path));
	file_delete(path);
}

static int flagload(const OEMCHAR *ext, const OEMCHAR *title, BOOL force) {

	int		ret;
	int		id;
	OEMCHAR	path[MAX_PATH];
	OEMCHAR	buf[1024];
	OEMCHAR	buf2[1024 + 256];

	getstatfilename(path, ext, NELEMENTS(path));
	id = DID_YES;
	ret = statsave_check(path, buf, NELEMENTS(buf));
	if (ret & (~STATFLAG_DISKCHG)) {
		menumbox(OEMTEXT("Couldn't restart"), title, MBOX_OK | MBOX_ICONSTOP);
		id = DID_NO;
	}
	else if ((!force) && (ret & STATFLAG_DISKCHG)) {
		OEMSPRINTF(buf2, OEMTEXT("Conflict!\n\n%s\nContinue?"), buf);
		id = menumbox(buf2, title, MBOX_YESNOCAN | MBOX_ICONQUESTION);
	}
	if (id == DID_YES) {
		statsave_load(path);
	}
	return(id);
}
#endif

// ----

bool dcsys_task()
{
	enum {
		CMD_MENU = 1,
	};
	int cmd = 0;
  
	Event ev;
	static  unsigned int tick = 0;

	unsigned int tm = Timer() - tick;
	if (tm < USEC_TO_TIMER(1000000/60)) {
		return __dc_avail;
	}
  
	tick += tm;

	int x, y;

	int cJoy = 0;
	static int pJoy;
	static unsigned int repeatTime;

	if (__dc_avail) {

		dc_mouseaxis1 = 0;
		dc_mouseaxis2 = 0;

		while (PollEvent(ev)) {
      
			switch (ev.type) {
				
			case EVENT_KEYDOWN:
				switch (ev.key.keycode) {
				case KBD_S1: case KBD_S2:
					cmd = CMD_MENU;
					break;
	  
				default:
					dckbd_keydown(ev.key.keycode);
				}
				break;
	
			case EVENT_KEYUP:
				dckbd_keyup(ev.key.keycode);
				break;
	
			case EVENT_MOUSEMOTION:
				dc_mouseaxis1 += ev.motion.x;
				dc_mouseaxis2 += ev.motion.y;
				break;

			case EVENT_MOUSEBUTTONDOWN:
				switch (ev.button.button) {
				case EVENT_BUTTON_LEFT:
					mousemng_buttonevent(MOUSEMNG_LEFTDOWN);
					break;

				case EVENT_BUTTON_RIGHT:
					mousemng_buttonevent(MOUSEMNG_RIGHTDOWN);
					break;
				}
				break;
      
			case EVENT_MOUSEBUTTONUP:
				switch (ev.button.button) {
				case EVENT_BUTTON_LEFT:
					mousemng_buttonevent(MOUSEMNG_LEFTUP);
					break;

				case EVENT_BUTTON_RIGHT:
					mousemng_buttonevent(MOUSEMNG_RIGHTUP);
					break;
				}
				break;

			case EVENT_JOYAXISMOTION:
				x = 0;
				y = 0;
	
				if (ev.jaxis.axis == 0) {
					x = ev.jaxis.value;
				}
				if (ev.jaxis.axis == 1) {
					y = ev.jaxis.value;
				}

				dc_mouseaxis1 += x;
				dc_mouseaxis2 += y;
	  
				break;

			case EVENT_JOYBUTTONDOWN:

				if (ev.jbutton.button == JOY_START)
					cmd = CMD_MENU;
	
				if (ev.jbutton.button == JOY_RTRIGGER)
					__skbd_avail = !__skbd_avail;

				if (__skbd_avail && ev.jbutton.button == JOY_A)
					softkbddc_down();

				if (__skbd_avail && ev.jbutton.button == JOY_B)
					__use_bg = !__use_bg;
	
				if (__skbd_avail) {
					cJoy = ev.jbutton.button & 0xffff;
	  
				} else {
					switch (ev.jbutton.button) {

					case JOY_UP:
						dckbd_keydown(JOY1_UP);
						break;
	    
					case JOY_DOWN:
						dckbd_keydown(JOY1_DOWN);
						break;
	    
					case JOY_LEFT:
						dckbd_keydown(JOY1_LEFT);
						break;
	    
					case JOY_RIGHT:
						dckbd_keydown(JOY1_RIGHT);
						break;
	    
					case JOY_A:
						dckbd_keydown(JOY1_A);
						break;
	    
					case JOY_B:
						dckbd_keydown(JOY1_B);
						break;

					case JOY_X:
						mousemng_buttonevent(MOUSEMNG_LEFTDOWN);
						break;
	    
					case JOY_Y:
						mousemng_buttonevent(MOUSEMNG_RIGHTDOWN);
						break;
					}
				}
				break;
	
			case EVENT_JOYBUTTONUP:

				softkbddc_up();

				if (__skbd_avail) {

					pJoy = 0;
					repeatTime = 0;

				} else {
	  
					switch (ev.jbutton.button) {
	    
					case JOY_UP:
						dckbd_keyup(JOY1_UP);
						break;
	    
					case JOY_DOWN:
						dckbd_keyup(JOY1_DOWN);
						break;
	    
					case JOY_LEFT:
						dckbd_keyup(JOY1_LEFT);
						break;
	    
					case JOY_RIGHT:
						dckbd_keyup(JOY1_RIGHT);
						break;
	    
					case JOY_A:
						dckbd_keyup(JOY1_A);
						break;
	    
					case JOY_B:
						dckbd_keyup(JOY1_B);
						break;

					case JOY_X:
						mousemng_buttonevent(MOUSEMNG_LEFTUP);
						break;

					case JOY_Y:
						mousemng_buttonevent(MOUSEMNG_RIGHTUP);
						break;
					}
				}
				break;
	
			case EVENT_QUIT:
				__dc_avail = false;
				break;
			}
		}
	}


	if (__skbd_avail) {

		dc_joyinput = 0;

		int button = 0;
    
		if (cJoy) {
			repeatTime = Timer() + USEC_TO_TIMER(1000000/60*30);
			pJoy = cJoy;
			button = cJoy;
		} else if (repeatTime < Timer()) {

			button = pJoy;
			repeatTime = Timer() + USEC_TO_TIMER(1000000/60*10);
		}

		softkbddc_send(button);

	} else
		getJoyButton(JOYSTICKID1, &dc_joyinput);

	if (sys_updates & (SYS_UPDATECFG | SYS_UPDATEOSCFG)) {
		initsave();
		sysmng_initialize();
	}

	switch (cmd) {
	case CMD_MENU:
		sysmenu_menuopen();
		break;
	}

	scrnmng_update();
	softkbddc_draw();
	ta_commit_frame();
  
	return __dc_avail;
}

int main(void)
{
	NP2MAIN np2main;

#ifndef NOSERIAL
	serial_init(57600);
	usleep(20000);
	printf("Serial OK\n");
#endif

	maple_init();
	dc_setup_ta();
	init_arm();
  
	__dc_avail = true;

	dc_savedtimes = 0;
	dc_joyinput = 0;

	dc_mouseaxis1 = 0;
	dc_mouseaxis2 = 0;

	ui_init();
  
	dosio_init();
	file_setcd(modulefile);
	initload();

	TRACEINIT();

	keystat_initialize();
	mousemng_initialize();
	
	scrnmng_initialize();

	UINT8 scrnmode = 0;

	if (scrnmng_create(scrnmode)  != SUCCESS) {
		return -1;
	}

	softkbddc_initialize();

	dckbd_bindinit();
	dckbd_bindcur(np2oscfg.bindcur);
	dckbd_bindbtn(np2oscfg.bindbtn);
  
	soundmng_initialize();
  
	commng_initialize();
	sysmng_initialize();
	taskmng_initialize();

	joymng_initialize();
	pccore_init();
	S98_init();

	pccore_reset();
	scrndraw_redraw();

	np2main.uFrameCount = 0;
	np2main.uWaitCount = 0;
	np2main.uFrameMax = 1;

#if 0
	if (np2oscfg.resume) {
		id = flagload(str_sav, str_resume, FALSE);
		if (id == DID_CANCEL) {
			DestroyWindow(hWnd);
			goto np2main_err4;
		}
	}
#endif
	
	while (dcsys_task()) {
		if (np2oscfg.NOWAIT) {
			exec1frame(np2main);

			if (np2oscfg.DRAW_SKIP) {
				// nowait frame skip
				if (np2main.uFrameCount >= np2oscfg.DRAW_SKIP) {
					processwait(np2main, 0);
				}
			} else {
				// nowait auto skip
				if (timing_getcount()) {
					processwait(np2main, 0);
				}
			}
		} else if (np2oscfg.DRAW_SKIP) {
			// frame skip
			if (np2main.uFrameCount < np2oscfg.DRAW_SKIP) {
				exec1frame(np2main);
			} else {
				processwait(np2main, np2oscfg.DRAW_SKIP);
			}
		} else {
			// auto skip
			if (!np2main.uWaitCount) {
				exec1frame(np2main);
				const UINT uCount = timing_getcount();
				if (np2main.uFrameCount > uCount) {
					np2main.uWaitCount = np2main.uFrameCount;
					if (np2main.uFrameMax > 1) {
						np2main.uFrameMax--;
					}
				} else if (np2main.uFrameCount >= np2main.uFrameMax) {
					if (np2main.uFrameMax < MAX_FRAMESKIP) {
						np2main.uFrameMax++;
					}
					if (uCount >= MAX_FRAMESKIP) {
						timing_reset();
					} else {
						timing_setcount(uCount - np2main.uFrameCount);
					}
					framereset(np2main, 0);
				}
			} else {
				processwait(np2main, np2main.uWaitCount);
				np2main.uWaitCount = np2main.uFrameCount;
			}
		}
	}

	pccore_cfgupdate();
#if 0	
	if (np2oscfg.resume) {
		flagsave(str_sav);
	}
	else {
		flagdelete(str_sav);
	}
#endif
	pccore_term();
	S98_trash();
	scrnmng_destroy();

	if (sys_updates & (SYS_UPDATECFG | SYS_UPDATEOSCFG)) {
		initsave();
	}
	TRACETERM();
	dosio_term();

#ifdef NOSERIAL
	(*(void(**)(int))0x8c0000e0)(1);
	while (1) { }
#endif
	
	return 0;
}

