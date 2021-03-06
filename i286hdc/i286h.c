#include	"compiler.h"
#include	"cpucore.h"


	I286CORE	i286hcore;

const UINT8 iflags[512] = {					// Z_FLAG, S_FLAG, P_FLAG
			0x44, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x04,
			0x04, 0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x00,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x84, 0x80, 0x80, 0x84, 0x80, 0x84, 0x84, 0x80,
			0x80, 0x84, 0x84, 0x80, 0x84, 0x80, 0x80, 0x84,
			0x45, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x01, 0x05, 0x05, 0x01, 0x05, 0x01, 0x01, 0x05,
			0x05, 0x01, 0x01, 0x05, 0x01, 0x05, 0x05, 0x01,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x85, 0x81, 0x81, 0x85, 0x81, 0x85, 0x85, 0x81,
			0x81, 0x85, 0x85, 0x81, 0x85, 0x81, 0x81, 0x85};


// ----

void i286h_initialize(void) {

	ZeroMemory(&i286hcore, sizeof(i286hcore));
}

void i286h_deinitialize(void) {

	if (CPU_EXTMEM) {
		_MFREE(CPU_EXTMEM);
		CPU_EXTMEM = NULL;
		CPU_EXTMEMSIZE = 0;
	}
}

static void i286h_initreg(void) {

	CPU_CS = 0xf000;
	CS_BASE = 0xf0000;
	CPU_IP = 0xfff0;
	CPU_ADRSMASK = 0xfffff;
}

void i286h_reset(void) {

#if 0
	if (offsetof(I286CORE, m) != 120) {
		exit(1);
	}
#endif
	ZeroMemory(&i286hcore.s, sizeof(i286hcore.s));
	i286h_initreg();
}

void i286h_shut(void) {

	ZeroMemory(&i286hcore.s, offsetof(I286STAT, cpu_type));
	i286h_initreg();
}

void i286h_setextsize(UINT32 size) {

	if (CPU_EXTMEMSIZE != size) {
		if (CPU_EXTMEM) {
			_MFREE(CPU_EXTMEM);
			CPU_EXTMEM = NULL;
		}
		if (size) {
			CPU_EXTMEM = (BYTE *)_MALLOC(size + 16, "EXTMEM");
			if (CPU_EXTMEM == NULL) {
				size = 0;
			}
		}
		CPU_EXTMEMSIZE = size;
	}
	i286hcore.e.ems[0] = mem + 0xc0000;
	i286hcore.e.ems[1] = mem + 0xc4000;
	i286hcore.e.ems[2] = mem + 0xc8000;
	i286hcore.e.ems[3] = mem + 0xcc000;
}

void i286h_setemm(UINT frame, UINT32 addr) {

	BYTE	*ptr;

	frame &= 3;
	if (addr < USE_HIMEM) {
		ptr = mem + addr;
	}
	else if ((addr - 0x100000 + 0x4000) <= CPU_EXTMEMSIZE) {
		ptr = CPU_EXTMEM + (addr - 0x100000);
	}
	else {
		ptr = mem + 0xc0000 + (frame << 14);
	}
	i286hcore.e.ems[frame] = ptr;
}


#if 0	// ---- test
void ea_assert(UINT32 x) {

	TCHAR	buf[32];

	wsprintf(buf, _T("addr = %x [%.2x]"), x, i286_memoryread(x - 2));
	MessageBox(NULL, buf, _T("!"), MB_OK);
	exit(1);
}
#endif

