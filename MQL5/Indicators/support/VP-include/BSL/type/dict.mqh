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

// Словарь, простой вариант для небольших объёмов данных. © FXcoder

#property strict

#include "../util/arr.mqh"
#include "uncopyable.mqh"

template<typename TKey, typename TValue>
class CBDict: public CBUncopyable
{
private:

	TKey   keys_[];
	TValue values_[];
	int    size_;


public:

	void CBDict():
		size_(0)
	{
	}

	TValue operator [](TKey key) const { return(values_[key_index(key)]); }

	bool try_get_value(TKey key, TValue &value) const
	{
		int index = key_index(key);

		if (index < 0)
			return(false);

		value = values_[index];
		return(true);
	}

	TValue get(TKey key, TValue fallback) const
	{
		TValue value;
		return(try_get_value(key, value) ? value : fallback);
	}

	// Add or update if exists
	void set(TKey key, TValue value)
	{
		// find existing
		int index = key_index(key);

		if (index >= 0)
		{
			values_[index] = value;
			return;
		}

		// add new
		size_++;
		index = size_ - 1;
		_arr.resize(keys_, size_);
		_arr.resize(values_, size_);
		keys_[index] = key;
		values_[index] = value;
	}

	void remove(TKey key)
	{
		int index = key_index(key);

		if (index < 0)
			return;

		remove_at(index);
	}

	void clear()
	{
		size_ = 0;
		_arr.resize(keys_, 0);
		_arr.resize(values_, 0);
	}

	TKey key(int i) const
	{
		return(keys_[i]);
	}

	// key's index
	int key_index(TKey key) const
	{
		for (int i = size_ - 1; i >= 0; i--)
		{
			if (keys_[i] == key)
				return(i);
		}

		return(-1);
	}

	TValue value(int i) const
	{
		return(values_[i]);
	}

	int size() const
	{
		return(size_);
	}


private:

	void remove_at(int index)
	{
		for (int s = index + 1, d = index; s < size_; s++, d++)
		{
			keys_[d] = keys_[s];
			values_[d] = values_[s];
		}

		size_--;
		_arr.resize(keys_, size_);
		_arr.resize(values_, size_);
	}

};
