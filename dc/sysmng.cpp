#include "compiler.h"
#include "cpucore.h"
#include "pccore.h"
#include "sysmng.h"


UINT	sys_updates;

#ifndef NODISP

// ----

static struct {
	UINT32	tick;
	UINT32	clock;
	UINT32	draws;
	SINT32	fps;
	SINT32	khz;
} workclock;

void sysmng_workclockreset(void) {

	workclock.tick = GETTICK();
	workclock.clock = CPU_CLOCK;
	workclock.draws = drawcount;
}

static BOOL workclockrenewal(void) {

	SINT32	tick;
  
	tick = GETTICK() - workclock.tick;
	if (tick < 2000) {
		return FALSE;
	}
	workclock.tick += tick;
	workclock.fps = ((drawcount - workclock.draws) * 10000) / tick;
	workclock.draws = drawcount;
	workclock.khz = (CPU_CLOCK - workclock.clock) / tick;
	workclock.clock = CPU_CLOCK;
	return TRUE;
}

void sysmng_updatecaption(void) {
  
	char work[256];
  
	if (workclockrenewal()) {
		OEMSPRINTF(work, OEMTEXT("%2u.%03uMHz %2u.%1uFPS")
				,workclock.khz / 1000, workclock.khz % 1000
				,workclock.fps / 10, workclock.fps % 10);

		printf("%s\n",work);
	}
}

#endif
