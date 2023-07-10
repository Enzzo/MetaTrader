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

// Chart properties and functions. © FXcoder

#property strict

#include "type/uncopyable.mqh"
#include "type/chartcolors.mqh"
#include "util/arr.mqh"
#include "util/math.mqh"
#include "util/str.mqh"
#include "debug.mqh"


#define _BSL_CHART_GET(T, N, P) T        N() const  { return((T)get(P)); }
#define _BSL_CHART_SET(T, N, P) CBChart *N(T value) { return(set(P, value)); }

#define _BSL_CHART_WINDOW_GET(T, N, P) T        N(int window = 0) const  { return((T)get(P, window)); }
#define _BSL_CHART_WINDOW_SET(T, N, P) CBChart *N(int window, T value)   { return(set(P, window, value)); }

class CBChart: public CBUncopyable
{
protected:

	// could be negative (for loop functions), zero (current chart) or reak ID
	long id_; // 0 - current chart (another code depends on this, do not change the behavior)


public:

	// Default constructor
	void CBChart():
		id_(0)
	{
	}

	// Constructor for a specific chart Id.
	void CBChart(long chart_id):
		id_(chart_id)
	{
	}

	// Constructor with opening the chart.
	void CBChart(string symbol, ENUM_TIMEFRAMES timeframe)
	{
		id_ = ::ChartOpen(symbol, timeframe);
	}

	CBChart *close()
	{
		::ChartClose(id_);
		return(&this);
	}

	// Chart functions

	CBChart *redraw()
	{
		::ChartRedraw(id_);
		return(&this);
	}

	// Last 6 digits of ID, enough uniqueness to save space (for example, in file names and gloval variables)
	int id_short() const
	{
		return(int(id() % 1000000));
	}

	bool xy_to_time_price(int x, int y, int &window, datetime &time, double &price) const
	{
		return(::ChartXYToTimePrice(id_, x, y, window, time, price));
	}

	bool time_price_to_xy(int window, datetime time, double price, int &x, int &y) const
	{
		return(::ChartTimePriceToXY(id_, window, time, price, x, y));
	}

	bool save_template(string name) const
	{
		return(::ChartSaveTemplate(id_, name));
	}

	bool apply_template(string name) const
	{
		return(::ChartApplyTemplate(id_, name));
	}

	bool navigate(ENUM_CHART_POSITION location, int bars_to_navigate = 0) const
	{
		return(::ChartNavigate(id_, location, bars_to_navigate));
	}

	bool navigate_begin(int bars_to_navigate = 0) const
	{
		return(::ChartNavigate(id_, CHART_BEGIN, bars_to_navigate));
	}

	bool navigate_current_pos(int bars_to_navigate = 0) const
	{
		return(::ChartNavigate(id_, CHART_CURRENT_POS, bars_to_navigate));
	}

	bool navigate_end(int bars_to_navigate = 0) const
	{
		return(::ChartNavigate(id_, CHART_END, bars_to_navigate));
	}

	bool navigate_time_left(datetime time) const
	{
		int bar_delta = leftmost_visible_bar() - iBarShift(symbol(), period(), time);
		return(navigate_current_pos(bar_delta));
	}

	static int window_find()
	{
		return(::ChartWindowFind());
	}

	int window_find(string indicator_shortname)
	{
		return(::ChartWindowFind(id_, indicator_shortname));
	}

	bool exists()
	{
		if (id_ < 0)
			return(false);

		if (id_ == 0)
			return(true);

		long tmp;
		return(::ChartGetInteger(id_, CHART_WINDOW_HANDLE, 0, tmp));
	}

	void event_custom(ushort event_n, long lparam, double dparam, string sparam)
	{
		::EventChartCustom(id_, event_n, lparam, dparam, sparam);
	}

	void screenshot(string path, int width, int height, ENUM_ALIGN_MODE align = ALIGN_RIGHT)
	{
		::ChartScreenShot(id_, path, width, height, align);
	}

	// if <0 return id_
	long id() const
	{
		return(id_ == 0 ? ::ChartID() : id_);
	}

	void id(long chart_id)
	{
		id_ = chart_id;
	}

	void first()
	{
		id_ = ::ChartFirst();
	}

	long next()
	{
		return(::ChartNext(id_));
	}

