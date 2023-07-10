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

// Функции символа (инструмента). © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "str.mqh"

class CBSymbolUtil: public CBUncopyable
{
public:

	static const string current;


public:

	static bool is_current(string symbol)
	{
		return(real(symbol) == _sym.current);
	}

	// selected_only - искать только в выбранных (в обзоре рынка)
	//tested: 4.1170
	static bool exists(string symbol, bool selected_only = false)
	{
#ifdef __MQL4__
		// Если свойство успешно считано, символ существет
		// проверка на ERR_MARKET_NOT_SELECTED здесь не нужна, т.к. код ниже её игнорирует (5.2007)
		long tmp;
		if (!::SymbolInfoInteger(symbol, SYMBOL_DIGITS, tmp))
			return(false);
#else
		if (!(bool)::SymbolInfoInteger(symbol, SYMBOL_EXIST))
			return(false);
#endif

		return(!selected_only || (bool)::SymbolInfoInteger(symbol, SYMBOL_SELECT));
	}

	// return current symbol if `symbol` does not exist
	static bool validate_input(string &symbol)
	{
		if (_sym.is_current(symbol))
		{
			symbol = _sym.current;
			return(true);
		}

		if (_sym.exists(symbol))
			return(true);

		if (_sym.exists(_str.upper(symbol)))
		{
			symbol = _str.upper(symbol);
			return(true);
		}

		return(false);
	}

	// return current if empy
	static string real(string symbol)
	{
		return(_str.is_empty(symbol) ? _Symbol : symbol);
	}

};

const string CBSymbolUtil::current  = Symbol();

CBSymbolUtil _sym;
