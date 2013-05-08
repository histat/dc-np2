#include "compiler.h"
#include "np2.h"
#include "joymng.h"
#include "pccore.h"
#include "dcsys.h"
#include "event.h"

enum {
	JOY_LEFT_BIT	= 0x04,
	JOY_RIGHT_BIT	= 0x08,
	JOY_UP_BIT		= 0x01,
	JOY_DOWN_BIT	= 0x02,
	JOY_BTN1_BIT	= 0x10,
	JOY_BTN2_BIT	= 0x20
};

static	REG8	joyflag = 0xff;
static	UINT8	joypad1btn[4];

void joymng_initialize(void) {

	int			i;

	for (i=0; i<4; i++) {
		joypad1btn[i] = 0xff ^
			((np2oscfg.JOY1BTN[i] & 3) << ((np2oscfg.JOY1BTN[i] & 4)?4:6));
	}
}

UINT8 joymng_getstat(void) {

	const int Flag = dc_joyinput;

	joyflag = 0xff;
  
	if (np2oscfg.JOYPAD1 && np2oscfg.bindcur == 0)  {
      
		if(Flag & JOY_LEFT) {
			joyflag &= ~JOY_LEFT_BIT;
		} else if (Flag & JOY_RIGHT) {
			joyflag &= ~JOY_RIGHT_BIT;
		}
		if (Flag & JOY_UP) {
			joyflag &= ~JOY_UP_BIT;
		} else if (Flag & JOY_DOWN) {
			joyflag &= ~JOY_DOWN_BIT;
		}
	}

	if (np2oscfg.JOYPAD1 && np2oscfg.bindbtn == 0) {
		if (Flag & JOY_A) {
			joyflag &= joypad1btn[0];							// ver0.28
		}
		if (Flag & JOY_B) {
			joyflag &= joypad1btn[1];							// ver0.28
		}
		if (Flag & JOY_X) {
			joyflag &= joypad1btn[2];							// ver0.28
		}
		if (Flag & JOY_Y) {
			joyflag &= joypad1btn[3];							// ver0.28
		}
	}
  
	return joyflag;
}


// joyflag	bit:0		up
// 			bit:1		down
// 			bit:2		left
// 			bit:3		right
// 			bit:4		trigger1 (rapid)
// 			bit:5		trigger2 (rapid)
// 			bit:6		trigger1
// 			bit:7		trigger2



