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
Класс доступа к свойствам графического объекта. © FXcoder

todo: изменить порядок параметров в конструкторах на : chart id, subwindow, obj_type, name, x/y or time/price
todo: создать иерархию типов графических объектов (как в CPlot)?
*/

#property strict

#include "type/uncopyable.mqh"
#include "util/ptr.mqh"
#include "const.mqh"
#include "debug.mqh"


class CBGO: public CBUncopyable
{
protected:

	const long   chart_id_;
	const string name_;
	bool last_set_res_; // последний результат 'bool set()'

	// Массивы свойств графического объекта
	static const ENUM_OBJECT_PROPERTY_INTEGER integers_[];
	static const ENUM_OBJECT_PROPERTY_DOUBLE  doubles_[];
	static const ENUM_OBJECT_PROPERTY_STRING  strings_[];


public:

	// Полный конструктор (с пересозданием объекта на графике)
	void CBGO(long chart_id, string name, ENUM_OBJECT obj_type, int subwindow,
		datetime time1, double price1,
		datetime time2 = 0, double price2 = 0,
		datetime time3 = 0, double price3 = 0):
			chart_id_(chart_id), name_(name), last_set_res_(false)
	{
		recreate(obj_type, subwindow, time1, price1, time2, price2, time3, price3);
	}

	// Конструктор для текущего графика (с пересозданием объекта на графике)
	void CBGO(string name, ENUM_OBJECT obj_type, int subwindow,
		datetime time1, double price1,
		datetime time2 = 0, double price2 = 0,
		datetime time3 = 0, double price3 = 0):
			chart_id_(0), name_(name), last_set_res_(false)
	{
		recreate(obj_type, subwindow, time1, price1, time2, price2, time3, price3);
	}

	// Конструктор для текущего графика и главного подокна (с пересозданием объекта на графике)
	void CBGO(string name, ENUM_OBJECT obj_type,
		datetime time1, double price1,
		datetime time2 = 0, double price2 = 0,
		datetime time3 = 0, double price3 = 0):
			chart_id_(0), name_(name), last_set_res_(false)
	{
		recreate(obj_type, 0, time1, price1, time2, price2, time3, price3);
	}

	// Конструктор (без создания объекта на графике)
	void CBGO(long chart_id, string name):
		chart_id_(chart_id), name_(name), last_set_res_(false)
	{
	}

	// Конструктор (без создания объекта на графике), текущий график
	void CBGO(string name):
		chart_id_(0), name_(name), last_set_res_(false)
	{
	}

	// Конструктор по умолчанию (без создания объекта на графике)
	void CBGO():
		chart_id_(0), name_(""), last_set_res_(false)
	{
	}

	// (пере)создать объект на графике
	virtual CBGO *recreate(ENUM_OBJECT obj_type, int subwindow,
		datetime time1, double price1,
		datetime time2 = 0, double price2 = 0,
		datetime time3 = 0, double price3 = 0)
	{
		// тесты показывают, что удаление и создание быстрее поиска и переустановки свойств (5.2167b->5.2170)
		return(del().create(obj_type, subwindow, time1, price1, time2, price2, time3, price3));
	}

	// создать объект на графике
	virtual CBGO *create(ENUM_OBJECT obj_type, int subwindow,
		datetime time1, double price1,
		datetime time2 = 0, double price2 = 0,
		datetime time3 = 0, double price3 = 0)
	{
		if (!::ObjectCreate(chart_id_, name_, obj_type, subwindow, time1, price1, time2, price2, time3, price3))
		{
		}

		return(&this);
	}

	virtual int    find      () const { return(ObjectFind(chart_id_, name_)); }
	virtual bool   exists    () const { return(find() >= 0); }
	virtual CBGO  *redraw    () { ChartRedraw(chart_id_); return(&this); } // функции отдельного обновления нет, обновить весь график
	virtual CBGO  *del       () { ObjectDelete(chart_id_, name_); return(&this); }

	virtual string name            () const { return(name_);    }
	virtual long   chart_id        () const { return(chart_id_); }
	virtual bool   last_set_result () const { return(last_set_res_); }

