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

// Класс доступа к свойствам исторических данных. © FXcoder


#property strict

#include "type/uncopyable.mqh"
#include "type/array/arrayptrt.mqh"
#include "symbolseries.mqh"

#include "util/sym.mqh"
#include "util/tf.mqh"

// mki#25
// шаблон для функций копирования истории, их слишком много (32-36), чтобы поддерживать все по отдельности
#define _BSL_SERIES_COPY_TPL(FUNC, SFUNC, T)                                         \
    bool FUNC(int pos, T &value) const                                               \
    {                                                                                \
        T arr[];                                                                     \
        if (::SFUNC(symbol_, period_, pos, 1, arr) != 1)                             \
            return(false);                                                           \
        value = arr[0];                                                              \
        return(true);                                                                \
    }                                                                                \
    int FUNC(     int start_pos,       int count,     T &arr[]) const { return(::SFUNC(symbol_, period_, start_pos,  count,     arr)); }  \
    int FUNC(datetime start_time,      int count,     T &arr[]) const { return(::SFUNC(symbol_, period_, start_time, count,     arr)); }  \
    int FUNC(datetime start_time, datetime stop_time, T &arr[]) const { return(::SFUNC(symbol_, period_, start_time, stop_time, arr)); }


// шаблон для функций получения котировок с типом float
#define _BSL_SERIES_COPY_TPL_FLOAT(FUNC, SFUNC)                                      \
    bool FUNC##_float(int pos, float &value) const                                   \
    {                                                                                \
        double arr_d[];                                                              \
        if (::SFUNC(symbol_, period_, pos, 1, arr_d) != 1)                           \
            return(false);                                                           \
        value = float(arr_d[0]);                                                     \
        return(true);                                                                \
    }                                                                                \
    int FUNC##_float(int start_pos, int count, float &arr[]) const {                 \
        double arr_d[];                                                              \
        int res = ::SFUNC(symbol_, period_, start_pos, count, arr_d);                \
        if (res < 1)                                                                 \
            return(res);                                                             \
        ::ArrayCopy(arr, arr_d);                                                     \
        return(res);                                                                 \
    }                                                                                \
    int FUNC##_float(datetime start_time, int count, float &arr[]) const {           \
        double arr_d[];                                                              \
        int res = ::SFUNC(symbol_, period_, start_time, count, arr_d);               \
        if (res < 1)                                                                 \
            return(res);                                                             \
        ::ArrayCopy(arr, arr_d);                                                     \
        return(res);                                                                 \
    }                                                                                \
    int FUNC##_float(datetime start_time, datetime stop_time, float &arr[]) const {  \
        double arr_d[];                                                              \
        int res = ::SFUNC(symbol_, period_, start_time, stop_time, arr_d);           \
        if (res < 1)                                                                 \
            return(res);                                                             \
        ::ArrayCopy(arr, arr_d);                                                     \
        return(res);                                                                 \
    }


class CBSymbolSeries;

class CBSeries: public CBUncopyable
{
protected:

	const string symbol_;
	const ENUM_TIMEFRAMES period_;
	const int period_seconds_;
	CBArrayPtrT<CBSymbolSeries> symbol_series_pool_;


public:

	// Для двойной индексации (_series["EURUSD"][PERIOD_D1])

	CBSymbolSeries *operator [](string symbol)
	{
		for (int i = symbol_series_pool_.size() - 1; i >= 0; i--)
		{
			if (symbol_series_pool_.data[i].symbol() == symbol)
				return(symbol_series_pool_.data[i]);
		}

        CBSymbolSeries *sym_ser = new CBSymbolSeries(symbol);
		return(symbol_series_pool_.add_return(sym_ser));
	}


	// Основная часть

	void CBSeries():
		symbol_(_Symbol),
		period_(_tf.current),
		period_seconds_(_tf.current_seconds)
	{
	}

	void CBSeries(string symbol, ENUM_TIMEFRAMES period):
		symbol_(_sym.real(symbol)),
		period_(_tf.real(period)),
		period_seconds_(::PeriodSeconds(period))
	{
	}

	string          symbol() const { return(symbol_); }
	ENUM_TIMEFRAMES period() const { return(period_); }


