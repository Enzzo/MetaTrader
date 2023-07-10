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
Conversion Functions. © FXcoder
Здесь собраны функции преобразования из типов данных, которые не представлены отдельно.
Если для какого-либо типа данных накапливается несколько функций, следует выделить в
отдельный класс, позже будет сложнее.
*/

#property strict

#include "../type/uncopyable.mqh"
#include "../global.mqh"
#include "double.mqh"
#include "str.mqh"
#include "tf.mqh"


class CBConvertUtil: public CBUncopyable
{
public:

	// Преобразовать anchor типа ENUM_ANCHOR_POINT (граф. объекты) в тип uint (для TextOut)
	static uint anchor_to_text_anchor(ENUM_ANCHOR_POINT anchor)
	{
		switch (anchor)
		{
			case ANCHOR_LEFT_UPPER:    return(TA_LEFT | TA_TOP);
			case ANCHOR_LEFT:          return(TA_LEFT | TA_VCENTER);
			case ANCHOR_LEFT_LOWER:    return(TA_LEFT | TA_BOTTOM);
			case ANCHOR_UPPER:         return(TA_CENTER | TA_TOP);
			case ANCHOR_CENTER:        return(TA_CENTER | TA_VCENTER);
			case ANCHOR_LOWER:         return(TA_CENTER | TA_BOTTOM);
			case ANCHOR_RIGHT_UPPER:   return(TA_RIGHT | TA_TOP);
			case ANCHOR_RIGHT:         return(TA_RIGHT | TA_VCENTER);
			case ANCHOR_RIGHT_LOWER:   return(TA_RIGHT | TA_BOTTOM);
			default:                   return(0);
		}
	}

	/*
	Преобразовать используемую цену в строковое представление.
	Функция может быть полезна при отображении параметров пользователю.
	@param ap       Используемая цена (applied price). Диапазон: от PRICE_CLOSE до PRICE_WEIGHTED.
	@param verbose  Выводить словесное представление.
	@return         Строковое представление используемой цены.

	                ap             | Результат (verbose=false) | Результат (verbose=true)
	                ---------------|---------------------------|-------------
	                PRICE_CLOSE    | "C"                       | "Close"
	                PRICE_OPEN     | "O"                       | "Open"
	                PRICE_HIGH     | "H"                       | "High"
	                PRICE_LOW      | "L"                       | "Low"
	                PRICE_MEDIAN   | "HL"                      | "Median"
	                PRICE_TYPICAL  | "HLC"                     | "Typical"
	                PRICE_WEIGHTED | "HLCC"                    | "Weighted"
	                Остальные      | "?"                       | "Unknown"
	*/
	string ap_to_string(ENUM_APPLIED_PRICE ap, bool verbose = false)
	{
		switch (ap)
		{
			case PRICE_CLOSE:    return(verbose ? "Close"    : "C");
			case PRICE_OPEN:     return(verbose ? "Open"     : "O");
			case PRICE_HIGH:     return(verbose ? "High"     : "H");
			case PRICE_LOW:      return(verbose ? "Low"      : "L");
			case PRICE_MEDIAN:   return(verbose ? "Median"   : "HL");
			case PRICE_TYPICAL:  return(verbose ? "Typical"  : "HLC");
			case PRICE_WEIGHTED: return(verbose ? "Weighted" : "HLCC");
			default:             return(verbose ? "Unknown"  : "?");
		}
	}

	static ENUM_ANCHOR_POINT corner_to_anchor(ENUM_BASE_CORNER corner)
	{
		if (corner == CORNER_LEFT_UPPER)
			return(ANCHOR_LEFT_UPPER);

		if (corner == CORNER_LEFT_LOWER)
			return(ANCHOR_LEFT_LOWER);

		if (corner == CORNER_RIGHT_UPPER)
			return(ANCHOR_RIGHT_UPPER);

		return(ANCHOR_RIGHT_LOWER);
	}

