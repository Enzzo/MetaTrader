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

// VP histogram parameters. © FXcoder

#property strict

#include "../enum/hg_coloring.mqh"
#include "enum/vp_bar_style.mqh"

class CVPHgParams
{
public:

	const ENUM_VP_BAR_STYLE      bar_style;
	const ENUM_HG_COLORING       coloring;
	const color                  color1;
	const color                  color2;
	const int                    line_width;
	const uint                   width_pct;


public:

	void CVPHgParams(
		ENUM_VP_BAR_STYLE      bar_style_,
		ENUM_HG_COLORING       coloring_,
		color                  color1_,
		color                  color2_,
		int                    line_width_,
		uint                   width_pct_
	):
		bar_style(bar_style_),
		coloring(coloring_),
		color1(color1_),
		color2(color2_),
		line_width(line_width_),
		width_pct(width_pct_)
	{
	}

	// copy constructor
	void CVPHgParams(
		const CVPHgParams &p
	):
		bar_style(p.bar_style),
		coloring(p.coloring),
		color1(p.color1),
		color2(p.color2),
		line_width(p.line_width),
		width_pct(p.width_pct)
	{
	}

};