	// Функции доступа к конкретным свойствам
	virtual CBGO *align        ( ENUM_ALIGN_MODE   value            ) { return(set(OBJPROP_ALIGN,         value )); }
	virtual CBGO *anchor       ( ENUM_ANCHOR_POINT value            ) { return(set(OBJPROP_ANCHOR,        value )); }
	virtual CBGO *angle        ( double            value            ) { return(set(OBJPROP_ANGLE,         value )); }
	virtual CBGO *arrow_anchor ( ENUM_ARROW_ANCHOR value            ) { return(set(OBJPROP_ANCHOR,        value )); } // отдельно ArrowAnchor из-за плохого дизайна ENUM_OBJECT_PROPERTY_INTEGER (совмещение ENUM_ARROW_ANCHOR и ENUM_ANCHOR_POINT)
	virtual CBGO *arrow_code   ( int               value            ) { return(set(OBJPROP_ARROWCODE,     value )); }
	virtual CBGO *back         ( bool              value            ) { return(set(OBJPROP_BACK,          value )); }
	virtual CBGO *bg_color     ( color             value            ) { return(set(OBJPROP_BGCOLOR,       value )); }
	virtual CBGO *bmp_file     ( string            value, int n = 0 ) { return(set(OBJPROP_BMPFILE,    n, value )); }
	virtual CBGO *border_color ( color             value            ) { return(set(OBJPROP_BORDER_COLOR,  value )); }
	virtual CBGO *border_type  ( ENUM_BORDER_TYPE  value            ) { return(set(OBJPROP_BORDER_TYPE,   value )); }
	virtual CBGO *colour       ( color             value            ) { return(set(OBJPROP_COLOR,         value )); }
	virtual CBGO *corner       ( ENUM_BASE_CORNER  value            ) { return(set(OBJPROP_CORNER,        value )); }
	virtual CBGO *deviation    ( double            value            ) { return(set(OBJPROP_DEVIATION,     value )); }
	virtual CBGO *ellipse      ( bool              value            ) { return(set(OBJPROP_ELLIPSE,       value )); }
	virtual CBGO *fill         ( bool              value            ) { return(set(OBJPROP_FILL,          value )); }
	virtual CBGO *font         ( string            value            ) { return(set(OBJPROP_FONT,          value )); }
	virtual CBGO *font_size    ( int               value            ) { return(set(OBJPROP_FONTSIZE,      value )); }
	virtual CBGO *hidden       ( bool              value            ) { return(set(OBJPROP_HIDDEN,        value )); }
	virtual CBGO *level_color  ( color             value, int n = 0 ) { return(set(OBJPROP_LEVELCOLOR, n, value )); }
	virtual CBGO *levels       ( int               value            ) { return(set(OBJPROP_LEVELS,        value )); }
	virtual CBGO *level_style  ( ENUM_LINE_STYLE   value, int n = 0 ) { return(set(OBJPROP_LEVELSTYLE, n, value )); }
	virtual CBGO *level_text   ( string            value, int n = 0 ) { return(set(OBJPROP_LEVELTEXT,  n, value )); }
	virtual CBGO *level_value  ( double            value, int n = 0 ) { return(set(OBJPROP_LEVELVALUE, n, value )); }
	virtual CBGO *level_width  ( datetime          value, int n = 0 ) { return(set(OBJPROP_LEVELWIDTH, n, value )); }
	virtual CBGO *price        ( double            value, int n = 0 ) { return(set(OBJPROP_PRICE,      n, value )); }

	virtual CBGO *ray          ( bool              value            ) { return(set(OBJPROP_RAY,           value )); }

#ifdef __MQL4__
	virtual CBGO *ray_left     ( bool              value            ) { return(&this);                              } // nothing to do in 4
	virtual CBGO *ray_right    ( bool              value            ) { return(set(OBJPROP_RAY,           value )); } // in 4 RAY is equivalent to RAY_RIGHT
#else
	virtual CBGO *ray_left     ( bool              value            ) { return(set(OBJPROP_RAY_LEFT,      value )); }
	virtual CBGO *ray_right    ( bool              value            ) { return(set(OBJPROP_RAY_RIGHT,     value )); }
#endif

