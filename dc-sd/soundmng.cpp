#include "compiler.h"
#include "np2.h"
#include "pccore.h"
#include "soundmng.h"
#include "sound.h"
#include "dosio.h"
#include "parts.h"
#if defined(VERMOUTH_LIB)
#include "commng.h"
#include "cmver.h"
#endif
#include <ronin/sound.h>
#include <ronin/soundcommon.h>

static UINT dsstreambytes;
static UINT8 dsstreamevent;

static short tmp_sound_buffer[RING_BUFFER_SAMPLES>>3] __attribute__((aligned (32)));


// ---- stream

UINT soundmng_create(UINT rate, UINT ms) {

	UINT samples;

	stop_sound();
	do_sound_command(CMD_SET_BUFFER(3));
	do_sound_command(CMD_SET_STEREO(1));

	switch (rate) {

	case 44100:
		do_sound_command(CMD_SET_FREQ_EXP(FREQ_44100_EXP));
		break;
	  
	case 11025:
		do_sound_command(CMD_SET_FREQ_EXP(FREQ_11025_EXP));
		break;
    
	case 22050:
		do_sound_command(CMD_SET_FREQ_EXP(FREQ_22050_EXP));
		break;

	default:
		return 0;
	  
	}

	ZeroMemory(tmp_sound_buffer, sizeof(tmp_sound_buffer));
  
	samples = read_sound_int(&SOUNDSTATUS->ring_length);

	samples /= 2;
  
	dsstreambytes = samples;
  
#if defined(VERMOUTH_LIB)
	cmvermouth_load(rate);
#endif

	soundmng_reset();
	return samples;
}

void soundmng_reset(void) {

	dsstreamevent = (UINT8)-1;
}

void soundmng_destroy(void) {

#if defined(VERMOUTH_LIB)
	cmvermouth_unload();
#endif
	stop_sound();
}

void soundmng_play(void) {
  
	if (read_sound_int(&SOUNDSTATUS->mode) == MODE_PAUSE)
		start_sound();
}

void soundmng_stop(void) {
  
	if (read_sound_int(&SOUNDSTATUS->mode) == MODE_PLAY)
		stop_sound();
}

extern "C" void *memcpy4s(void *s1, const void *s2, unsigned int n);

static void streamwrite(DWORD pos) {

	const SINT32 *pcm;
  
	pcm = sound_pcmlock();
  
	if (pcm) {
		satuation_s16(tmp_sound_buffer, pcm, 2*SAMPLES_TO_BYTES(dsstreambytes));
	} else {
		ZeroMemory(tmp_sound_buffer, SAMPLES_TO_BYTES(dsstreambytes));
	}

	memcpy4s(RING_BUF + pos, tmp_sound_buffer, SAMPLES_TO_BYTES(dsstreambytes));
  
	sound_pcmunlock(pcm);
}

void soundmng_sync(void) {
  
	DWORD	pos;

	pos = read_sound_int(&SOUNDSTATUS->samplepos);
  
	if (pos >= dsstreambytes) {
		if (dsstreamevent != 0) {
			dsstreamevent = 0;
			streamwrite(0);
		}
	} else {
		if (dsstreamevent != 1) {
			dsstreamevent = 1;
			streamwrite(dsstreambytes);
		}
	}
}


// ----

BOOL soundmng_initialize(void) {

	return SUCCESS;
}