	// свойства int/bool

	// long в справке по ошибке? остальные баровые функции работают с int
	int bars_count() const
	{
		return((int)info(SERIES_BARS_COUNT));
	}

	datetime first_date        () { return( (datetime) info(SERIES_FIRSTDATE)          ); }
	datetime last_bar_date     () { return( (datetime) info(SERIES_LASTBAR_DATE)       ); }
	datetime server_first_date () { return( (datetime) info(SERIES_SERVER_FIRSTDATE)   ); }

	int bars() const
	{
//#ifdef __MQL4__
		return(::Bars(symbol_, period_));
//#else
//		return(_math.min(::Bars(symbol_, period_), _terminal.max_bars())); // mki#32
//#endif
	}

	int bars(datetime start_time, datetime stop_time) const
	{
		return(::Bars(symbol_, period_, start_time, stop_time));
	}

	_BSL_SERIES_COPY_TPL(copy_rates,       CopyRates,      MqlRates)
	_BSL_SERIES_COPY_TPL(copy_time,        CopyTime,       datetime)
	_BSL_SERIES_COPY_TPL(copy_open,        CopyOpen,       double)
	_BSL_SERIES_COPY_TPL(copy_high,        CopyHigh,       double)
	_BSL_SERIES_COPY_TPL(copy_low,         CopyLow,        double)
	_BSL_SERIES_COPY_TPL(copy_close,       CopyClose,      double)
	_BSL_SERIES_COPY_TPL(copy_tick_volume, CopyTickVolume, long)
	_BSL_SERIES_COPY_TPL(copy_spread,      CopySpread,     int)

	_BSL_SERIES_COPY_TPL_FLOAT(copy_open,  CopyOpen)
	_BSL_SERIES_COPY_TPL_FLOAT(copy_high,  CopyHigh)
	_BSL_SERIES_COPY_TPL_FLOAT(copy_low,   CopyLow)
	_BSL_SERIES_COPY_TPL_FLOAT(copy_close, CopyClose)


	// Обёртки для стандартных функций типа iTime, iBarShift.

	int bar_shift(datetime time, bool exact = false) const
	{
		return(::iBarShift(symbol_, period_, time, exact));
	}

	datetime time(int index, bool zero_limit = true) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif

		if (!zero_limit && (index < 0))
			return(::iTime(symbol_, period_, 0) - index * period_seconds_);

		return(::iTime(symbol_, period_, index));
	}

	double low(int index) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif
		return(::iLow(symbol_, period_, index));
	}

	double high(int index) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif
		return(::iHigh(symbol_, period_, index));
	}

	double close(int index) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif
		return(::iClose(symbol_, period_, index));
	}

	double open(int index) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif
		return(::iOpen(symbol_, period_, index));
	}

	long volume(int index) const
	{
#ifndef __MQL4__
		index = _math.min(index, bars_count() - 1); // mki#32
#endif
		return(::iVolume(symbol_, period_, index));
	}


#ifdef __MQL4__

	int    highest      (int type, int count = WHOLE_ARRAY, int start = 0) const { return(::iHighest(symbol_, period_, type, count, start)); }
	int    lowest       (int type, int count = WHOLE_ARRAY, int start = 0) const { return(::iLowest (symbol_, period_, type, count, start)); }

	double highest_value(int type, int count = WHOLE_ARRAY, int start = 0) const { return(high(highest(type, count, start))); }
	double lowest_value (int type, int count = WHOLE_ARRAY, int start = 0) const { return(low (lowest (type, count, start))); }

#else

	int    highest      (ENUM_SERIESMODE type, int count = WHOLE_ARRAY, int start = 0) const { return(::iHighest(symbol_, period_, type, count, start)); }
	int    lowest       (ENUM_SERIESMODE type, int count = WHOLE_ARRAY, int start = 0) const { return(::iLowest (symbol_, period_, type, count, start)); }

	double highest_value(ENUM_SERIESMODE type, int count = WHOLE_ARRAY, int start = 0) const { return(high(highest(type, count, start))); }
	double lowest_value (ENUM_SERIESMODE type, int count = WHOLE_ARRAY, int start = 0) const { return(low (lowest (type, count, start))); }