	virtual CBGO *read_only    ( bool              value            ) { return(set(OBJPROP_READONLY,      value )); }
	virtual CBGO *scale        ( double            value            ) { return(set(OBJPROP_SCALE,         value )); }
	virtual CBGO *selectable   ( bool              value            ) { return(set(OBJPROP_SELECTABLE,    value )); }
	virtual CBGO *selected     ( bool              value            ) { return(set(OBJPROP_SELECTED,      value )); }
	virtual CBGO *state        ( bool              value            ) { return(set(OBJPROP_STATE,         value )); }
	virtual CBGO *style        ( ENUM_LINE_STYLE   value            ) { return(set(OBJPROP_STYLE,         value )); }
	virtual CBGO *symbol       ( string            value            ) { return(set(OBJPROP_SYMBOL,        value )); }
	virtual CBGO *text         ( string            value            ) { return(set(OBJPROP_TEXT,          value )); }
	virtual CBGO *time         ( datetime          value, int n = 0 ) { return(set(OBJPROP_TIME,       n, value )); }
	virtual CBGO *timeframes   ( long              value            ) { return(set(OBJPROP_TIMEFRAMES,    value )); }
	virtual CBGO *tooltip      ( string            value            ) { return(set(OBJPROP_TOOLTIP,       value )); }
	virtual CBGO *width        ( int               value            ) { return(set(OBJPROP_WIDTH,         value )); } // line width, see XSise for object width
	virtual CBGO *xdistance    ( int               value            ) { return(set(OBJPROP_XDISTANCE,     value )); }
	virtual CBGO *xoffset      ( int               value            ) { return(set(OBJPROP_XOFFSET,       value )); }
	virtual CBGO *xsize        ( int               value            ) { return(set(OBJPROP_XSIZE,         value )); }
	virtual CBGO *ydistance    ( int               value            ) { return(set(OBJPROP_YDISTANCE,     value )); }
	virtual CBGO *yoffset      ( int               value            ) { return(set(OBJPROP_YOFFSET,       value )); }
	virtual CBGO *ysize        ( int               value            ) { return(set(OBJPROP_YSIZE,         value )); }
	virtual CBGO *zorder       ( long              value            ) { return(set(OBJPROP_ZORDER,        value )); }

	virtual ENUM_ALIGN_MODE     align        ()          const { return( (ENUM_ALIGN_MODE)   get(OBJPROP_ALIGN         )); }
	virtual ENUM_ANCHOR_POINT   anchor       ()          const { return( (ENUM_ANCHOR_POINT) get(OBJPROP_ANCHOR        )); }
	virtual double              angle        ()          const { return(                     get(OBJPROP_ANGLE         )); }
	virtual ENUM_ARROW_ANCHOR   arrow_anchor ()          const { return( (ENUM_ARROW_ANCHOR) get(OBJPROP_ANCHOR        )); } // отдельно ArrowAnchor из-за плохого дизайна ENUM_OBJECT_PROPERTY_INTEGER (совмещение ENUM_ARROW_ANCHOR и ENUM_ANCHOR_POINT)
	virtual int                 arrow_code   ()          const { return( (int)               get(OBJPROP_ARROWCODE     )); }
	virtual bool                back         ()          const { return( (bool)              get(OBJPROP_BACK          )); }
	virtual color               bg_color     ()          const { return( (color)             get(OBJPROP_BGCOLOR       )); }
	virtual string              bmp_file     ()          const { return(                     get(OBJPROP_BMPFILE       )); } // modifier?
	virtual color               border_color ()          const { return( (color)             get(OBJPROP_BORDER_COLOR  )); }
	virtual ENUM_BORDER_TYPE    border_type  ()          const { return( (ENUM_BORDER_TYPE)  get(OBJPROP_BORDER_TYPE   )); }
	virtual color               colour       ()          const { return( (color)             get(OBJPROP_COLOR         )); }
	virtual ENUM_BASE_CORNER    corner       ()          const { return( (ENUM_BASE_CORNER)  get(OBJPROP_CORNER        )); }
	virtual datetime            create_time  ()          const { return( (datetime)          get(OBJPROP_CREATETIME    )); } // r/o
	virtual double              deviation    ()          const { return(                     get(OBJPROP_DEVIATION     )); }
	virtual bool                ellipse      ()          const { return( (bool)              get(OBJPROP_ELLIPSE       )); }
	virtual bool                fill         ()          const { return( (bool)              get(OBJPROP_FILL          )); }
	virtual string              font         ()          const { return(                     get(OBJPROP_FONT          )); }
	virtual int                 font_size    ()          const { return( (int)               get(OBJPROP_FONTSIZE      )); }
	virtual bool                hidden       ()          const { return( (bool)              get(OBJPROP_HIDDEN        )); }
	virtual color               level_color  (int n = 0) const { return( (color)             get(OBJPROP_LEVELCOLOR, n )); }
	virtual int                 levels       ()          const { return( (int)               get(OBJPROP_LEVELS        )); }
	virtual ENUM_LINE_STYLE     level_style  (int n = 0) const { return( (ENUM_LINE_STYLE)   get(OBJPROP_LEVELSTYLE, n )); }
	virtual string              level_text   (int n = 0) const { return(                     get(OBJPROP_LEVELTEXT,  n )); }
	virtual double              level_value  (int n = 0) const { return(                     get(OBJPROP_LEVELVALUE, n )); }
	virtual int                 level_width  (int n = 0) const { return( (int)               get(OBJPROP_LEVELWIDTH, n )); }
	//virtual string              name         ()          const { return(                     get(OBJPROP_NAME          )); }
	virtual double              price        (int n = 0) const { return(                     get(OBJPROP_PRICE,      n )); }

