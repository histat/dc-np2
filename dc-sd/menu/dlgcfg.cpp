#include "compiler.h"
#include "strres.h"
#include "np2.h"
#include "sysmng.h"
#include "pccore.h"
#include "scrnmng.h"
#include "sysmenu.h"
#include "sysmenu.res"
#include "dlgcfg.h"
#include "dcsys.h"
#include "event.h"
#include "ui.h"
#include <ronin/ta.h>



enum {
	DID_CLOCK1 = 0,
	DID_CLOCK2,
	DID_MULTIPLE,
	DID_MULSTR,
	DID_CLOCKSTR,
	DID_MODELVM,
	DID_MODELVX,
	DID_MODELEPSON,
	DID_RATE11,
	DID_RATE22,
	DID_RATE44,
	DID_RESUME
};

static const OEMCHAR mstr_cfg[] = OEMTEXT("Configure");

static const OEMCHAR str_cpu[] = OEMTEXT("CPU");
static const OEMCHAR str_base[] = OEMTEXT("Base");
static const OEMCHAR str_2mhz[] = OEMTEXT("1.9968MHz");
static const OEMCHAR str_2halfmhz[] = OEMTEXT("2.4576MHz");
static const OEMCHAR str_mul[] = OEMTEXT("Multiple");
static const OEMCHAR str_arch[] = OEMTEXT("Architecture");
static const OEMCHAR str_vm[] = OEMTEXT("PC-9801VM");
static const OEMCHAR str_vx[] = OEMTEXT("PC-9801VX");
static const OEMCHAR str_epson[] = OEMTEXT("EPSON");
static const OEMCHAR str_sound[] = OEMTEXT("Sound");
static const OEMCHAR str_rate[] = OEMTEXT("Rate");
static const OEMCHAR str_11khz[] = OEMTEXT("11KHz");
static const OEMCHAR str_22khz[] = OEMTEXT("22KHz");
static const OEMCHAR str_44khz[] = OEMTEXT("44KHz");

static const MENUPRM res_cfg[] = {
	{DLGTYPE_FRAME,	DID_STATIC,		0, str_cpu},
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_base},
	{DLGTYPE_RADIO,	DID_CLOCK1,		0, str_2mhz},
	{DLGTYPE_RADIO,	DID_CLOCK2,		0, str_2halfmhz},
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_mul},
	{DLGTYPE_SLIDER,	DID_MULTIPLE,		0, (void *)SLIDERPOS(1, 4)},
	{DLGTYPE_LTEXT,	DID_MULSTR,		0, NULL},
	{DLGTYPE_RTEXT,	DID_CLOCKSTR,		0, NULL},
  
	{DLGTYPE_FRAME,	DID_STATIC,		0, str_arch},
	{DLGTYPE_RADIO,	DID_MODELVM,		0, str_vm},
	{DLGTYPE_RADIO,	DID_MODELVX,		0, str_vx},
	{DLGTYPE_RADIO,	DID_MODELEPSON,		0, str_epson},
			
	{DLGTYPE_FRAME,	DID_STATIC,		0, str_sound},
	{DLGTYPE_LTEXT,	DID_STATIC,		0, str_rate},
	{DLGTYPE_RADIO,	DID_RATE11,		0, str_11khz},
	{DLGTYPE_RADIO,	DID_RATE22,		0, str_22khz},
	{DLGTYPE_RADIO,	DID_RATE44,		0, str_44khz}};


// ----

static int dlg_val[DID_RESUME+1];

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
	}
}

static OEMCHAR	mulstr[16];
static OEMCHAR	clockstr[16];

static void menudlg_settext(MENUID id, const char *work)
{
	switch (id) {
    
	case DID_MULSTR:
		milstr_ncpy(mulstr, work, NELEMENTS(mulstr));
		break;
    
	case DID_CLOCKSTR:
		milstr_ncpy(clockstr, work, NELEMENTS(clockstr));
		break;
	}
}

