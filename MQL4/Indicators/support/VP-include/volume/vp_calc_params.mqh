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

// VP calculation parameters. © FXcoder

#property strict

#include "../enum/point_scale.mqh"

class CVPCalcParams
{
public:

	const int               mode_step;
	const ENUM_POINT_SCALE  hg_point_scale;
	const int               smooth;


public:

	void CVPCalcParams(
		int                mode_step_,
		ENUM_POINT_SCALE   hg_point_scale_,
		int                smooth_
	):
		mode_step(mode_step_),
		hg_point_scale(hg_point_scale_),
		smooth(smooth_)
	{
	}

	// copy constructor
	void CVPCalcParams(
		const CVPCalcParams &p
	):
		mode_step(p.mode_step),
		hg_point_scale(p.hg_point_scale),
		smooth(p.smooth)
	{
	}

};
