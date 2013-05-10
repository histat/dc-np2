#include "compiler.h"
#include "strres.h"
#include "np2.h"
#include "sysmng.h"
#include "pccore.h"
#include "scrnmng.h"
#include "sysmenu.h"
#include "sysmenu.res"
#include "joymng.h"
#include "dlgsnd.h"
#include "dcsys.h"
#include "event.h"
#include "ui.h"
#include <ronin/ta.h>

enum {
	DID_JOYPAD1 = 0,
	DID_PAD1_1A,
	DID_PAD1_1B,
	DID_PAD1_1C,
	DID_PAD1_1D,
	DID_PAD1_2A,
	DID_PAD1_2B,
	DID_PAD1_2C,
	DID_PAD1_2D,
	DID_PAD1_RA,
	DID_PAD1_RB,
	DID_PAD1_RC,
	DID_PAD1_RD
};

static const OEMCHAR mstr_snd[] = OEMTEXT("Sound board option");

static const OEMCHAR str_joy[] = OEMTEXT("JoyPad");
static const OEMCHAR str_use[] = OEMTEXT("Use JoyPAD-1");
static const OEMCHAR str_trig1[] = OEMTEXT("Trigger-1");
static const OEMCHAR str_trig2[] = OEMTEXT("Trigger-2");
static const OEMCHAR str_ba[] = OEMTEXT("A");
static const OEMCHAR str_bb[] = OEMTEXT("B");
static const OEMCHAR str_bc[] = OEMTEXT("C");
static const OEMCHAR str_bd[] = OEMTEXT("D");
static const OEMCHAR str_rapid[] = OEMTEXT("Rapid");

static const MENUPRM res_snd[] = {
	{DLGTYPE_FRAME,	DID_STATIC,		0, str_joy},
	{DLGTYPE_CHECK,DID_JOYPAD1,		0, str_use},
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_trig1},
	{DLGTYPE_CHECK, DID_PAD1_1A,		0, str_ba},
	{DLGTYPE_CHECK,	DID_PAD1_1B,		0, str_bb},
	{DLGTYPE_CHECK, DID_PAD1_1C,		0, str_bc},
	{DLGTYPE_CHECK, DID_PAD1_1D,		0, str_bd},
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_trig2},
	{DLGTYPE_CHECK, DID_PAD1_2A,		0, str_ba},
	{DLGTYPE_CHECK,	DID_PAD1_2B,		0, str_bb},
	{DLGTYPE_CHECK, DID_PAD1_2C,		0, str_bc},
	{DLGTYPE_CHECK, DID_PAD1_2D,		0, str_bd},
#if 0
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_rapid},
	{DLGTYPE_CHECK, DID_PAD1_RA,		0, str_ba},
	{DLGTYPE_CHECK,	DID_PAD1_RB,		0, str_bb},
	{DLGTYPE_CHECK, DID_PAD1_RC,		0, str_bc},
	{DLGTYPE_CHECK, DID_PAD1_RD,		0, str_bd}
#endif
};

typedef struct {
	UINT16	res;
	UINT16	bit;
	UINT8	*ptr;
} CHECKTBL;

static const CHECKTBL pad1opt[13] = {
			{DID_JOYPAD1, 0, &np2oscfg.JOYPAD1},
			{DID_PAD1_1A, 0, np2oscfg.JOY1BTN + 0},
			{DID_PAD1_1B, 0, np2oscfg.JOY1BTN + 1},
			{DID_PAD1_1C, 0, np2oscfg.JOY1BTN + 2},
			{DID_PAD1_1D, 0, np2oscfg.JOY1BTN + 3},
			{DID_PAD1_2A, 1, np2oscfg.JOY1BTN + 0},
			{DID_PAD1_2B, 1, np2oscfg.JOY1BTN + 1},
			{DID_PAD1_2C, 1, np2oscfg.JOY1BTN + 2},
			{DID_PAD1_2D, 1, np2oscfg.JOY1BTN + 3},
#if 0
			{DID_PAD1_RA, 2, np2oscfg.JOY1BTN + 0},
			{DID_PAD1_RB, 2, np2oscfg.JOY1BTN + 1},
			{DID_PAD1_RC, 2, np2oscfg.JOY1BTN + 2},
			{DID_PAD1_RD, 2, np2oscfg.JOY1BTN + 3}
#endif
};