	virtual bool                ray          ()          const { return( (bool)              get(OBJPROP_RAY           )); }
#ifdef __MQL4__
	virtual bool                ray_left     ()          const { return( false );                                          } // no left ray in 4
	virtual bool                ray_right    ()          const { return( (bool)              get(OBJPROP_RAY_RIGHT     )); }
#else
	virtual bool                ray_left     ()          const { return( (bool)              get(OBJPROP_RAY_LEFT      )); }
	virtual bool                ray_right    ()          const { return( (bool)              get(OBJPROP_RAY_RIGHT     )); }
#endif

	virtual bool                read_only    ()          const { return( (bool)              get(OBJPROP_READONLY      )); }
	virtual double              scale        ()          const { return(                     get(OBJPROP_SCALE         )); }
	virtual bool                selectable   ()          const { return( (bool)              get(OBJPROP_SELECTABLE    )); }
	virtual bool                selected     ()          const { return( (bool)              get(OBJPROP_SELECTED      )); }
	virtual bool                state        ()          const { return( (bool)              get(OBJPROP_STATE         )); }
	virtual ENUM_LINE_STYLE     style        ()          const { return( (ENUM_LINE_STYLE)   get(OBJPROP_STYLE         )); }
	virtual string              symbol       ()          const { return(                     get(OBJPROP_SYMBOL        )); }
	virtual string              text         ()          const { return(                     get(OBJPROP_TEXT          )); }
	virtual datetime            time         (int n = 0) const { return( (datetime)          get(OBJPROP_TIME,       n )); }
	virtual long                timeframes   ()          const { return(                     get(OBJPROP_TIMEFRAMES    )); }
	virtual string              tooltip      ()          const { return(                     get(OBJPROP_TOOLTIP       )); }
	virtual ENUM_OBJECT         type         ()          const { return( (ENUM_OBJECT)       get(OBJPROP_TYPE          )); } // r/o
	virtual int                 width        ()          const { return( (int)               get(OBJPROP_WIDTH         )); }
	virtual int                 xdistance    ()          const { return( (int)               get(OBJPROP_XDISTANCE     )); }
	virtual int                 xoffset      ()          const { return( (int)               get(OBJPROP_XOFFSET       )); }
	virtual int                 xsize        ()          const { return( (int)               get(OBJPROP_XSIZE         )); }
	virtual int                 ydistance    ()          const { return( (int)               get(OBJPROP_YDISTANCE     )); }
	virtual int                 yoffset      ()          const { return( (int)               get(OBJPROP_YOFFSET       )); }
	virtual int                 ysize        ()          const { return( (int)               get(OBJPROP_YSIZE         )); }
	virtual long                zorder       ()          const { return(                     get(OBJPROP_ZORDER        )); }

