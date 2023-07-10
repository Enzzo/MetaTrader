/*
Copyright 2021 FXcoder

This file is part of VP.

VP is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

VP is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with VP. If not, see
http://www.gnu.org/licenses/.
*/

/*
Отладка. © FXcoder
Работа зависит от определений DEBUG, DEBUG_WARNING_PRINT, DEBUG_WARNING_ALERT.
*/

#property strict

// В режиме отладки терминала включать макрос отладки автоматически
#ifdef _DEBUG
	#ifndef DEBUG
		#define DEBUG
	#endif
#endif


#define FUNC_LINE_PREFIX      (string(__FUNCTION__) + "," + string(__LINE__) + ": ")
#define ERROR_SUFFIX          (" [" + _err.last_message(false) + "]")
#define DEBUG_MESSAGE(M)      (string(FUNC_LINE_PREFIX) + string(M) + (ERROR_SUFFIX))

#define VV(V)                 (#V + "=" + string(V))
#define VVD(V, D)             (#V + "=" + ::DoubleToString((V), (D)))
#define VVDC(V)               (#V + "=" + _double.to_string_compact(V))
#define VVE(V)                (#V + "=" + ::EnumToString(V))
#define VVPAD(V, P)           (#V + "=" + _str.pad(string(V), P))
#define VVT(V)                (#V + "=" + ::TimeToString(V))
#define VVC(V)                (#V + "=" + ::ColorToString(V, true))

#define VAR(V)                ("  " + VV(V))
#define VARD(V, D)            ("  " + VVD(V, D))
#define VARDC(V)              ("  " + VVDC(V))
#define VARE(V)               ("  " + VVE(V))
#define VARPAD(V, P)          ("  " + VVPAD(V, P))
#define VART(V)               ("  " + VVT(V))
#define VARC(V)               ("  " + VVC(V))


#ifdef DEBUG

#define PRINT(M)              { ::Print(DEBUG_MESSAGE(M)); }
#define PRINT_RET(M)          { ::Print(DEBUG_MESSAGE(M)); return; }
#define PRINT_RETURN(M, R)    { ::Print(DEBUG_MESSAGE(M)); return(R); }
#define PRINT_BREAK(M)        { ::Print(DEBUG_MESSAGE(M)); break; }

#define LOG(M)                { _log.show(M); }

#define DEBUG_DO(A)           { A; }

#else

#define PRINT(M)              { }
#define PRINT_RET(M)          { return; }
#define PRINT_RETURN(M, R)    { return(R); }
#define PRINT_BREAK(M)        { break; }

#define LOG(M)                { }

#define DEBUG_DO(A)           { }

#endif


/* Предупреждения */

//#define DEBUG_ALERT

// Способ предупреждений по умолчанию в режиме отладки
#ifdef DEBUG
	#ifndef DEBUG_ALERT
		#ifndef DEBUG_PRINT
			#define DEBUG_PRINT
		#endif
	#endif
#endif


#include "type/uncopyable.mqh"
#include "util/err.mqh"


class CBDebug: CBUncopyable
{
private:

	bool print_;
	bool alert_;


public:

	void CBDebug(bool print, bool alert):
		print_(print), alert_(alert)
	{
	}

	void warning(string message)
	{
		if (print_)
			::Print("WARNING: ", message);

		if (alert_)
			::Alert("WARNING: ", message);
	}

	void info(string message)
	{
		if (print_)
			::Print("INFO: ", message);

		if (alert_)
			::Alert("INFO: ", message);
	}

	bool check(bool cond, string msg)
	{
		if (cond)
			return(true);

		PRINT("ASSERTION FAILED: " + msg);
		return(false);
	}

};

#ifdef DEBUG_PRINT
	#ifdef DEBUG_ALERT
		CBDebug _debug(true, true);
	#else
		CBDebug _debug(true, false);
	#endif
#else
	#ifdef DEBUG_ALERT
		CBDebug _debug(false, true);
	#else
		CBDebug _debug(false, false);
	#endif
#endif

// result
//#ifdef DEBUG
	#define ASSERT(C)        _debug.check((C), #C)
	#define ASSERT_MSG(C, M) _debug.check((C), #C + string(M))
	// return
	#define ASSERT_EXIT(C)               { if (!(C)) PRINT_RET    ("ASSERTION FAILED: " + #C); }
	#define ASSERT_FAIL(C)               { if (!(C)) PRINT_RETURN ("ASSERTION FAILED: " + #C, false); }
	#define ASSERT_RETURN(C, R)          { if (!(C)) PRINT_RETURN ("ASSERTION FAILED: " + #C, (R)); }
	#define ASSERT_MSG_RETURN(C, M, R)   { if (!(C)) PRINT_RETURN ("ASSERTION FAILED: " + #C + ". " + M, (R)); }
//#else
//	#define ASSERT(C)
//	#define ASSERT_MSG(C, M)
//	// return
//	#define ASSERT_EXIT(C)
//	#define ASSERT_RETURN(C, R)
//	#define ASSERT_MSG_RETURN(C, M, R)
//#endif

// check
// (C) должно выполняться всегда
#define CHECK(C)             _debug.check((C), #C)
#define CHECK_EXIT(C)        { if (!(C)) { Print("CHECK FAILED: ", #C); return; } } // deprecated
#define CHECK_RET(C)         { if (!(C)) { Print("CHECK FAILED: ", #C); return; } }
#define CHECK_RETURN(C, R)   { if (!(C)) { Print("CHECK FAILED: ", #C); return(R); } }
