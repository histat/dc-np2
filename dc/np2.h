
typedef struct {
	UINT8	NOWAIT;
	UINT8	DRAW_SKIP;
	UINT8	F12KEY;
	UINT8	resume;
  
	UINT8	JOYPAD1;
	UINT8	JOYPAD2;
  
	UINT8	bindcur;
	UINT8	bindbtn;
  
	UINT8	jastsnd;
} NP2OSCFG;

#ifdef __cplusplus
extern "C" {
#endif
	extern	NP2OSCFG	np2oscfg;
#ifdef __cplusplus
}
#endif
