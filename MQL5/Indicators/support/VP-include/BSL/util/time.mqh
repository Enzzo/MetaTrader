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

// Функции времени. © FXcoder

#property strict

#include "../type/uncopyable.mqh"

#include "../debug.mqh"
#include "tf.mqh"

class CBTimeUtil: public CBUncopyable
{
public:

	static const int seconds_in_hour;
	static const int seconds_in_day;
	static const int seconds_in_work_week;
	static const int seconds_in_week;
	static const int seconds_in_month;
	static const int seconds_in_non_leap_year;
	static const int seconds_in_leap_year;
	static const int seconds_in_28_years;

	static const datetime null;


private:

	static const datetime mar_second_sunday[28];
	static const datetime mar_last_sunday[28];
	static const datetime oct_last_sunday[28];
	static const datetime nov_first_sunday[28];

	static uint tick_count_prev_;
	static long tick_count_cycle_;


public:

	/*
	Преобразовать переменную типа datetime в структуру MqlDateTime.
	@param time  Время.
	@return      Время в структуре MqlDateTime.
	*/
	static MqlDateTime to_struct(datetime time)
	{
		MqlDateTime time_struct;
		::TimeToStruct(time, time_struct);
		return(time_struct);
	}

	/*
	Обновить структуру времени. Может быть полезно после изменения её частей для обновления полей дня недели и дня года.
	@param time_struct  Время в виде структуры.
	*/
	static void update_struct(MqlDateTime &time_struct)
	{
		::TimeToStruct(::StructToTime(time_struct), time_struct);
	}

	/*
	Получить день недели для указанного времени.
	В MQL4 есть стандартная функция TimeDayOfWeek, но она медленнее в несколько раз (билд 1320)
	@param time  Время.
	@return      День недели.
	*/
	static ENUM_DAY_OF_WEEK day_of_week(datetime time)
	{
		// time/86400  число дней с нулевой даты
		// +4          смещение нулевой даты (день недели)
		// %7          день недели числом
		return((ENUM_DAY_OF_WEEK)(((time / _time.seconds_in_day) + 4) % 7));
	}

	/*
	Получить время начала дня для указанного времени.
	@param time  Исходное время. Если не указано, будет использовано последнее время сервера.
	@return      Время начала дня.
	*/
	static datetime begin_of_day(datetime time)
	{
		return(time - (time % _time.seconds_in_day));
	}

	/*
	Получить время от начала дня.
	@param time  Исходное время.
	@return      Время от начала дня.
	*/
	static datetime time_of_day(datetime time)
	{
		return(time % _time.seconds_in_day);
	}

	/*
	Получить номер минуты от начала дня.
	@param time  Исходное время.
	@return      Минуты от начала дня (0..1439).
	*/
	static int minute_of_day(datetime time)
	{
		return(int(time % _time.seconds_in_day) / 60);
	}

	/*
	Получить время начала недели (первый день - воскресенье).
	@param time     Исходное время.
	@return         Время начала недели. Считается, что первый день недели - воскресенье.
	*/
	static datetime begin_of_week_sun(datetime time)
	{
		time = begin_of_day(time);
		return(time - (int)day_of_week(time) * _time.seconds_in_day);
	}

	/*
	Получить время начала недели (первый день - понедельник).
	@param time     Исходное время.
	@return         Время начала недели. Считается, что первый день недели - понедельник.
	*/
	static datetime begin_of_week_mon(datetime time)
	{
		time = begin_of_day(time);
		int dow = day_of_week(time);

		if (dow == SUNDAY)
			time -= 6 * _time.seconds_in_day;
		else
			time -= (dow - 1) * _time.seconds_in_day;

		return(time);
	}

