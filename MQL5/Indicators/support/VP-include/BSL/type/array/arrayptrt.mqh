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

// Класс массива ptr, шаблонный. © FXcoder
// В отличие от старого варианта, здесь объекты всегда удаляются в деструкторе, и нет отдельной функции для удаления вручную.

#property strict

#include "../../util/arr.mqh"
#include "../../util/ptr.mqh"
#include "arraya.mqh"

template <typename T>
class CBArrayPtrT: public CBArrayA
{
public:

	T *data[];


public:

	void CBArrayPtrT():                      CBArrayA() { }
	void CBArrayPtrT(int size):              CBArrayA() { resize(size);          }
	void CBArrayPtrT(int size, int reserve): CBArrayA() { resize(size, reserve); }

	void ~CBArrayPtrT() { _ptr.safe_delete_array(data); }

	T *operator[](int i) const { return(data[i]); } // не использовать, если важна скорость

	/* Implementation */

	virtual int size()                        override const { return(::ArraySize(data)); }
	virtual int resize(int size)              override       { return(::ArrayResize(data, size, reserve_)); };
	virtual int resize(int size, int reserve) override       { reserve_ = reserve; return(resize(size)); }

	/* Type-dependent functions */

	int add(T &value)
	{
		int new_size = resize(size() + 1);
		if (new_size < 0)
			return(-1);

		data[new_size - 1] = &value;
		return(new_size - 1);
	}

	// Возвращает добавленный объект
	T *add_return(T &value)
	{
		int index = add(value);
		return(index >= 0 ? data[index] : NULL);
	}

	// see also: remove_delete
	void remove(int index)
	{
		int size = size();

		// Левая часть остаётся без изменений.
		// Правая часть
		for (int i = index + 1; i < size; i++)
			data[i - 1] = data[i];

		// size() не использовать, т.к. там может появиться удаление старых объектов, что здесь не нужно
		::ArrayResize(data, size - 1, reserve_);
	}

	// see also: remove
	void remove_delete(int index)
	{
		_ptr.safe_delete(data[index]);
		remove(index);
	}

};