static const OEMCHAR str_mulfmt[] = OEMTEXT("x%u");
static const OEMCHAR str_clockfmt[] = OEMTEXT("%2u.%.4uMHz");

static void setmulstr(void) {

	UINT	multiple;
	OEMCHAR	work[32];

	multiple = menudlg_getval(DID_MULTIPLE);
	if (multiple < 1) {
		multiple = 1;
	}
	else if (multiple > 32) {
		multiple = 32;
	}
	OEMSPRINTF(work, str_mulfmt, multiple);
	menudlg_settext(DID_MULSTR, work);
}

static void setclockstr(void) {

	UINT32	clock;
	UINT	multiple;
	OEMCHAR	work[32];

	if (menudlg_getval(DID_CLOCK1)) {
		clock = PCBASECLOCK20 / 100;
	}
	else {
		clock = PCBASECLOCK25 / 100;
	}
	multiple = menudlg_getval(DID_MULTIPLE);
	if (multiple < 1) {
		multiple = 1;
	}
	else if (multiple > 32) {
		multiple = 32;
	}
	clock *= multiple;
	OEMSPRINTF(work, str_clockfmt, clock / 10000, clock % 10000);
	menudlg_settext(DID_CLOCKSTR, work);
}

static void dlginit(void) {

	MENUID	id;

	if (np2cfg.baseclock < ((PCBASECLOCK25 + PCBASECLOCK20) / 2)) {
		id = DID_CLOCK1;
	}
	else {
		id = DID_CLOCK2;
	}
	menudlg_setval(id, 1);
	menudlg_setval(DID_MULTIPLE, np2cfg.multiple);

	if (!milstr_cmp(np2cfg.model, str_VM)) {
		id = DID_MODELVM;
	}
	else if (!milstr_cmp(np2cfg.model, str_EPSON)) {
		id = DID_MODELEPSON;
	}
	else {
		id = DID_MODELVX;
	}
	menudlg_setval(id, 1);

	if (np2cfg.samplingrate < ((11025 + 22050) / 2)) {
		id = DID_RATE11;
	}
	else if (np2cfg.samplingrate < ((22050 + 44100) / 2)) {
		id = DID_RATE22;
	}
	else {
		id = DID_RATE44;
	}
	menudlg_setval(id, 1);
	menudlg_setval(DID_RESUME, np2oscfg.resume);

	setmulstr();
	setclockstr();

#if defined(DISABLE_SOUND)
	menudlg_setenable(DID_RATE11, FALSE);
	menudlg_setenable(DID_RATE22, FALSE);
	menudlg_setenable(DID_RATE44, FALSE);
#endif
}

static void dlgupdate(void) {

	UINT		update;
	UINT		val;
	const OEMCHAR	*str;

	update = 0;
	if (menudlg_getval(DID_CLOCK1)) {
		val = PCBASECLOCK20;
	}
	else {
		val = PCBASECLOCK25;
	}
	if (np2cfg.baseclock != val) {
		np2cfg.baseclock = val;
		update |= SYS_UPDATECFG | SYS_UPDATECLOCK;
	}
	val = menudlg_getval(DID_MULTIPLE);
	if (val < 1) {
		val = 1;
	}
	else if (val > 32) {
		val = 32;
	}
	if (np2cfg.multiple != val) {
		np2cfg.multiple = val;
		update |= SYS_UPDATECFG | SYS_UPDATECLOCK;
	}

	if (menudlg_getval(DID_RATE11)) {
		val = 11025;
	}
	else if (menudlg_getval(DID_RATE44)) {
		val = 44100;
	}
	else {
		val = 22050;
	}
	if (np2cfg.samplingrate != (UINT16)val) {
		np2cfg.samplingrate = (UINT16)val;
		update |= SYS_UPDATECFG | SYS_UPDATERATE;
		soundrenewal = 1;
	}

	if (menudlg_getval(DID_MODELVM)) {
		str = str_VM;
	}
	else if (menudlg_getval(DID_MODELEPSON)) {
		str = str_EPSON;
	}
	else {
		str = str_VX;
	}
	if (milstr_cmp(np2cfg.model, str)) {
		milstr_ncpy(np2cfg.model, str, NELEMENTS(np2cfg.model));
		update |= SYS_UPDATECFG;
	}

	if (menudlg_getval(DID_RATE11)) {
		val = 11025;
	}
	else if (menudlg_getval(DID_RATE44)) {
		val = 44100;
	}
	else {
		val = 22050;
	}
	if (np2cfg.samplingrate != (UINT16)val) {
		np2cfg.samplingrate = (UINT16)val;
		update |= SYS_UPDATECFG | SYS_UPDATERATE;
		soundrenewal = 1;
	}
	val = menudlg_getval(DID_RESUME);
	if (np2oscfg.resume != (UINT8)val) {
		np2oscfg.resume = (UINT8)val;
		update |= SYS_UPDATEOSCFG;
	}
	sysmng_update(update);
}

