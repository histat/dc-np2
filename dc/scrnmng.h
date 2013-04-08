
typedef struct {
	UINT8	*ptr;
	int		xalign;
	int		yalign;
	int		width;
	int		height;
	UINT	bpp;
	int		extend;
} SCRNSURF;

enum {
	SCRNMODE_FULLSCREEN		= 0x01,
	SCRNMODE_HIGHCOLOR		= 0x02,
	SCRNMODE_ROTATE			= 0x10,
	SCRNMODE_ROTATEDIR		= 0x20,
	SCRNMODE_ROTATELEFT		= (SCRNMODE_ROTATE + 0),
	SCRNMODE_ROTATERIGHT	= (SCRNMODE_ROTATE + SCRNMODE_ROTATEDIR),
	SCRNMODE_ROTATEMASK		= 0x30,
};

enum {
	SCRNFLAG_FULLSCREEN		= 0x01,
	SCRNFLAG_HAVEEXTEND		= 0x02,
	SCRNFLAG_ENABLE			= 0x80
};

typedef struct {
	UINT8	flag;
	UINT8	bpp;
	UINT8	allflash;
	UINT8	palchanged;
} SCRNMNG;

#ifdef __cplusplus
extern "C" {
#endif

extern	SCRNMNG		scrnmng;			// マクロ用


void scrnmng_initialize(void);
BOOL scrnmng_create(UINT8 scrnmode);
void scrnmng_destroy(void);

void scrnmng_setwidth(int posx, int width);
void scrnmng_setextend(int extend);
void scrnmng_setheight(int posy, int height);
const SCRNSURF *scrnmng_surflock(void);
void scrnmng_surfunlock(const SCRNSURF *surf);
void scrnmng_update(void);
#define	scrnmng_dispclock()

#define	scrnmng_isfullscreen()	
#define	scrnmng_haveextend()	(0)
#define	scrnmng_getbpp()		(scrnmng.bpp)
#define	scrnmng_allflash()		scrnmng.allflash = TRUE
#define	scrnmng_palchanged()	scrnmng.palchanged = TRUE

UINT16 scrnmng_makepal16(RGB32 pal32);

#ifdef __cplusplus
}
#endif

