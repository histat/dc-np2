#include "compiler.h"
#include "np2.h"
#include "mousemng.h"
#include "scrnmng.h"
#include "dcsys.h"
#include "event.h"

static MOUSEMNG mousemng;

UINT8 mousemng_getstat(SINT16 *x, SINT16 *y, int clear)
{
	*x = mousemng.x;
	*y = mousemng.y;
	if (clear) {
		mousemng.x = 0;
		mousemng.y = 0;
	}
	return mousemng.btn;
}

void mousemng_initialize(void)
{
	ZeroMemory(&mousemng, sizeof(mousemng));
	mousemng.btn = uPD8255A_LEFTBIT | uPD8255A_RIGHTBIT;
}

void mousemng_sync(void)
{
	mousemng.x += dc_mouseaxis1;
	mousemng.y += dc_mouseaxis2;
}


BOOL mousemng_buttonevent(UINT event) {

	switch (event) {
    
	case MOUSEMNG_LEFTDOWN:
		mousemng.btn &= ~(uPD8255A_LEFTBIT);
		break;
    
	case MOUSEMNG_LEFTUP:
		mousemng.btn |= uPD8255A_LEFTBIT;
		break;
    
	case MOUSEMNG_RIGHTDOWN:
		mousemng.btn &= ~(uPD8255A_RIGHTBIT);
		break;
    
	case MOUSEMNG_RIGHTUP:
		mousemng.btn |= uPD8255A_RIGHTBIT;
		break;
	}
  
	return TRUE;
}

