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

// Положение гистограммы в режиме разбвики по периодам. © FXcoder

#property strict

enum ENUM_VP_HG_POS_PERIOD
{
	VP_HG_POS_PERIOD_L2R   = 0x0100,  // |>|  Left to Right
	VP_HG_POS_PERIOD_R2L   = 0x0200,  // |<|  Right to Left

	VP_HG_POS_PERIOD_L2C   = 0x0300,  // |>:  |  Left to Center
	VP_HG_POS_PERIOD_C2L   = 0x0400,  // |<:  |  Center to Left

	VP_HG_POS_PERIOD_C2R   = 0x0500,  // |  :>|  Center to Right
	VP_HG_POS_PERIOD_R2C   = 0x0600,  // |  :<|  Right to Center
};
