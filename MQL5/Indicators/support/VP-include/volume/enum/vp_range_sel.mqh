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

// Режим выбора диапазона. © FXcoder

#property strict

enum ENUM_VP_RANGE_SEL
{
	VP_RANGE_SEL_BETWEEN_LINES     = 0,  // |<->|  Between lines
	VP_RANGE_SEL_LAST_MINUTES      = 1,  //  --->]  Last minutes
	VP_RANGE_SEL_MINUTES_TO_LINE   = 2,  //  --->|  Minutes to line
	VP_RANGE_SEL_LAST_BARS         = 3,  //  ++>]  Last bars
	VP_RANGE_SEL_BARS_TO_LINE      = 4,  //  ++>|  Bars to line
};

string EnumVPRangeModeToString(ENUM_VP_RANGE_SEL mode)
{
	switch (mode)
	{
		case VP_RANGE_SEL_BETWEEN_LINES:   return("lines");
		case VP_RANGE_SEL_LAST_MINUTES:    return("t-last");
		case VP_RANGE_SEL_MINUTES_TO_LINE: return("t-2line");
		case VP_RANGE_SEL_LAST_BARS:       return("b-last");
		case VP_RANGE_SEL_BARS_TO_LINE:    return("b-2line");
	}

	return("?");
}
