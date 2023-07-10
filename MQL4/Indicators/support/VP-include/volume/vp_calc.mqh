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

// VP calculator. © FXcoder

#property strict

#include "../bsl.mqh"
#include "../s.mqh"

#include "../enum/applied_volume.mqh"
#include "../enum/quantile.mqh"
#include "enum/vp_bar_ticks.mqh"
#include "enum/vp_source.mqh"
#include "enum/vp_tick_price.mqh"
#include "vp_data_params.mqh"
#include "vp_histogram.mqh"

class CVPCalc
{
protected:

	const CVPDataParams data_;

	const double point_;
	const double point_inverse_; // inverse for faster calculation

	const ENUM_VP_TICK_PRICE tick_price_type_;
	const int tick_flags_;

	double  quantiles_[];
	int     quantiles_count_;


public:

	_GETREF(const CVPDataParams*, data)

	void CVPCalc(
		const CVPDataParams &data,
		double point,
		ENUM_VP_TICK_PRICE tick_price_type,
		int tick_flags,
		ENUM_QUANTILE quantiles
	):
		data_(data),
		point_(point),
		point_inverse_(point == 0 ? _math.nan : (1.0 / point)),
		tick_price_type_(tick_price_type),
		tick_flags_(tick_flags)
	{
		quantiles_count_ = EnumQuantileToArray(quantiles, quantiles_);
	}

	bool get_tick_price(const MqlTick &tick, double &tick_price) const
	{
		if ((tick_flags_ & tick.flags) == 0)
			return(false);

		switch (tick_price_type_)
		{
			case VP_TICK_PRICE_BID:
				tick_price = tick.bid;
				break;

			case VP_TICK_PRICE_ASK:
				tick_price = tick.ask;
				break;

			case VP_TICK_PRICE_LAST:
				tick_price = tick.last;
				break;

			case VP_TICK_PRICE_AVG:
				tick_price = (tick.bid + tick.ask) / 2.0;
				break;

			case VP_TICK_PRICE_LAST_OR_AVG:
				if (tick.last != 0)
					tick_price = tick.last;
				else
					tick_price = (tick.bid + tick.ask) / 2.0;

				break;

			default:
				return(false);
		}

		return(true);
	}

	/**
	Get (calculate) histogram by ticks.

	[time_from..time_to)

	Result:
		-1: loading error / no ticks in history
		 0: no filtered ticks
		>0: number of bars in result histogram
	*/
	int get_hg_by_ticks(datetime time_from, datetime time_to, double &low, double &volumes[]) const
	{
#ifdef __MQL4__

		// No tick data in MT4
		return(0);

#else
		_err.reset();

		const long time_from_ms = time_from * 1000;
		const long time_to_ms   = time_to * 1000;

		// COPY_TICKS_ALL because (from MQL's help) "Call of CopyTicks() with the COPY_TICKS_ALL ... in other modes ... do not provide significant speed advantage.".
		MqlTick ticks[];
		int tick_count = CopyTicksRange(_Symbol, ticks, COPY_TICKS_ALL, time_from_ms, time_to_ms - 1);
		if (tick_count <= 0)
			PRINT_RETURN("CopyTicksRange<=0" + VAR(tick_count) + VAR(time_from) + VAR(time_to), -1);

		// First pass: determine the minimum and maximum, the size of the histogram array.
		// The prices are supposed to be positive.
		int positions[];
		ArrayResize(positions, tick_count);
		ArrayInitialize(positions, -1);
		int pos_max = INT_MIN;
		int pos_min = INT_MAX;
		int hg_size = 0;
		{
			for (int i = 0; i < tick_count; i++)
			{
				// Sometimes obtained ticks are outside the specified range (due to error in the data on the server, for example).
				// In this case, trim the excess. The array itself can be left unchanged; just specify the number of correct ticks.
				// It is assumed that there is no problem of leaving the left border.
				if (ticks[i].time_msc > time_to_ms - 1)
				{
					tick_count = i;
					break;
				}

				double tick_price;
				if (!get_tick_price(ticks[i], tick_price))
					continue;

				const int pos = price_to_points(tick_price);
				positions[i] = pos;

				if (pos < pos_min)
					pos_min = pos;

				if (pos > pos_max)
					pos_max = pos;
			}

			if ((pos_min == INT_MAX) || (pos_max == INT_MIN))
				return(0);

			// lowest price level and number of bars
			low = pos_min * point_;
			hg_size = pos_max - pos_min + 1;
		}

		// Collect all ticks in one histogram.
		{
			ArrayResize(volumes, hg_size);
			ArrayInitialize(volumes, 0.0);
			double total_volume = 0.0;

			for (int i = 0; i < tick_count; i++)
			{
				const int pos = positions[i];

				if (pos < 0)
					continue;

				const int pri = pos - pos_min;

				// If you need a real volume, take it from the tick information.
				// If you need tick volume, then it is enough to take into account each tick exactly once.

				if (data_.volume_type == VOLUME_REAL)
				{
					total_volume += ticks[i].volume_real;
					volumes[pri] += ticks[i].volume_real;
				}
				else
				{
					volumes[pri]++;
				}
			}

			// The broker may not give real volumes for the instrument.
			if ((data_.volume_type == VOLUME_REAL) && (total_volume == 0.0))
				return(0);
		}

		return(hg_size);
#endif
	}

