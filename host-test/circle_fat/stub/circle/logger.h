//
// Minimal host-build stand-in for circle/logger.h (messages are discarded).
//
#ifndef _circle_logger_h
#define _circle_logger_h

#include <circle/types.h>

enum TLogSeverity
{
	LogPanic,
	LogError,
	LogWarning,
	LogNotice,
	LogDebug
};

class CLogger
{
public:
	static CLogger *Get (void)
	{
		static CLogger Instance;
		return &Instance;
	}

	void Write (const char *pSource, TLogSeverity Severity, const char *pMessage, ...)
	{
		(void) pSource;
		(void) Severity;
		(void) pMessage;
	}
};

#endif