static int dlg_val[DID_PAD1_RD+1];

static int menudlg_getval(MENUID id)
{
	switch (id) {
    
	case DID_STATIC:
		return 0;

	default:
		return dlg_val[id];
	}
}


static void menudlg_setval(MENUID id, int val)
{
	switch (id) {
    
	case DID_STATIC:
		break;

	default:
		dlg_val[id] = val;
		break;
	}
}

static void dlginit(void)
{
	menudlg_setval(DID_JOYPAD1, np2oscfg.JOYPAD1 & 1);

	menudlg_setval(DID_PAD1_1A, np2oscfg.JOY1BTN[0] & 1);
	menudlg_setval(DID_PAD1_1B, np2oscfg.JOY1BTN[1] & 1);
	menudlg_setval(DID_PAD1_1C, np2oscfg.JOY1BTN[2] & 1);
	menudlg_setval(DID_PAD1_1D, np2oscfg.JOY1BTN[3] & 1);

	menudlg_setval(DID_PAD1_2A, (np2oscfg.JOY1BTN[0] & 2) >> 1);
	menudlg_setval(DID_PAD1_2B, (np2oscfg.JOY1BTN[1] & 2) >> 1);
	menudlg_setval(DID_PAD1_2C, (np2oscfg.JOY1BTN[2] & 2) >> 1);
	menudlg_setval(DID_PAD1_2D, (np2oscfg.JOY1BTN[3] & 2) >> 1);
};

static void dlgupdate(void)
{
	BOOL	renewal;
	int val;

	renewal = FALSE;
	val = menudlg_getval(DID_JOYPAD1);
	if (np2oscfg.JOYPAD1 != (UINT8)val) {
		np2oscfg.JOYPAD1 = (UINT8)val;
		renewal = TRUE;
	}
	
	val = menudlg_getval(DID_PAD1_1A) + (menudlg_getval(DID_PAD1_2A) << 1);
	if (np2oscfg.JOY1BTN[0] != (UINT8)val) {
		np2oscfg.JOY1BTN[0] = (UINT8)val;
		renewal = TRUE;
	}
	val = menudlg_getval(DID_PAD1_1B) + (menudlg_getval(DID_PAD1_2B) << 1);
	if (np2oscfg.JOY1BTN[1] != (UINT8)val) {
		np2oscfg.JOY1BTN[1] = (UINT8)val;
		renewal = TRUE;
	}
	val = menudlg_getval(DID_PAD1_1C) + (menudlg_getval(DID_PAD1_2C) << 1);
	if (np2oscfg.JOY1BTN[2] != (UINT8)val) {
		np2oscfg.JOY1BTN[2] = (UINT8)val;
		renewal = TRUE;
	}
	val = menudlg_getval(DID_PAD1_1D) + (menudlg_getval(DID_PAD1_2D) << 1);
	if (np2oscfg.JOY1BTN[3] != (UINT8)val) {
		np2oscfg.JOY1BTN[3] = (UINT8)val;
		renewal = TRUE;
	}

	if (renewal) {
		joymng_initialize();
		sysmng_update(SYS_UPDATECFG);
	}
}

static void dlg_btn(int id)
{
	switch (id) {
    case DID_PAD1_1A:
	case DID_PAD1_2A:
	case DID_PAD1_RA:
		menudlg_setval(DID_PAD1_1A, 0);
		menudlg_setval(DID_PAD1_2A, 0);
		menudlg_setval(DID_PAD1_RA, 0);
		menudlg_setval(id, 1);
		break;
		
	case DID_PAD1_1B:
	case DID_PAD1_2B:
	case DID_PAD1_RB:
		menudlg_setval(DID_PAD1_1B, 0);
		menudlg_setval(DID_PAD1_2B, 0);
		menudlg_setval(DID_PAD1_RB, 0);
		menudlg_setval(id, 1);
		break;
		
	case DID_PAD1_1C:
	case DID_PAD1_2C:
	case DID_PAD1_RC:
		menudlg_setval(DID_PAD1_1C, 0);
		menudlg_setval(DID_PAD1_2C, 0);
		menudlg_setval(DID_PAD1_RC, 0);
		menudlg_setval(id, 1);
		break;
		
	case DID_PAD1_1D:
	case DID_PAD1_2D:
	case DID_PAD1_RD:
		menudlg_setval(DID_PAD1_1D, 0);
		menudlg_setval(DID_PAD1_2D, 0);
		menudlg_setval(DID_PAD1_RD, 0);
		menudlg_setval(id, 1);
		break;
	}
}