	/*
	Добавить или вычесть указанное количество рабочих дней.

	@param time  Время, к которому нужно прибавить дни.
	@param days  Количество рабочих дней, которое нужно добавить. При отрицательном значении дни будут вычитаться.
	@return      Время с добавленными или вычтенными днями. 0 при переполнении снизу (мин. дата), не определено при переполнении сверху.
	*/
	static datetime add_work_days(datetime time, int days)
	{
		int weekend_seconds = 2 * _time.seconds_in_day;

		int i;
		ENUM_DAY_OF_WEEK dow;

		if (days > 0)
		{
			for (i = 1; i <= days; i++)
			{
				time += _time.seconds_in_day;
				dow = day_of_week(time);

				// Воскресенье и субботу сдвинуть на понедельник
				if (dow == SUNDAY)
					time += _time.seconds_in_day;
				else if (dow == SATURDAY)
					time += weekend_seconds;
			}
		}
		else
		{
			for (i = 1; i <= -days; i++)
			{
				if (time < _time.seconds_in_day)
					return(0);

				time -= _time.seconds_in_day;
				dow = day_of_week(time);

				// Воскресенье и субботу сдвинуть на пятницу с проверкой на минимальную дату
				if (dow == SUNDAY)
				{
					if (time < weekend_seconds)
						return(0);

					time -= weekend_seconds;
				}
				else if (dow == SATURDAY)
				{
					if (time < _time.seconds_in_day)
						return(0);

					time -= _time.seconds_in_day;
				}
			}
		}

		return(time);
	}

	/*
	Добавить или вычесть указанное количество недель.

	@param time   Время, к которому нужно прибавить недели.
	@param weeks  Количество недель, которое нужно добавить. При отрицательном значении недели будут вычитаться.
	@return       Время с добавленными или вычтенными неделями.
	*/
	static datetime add_weeks(datetime time, int weeks)
	{
		return(add_days(time, 7 * weeks));
	}

	static datetime add_days(datetime time, int days)
	{
		return(time + _time.seconds_in_day * days);
	}

	static datetime add_hours(datetime time, int hours)
	{
		return(time + _time.seconds_in_hour * hours);
	}

	// 0 в случае неудачи (лучше для отладки, чем возвращать исходное время).
	// Без проверок на переполнение.
	// bars может быть с любым знаком, положительные значения смещают в будущее (вправо).
	// Для PERIOD_MN1 результат только в пределах 28 числа.
	static datetime add_periods(datetime time, int bars, ENUM_TIMEFRAMES period = PERIOD_CURRENT)
	{
		const int period_seconds = ::PeriodSeconds(period);

		// для периодов до недельного включительно можно просто добавлять секунды
		if (period_seconds <= _tf.w1_seconds)
			return(time += bars * period_seconds);

		MqlDateTime ts;
		CHECK_RETURN(::TimeToStruct(time, ts) == true, 0);
		CHECK_RETURN(ts.day <= 28, 0);

		int months = (ts.year - 1970) * 12 + ts.mon - 1;
		months += bars;
		ts.year = 1970 + months / 12;
		ts.mon = (months % 12) + 1;

		return(StructToTime(ts));
	}

	/*
	Определить, является ли день выходным (суббота или воскресенье).
	@param time  Время для проверки.
	@return      True - выходной (суббота или воскресенье), false - рабочий день (понедельник - пятница).
	*/
	static bool is_weekend(datetime time)
	{
		ENUM_DAY_OF_WEEK dow = day_of_week(time);
		return((dow == SATURDAY) || (dow == SUNDAY));
	}

	/*
	Проверить, находится ли указанное время в периоде, когда на 1-3 недели меняется разница
	часовых поясов между Америкой и Европой при переходе на летнее время весной. В такие периоды
	американские торговые сессии начинаются на час раньше относительно европейских.

	Быстрый, полутабличный вариант для роботов. Не учитываются нюансы со временем и даже днями недели,
	расчет только на рабочие дни.

	Переход на летнее время весной:
	  - Америка: второе воскресенье марта в 2:00 (на час вперед)
	  - Европа: последнее воскресенье марта в 2:00 (на час вперед)

	@param time  Время, которое нужно проверить на сдвиг
	@return      true, если время находится в периоде весеннего сдвига часовых поясов, false в обычное время.
	*/
	static bool is_in_spring_tz_shift(datetime time)
	{
		int index = (int)(time / _time.seconds_in_non_leap_year) % 28; // такой точности здесь достаточно
		time = time % _time.seconds_in_28_years;
		return((time < _time.mar_last_sunday[index]) && (time >= _time.mar_second_sunday[index]));
	}

	static int hour_of_day(datetime time)
	{
		return((int)((time % _time.seconds_in_day) / _time.seconds_in_hour));
	}

