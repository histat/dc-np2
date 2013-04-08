#include "compiler.h"
#include "np2.h"
#include "joymng.h"
#include "pccore.h"
#include "dcsys.h"
#include "event.h"

#define	JOY_LEFT_BIT	0x04
#define	JOY_RIGHT_BIT	0x08
#define	JOY_UP_BIT	0x01
#define	JOY_DOWN_BIT	0x02
#define	JOY_BTN1_BIT	0x10
#define	JOY_BTN2_BIT	0x20

static REG8 joyflag = 0xff;

UINT8 joymng_getstat(void) {

	const int Flag = dc_joyinput;

	joyflag = 0xff;
  
	if (np2oscfg.bindcur == 0 )  {
      
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

	if (np2oscfg.bindbtn == 0) {
		if (Flag & JOY_A) {
			joyflag &= (0xff ^ (JOY_BTN1_BIT<<2));
		}
		if (Flag & JOY_B) {
			joyflag &= (0xff ^ (JOY_BTN2_BIT)<<2);
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



