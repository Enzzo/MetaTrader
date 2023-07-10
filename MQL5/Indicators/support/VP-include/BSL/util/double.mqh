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

// Функции double. © FXcoder

#property strict

#include "num.mqh"


class CBDoubleUtil: public CBNumberUtil
{
public:

	static const double nan;          // not a number
	static const double empty_value;
	static const double null;

};

const double CBDoubleUtil::nan          = ::log(-1);           // NAN
const double CBDoubleUtil::empty_value  = double(EMPTY_VALUE); // в 4 и 5 разные значения, но интерпретируются одинаково (в буферах линий)
const double CBDoubleUtil::null         = 0.0;

CBDoubleUtil _double;