	// for such a code: for(CBChart chart; chart.loop();)
	bool loop()
	{
		// ChartNext's behavior with a negative id is not documented, so check explicitly
		if (id_ < 0)
			return(false);

		id_ = id_ == 0 ? ::ChartFirst() : ::ChartNext(id_);
		return(id_ > 0);
	}

	// for such a code: for(CBChart chart; chart.loop_real();)
	// Only real charts (not objects).
	// In 4 is equivalent to loop ().
	bool loop_real()
	{
#ifdef __MQL4__
		return(loop());
#else
		while(loop())
		{
			if (!is_object())
				return(true);
		}

		return(false);
#endif
	}

	bool is_this_chart() const
	{
		// for speed in loops calling this function
		if (id_ < 0)
			return(false);

		return((id_ == 0) || (id_ == ::ChartID()));
	}


	int objects_total()                                    const { return(::ObjectsTotal(id_)); }
	int objects_total(int subwindow)                       const { return(::ObjectsTotal(id_, subwindow)); }
	int objects_total(int subwindow, ENUM_OBJECT obj_type) const { return(::ObjectsTotal(id_, subwindow, obj_type)); }

	string object_name(int index)                                      const { return(::ObjectName(id_, index)); }
	string object_name(int index, int subwindow)                       const { return(::ObjectName(id_, index, subwindow)); }
	string object_name(int index, int subwindow, ENUM_OBJECT obj_type) const { return(::ObjectName(id_, index, subwindow, obj_type)); }

	int object_find(string object_name) const { return(::ObjectFind(id_, object_name)); }


	int objects_delete_all(int subwindow = -1, int object_type = -1) const
	{
		return(::ObjectsDeleteAll(id_, subwindow, object_type));
	}

	int objects_delete_all(const string prefix, int subwindow = -1, int object_type = -1) const
	{
		return(::ObjectsDeleteAll(id_, prefix, subwindow, object_type));
	}

	// symbol & period

	CBChart *symbol(string symbol)
	{
		::ChartSetSymbolPeriod(id_, symbol, ::ChartPeriod(id_));
		return(&this);
	}

	CBChart *period(ENUM_TIMEFRAMES period)
	{
		::ChartSetSymbolPeriod(id_, ::ChartSymbol(id_), period);
		return(&this);
	}

	CBChart *symbol_period(string symbol, ENUM_TIMEFRAMES period)
	{
		::ChartSetSymbolPeriod(id_, symbol, period);
		return(&this);
	}

	string symbol() const
	{
		return(::ChartSymbol(id_));
	}

	ENUM_TIMEFRAMES period() const
	{
		return(::ChartPeriod(id_));
	}

	// setting the same symbol and tf leads to an update of the chart (but not exactly like the Refresh menu)
	CBChart *refresh()
	{
		return(symbol_period(symbol(), period()));
	}


	// Access functions for specific properties and their combinations

	// properties