// ---

static int menu_index;

struct Config {
	int		type;
	MENUID	id;
	const void	*arg;
	float x ,y;
	int r, g, b;
};

static int create_menu(Config *dst)
{
	const int num_items = sizeof(res_cfg)/sizeof(res_cfg[0]);
	const MENUPRM *src = res_cfg;
	float x,y;

	int page = 0;
	int n = 0;

	y = 0;

	for (int i = 0; i < num_items; ++i) {
		if (src[i].type == DLGTYPE_FRAME) {
			++page;
		}

		if (menu_index == page) {
      
			dst[n].type = src[i].type;
			dst[n].id = src[i].id;

			switch (src[i].id) {
	
			case DID_MULSTR:
				dst[n].arg = (void *)mulstr;
				break;

			case DID_CLOCKSTR:
				dst[n].arg = (void *)clockstr;
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
				x = (MAX_MENU_SIZE - (strlen((char*)dst[n].arg)+2) * ui_font_width());
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
			case DLGTYPE_LTEXT:
			case DLGTYPE_FRAME:
			case DLGTYPE_CTEXT:
			case DLGTYPE_RTEXT:
				y += ui_font_height() + 5;
			}

			++n;
		}
	}
  
	return n;
}

void dlg_clock(int id) {
  
	switch (id) {
    
	case DID_CLOCK1:
	case DID_CLOCK2:
		menudlg_setval(DID_CLOCK1, 0);
		menudlg_setval(DID_CLOCK2, 0);
		menudlg_setval(id, 1);
		break;
	}
}

void dlg_model(int id) {
  
	switch (id) {
    
	case DID_MODELVM:
	case DID_MODELVX:
	case DID_MODELEPSON:
		menudlg_setval(DID_MODELVM, 0);
		menudlg_setval(DID_MODELVX, 0);
		menudlg_setval(DID_MODELEPSON, 0);
		menudlg_setval(id, 1);
		break;
	}
}

void dlg_rate(int id) {
  
	switch (id) {
    
	case DID_RATE11:
	case DID_RATE44:
	case DID_RATE22:
		menudlg_setval(DID_RATE11, 0);
		menudlg_setval(DID_RATE22, 0);
		menudlg_setval(DID_RATE44, 0);
		menudlg_setval(id, 1);
		break;
	}
}

