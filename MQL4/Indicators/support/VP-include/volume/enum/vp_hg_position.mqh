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

// VP. Histogram position (range mode). © FXcoder

#property strict

/*
	- направо от левой границы окна графика
	- налево (наружу) от левой границы
	- направо (внутрь) от левой границы
	- налево (внутрь) от правой границы
	- направо (наружу) от правой границы
	- налево от правой границы окна графика
*/

enum ENUM_VP_HG_POSITION
{
	VP_HG_POSITION_CHART_LEFT     = 0,  // [>  |   |    ]  Chart Left
	VP_HG_POSITION_LEFT_OUTSIDE   = 2,  // [  <|   |    ]  Left Outside
	VP_HG_POSITION_LEFT_INSIDE    = 4,  // [    |> |    ]  Left Inside
	VP_HG_POSITION_RIGHT_INSIDE   = 5,  // [    | <|    ]  Right Inside
	VP_HG_POSITION_RIGHT_OUTSIDE  = 3,  // [    |   |>  ]  Right Outside
	VP_HG_POSITION_CHART_RIGHT    = 1   // [    |   |  <]  Chart Right
};

bool EnumVPHGPositionIsInsideRange(ENUM_VP_HG_POSITION hg_position)
{
	return(
		(hg_position == VP_HG_POSITION_LEFT_INSIDE) ||
		(hg_position == VP_HG_POSITION_RIGHT_INSIDE)
	);
}