	// Get (calculate) the histogram using bars.
	// Returns -1 on history load error.
	int get_hg(datetime time_from, datetime time_to, double &low, double &volumes[], bool debug = false) const
	{
		_err.reset();

		// Get calculation timeframe bars (usually M1).
		MqlRates rates[];
		CBSeries data_ser(_Symbol, data_.period);
		const int rate_count = data_ser.copy_rates(time_from, time_to, rates);
		if (rate_count <= 0)
			return(rate_count);

		//hack: непонятный баг с запросом вне истории, отдаётся один бар вне запрашиваемой истории
		if ((rate_count == 1) && (rates[0].time > time_to))
			PRINT_RETURN(VAR(rate_count) + " || time...", -1);

		// Determine the minimum and maximum, the size of the histogram array.
		int low_index, high_index, hg_size;
		{
			low_index = price_to_points(rates[0].low);
			high_index = price_to_points(rates[0].high);

			for (int i = 1; i < rate_count; i++)
			{
				const int rate_low_index  = price_to_points(rates[i].low);
				if (rate_low_index < low_index)
					low_index = rate_low_index;

				const int rate_high_index = price_to_points(rates[i].high);
				if (rate_high_index > high_index)
					high_index = rate_high_index;
			}

			low = points_to_price(low_index);
			hg_size = high_index - low_index + 1; // количество цен в гистограмме
		}

		// Collect all ticks in one histogram.
		{
			const ENUM_VP_BAR_TICKS bar_ticks = data_.bar_ticks;
			const ENUM_APPLIED_VOLUME volume_type = data_.volume_type;

			ArrayResize(volumes, hg_size);
			ArrayInitialize(volumes, 0);

			double tmp_hg[];
			if (EnumVPBarTicksIsUsingTempArray(bar_ticks))
				ArrayResize(tmp_hg, hg_size);

			for (int i = 0; i < rate_count; i++)
			{
				const MqlRates rate = rates[i]; // for speed (tested)
				const double v = (double)(volume_type == VOLUME_REAL ? rate.real_volume : rate.tick_volume);

				const int hi = price_to_points(rate.high)  - low_index;
				const int li = price_to_points(rate.low)   - low_index;
				const int n = hi - li + 1;
				ASSERT_RETURN(n > 0, 0);

				if (bar_ticks == VP_BAR_TICKS_OHLC)
				{
					// relative indexes
					const int oi = price_to_points(rate.open)  - low_index;
					const int ci = price_to_points(rate.close) - low_index;

					// Tick imitation
					if (ci >= oi)
					{
						/* Bull bar */

						// average tick volume
						const double dv = v / (oi - li + hi - li + hi - ci + 1.0);

						// [open --> low]
						for (int pri = oi; pri >= li; pri--)
							volumes[pri] += dv;

						// (low ++> high]
						for (int pri = li + 1; pri <= hi; pri++)
							volumes[pri] += dv;

						// (high --> close]
						for (int pri = hi - 1; pri >= ci; pri--)
							volumes[pri] += dv;
					}
					else
					{
						/* Bear bar */

						// average tick volume
						const double dv = v / (hi - oi + hi - li + ci - li + 1.0);

						// [open ++> high]
						for (int pri = oi; pri <= hi; pri++)
							volumes[pri] += dv;

						// (high --> low]
						for (int pri = hi - 1; pri >= li; pri--)
							volumes[pri] += dv;

						// (low ++> close]
						for (int pri = li + 1; pri <= ci; pri++)
							volumes[pri] += dv;
					}
				}
				else if (bar_ticks == VP_BAR_TICKS_HIGH)
				{
					volumes[hi] += v;
				}
				else if (bar_ticks == VP_BAR_TICKS_LOW)
				{
					volumes[li] += v;
				}
				else if (bar_ticks == VP_BAR_TICKS_CLOSE)
				{
					const int ci = price_to_points(rate.close) - low_index;
					volumes[ci] += v;
				}
				else if (bar_ticks == VP_BAR_TICKS_UNIFORM)
				{
					const double dv = v / n;

					for (int pri = li; pri <= hi; ++pri)
						volumes[pri] += dv;
				}
				else if (bar_ticks == VP_BAR_TICKS_PRESENCE)
				{
					const double dv = 1;

					for (int pri = li; pri <= hi; ++pri)
						volumes[pri] += dv;
				}
				else if (bar_ticks == VP_BAR_TICKS_TRIANGULAR)
				{
					// Число шагов восхождения, нисхождения.
					const int n1 = n / 2;
					const int n2 = n - n1;

					// шаг объёма как общий объём / площадь
					const int s1 = (1 + n1) * n1 / 2;
					const int s2 = (1 + n2) * n2 / 2;
					const int s = s1 + s2;
					const double dv = v / s;

					// первая половина треугольника
					for (int j = 0; j < n1; ++j)
						volumes[li + j] += dv * (j + 1);

					// вторая половина треугольника
					for (int j = n1; j < n; ++j)
						volumes[li + j] += dv * (n - j);

				}
				else if ((bar_ticks == VP_BAR_TICKS_PARABOLIC) || (bar_ticks == VP_BAR_TICKS_QUARTIC))
				{
					/*
					Предварительно рассчитать для случая единичной высоты и затем с масштабом добавить
					  к общей гистограмме.
					*/
					{
						const double c = (n - 1.0) / 2.0;
						const double c1sq = _math.sqr(1.0 + c);

						// площадь
						double val;
						double sq = 0.0;

						for (int j = 0; j < n; ++j)
						{
							val = 1.0 - _math.sqr(j - c) / c1sq;

							if (bar_ticks == VP_BAR_TICKS_QUARTIC)
								val = val * val;

							tmp_hg[j] = val;
							sq += val;
						}

						const double k = v / sq;

						for (int j = 0; j < n; ++j)
							volumes[li + j] += tmp_hg[j] * k;
					}
				}
				else
				{
					_ONCE(_debug.warning("Not implemented ENUM_VP_BAR_TICKS: " + EnumToString(bar_ticks)));
					return(0);
				}
			}
		}

		return(hg_size);
	}

