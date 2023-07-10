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

// Строковые функции. © FXcoder


#property strict

#include "../type/uncopyable.mqh"
#include "arr.mqh"

class CBStringUtil: public CBUncopyable
{
public:

	static const string empty;
	static const string comma_alt_separators[]; // альтернативные разделители строковых параметров, разделённых запятой


public:

	// сравнение строк для типовой сортировки
	static int compare_sorting(const string &s1, const string &s2)
	{
		return(::StringCompare(s1, s2, false));
	}

	static bool contains(string s, string match, int start_pos = 0)
	{
		return(::StringFind(s, match, start_pos) >= 0);
	}

	// отрезать слева cut_len знаков
	static string cut_start(string s, int cut_len)
	{
		if (cut_len <= 0)
			return(s);

		if (cut_len >= StringLen(s))
			return("");

		return(::StringSubstr(s, cut_len));
	}

	// отрезать справа cut_len знаков
	static string cut_end(string s, int cut_len)
	{
		if (cut_len <= 0)
			return(s);

		const int s_len = StringLen(s);

		if (cut_len >= s_len)
			return("");

		return(::StringSubstr(s, 0, s_len - cut_len));
	}

	// отрезать слева cut, если есть
	static string cut_start(string s, string cut)
	{
		if (!starts_with(s, cut))
			return(s);

		return(cut_start(s, StringLen(cut)));
	}

	// отрезать справа cut, если есть
	static string cut_end(string s, string cut)
	{
		if (!ends_with(s, cut))
			return(s);

		return(cut_end(s, StringLen(cut)));
	}

	/*
	Заменить подстроку в строке на указанную.
	@param  s     Исходная строка.
	@param  from  Искомая подстрока.
	@param  to    Строка, на которую нужно заменить указанную подстроку.
	@return       Преобразованная строка.
	*/
	static string replace(string s, string from, string to)
	{
		// Используем стандартную функцию
		::StringReplace(s, from, to);
		return(s);
	}

	// Заменить в строке s все строки из from на to
	static string replace(string s, const string &from[], string to)
	{
		string res = s;

		for (int i = 0, size = ::ArraySize(from); i < size; i++)
			::StringReplace(res, from[i], to);

		return(res);
	}

	static string trim_start(string s)
	{
#ifdef __MQL4__
		return(::StringTrimLeft(s));
#else
		::StringTrimLeft(s);
		return(s);
#endif
	}

	/*
	Убрать указанные символы в начале строки.
	@param  s   Входная строка для преобразований.
	@param  ch  Удаляемый символ.
	@return     Строка без указанных символов в начале.
	*/
	static string trim_start(string s, ushort ch)
	{
		int len = ::StringLen(s);

		// Найти конец вырезаемого от начала участка
		int cut = 0;

		for (int i = 0; i < len; i++)
		{
			if (::StringGetCharacter(s, i) == ch)
				cut++;
			else
				break;
		}

		// Отрезать
		if (cut > 0)
		{
			if (cut > len - 1)
				s = "";
			else
				s = ::StringSubstr(s, cut);
		}

		return(s);
	}


	// убрать справа пустые символы, как в StringTrimLeft()
	static string trim_end(string s)
	{
#ifdef __MQL4__
		return(::StringTrimRight(s));
#else
		::StringTrimRight(s);
		return(s);
#endif
	}

	/*
	Убрать указанные символы в конце строки.
	@param s   Входная строка для преобразований.
	@param ch  Удаляемый символ.
	@return    Строка без указанных символов в конце.
	*/
	static string trim_end(string s, ushort ch)
	{
		int len = ::StringLen(s);

		// Найти начало вырезаемого до конца участка
		int cut = len;

		for (int i = len - 1; i >= 0; i--)
		{
			if (::StringGetCharacter(s, i) == ch)
				cut--;
			else
				break;
		}

		if (cut != len)
			return(cut == 0 ? "" : ::StringSubstr(s, 0, cut));

		return(s);
	}


	/*
	Убрать пустые символы в начале и конце строки
	@param s   Входная строка для преобразований.
	@return    Строка без указанных символов в начале и конце.
	*/
	static string trim(string s)
	{
#ifdef __MQL4__
		s = ::StringTrimRight(s);
		s = ::StringTrimLeft(s);
#else
		::StringTrimRight(s);
		::StringTrimLeft(s);
#endif
		return(s);
	}


	/*
	Убрать указанные символы в начале и конце строки
	@param s   Входная строка для преобразований.
	@param ch  Удаляемый символ. Если не указан (-1), удаляются символы перевода строк, пробелы, табуляция.
	@return    Строка без указанных символов в начале и конце.
	*/
	static string trim(string s, ushort ch)
	{
		return(trim_start(trim_end(s, ch), ch));
	}

	static double to_double(const string s) { return(     StringToDouble (s)); }
	static long   to_long  (const string s) { return(     StringToInteger(s)); }
	static int    to_int   (const string s) { return((int)StringToInteger(s)); }