	// Функции доступа к комбинациям свойств, например, XY(x,y) = xdistance(x).ydistance(y).
	virtual CBGO *font(string font_name, int font_size)
	{
		return(this.font(font_name).font_size(font_size));
	}

	virtual CBGO *text(string text, int font_size, string font_name, color text_color)
	{
		return(this.text(text).font_size(font_size).font(font_name).colour(text_color));
	}

	virtual CBGO *text(string text, string font_name, int font_size, color text_color)
	{
		return(this.text(text).font_size(font_size).font(font_name).colour(text_color));
	}

	virtual CBGO *time_price(datetime time, double price, int n = 0)
	{
		return(this.time(time, n).price(price, n));
	}

	virtual CBGO *time_price(datetime time1, double price1, datetime time2, double price2)
	{
		return(this.time_price(time1, price1, 0).time_price(time2, price2, 1));
	}

	virtual CBGO *time_price(datetime time1, double price1, datetime time2, double price2, datetime time3, double price3)
	{
		return(this.time_price(time1, price1, 0).time_price(time2, price2, 1).time_price(time3, price3, 2));
	}

	virtual CBGO *xy_size(int x_size, int y_size)
	{
		return(this.xsize(x_size).ysize(y_size));
	}

	virtual CBGO *xy(int x, int y)
	{
		return(this.xdistance(x).ydistance(y));
	}

	// Другие функции
	virtual CBGO *tooltip_disable()
	{
		// \n - специальное значение для отключения подсказки
		return(this.set(OBJPROP_TOOLTIP, _const.disable_tooltip));
	}

	virtual CBGO *line_style(ENUM_LINE_STYLE line_style, int line_width, color line_color)
	{
		style(line_style);
		// Хотя это свойство имеет смысл только для сплошной линии, всё равно установить свойство,
		// т.к. это предполагается. Кроме того, в будущих версиях может появиться поддержка жирных пунктиров,
		// либо такая поддержка придёт из своей прослойки для рисования.
		width(line_width);
		colour(line_color);
		return(&this);
	}

	// LONG_MAX и LONG_MIN не работают (4.1170), mki#1
	virtual CBGO *zorder_max() { return(zorder(INT_MAX)); }
	virtual CBGO *zorder_min() { return(zorder(INT_MIN)); }

	virtual datetime time1()  const { return(time(0)); }
	virtual datetime time2()  const { return(time(1)); }
	virtual datetime time3()  const { return(time(2)); }
	virtual double   price1() const { return(price(0)); }
	virtual double   price2() const { return(price(1)); }
	virtual double   price3() const { return(price(2)); }

#ifdef __MQL4__
	virtual CBGO *ray_left_right (bool value)                        { return(ray_right(       value )); }
	virtual CBGO *ray_left_right (bool left_value, bool right_value) { return(ray_right( right_value )); }
#else
	virtual CBGO *ray_left_right (bool value)                        { return(ray_left(      value ).ray_right(       value )); }
	virtual CBGO *ray_left_right (bool left_value, bool right_value) { return(ray_left( left_value ).ray_right( right_value )); }
#endif

	virtual bool is_xy_object() const
	{
		ENUM_OBJECT ot = type();
		return((ot == OBJ_LABEL) || (ot == OBJ_BITMAP_LABEL) || (ot == OBJ_RECTANGLE_LABEL) || (ot == OBJ_BUTTON) || (ot == OBJ_CHART) || (ot == OBJ_EDIT));
	}

	virtual bool is_time_only_object() const
	{
		ENUM_OBJECT ot = type();
		return((ot == OBJ_VLINE) || (ot == OBJ_CYCLES) || (ot == OBJ_FIBOTIMES) || (ot == OBJ_EVENT));
	}

