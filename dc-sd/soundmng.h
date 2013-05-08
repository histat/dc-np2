
enum {
	SOUND_PCMSEEK		= 0,
	SOUND_PCMSEEK1		= 1,

	SOUND_MAXPCM
};


#ifdef __cplusplus
extern "C" {
#endif

UINT soundmng_create(UINT rate, UINT ms);
void soundmng_destroy(void);
void soundmng_reset(void);
void soundmng_play(void);
void soundmng_stop(void);
void soundmng_sync(void);
#define soundmng_setreverse(x)

#define	soundmng_pcmplay(a, b)
#define	soundmng_pcmstop(a)

#ifdef __cplusplus
}
#endif


// ----

BOOL soundmng_initialize(void);

