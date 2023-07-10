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

// Свойства события графика OnChartEvent. © FXcoder

#property strict

#include "type/single.mqh"
#include "type/uncopyable.mqh"
#include "util/math.mqh"
#include "util/time.mqh"
#include "chart.mqh"

class CBChartEvent: public CBUncopyable
{
private:

	int    id_;
	long   lparam_;
	double dparam_;
	string sparam_;

	// время предыдущего клика в мс для определения двойного клика
	long            chart_dbl_click_prev_click_time_msc_;
	string          chart_dbl_click_prev_symbol_;
	ENUM_TIMEFRAMES chart_dbl_click_prev_period_;


public:

	long   lparam() { return(lparam_); }
	double dparam() { return(dparam_); }
	string sparam() { return(sparam_); }

	void init(const int id, const long &lparam, const double &dparam, const string &sparam)
	{
		id_ = id;
		lparam_ = lparam;
		dparam_ = dparam;
		sparam_ = sparam;
	}

	bool is_click_event()        { return(id_ == CHARTEVENT_CLICK); }
	bool is_chart_change_event() { return(id_ == CHARTEVENT_CHART_CHANGE); }

	// вызов должен производиться только из одного места
	bool is_double_click_event(int gap_msc = 333)
	{
		if (!is_click_event())
			return(false);

		const long time = _time.tick_count_long();

		//if (time == chart_dbl_click_prev_click_time_msc_)
		//	return(false);

		bool res = time - chart_dbl_click_prev_click_time_msc_ <= gap_msc;

		// Между кликами может произойти смена символа или таймфрейма, при котором двойной клик
		//   вряд ли имеет смысл.
		res = res && (chart_dbl_click_prev_symbol_ == _Symbol);
		res = res && (chart_dbl_click_prev_period_ == (ENUM_TIMEFRAMES)_Period);

		chart_dbl_click_prev_click_time_msc_ = time;
		chart_dbl_click_prev_symbol_ = _Symbol;
		chart_dbl_click_prev_period_ = (ENUM_TIMEFRAMES)_Period;
		return(res);
	}

	bool is_mouse_move_event()
	{
		return(id_ == CHARTEVENT_MOUSE_MOVE);
	}

	bool is_mouse_move_event(int &mouse_x, int &mouse_y)
	{
		if (!is_mouse_move_event())
			return(false);

		mouse_x = CBChartEvent::mouse_x();
		mouse_y = CBChartEvent::mouse_y();
		return(true);
	}

	// mouse_y is relative to window
	bool is_mouse_move_event(int window, int &mouse_x, int &mouse_y)
	{
		if (!is_mouse_move_event())
			return(false);

		mouse_x = CBChartEvent::mouse_x();
		if (!_math.is_in_range(mouse_x, 0, _chart.width_in_pixels() - 1))
			return(false);

		mouse_y = CBChartEvent::mouse_y(window);
		if (!_math.is_in_range(mouse_y, 0, _chart.height_in_pixels(window) - 1))
			return(false);

		return(true);
	}

	bool is_custom_event()
	{
		return(_math.is_in_range(id_, (int)CHARTEVENT_CUSTOM, (int)CHARTEVENT_CUSTOM_LAST));
	}

	bool is_custom_event(int event_n)
	{
		const int check_id = CHARTEVENT_CUSTOM + event_n;
		return((check_id == id_) && _math.is_in_range(check_id, (int)CHARTEVENT_CUSTOM, (int)CHARTEVENT_CUSTOM_LAST));
	}

	// подразумеваются все действия, изменяющие координаты, включая создание и удаление объекта
	bool is_object_move_event()
	{
		return
		(
			(id_ == CHARTEVENT_OBJECT_CREATE) ||
			(id_ == CHARTEVENT_OBJECT_CHANGE) ||
			(id_ == CHARTEVENT_OBJECT_DRAG)   ||
			(id_ == CHARTEVENT_OBJECT_DELETE)
		);
	}

	// подразумеваются все действия, изменяющие координаты, включая создание и удаление объекта
	bool is_object_move_event(string name)
	{
		return(is_object_move_event() && (sparam_ == name));
	}

	bool is_key_down_event()
	{
		return(id_ == CHARTEVENT_KEYDOWN);
	}

	bool is_key_down_event(ushort key)
	{
		return(is_key_down_event() && (key == lparam_));
	}

	bool is_object_click_event()
	{
		return(id_ == CHARTEVENT_OBJECT_CLICK);
	}

	bool is_object_click_event(string name)
	{
		return(is_object_click_event() && (sparam_ == name));
	}

	bool is_object_click_event_prefix(string prefix)
	{
		if (!is_object_click_event())
			return(false);

		return((prefix == "") ? true : _str.starts_with(sparam_, prefix));
	}

	int mouse_x() { return(int(lparam_)); }
	int mouse_y() { return(int(dparam_)); }

	int mouse_y(int window)
	{
		return(int(dparam_) - _chart.window_y_distance(window));
	}

	ushort key()
	{
		return(ushort(lparam_));
	}

	string key_string()
	{
		return(::ShortToString(CBChartEvent::key()));
	}

	// -1 в случае ошибки
	int custom_event_n()
	{
		return(is_custom_event() ? (id_ - CHARTEVENT_CUSTOM) : -1);
	}

	SINGLE_INSTANCE(CBChartEvent)


private:
	void CBChartEvent():
		id_(0),
		lparam_(0),
		dparam_(0.0),
		sparam_(""),
		chart_dbl_click_prev_click_time_msc_(0),
		chart_dbl_click_prev_symbol_(""),
		chart_dbl_click_prev_period_(PERIOD_CURRENT)
	{
	}

};

SINGLE_GET(CBChartEvent, _chartevent)