	// Chart type (candlesticks, bars or line)
	_BSL_CHART_GET(ENUM_CHART_MODE, mode, CHART_MODE)
	_BSL_CHART_SET(ENUM_CHART_MODE, mode, CHART_MODE)
	// Display volume in the chart
	_BSL_CHART_GET(ENUM_CHART_VOLUME_MODE, show_volumes, CHART_SHOW_VOLUMES)
	_BSL_CHART_SET(ENUM_CHART_VOLUME_MODE, show_volumes, CHART_SHOW_VOLUMES)
	// Chart height in pixels
	_BSL_CHART_WINDOW_GET(int, height_in_pixels, CHART_HEIGHT_IN_PIXELS)
	_BSL_CHART_WINDOW_SET(int, height_in_pixels, CHART_HEIGHT_IN_PIXELS)
	// Mode of automatic moving to the right border of the chart
	_BSL_CHART_GET(bool, autoscroll, CHART_AUTOSCROLL)
	_BSL_CHART_SET(bool, autoscroll, CHART_AUTOSCROLL)
	// Show chart on top of other charts (w/o)
	_BSL_CHART_SET(bool, bring_to_top, CHART_BRING_TO_TOP)
	// Ask price level color
	_BSL_CHART_GET(color, color_ask          , CHART_COLOR_ASK)
	_BSL_CHART_SET(color, color_ask          , CHART_COLOR_ASK)
	// Chart background color
	_BSL_CHART_GET(color, color_background   , CHART_COLOR_BACKGROUND)
	_BSL_CHART_SET(color, color_background   , CHART_COLOR_BACKGROUND)
	// Bid price level color
	_BSL_CHART_GET(color, color_bid          , CHART_COLOR_BID)
	_BSL_CHART_SET(color, color_bid          , CHART_COLOR_BID)
	// Body color of a bear candlestick
	_BSL_CHART_GET(color, color_candle_bear  , CHART_COLOR_CANDLE_BEAR)
	_BSL_CHART_SET(color, color_candle_bear  , CHART_COLOR_CANDLE_BEAR)
	// Body color of a bull candlestick
	_BSL_CHART_GET(color, color_candle_bull  , CHART_COLOR_CANDLE_BULL)
	_BSL_CHART_SET(color, color_candle_bull  , CHART_COLOR_CANDLE_BULL)
	// Color for the down bar, shadows and body borders of bear candlesticks
	_BSL_CHART_GET(color, color_chart_down   , CHART_COLOR_CHART_DOWN)
	_BSL_CHART_SET(color, color_chart_down   , CHART_COLOR_CHART_DOWN)
	// Line chart color and color of "Doji" Japanese candlesticks
	_BSL_CHART_GET(color, color_chart_line   , CHART_COLOR_CHART_LINE)
	_BSL_CHART_SET(color, color_chart_line   , CHART_COLOR_CHART_LINE)
	// Color for the up bar, shadows and body borders of bull candlesticks
	_BSL_CHART_GET(color, color_chart_up     , CHART_COLOR_CHART_UP)
	_BSL_CHART_SET(color, color_chart_up     , CHART_COLOR_CHART_UP)
	// Color of axes, scales and OHLC line
	_BSL_CHART_GET(color, color_foreground   , CHART_COLOR_FOREGROUND)
	_BSL_CHART_SET(color, color_foreground   , CHART_COLOR_FOREGROUND)
	// Grid color
	_BSL_CHART_GET(color, color_grid         , CHART_COLOR_GRID)
	_BSL_CHART_SET(color, color_grid         , CHART_COLOR_GRID)
	// Line color of the last executed deal price (Last)
	_BSL_CHART_GET(color, color_last         , CHART_COLOR_LAST)
	_BSL_CHART_SET(color, color_last         , CHART_COLOR_LAST)
	// Color of stop order levels (Stop Loss and Take Profit)
	_BSL_CHART_GET(color, color_stop_level   , CHART_COLOR_STOP_LEVEL)
	_BSL_CHART_SET(color, color_stop_level   , CHART_COLOR_STOP_LEVEL)
	// Color of volumes and position opening levels
	_BSL_CHART_GET(color, color_volume       , CHART_COLOR_VOLUME)
	_BSL_CHART_SET(color, color_volume       , CHART_COLOR_VOLUME)
	// Text of a comment in a chart
	_BSL_CHART_GET(string, comment, CHART_COMMENT)
	_BSL_CHART_SET(string, comment, CHART_COMMENT)
	// Permission to drag trading levels on a chart with a mouse
	_BSL_CHART_GET(bool, drag_trade_levels, CHART_DRAG_TRADE_LEVELS)
	_BSL_CHART_SET(bool, drag_trade_levels, CHART_DRAG_TRADE_LEVELS)
	// Price chart in the foreground
	_BSL_CHART_GET(bool, foreground, CHART_FOREGROUND)
	_BSL_CHART_SET(bool, foreground, CHART_FOREGROUND)
	// Send notifications of mouse move and mouse click events (CHARTEVENT_MOUSE_MOVE) to all mql5 programs on a chart
	_BSL_CHART_GET(bool, event_mouse_move, CHART_EVENT_MOUSE_MOVE)
	_BSL_CHART_SET(bool, event_mouse_move, CHART_EVENT_MOUSE_MOVE)
	// Send a notification of an event of new object creation (CHARTEVENT_OBJECT_CREATE) to all mql5-programs on a chart
	_BSL_CHART_GET(bool, event_object_create, CHART_EVENT_OBJECT_CREATE)
	_BSL_CHART_SET(bool, event_object_create, CHART_EVENT_OBJECT_CREATE)
	// Send a notification of an event of object deletion (CHARTEVENT_OBJECT_DELETE) to all mql5-programs on a chart
	_BSL_CHART_GET(bool, event_object_delete, CHART_EVENT_OBJECT_DELETE)
	_BSL_CHART_SET(bool, event_object_delete, CHART_EVENT_OBJECT_DELETE)
	// Number of the first visible bar in the chart. Indexing of bars is the same as for timeseries (r/o)
	_BSL_CHART_GET(int, first_visible_bar, CHART_FIRST_VISIBLE_BAR)
	// Fixed  chart maximum
	_BSL_CHART_GET(double, fixed_max, CHART_FIXED_MAX)
	_BSL_CHART_SET(double, fixed_max, CHART_FIXED_MAX)
	// Fixed  chart minimum
	_BSL_CHART_GET(double, fixed_min, CHART_FIXED_MIN)
	_BSL_CHART_SET(double, fixed_min, CHART_FIXED_MIN)
	// Chart fixed position from the left border in percent value
	_BSL_CHART_GET(double, fixed_position, CHART_FIXED_POSITION)
	_BSL_CHART_SET(double, fixed_position, CHART_FIXED_POSITION)
	// Allow managing the chart using a keyboard
	_BSL_CHART_GET(bool, keyboard_control, CHART_KEYBOARD_CONTROL)
	_BSL_CHART_SET(bool, keyboard_control, CHART_KEYBOARD_CONTROL)
	// Scrolling the chart horizontally using the left mouse button
	_BSL_CHART_GET(bool, mouse_scroll, CHART_MOUSE_SCROLL)
	_BSL_CHART_SET(bool, mouse_scroll, CHART_MOUSE_SCROLL)
	// Scale in points per bar
	_BSL_CHART_GET(double, points_per_bar, CHART_POINTS_PER_BAR)
	_BSL_CHART_SET(double, points_per_bar, CHART_POINTS_PER_BAR)
	// Allow the chart to intercept Space and Enter key strokes to activate the quick navigation bar
	_BSL_CHART_GET(bool, quick_navigation, CHART_QUICK_NAVIGATION)
	_BSL_CHART_SET(bool, quick_navigation, CHART_QUICK_NAVIGATION)
	// Chart maximum (r/o)
	_BSL_CHART_WINDOW_GET(double, price_max, CHART_PRICE_MAX)
	// Chart minimum (r/o)
	_BSL_CHART_WINDOW_GET(double, price_min, CHART_PRICE_MIN)
	// Scale (0..5)
	_BSL_CHART_GET(int, scale, CHART_SCALE)
	_BSL_CHART_SET(int, scale, CHART_SCALE)
	// Fixed scale mode
	_BSL_CHART_GET(bool, scale_fix, CHART_SCALEFIX)
	_BSL_CHART_SET(bool, scale_fix, CHART_SCALEFIX)
	// Scale 1:1 mode
	_BSL_CHART_GET(bool, scale_fix_11, CHART_SCALEFIX_11)
	_BSL_CHART_SET(bool, scale_fix_11, CHART_SCALEFIX_11)
	// Scale to be specified in points per bar
	_BSL_CHART_GET(bool, scale_pt_per_bar, CHART_SCALE_PT_PER_BAR)
	_BSL_CHART_SET(bool, scale_pt_per_bar, CHART_SCALE_PT_PER_BAR)
	// Mode of price chart indent from the right border
	_BSL_CHART_GET(bool, shift, CHART_SHIFT)
	_BSL_CHART_SET(bool, shift, CHART_SHIFT)
	// The size of the zero bar indent from the right border in percents (10..50)
	_BSL_CHART_GET(double, shift_size, CHART_SHIFT_SIZE) // 10..50%
	_BSL_CHART_SET(double, shift_size, CHART_SHIFT_SIZE) // 10..50%
	// Display Ask values as a horizontal line in a chart
	_BSL_CHART_GET(bool, show_ask_line, CHART_SHOW_ASK_LINE)
	_BSL_CHART_SET(bool, show_ask_line, CHART_SHOW_ASK_LINE)
	// Display Bid values as a horizontal line in a chart
	_BSL_CHART_GET(bool, show_bid_line, CHART_SHOW_BID_LINE)
	_BSL_CHART_SET(bool, show_bid_line, CHART_SHOW_BID_LINE)
	// Showing the time scale on a chart
	_BSL_CHART_GET(bool, show_date_scale, CHART_SHOW_DATE_SCALE)
	_BSL_CHART_SET(bool, show_date_scale, CHART_SHOW_DATE_SCALE)
	// Display grid in the chart
	_BSL_CHART_GET(bool, show_grid, CHART_SHOW_GRID)
	_BSL_CHART_SET(bool, show_grid, CHART_SHOW_GRID)
	// Display Last values as a horizontal line in a chart
	_BSL_CHART_GET(bool, show_last_line, CHART_SHOW_LAST_LINE)
	_BSL_CHART_SET(bool, show_last_line, CHART_SHOW_LAST_LINE)
	// Display textual descriptions of objects (not available for all objects)
	_BSL_CHART_GET(bool, show_object_descr, CHART_SHOW_OBJECT_DESCR)
	_BSL_CHART_SET(bool, show_object_descr, CHART_SHOW_OBJECT_DESCR)
	// Show OHLC values in the upper left corner
	_BSL_CHART_GET(bool, show_ohlc, CHART_SHOW_OHLC)
	_BSL_CHART_SET(bool, show_ohlc, CHART_SHOW_OHLC)
	// Showing the "One click trading" panel on a chart
	_BSL_CHART_GET(bool, show_one_click, CHART_SHOW_ONE_CLICK)
	_BSL_CHART_SET(bool, show_one_click, CHART_SHOW_ONE_CLICK)
	// Display vertical separators between adjacent periods
	_BSL_CHART_GET(bool, show_period_sep, CHART_SHOW_PERIOD_SEP)
	_BSL_CHART_SET(bool, show_period_sep, CHART_SHOW_PERIOD_SEP)
	// Showing the price scale on a chart
	_BSL_CHART_GET(bool, show_price_scale, CHART_SHOW_PRICE_SCALE)
	_BSL_CHART_SET(bool, show_price_scale, CHART_SHOW_PRICE_SCALE)
	// Displaying trade levels in the chart
	_BSL_CHART_GET(bool, show_trade_levels, CHART_SHOW_TRADE_LEVELS)
	_BSL_CHART_SET(bool, show_trade_levels, CHART_SHOW_TRADE_LEVELS)
	// The number of bars on the chart that can be displayed (r/o)
	_BSL_CHART_GET(int, visible_bars, CHART_VISIBLE_BARS)
	// Chart width in bars (r/o)
	_BSL_CHART_GET(int, width_in_bars, CHART_WIDTH_IN_BARS)
	// Chart width in pixels (r/o)
	_BSL_CHART_GET(int, width_in_pixels, CHART_WIDTH_IN_PIXELS)
	// Chart window handle (HWND) (r/o)
	_BSL_CHART_GET(int, window_handle, CHART_WINDOW_HANDLE)
	// Visibility of subwindows (r/o)
	_BSL_CHART_WINDOW_GET(bool, window_is_visible, CHART_WINDOW_IS_VISIBLE)
	// The distance between the upper frame of the indicator subwindow and the upper frame of the main chart window, along the vertical Y axis, in pixels (r/o)
	_BSL_CHART_WINDOW_GET(int, window_y_distance, CHART_WINDOW_YDISTANCE)
	// The total number of chart windows, including indicator subwindows (r/o)
	_BSL_CHART_GET(int, windows_total, CHART_WINDOWS_TOTAL)