	/*
	Разбить строку на отдельные строки, разделенные в исходной строке указанным разделителем.
	@param s            Входная строка.
	@param sep          Разделитель.
	@param parts[]      Ссылка на результат - массив строк.
	@param remove_empty  Пропускать пустые строки.
	@param unique       Добавлять только уникальные значения.
	@return             Количество строк в результирующем массиве строк. Сам массив передается по ссылке
	                    в параметрах.
	*/
	static int split(string s, string sep, bool remove_empty, bool unique, string &parts[])
	{
		int sep_len = ::StringLen(sep);

		// Оптимизация наиболее часто используемого варианта за счёт использования стандартной функции со схожим, но ограниченным, функционалом.
		if (!remove_empty && !unique && (sep_len == 1))
		{
			ushort sep_char = ::StringGetCharacter(sep, 0);
			return(::StringSplit(s, sep_char, parts));
		}


		int reserve = ::StringLen(s) / 2; // оптимальное значение зависит от типовых задач, len/2 - это почти максимум
		int count = 0;
		::ArrayFree(parts);

		while (true)
		{
			int p = ::StringFind(s, sep);

			if (p >= 0)
			{
				string part = (p == 0) ? "" : ::StringSubstr(s, 0, p);

				if (!remove_empty || (trim(part) != ""))
				{
					if (unique)
						_arr.set(parts, part, reserve);
					else
						_arr.add(parts, part, reserve);

					count = ::ArraySize(parts);
				}

				s = ::StringSubstr(s, p + sep_len);
			}
			else
			{
				// Последний кусок
				if (!remove_empty || (trim(s) != ""))
				{
					if (unique)
						_arr.set(parts, s, reserve);
					else
						_arr.add(parts, s, reserve);

					count = ::ArraySize(parts);
				}

				break;
			}
		}

		// удалить последнюю пустую строку
		if ((count > 0) && (parts[count - 1] == ""))
		{
			count--;

			if (count > 0)
				::ArrayResize(parts, count);
		}

		return(count);
	}

	static int split_input_csv(string s, bool unique, string &parts[])
	{
		return(split(replace(s, _str.comma_alt_separators, ","), ",", true, unique, parts));
	}

	/*
	Перевести строку в верхний регистр
	@param s  Исходная строка.
	@return   Строка, переведенная в верхний регистр.
	*/
	static string upper(string s)
	{
		::StringToUpper(s);
		return(s);
	}

	/*
	Перевести строку в нижний регистр
	@param s  Исходная строка.
	@return   Строка, переведенная в нижний регистр.
	*/
	static string lower(string s)
	{
		::StringToLower(s);
		return(s);
	}

	// ("123", 5)  =>  "  123"
	static string pad_left(string s, int total_length, ushort fill_char)
	{
		int len = ::StringLen(s);
		if (len >= total_length)
			return(s);

		string spaces;
		::StringInit(spaces, total_length - len, fill_char);
		return(spaces + s);
	}

	static string pad_left(string s, int total_length)
	{
		return(pad_left(s, total_length, ' '));
	}

	// ("123", 5)  =>  "123  "
	static string pad_right(string s, int total_length, ushort fill_char)
	{
		int len = ::StringLen(s);
		if (len >= total_length)
			return(s);

		string spaces;
		::StringInit(spaces, total_length - len, fill_char);
		return(s + spaces);
	}

	static string pad_right(string s, int total_length)
	{
		return(pad_right(s, total_length, ' '));
	}

	/*
	("123", 5)  =>  "123  "
	("123", -5)  =>  "  123"
	*/
	static string pad(string s, int total_length, ushort fill_char)
	{
		if (total_length > 0)
			return(pad_right(s, total_length, fill_char));

		if (total_length < 0)
			return(pad_left(s, -total_length, fill_char));

		// total_length == 0
		return(s);
	}

	static string pad(string s, int total_length)
	{
		return(pad(s, total_length, ' '));
	}

	static bool is_empty(string s)
	{
		// "" и NULL - разные значения (5.2007), но оба означают пустую строку
		return((s == "") || (s == NULL));
	}

	// Проверить, является ли строка строковым представлением целого числа (int).
	static bool is_int(string s)
	{
		int len = ::StringLen(s);
		if (len <= 0)
			return(false);

		ushort ch = ::StringGetCharacter(s, 0);

		// начальная позиция сканирования на цифры
		int first = ((ch == '-') || (ch == '+')) ? 1 : 0;
		int digits_count = len - first;

		// fast check by length
		if ((digits_count > 10) || (digits_count == 0))
			return(false);

		for (int i = first; i < len; i++)
		{
			ch = ::StringGetCharacter(s, i);

			if ((ch < '0') || (ch > '9'))
				return(false);
		}

		return(true);
	}

	//  true: строка s начинается на match_string
	// false: иначе, либо если любая из строк пуста
	static bool starts_with(const string s, const string match_string)
	{
		return(::StringFind(s, match_string) == 0);
	}

	//  true: строка s заканчивается на match_string
	// false: иначе, либо если любая из строк пуста
	static bool ends_with(const string s, const string match_string)
	{
		return(::StringFind(s, match_string) == (::StringLen(s) - ::StringLen(match_string)));
	}

};

const string CBStringUtil::empty = "";
const string CBStringUtil::comma_alt_separators[]   = { " ", ";" };

CBStringUtil _str;
