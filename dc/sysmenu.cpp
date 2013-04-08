#include "compiler.h"
#include "strres.h"
#include "np2.h"
#include "fontmng.h"
#include "scrnmng.h"
#include "sysmng.h"
#include "taskmng.h"
#include "dckbd.h"
#include "pccore.h"
#include "iocore.h"
#include "pc9861k.h"
#include "mpu98ii.h"
#include "sound.h"
#include "beep.h"
#include "diskdrv.h"
#include "keystat.h"
#include "soundmng.h"
#include "sysmenu.h"
#include "sysmenu.res"
#include "sysmenu.str"
#include "filesel.h"
#include "dlgcfg.h"
#include "dlgscr.h"
#include "dlgabout.h"
#include "dcsys.h"
#include "event.h"
#include "ui.h"
#include <ronin/ronin.h>



static void sys_cmd(MENUID id) {

	UINT	update;

	update = 0;
	switch(id) {
	case MID_RESET:
		pccore_cfgupdate();
		pccore_reset();
		break;

	case MID_CONFIG:
		dlgcfg();
		break;

	case MID_CHANGEFONT:
		file_browser(0xff, FONT_FILE);
		break;
					  
	case MID_FDD1OPEN:
		file_browser(0, FDD_FILE);
		break;

	case MID_FDD1EJECT:
		diskdrv_setfdd(0, NULL, 0);
		break;

	case MID_FDD2OPEN:
		file_browser(1, FDD_FILE);
		break;

	case MID_FDD2EJECT:
		diskdrv_setfdd(1, NULL, 0);
		break;

	case MID_SASI1OPEN:
		file_browser(0x00, HDD_FILE);
		break;

	case MID_SASI1EJECT:
		diskdrv_sethdd(0x00, NULL);
		break;

	case MID_SASI2OPEN:
		file_browser(0x01, HDD_FILE);
		break;

	case MID_SASI2EJECT:
		diskdrv_sethdd(0x01, NULL);
		break;
#if defined(SUPPORT_SCSI)
	case MID_SCSI0OPEN:
		filesel_hdd(0x20);
		break;

	case MID_SCSI0EJECT:
		diskdrv_sethdd(0x20, NULL);
		break;

	case MID_SCSI1OPEN:
		filesel_hdd(0x21);
		break;

	case MID_SCSI1EJECT:
		diskdrv_sethdd(0x21, NULL);
		break;

	case MID_SCSI2OPEN:
		filesel_hdd(0x22);
		break;

	case MID_SCSI2EJECT:
		diskdrv_sethdd(0x22, NULL);
		break;

	case MID_SCSI3OPEN:
		filesel_hdd(0x23);
		break;

	case MID_SCSI3EJECT:
		diskdrv_sethdd(0x23, NULL);
		break;
#endif
#if 0
	case MID_ROLNORMAL:
		scrnmode = 0;
		break;

	case MID_ROLLEFT:
		scrnmode = 1;
		break;

	case MID_ROLRIGHT:
		scrnmode = 2;
		break;
#endif
			
	case MID_DISPSYNC:
		np2cfg.DISPSYNC ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_RASTER:
		np2cfg.RASTER ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_NOWAIT:
		np2oscfg.NOWAIT ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_AUTOFPS:
		np2oscfg.DRAW_SKIP = 0;
		update |= SYS_UPDATECFG;
		break;

	case MID_60FPS:
		np2oscfg.DRAW_SKIP = 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_30FPS:
		np2oscfg.DRAW_SKIP = 2;
		update |= SYS_UPDATECFG;
		break;

	case MID_20FPS:
		np2oscfg.DRAW_SKIP = 3;
		update |= SYS_UPDATECFG;
		break;

	case MID_15FPS:
		np2oscfg.DRAW_SKIP = 4;
		update |= SYS_UPDATECFG;
		break;

	case MID_SCREENOPT:
		dlgscr();
		break;

	case MID_CURDEF:
		dckbd_bindcur(0);
		np2oscfg.bindcur = 0;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_CUR1:
		dckbd_bindcur(1);
		np2oscfg.bindcur = 1;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_CUR2:
		dckbd_bindcur(2);
		np2oscfg.bindcur = 2;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_BTNDEF:
		dckbd_bindbtn(0);
		np2oscfg.bindbtn = 0;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_BTN1:
		dckbd_bindbtn(1);
		np2oscfg.bindbtn = 1;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_BTN2:
		dckbd_bindbtn(2);
		np2oscfg.bindbtn = 2;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_KEY:
		np2cfg.KEY_MODE = 0;
		keystat_resetjoykey();
		update |= SYS_UPDATECFG;
		break;

	case MID_JOY1:
		np2cfg.KEY_MODE = 1;
		keystat_resetjoykey();
		update |= SYS_UPDATECFG;
		break;

	case MID_JOY2:
		np2cfg.KEY_MODE = 2;
		keystat_resetjoykey();
		update |= SYS_UPDATECFG;
		break;

	case MID_MOUSEKEY:
		np2cfg.KEY_MODE = 3;
		keystat_resetjoykey();
		update |= SYS_UPDATECFG;
		break;

	case MID_XSHIFT:
		np2cfg.XSHIFT ^= 1;
		keystat_forcerelease(0x70);
		update |= SYS_UPDATECFG;
		break;

	case MID_XCTRL:
		np2cfg.XSHIFT ^= 2;
		keystat_forcerelease(0x74);
		update |= SYS_UPDATECFG;
		break;

	case MID_XGRPH:
		np2cfg.XSHIFT ^= 4;
		keystat_forcerelease(0x73);
		update |= SYS_UPDATECFG;
		break;

	case MID_F12MOUSE:
		np2oscfg.F12KEY = 0;
		dckbd_resetf12();
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_F12COPY:
		np2oscfg.F12KEY = 1;
		dckbd_resetf12();
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_F12STOP:
		np2oscfg.F12KEY = 2;
		dckbd_resetf12();
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_F12EQU:
		np2oscfg.F12KEY = 3;
		dckbd_resetf12();
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_F12COMMA:
		np2oscfg.F12KEY = 4;
		dckbd_resetf12();
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_BEEPOFF:
		np2cfg.BEEP_VOL = 0;
		beep_setvol(0);
		update |= SYS_UPDATECFG;
		break;

	case MID_BEEPLOW:
		np2cfg.BEEP_VOL = 1;
		beep_setvol(1);
		update |= SYS_UPDATECFG;
		break;

	case MID_BEEPMID:
		np2cfg.BEEP_VOL = 2;
		beep_setvol(2);
		update |= SYS_UPDATECFG;
		break;

	case MID_BEEPHIGH:
		np2cfg.BEEP_VOL = 3;
		beep_setvol(3);
		update |= SYS_UPDATECFG;
		break;

	case MID_NOSOUND:
		np2cfg.SOUND_SW = 0x00;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_14:
		np2cfg.SOUND_SW = 0x01;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_26K:
		np2cfg.SOUND_SW = 0x02;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_86:
		np2cfg.SOUND_SW = 0x04;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_26_86:
		np2cfg.SOUND_SW = 0x06;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_86_CB:
		np2cfg.SOUND_SW = 0x14;
		update |= SYS_UPDATECFG;
		break;

	case MID_PC9801_118:
		np2cfg.SOUND_SW = 0x08;
		update |= SYS_UPDATECFG;
		break;

	case MID_SPEAKBOARD:
		np2cfg.SOUND_SW = 0x20;
		update |= SYS_UPDATECFG;
		break;

	case MID_SPARKBOARD:
		np2cfg.SOUND_SW = 0x40;
		update |= SYS_UPDATECFG;
		break;

	case MID_AMD98:
		np2cfg.SOUND_SW = 0x80;
		update |= SYS_UPDATECFG;
		break;

	case MID_JASTSND:
		np2oscfg.jastsnd ^= 1;
		update |= SYS_UPDATEOSCFG;
		break;

	case MID_SEEKSND:
		np2cfg.MOTOR ^= 1;
		update |= SYS_UPDATECFG;
		break;
#if 0
	case IDM_SNDOPT:
		break;
#endif

	case MID_MEM640:
		np2cfg.EXTMEM = 0;
		update |= SYS_UPDATECFG;
		break;

	case MID_MEM16:
		np2cfg.EXTMEM = 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_MEM36:
		np2cfg.EXTMEM = 3;
		update |= SYS_UPDATECFG;
		break;

	case MID_MEM76:
		np2cfg.EXTMEM = 7;
		update |= SYS_UPDATECFG;
		break;
#if 0
	case IDM_MOUSE:
		mousemng_toggle(MOUSEPROC_SYSTEM);
		xmenu_setmouse(np2oscfg.MOUSE_SW ^ 1);
		update |= SYS_UPDATECFG;
		break;

	case IDM_SERIAL1:
		winuienter();
		dialog_serial(hWnd);
		winuileave();
		break;

	case IDM_MPUPC98:
		winuienter();
		DialogBox(hInst, MAKEINTRESOURCE(IDD_MPUPC98),
				  hWnd, (DLGPROC)MidiDialogProc);
		winuileave();
		break;
#endif
	case MID_MIDIPANIC:
		rs232c_midipanic();
		mpu98ii_midipanic();
		pc9861k_midipanic();
		break;

	case MID_BMPSAVE:
		break;

#if 0
	case IDM_S98LOGGING:
		winuienter();
		dialog_s98(hWnd);
		winuileave();
		break;

	case IDM_DISPCLOCK:
		xmenu_setdispclk(np2oscfg.DISPCLK ^ 1);
		update |= SYS_UPDATECFG;
		break;

	case IDM_DISPFRAME:
		xmenu_setdispclk(np2oscfg.DISPCLK ^ 2);
		update |= SYS_UPDATECFG;
		break;

	case IDM_CALENDAR:
		winuienter();
		DialogBox(hInst, MAKEINTRESOURCE(IDD_CALENDAR),
				  hWnd, (DLGPROC)ClndDialogProc);
		winuileave();
		break;

	case IDM_ALTENTER:
		xmenu_setshortcut(np2oscfg.shortcut ^ 1);
		update |= SYS_UPDATECFG;
		break;

	case IDM_ALTF4:
		xmenu_setshortcut(np2oscfg.shortcut ^ 2);
		update |= SYS_UPDATECFG;
		break;
#endif
	case MID_JOYX:
		np2cfg.BTN_MODE ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_RAPID:
		np2cfg.BTN_RAPID ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_MSRAPID:
		np2cfg.MOUSERAPID ^= 1;
		update |= SYS_UPDATECFG;
		break;

	case MID_ABOUT:
		dlgabout();
		break;
			  
	case MID_EXIT:
		taskmng_exit();
		break;
	}
	sysmng_update(update);
}


