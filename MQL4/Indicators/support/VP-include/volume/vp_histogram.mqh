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

// VP Histogram. © FXcoder

#property strict

#include "../bsl.mqh"

class CVPHistogram: public CBUncopyable
{
public:

	double low_price;
	double volumes[];
	double point;

	double max_volume;
	int modes[];
	int mode_count;
	int max_pos;
	int vwap_pos;
	int quantiles[];

	int bar_from;
	int bar_to;

	bool need_redraw;
	string prefix;

	void CVPHistogram():
		low_price(0), point(0), max_volume(1), mode_count(0), max_pos(-1), vwap_pos(-1), bar_from(0), bar_to(0), need_redraw(false), prefix("")
	{
	}

};
