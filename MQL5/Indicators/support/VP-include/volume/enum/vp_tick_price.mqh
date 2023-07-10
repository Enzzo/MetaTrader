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

// VP. Zoom mode. © FXcoder

#property strict

enum ENUM_VP_TICK_PRICE
{
	VP_TICK_PRICE_BID           = 0x100,  // Bid Price
	VP_TICK_PRICE_ASK           = 0x200,  // Ask Price
	VP_TICK_PRICE_LAST          = 0x300,  // Last Price
	VP_TICK_PRICE_AVG           = 0x400,  // Bid/Ask Average
	VP_TICK_PRICE_LAST_OR_AVG   = 0x500,  // Last or Bid/Ask Average
};
