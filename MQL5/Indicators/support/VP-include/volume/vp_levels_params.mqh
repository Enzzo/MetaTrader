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

// VP levels parameters. © FXcoder

#property strict

#include "../enum/quantile.mqh"

class CVPLevelsParams
{
public:

	const color                  mode_color;
	const color                  max_color;
	const color                  quantile_color;
	const color                  vwap_color;
	const int                    mode_line_width;
	const int                    stat_line_width;
	const ENUM_LINE_STYLE        stat_line_style;
	const color                  mode_level_color;
	const int                    mode_level_width;
	const ENUM_LINE_STYLE        mode_level_style;
	const ENUM_QUANTILE          quantiles;


public:

	void CVPLevelsParams(
		color                  mode_color_,
		color                  max_color_,
		color                  quantile_color_,
		color                  vwap_color_,
		int                    mode_line_width_,
		int                    stat_line_width_,
		ENUM_LINE_STYLE        stat_line_style_,
		color                  mode_level_color_,
		int                    mode_level_width_,
		ENUM_LINE_STYLE        mode_level_style_,
		ENUM_QUANTILE          quantiles_
	):
		mode_color(mode_color_),
		max_color(max_color_),
		quantile_color(quantile_color_),
		vwap_color(vwap_color_),
		mode_line_width(mode_line_width_),
		stat_line_width(stat_line_width_),
		stat_line_style(stat_line_style_),
		mode_level_color(mode_level_color_),
		mode_level_width(mode_level_width_),
		mode_level_style(mode_level_style_),
		quantiles(quantiles_)
	{
	}

	// copy constructor
	void CVPLevelsParams(
		const CVPLevelsParams &p
	):
		mode_color(p.mode_color),
		max_color(p.max_color),
		quantile_color(p.quantile_color),
		vwap_color(p.vwap_color),
		mode_line_width(p.mode_line_width),
		stat_line_width(p.stat_line_width),
		stat_line_style(p.stat_line_style),
		mode_level_color(p.mode_level_color),
		mode_level_width(p.mode_level_width),
		mode_level_style(p.mode_level_style),
		quantiles(p.quantiles)
	{
	}

};