	/*
	Преобразовать шестнадцатеричное представление числа в целое.
	@param hex  Строка для преобразования. Допускается весь диапазон чисел типа int, включая отрицательные значения.
	@param res  Результат преобразования.
	@return     Успех операции. Не каждая строка может быть преобразована.
	*/
	static bool hex_to_int(string hex, int &res)
	{
		// убрать нули слева и поднять регистр
		string hex_normalized = _str.upper(_str.trim_start(_str.trim(hex), '0'));
		int len = ::StringLen(hex_normalized);

		// не влезет в int
		if (len > 8)
			return(false);

		res = 0;

		for (int i = 0; i < len; i++)
		{
			res = res << 4;

			ushort ch = ::StringGetCharacter(hex_normalized, i);

			if ((ch >= '0') && (ch <= '9'))
				res = res | (ch - '0');
			else if ((ch >= 'A') && (ch <= 'F'))
				res = res | (10 + ch - 'A');
			else
				return(false);
		}

		return(true);
	}

	/*
	Преобразовать целое число в шестнадцатеричное представление.
	Например, 123456789 будет преобразовано в "075BCD15".
	@param n  Число для преобразования. Допускается весь диапазон чисел типа int, включая отрицательные значения.
	@return   Строка - шестнадцатеричное представление указанного числа.
	*/
	static string int_to_hex(int n)
	{
		string res = "";

		for (int i = 28; i >= 0; i -= 4)
			res += ::CharToString(hex_digit_to_char((uchar)((n & (0xf << i)) >> i)));

		return(res);
	}

	static string byte_to_hex(uchar n)
	{
		uchar digit0 = (uchar)(0xf & n);
		uchar digit1 = (uchar)(0xf & (n >> 4));
		return(::CharToString(hex_digit_to_char(digit1)) + CharToString(hex_digit_to_char(digit0)));
	}

	static string bytes_to_hex(const uchar &bytes[])
	{
		string res_str = "";

		for (int i = 0, size = ArraySize(bytes); i < size; i++)
			res_str += _conv.byte_to_hex(bytes[i]);

		return(res_str);
	}

	/*
	@param digit  0..15
	@return       '0'..'F'
	*/
	static uchar hex_digit_to_char(uchar digit)
	{
		if (digit > 9)
			return((uchar)('A' - 10 + digit));
		else
			return((uchar)('0' + digit));
	}

	/*
	Преобразовать тип средней в строковое представление.
	Функция может быть полезна при отображении параметров пользователю.
	@param ma_method  Тип средней. Диапазон: от MODE_SMA до MODE_LWMA.
	@return           Строковое представление типа средней.
	                  ma_method          | Результат
	                  -------------------|-------------
	                  0, MODE_SMA        | "SMA"
	                  1, MODE_EMA        | "EMA"
	                  2, MODE_SMMA       | "SMMA"
	                  3, MODE_LWMA       | "LWMA"
	                  Остальные значения | "MA?#"
	*/
	static string ma_method_to_string(ENUM_MA_METHOD ma_method)
	{
		switch (ma_method)
		{
			case MODE_SMA:  return("SMA");
			case MODE_EMA:  return("EMA");
			case MODE_SMMA: return("SMMA");
			case MODE_LWMA: return("LWMA");
			default:        return("MA?" + ::IntegerToString(ma_method));
		}
	}

	/*
	Преобразовать минуту дня в текстовое 24-часовое представление времени.

	Примеры преобразования:
	Минута  | Текстовое представление
	-------:|-------------------------
	     5  | "00:05"
	    -5  | "23:55"
	     0  | "00:00"
	   725  | "12:05"
	   1445 | "00:05"

	@param minute  Минута дня. Можно использовать как положительные значения (от полуночи вперед), так и отрицательные (от полуночи назад).
	@return        Текстовое представление времени.
	*/
	static string minute_to_string(int minute)
	{
		int day_minute = minute % 1440;
		if (day_minute < 0)
			day_minute += 1440;

		// Разбить на составляющие
		int h = day_minute / 60;
		int m = day_minute % 60;

		return(::IntegerToString(h, 2, '0') + ":" + ::IntegerToString(m, 2, '0'));
	}

	/*
	Преобразовать количество знаков после запятой в пункт. Отрицательные значения допустимы (-1 => 10, -2 => 100).
	*/
	static double digits_to_point(int digits)
	{
		return(::pow(10.0, -digits));
	}

