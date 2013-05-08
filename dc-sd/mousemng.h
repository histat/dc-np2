
enum {
	uPD8255A_LEFTBIT	= 0x80,
	uPD8255A_RIGHTBIT	= 0x20
};

typedef struct {
	SINT16	x;
	SINT16	y;
	UINT8	btn;
	UINT	flag;
} MOUSEMNG;



#ifdef __cplusplus
extern "C" {
#endif

	BYTE mousemng_getstat(SINT16 *x, SINT16 *y, int clear);

#ifdef __cplusplus
}
#endif


enum {
	MOUSEMNG_LEFTDOWN		= 0,
	MOUSEMNG_LEFTUP,
	MOUSEMNG_RIGHTDOWN,
	MOUSEMNG_RIGHTUP
};

void mousemng_initialize(void);
void mousemng_sync(void);
BOOL mousemng_buttonevent(UINT event);
