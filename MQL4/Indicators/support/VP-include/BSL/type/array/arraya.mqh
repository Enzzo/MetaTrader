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

// Класс массива, абстрактная заготовка. © FXcoder

/*
Из-за отсутствия подсказки в редакторе (проверено в 5.2006) для шаблонных классов
приходится делать для каждого типа отдельный класс с дублированием всех общих функций.

Этот класс - предок всех классов массивов.
*/

#property strict

#include "../../util/arr.mqh"
#include "../uncopyable.mqh"

// abstract
class CBArrayA: public CBUncopyable
{
protected:

	int reserve_;

public:

	// Конструкторы
	void CBArrayA():
		reserve_(_arr.default_reserve)
	{
	}

	virtual void reserve(int reserve) { reserve_ = reserve; }

	// abstract
	virtual int size() const = NULL;
	virtual int resize(int size) = NULL;
	virtual int resize(int size, int reserve) = NULL;

};