	/*
	Проверить, находится ли указанное время в периоде, когда на 1 неделю меняется разница
	часовых поясов между Америкой и Европой при переходе на зимнее время осенью. В такие периоды
	американские торговые сессии начинаются на час раньше относительно европейских.

	Быстрый, полутабличный вариант для роботов! Не учитываются нюансы со временем и даже днями недели,
	расчет только на рабочие дни.

	Переход на зимнее время осенью:
	  - Америка: первое воскресенье ноября в 2:00 (на 1 час назад)
	  - Европа: последнее воскресенье октября в 3:00 (на 1 час назад)

	@param time  Время, которое нужно проверить на сдвиг

	@return      true, если время находится в периоде осеннего сдвига часовых поясов, false в обычное время.
	*/
	static bool is_in_autumn_tz_shift(datetime time)
	{
		int index = (int)(time / _time.seconds_in_non_leap_year) % 28; // такой точности здесь достаточно
		time = time % _time.seconds_in_28_years;
		return((time >= _time.oct_last_sunday[index]) && (time < _time.nov_first_sunday[index]));
	}

	/*
	Проверить, находится ли указанное время в периоде, когда меняется разница часовых поясов между Америкой и
	Европой при переходе на зимнее время осенью или летнее время весной. В такие периоды американские торговые
	сессии начинаются на час раньше относительно европейских.

	Эквивалентно выражению is_in_spring_tz_shift || is_in_autumn_tz_shift, но без дублирования расчётов.
	*/
	static bool is_in_tz_shift(datetime time)
	{
		int index = (int)(time / _time.seconds_in_non_leap_year) % 28; // такой точности здесь достаточно
		time = time % _time.seconds_in_28_years;
		return(
			((time < _time.mar_last_sunday[index]) && (time >= _time.mar_second_sunday[index])) ||
			((time >= _time.oct_last_sunday[index]) && (time < _time.nov_first_sunday[index]))
		);
	}

	static datetime spring_autumn_tz_shift(datetime time)
	{
		return(is_in_tz_shift(time) ? (time - _time.seconds_in_hour) : time);
	}

	// возвращает теоретическое время открытия бара, в реале может быть другое
	// 0 в случае неизвестного таймфрейма
	static datetime begin_of_period(datetime time, ENUM_TIMEFRAMES tf = PERIOD_CURRENT)
	{
		int tf_seconds = ::PeriodSeconds(tf);

		// для тф меньше недельного подойдёт отбрасывание остатка периода
		if (tf_seconds < _tf.w1_seconds)
			return((time / tf_seconds) * tf_seconds);

		// для недельного тф требуется небольшая магия с округлением и сдвигом из-за того, что
		//   нулевая дата - не воскресенье.
		// сравнение по секундам, чтобы не вызывать _tf.real()
		if (tf_seconds == _tf.w1_seconds)
			return(((time - 3 * _time.seconds_in_day) / _tf.w1_seconds) * _tf.w1_seconds + 3 * _time.seconds_in_day);

		if (tf_seconds == _tf.mn1_seconds)
		{
			MqlDateTime ts;
			if (!::TimeToStruct(time, ts))
				return(0);

			ts.day = 1;
			ts.hour = 0;
			ts.min = 0;
			ts.sec = 0;

			return(::StructToTime(ts));
		}

		return(0);
	}

	static string to_string(datetime time, int flags = TIME_DATE | TIME_MINUTES)
	{
		return(::TimeToString(time, flags));
	}

	static string to_string_msc(long time_msc, bool time_only)
	{
		return
		(
			::TimeToString(time_msc / 1000, time_only ? (TIME_MINUTES | TIME_SECONDS) : (TIME_DATE | TIME_MINUTES | TIME_SECONDS)) +
			"." +
			::IntegerToString(time_msc % 1000, 3, '0')
		);
	}