int cfg_menu(Config *menu, int num_items)
{
	float x,y;
	float base_width = MAX_MENU_SIZE;
	float base_height = ((menu[num_items-1].y + ui_font_height()) - menu[0].y);
	int max_menu;
	int menu_pos;
	char work[32];

	base_height += ui_font_height() * 2;
  
	max_menu = 0;
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
  
	int max_val = 0;
	int min_val = 0;
	int val_index = 0;
  
	float offx = ui_offx() + (ui_width() - base_width) / 2;
	float offy = ui_offy() + (ui_height() - base_height) / 2;

	int fade = 128;
  
	for (;;) {

		uisys_task();
    
		if (ui_keyrepeat(JOY_UP)) {

			switch (result) {
			case DID_MULTIPLE:
				break;
	
			default:
				if (--sel < 0)
					sel = max_menu - 1;
			}
		} else if (ui_keyrepeat(JOY_DOWN)) {

			switch (result) {
	
			case DID_MULTIPLE:
				break;
	
			default:
				if (++sel > (max_menu - 1))
					sel = 0;
			}
      
		} else if (ui_keyrepeat(JOY_RIGHT) || ui_keyrepeat(JOY_RTRIGGER)) {
      
			switch (result) {
	
			case DID_MULTIPLE:
				if (++val_index > max_val)
					val_index = max_val;
				break;
	
			default:
				if (++menu_index > 3) {
					menu_index = 3;
				} else {
					return 0;
				}
			}
		} else if (ui_keyrepeat(JOY_LEFT) || ui_keyrepeat(JOY_LTRIGGER)) {
      
			switch (result) {
	
			case DID_MULTIPLE:
				if (--val_index < min_val)
					val_index = min_val;
				break;
	
			default:
				if (--menu_index < 1) {
					menu_index = 1;
				} else {
					return 0;
				}
			}
		}
    
		if (ui_keypressed(JOY_A)) {

			switch (id) {
	
			case DID_CLOCK1:
			case DID_CLOCK2:
				dlg_clock(id);
				setclockstr();
				break;

			case DID_MULTIPLE:
				if (result == id) {
					menudlg_setval(id, val_index);
					setmulstr();
					setclockstr();
					result = -1;
				} else {
					val_index = menudlg_getval(id);
					result = id;
				}
				break;

			case DID_MODELVM:
			case DID_MODELVX:
			case DID_MODELEPSON:
				dlg_model(id);
				break;

			case DID_RATE11:
			case DID_RATE44:
			case DID_RATE22:
				dlg_rate(id);
				break;
			}
		}
    
		if (ui_keypressed(JOY_B)) {

			switch (result) {
	
			case DID_MULTIPLE:
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

		OEMSPRINTF(work, "%s (%d/%d)", mstr_cfg, menu_index, 3);
		x = offx + (base_width - strlen(work) * ui_font_width()) / 2;
		y = offy;
		ui_font_draw(x, y, 255, 255, 255, work);
    
		if (menu_index != 1)
			draw_pointer(offx + ui_font_width(), y, 0);
    
		if (menu_index != 3)
			draw_pointer(offx + base_width - ui_font_width(), y, 1);
    
		y += ui_font_height() + 5;
		x = offx;

		draw_transquad(offx, y, offx + base_width, y + 1, MAKECOL32(128, 128, 128, 255),
					   MAKECOL32(128, 128, 128, 255), MAKECOL32(128, 128, 128, 255), MAKECOL32(128, 128, 128, 255));

		y += 6;
    
		menu_pos = 0;
    
		for (int i = 0; i < num_items; ++i) {
      
			switch (menu[i].type) {
	
			case DLGTYPE_RADIO:
				if (menu_pos == sel) {
					draw_transquad(offx, y + menu[i].y, offx + base_width, y + menu[i].y + ui_font_height() + 5, MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade), MAKECOL32(255, 0, 0, fade));
	  
					id = menu[i].id;
				}
				if (menudlg_getval(menu[i].id))
					draw_pointer(x + menu[i].x - ui_font_width(), y + menu[i].y, 1);
	
				ui_font_draw(x + menu[i].x, y + menu[i].y, menu[i].r, menu[i].g, menu[i].b, (const char *)menu[i].arg);
	
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
      
		case DID_MULTIPLE:
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Cancel");
			break;
      
		default:
			ui_font_draw(x, y, 255, 255, 255, "A:Select B:Back");
		}
    
		ta_commit_frame();
	}
}

void dlgcfg()
{
	Config cfgmenu[sizeof(res_cfg)/sizeof(res_cfg[0])];
	int n;

	menu_index = 1;
	memset(dlg_val, 0, sizeof(dlg_val));
  
	dlginit();
  
	for (;;) {
		n = create_menu(cfgmenu);

		if (cfg_menu(cfgmenu, n) < 0)
			break;
	}

	dlgupdate();
}
