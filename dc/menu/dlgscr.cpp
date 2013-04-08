#include "compiler.h"
#include "strres.h"
#include "scrnmng.h"
#include "sysmng.h"
#include "pccore.h"
#include "iocore.h"
#include "scrndraw.h"
#include "palettes.h"
#include "sysmenu.h"
#include "sysmenu.res"
#include "dlgscr.h"
#include "dcsys.h"
#include "event.h"
#include "ui.h"
#include <ronin/ta.h>




enum {
	DID_LCD = 0,
	DID_LCDX,
	DID_SKIPLINE,
	DID_SKIPLIGHT,
	DID_LIGHTSTR,
	DID_GDC7220,
	DID_GDC72020,
	DID_GRCGNON,
	DID_GRCG,
	DID_GRCG2,
	DID_EGC,
	DID_PC980124,
	DID_TRAMWAIT,
	DID_TRAMSTR,
	DID_VRAMWAIT,
	DID_VRAMSTR,
	DID_GRCGWAIT,
	DID_GRCGSTR,
	DID_REALPAL,
	DID_REALPALSTR
};

static const OEMCHAR mstr_scropt[] = OEMTEXT("Screen Option");

static const OEMCHAR str_video[] = OEMTEXT("Video");
static const OEMCHAR str_lcd[] = OEMTEXT("Liquid Crystal Display");
static const OEMCHAR str_lcdx[] = OEMTEXT("Reverse");
static const OEMCHAR str_skipline[] = OEMTEXT("Use skipline revisions");
static const OEMCHAR str_skiplght[] = OEMTEXT("Ratio");

static const OEMCHAR str_chip[] = OEMTEXT("Chip");
static const OEMCHAR str_gdc[] = OEMTEXT("GDC");
static const OEMCHAR str_gdc0[] = OEMTEXT("uPD7220");
static const OEMCHAR str_gdc1[] = OEMTEXT("uPD72020");
static const OEMCHAR str_grcg[] = OEMTEXT("Graphic Charger");
static const OEMCHAR str_grcg0[] = OEMTEXT("None");
static const OEMCHAR str_grcg1[] = OEMTEXT("GRCG");
static const OEMCHAR str_grcg2[] = OEMTEXT("GRCG+");
static const OEMCHAR str_grcg3[] = OEMTEXT("EGC");
static const OEMCHAR str_pc980124[] = OEMTEXT("Enable 16color (PC-9801-24)");

static const OEMCHAR str_timing[] = OEMTEXT("Timing");
static const OEMCHAR str_tram[] = OEMTEXT("T-RAM");
static const OEMCHAR str_vram[] = OEMTEXT("V-RAM");
static const OEMCHAR str_clock[] = OEMTEXT("clock");
static const OEMCHAR str_realpal[] = OEMTEXT("RealPalettes Adjust");

static const MENUPRM res_scr1[] = {
	{DLGTYPE_CHECK,		DID_LCD,		0, str_lcd},
	{DLGTYPE_CHECK,		DID_LCDX,		0, str_lcdx},
	{DLGTYPE_CHECK,		DID_SKIPLINE,		0, str_skipline},
	{DLGTYPE_LTEXT,		DID_STATIC,		0, str_skiplght},
	{DLGTYPE_SLIDER,		DID_SKIPLIGHT,		0, (void *)SLIDERPOS(0, 255)},
	{DLGTYPE_RTEXT,		DID_LIGHTSTR,		0,	 NULL}};

static const MENUPRM res_scr2[] = {
	{DLGTYPE_FRAME,		DID_STATIC,		0, str_gdc},
	{DLGTYPE_RADIO,		DID_GDC7220,		0, str_gdc0},
	{DLGTYPE_RADIO,		DID_GDC72020,		0, str_gdc1},
	{DLGTYPE_FRAME,		DID_STATIC,		0, str_grcg},
	{DLGTYPE_RADIO,		DID_GRCGNON,		0, str_grcg0},
	{DLGTYPE_RADIO,		DID_GRCG,		0, str_grcg1},
	{DLGTYPE_RADIO,		DID_GRCG2,		0, str_grcg2},
	{DLGTYPE_RADIO,		DID_EGC,		0, str_grcg3},
	{DLGTYPE_CHECK,		DID_PC980124,		0, str_pc980124}};