// ----

struct Menu {
	const OEMCHAR	*string;
	const MSYSITEM *child;
	MENUID	id;
	float x,y;
	int r, g, b;
};

int create_menu(Menu *dst, const MSYSITEM *src)
{
	int i;
	int n;
	float x,y;

	y = 0;
	n = 0;
	i = 0;
	for (;;) {
    
		if (src[i].string != NULL) {
      
			int len = strlen(src[i].string);
			x = (MAX_MENU_SIZE - len * ui_font_width()) / 2;
      
			dst[n].id = src[i].id;
			dst[n].string = src[i].string;
			dst[n].child = src[i].child;
			dst[n].x = x;
			dst[n].y = y;

			if (src[i].flag & MENU_GRAY) {
				dst[n].r = 0xa9;
				dst[n].g = 0xa9;
				dst[n].b = 0xa9;
			} else {
				dst[n].r = 255;
				dst[n].g = 255;
				dst[n].b = 255;
			}

			y += ui_font_height() + 5;

			++n;
		}
    
		if (src[i].flag & MENU_SEPARATOR)
			y += ui_font_height() / 2;
    
		if (src[i].flag & MENU_DELETED)
			break;

		++i;
	}
  
	return n;
}

void setcheck(MENUID arg, float x, float y, MENUID id, int checked)
{
	if (arg == id && checked) {
		draw_pointer(x - ui_font_width(), y, 1);
	}
}

