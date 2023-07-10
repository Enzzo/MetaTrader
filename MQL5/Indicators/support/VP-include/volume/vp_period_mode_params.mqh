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

// VP period mode parameters. © FXcoder

#property strict

#include "enum/vp_hg_pos_period.mqh"
#include "enum/vp_time_shift.mqh"
#include "enum/vp_zoom.mqh"

class CVPPeriodModeParams
{
public:

	const ENUM_TIMEFRAMES        tf;
	const int                    count;
	const ENUM_VP_TIME_SHIFT     time_shift;
	const ENUM_VP_HG_POS_PERIOD  hg_pos;
	const ENUM_VP_ZOOM           zoom_type;
	const double                 zoom_custom;


public:

	void CVPPeriodModeParams(
		ENUM_TIMEFRAMES        tf_,
		int                    count_,
		ENUM_VP_TIME_SHIFT     time_shift_,
		ENUM_VP_HG_POS_PERIOD  hg_pos_,
		ENUM_VP_ZOOM           zoom_type_,
		double                 zoom_custom_
	):
		tf(tf_),
		count(count_),
		time_shift(time_shift_),
		hg_pos(hg_pos_),
		zoom_type(zoom_type_),
		zoom_custom(zoom_custom_)
	{
	}

	// copy constructor
	void CVPPeriodModeParams(const CVPPeriodModeParams &p):
		tf(p.tf),
		count(p.count),
		time_shift(p.time_shift),
		hg_pos(p.hg_pos),
		zoom_type(p.zoom_type),
		zoom_custom(p.zoom_custom)
	{
	}

};
