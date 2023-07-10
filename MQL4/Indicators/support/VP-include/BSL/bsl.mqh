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

/*
© FXcoder

Including all files.

The library is not intended for separate distribution and use.
Any function in the next version may be excluded or changed.

// Last check: 4.1090? /5.2190 (verification of builds up to 5.1930 is required)

todo: calendar
todo: signal
todo: socket
todo: unify functions for loops (chart, position, gv, go, etc.)
*/

#property strict

#define BSL

// indentation shows inheritance


#include "type/array/arraya.mqh"


#include "type/array/arrayptrt.mqh"


#include "type/chartcolors.mqh"
#include "type/dict.mqh"

#include "type/uncopyable.mqh"


#include "util/arr.mqh"


#include "util/color.mqh"
#include "util/conv.mqh"
#include "util/err.mqh"


#include "util/hsv.mqh"
#include "util/math.mqh"
#include "util/num.mqh"
#include "util/double.mqh"


#include "util/ptr.mqh"
#include "util/ring.mqh"


#include "util/str.mqh"
#include "util/sym.mqh"
#include "util/tf.mqh"
#include "util/time.mqh"


#include "chart.mqh"

#include "chartevent.mqh"
#include "const.mqh"

#include "debug.mqh"
#include "event.mqh"


#include "global.mqh"
#include "go.mqh"
#include "goselect.mqh"


#include "series.mqh"

#include "symbol.mqh"

#include "symbolseries.mqh"