	// Get the time of the first available data
	datetime get_horizon() const
	{
#ifndef __MQL4__
		if (data_.source == VP_SOURCE_TICKS)
		{
			MqlTick ticks[];
			const int tick_count = CopyTicks(_Symbol, ticks, COPY_TICKS_ALL, 1, 1);

			// If there is no data, return current time + 1 second
			if (tick_count <= 0)
				return(TimeCurrent() + 1);

			return(ticks[0].time);
		}
#endif

		CBSeries data_ser(_Symbol, data_.period);
		return(data_ser.time(data_ser.bars_count() - 1));
	}


	void smooth_hg(const int depth, CVPHistogram &hg) const
	{
		smooth_hg(depth, hg.point, hg.low_price, hg.volumes);
	}

	// Smooth histogram step by step.
	// There is a faster version of the same algorithm based on the sum of the columns of the Pascal's
	//   pyramid, but it requires working with very large numbers outside the standard data types.
	// The function leaves zero tails, but they will be truncated when displayed.
	void smooth_hg(const int depth, const double hg_point, double &low_price, double &volumes[]) const
	{
		if (depth <= 0)
			return;

		const int hg_size = ArraySize(volumes);

		// copy and expand hg with zeroes on both sides
		int new_hg_size;
		double hg_prev[];
		double hg_next[];
		{
			new_hg_size = hg_size + 2 * (depth + 1);
			_arr.resize_fill(hg_prev, new_hg_size, 0.0);
			_arr.resize_fill(hg_next, new_hg_size, 0.0);
		}

		// step by step averaging
		{
			ArrayCopy(hg_prev, volumes, depth + 1, 0);

			// It is necessary to divide by 3 (average) instead of summing up at each step because of the probability of overflow.
			// This constant is for speed.
			const double one_third = 1.0 / 3.0;
			for (int d = 1; d <= depth; d++)
			{
				for (int i = depth + 1 - d, last = depth + 1 + hg_size - 1 + d; i <= last; i++)
					hg_next[i] = (hg_prev[i - 1] + hg_prev[i] + hg_prev[i + 1]) * one_third;

				ArrayCopy(hg_prev, hg_next);
			}
		}

		low_price -= hg_point * (depth + 1);
		_arr.clone(volumes, hg_prev);
	}

