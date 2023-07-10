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

// Constants. © FXcoder

#property strict

#include "type/single.mqh"
#include "type/uncopyable.mqh"

class CBConst: public CBUncopyable
{
public:

	static const string disable_tooltip;

	SINGLE_INSTANCE(CBConst)


private:

	SINGLE_CONSTRUCTOR(CBConst)

};

const string CBConst::disable_tooltip = "\n";

SINGLE_GET(CBConst, _const)