static const MENUPRM res_scr3[] = {
	{DLGTYPE_LTEXT,		DID_STATIC,		0, str_tram},
	{DLGTYPE_SLIDER,	DID_TRAMWAIT,			0, (void *)SLIDERPOS(0, 48)},
	{DLGTYPE_RTEXT,	DID_TRAMSTR,			0, NULL},
	{DLGTYPE_LTEXT,		DID_STATIC,		0, str_vram},
	{DLGTYPE_SLIDER,	DID_VRAMWAIT,			0, (void *)SLIDERPOS(0, 48)},
	{DLGTYPE_RTEXT,	DID_VRAMSTR,			0, NULL},
	{DLGTYPE_LTEXT,		DID_STATIC,		0, str_grcg1},
	{DLGTYPE_SLIDER,	DID_GRCGWAIT,			0, (void *)SLIDERPOS(0, 48)},
	{DLGTYPE_RTEXT,		DID_GRCGSTR,		0, NULL},
	{DLGTYPE_LTEXT,		DID_STATIC,		0, str_realpal},
	{DLGTYPE_SLIDER,	DID_REALPAL,			0, (void *)SLIDERPOS(32, 64)},
	{DLGTYPE_RTEXT,		DID_REALPALSTR,		0, NULL}};



static int dlg_val[DID_REALPAL+1];

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

static OEMCHAR	skipstr[16];
static OEMCHAR	tramstr[16];
static OEMCHAR	vramstr[16];
static OEMCHAR	grcgstr[16];
static OEMCHAR	realpalstr[16];

// ---

static void setintstr(MENUID id, int val) {

	OEMCHAR	buf[16];

	OEMSPRINTF(buf, str_d, val);

	switch (id) {
    
	case DID_LIGHTSTR:
		milstr_ncpy(skipstr, buf, NELEMENTS(skipstr));
		break;
    
	case DID_TRAMSTR:
		milstr_ncpy(tramstr, buf, NELEMENTS(tramstr));
		break;

	case DID_VRAMSTR:
		milstr_ncpy(vramstr, buf, NELEMENTS(vramstr));
		break;

	case DID_GRCGSTR:
		milstr_ncpy(grcgstr, buf, NELEMENTS(grcgstr));
		break;

	case DID_REALPALSTR:
		milstr_ncpy(realpalstr, buf, NELEMENTS(realpalstr));
		break;
	}
}

static const MENUID gdcchip[4] = {DID_GRCGNON, DID_GRCG, DID_GRCG2, DID_EGC};

static void dlginit(void)
{
	menudlg_setval(DID_LCD, np2cfg.LCD_MODE & 1);
	menudlg_setval(DID_LCDX, np2cfg.LCD_MODE & 2);
	menudlg_setval(DID_SKIPLINE, np2cfg.skipline);
	menudlg_setval(DID_SKIPLIGHT, np2cfg.skiplight);
	setintstr(DID_LIGHTSTR, np2cfg.skiplight);

	if (!np2cfg.uPD72020) {
		menudlg_setval(DID_GDC7220, TRUE);
	}
	else {
		menudlg_setval(DID_GDC72020, TRUE);
	}
	menudlg_setval(gdcchip[np2cfg.grcg & 3], TRUE);
	menudlg_setval(DID_PC980124, np2cfg.color16);

	menudlg_setval(DID_TRAMWAIT, np2cfg.wait[0]);
	setintstr(DID_TRAMSTR, np2cfg.wait[0]);
	menudlg_setval(DID_VRAMWAIT, np2cfg.wait[2]);
	setintstr(DID_VRAMSTR, np2cfg.wait[2]);
	menudlg_setval(DID_GRCGWAIT, np2cfg.wait[4]);
	setintstr(DID_GRCGSTR, np2cfg.wait[4]);
	menudlg_setval(DID_REALPAL, np2cfg.realpal);
	setintstr(DID_REALPALSTR, np2cfg.realpal);
}