	// Индексы квантилей в гистограмме. Смещаются к центру, что может приводить к небольшим искажениям.
	int quantiles_indexes(const double &data[], int &q_indexes[]) const
	{
		ArrayResize(q_indexes, quantiles_count_);

		for (int i = 0; i < quantiles_count_; ++i)
		{
			const double probe = quantiles_[i];
			const double pos = quantile_pos(data, probe);

			if (pos == -1)
				q_indexes[i] = -1;
			else if (probe > 0.5)
				q_indexes[i] = (int)floor(pos);
			else // if (probe <= 0.5)
				q_indexes[i] = (int)ceil(pos);
		}

		return(quantiles_count_);
	}

	// Найти позицию квантиля.
	// Может находиться между элементами, метод округления выбирается вызывающей стороной.
	// Это упрощённый и адаптированный метод, использовать только с VP и подобными данными.
	// Для пустого массива вернётся -1.
	double quantile_pos(const double &data[], double probe) const
	{
		const int n = ArraySize(data);

		if (probe <= 0)
			return(-0.5);

		if (probe >= 1)
			return(n - 0.5);

		const double sum = _math.sum(data, 0, n);
		const double stop_sum_f = sum * probe;

		// forward
		double index_f = -1;
		double cum_sum_f = 0;

		for (int i = 0; i < n; ++i)
		{
			cum_sum_f += data[i];

			if (cum_sum_f == stop_sum_f)
			{
				index_f = i + 0.5;
				break;
			}

			if (cum_sum_f > stop_sum_f)
			{
				index_f = i - 0.5;
				break;
			}
		}

		if (index_f == -1)
			return(-1);

		const double stop_sum_b = sum * (1.0 - probe);
		double index_b = -1;
		double cum_sum_b = 0;

		// backward

		for (int i = 0; i < n; ++i)
		{
			cum_sum_b += data[n - 1 - i];

			if (cum_sum_b == stop_sum_b)
			{
				index_b = i + 0.5;
				break;
			}

			if (cum_sum_b > stop_sum_b)
			{
				index_b = i - 0.5;
				break;
			}
		}

		if (index_b == -1)
			return(-1);

		index_b = n - 1 - index_b;

		return((index_f + index_b) / 2.0);
	}


protected:

	int price_to_points(const double price) const
	{
		return((int)(price * point_inverse_ + 0.5));
	}

	double points_to_price(const int points) const
	{
		return(points * point_);
	}

};
