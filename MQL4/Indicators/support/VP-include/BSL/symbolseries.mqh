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

// Класс серии символа. © FXcoder

#property strict

#include "type/uncopyable.mqh"
#include "series.mqh"
#include "type/array/arrayptrt.mqh"

class CBSeries;

class CBSymbolSeries: public CBUncopyable
{
private:

	const string symbol_;
	CBArrayPtrT<CBSeries> series_pool_;


public:

	void CBSymbolSeries(string symbol): symbol_(symbol) { }
	//void ~CBSymbolSeries() { series_pool_.safe_delete(); }

	CBSeries *operator[](ENUM_TIMEFRAMES period)
	{
		for (int i = series_pool_.size() - 1; i >= 0; i--)
		{
			if (series_pool_.data[i].period() == period)
				return(series_pool_.data[i]);
		}

		CBSeries *ser = new CBSeries(symbol_, period);
		return(series_pool_.add_return(ser));
	}

	string symbol() const { return(symbol_); }

	datetime server_first_date    () { return( (datetime) ::SeriesInfoInteger(symbol_, _Period, SERIES_SERVER_FIRSTDATE)   ); }


#ifndef __MQL4__

	datetime terminal_first_date  () { return( (datetime) ::SeriesInfoInteger(symbol_, _Period, SERIES_TERMINAL_FIRSTDATE) ); }

#endif

};