	/*
	Получить количество знаков после запятой для указанного пункта.
	Возможно, не работает на всех возможных значениях point из-за ограничения точности представления чисел.
	*/
	static int point_to_digits(double point, int max_digits)
	{
		if (point == 0)
			return(max_digits);

		string point_string = _double.to_string_compact(point, max_digits);
		int point_string_len = ::StringLen(point_string);
		int dot_pos = ::StringFind(point_string, ".");

		// point_string => result:
		//   1230   => -1
		//   123    =>  0
		//   12.3   =>  1
		//   1.23   =>  2
		//   0.123  =>  3
		//   .123   =>  3

		return(dot_pos < 0
			? ::StringLen(_str.trim_end(point_string, '0')) - point_string_len
			: point_string_len - dot_pos - 1);
	}

	/*
	Преобразовать массив целых чисел в сокращённый список.
	Примеры:
		[1, 2, 3, 4, 5, 6, 7]  => "1..7/7" + suffux
		[3, 5, 8, 13, 21]      => "3..21/5" + suffux
	*/
	static string range_to_string(const int &range[], string suffix)
	{
		int sorted[];
		::ArrayCopy(sorted, range);
		::ArraySort(sorted);

		int count = ::ArraySize(sorted);

		if (count <= 0)
			return("");

		if (count == 1)
			return((string)sorted[0]);

		if (count == 2)
			return((string)sorted[0] + "," + (string)sorted[1]);

		// all are equal
		if (sorted[0] == sorted[count - 1])
			return(string(sorted[0]) + ".." + string(sorted[count - 1]));

		return((string)sorted[0] + ".." + (string)sorted[count - 1] + "/" + (string)count + suffix);
	}

	/*
	Преобразовать сортированный массив целых чисел в сокращённый список (альтернативный вариант).
	[1, 2, 3, 4, 5, 6, 7]  =>  "1, 2..7"
	[1, 5]                 =>  "1, 5"
	[3, 5, 8, 13, 21]      =>  "3, 5..21"
	*/
	static string range_to_string_alt(int &range[])
	{
		int count = ::ArraySize(range);
		if (count <= 0)
			return("");

		string res = (string)range[0];

		if (count > 1)
			res += "," + (string)range[1];

		if (count > 2)
			res += "," + (string)range[2];

		if (count > 3)
			res += (count == 4 ? "," : "..") + (string)range[count - 1];

		return(res);
	}

	static double rate_to_price(const MqlRates &rate, ENUM_APPLIED_PRICE applied_price)
	{
		// Т.к. в таких функциях скорость обычно критична очевидный вызов ohlc_to_price лучше заменить на его код (инлайн вручную).
		// Возможно, компилятор делает такой инлайн сам, но вряд ли в 4, так что актуально.

		switch (applied_price)
		{
			case PRICE_CLOSE:    return(rate.close);
			case PRICE_OPEN:     return(rate.open);
			case PRICE_HIGH:     return(rate.high);
			case PRICE_LOW:      return(rate.low);
			case PRICE_MEDIAN:   return((rate.high + rate.low) / 2.0);
			case PRICE_TYPICAL:  return((rate.high + rate.low + rate.close) / 3.0);
			case PRICE_WEIGHTED: return((rate.high + rate.low + rate.close + rate.close) / 4.0);
		}

		// этот исход возможен только при явной ошибке в applied_price, либо если в новых версий появятся новые типы
		return(EMPTY_VALUE);
	}

	static double ohlc_to_price(double open, double high, double low, double close, ENUM_APPLIED_PRICE applied_price)
	{
		switch (applied_price)
		{
			case PRICE_CLOSE:    return(close);
			case PRICE_OPEN:     return(open);
			case PRICE_HIGH:     return(high);
			case PRICE_LOW:      return(low);
			case PRICE_MEDIAN:   return((high + low) / 2.0);
			case PRICE_TYPICAL:  return((high + low + close) / 3.0);
			case PRICE_WEIGHTED: return((high + low + close + close) / 4.0);
		}

		// этот исход возможен только при явной ошибке в applied_price, либо если в новых версий появятся новые типы
		return(EMPTY_VALUE);
	}

	static bool reverse_ohlc(double &open, double &high, double &low, double &close)
	{
		if ((open == 0) || (high == 0) || (low == 0) || (close == 0))
			return(false);

		open  = 1.0 / open;
		high  = 1.0 / high;
		low   = 1.0 / low;
		close = 1.0 / close;

		swap(high, low);
		return(true);
	}

	static void reverse_ohlc_log(double &open, double &high, double &low, double &close)
	{
		open  = -open;
		high  = -high;
		low   = -low;
		close = -close;

		swap(high, low);
	}

} _conv;
