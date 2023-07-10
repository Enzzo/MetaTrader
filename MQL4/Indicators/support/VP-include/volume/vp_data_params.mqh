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

// VP data parameters. © FXcoder

#property strict

#include "../bsl.mqh"
#include "enum/vp_bar_ticks.mqh"
#include "enum/vp_source.mqh"

class CVPDataParams
{
public:

	const ENUM_VP_SOURCE         source;
	const ENUM_VP_BAR_TICKS      bar_ticks;
	const ENUM_APPLIED_VOLUME    volume_type;
	const ENUM_TIMEFRAMES        period;


public:

	void CVPDataParams(
		ENUM_VP_SOURCE         source_,
		ENUM_VP_BAR_TICKS      bar_ticks_,
		ENUM_APPLIED_VOLUME    volume_type_
	):
		source(source_),
		bar_ticks(bar_ticks_),
		volume_type(volume_type_),
		period(_tf.find_closest(EnumVPSourceMinutes(source_)))
	{
	}

	// copy constructor
	void CVPDataParams(
		const CVPDataParams &p
	):
		source(p.source),
		bar_ticks(p.bar_ticks),
		volume_type(p.volume_type),
		period(p.period)
	{
	}

};