	/*
	Преобразовать время в строку по заданному шаблону.

	@param date    Дата
	@param format  Шаблон. Можно использовать следующие подстановки:
	                 - yy - год (2 знака),
	                 - yyyy - год (4 знака),
	                 - MM - месяц (2 знака),
	                 - dd - день (2 знака),
	                 - HH - час (2 знака, 24-часовой формат),
	                 - mm - минута (2 знака),
	                 - ss - секунда (2 знака).

	@return        Время в указанном формате.

	@code
	// преобразование в американский формат
	string am_time = to_string_format(D'2011.01.15', "MM/dd/yyyy"); // 01/15/2011

	// преобразование в российский формат
	string ru_time = to_string_format(D'2011.01.15', "dd.MM.yyyy"); // 15.01.2011
	@endcode
	*/
	static string to_string_format(datetime time, string format)
	{
		// пример: 18.03.2011 15:20:55
		//yy    11
		//yyyy  2011
		//MM    03
		//dd    18
		//HH    15
		//mm    20
		//ss    55

		// Формат по умолчанию: yyyy.MM.dd HH:mm:ss
		string s = ::TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
		string res;

		// для часто используемых форматов использовать быстрое преобразование
		if (format == "MM/dd/yyyy")
		{
			// американский формат
			res = ::StringSubstr(s, 5, 2) + "/" + ::StringSubstr(s, 8, 2) + "/" + ::StringSubstr(s, 0, 4);
		}
		else if (format == "dd.MM.yyyy")
		{
			// русский формат
			res = ::StringSubstr(s, 8, 2) + "." + ::StringSubstr(s, 5, 2) + "." + ::StringSubstr(s, 0, 4);
		}
		else if (format == "yyyy-MM-dd")
		{
			// удобный для сортировки
			res = ::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2);
		}
		else
		{
			res = format;
			::StringReplace(res, "yyyy", ::StringSubstr(s, 0,  4));
			::StringReplace(res, "yy",   ::StringSubstr(s, 2,  2));
			::StringReplace(res, "MM",   ::StringSubstr(s, 5,  2));
			::StringReplace(res, "dd",   ::StringSubstr(s, 8,  2));
			::StringReplace(res, "HH",   ::StringSubstr(s, 11, 2));
			::StringReplace(res, "mm",   ::StringSubstr(s, 14, 2));
			::StringReplace(res, "ss",   ::StringSubstr(s, 17, 2));
		}

		return (res);
	}

	// Сортируемый (система, Excel и т.п.), совместимый формат (без T между датой и временем) = "yyyy-MM-dd HH:mm:ss"
	// подходит для экспорта в Excel.
	// Для сортировки в коде оптимальнее будет использовать числовое значение даты.
	static string to_string_sorting(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS); // yyyy.MM.dd HH:mm:ss
		return
		(
			::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2) + " " +
			::StringSubstr(s, 11, 8)
		);
	}

	// to_string_sorting без секунд
	static string to_string_sorting_dm(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE | TIME_MINUTES); // yyyy.MM.dd HH:mm
		return
		(
			::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2) + " " +
			::StringSubstr(s, 11, 5)
		);
	}

	// ISO8601 с нулевым часовым поясом.
	static string to_string_iso8601(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS); // yyyy.MM.dd HH:mm:ss
		return
		(
			::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2) + "T" +
			::StringSubstr(s, 11, 8) + "Z"
		);
	}

	// формат для имени файла: "yyyy-MM-dd_HHmmss"
	static string to_string_file(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS); // yyyy.MM.dd HH:mm:ss
		return
		(
			::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2) + "_" +
			::StringSubstr(s, 11, 2) + ::StringSubstr(s, 14, 2) + ::StringSubstr(s, 17, 2)
		);
	}

	// только день
	static string to_string_file_day(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE); // yyyy.MM.dd
		return
		(
			::StringSubstr(s, 0, 4) + "-" + ::StringSubstr(s, 5, 2) + "-" + ::StringSubstr(s, 8, 2)
		);
	}

	static string to_string_yyyymmdd(datetime time)
	{
		string s = ::TimeToString(time, TIME_DATE); // yyyy.MM.dd
		return
		(
			::StringSubstr(s, 0, 4) + ::StringSubstr(s, 5, 2) + ::StringSubstr(s, 8, 2)
		);
	}


	// Вариант GetTickCount без переполнения
	// Для корректной работы время между вызовами должно быть меньше 49.7 дней (период переполнения GetTickCount)
	static long tick_count_long()
	{
		uint time = ::GetTickCount();

		// переполнение
		if (time < tick_count_prev_)
			tick_count_cycle_++;

		// переполнение недостижимо
		return(tick_count_cycle_ * UINT_MAX + time);
	}
};