// ---

static int menu_index;

struct Sound {
	int		type;
	MENUID	id;
	const void	*arg;
	float x,y;
	int r, g, b;
};

static int create_menu(Sound *dst)
{
	const MENUPRM *src;
	int cnt;
	float x,y;
	int n;

	n = 0;
	y = 0;

	switch (menu_index) {
	default:
	case 0:
		cnt = sizeof(res_snd)/sizeof(res_snd[0]);
		src = res_snd;
	}

	for (int i = 0; i < cnt; ++i) {
		dst[n].type = src[i].type;
		dst[n].id = src[i].id;

		switch (src[i].id) {
		default:
			dst[n].arg = src[i].arg;
		}

		switch (src[i].type) {
		case DLGTYPE_FRAME:
			x = (MAX_MENU_SIZE - strlen((char*)dst[n].arg) * ui_font_width()) / 2;
			break;
      
		case DLGTYPE_CTEXT:
			x = (MAX_MENU_SIZE - strlen((char*)dst[n].arg) * ui_font_width()) / 2;
			break;
      
		case DLGTYPE_RTEXT:
			x = (MAX_MENU_SIZE - strlen((char*)dst[n].arg) * ui_font_width());
			break;
      
		case DLGTYPE_SLIDER:
			x = ui_font_width() * 2;
			break;

		case DLGTYPE_RADIO:
			x = (MAX_MENU_SIZE - strlen((char*)dst[n].arg) * ui_font_width()) / 2;
			break;
      
		default:
		case DLGTYPE_LTEXT:
			x = ui_font_width() * 2;
		}
    
		dst[n].x = x;
		dst[n].y = y;
		dst[n].r = 255;
		dst[n].g = 255;
		dst[n].b = 255;

		switch (src[i].type) {
      
		case DLGTYPE_SLIDER:
			break;
      
		case DLGTYPE_CHECK:
		case DLGTYPE_RADIO:
			y += ui_font_height() + 5;
			break;

		default:
		case DLGTYPE_FRAME:
		case DLGTYPE_CTEXT:
		case DLGTYPE_RTEXT:
		case DLGTYPE_LTEXT:
			y += ui_font_height() + 5;
		}
    
		++n;
	}
  
	return n;
}

