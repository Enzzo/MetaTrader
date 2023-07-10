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

// VP range mode parameters. © FXcoder

#property strict

#include "enum/vp_hg_position.mqh"
#include "enum/vp_range_sel.mqh"

class CVPRangeModeParams
{
public:

	const ENUM_VP_RANGE_SEL     selection;
	const int                   size;
	const ENUM_VP_HG_POSITION   hg_position;
	const bool                  hg_position_is_inside_range;

public:

	void CVPRangeModeParams(
		ENUM_VP_RANGE_SEL    selection_,
		int                  size_,
		ENUM_VP_HG_POSITION  hg_position_
	):
		selection(selection_),
		size(size_),
		hg_position(hg_position_),
		hg_position_is_inside_range(EnumVPHGPositionIsInsideRange(hg_position_))
	{
	}

	// copy constructor
	void CVPRangeModeParams(
		const CVPRangeModeParams &p
	):
		selection(p.selection),
		size(p.size),
		hg_position(p.hg_position),
		hg_position_is_inside_range(p.hg_position_is_inside_range)
	{
	}

};
