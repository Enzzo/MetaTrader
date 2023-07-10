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

// Класс выбора объектов в стиле _go[obj_name]. © FXcoder

#property strict

#include "type/uncopyable.mqh"
#include "type/array/arrayptrt.mqh"
#include "go.mqh"

class CBGOSelect: public CBUncopyable
{
private:

	long chart_id_;
	CBArrayPtrT<CBGO> objects_;


public:

	void CBGOSelect():
		chart_id_(0)
	{
	}

	void CBGOSelect(long chart_id):
		chart_id_(chart_id)
	{
	}

	CBGO *operator[](string name)
	{
		// find existing
		for (int i = objects_.size() - 1; i >= 0; i--)
		{
			if (objects_.data[i].name() == name)
				return(objects_.data[i]);
		}

		// create new
		CBGO *go = new CBGO(chart_id_, name);
		return(objects_.add_return(go));
	}

	CBGO *operator[](int i)
	{
		string name = ObjectName(chart_id_, i);

		if (_str.is_empty(name))
			return(NULL);

		CBGO *go = new CBGO(chart_id_, name);
		return(objects_.add_return(go));
	}

	int total(int subwindow = -1, int object_type = -1)
	{
		return(::ObjectsTotal(chart_id_, subwindow, object_type));
	}

} _go;