int snd_menu(Sound *menu, int num_items)
{
	float x,y;
	float base_width = MAX_MENU_SIZE;
	float base_height = ((menu[num_items-1].y + ui_font_height()) - menu[0].y);

	int menu_pos;
	char work[32];

	int max_menu = 0;

	base_height += ui_font_height() * 2;
	for (int i = 0; i < num_items; ++i) {
    
		switch (menu[i].type) {
		case DLGTYPE_RADIO:
		case DLGTYPE_CHECK:
		case DLGTYPE_SLIDER:
			++max_menu;
			break;
		}
	}

	int result = -1;
	int id = 0;
	int sel = 0;
#if 0  
	int max_val  = 0;
	int min_val = 0;
	int val_index = 0;
#endif  
	float offx = ui_offx() + (ui_width() - base_width) / 2;
	float offy = ui_offy() + (ui_height() - base_height) / 2;

	int fade = 128;
  
	for (;;) {
		uisys_task();
      
		if (ui_keyrepeat(JOY_UP)) {

			switch (result) {
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				break;
	
			default:
				if (--sel < 0)
					sel = max_menu - 1;
			}
      
		} else if (ui_keyrepeat(JOY_DOWN)) {
      
			switch (result) {
				
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				break;
	
			default:
				if (++sel > (max_menu - 1))
					sel = 0;
			}
		}
#if 0			
		else if (ui_keyrepeat(JOY_RIGHT) || ui_keyrepeat(JOY_RTRIGGER)) {
      
			switch (result) {
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				if (++val_index > max_val)
					val_index = max_val;
				break;
	
			default:
				if (++menu_index > 1) {
					menu_index = 1;
				} else {
					return 0;
				}
			}
		} else if (ui_keyrepeat(JOY_LEFT) || ui_keyrepeat(JOY_LTRIGGER)) {
      
			switch (result) {
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				if (--val_index < min_val)
					val_index = min_val;
				break;
	
			default:
				if (--menu_index < 0) {
					menu_index = 0;
				} else {
					return 0;
				}
			}
		}
#endif
    
		if (ui_keypressed(JOY_A)) {

			switch (id) {

			case DID_JOYPAD1:
				menudlg_setval(id, !menudlg_getval(id));
				break;
				
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				dlg_btn(id);
				break;

			}
		}
    
		if (ui_keypressed(JOY_B)) {

			switch (result) {
			case DID_PAD1_1A:
			case DID_PAD1_1B:
			case DID_PAD1_1C:
			case DID_PAD1_1D:
			case DID_PAD1_2A:
			case DID_PAD1_2B:
			case DID_PAD1_2C:
			case DID_PAD1_2D:
			case DID_PAD1_RA:
			case DID_PAD1_RB:
			case DID_PAD1_RC:
			case DID_PAD1_RD:
				result = -1;
				break;

			default:
				if (result < 0)
					return -1;
			}
		}

		if ((fade += 255/60) > 255) fade = 128;
      
		tx_resetfont();

		scrnmng_update();
		draw_transquad(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, UI_TR, UI_TR, UI_TR, UI_TR);
		draw_transquad(offx, offy, offx + base_width, offy + base_height, UI_BS, UI_BS, UI_BS, UI_BS);
      
		OEMSPRINTF(work, "%s ", mstr_snd);
		x = offx + (base_width - strlen(work) * ui_font_width()) / 2;
		y = offy;
		ui_font_draw(x, y, 255, 255, 255, work);

		y += ui_font_height();
		x = offx;

		draw_transquad(offx, y, offx + base_width, y + 1, MAKECOL32(128, 128, 128, 255),
					   MAKECOL32(128, 128, 128, 255), MAKECOL32(128, 128, 128, 255), MAKECOL32(128, 128, 128, 255));

		y += 6;

		menu_pos = 0;
		for (int i = 0; i < num_items; ++i) {
			
			int r = menu[i].r;
			int g = menu[i].g;
			int b = menu[i].b;
      
			switch (menu[i].type) {
	  
			case DLGTYPE_RADIO:
			case DLGTYPE_CHECK:
				if (menu_pos == sel) {

					draw_transquad(offx, y + menu[i].y, offx + base_width, y + menu[i].y + ui_font_height() + 5, MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade));

					id = menu[i].id;
				}


				switch (menu[i].id) {
	    
				default:
					if (menudlg_getval(menu[i].id))
						draw_pointer(x + menu[i].x - ui_font_width(), y + menu[i].y, 1);
				}
				ui_font_draw(x + menu[i].x, y + menu[i].y, r, g, b, (const char *)menu[i].arg);
				++menu_pos;
				break;
			}
		}
    
		for (int i = 0; i < num_items; ++i) {
      
			switch (menu[i].type) {
	
			case DLGTYPE_FRAME:
			case DLGTYPE_LTEXT:
			case DLGTYPE_RTEXT:
				ui_font_draw(x + menu[i].x, y + menu[i].y, menu[i].r, menu[i].g, menu[i].b, (const char *)menu[i].arg);
				break;
			}
		}

		x = ui_offx();
		y = ui_height() - ui_font_height();
    
		switch (result) {
		default:
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Back");
		}
		
		ta_commit_frame();
	}
}


void dlgsnd()
{
	Sound sndmenu[sizeof(res_snd)/sizeof(res_snd[0])];
	int n;

	menu_index = 0;
	memset(dlg_val, 0, sizeof(dlg_val));
  
	dlginit();

	for (;;) {
		n = create_menu(sndmenu);

		if (snd_menu(sndmenu, n) < 0)
			break;
	}

	dlgupdate();
}