#define MAX_LINK 5
struct Link {
	const MSYSITEM *cur_menu;
	int sel;
};

static const MSYSITEM *cur_menu;
static int menu_index;
Link link_menu[MAX_LINK];

static int main_menu(Menu *menu, int num_items)
{
	int i;
	float x,y;
	float base_width = MAX_MENU_SIZE;
	float base_height = 0;

	UINT8	b;
	MENUID id;

	base_height += (menu[1].y - menu[0].y);
	for (i=0; i<num_items-1; ++i) {
		base_height += (menu[i+1].y - menu[i].y);
	}
  
	int sel = link_menu[menu_index].sel;

	float offx = ui_offx() + (ui_width() - base_width) / 2;
	float offy = ui_offy() + (ui_height() - base_height) / 2;

	int fade = 128;
  
	for (;;) {
		uisys_task();
    
		if (ui_keyrepeat(JOY_UP)) {
			if (--sel < 0)
				sel = num_items - 1;
		} else if (ui_keyrepeat(JOY_DOWN)) {
			if (++sel > (num_items - 1))
				sel = 0;
		}
		if (ui_keypressed(JOY_A)) {

			if (menu[sel].child) {

				link_menu[menu_index].sel = sel;
				++menu_index;
				link_menu[menu_index].cur_menu = menu[sel].child;
				link_menu[menu_index].sel = 0;

				return 0;
			}

			id = menu[sel].id;
			sys_cmd(id);
      
			switch (id) {
			case MID_RESET:
			case MID_EXIT:
				return -1;
			}

		}
    
		if (ui_keypressed(JOY_B)) {
      
			if (--menu_index < 0)
				menu_index = 0;

			if (cur_menu != s_main)
				return 0;
		}

		if (ui_keypressed(JOY_START))
			return -1;

		if ((fade += 255/60) > 255) fade = 128;
      
		tx_resetfont();
      
		scrnmng_update();
		draw_transquad(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, UI_TR, UI_TR, UI_TR, UI_TR);
		draw_transquad(offx, offy, offx + base_width, offy + base_height, UI_BS, UI_BS, UI_BS, UI_BS);

    
		for (i = 0; i < num_items; ++i) {

			y = offy + menu[i].y;
      
			if (i == sel) {
				draw_transquad(offx, y, offx + base_width, y + ui_font_height() + 5, MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade));
			}
      
			x = offx + menu[i].x;
			ui_font_draw(x, y, menu[i].r, menu[i].g, menu[i].b, menu[i].string);

			setcheck(menu[i].id, x, y, MID_DISPSYNC, (np2cfg.DISPSYNC & 1));
			setcheck(menu[i].id, x, y, MID_RASTER, (np2cfg.RASTER & 1));
			setcheck(menu[i].id, x, y, MID_NOWAIT, (np2oscfg.NOWAIT & 1));
			b = np2oscfg.DRAW_SKIP;
			setcheck(menu[i].id, x, y, MID_AUTOFPS, (b == 0));
			setcheck(menu[i].id, x, y, MID_60FPS, (b == 1));
			setcheck(menu[i].id, x, y, MID_30FPS, (b == 2));
			setcheck(menu[i].id, x, y, MID_20FPS, (b == 3));
			setcheck(menu[i].id, x, y, MID_15FPS, (b == 4));
      
			b = np2oscfg.bindcur;
			setcheck(menu[i].id, x, y, MID_CURDEF, (b == 0));
			setcheck(menu[i].id, x, y, MID_CUR1, (b == 1));
			setcheck(menu[i].id, x, y, MID_CUR2, (b == 2));
			b = np2oscfg.bindbtn;
			setcheck(menu[i].id, x, y, MID_BTNDEF, (b == 0));
			setcheck(menu[i].id, x, y, MID_BTN1, (b == 1));
			setcheck(menu[i].id, x, y, MID_BTN2, (b == 2));
#if 0
			setcheck(menu[i].id, x, y, MID_ROLNORMAL, (scrnmode == 0));
			setcheck(menu[i].id, x, y, MID_ROLLEFT, (scrnmode == 1));
			setcheck(menu[i].id, x, y, MID_ROLRIGHT, (scrnmode == 2));
#endif      
			b = np2cfg.KEY_MODE;
			setcheck(menu[i].id, x, y, MID_KEY, (b == 0));
			setcheck(menu[i].id, x, y, MID_JOY1, (b == 1));
			setcheck(menu[i].id, x, y, MID_JOY2, (b == 2));
			setcheck(menu[i].id, x, y, MID_MOUSEKEY, (b == 3));
			b = np2cfg.XSHIFT;
			setcheck(menu[i].id, x, y, MID_XSHIFT, (b & 1));
			setcheck(menu[i].id, x, y, MID_XCTRL, (b & 2));
			setcheck(menu[i].id, x, y, MID_XGRPH, (b & 4));
			b = np2oscfg.F12KEY;
			setcheck(menu[i].id, x, y, MID_F12MOUSE, (b == 0));
			setcheck(menu[i].id, x, y, MID_F12COPY, (b == 1));
			setcheck(menu[i].id, x, y, MID_F12STOP, (b == 2));
			setcheck(menu[i].id, x, y, MID_F12EQU, (b == 3));
			setcheck(menu[i].id, x, y, MID_F12COMMA, (b == 4));
			b = np2cfg.BEEP_VOL & 3;
			setcheck(menu[i].id, x, y, MID_BEEPOFF, (b == 0));
			setcheck(menu[i].id, x, y, MID_BEEPLOW, (b == 1));
			setcheck(menu[i].id, x, y, MID_BEEPMID, (b == 2));
			setcheck(menu[i].id, x, y, MID_BEEPHIGH, (b == 3));
			b = np2cfg.SOUND_SW;
			setcheck(menu[i].id, x, y, MID_NOSOUND, (b == 0x00));
			setcheck(menu[i].id, x, y, MID_PC9801_14, (b == 0x01));
			setcheck(menu[i].id, x, y, MID_PC9801_26K, (b == 0x02));
			setcheck(menu[i].id, x, y, MID_PC9801_86, (b == 0x04));
			setcheck(menu[i].id, x, y, MID_PC9801_26_86, (b == 0x06));
			setcheck(menu[i].id, x, y, MID_PC9801_86_CB, (b == 0x14));
			setcheck(menu[i].id, x, y, MID_PC9801_118, (b == 0x08));
			setcheck(menu[i].id, x, y, MID_SPEAKBOARD, (b == 0x20));
			setcheck(menu[i].id, x, y, MID_SPARKBOARD, (b == 0x40));
			setcheck(menu[i].id, x, y, MID_AMD98, (b == 0x80));
			setcheck(menu[i].id, x, y, MID_JASTSND, (np2oscfg.jastsnd & 1));
			setcheck(menu[i].id, x, y, MID_SEEKSND, (np2cfg.MOTOR & 1));
			b = np2cfg.EXTMEM;
			setcheck(menu[i].id, x, y, MID_MEM640, (b == 0));
			setcheck(menu[i].id, x, y, MID_MEM16, (b == 1));
			setcheck(menu[i].id, x, y, MID_MEM36, (b == 3));
			setcheck(menu[i].id, x, y, MID_MEM76, (b == 7));
			setcheck(menu[i].id, x, y, MID_JOYX, (np2cfg.BTN_MODE & 1));
			setcheck(menu[i].id, x, y, MID_RAPID, (np2cfg.BTN_RAPID & 1));
			setcheck(menu[i].id, x, y, MID_MSRAPID, (np2cfg.MOUSERAPID & 1));
		}
    
		x = ui_offx();
		y = ui_height() - ui_font_height();
    
		if (!menu_index) {
			ui_font_draw(x, y, 255, 255, 255, "A:Select");
		} else {
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Back");
		}
    
		ta_commit_frame();
	}
}

void sysmenu_menuopen()
{
	Menu mainmenu[16];
	int n;

	soundmng_stop();
  
	menu_index = 0;
	link_menu[menu_index].cur_menu = s_main;
	link_menu[menu_index].sel = 0;
  
	for (;;) {
		cur_menu = link_menu[menu_index].cur_menu;
		n = create_menu(mainmenu, cur_menu);

		if (main_menu(mainmenu, n) < 0)
			break;
	}
  
	soundmng_play();
}