	// Дополнительные функции

	// Универсальный вариант is_offline
	bool is_custom()
	{
#ifdef __MQL4__
	return((bool)get(CHART_IS_OFFLINE));
#else
	return((bool)::SymbolInfoInteger(symbol(), SYMBOL_CUSTOM));
#endif
	}

	// Последний (правый) видимый бар, может быть отрицательный, если справа есть отступ.
	// zero_limit: вернуть 0, если номер бара отрицательный
	int last_visible_bar(bool zero_limit = false) const
	{
		int bar = first_visible_bar() - width_in_bars();

		if (zero_limit && (bar < 0))
			bar = 0;

		return(bar);
	}

	// синонимы с понятными именами
	int leftmost_visible_bar() const { return(first_visible_bar()); }
	int rightmost_visible_bar(bool zero_limit = false) const { return(last_visible_bar(zero_limit)); }

	// Ширина бара (включая зазор) в пикселях. Или шаг баров в пикселях.
	int bar_width() const
	{
		return(1 << scale());
	}

	// Толщина бара как линии (не пиксели).
	int bar_body_line_width()
	{
		int scale = scale();

#ifdef __MQL4__
		switch (scale)
		{
			case 0: return(1);
			case 1: return(1);
			case 2: return(2);
			case 3: return(3);
			case 4: return(6);
			case 5: return(13);
		}
#else
		// see mki#55
		switch (scale)
		{
			case 0: return(1);
			case 1: return(1);
			case 2: return(2);
			case 3: return(3);
			case 4: return(6);
			case 5: return(13);
		}
#endif

		_debug.warning("Unknown bar scale:" + VAR(scale));
		return(1);
	}

