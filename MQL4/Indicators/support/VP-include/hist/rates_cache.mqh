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

// Series Cache. © FXcoder

/*
The idea is to replace functions like iTime by cached values. Negative values are acceptable.

You must recreate or clear the class's object on every new bar. Self-checking will neutralize
the benefits of this class.
*/


#property strict

#include "../bsl.mqh"
#include "../class/timer.mqh"


class CRatesCache
{
protected:

	MqlRates rates_[]; // real rates, [0] is oldest
	int rates_count_;  // also used as status
	const int rates_reserve_; // has two meanings: array reserve and load reserve

	const ENUM_TIMEFRAMES tf_;
	const int period_seconds_;
	CBSeries *ser_;

	MqlRates neg_rate_;


public:

	void CRatesCache(string symbol, ENUM_TIMEFRAMES tf):
		rates_count_(0),
		rates_reserve_(100),
		tf_(_tf.real(tf)),
		period_seconds_(PeriodSeconds(tf)),
		ser_(new CBSeries(symbol, tf))
	{
		clear();
	}

	void CRatesCache():
		rates_count_(0),
		rates_reserve_(100),
		tf_(_tf.current),
		period_seconds_(_tf.current_seconds),
		ser_(new CBSeries())
	{
		clear();
	}

	void ~CRatesCache()
	{
		_ptr.safe_delete(ser_);
	}

	void clear()
	{
		rates_count_ = 0;
		ZeroMemory(neg_rate_);
		ArrayResize(rates_, 0, rates_reserve_);
	}

	bool load(int start_pos, int count)
	{
		return(load(start_pos, count, rates_reserve_));
	}

	bool load(int start_pos, int count, int reserve)
	{
		int add_count = start_pos + count - rates_count_;
		int add_start = rates_count_;

		reserve = _math.limit_below(reserve, count);
		int reserve_count = start_pos + reserve - rates_count_;

		if (add_count <= 0)
		{
			// nothing to load, reserve is not mandatory
			if (rates_count_ > 0)
				return(true);

			// load at least one bar
			add_count = 1;
			add_start = rates_count_;
			reserve_count = _math.limit_below(reserve_count, 1);
		}

		// load and add to the end
		MqlRates add_rates[];
		int copy_count = ser_.copy_rates(add_start, reserve_count, add_rates);
		CHECK_RETURN(copy_count >= add_count, false);
		rates_count_ += copy_count;
		CHECK_RETURN(_arr.insert_array(rates_, add_rates, 0, rates_reserve_) == rates_count_, false);

		// update neg_rate if necessary
		if (neg_rate_.time <= 0)
		{
			ZeroMemory(neg_rate_);

			// all negative bars are the same except for time
			const double last_close = rates_[rates_count_ - 1].close;
			const datetime last_time = rates_[rates_count_ - 1].time;

			neg_rate_.close = last_close;
			neg_rate_.high  = last_close;
			neg_rate_.low   = last_close;
			neg_rate_.open  = last_close;
			neg_rate_.time = _time.begin_of_period(last_time, tf_);
		}

		return(true);
	}

	// 0 is the rightmost real bar
	// call `load` manually if you need the reserve more than rates_reserve_
	bool get_rate(int bar, MqlRates &rate)
	{
		if (!load(bar, 1, rates_reserve_))
			return(false);

		if (bar >= 0)
		{
			rate = rates_[rates_count_ - 1 - bar];
		}
		else
		{
			rate = neg_rate_;
			rate.time = _time.add_periods(rate.time, -bar, tf_);
		}

		return(true);
	}

	datetime time(int bar, datetime fallback = 0)
	{
		MqlRates rate;
		return(get_rate(bar, rate) ? rate.time : fallback);
	}

};
