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

// Symbol and custom symbol. © FXcoder


#property strict

#include "type/uncopyable.mqh"
#include "type/dict.mqh"
#include "util/double.mqh"
#include "util/math.mqh"
#include "util/ptr.mqh"
#include "util/sym.mqh"

// sugar
// mki#25 из-за бага неудобно использовать объединённые шаблоны (get и set в одном)
#define _BSL_SYMBOL_GET(T, N, P)         T      N() const { return((T)get(P));        }
#define _BSL_SYMBOL_GET_CACHED(T, N, P)  T      N()       { return((T)get_cached(P)); }

#define _BSL_SYMBOL_GET_STORED_DBL(N, P)  \
    double N()                            \
    {                                     \
        if (N##_ != _double.empty_value)  \
            return(N##_);                 \
        if (!get(P, N##_))                \
            return(_double.empty_value);  \
        return(N##_);                     \
    }

#ifdef __MQL4__
	// в 4 нет функций установки свойств (собственных символов)
	#define _BSL_SYMBOL_SET(T, N, P)
	#define _BSL_SYMBOL_SET_CACHED(T, N, P)
	#define _BSL_SYMBOL_SET_STORED_DBL(N, P)
#else
	#define _BSL_SYMBOL_SET(T, N, P)         CBSymbol *N(T      value) { return(set(P, value));       }
	#define _BSL_SYMBOL_SET_CACHED(T, N, P)  CBSymbol *N(T      value) { return(set_cached(P, value)); }
	#define _BSL_SYMBOL_SET_STORED_DBL(N, P) CBSymbol *N(double value) { N##_ = value; return(set(P, value)); }
#endif


class CBSymbol: public CBUncopyable
{
private:

	// cache
	double volume_step_;
	double volume_min_;


protected:

	const string name_;
	const bool is_current_;

	// Словари с кэшем.
	// Не самый быстрый вариант. Самый - это отдельный член для каждой переменной с проверкой изменений (раз в 5-10 быстрее).
	// Незначительно (15-20%) быстрее вариант с массивами с прямой адресацией свойств (cache_double_[property_id]).
	CBDict<ENUM_SYMBOL_INFO_DOUBLE,  double> cache_double_;
	CBDict<ENUM_SYMBOL_INFO_INTEGER, long  > cache_long_;
	CBDict<ENUM_SYMBOL_INFO_STRING,  string> cache_string_;


public:

	void CBSymbol():
		name_(_Symbol),
		is_current_(true)
	{
		clear_cache();
	}

	void CBSymbol(string symbol):
		name_(_sym.real(symbol)),
		is_current_(_sym.is_current(symbol))
	{
		clear_cache();
	}

	string name() const { return(name_); }

	// функции
	MqlTick tick()              const { MqlTick tick; ::SymbolInfoTick(name_, tick); return(tick); }
	bool    tick(MqlTick &tick) const { return(::SymbolInfoTick(name_, tick)); }
	bool    select(bool select) const { return(::SymbolSelect(name_, select)); }

	bool is_synchronized() const
	{
#ifdef __MQL4__
		return(true);
#else
		return(::SymbolIsSynchronized(name_));
#endif
	}

	// selected_only - искать только в выбранных (в обзоре рынка)
	bool exists(bool selected_only = false)
	{
		return(_sym.exists(name_, selected_only));
	}

	bool is_current() const { return(is_current_); }

	bool is_trade_allowed(datetime time) const
	{
		//return(::IsTradeAllowed(name_, time));

		return(true);
	}

	/*
	Нормализовать лот.
	Лот будет ограничен сверху максимальным лотом, снизу - минимальным лотом и округлен до
	точности лота для данного инструмента.
	@param lot  Лот
	@return     Нормализованный лот.
	*/
	double normalize_volume(double volume)
	{
		volume = _math.round_err(volume, volume_step());

		double min_lot = volume_min();
		if (volume < min_lot)
			return(min_lot);

		double max_lot = volume_max();
		if (volume > max_lot)
			return(max_lot);

		return(volume);
	}

	// для удобства, чтобы не запоминать где какой тип валюты, только для форекс
	string currency1() { return(currency_base()); }
	string currency2() { return(currency_profit()); }


	// cached
	_BSL_SYMBOL_GET_CACHED(ENUM_SYMBOL_TRADE_EXECUTION, trade_exe_mode,       SYMBOL_TRADE_EXEMODE)
	_BSL_SYMBOL_SET_CACHED(ENUM_SYMBOL_TRADE_EXECUTION, trade_exe_mode,       SYMBOL_TRADE_EXEMODE)
	_BSL_SYMBOL_GET_CACHED(ENUM_DAY_OF_WEEK,            swap_rollover_3_days, SYMBOL_SWAP_ROLLOVER3DAYS)
	_BSL_SYMBOL_SET_CACHED(ENUM_DAY_OF_WEEK,            swap_rollover_3_days, SYMBOL_SWAP_ROLLOVER3DAYS)

	_BSL_SYMBOL_GET_CACHED(string,   currency_base,   SYMBOL_CURRENCY_BASE)   // = currency1 для forex
	_BSL_SYMBOL_SET_CACHED(string,   currency_base,   SYMBOL_CURRENCY_BASE)   // = currency1 для forex
	_BSL_SYMBOL_GET_CACHED(string,   currency_profit, SYMBOL_CURRENCY_PROFIT) // = currency2 для forex
	_BSL_SYMBOL_SET_CACHED(string,   currency_profit, SYMBOL_CURRENCY_PROFIT) // = currency2 для forex
	_BSL_SYMBOL_GET_CACHED(string,   currency_margin, SYMBOL_CURRENCY_MARGIN)
	_BSL_SYMBOL_SET_CACHED(string,   currency_margin, SYMBOL_CURRENCY_MARGIN)
	_BSL_SYMBOL_GET_CACHED(int,      digits,          SYMBOL_DIGITS)
	_BSL_SYMBOL_SET_CACHED(int,      digits,          SYMBOL_DIGITS)
	_BSL_SYMBOL_GET_CACHED(int,      expiration_mode, SYMBOL_EXPIRATION_MODE)
	_BSL_SYMBOL_SET_CACHED(int,      expiration_mode, SYMBOL_EXPIRATION_MODE)
	_BSL_SYMBOL_GET_CACHED(datetime, expiration_time, SYMBOL_EXPIRATION_TIME)
	_BSL_SYMBOL_SET_CACHED(datetime, expiration_time, SYMBOL_EXPIRATION_TIME)
	_BSL_SYMBOL_GET_CACHED(string,   path,            SYMBOL_PATH)            // r/o ?
	_BSL_SYMBOL_SET_CACHED(string,   path,            SYMBOL_PATH)            // r/o ?
	_BSL_SYMBOL_GET_CACHED(double,   point,           SYMBOL_POINT)
	_BSL_SYMBOL_SET_CACHED(double,   point,           SYMBOL_POINT)
	_BSL_SYMBOL_GET_CACHED(datetime, start_time,      SYMBOL_START_TIME)
	_BSL_SYMBOL_SET_CACHED(datetime, start_time,      SYMBOL_START_TIME)
	_BSL_SYMBOL_GET_CACHED(double,   volume_max,      SYMBOL_VOLUME_MAX)
	_BSL_SYMBOL_SET_CACHED(double,   volume_max,      SYMBOL_VOLUME_MAX)
	_BSL_SYMBOL_GET_STORED_DBL(volume_min,  SYMBOL_VOLUME_MIN)
	_BSL_SYMBOL_SET_STORED_DBL(volume_min,  SYMBOL_VOLUME_MIN)
	_BSL_SYMBOL_GET_STORED_DBL(volume_step, SYMBOL_VOLUME_STEP)
	_BSL_SYMBOL_SET_STORED_DBL(volume_step, SYMBOL_VOLUME_STEP)

	// direct
	_BSL_SYMBOL_GET(ENUM_SYMBOL_TRADE_MODE, trade_mode, SYMBOL_TRADE_MODE) // ~
	_BSL_SYMBOL_SET(ENUM_SYMBOL_TRADE_MODE, trade_mode, SYMBOL_TRADE_MODE) // ~
	_BSL_SYMBOL_GET(double,   ask,                        SYMBOL_ASK)                        // ~
	_BSL_SYMBOL_SET(double,   ask,                        SYMBOL_ASK)                        // ~
	_BSL_SYMBOL_GET(double,   ask_high,                   SYMBOL_ASKHIGH)                    // ~
	_BSL_SYMBOL_SET(double,   ask_high,                   SYMBOL_ASKHIGH)                    // ~
	_BSL_SYMBOL_GET(double,   ask_low,                    SYMBOL_ASKLOW)                     // ~
	_BSL_SYMBOL_SET(double,   ask_low,                    SYMBOL_ASKLOW)                     // ~
	_BSL_SYMBOL_GET(string,   bank,                       SYMBOL_BANK)                       // ~
	_BSL_SYMBOL_SET(string,   bank,                       SYMBOL_BANK)                       // ~
	_BSL_SYMBOL_GET(double,   bid,                        SYMBOL_BID)                        // ~
	_BSL_SYMBOL_SET(double,   bid,                        SYMBOL_BID)                        // ~
	_BSL_SYMBOL_GET(double,   bid_high,                   SYMBOL_BIDHIGH)                    // ~
	_BSL_SYMBOL_SET(double,   bid_high,                   SYMBOL_BIDHIGH)                    // ~
	_BSL_SYMBOL_GET(double,   bid_low,                    SYMBOL_BIDLOW)                     // ~
	_BSL_SYMBOL_SET(double,   bid_low,                    SYMBOL_BIDLOW)                     // ~
	_BSL_SYMBOL_GET(long,     deals,                      SYMBOL_SESSION_DEALS)              // ~
	_BSL_SYMBOL_SET(long,     deals,                      SYMBOL_SESSION_DEALS)              // ~
	_BSL_SYMBOL_GET(string,   description,                SYMBOL_DESCRIPTION)                // const?
	_BSL_SYMBOL_SET(string,   description,                SYMBOL_DESCRIPTION)                // const?
	_BSL_SYMBOL_GET(int,      filling_mode,               SYMBOL_FILLING_MODE)               // const? uint (see CTrade)?
	_BSL_SYMBOL_SET(int,      filling_mode,               SYMBOL_FILLING_MODE)               // const? uint (see CTrade)?
	_BSL_SYMBOL_GET(string,   isin,                       SYMBOL_ISIN)                       // const?
	_BSL_SYMBOL_SET(string,   isin,                       SYMBOL_ISIN)                       // const?
	_BSL_SYMBOL_GET(double,   last,                       SYMBOL_LAST)                       // ~
	_BSL_SYMBOL_SET(double,   last,                       SYMBOL_LAST)                       // ~
	_BSL_SYMBOL_GET(double,   last_high,                  SYMBOL_LASTHIGH)                   // ~
	_BSL_SYMBOL_SET(double,   last_high,                  SYMBOL_LASTHIGH)                   // ~
	_BSL_SYMBOL_GET(double,   last_low,                   SYMBOL_LASTLOW)                    // ~
	_BSL_SYMBOL_SET(double,   last_low,                   SYMBOL_LASTLOW)                    // ~
	_BSL_SYMBOL_GET(double,   margin_initial,             SYMBOL_MARGIN_INITIAL)             // ~
	_BSL_SYMBOL_SET(double,   margin_initial,             SYMBOL_MARGIN_INITIAL)             // ~
	_BSL_SYMBOL_GET(double,   margin_maintenance,         SYMBOL_MARGIN_MAINTENANCE)         // ~
	_BSL_SYMBOL_SET(double,   margin_maintenance,         SYMBOL_MARGIN_MAINTENANCE)         // ~
	_BSL_SYMBOL_GET(int,      order_mode,                 SYMBOL_ORDER_MODE)                 // const?
	_BSL_SYMBOL_SET(int,      order_mode,                 SYMBOL_ORDER_MODE)                 // const?
	_BSL_SYMBOL_GET(bool,     selected,                   SYMBOL_SELECT)                     // ~ переименовано, чтобы не конфликтовать с bool select(bool) выше
	_BSL_SYMBOL_SET(bool,     selected,                   SYMBOL_SELECT)                     // ~ r/o?
	_BSL_SYMBOL_GET(double,   session_aw,                 SYMBOL_SESSION_AW)                 // ~
	_BSL_SYMBOL_SET(double,   session_aw,                 SYMBOL_SESSION_AW)                 // ~
	_BSL_SYMBOL_GET(long,     session_buy_orders,         SYMBOL_SESSION_BUY_ORDERS)         // ~
	_BSL_SYMBOL_SET(long,     session_buy_orders,         SYMBOL_SESSION_BUY_ORDERS)         // ~
	_BSL_SYMBOL_GET(double,   session_buy_orders_volume,  SYMBOL_SESSION_BUY_ORDERS_VOLUME)  // ~
	_BSL_SYMBOL_SET(double,   session_buy_orders_volume,  SYMBOL_SESSION_BUY_ORDERS_VOLUME)  // ~
	_BSL_SYMBOL_GET(double,   session_close,              SYMBOL_SESSION_CLOSE)              // ~
	_BSL_SYMBOL_SET(double,   session_close,              SYMBOL_SESSION_CLOSE)              // ~
	_BSL_SYMBOL_GET(double,   session_interest,           SYMBOL_SESSION_INTEREST)           // ~
	_BSL_SYMBOL_SET(double,   session_interest,           SYMBOL_SESSION_INTEREST)           // ~
	_BSL_SYMBOL_GET(double,   session_open,               SYMBOL_SESSION_OPEN)               // ~
	_BSL_SYMBOL_SET(double,   session_open,               SYMBOL_SESSION_OPEN)               // ~
	_BSL_SYMBOL_GET(double,   session_price_limit_max,    SYMBOL_SESSION_PRICE_LIMIT_MAX)    // ~
	_BSL_SYMBOL_SET(double,   session_price_limit_max,    SYMBOL_SESSION_PRICE_LIMIT_MAX)    // ~
	_BSL_SYMBOL_GET(double,   session_price_limit_min,    SYMBOL_SESSION_PRICE_LIMIT_MIN)    // ~
	_BSL_SYMBOL_SET(double,   session_price_limit_min,    SYMBOL_SESSION_PRICE_LIMIT_MIN)    // ~
	_BSL_SYMBOL_GET(double,   session_price_settlement,   SYMBOL_SESSION_PRICE_SETTLEMENT)   // ~
	_BSL_SYMBOL_SET(double,   session_price_settlement,   SYMBOL_SESSION_PRICE_SETTLEMENT)   // ~
	_BSL_SYMBOL_GET(long,     session_sell_orders,        SYMBOL_SESSION_SELL_ORDERS)        // ~
	_BSL_SYMBOL_SET(long,     session_sell_orders,        SYMBOL_SESSION_SELL_ORDERS)        // ~
	_BSL_SYMBOL_GET(double,   session_sell_orders_volume, SYMBOL_SESSION_SELL_ORDERS_VOLUME) // ~
	_BSL_SYMBOL_SET(double,   session_sell_orders_volume, SYMBOL_SESSION_SELL_ORDERS_VOLUME) // ~
	_BSL_SYMBOL_GET(double,   session_turnover,           SYMBOL_SESSION_TURNOVER)           // ~
	_BSL_SYMBOL_SET(double,   session_turnover,           SYMBOL_SESSION_TURNOVER)           // ~
	_BSL_SYMBOL_GET(double,   session_volume,             SYMBOL_SESSION_VOLUME)             // ~
	_BSL_SYMBOL_SET(double,   session_volume,             SYMBOL_SESSION_VOLUME)             // ~
	_BSL_SYMBOL_GET(int,      spread,                     SYMBOL_SPREAD)                     // ~
	_BSL_SYMBOL_SET(int,      spread,                     SYMBOL_SPREAD)                     // ~
	_BSL_SYMBOL_GET(bool,     spread_float,               SYMBOL_SPREAD_FLOAT)               // const?
	_BSL_SYMBOL_SET(bool,     spread_float,               SYMBOL_SPREAD_FLOAT)               // const?
	_BSL_SYMBOL_GET(double,   swap_long,                  SYMBOL_SWAP_LONG)                  // ~
	_BSL_SYMBOL_SET(double,   swap_long,                  SYMBOL_SWAP_LONG)                  // ~
	_BSL_SYMBOL_GET(double,   swap_short,                 SYMBOL_SWAP_SHORT)                 // ~
	_BSL_SYMBOL_SET(double,   swap_short,                 SYMBOL_SWAP_SHORT)                 // ~
	_BSL_SYMBOL_GET(int,      ticks_book_depth,           SYMBOL_TICKS_BOOKDEPTH)            // const?
	_BSL_SYMBOL_SET(int,      ticks_book_depth,           SYMBOL_TICKS_BOOKDEPTH)            // const?
	_BSL_SYMBOL_GET(datetime, time,                       SYMBOL_TIME)                       // ~
	_BSL_SYMBOL_SET(datetime, time,                       SYMBOL_TIME)                       // ~
	_BSL_SYMBOL_GET(double,   trade_contract_size,        SYMBOL_TRADE_CONTRACT_SIZE)        // const?
	_BSL_SYMBOL_SET(double,   trade_contract_size,        SYMBOL_TRADE_CONTRACT_SIZE)        // const?
	_BSL_SYMBOL_GET(int,      trade_freeze_level,         SYMBOL_TRADE_FREEZE_LEVEL)
	_BSL_SYMBOL_SET(int,      trade_freeze_level,         SYMBOL_TRADE_FREEZE_LEVEL)
	_BSL_SYMBOL_GET(int,      trade_stops_level,          SYMBOL_TRADE_STOPS_LEVEL)
	_BSL_SYMBOL_SET(int,      trade_stops_level,          SYMBOL_TRADE_STOPS_LEVEL)
	_BSL_SYMBOL_GET(double,   trade_tick_value,           SYMBOL_TRADE_TICK_VALUE)
	_BSL_SYMBOL_SET(double,   trade_tick_value,           SYMBOL_TRADE_TICK_VALUE)
	_BSL_SYMBOL_GET(double,   trade_tick_value_profit,    SYMBOL_TRADE_TICK_VALUE_PROFIT)
	_BSL_SYMBOL_SET(double,   trade_tick_value_profit,    SYMBOL_TRADE_TICK_VALUE_PROFIT)
	_BSL_SYMBOL_GET(double,   trade_tick_value_loss,      SYMBOL_TRADE_TICK_VALUE_LOSS)
	_BSL_SYMBOL_SET(double,   trade_tick_value_loss,      SYMBOL_TRADE_TICK_VALUE_LOSS)
	_BSL_SYMBOL_GET(double,   trade_tick_size,            SYMBOL_TRADE_TICK_SIZE)
	_BSL_SYMBOL_SET(double,   trade_tick_size,            SYMBOL_TRADE_TICK_SIZE)
	_BSL_SYMBOL_GET(long,     volume,                     SYMBOL_VOLUME)                     // ~
	_BSL_SYMBOL_SET(long,     volume,                     SYMBOL_VOLUME)                     // ~
	_BSL_SYMBOL_GET(long,     volume_high,                SYMBOL_VOLUMEHIGH)                 // ~
	_BSL_SYMBOL_SET(long,     volume_high,                SYMBOL_VOLUMEHIGH)                 // ~
	_BSL_SYMBOL_GET(double,   volume_limit,               SYMBOL_VOLUME_LIMIT)               // const?
	_BSL_SYMBOL_SET(double,   volume_limit,               SYMBOL_VOLUME_LIMIT)               // const?
	_BSL_SYMBOL_GET(long,     volume_low,                 SYMBOL_VOLUMELOW)                  // ~
	_BSL_SYMBOL_SET(long,     volume_low,                 SYMBOL_VOLUMELOW)                  // ~

	/*
	Splits symbol to parts.
	Examples: EURUSD->EUR/USD, XAUUSD->XAU/USD, XAUEUR->XAU/EUR, GOLD->GOLD/USD, SP500->SP500/USD, DAX30->DAX30/EUR.
	Returns false if symbol does not exist.
	*/
	bool split(string &part_base, string &part_profit)
	{
		if (!exists())
			return(false);


		part_profit = currency_profit();

		if (is_forex())
			part_base = currency_base();
		else if (_str.ends_with(name_, part_profit))
			part_base = _str.cut_end(name_, StringLen(part_profit));
		else
			part_base = name_;

		return(true);
	}

	/* Зависимые от версии MQL */

	bool is_forex()
	{
		// Может вернуть true для несуществующего символа.
#ifdef __MQL4__
		return(trade_calc_mode() == 0);
#else
		const ENUM_SYMBOL_CALC_MODE calc_mode = trade_calc_mode();
		return((calc_mode == SYMBOL_CALC_MODE_FOREX) || (calc_mode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE));
#endif
	}


#ifdef __MQL4__

	_BSL_SYMBOL_GET_CACHED(int, trade_calc_mode, SYMBOL_TRADE_CALC_MODE) // 0 - Forex; 1 - CFD; 2 - Futures; 3 - CFD на индексы (см. MODE_MARGINCALCMODE)

#else

	bool margin_rate(
		ENUM_ORDER_TYPE  order_type,               // тип ордера
		double          &initial_margin_rate,      // коэффициент взимания начальной маржи
		double          &maintenance_margin_rate   // коэффициент взимания поддерживающей маржи
		)
	{
		return(::SymbolInfoMarginRate(name_, order_type, initial_margin_rate, maintenance_margin_rate));
	}

	bool create()            { return(::CustomSymbolCreate(name_)); }
	bool create(string path) { return(::CustomSymbolCreate(name_, path)); }

	// 5.2007
	bool create(string path, string origin)
	{
		// т.к. многие свойства будут скопированы из другого символа, то на всякий случай лучше очистить кэш
		clear_cache();
		return(::CustomSymbolCreate(name_, path, origin));
	}

	bool del() { return(::CustomSymbolDelete(name_)); }

	// Устанавливает для пользовательского символа коэффициенты взимания маржи в зависимости от типа и направления ордера.
	bool set_margin_rate(
		ENUM_ORDER_TYPE    order_type,              // тип ордера
		double             initial_margin_rate,     // коэффициент взимания начальной маржи
		double             maintenance_margin_rate  // коэффициент взимания поддерживающей маржи
		)
	{
		return(::CustomSymbolSetMarginRate(name_, order_type, initial_margin_rate, maintenance_margin_rate));
	}

	// Устанавливает время начала и время окончания указанной котировочной сессии для указанных символа и дня недели.
	bool set_session_quote(
		ENUM_DAY_OF_WEEK  day_of_week,         // день недели
		uint              session_index,       // номер сессии
		datetime          from,                // время начала сессии
		datetime          to                   // время окончания сессии
		)
	{
		return(::CustomSymbolSetSessionQuote(name_, day_of_week, session_index, from, to));
	}

	// Устанавливает время начала и время окончания указанной торговой сессии для указанных символа и дня недели.
	bool set_session_trade(
		ENUM_DAY_OF_WEEK  day_of_week,   // день недели
		uint              session_index, // номер сессии
		datetime          from,          // время начала сессии
		datetime          to             // время окончания сессии
		)
	{
		return(::CustomSymbolSetSessionTrade(name_, day_of_week, session_index, from, to));
	}

	// Удаляет все бары в указанном временном интервале из ценовой истории пользовательского инструмента.
	// returns: Количество удаленных баров либо -1 в случае ошибки.
	int rates_delete(
		datetime         from,     // с какой даты
		datetime         to        // по какую дату
		)
	{
		return(::CustomRatesDelete(name_, from, to));
	}

	// Полностью заменяет ценовую историю пользовательского инструмента в указанном временном интервале данными из массива типа MqlRates.
	int rates_replace(
		datetime         from,     // с какой даты
		datetime         to,       // по какую дату
		const MqlRates  &rates[]   // массив с данными, которые необходимо применить к пользовательскому инструменту
		)
	{
		return(::CustomRatesReplace(name_, from, to, rates));
	}

	// Добавляет в историю пользовательского инструмента отсутствующие бары и заменяет существующие данными из массива типа MqlRates.
	int rates_update(
		const MqlRates  &rates[]   // массив с данными, которые необходимо применить к пользовательскому инструменту
		)
	{
		return(::CustomRatesUpdate(name_, rates));
	}

	// Добавляет в ценовую историю пользовательского инструмента данные из массива типа MqlTick.
	// Пользовательский символ должен быть выбран в окне MarketWatch (Обзор рынка).
	int ticks_add(
		const MqlTick   &ticks[]   // массив с тиковыми данными, которые необходимо применить к пользовательскому инструменту
		)
	{
		return(::CustomTicksAdd(name_, ticks));
	}

	// Удалаляет все тики в указанном временном интервале из ценовой истории пользовательского инструмента.
	int ticks_delete(
		long             from_msc,  // с какой даты
		long             to_msc     // по какую дату
		)
	{
		return(::CustomTicksDelete(name_, from_msc, to_msc));
	}

	// Полностью заменяет ценовую историю пользовательского инструмента в указанном временном интервале данными из массива типа MqlTick.
	// returns Количество обновленных тиков либо -1 в случае ошибки.
	int ticks_replace(
		long             from_msc,  // с какой даты
		long             to_msc,    // по какую дату
		const MqlTick   &ticks[]    // массив с тиковыми данными, которые необходимо применить к пользовательскому инструменту
		)
	{
		return(::CustomTicksReplace(name_, from_msc, to_msc, ticks));
	}

	// Свойства
	_BSL_SYMBOL_GET_CACHED(ENUM_SYMBOL_CALC_MODE, trade_calc_mode, SYMBOL_TRADE_CALC_MODE) // в 4 другой результат
	_BSL_SYMBOL_SET_CACHED(ENUM_SYMBOL_CALC_MODE, trade_calc_mode, SYMBOL_TRADE_CALC_MODE) // в 4 другой результат
	_BSL_SYMBOL_GET(ENUM_SYMBOL_OPTION_MODE,  option_mode,     SYMBOL_OPTION_MODE)
	_BSL_SYMBOL_SET(ENUM_SYMBOL_OPTION_MODE,  option_mode,     SYMBOL_OPTION_MODE)
	_BSL_SYMBOL_GET(ENUM_SYMBOL_OPTION_RIGHT, option_right,    SYMBOL_OPTION_RIGHT)
	_BSL_SYMBOL_SET(ENUM_SYMBOL_OPTION_RIGHT, option_right,    SYMBOL_OPTION_RIGHT)
	_BSL_SYMBOL_GET(ENUM_SYMBOL_SWAP_MODE,    swap_mode,       SYMBOL_SWAP_MODE)
	_BSL_SYMBOL_SET(ENUM_SYMBOL_SWAP_MODE,    swap_mode,       SYMBOL_SWAP_MODE)

	_BSL_SYMBOL_GET(string, basis,                 SYMBOL_BASIS)
	_BSL_SYMBOL_SET(string, basis,                 SYMBOL_BASIS)
	_BSL_SYMBOL_GET(double, option_strike,         SYMBOL_OPTION_STRIKE)
	_BSL_SYMBOL_SET(double, option_strike,         SYMBOL_OPTION_STRIKE)
	_BSL_SYMBOL_GET(double, session_margin_hedged, SYMBOL_MARGIN_HEDGED)
	_BSL_SYMBOL_SET(double, session_margin_hedged, SYMBOL_MARGIN_HEDGED)

	// 5.?
	_BSL_SYMBOL_GET(ENUM_SYMBOL_CHART_MODE,     chart_mode,     SYMBOL_CHART_MODE)
	_BSL_SYMBOL_SET(ENUM_SYMBOL_CHART_MODE,     chart_mode,     SYMBOL_CHART_MODE)
	_BSL_SYMBOL_GET(ENUM_SYMBOL_ORDER_GTC_MODE, order_gtc_mode, SYMBOL_ORDER_GTC_MODE)
	_BSL_SYMBOL_SET(ENUM_SYMBOL_ORDER_GTC_MODE, order_gtc_mode, SYMBOL_ORDER_GTC_MODE)

	_BSL_SYMBOL_GET(bool,   margin_hedged_use_leg,  SYMBOL_MARGIN_HEDGED_USE_LEG)
	_BSL_SYMBOL_SET(bool,   margin_hedged_use_leg,  SYMBOL_MARGIN_HEDGED_USE_LEG)
	_BSL_SYMBOL_GET(double, trade_accrued_interest, SYMBOL_TRADE_ACCRUED_INTEREST)
	_BSL_SYMBOL_SET(double, trade_accrued_interest, SYMBOL_TRADE_ACCRUED_INTEREST)
	_BSL_SYMBOL_GET(double, trade_face_value,       SYMBOL_TRADE_FACE_VALUE)
	_BSL_SYMBOL_SET(double, trade_face_value,       SYMBOL_TRADE_FACE_VALUE)
	_BSL_SYMBOL_GET(double, trade_liquidity_rate,   SYMBOL_TRADE_LIQUIDITY_RATE)
	_BSL_SYMBOL_SET(double, trade_liquidity_rate,   SYMBOL_TRADE_LIQUIDITY_RATE)


	// 5.1640+
	_BSL_SYMBOL_GET_CACHED(bool, custom, SYMBOL_CUSTOM) // r/o?
	_BSL_SYMBOL_SET_CACHED(bool, custom, SYMBOL_CUSTOM) // r/o?

	// 5.1730, 4?
	_BSL_SYMBOL_GET(string, formula, SYMBOL_FORMULA)
	_BSL_SYMBOL_SET(string, formula, SYMBOL_FORMULA)
	_BSL_SYMBOL_GET(string, page,    SYMBOL_PAGE)
	_BSL_SYMBOL_SET(string, page,    SYMBOL_PAGE)
	_BSL_SYMBOL_GET(bool,   visible, SYMBOL_VISIBLE) // r/o?
	_BSL_SYMBOL_SET(bool,   visible, SYMBOL_VISIBLE) // r/o?

	// 5.1730?
	_BSL_SYMBOL_GET(color,  background_color, SYMBOL_BACKGROUND_COLOR)
	_BSL_SYMBOL_SET(color,  background_color, SYMBOL_BACKGROUND_COLOR)

	// 5.1930
	_BSL_SYMBOL_GET(double, volume_real,     SYMBOL_VOLUME_REAL)
	_BSL_SYMBOL_SET(double, volume_real,     SYMBOL_VOLUME_REAL)
	_BSL_SYMBOL_GET(double, volumehigh_real, SYMBOL_VOLUMEHIGH_REAL)
	_BSL_SYMBOL_SET(double, volumehigh_real, SYMBOL_VOLUMEHIGH_REAL)
	_BSL_SYMBOL_GET(double, volumelow_real,  SYMBOL_VOLUMELOW_REAL)
	_BSL_SYMBOL_SET(double, volumelow_real,  SYMBOL_VOLUMELOW_REAL)

	// 5.2007
	_BSL_SYMBOL_GET(bool, exist, SYMBOL_EXIST) // r/o?
	//_BSL_SYMBOL_SET(bool, exist, SYMBOL_EXIST)

	// 5.2170
	_BSL_SYMBOL_GET(string, category, SYMBOL_CATEGORY)
	_BSL_SYMBOL_SET(string, category, SYMBOL_CATEGORY)
	_BSL_SYMBOL_GET(string, exchange, SYMBOL_EXCHANGE)
	_BSL_SYMBOL_SET(string, exchange, SYMBOL_EXCHANGE)

#endif

	// Универсальные функции доступа к свойствам.
	// value не меняет значение в случае неуспеха

	bool get(ENUM_SYMBOL_INFO_DOUBLE property_id, double &value) const
	{
		double res;

		if (!::SymbolInfoDouble(name_, property_id, res))
			return(false);

		value = res;
		return(true);
	}

	bool get(ENUM_SYMBOL_INFO_INTEGER property_id, long &value) const
	{
		long res;

		if (!::SymbolInfoInteger(name_, property_id, res))
			return(false);

		value = res;
		return(true);
	}

	bool get(ENUM_SYMBOL_INFO_STRING property_id, string &value) const
	{
		string res;

		if (!::SymbolInfoString(name_, property_id, res))
			return(false);

		value = res;
		return(true);
	}


protected:

	// Универсальные функции доступа к свойствам

	double get(ENUM_SYMBOL_INFO_DOUBLE  property_id) const { return(::SymbolInfoDouble (name_, property_id)); }
	long   get(ENUM_SYMBOL_INFO_INTEGER property_id) const { return(::SymbolInfoInteger(name_, property_id)); }
	string get(ENUM_SYMBOL_INFO_STRING  property_id) const { return(::SymbolInfoString (name_, property_id)); }

	// double
	bool get_cached_double(ENUM_SYMBOL_INFO_DOUBLE property_id, double &value)
	{
		// Найти в кэше
		if (cache_double_.try_get_value(property_id, value))
			return(true);

		// Получить значение
		if (!::SymbolInfoDouble(name_, property_id, value))
			return(false);

		// В случае успеха записать значение в кэш
		cache_double_.set(property_id, value);
		return(true);
	}

	double get_cached(ENUM_SYMBOL_INFO_DOUBLE property_id)
	{
		// Для совместимости в случае неудачи вернуть результат с прямым результатом
		double value;
		return(get_cached_double(property_id, value) ? value : ::SymbolInfoDouble(name_, property_id));
	}

	// integer
	bool get_cached_long(ENUM_SYMBOL_INFO_INTEGER property_id, long &value)
	{
		// Найти в кэше
		if (cache_long_.try_get_value(property_id, value))
			return(true);

		// Получить значение
		if (!::SymbolInfoInteger(name_, property_id, value))
			return(false);

		// В случае успеха записать значение в кэш
		cache_long_.set(property_id, value);
		return(true);
	}

	long get_cached(ENUM_SYMBOL_INFO_INTEGER property_id)
	{
		// Для совместимости в случае неудачи вернуть результат с прямым результатом
		long value;
		return(get_cached_long(property_id, value) ? value : ::SymbolInfoInteger(name_, property_id));
	}

	// string
	bool get_cached_string(ENUM_SYMBOL_INFO_STRING property_id, string &value)
	{
		// Найти в кэше
		if (cache_string_.try_get_value(property_id, value))
			return(true);

		// Получить значение
		if (!::SymbolInfoString(name_, property_id, value))
			return(false);

		// В случае успеха записать значение в кэш
		cache_string_.set(property_id, value);
		return(true);
	}

	string get_cached(ENUM_SYMBOL_INFO_STRING property_id)
	{
		// Для совместимости в случае неудачи вернуть результат с прямым результатом
		string value;
		return(get_cached_string(property_id, value) ? value : ::SymbolInfoString(name_, property_id));
	}

	void clear_cache()
	{
		volume_step_ = _double.empty_value;
		volume_min_ = _double.empty_value;
		cache_double_.clear();
		cache_long_.clear();
		cache_string_.clear();
	}

	// Универсальные функции установки свойств

#ifndef __MQL4__

	CBSymbol *set(ENUM_SYMBOL_INFO_DOUBLE  property_id, double value) { ::CustomSymbolSetDouble (name(), property_id, value); return(&this); }
	CBSymbol *set(ENUM_SYMBOL_INFO_INTEGER property_id, long   value) { ::CustomSymbolSetInteger(name(), property_id, value); return(&this); }
	CBSymbol *set(ENUM_SYMBOL_INFO_STRING  property_id, string value) { ::CustomSymbolSetString (name(), property_id, value); return(&this); }

	CBSymbol *set_cached(ENUM_SYMBOL_INFO_DOUBLE  property_id, double value) { cache_double_.set(property_id, value); return(set(property_id, value)); }
	CBSymbol *set_cached(ENUM_SYMBOL_INFO_INTEGER property_id, long   value) { cache_long_.set  (property_id, value); return(set(property_id, value)); }
	CBSymbol *set_cached(ENUM_SYMBOL_INFO_STRING  property_id, string value) { cache_string_.set(property_id, value); return(set(property_id, value)); }

#endif

} _symbol;