	// Число баров на графике (не в окне)
	int bars_count() const
	{
		int count = ::Bars(symbol(), period());
//#ifdef __MQL4__
		return(count);
//#else
//		return(_math.min(count, _terminal.max_bars())); // mki#32
//#endif
	}

	// Число баров на графике (не в окне)
	int bars() const
	{
		return(::Bars(symbol(), period()));
	}

	double height_in_price() const
	{
		return(this.price_max() - this.price_min());
	}

	// Redraw только для 5 и новее
	CBChart *redraw5()
	{
#ifndef __MQL4__
		::ChartRedraw(id_);
#endif
		return(&this);
	}

	// get chart colors
	BChartColors colors() const
	{
		BChartColors colors;

		colors.ask          = color_ask();
		colors.background   = color_background();
		colors.bid          = color_bid();
		colors.candle_bear  = color_candle_bear();
		colors.candle_bull  = color_candle_bull();
		colors.chart_down   = color_chart_down();
		colors.chart_line   = color_chart_line();
		colors.chart_up     = color_chart_up();
		colors.foreground   = color_foreground();
		colors.grid         = color_grid();
		colors.last         = color_last();
		colors.stop_level   = color_stop_level();
		colors.volume       = color_volume();

		return(colors);
	}

	// set chart colors
	void colors(const BChartColors &colors)
	{
		color_ask          (colors.ask);
		color_background   (colors.background);
		color_bid          (colors.bid);
		color_candle_bear  (colors.candle_bear);
		color_candle_bull  (colors.candle_bull);
		color_chart_down   (colors.chart_down);
		color_chart_line   (colors.chart_line);
		color_chart_up     (colors.chart_up);
		color_foreground   (colors.foreground);
		color_grid         (colors.grid);
		color_last         (colors.last);
		color_stop_level   (colors.stop_level);
		color_volume       (colors.volume);
	}