static void dlgupdate(void)
{
	UINT	update;
	BOOL	renewal;
	UINT	val;
	UINT8	value[6];

	update = 0;
	renewal = FALSE;
	val = menudlg_getval(DID_SKIPLINE);
	if (np2cfg.skipline != (UINT8)val) {
		np2cfg.skipline = (UINT8)val;
		renewal = TRUE;
	}
	val = menudlg_getval(DID_SKIPLIGHT);
	if (val > 255) {
		val = 255;
	}
	if (np2cfg.skiplight != (UINT16)val) {
		np2cfg.skiplight = (UINT16)val;
		renewal = TRUE;
	}
	if (renewal) {
		pal_makeskiptable();
	}
	val = menudlg_getval(DID_LCD) + (menudlg_getval(DID_LCDX) << 1);
	if (np2cfg.LCD_MODE != (UINT8)val) {
		np2cfg.LCD_MODE = (UINT8)val;
		pal_makelcdpal();
		renewal = TRUE;
	}
	if (renewal) {
		scrndraw_redraw();
		update |= SYS_UPDATECFG;
	}

	val = menudlg_getval(DID_GDC72020);
	if (np2cfg.uPD72020 != (UINT8)val) {
		np2cfg.uPD72020 = (UINT8)val;
		update |= SYS_UPDATECFG;
		gdc_restorekacmode();
		gdcs.grphdisp |= GDCSCRN_ALLDRAW2;
	}
	for (val=0; (val<3) && (!menudlg_getval(gdcchip[val])); val++) { }
	if (np2cfg.grcg != (UINT8)val) {
		np2cfg.grcg = (UINT8)val;
		update |= SYS_UPDATECFG;
		gdcs.grphdisp |= GDCSCRN_ALLDRAW2;
	}
	val = menudlg_getval(DID_PC980124);
	if (np2cfg.color16 != (UINT8)val) {
		np2cfg.color16 = (UINT8)val;
		update |= SYS_UPDATECFG;
	}

	ZeroMemory(value, sizeof(value));
	value[0] = (UINT8)menudlg_getval(DID_TRAMWAIT);
	if (value[0]) {
		value[1] = 1;
	}
	value[2] = (UINT8)menudlg_getval(DID_VRAMWAIT);
	if (value[2]) {
		value[3] = 1;
	}
	value[4] = (UINT8)menudlg_getval(DID_GRCGWAIT);
	if (value[4]) {
		value[5] = 1;
	}
	for (val=0; val<6; val++) {
		if (np2cfg.wait[val] != value[val]) {
			np2cfg.wait[val] = value[val];
			update |= SYS_UPDATECFG;
		}
	}
	val = menudlg_getval(DID_REALPAL);
	if (np2cfg.realpal != (UINT8)val) {
		np2cfg.realpal = (UINT8)val;
		update |= SYS_UPDATECFG;
	}
	sysmng_update(update);
}


// ---

static int menu_index;

struct Screen {
	int		type;
	MENUID	id;
	const void	*arg;
	float x,y;
	int r, g, b;
};