#endif

	// дополнительные функции

	//depracated
	/*
	Получить время указанного бара и таймфрейма.
	@param bar         Номер искомого бара.
	@param zero_limit  Не допускать отрицательных значений баров.
	@return            Время искомого бара. Если указан бар с отрицательным номером, возвращается время из будущего без учета
	                   выходных (терминал использует этот же способ для рисования сетки периодов).
	*/
	datetime bar_time(int bar)//, bool zero_limit = false)
	{
		return(time(bar, false));
	}

	/*
	В отличие от bar_shift может принимать отрицательные значения.

	Получить номер бара для указанного времени и таймфрейма.
	@param time        Время искомого бара.
	@param zero_limit  Не допускать отрицательных значений. При true будет работать как bar_shift(int,false).
	@return            Номер бара. Если бар выходит за границу котировок справа, возвращается соответствующее отрицательные
	                   значение.
	*/
	int time_bar(datetime time)//, bool zero_limit = false)
	{
		bool zero_limit = false;

		int bar = bar_shift(time);
		datetime t = this.time(bar);

		// на случай времени за последним баром
		if (!zero_limit && (bar == 0) && (t != time))
			bar = (int)((this.time(0) - time) / period_seconds_);

		return(bar);
	}

	/*
	Получить номер бара для указанного времени и таймфрейма со смещением вправо.
	@param time        Время искомого бара.
	@return            Номер бара. Если бар выходит за границу котировок справа, возвращается соответствующее отрицательное
	                   значение. Если найденный бар имеет время раньше указанного, то возвращается бар справа.
	*/
	int bar_shift_right(datetime time)
	{
		int bar = bar_shift(time);

		// bar == 0 может означать как нулевой бар, так и отрицательный (будущее). В этом случае вычислить бар по формуле разницы.
		if (bar == 0)
			bar = (int)((this.time(0) - time) / period_seconds_);

		// если время не совпадает с открытием бара, то взять правый
		if (time != this.time_to_open_left(time))
			bar--;

		return(bar);
	}

	/*
	Получить номер бара для указанного времени и таймфрейма со смещением влево.
	@param time    Время искомого бара.
	@return        Номер бара. Если бар выходит за границу котировок справа, возвращается соответствующее отрицательное
	               значение. Если найденный бар имеет время раньше указанного, то возвращается бар слева.
	*/
	int bar_shift_left(datetime time)
	{
		int bar = bar_shift(time);
		datetime t = this.time(bar);

		if ((t != time) && (bar == 0))
		{
			// время за пределами диапазона
			bar = (int)((this.time(0) - time) / period_seconds_);
		}
		else
		{
			// проверить, чтобы бар был не справа по времени (документация не уточняет этот момент)
			if (t > time)
				bar++;
		}

		return(bar);
	}

	// Привести время ко времени открытия бара влево.
	// Если время уже на открытии бара, оно не изменится, иначе будет возвращено ближайшее
	//   время открытия слева.
	datetime time_to_open_left(datetime time)
	{
		return(this.time(bar_shift_left(time)));
	}

	// Привести время ко времени открытия бара вправо.
	// Если время уже на открытии бара, оно не изменится, иначе будет возвращено ближайшее
	//   время открытия справа.
	datetime time_to_open_right(datetime time)
	{
		return(this.time(bar_shift_right(time), false));
	}


#ifndef __MQL4__

	// Свойства
	datetime terminal_first_date () { return( (datetime) info(SERIES_TERMINAL_FIRSTDATE) ); }
	bool     synchronized        () { return( (bool)     info(SERIES_SYNCHRONIZED)       ); }

	_BSL_SERIES_COPY_TPL(copy_real_volume, CopyRealVolume, long)

#endif


protected:

	// Универсальные функции доступа к свойствам
	long info(ENUM_SERIES_INFO_INTEGER property_id             ) const { return(::SeriesInfoInteger(symbol_, period_, property_id)); }
	bool info(ENUM_SERIES_INFO_INTEGER property_id, long &value) const { return(::SeriesInfoInteger(symbol_, period_, property_id, value)); }

} _series;