	void comment_log(string s)
	{
		// часть экрана, занимаемая логом
		const double screen_part = 0.5;

		// число строк. 1 строка занимает 12 пикселей
		int rows = _math.round_to_int((screen_part * height_in_pixels(0)) / 12.0);
		if (rows < 1)
			rows = 1;

		string old_comment = comment();
		string lines[];
		int old_count = _str.split(old_comment, "\n", false, false, lines);

		int remove_count = old_count - (rows - 1);
		if (remove_count > 0)
			_arr.remove(lines, 0, remove_count);

		_arr.add(lines, "[" + ::TimeToString(::TimeLocal(), TIME_MINUTES | TIME_SECONDS) + "] " + s);
		comment(_arr.to_string(lines, "\n"));
	}

#ifdef __MQL4__

	// Свойства
	_BSL_CHART_GET(bool, is_offline, CHART_IS_OFFLINE) // r/o

#else

	// Функции для работы с индикаторами графика, только мт5
	bool   indicator_add    ( int window, int    indicator_handle    ) const { return(::ChartIndicatorAdd    ( id_, window, indicator_handle    )); }
	bool   indicator_delete ( int window, string indicator_shortname ) const { return(::ChartIndicatorDelete ( id_, window, indicator_shortname )); }
	int    indicator_get    ( int window, string indicator_shortname ) const { return(::ChartIndicatorGet    ( id_, window, indicator_shortname )); }
	string indicator_name   ( int window, int    index               ) const { return(::ChartIndicatorName   ( id_, window, index               )); }
	int    indicators_total ( int window                             ) const { return(::ChartIndicatorsTotal ( id_, window                      )); }

	// Свойства

	// Identifying "Chart" (OBJ_CHART) object – returns true for a graphical object (r/o)
	_BSL_CHART_GET(bool, is_object, CHART_IS_OBJECT)

