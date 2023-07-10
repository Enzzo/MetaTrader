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

// Функции указателей. © FXcoder

#property strict

#include "../type/uncopyable.mqh"

class CBPointerUtil: public CBUncopyable
{
public:

	template <typename T>
	static void safe_delete(T obj)
	{
		if (is_dynamic(obj))
			delete obj;
	}

	template <typename T>
	static void safe_delete_array(T &arr[])
	{
		for (int i = ::ArraySize(arr) - 1; i >= 0; --i)
			safe_delete(arr[i]);
	}

	template <typename T> static bool is_valid    (T obj) { return(::CheckPointer(obj) != POINTER_INVALID  ); }
	template <typename T> static bool is_invalid  (T obj) { return(::CheckPointer(obj) == POINTER_INVALID  ); }
	template <typename T> static bool is_automatic(T obj) { return(::CheckPointer(obj) == POINTER_AUTOMATIC); }
	template <typename T> static bool is_dynamic  (T obj) { return(::CheckPointer(obj) == POINTER_DYNAMIC  ); }

	template <typename T> static ENUM_POINTER_TYPE check(T obj) { return(::CheckPointer(obj)); }

} _ptr;
