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

// Функции кольцевого массива. © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "str.mqh"

class CBRingUtil: public CBUncopyable
{
public:

	// ring[pos] последний добавленный элемент
	template <typename T>
	static int to_array(const T &ring[], int pos, T &arr[])
	{
		int size = ::ArraySize(ring);
		if (size == 0)
			return(0);

		if ((pos < 0) || (pos > size - 1))
			return(0);

		::ArrayResize(arr, size);

		// 0..pos][pos+1..last -> [pos+1..last,0..pos]

		int lsize = pos + 1;
		int rsize = size - lsize;

		if (rsize > 0)
			::ArrayCopy(arr, ring, 0, pos + 1, rsize);

		// left size always exists
		::ArrayCopy(arr, ring, rsize, 0, lsize);

		return(size);
	}

	// pos=-1 means pos=last=size-1, so ring is a simple array
	static string to_string(const double &ring[], int pos, string separator, int digits, int padding)
	{
		int size = ::ArraySize(ring);
		if ((size == 0) || (pos < -1) || (pos >= size))
			return("");

		string result = "";

		// NormalizeDouble is to exclude '-0' result
		for (int i = 0; i < size; i++)
			result += _str.pad(::DoubleToString(::NormalizeDouble(ring[(pos + 1 + i) % size], digits), digits) + separator, padding);

		return(result);
	}

	// pos=-1 means pos=last=size-1, so ring is a simple array
	static string to_string(const int &ring[], int pos, string separator, int padding)
	{
		int size = ::ArraySize(ring);
		if ((size == 0) || (pos < -1) || (pos >= size))
			return("");

		string result = "";

		for (int i = 0; i < size; i++)
			result += _str.pad(string(ring[(pos + 1 + i) % size]) + separator, padding);

		return(result);
	}

	// pos=-1 means pos=last=size-1, so ring is a simple array
	static string to_string(const float &ring[], int pos, string separator, int digits, int padding)
	{
		int size = ::ArraySize(ring);
		if ((size == 0) || (pos < -1) || (pos >= size))
			return("");

		string result = "";

		// NormalizeDouble is to exclude '-0' result
		for (int i = 0; i < size; i++)
			result += _str.pad(::DoubleToString(::NormalizeDouble(ring[(pos + 1 + i) % size], digits), digits) + separator, padding);

		return(result);
	}

	// Add value to ring. Returns new pos, -1 on error.
	template <typename T>
	static int add(T &ring[], int pos, T value)
	{
		int size = ::ArraySize(ring);
		if (size <= 0)
			return(-1);

		int new_pos = (pos + 1) % size;
		ring[new_pos] = value;
		return(new_pos);
	}

} _ring;
