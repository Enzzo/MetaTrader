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

#property copyright   "VP 10.2.1. © FXcoder"
#property link        "https://fxcoder.blogspot.com"
#property description "VP: Volume Profile Indicator"
#property strict
#property indicator_chart_window
#property indicator_plots 0

//#define DEBUG

#include "VP-include/bsl.mqh"
#include "VP-include/enum/hg_coloring.mqh"
#include "VP-include/enum/point_scale.mqh"

#include "VP-include/enum/quantile.mqh"
#include "VP-include/volume/enum/vp_bar_style.mqh"
#include "VP-include/volume/enum/vp_bar_ticks.mqh"
#include "VP-include/volume/enum/vp_hg_pos_period.mqh"
#include "VP-include/volume/enum/vp_hg_position.mqh"
#include "VP-include/volume/enum/vp_mode.mqh"
#include "VP-include/volume/enum/vp_range_sel.mqh"
#include "VP-include/volume/enum/vp_tick_price.mqh"
#include "VP-include/volume/enum/vp_time_shift.mqh"
#include "VP-include/volume/enum/vp_zoom.mqh"
#include "VP-include/volume/vp_indicator.mqh"


//#define input

#ifndef INPUT_GROUP
#define INPUT_GROUP ""
#endif

input ENUM_VP_MODE           Mode           = VP_MODE_PERIOD;        // Mode

input string                 g_per_mode_    = INPUT_GROUP;           // •••••••••• PERIOD MODE ••••••••••
input ENUM_TIMEFRAMES        RangePeriod    = PERIOD_D1;             // Range Period
input int                    RangeCount     = 20;                    // Range Count
input ENUM_VP_TIME_SHIFT     TimeShift      = VP_TIME_SHIFT_0;       // Time Zone Shift
input ENUM_VP_HG_POS_PERIOD  HgPosPeriod    = VP_HG_POS_PERIOD_L2R;  // Histogram Position
input ENUM_VP_ZOOM           ZoomType       = VP_ZOOM_AUTO_LOCAL;    // Zoom Type
input double                 ZoomCustom     = 0;                     // Custom Zoom

input string                 g_rng_mode_    = INPUT_GROUP;                     // •••••••••• RANGE MODE ••••••••••
input ENUM_VP_RANGE_SEL      RangeSelection = VP_RANGE_SEL_BETWEEN_LINES;      // Range Selection
input int                    RangeSize      = 1440;                            // Range Size (minutes or bars)
input ENUM_VP_HG_POSITION    HgPosition     = VP_HG_POSITION_CHART_RIGHT;      // Histogram Position

input string                 g_data_        = INPUT_GROUP;           // •••••••••• DATA ••••••••••
input ENUM_VP_SOURCE         DataSource     = VP_SOURCE_M1;          // Data Source
input ENUM_VP_BAR_TICKS      BarTicks       = VP_BAR_TICKS_OHLC;     // Bar Distribution

#ifdef __MQL4__
      ENUM_APPLIED_VOLUME    VolumeType     = VOLUME_TICK;           // Volume Type (always TICK in 4)

      ENUM_VP_TICK_PRICE     TickPriceType  = VP_TICK_PRICE_LAST_OR_AVG; // Price Type
      bool                   TickBid        = true;                  // Bid Price Changed
      bool                   TickAsk        = true;                  // Ask Price Changed
      bool                   TickLast       = true;                  // Last Price Changed
      bool                   TickVolume     = true;                  // Volume Changed
      bool                   TickBuy        = true;                  // Buy Deal
      bool                   TickSell       = true;                  // Sell Deal
#else
input ENUM_APPLIED_VOLUME    VolumeType     = VOLUME_TICK;           // Volume Type

input string                 g_tick_        = INPUT_GROUP;           // •••••••••• TICK ••••••••••
input ENUM_VP_TICK_PRICE     TickPriceType  = VP_TICK_PRICE_LAST_OR_AVG; // Price Type
input bool                   TickBid        = true;                  // Bid Price Changed
input bool                   TickAsk        = true;                  // Ask Price Changed
input bool                   TickLast       = true;                  // Last Price Changed
input bool                   TickVolume     = true;                  // Volume Changed
input bool                   TickBuy        = true;                  // Buy Deal
input bool                   TickSell       = true;                  // Sell Deal
#endif

input string                 g_calc_        = INPUT_GROUP;           // •••••••••• CALCULATION ••••••••••
input int                    ModeStep       = 100;                   // Mode Step (points)
input ENUM_POINT_SCALE       HgPointScale   = POINT_SCALE_10;        // Point Scale
input int                    Smooth         = 0;                     // Smooth Depth (0 => disable)

input string                 g_hg_          = INPUT_GROUP;           // •••••••••• HISTOGRAM ••••••••••
input ENUM_VP_BAR_STYLE      HgBarStyle     = VP_BAR_STYLE_LINE;     // Bar Style
input ENUM_HG_COLORING       HgColoring     = HG_COLORING_GRADIENT10;  // Coloring
input color                  HgColor        = C'128,160,192';        // Color 1 (Low Volume)
input color                  HgColor2       = C'128,160,192';        // Color 2 (High Volume)
input int                    HgLineWidth    = 1;                     // Line Width
input uint                   HgWidthPct     = 100;                   // Histogram Width (% of normal)