static int create_menu(Screen *dst)
{
	const MENUPRM *src;
	int cnt;
	float x,y;
	int n;

	n = 0;
	y = 0;

	switch (menu_index) {
	case 2:
		cnt = sizeof(res_scr3)/sizeof(res_scr3[0]);
		src = res_scr3;
		break;
    
	case 1:
		cnt = sizeof(res_scr2)/sizeof(res_scr2[0]);
		src = res_scr2;
		break;

	default:
	case 0:
		cnt = sizeof(res_scr1)/sizeof(res_scr1[0]);
		src = res_scr1;
	}

	for (int i = 0; i < cnt; ++i) {
		dst[n].type = src[i].type;
		dst[n].id = src[i].id;

		switch (src[i].id) {
		case DID_LIGHTSTR:
			dst[n].arg = (void *)skipstr;
			break;
	
		case DID_TRAMSTR:
			dst[n].arg = (void *)tramstr;
			break;
	
		case DID_VRAMSTR:
			dst[n].arg = (void *)vramstr;
			break;

		case DID_GRCGSTR:
			dst[n].arg = (void *)grcgstr;
			break;

		case DID_REALPALSTR:
			dst[n].arg = (void *)realpalstr;
			break;

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

void dlg_gdc(int id)
{
	switch (id) {
    
	case DID_GDC7220:
	case DID_GDC72020:
		menudlg_setval(DID_GDC7220, 0);
		menudlg_setval(DID_GDC72020, 0);
		menudlg_setval(id, 1);
	}
}

void dlg_grcg(int id)
{
	switch (id) {
    
	case DID_GRCGNON:
	case DID_GRCG:
	case DID_GRCG2:
	case DID_EGC:
		menudlg_setval(DID_GRCGNON, 0);
		menudlg_setval(DID_GRCG, 0);
		menudlg_setval(DID_GRCG2, 0);
		menudlg_setval(DID_EGC, 0);
		menudlg_setval(id, 1);
	}
}

void dlg_set(int id)
{
	switch (id) {
    
	case DID_SKIPLIGHT:
		setintstr(DID_LIGHTSTR, menudlg_getval(id));
		break;
      
	case DID_TRAMWAIT:
		setintstr(DID_TRAMSTR, menudlg_getval(id));
		break;
      
	case DID_VRAMWAIT:
		setintstr(DID_VRAMSTR, menudlg_getval(id));
		break;
    
	case DID_GRCGWAIT:
		setintstr(DID_GRCGSTR, menudlg_getval(id));
		break;
    
	case DID_REALPAL:
		setintstr(DID_REALPALSTR, menudlg_getval(id));
		break;
	}
}

int scr_menu(Screen *menu, int num_items)
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
  
	int max_val  = 0;
	int min_val = 0;
	int val_index = 0;
  
	float offx = ui_offx() + (ui_width() - base_width) / 2;
	float offy = ui_offy() + (ui_height() - base_height) / 2;

	int fade = 128;
  
	for (;;) {
		uisys_task();
      
		if (ui_keyrepeat(JOY_UP)) {

			switch (result) {
	
			case DID_SKIPLIGHT:
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
				break;
	
			default:
				if (--sel < 0)
					sel = max_menu - 1;
			}
      
		} else if (ui_keyrepeat(JOY_DOWN)) {
      
			switch (result) {
	
			case DID_SKIPLIGHT:
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
				break;
	
			default:
				if (++sel > (max_menu - 1))
					sel = 0;
			}
		} else if (ui_keyrepeat(JOY_RIGHT) || ui_keyrepeat(JOY_RTRIGGER)) {
      
			switch (result) {
	
			case DID_SKIPLIGHT:
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
				if (++val_index > max_val)
					val_index = max_val;
				break;
	
			default:
				if (++menu_index > 2) {
					menu_index = 2;
				} else {
					return 0;
				}
			}
		} else if (ui_keyrepeat(JOY_LEFT) || ui_keyrepeat(JOY_LTRIGGER)) {
      
			switch (result) {
	
			case DID_SKIPLIGHT:
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
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
    
		if (ui_keypressed(JOY_A)) {

			switch (id) {
	
			case DID_LCD:
			case DID_SKIPLINE:
				menudlg_setval(id, !menudlg_getval(id));
				break;
	
			case DID_GDC7220:
			case DID_GDC72020:
				dlg_gdc(id);
				break;
	
			case DID_GRCGNON:
			case DID_GRCG:
			case DID_GRCG2:
			case DID_EGC:
				dlg_grcg(id);
				break;
      
			case DID_PC980124:
				menudlg_setval(id, !menudlg_getval(id));
				break;
	
			case DID_LCDX:
				if (menudlg_getval(DID_LCD))
					menudlg_setval(id, !menudlg_getval(id));
				break;

			case DID_SKIPLIGHT:
				if (menudlg_getval(DID_SKIPLINE)) {
					if (result == id) {
						menudlg_setval(id, val_index);
						dlg_set(id);
						result = -1;
					} else {
						val_index = menudlg_getval(id);
						result = id;
					}
				}
				break;
	
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
				if (result == id) {
					menudlg_setval(id, val_index);
					dlg_set(id);
					result = -1;
				} else {
					val_index = menudlg_getval(id);
					result = id;
				}
				break;
			}
		}
    
		if (ui_keypressed(JOY_B)) {

			switch (result) {
	
			case DID_SKIPLIGHT:
			case DID_TRAMWAIT:
			case DID_VRAMWAIT:
			case DID_GRCGWAIT:
			case DID_REALPAL:
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
      
		OEMSPRINTF(work, "%s (%d/%d)", str_video, menu_index+1, 3);
		x = offx + (base_width - strlen(work) * ui_font_width()) / 2;
		y = offy;
		ui_font_draw(x, y, 255, 255, 255, work);
    
		if (menu_index != 0)
			draw_pointer(offx + ui_font_width(), y, 0);
    
		if (menu_index != 2)
			draw_pointer(offx + base_width - ui_font_width(), y, 1);

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
	    
				case DID_LCDX:
					if (menudlg_getval(DID_LCD)) {
	    
						if (menudlg_getval(menu[i].id))
							draw_pointer(x + menu[i].x - ui_font_width(), y + menu[i].y, 1);
					} else {
						r = 0xa9;
						g = 0xa9;
						b = 0xa9;
					}
					break;
	  
				default:
					if (menudlg_getval(menu[i].id))
						draw_pointer(x + menu[i].x - ui_font_width(), y + menu[i].y, 1);
				}
				ui_font_draw(x + menu[i].x, y + menu[i].y, r, g, b, (const char *)menu[i].arg);
				++menu_pos;
				break;
	
			case DLGTYPE_SLIDER:
				if (menu_pos == sel) {
					draw_transquad(offx, y + menu[i].y, offx + base_width, y + menu[i].y + ui_font_height() + 5, MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade));

					id = menu[i].id;
				}
	
				if (result == menu[i].id) {
					const void *arg = menu[i].arg;
	  
					min_val = (SINT16)(long)arg;
					max_val = (SINT16)((long)arg >> 16);
	  
					menu[i].x = (MAX_MENU_SIZE - strlen(work) * ui_font_width()) / 2;
	  
					if (val_index != min_val)
						draw_pointer(x + menu[i].x - ui_font_width()*2, y + menu[i].y, 0);
	  
					sprintf(work, "%3d", val_index);
					ui_font_draw(x + menu[i].x, y + menu[i].y, menu[i].r, menu[i].g, menu[i].b, work);
	  
					if (val_index != max_val)
						draw_pointer(x + menu[i].x + (strlen(work)+2)*ui_font_width(), y + menu[i].y, 1);
				}
	
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
      
		case DID_SKIPLIGHT:
		case DID_TRAMWAIT:
		case DID_VRAMWAIT:
		case DID_GRCGWAIT:
		case DID_REALPAL:
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Cancel");
			break;
      
		default:
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Back");
		}
    
		ta_commit_frame();
	}
}


void dlgscr()
{
	Screen scrmenu[16];
	int n;

	menu_index = 0;
	memset(dlg_val, 0, sizeof(dlg_val));
  
	dlginit();

	for (;;) {
		n = create_menu(scrmenu);

		if (scr_menu(scrmenu, n) < 0)
			break;
	}

	dlgupdate();
}