	// The name of the Expert Advisor running on the chart
	_BSL_CHART_GET(string, expert_name, CHART_EXPERT_NAME)
	_BSL_CHART_SET(string, expert_name, CHART_EXPERT_NAME)

	// The name of the script running on the chart
	_BSL_CHART_GET(string, script_name, CHART_SCRIPT_NAME)
	_BSL_CHART_SET(string, script_name, CHART_SCRIPT_NAME)

	// Price chart drawing
	_BSL_CHART_GET(bool, show, CHART_SHOW)
	_BSL_CHART_SET(bool, show, CHART_SHOW)

	// 5.1730

	// Enabling/disabling access to the context menu using the right click
	_BSL_CHART_GET(bool, context_menu, CHART_CONTEXT_MENU)
	_BSL_CHART_SET(bool, context_menu, CHART_CONTEXT_MENU)

	// Enabling/disabling access to the Crosshair tool using the middle click
	_BSL_CHART_GET(bool, crosshair_tool, CHART_CROSSHAIR_TOOL)
	_BSL_CHART_SET(bool, crosshair_tool, CHART_CROSSHAIR_TOOL)

	// Sending messages about mouse wheel events (CHARTEVENT_MOUSE_WHEEL) to all mql5 programs on a chart
	_BSL_CHART_GET(bool, event_mouse_wheel, CHART_EVENT_MOUSE_WHEEL)
	_BSL_CHART_SET(bool, event_mouse_wheel, CHART_EVENT_MOUSE_WHEEL)

	// 5.1930

	// The chart window is docked
	_BSL_CHART_GET(bool, is_docked, CHART_IS_DOCKED)
	_BSL_CHART_SET(bool, is_docked, CHART_IS_DOCKED)

	// The left coordinate of the undocked chart window relative to the virtual screen
	_BSL_CHART_GET(int, float_left, CHART_FLOAT_LEFT)
	_BSL_CHART_SET(int, float_left, CHART_FLOAT_LEFT)

	// The top coordinate of the undocked chart window relative to the virtual screen
	_BSL_CHART_GET(int, float_top, CHART_FLOAT_TOP)
	_BSL_CHART_SET(int, float_top, CHART_FLOAT_TOP)

	// The right coordinate of the undocked chart window relative to the virtual screen
	_BSL_CHART_GET(int, float_right, CHART_FLOAT_RIGHT)
	_BSL_CHART_SET(int, float_right, CHART_FLOAT_RIGHT)

	// The bottom coordinate of the undocked chart window relative to the virtual screen
	_BSL_CHART_GET(int, float_bottom, CHART_FLOAT_BOTTOM)
	_BSL_CHART_SET(int, float_bottom, CHART_FLOAT_BOTTOM)


#endif


protected:

	// Универсальные функции доступа к свойствам
	CBChart *set(ENUM_CHART_PROPERTY_DOUBLE  property_id, double value) { ::ChartSetDouble( id_, property_id, value); return(&this); }
	CBChart *set(ENUM_CHART_PROPERTY_INTEGER property_id, long   value) { ::ChartSetInteger(id_, property_id, value); return(&this); }
	CBChart *set(ENUM_CHART_PROPERTY_STRING  property_id, string value) { ::ChartSetString( id_, property_id, value); return(&this); }
	CBChart *set(ENUM_CHART_PROPERTY_INTEGER property_id, int window, long value) { ::ChartSetInteger(id_, property_id, value); return(&this); }

	double get(ENUM_CHART_PROPERTY_DOUBLE  property_id, int window = 0) const { return(::ChartGetDouble( id_, property_id, window)); }
	long   get(ENUM_CHART_PROPERTY_INTEGER property_id, int window = 0) const { return(::ChartGetInteger(id_, property_id, window)); }
	string get(ENUM_CHART_PROPERTY_STRING  property_id                ) const { return(::ChartGetString( id_, property_id        )); }

	bool get(ENUM_CHART_PROPERTY_DOUBLE  property_id, int window, double &value) const { return(::ChartGetDouble( id_, property_id, window, value)); }
	bool get(ENUM_CHART_PROPERTY_INTEGER property_id, int window, long   &value) const { return(::ChartGetInteger(id_, property_id, window, value)); }
	bool get(ENUM_CHART_PROPERTY_STRING  property_id,             string &value) const { return(::ChartGetString( id_, property_id,         value)); }

} _chart;