const int CBTimeUtil::seconds_in_hour           =           60 * 60; //       3 600
const int CBTimeUtil::seconds_in_day            =         1440 * 60; //      86 400
const int CBTimeUtil::seconds_in_work_week      =     5 * 1440 * 60; //     432 000
const int CBTimeUtil::seconds_in_week           =     7 * 1440 * 60; //     604 800
const int CBTimeUtil::seconds_in_month          =    30 * 1440 * 60; //   2 592 000 // 30-days
const int CBTimeUtil::seconds_in_non_leap_year  =   365 * 1440 * 60; //  31 536 000
const int CBTimeUtil::seconds_in_leap_year      =   366 * 1440 * 60; //  31 622 400
const int CBTimeUtil::seconds_in_28_years       = 10227 * 1440 * 60; // 883 612 800

const datetime CBTimeUtil::null = NULL;

const datetime CBTimeUtil::mar_second_sunday[28] =
{
	D'1970.03.02', D'1971.03.14', D'1972.03.12', D'1973.03.11', D'1974.03.10', D'1975.03.09', D'1976.03.14',
	D'1977.03.13', D'1978.03.12', D'1979.03.11', D'1980.03.09', D'1981.03.02', D'1982.03.14', D'1983.03.13',
	D'1984.03.11', D'1985.03.10', D'1986.03.09', D'1987.03.02', D'1988.03.13', D'1989.03.12', D'1990.03.11',
	D'1991.03.10', D'1992.03.02', D'1993.03.14', D'1994.03.13', D'1995.03.12', D'1996.03.10', D'1997.03.09'
};

const datetime CBTimeUtil::mar_last_sunday[28] =
{
	D'1970.03.29', D'1971.03.28', D'1972.03.26', D'1973.03.25', D'1974.03.31', D'1975.03.30', D'1976.03.28',
	D'1977.03.27', D'1978.03.26', D'1979.03.25', D'1980.03.30', D'1981.03.29', D'1982.03.28', D'1983.03.27',
	D'1984.03.25', D'1985.03.31', D'1986.03.30', D'1987.03.29', D'1988.03.27', D'1989.03.26', D'1990.03.25',
	D'1991.03.31', D'1992.03.29', D'1993.03.28', D'1994.03.27', D'1995.03.26', D'1996.03.31', D'1997.03.30'
};

const datetime CBTimeUtil::oct_last_sunday[28] =
{
	D'1970.10.25', D'1971.10.31', D'1972.10.29', D'1973.10.28', D'1974.10.27', D'1975.10.26', D'1976.10.31',
	D'1977.10.30', D'1978.10.29', D'1979.10.28', D'1980.10.26', D'1981.10.25', D'1982.10.31', D'1983.10.30',
	D'1984.10.28', D'1985.10.27', D'1986.10.26', D'1987.10.25', D'1988.10.30', D'1989.10.29', D'1990.10.28',
	D'1991.10.27', D'1992.10.25', D'1993.10.31', D'1994.10.30', D'1995.10.29', D'1996.10.27', D'1997.10.26'
};

const datetime CBTimeUtil::nov_first_sunday[28] =
{
	D'1970.11.02', D'1971.11.07', D'1972.11.05', D'1973.11.04', D'1974.11.03', D'1975.11.02', D'1976.11.07',
	D'1977.11.06', D'1978.11.05', D'1979.11.04', D'1980.11.02', D'1981.11.02', D'1982.11.07', D'1983.11.06',
	D'1984.11.04', D'1985.11.03', D'1986.11.02', D'1987.11.02', D'1988.11.06', D'1989.11.05', D'1990.11.04',
	D'1991.11.03', D'1992.11.02', D'1993.11.07', D'1994.11.06', D'1995.11.05', D'1996.11.03', D'1997.11.02'
};


uint CBTimeUtil::tick_count_prev_  = ::GetTickCount();
long CBTimeUtil::tick_count_cycle_ = 0;

CBTimeUtil _time;