input string                 g_levels_      = INPUT_GROUP;         // •••••••••• LEVELS ••••••••••
input color                  ModeColor      = clrBlue;             // Mode Color
input color                  MaxColor       = clrNONE;             // Maximum Color
input int                    ModeLineWidth  = 1;                   // Mode Line Width

input color                  VwapColor      = clrNONE;             // VWAP Color

input ENUM_QUANTILE          Quantiles      = QUANTILE_NONE;       // Quantiles
input color                  QuantileColor  = clrChocolate;        // Quantile Color

input int                    StatLineWidth  = 1;                   // Quantile & VWAP Line Width
input ENUM_LINE_STYLE        StatLineStyle  = STYLE_DOT;           // Quantile & VWAP Line Style

input string                 g_lev_lines_   = INPUT_GROUP; // •••••••••• LEVEL LINES (range mode only) ••••••••••
input color                  ModeLevelColor = clrGreen;    // Mode Level Line Color (None=disable)
input int                    ModeLevelWidth = 1;           // Mode Level Line Width
input ENUM_LINE_STYLE        ModeLevelStyle = STYLE_SOLID; // Mode Level Line Style

input string                 g_service_     = INPUT_GROUP; // •••••••••• SERVICE ••••••••••
input bool                   ShowHorizon    = true;        // Show Data Horizon
input string                 Id             = "+vp";       // Identifier


const CVPPeriodModeParams params_period_(RangePeriod, RangeCount, TimeShift,/** SessionStart, SessionEnd,**/ HgPosPeriod, ZoomType, ZoomCustom);
const CVPRangeModeParams params_range_(RangeSelection, RangeSize, HgPosition);
const CVPDataParams params_data_(DataSource, BarTicks, VolumeType);
const CVPTickParams params_tick_(TickPriceType, TickBid, TickAsk, TickLast, TickVolume, TickBuy, TickSell);
const CVPCalcParams params_calc_(ModeStep, HgPointScale, Smooth);

const CVPHgParams params_hg_(
	HgBarStyle,
	HgColoring,
	// if colors are equal in color mode, make first transparent (none)
	((HgBarStyle == VP_BAR_STYLE_COLOR) && EnumHGColoringIsMulticolor(HgColoring) && (HgColor == HgColor2)) ? _color.none : HgColor,
	HgColor2,
	HgLineWidth,
	HgWidthPct);

const CVPLevelsParams params_lvl_(
	ModeColor,
	MaxColor,
	QuantileColor,
	VwapColor,
	ModeLineWidth,
	StatLineWidth,
	StatLineStyle,
	// do not show level lines in period mode
	Mode == VP_MODE_PERIOD ? _color.none : ModeLevelColor,
	ModeLevelWidth,
	ModeLevelStyle,
	Quantiles);

const CVPServiceParams params_service_(ShowHorizon, Id);


CVPIndicator vpi_(
	Mode,
	params_period_,
	params_range_,
	params_data_,
	params_tick_,
	params_calc_,
	params_hg_,
	params_lvl_,
	params_service_
);


void OnInit()
{
	vpi_.init();
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
	if (!_tf.is_enabled())
		return;

	_chartevent.init(id, lparam, dparam, sparam);
	vpi_.chart_event();
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
{
	_tf.enable();
	return(vpi_.calculate(rates_total, prev_calculated));
}

void OnTimer()
{
	if (!_tf.is_enabled())
		return;

	vpi_.timer();
}

void OnDeinit(const int reason)
{
	vpi_.deinit(reason);
}


/*
Последние изменения

10.2:
	* исправлено: не удаляются старые уровни VWAP у последней гистограммы, #33
	* исправлено: не удаляются старые гистограммы (левее первой), #34
	* исправлено: лишний тик в избыточных данных (редко), #39

10.1:
	* исправлено: неверное направление отображения в Range Mode (всегда рисуется вправо), #32

10.0:
	* добавлен параметр BarTicks - распределение тиков внутри бара, #15
	* добавлены режимы диапазона Bars to Line и Last Bars, параметр RangeMinutes переименован в RangeSize, #21
	* параметр RangeMode переименован в RangeSelection
	* параметр DrawDirection заменён на HgPosPeriod, в Period Mode добавлены варианты размещения гистограммы относительно центра
	* добавлены таймфреймы источника данных H1-D1
	* TickPriceType дополнен вариантами: Bid/Ask Average, Last or Bid/Ask Average (теперь по умолчанию)
	* HgPointScale дополнен вариантами *5 и *50
	* исправлено: диапазон Last Minutes всегда использовал M1, что мешало работать большими диапазонами, #25
	* исправлено: уменьшена вероятность мерцания последней или единственной (в режиме диапазона) гистограммы, #30
	* исправлено: смещается отображение после подгрузки данных, #22
	* исправлено: не рисуется самый нижний бар (кроме случая Bar Style = Outline)

9.0:
	* исправлено: не находятся моды, расположенные близко к краям, #19
	* добавлен параметр Quantiles для отображения некоторых квантилей, включая медиану, вместо только медианы, параметр MedianColor переименован QuantileColor
	* добавлен параметр HgColoring - способ расцветки гистограмм
	* добавлен параметр StatLineWidth - толщина линий статистики (VWAP, квантили), раньше была общей с толщиной мод
	* при Bar Style = Color если оба цвета одинаковы, то первый считается прозрачным
	* добавлен обязательный временной зазор между обновлениями (500 мс)
*/
