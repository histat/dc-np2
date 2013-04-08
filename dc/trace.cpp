#include "compiler.h"
#include <stdarg.h>

#ifdef TRACE

void trace_fmt(const char *fmt, ...) {

	va_list	ap;
	char	buf[1024];

	va_start(ap, fmt);
	vsprintf(buf, fmt, ap);
	va_end(ap);
	reportff("%s\n", buf);
}

#endif
