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

// Функции чисел (double и float). © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "str.mqh"

class CBNumberUtil: public CBUncopyable
{
public:

	/*
	Преобразовать число (double) в строку с указанием знаков и разделителя целой и дробной части.
	@param d          Число
	@param digits     Количество знаков после запятой (как в DoubleToString)
	@param dot        Разделитель целой и дробной частей
	@return           Число в строковом формате.
	*/
	static string to_string(double value, int digits, uchar dot)
	{
		string s = ::DoubleToString(value, digits);
		replace_dot(s, dot);
		return(s);
	}

	static string to_string(double value, int digits)  { return(::DoubleToString(value, digits)); }
	static string to_string(double value)              { return(::DoubleToString(value)); }

	static string to_string_sign(double value, int digits, uchar dot, string zero_sign = "", string plus_sign = "+", string minus_sign = "-")
	{
		if (value == 0)
			return(zero_sign + to_string(value, digits, dot));

		if (value > 0)
			return(plus_sign + to_string(value, digits, dot));

		return(minus_sign + to_string(::fabs(value), digits, dot));
	}

	static string to_string_sign(double value, int digits, string zero_sign = "", string plus_sign = "+", string minus_sign = "-")
	{
		if (value == 0)
			return(zero_sign + ::DoubleToString(value, digits));

		if (value > 0)
			return(plus_sign + ::DoubleToString(value, digits));

		return(minus_sign + ::DoubleToString(fabs(value), digits));
	}

	/*
	Компактно преобразовать число (double) в строку с указанием максимального числа знаков.
	Компактность достигается за счет удаление лишних завершающих нулей в дробной части. Может быть удобно для показа
	числовых данных пользователю, когда нужна максимальная точность, но без отображения лишней информации.
	@param d          Число
	@param digits     Максимальное количество знаков после запятой
	@return           Число в строковом формате без лишних завершающих нулей в дробной части.
	*/
	static string to_string_compact(double value, int digits = 8)
	{
		string s = ::DoubleToString(value, digits);

		// убрать нули в конце дробной части
		if (::StringFind(s, ".") >= 0)
		{
			s = _str.trim_end(s, '0');
			s = _str.trim_end(s, '.');
		}

		return(s);
	}

	static string to_string_compact(double value, int digits, uchar dot)
	{
		string s = to_string_compact(value, digits);
		replace_dot(s, dot);
		return(s);
	}

private:

	// dot=0 уберёт разделитель (см. StringSetCharacter)
	static void replace_dot(string &s, uchar dot)
	{
		if (dot == '.')
			return;

		int p = ::StringFind(s, ".");
		if (p != -1)
			::StringSetCharacter(s, p, dot);
	}

};
