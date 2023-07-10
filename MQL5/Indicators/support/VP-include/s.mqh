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

// Sugar. © FXcoder

#property strict


/* Debug helpers */

// run A just once
#define _ONCE(A) { static bool once__ = false; if (!once__) { once__ = true; A; } }


/* Class helpers */

// _GET(double,x) -> double x() const { return(x_); }
#define _GET(T, N) T N() const { return(N##_); }
#define _GETREF(T, N) T N() const { return(&N##_); }

// _SET(double,x) -> void x(double value) { x_ = value; }
#define _SET(T, N) void N(T value) { N##_ = value; }

// requires BSL
// _GETARR(double,x) -> int x(double &arr[]) const { _arr.clone(arr, x_); return(::ArraySize(arr)); }
#define _GETARR(T, N) int get_##N(T &arr[]) const { _arr.clone(arr, N##_); return(::ArraySize(arr)); }


/* Compatibility */

// run on certain MQL vesion
#ifdef __MQL4__
	#define _MQL4(A) A
#else
	#define _MQL4(A)
#endif

#ifdef __MQL5__
	#define _MQL5(A) A
#else
	#define _MQL5(A)
#endif
