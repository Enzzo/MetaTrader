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

// VP. Tick distribution in a bar. © FXcoder

#property strict

enum ENUM_VP_BAR_TICKS
{
	VP_BAR_TICKS_OHLC                = 0x0100,  // Shortest Path: OHLC / OLHC
	VP_BAR_TICKS_HIGH                = 0x0200,  // High
	VP_BAR_TICKS_LOW                 = 0x0300,  // Low
	VP_BAR_TICKS_CLOSE               = 0x0400,  // Close

	VP_BAR_TICKS_UNIFORM             = 0x1100,  // Uniform Distribution
	VP_BAR_TICKS_PRESENCE            = 0x1200,  // Uniform Presence
	VP_BAR_TICKS_TRIANGULAR          = 0x1300,  // Triangular Distribution
	VP_BAR_TICKS_PARABOLIC           = 0x1400,  // Parabolic Distribution
	VP_BAR_TICKS_QUARTIC             = 0x1500,  // Quartic Distribution
};

bool EnumVPBarTicksIsUsingTempArray(ENUM_VP_BAR_TICKS bar_ticks)
{
	return((bar_ticks == VP_BAR_TICKS_PARABOLIC) || (bar_ticks == VP_BAR_TICKS_QUARTIC));
}