	virtual bool is_bitmap_object() const
	{
		ENUM_OBJECT ot = type();
		return((ot == OBJ_BITMAP) || (ot == OBJ_BITMAP_LABEL));
	}

	virtual bool is_control_object() const
	{
		ENUM_OBJECT ot = type();
		return((ot == OBJ_BUTTON) || (ot == OBJ_EDIT));
	}


#ifndef __MQL4__

	virtual CBGO *chart_scale ( int                     value ) { return(set( OBJPROP_CHART_SCALE, value )); }
	virtual CBGO *date_scale  ( bool                    value ) { return(set( OBJPROP_DATE_SCALE,  value )); }
	virtual CBGO *degree      ( ENUM_ELLIOT_WAVE_DEGREE value ) { return(set( OBJPROP_DEGREE,      value )); }
	virtual CBGO *direction   ( ENUM_GANN_DIRECTION     value ) { return(set( OBJPROP_DIRECTION,   value )); }
	virtual CBGO *draw_lines  ( bool                    value ) { return(set( OBJPROP_DRAWLINES,   value )); }
	virtual CBGO *period      ( ENUM_TIMEFRAMES         value ) { return(set( OBJPROP_PERIOD,      value )); }
	virtual CBGO *price_scale ( bool                    value ) { return(set( OBJPROP_PRICE_SCALE, value )); }

	virtual int                      chart_scale () const { return( (int)                     get( OBJPROP_CHART_SCALE )); }
	virtual bool                     date_scale  () const { return( (bool)                    get( OBJPROP_DATE_SCALE  )); }
	virtual long                     subchart_id () const { return(                           get( OBJPROP_CHART_ID    )); } // r/o
	virtual ENUM_ELLIOT_WAVE_DEGREE  degree      () const { return( (ENUM_ELLIOT_WAVE_DEGREE) get( OBJPROP_DEGREE      )); }
	virtual ENUM_GANN_DIRECTION      direction   () const { return( (ENUM_GANN_DIRECTION)     get( OBJPROP_DIRECTION   )); }
	virtual bool                     draw_lines  () const { return( (bool)                    get( OBJPROP_DRAWLINES   )); }
	virtual ENUM_TIMEFRAMES          period      () const { return( (ENUM_TIMEFRAMES)         get( OBJPROP_PERIOD      )); }
	virtual bool                     price_scale () const { return( (bool)                    get( OBJPROP_PRICE_SCALE )); }

#endif

	// Универсальные функции доступа к свойствам
	virtual CBGO *set(ENUM_OBJECT_PROPERTY_INTEGER property_id, long   value) { last_set_res_ = ObjectSetInteger(chart_id_, name_, property_id, value); return(&this); }
	virtual CBGO *set(ENUM_OBJECT_PROPERTY_DOUBLE  property_id, double value) { last_set_res_ = ObjectSetDouble (chart_id_, name_, property_id, value); return(&this); }
	virtual CBGO *set(ENUM_OBJECT_PROPERTY_STRING  property_id, string value) { last_set_res_ = ObjectSetString (chart_id_, name_, property_id, value); return(&this); }

	virtual CBGO *set(ENUM_OBJECT_PROPERTY_INTEGER property_id, int modifier, long   value) { last_set_res_ = ObjectSetInteger(chart_id_, name_, property_id, modifier, value); return(&this); }
	virtual CBGO *set(ENUM_OBJECT_PROPERTY_DOUBLE  property_id, int modifier, double value) { last_set_res_ = ObjectSetDouble (chart_id_, name_, property_id, modifier, value); return(&this); }
	virtual CBGO *set(ENUM_OBJECT_PROPERTY_STRING  property_id, int modifier, string value) { last_set_res_ = ObjectSetString (chart_id_, name_, property_id, modifier, value); return(&this); }

	virtual long   get(ENUM_OBJECT_PROPERTY_INTEGER property_id, int modifier = 0) const { return(ObjectGetInteger(chart_id_, name_, property_id, modifier)); }
	virtual double get(ENUM_OBJECT_PROPERTY_DOUBLE  property_id, int modifier = 0) const { return(ObjectGetDouble (chart_id_, name_, property_id, modifier)); }
	virtual string get(ENUM_OBJECT_PROPERTY_STRING  property_id, int modifier = 0) const { return(ObjectGetString (chart_id_, name_, property_id, modifier)); }

