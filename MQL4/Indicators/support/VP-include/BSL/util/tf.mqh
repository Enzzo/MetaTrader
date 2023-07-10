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

// Timeframe functions. © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "time.mqh"

class CBTimeframeUtil: public CBUncopyable
{
public:

	static const ENUM_TIMEFRAMES current;
	static const int current_minutes; // number of minutes in the current timeframe
	static const int current_seconds; // number of seconds in the current timeframe
	static const int w1_seconds;      // number of seconds in the W1 timeframe
	static const int mn1_seconds;     // number of seconds in the MN1 timeframe

	static const ENUM_TIMEFRAMES list[]; // list of all available timeframes
	static const int             count;  // number of all available timeframes


private:

#ifdef __MQL4__
	static bool is_enabled_; // mki#31
#endif


public:

	static bool is_current(ENUM_TIMEFRAMES tf)
	{
		return((tf == PERIOD_CURRENT) || (tf == _Period));
	}

	// Convert timeframe to string. Standard timeframes only.
	static string to_string(ENUM_TIMEFRAMES tf = PERIOD_CURRENT)
	{
		const int seconds = to_seconds(tf);

		if (seconds % _time.seconds_in_month == 0)
			return("MN" + ::IntegerToString(seconds / _time.seconds_in_month));
		else if (seconds % _time.seconds_in_week == 0)
			return("W" + ::IntegerToString(seconds / _time.seconds_in_week));
		else if (seconds % _time.seconds_in_day == 0)
			return("D" + ::IntegerToString(seconds / _time.seconds_in_day));
		else if (seconds % _time.seconds_in_hour == 0)
			return("H" + ::IntegerToString(seconds / _time.seconds_in_hour));
		else
			return("M" + ::IntegerToString(seconds / 60));
	}

#ifdef __MQL4__
	// for using with 0, NULL, _Period (tf is int in 4)
	static string to_string(int tf) { return(to_string((ENUM_TIMEFRAMES)tf)); }
#endif

	// for current timeframe use `_tf.current_minutes`
	static int to_minutes(ENUM_TIMEFRAMES tf)
	{
		return(::PeriodSeconds(tf) / 60);
	}

	// for current timeframe use `_tf.current_seconds`
	static int to_seconds(ENUM_TIMEFRAMES tf)
	{
		return(::PeriodSeconds(tf));
	}

#ifdef __MQL4__
	// for using with 0, NULL, _Period (tf is int in 4)
	// for current timeframe use `_tf.current_*`
	static int to_minutes(int tf) { return(to_minutes((ENUM_TIMEFRAMES)tf)); }
	static int to_seconds(int tf) { return(to_seconds((ENUM_TIMEFRAMES)tf)); }
#endif

	// Find the closest timeframe to the given time in minutes.
	// It always has a result. Values <= 0 give M1.
	static ENUM_TIMEFRAMES find_closest(int minutes)
	{
		const long seconds = minutes * 60;
		long min_diff = LONG_MAX;
		ENUM_TIMEFRAMES tf = PERIOD_CURRENT; // remove `possible use of uninitialized variable`

		for (int i = 0; i < _tf.count; i++)
		{
			const long tf_sec = ::PeriodSeconds(list[i]);
			const long diff = ::fabs(tf_sec - seconds);

			if (diff <= min_diff) // give priority to higher timeframe (3 seems closer to 5 than to 1)
			{
				min_diff = diff;
				tf = list[i];
			}
		}

		return(tf);
	}

	// Get real timeframe (convert PERIOD_CURRENT to real).
	static ENUM_TIMEFRAMES real(ENUM_TIMEFRAMES tf = PERIOD_CURRENT)
	{
		return(tf == PERIOD_CURRENT ? (ENUM_TIMEFRAMES)_Period : tf);
	}

	// mki#31
	// hack for 4's bug: disabling of showing indicator on period affects only OnCalculate
	// should be called in OnCalculate
	static void enable()
	{
#ifdef __MQL4__
		if (!is_enabled_)
			is_enabled_ = true;
#endif
	}

	// mki#31
	// hack for 4's bug: disabling of showing indicator on period affects only OnCalculate
	// should be checked in every event handler except OnCalculate
	static bool is_enabled()
	{
#ifdef __MQL4__
		return(is_enabled_);
#else
		return(true);
#endif
	}

};

const ENUM_TIMEFRAMES  CBTimeframeUtil::current          = (ENUM_TIMEFRAMES)::Period();
const int              CBTimeframeUtil::current_minutes  = ::PeriodSeconds() / 60;
const int              CBTimeframeUtil::current_seconds  = ::PeriodSeconds();
const int              CBTimeframeUtil::w1_seconds       = ::PeriodSeconds(PERIOD_W1);
const int              CBTimeframeUtil::mn1_seconds      = ::PeriodSeconds(PERIOD_MN1);

#ifdef __MQL4__
bool CBTimeframeUtil::is_enabled_ = false;
#endif

#ifdef __MQL4__

	const ENUM_TIMEFRAMES CBTimeframeUtil::list[] =
	{
		PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30,
		PERIOD_H1, PERIOD_H4,
		PERIOD_D1, PERIOD_W1, PERIOD_MN1
	};

	const int CBTimeframeUtil::count = 9;

#else

	const ENUM_TIMEFRAMES CBTimeframeUtil::list[] =
	{
		PERIOD_M1, PERIOD_M2, PERIOD_M3, PERIOD_M4, PERIOD_M5, PERIOD_M6, PERIOD_M10, PERIOD_M12, PERIOD_M15, PERIOD_M20, PERIOD_M30,
		PERIOD_H1, PERIOD_H2, PERIOD_H3, PERIOD_H4, PERIOD_H6, PERIOD_H8, PERIOD_H12,
		PERIOD_D1, PERIOD_W1, PERIOD_MN1
	};

	const int CBTimeframeUtil::count = 21;

#endif

CBTimeframeUtil _tf;
