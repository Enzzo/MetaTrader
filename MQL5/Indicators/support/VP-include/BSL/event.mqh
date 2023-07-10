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

// Функции событий. © FXcoder

#property strict

#include "type/single.mqh"
#include "type/uncopyable.mqh"

class CBEventUtil: public CBUncopyable
{
public:

	static bool chart_custom(long chart_id, ushort custom_event_id, long lparam, double dparam, string sparam)
	{
		return(::EventChartCustom(chart_id, custom_event_id, lparam, dparam, sparam));
	}

	static void kill_timer()
	{
		::EventKillTimer();
	}

	static bool set_millisecond_timer(int milliseconds)
	{
		return(::EventSetMillisecondTimer(milliseconds));
	}

	static bool set_timer(int seconds)
	{
		return(::EventSetTimer(seconds));
	}

	// повторный вызов установки таймера не документирован (mki#24), поэтому ещё такой явный вариант
	static bool reset_millisecond_timer(int milliseconds)
	{
		kill_timer();
		return(set_millisecond_timer(milliseconds));
	}

	// повторный вызов установки таймера не документирован (mki#24), поэтому ещё такой явный вариант
	static bool reset_timer(int seconds)
	{
		kill_timer();
		return(set_timer(seconds));
	}

	SINGLE_INSTANCE(CBEventUtil)

private:

	SINGLE_CONSTRUCTOR(CBEventUtil)

};

SINGLE_GET(CBEventUtil, _event)