	virtual bool get(ENUM_OBJECT_PROPERTY_INTEGER property_id, int modifier, long   &value) const { return(ObjectGetInteger(chart_id_, name_, property_id, modifier, value)); }
	virtual bool get(ENUM_OBJECT_PROPERTY_DOUBLE  property_id, int modifier, double &value) const { return(ObjectGetDouble (chart_id_, name_, property_id, modifier, value)); }
	virtual bool get(ENUM_OBJECT_PROPERTY_STRING  property_id, int modifier, string &value) const { return(ObjectGetString (chart_id_, name_, property_id, modifier, value)); }
};


// Константы свойств графического объекта.
// Для удобства поиска изменений порядок соотвествует порядку в справке.

const ENUM_OBJECT_PROPERTY_INTEGER CBGO::integers_[] =
{
/*
	Универсальные     Только мт4          Только мт5
*/
	OBJPROP_COLOR,
	OBJPROP_STYLE,
	OBJPROP_WIDTH,
	OBJPROP_BACK,
	OBJPROP_ZORDER,
#ifndef __MQL4__
	                                      OBJPROP_FILL,
#endif
	OBJPROP_HIDDEN,
	OBJPROP_SELECTED,
	OBJPROP_READONLY,
	OBJPROP_TYPE,
	OBJPROP_TIME,
	OBJPROP_SELECTABLE,
	OBJPROP_CREATETIME,
	OBJPROP_LEVELS,
	OBJPROP_LEVELCOLOR,
	OBJPROP_LEVELSTYLE,
	OBJPROP_LEVELWIDTH,
	OBJPROP_ALIGN,
	OBJPROP_FONTSIZE,
#ifndef __MQL4__
	                                      OBJPROP_RAY_LEFT,
#endif
	OBJPROP_RAY_RIGHT,
#ifndef __MQL4__
	                                      OBJPROP_RAY,
#endif
	OBJPROP_ELLIPSE,
	OBJPROP_ARROWCODE,
	OBJPROP_TIMEFRAMES,
	OBJPROP_ANCHOR,
	OBJPROP_XDISTANCE,
	OBJPROP_YDISTANCE,
#ifndef __MQL4__
	                                      OBJPROP_DIRECTION,
	                                      OBJPROP_DEGREE,
	                                      OBJPROP_DRAWLINES, // также присутствует в справке 4, но компилятор ругается
#endif
	OBJPROP_STATE,
#ifndef __MQL4__
	                                      OBJPROP_CHART_ID,
#endif
	OBJPROP_XSIZE,
	OBJPROP_YSIZE,
	OBJPROP_XOFFSET,
	OBJPROP_YOFFSET,
#ifndef __MQL4__
	                                      OBJPROP_PERIOD,
	                                      OBJPROP_DATE_SCALE,
	                                      OBJPROP_PRICE_SCALE,
	                                      OBJPROP_CHART_SCALE,
#endif
	OBJPROP_BGCOLOR,
	OBJPROP_CORNER,
	OBJPROP_BORDER_TYPE,
	OBJPROP_BORDER_COLOR,
};

const ENUM_OBJECT_PROPERTY_DOUBLE CBGO::doubles_[] = {
/*
	Универсальные     Только мт4          Только мт5
*/
	OBJPROP_PRICE,
	OBJPROP_LEVELVALUE,
	OBJPROP_SCALE,
	OBJPROP_ANGLE,
	OBJPROP_DEVIATION,
};

const ENUM_OBJECT_PROPERTY_STRING CBGO::strings_[] =
{
/*
	Универсальные     Только мт4          Только мт5
*/
	OBJPROP_NAME,
	OBJPROP_TEXT,
	OBJPROP_TOOLTIP,
	OBJPROP_LEVELTEXT,
	OBJPROP_FONT,
	OBJPROP_BMPFILE,
	OBJPROP_SYMBOL,
};
