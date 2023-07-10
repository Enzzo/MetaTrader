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

// VP indicator. © FXcoder


#property strict

#include "../bsl.mqh"
#include "../s.mqh"

#include "../enum/hg_coloring.mqh"
#include "../enum/quantile.mqh"
#include "../class/timer.mqh"
#include "../util/stat.mqh"

#include "enum/vp_bar_ticks.mqh"
#include "enum/vp_mode.mqh"
#include "vp_histogram.mqh"
#include "vp_visual.mqh"
#include "vp_calc.mqh"

#include "vp_period_mode_params.mqh"
#include "vp_range_mode_params.mqh"
#include "vp_data_params.mqh"
#include "vp_tick_params.mqh"
#include "vp_calc_params.mqh"
#include "vp_hg_params.mqh"
#include "vp_levels_params.mqh"
#include "vp_service_params.mqh"


class CVPIndicator: CBUncopyable
{
protected:

	// input parameters
	const ENUM_VP_MODE         mode_;
	const CVPPeriodModeParams  params_period_;
	const CVPRangeModeParams   params_range_;
	const CVPDataParams        params_data_;
	const CVPTickParams        params_tick_;
	const CVPCalcParams        params_calc_;
	const CVPHgParams          params_hg_;
	const CVPLevelsParams      params_lvl_;
	const CVPServiceParams     params_service_;

	// common
	bool   is_range_mode_;
	ENUM_TIMEFRAMES data_period_;
	string hz_line_name_;
	string prefix_;
	bool   last_ok_;
	int    mode_step_;
	double hg_width_fraction_;

	int     mql_timer_ms_;
	int     update_timer_ms_;
	CTimer  update_timer_;

	// working time limits (period mode only)
	const int    calc_time_limit_ms_;   // calculation time limit, ms
	const int    draw_time_limit_ms_;   // drawing time limit, ms
	bool  wait_for_history_;
	int   wait_for_history_factor_;

	// guaranteed time gap between work, ms
	const int time_gap_ms_;
	long prev_work_end_time_ms_;

	CVPVisual *vpvis_;
	CVPCalc   *vpcalc_;

	// period mode
	int      tz_shift_seconds_;
	int      range_count_;
	datetime draw_history_[];
	double   global_max_volume_;

	CBDict<datetime, int> load_counts_; // load attempt counts
	int      load_stop_threshold_;       // load attempt theshold

	// range mode
	bool update_on_tick_;


public:

	void CVPIndicator(
		ENUM_VP_MODE              mode,
		const CVPPeriodModeParams &params_period,
		const CVPRangeModeParams  &params_range,
		const CVPDataParams       &params_data,
		const CVPTickParams       &params_tick,
		const CVPCalcParams       &params_calc,
		const CVPHgParams         &params_hg,
		const CVPLevelsParams     &params_lvl,
		const CVPServiceParams    &params_service
	):
		mode_(mode),
		params_period_(params_period),
		params_range_(params_range),
		params_data_(params_data),
		params_tick_(params_tick),
		params_calc_(params_calc),
		params_hg_(params_hg),
		params_lvl_(params_lvl),
		params_service_(params_service),
		calc_time_limit_ms_(400),
		draw_time_limit_ms_(600),
		time_gap_ms_(500)
	{
		// aliases
		const string id = params_service_.id;
		const ENUM_TIMEFRAMES range_period = params_period_.tf;
		const int range_count = params_period_.count;
		const ENUM_VP_RANGE_SEL range_selection = params_range_.selection;
		const ENUM_VP_SOURCE data_source = params_data_.source;
		const int mode_step = params_calc_.mode_step;
		const ENUM_POINT_SCALE hg_point_scale = params_calc_.hg_point_scale;
		const uint hg_width_pct = params_hg_.width_pct;
		const ENUM_VP_TICK_PRICE tick_price_type = params_tick_.price_type;
		const ENUM_QUANTILE quantiles = params_lvl_.quantiles;

		// common

		is_range_mode_        = mode == VP_MODE_RANGE;
		data_period_          = PERIOD_M1;
		hz_line_name_         = id + "-" + string((int(data_source))) + "-hz";
		prefix_               = id + (is_range_mode_ ? (" rng:" + EnumVPRangeModeToString(range_selection)) : (" per:" + _tf.to_string(range_period))) + " ";
		last_ok_              = false;
		mode_step_            = mode_step / hg_point_scale;
		hg_width_fraction_    = 0.01 * hg_width_pct;

		mql_timer_ms_         = 111; // built-in timer period (OnTimer), ms
		update_timer_ms_      = is_range_mode_ ? 500 : 1000; // период для таймера обновления (проверяется при любом событии), мс
		update_timer_.set(update_timer_ms_, false);

		wait_for_history_     = false; // признак того, что при прошлая загрузка истории не удалась, и надо подождать подольше
		wait_for_history_factor_ = 3;  // коэффициет замедления повторной загрузки истории после неудачи

		vpvis_ = new CVPVisual(id, params_hg_, params_lvl_);
		vpcalc_ = new CVPCalc(params_data_, _Point * hg_point_scale, tick_price_type, params_tick_.flags, quantiles);

		// period mode

		tz_shift_seconds_  = 0;
		range_count_       = range_count > 0 ? range_count : 1;
		global_max_volume_ = 0; // global max volume
		load_stop_threshold_ = 10; // number of attempts before stopping of loading

		// range mode

		update_on_tick_ = true;
	}

	void ~CVPIndicator()
	{
		_ptr.safe_delete(vpvis_);
		_ptr.safe_delete(vpcalc_);
	}


	void init()
	{
		// source's period
		data_period_ = get_data_source_tf(params_data_.source);

		/* Period mode */

		// shift cannot be more than RangePeriod
		tz_shift_seconds_ = (((int)params_period_.time_shift * 60) % PeriodSeconds(params_period_.tf));

		// vp#26, mki#29
		// delete range line/s after switching to period mode
		if (!is_range_mode_)
			vpvis_.delete_range_lines();
	}

	void chart_event()
	{
		if (is_range_mode_)
		{
			// If range lines moved, update histogram
			if (_chartevent.is_object_move_event(vpvis_.line_from().name()) || _chartevent.is_object_move_event(vpvis_.line_to().name()))
			{
		 		check_timer();
			}

			// Chart changes (scale, position, back color)
			if (_chartevent.is_chart_change_event())
			{
				static int first_visible_bar_prev = 0;
				static int last_visible_bar_prev = 0;

				const int first_visible_bar = _chart.first_visible_bar();
				const int last_visible_bar = _chart.last_visible_bar();

				bool update =
					(first_visible_bar_prev == last_visible_bar_prev) ||
					(
						((first_visible_bar != first_visible_bar_prev) || (last_visible_bar != last_visible_bar_prev)) &&
						((params_range_.hg_position == VP_HG_POSITION_CHART_LEFT) || (params_range_.hg_position == VP_HG_POSITION_CHART_RIGHT))
					);

				first_visible_bar_prev = first_visible_bar;
				last_visible_bar_prev = last_visible_bar;

				if (vpvis_.update_auto_colors())
				{
					last_ok_ = false;
					check_timer();
				}
				else if (update)
				{
					check_timer();
				}
			}
		}
		else
		{
			if (_chartevent.is_chart_change_event())
			{
				// If chart's back color changed, redraw all histograms
				if (vpvis_.update_auto_colors())
				{
					ArrayFree(draw_history_);
					check_timer();
				}
			}
		}
	}

	int calculate(const int rates_total, const int prev_calculated)
	{
		if (prev_calculated == 0)
			last_ok_ = false;

		if (is_range_mode_)
		{
			if (vpvis_.update_auto_colors())
			{
				// при обновлении цвета фона обновлять сразу, сбросив признак последнего успешного выполнения
				last_ok_ = false;
				check_timer();
			}
			else if (update_on_tick_)
			{
				// обновлять на каждом тике, если выставлен такой признак при анализе правой границы
				check_timer();
			}
			else if (!last_ok_)
			{
				check_timer();
			}
		}
		else
		{
			// если цвет фона изменился, перерисовать все гистограммы
			if (vpvis_.update_auto_colors())
				_arr.clear(draw_history_);

			// если подгрузилась история, перерисовать все гистограммы
			if (prev_calculated == 0)
				_arr.clear(draw_history_);

			check_timer();
		}

		return(rates_total);
	}

	void timer()
	{
		check_timer();
	}

	void deinit(const int reason)
	{
		// удалить гистограммы и их производные
		_chart.objects_delete_all(prefix_);
		_go[hz_line_name_].del();

		if (is_range_mode_)
		{
			// удалить линии только при явном удалении индикатора с графика
			if (reason == REASON_REMOVE)
				vpvis_.delete_range_lines();
		}
	}


protected:

	/**
	Проверить таймер. Если сработал, обновить индикатор.
	*/
	void check_timer()
	{
		// отложить проверку, если таймер проверяется слишком рано после последней работы
		if (_time.tick_count_long() - prev_work_end_time_ms_ < time_gap_ms_)
		{
			_event.reset_millisecond_timer(mql_timer_ms_);
			return;
		}

		// Выключить резервный таймер
		_event.kill_timer();

		// Если таймер сработал, нарисовать картинку
		if (update_timer_.check())
		{
			// Обновить. В случае неудачи поставить таймер на 3 секунды, чтобы попробовать снова ещё раз.
			// 1 секунды должно быть достаточно для подгрузки последней истории. Иначе всё просто повторится ещё через 1.
			last_ok_ = is_range_mode_ ? update_range() : update();

			int timer_factor = wait_for_history_ ? wait_for_history_factor_ : 1;

			if (!last_ok_)
				_event.reset_millisecond_timer(mql_timer_ms_ * timer_factor);

			_chart.redraw();

			// расчёт и рисование могут быть длительными, лучше перезапустить таймер
			update_timer_.reset(update_timer_ms_ * timer_factor);
		}
		else
		{
			// На случай, если свой таймер больше не будет проверяться, добавить принудительную проверку через 2-4 секунды
			int timer_factor = wait_for_history_ ? wait_for_history_factor_ : 1;
			_event.reset_millisecond_timer(update_timer_ms_ * timer_factor);
		}
	}

	// Получить список диапазонов, отсчёт справа налево, [start;end].
	// -1 в случае ошибки
	int get_period_mode_ranges(int count, datetime last_tick_time, datetime &starts[], datetime &ends[])
	{
		// const
		const ENUM_TIMEFRAMES range_tf = params_period_.tf;
		const datetime last_start_time = _time.begin_of_period(last_tick_time, range_tf);
		const datetime first_time = _series.first_date();
		CHECK_RETURN(first_time > 0, -1);

		// Найти самый правый диапазон, для этого сначала установить значение на предполагаемый первый правый диапазон
		//   со сдвигом, после чего возвращаться назад, пока время не окажется внутри истории.
		datetime start_time = _time.add_periods(last_start_time, 1, range_tf) + tz_shift_seconds_;
		_arr.resize(starts, 0, count);
		_arr.resize(ends, 0, count);
		int real_count = 0;

		while ((real_count < count) && (start_time >= first_time))
		{
			const datetime end_time = start_time + PeriodSeconds(range_tf) - 1;

			// Посчитать число баров между началом и концом. Добавить в список, если есть бары.
			if (_series.bars(start_time, end_time) > 0)
			{
				// скорректировать по реальным барам
				_arr.add(starts, _series.time_to_open_right(start_time));
				_arr.add(ends, _series.time_to_open_right(end_time) - 1);
				real_count++;
			}

			const datetime prev_start_time = start_time;
			start_time = _time.begin_of_period(start_time, range_tf) + tz_shift_seconds_;

			if (start_time == prev_start_time)
				start_time = _time.add_periods(_time.begin_of_period(start_time, range_tf), -1, range_tf) + tz_shift_seconds_;

			ASSERT_MSG_RETURN(start_time != 0, VAR(start_time) + VAR(first_time), -1);
			ASSERT_MSG_RETURN(start_time != prev_start_time, VAR(start_time) + VAR(first_time), -1);
		}

		return(real_count);
	}

	string get_period_mode_hg_prefix(datetime range_start)
	{
		return(prefix_ + _time.to_string_format(range_start, "yyMMdd.HHmm") + " ");
	}

	/**
	Update (period mode).
	@return  false on fail.
	*/
	bool update()
	{
		wait_for_history_ = false;

		// Все проверки достаточно быстрые, поэтому можно на случай их провала заранее
		//   выставить время окончания последней работы.
		prev_work_end_time_ms_ = _time.tick_count_long();

		// время последнего тика
		datetime last_tick_time;
		{
			MqlTick tick;
			if (!_symbol.tick(tick))
				return(false);

			last_tick_time = tick.time;
		}

		// Составить список диапазонов
		datetime ranges_starts[];
		datetime ranges_ends[];
		int real_range_count;
		{
			real_range_count = get_period_mode_ranges(range_count_, last_tick_time, ranges_starts, ranges_ends);

			// полное отсутствие диапазонов считать ошибкой
			if (real_range_count <= 0)
			{
				PRINT("real_range_count < 0");
				delete_hg_unlisted(ranges_starts);
				return(false);
			}

			// If Zoom=Automatic Zoom (local), limit rightmost histogram to the zero bar
			if (params_period_.zoom_type == VP_ZOOM_AUTO_LOCAL)
			{
				if (ranges_ends[0] > last_tick_time)
					ranges_ends[0] = last_tick_time;
			}

			// Проверить наличие необходимых котировок
			{
				datetime data_rates[];
				const datetime ranges_start = ranges_starts[real_range_count - 1];
				const datetime ranges_end = ranges_ends[0];

				if (CopyTime(_Symbol, data_period_, ranges_start, ranges_end, data_rates) <= 0)
				{
					LOG("!CopyTime: " + VAR(ranges_start) + VAR(ranges_end));
					wait_for_history_ = true;
					delete_hg_unlisted(ranges_starts);
					return(false);
				}
			}
		}

		// Show data horizon - the oldest available data
		const datetime horizon = vpcalc_.get_horizon();
		if (params_service_.show_horizon)
			vpvis_.draw_horizon(hz_line_name_, horizon);

		// Calculate histograms
		bool total_result = true;
		CVPHistogram *hgs[];
		{
			ArrayResize(hgs, real_range_count);

			// предварительная инициализация на случай прерывания расчётов
			for (int i = 0; i < real_range_count; i++)
			{
				hgs[i] = new CVPHistogram();
				hgs[i].point = _Point * params_calc_.hg_point_scale;
			}

			CTimer calc_timer(calc_time_limit_ms_);

			for (int i = 0; i < real_range_count; i++)
			{
				CVPHistogram *hg = hgs[i];

				const datetime range_start = ranges_starts[i];
				const datetime range_end = ranges_ends[i];

				// Check range
				{
					// do not request inaccessible data
					if (range_end < horizon)
						continue;

					// если гистограмма уже была успешно нарисована, пропустить. Кроме крайней правой.
					if ((i > 0) && (_arr.contains(draw_history_, range_start)))
						continue;

					// если гистограмма превысила порог попыток загрузки, пропустить. Кроме крайней правой.
					if ((i > 0) && (load_counts_.get(range_start, 0) >= load_stop_threshold_))
						continue;

					if (!time_range_to_bars(range_start, range_end, hg.bar_from, hg.bar_to))
					{
						LOG("!vpvis_.time_range_to_bars: " + VAR(range_start) + VAR(range_end) + VAR(hg.bar_from) + VAR(hg.bar_to));
						// в случае ошибки загрузки истории прерваться
						total_result = false;
						wait_for_history_ = true;
						break;
					}
				}

				// префикс для каждой гистограммы свой
				hg.prefix = get_period_mode_hg_prefix(range_start);

				// Расчёт

#ifdef __MQL4__
				const int count = vpcalc_.get_hg(range_start, range_end, hg.low_price, hg.volumes);
#else
				const int count = (params_data_.source == VP_SOURCE_TICKS)
					? vpcalc_.get_hg_by_ticks   (range_start, range_end, hg.low_price, hg.volumes)
					: vpcalc_.get_hg            (range_start, range_end, hg.low_price, hg.volumes);
#endif

				if (count < 0)
				{
					LOG("get_hg / get_hg_by_ticks < 0: " + VAR(range_start) + VAR(range_end));
					// в случае ошибки загрузки истории прерваться
					total_result = false;
					wait_for_history_ = true;
					break;
				}
				else if (count == 0)
				{
					int load_count = load_counts_.get(range_start, 0);

					if (load_count < load_stop_threshold_)
					{
						load_counts_.set(range_start, ++load_count);

						if (load_count == load_stop_threshold_)
							PRINT("BLACKLISTED: " + VAR(range_start) + VAR(range_end));
					}

					continue;
				}

				// Сглаживание
				if (params_calc_.smooth > 0)
					vpcalc_.smooth_hg(params_calc_.smooth, hg);

				// Параметры отображения
				{
					hg.need_redraw = true;

					// учесть нулевые объёмы всех баров источника
					hg.max_volume = _math.limit_below(_math.max(hg.volumes), 1.0);
				}

				if ((params_period_.zoom_type == VP_ZOOM_AUTO_GLOBAL) && (hg.max_volume > global_max_volume_))
					global_max_volume_ = hg.max_volume;

				if (calc_timer.check())
				{
					PRINT("Stopped calculation hg #" + string(i + 1) + " of " + string(real_range_count));
					total_result = false;
					break;
				}
			}
		}

		// Отображение. Отдельно от расчётов, т.к. может быть нужно значение максимального максимума (global_max_volume_)
		{
			// Удаление поближе к рисованию, чтобы уменьшить вероятность мерцания
			delete_hg_unlisted(ranges_starts);

			CTimer draw_timer(draw_time_limit_ms_);

			for (int i = 0; i < real_range_count; i++)
			{
				CVPHistogram *hg = hgs[i];
				if (!hg.need_redraw)
					continue;

				// always delete the last hg
				if (i == 0)
					delete_hg(hg.prefix);

				const datetime range_start = ranges_starts[i];
				const datetime range_end = ranges_ends[i];

				if (load_counts_.get(range_start, 0) >= load_stop_threshold_)
				{
					delete_hg(hg.prefix);
					continue;
				}

				// Levels
				hg.mode_count  = vpvis_.show_modes()  ? hg_modes(hg.volumes, mode_step_, hg.modes)  : -1;
				hg.max_pos     = vpvis_.show_max()    ? _arr.max_index(hg.volumes)               : -1;
				hg.vwap_pos    = vpvis_.show_vwap()   ? hg_vwap_index(hg.volumes, hg.low_price, hg.point) : -1;
				vpcalc_.quantiles_indexes(hg.volumes, hg.quantiles);

				// Position and zoom
				double zoom = params_period_.zoom_custom;
				{
					// hg position (period mode)
					{
						const int width = hg.bar_from - hg.bar_to;
						const int half_width = width / 2;
						//const int center = hg.bar_from + half_width;

						switch (params_period_.hg_pos)
						{
							case VP_HG_POS_PERIOD_L2R: // |>|  ->  8-7-6-5-(4) => 8:4  8-7-6-5-4-(3) => 8:3
								// default
								break;

							case VP_HG_POS_PERIOD_R2L: // |>| -> |<|  =>  8-7-6-5-(4) => 4:8  8-7-6-5-4-(3) => 3:8
								swap(hg.bar_from, hg.bar_to);
								break;

							case VP_HG_POS_PERIOD_L2C: // |>| -> |>: |  ->  8-7-6-5-(4) => 8:6  8-7-6-5-4-(3) => 8:6
								hg.bar_to = hg.bar_from - half_width;
								break;

							case VP_HG_POS_PERIOD_C2L: // |>| -> |<: |  ->  8-7-6-5-(4) => 6:8  8-7-6-5-4-(3) => 6:8
								hg.bar_to = hg.bar_from - half_width;
								swap(hg.bar_from, hg.bar_to);
								break;

							case VP_HG_POS_PERIOD_C2R: // |>| -> | :>|  ->  8-7-6-5-(4) => 6:4  8-7-6-5-4-(3) => 5:3?
								hg.bar_from = hg.bar_to + half_width;
								break;

							case VP_HG_POS_PERIOD_R2C: // |>| -> | :<|  ->  ?
								hg.bar_from = hg.bar_to + half_width;
								swap(hg.bar_from, hg.bar_to);
								break;
						}
					}

					if (params_hg_.bar_style == VP_BAR_STYLE_COLOR)
					{
						zoom = 1.0;
					}
					else
					{
						if (params_period_.zoom_type == VP_ZOOM_AUTO_GLOBAL)
						{
							zoom = (hg.bar_from - hg.bar_to) / global_max_volume_;
						}
						else if (params_period_.zoom_type == VP_ZOOM_AUTO_LOCAL)
						{
							zoom = (hg.bar_from - hg.bar_to) / hg.max_volume;
						}
					}

					zoom *= hg_width_fraction_;
				}

				// Нарисовать гистограмму и добавить гистограмму в список выполненных, если её правая граница левее текущего тика
				if ((vpvis_.draw_hg(hg, zoom, global_max_volume_)) && (range_end < last_tick_time))
				{
					_arr.set(draw_history_, range_start);
				}

				// Проверить ограничение на время рисования
				if (draw_timer.check())
				{
					PRINT("Stopped drawing hg #" + string(i + 1) + " of " + string(real_range_count));
					total_result = false;
					break;
				}
			}
		}

		_ptr.safe_delete_array(hgs);

		prev_work_end_time_ms_ = _time.tick_count_long();
		return(total_result);
	}

	bool get_range_mode_range(datetime &time_from, datetime &time_to)
	{
		if (params_range_.selection == VP_RANGE_SEL_BETWEEN_LINES)  // между двух линий
		{
			// найти линии границ
			time_from = vpvis_.line_from().time();
			time_to = vpvis_.line_to().time();

			// если границы диапазона не заданы, установить их заново в видимую часть экрана
			if ((time_from == 0) || (time_to == 0))
			{
				const int leftmost_bar  = _chart.leftmost_visible_bar();
				const int rightmost_bar = _chart.rightmost_visible_bar(false);
				const int bar_range     = leftmost_bar - rightmost_bar + 1;

				time_from = _series.time(leftmost_bar - bar_range * 2 / 3, false);
				time_to   = _series.time(leftmost_bar - bar_range * 1 / 3, false);

				// нарисовать линии
				vpvis_.draw_range_lines(time_from, time_to);
			}

			// включить обе линии для выбора
			vpvis_.enable_range_lines();

			// если линии перепутаны местами, поменять местами времена начала и конца
			if (time_from > time_to)
				swap(time_from, time_to);
		}
		else if (
			(params_range_.selection == VP_RANGE_SEL_MINUTES_TO_LINE) ||
			(params_range_.selection == VP_RANGE_SEL_BARS_TO_LINE))
		{
			// найти правую линию
			time_to = vpvis_.line_to().time();

			// если правой линии нет, установить её в видимую часть экрана, запомнить номер бара правой границы
			int bar_to;
			{
				if (time_to == 0)
				{
					const int leftmost_bar = _chart.leftmost_visible_bar();
					const int rightmost_bar = _chart.rightmost_visible_bar(false);
					const int bar_range = leftmost_bar - rightmost_bar;

					bar_to = leftmost_bar - bar_range * 2 / 3;
					time_to = _series.time(bar_to, false);
				}
				else
				{
					bar_to = _series.bar_shift_left(time_to);
				}

				vpvis_.draw_line_to(time_to);
				vpvis_.enable_line_to();
			}

			// левая невыбираемая граница
			{
				const int bar_from = (params_range_.selection == VP_RANGE_SEL_MINUTES_TO_LINE)
					? (bar_to + round_minutes_to_bars(params_range_.size))
					: (bar_to + params_range_.size);

				time_from = _series.time(bar_from, false);

				vpvis_.draw_line_from(time_from);
				vpvis_.disable_line_from();
			}

		}
		else if (params_range_.selection == VP_RANGE_SEL_LAST_MINUTES)
		{
			time_from = _series.time(round_minutes_to_bars(params_range_.size) - 1, false);
			time_to = _series.time(-1, false);

			// удалить линии границ
			vpvis_.delete_range_lines();
		}
		else if (params_range_.selection == VP_RANGE_SEL_LAST_BARS)
		{
			time_to   = _series.time(-1, false);
			time_from = _series.time(params_range_.size - 1);

			// удалить линии границ
			vpvis_.delete_range_lines();
		}
		else
		{
			return(false);
		}

		return true;
	}

	/**
	Update (range mode).
	@return  false on fail (no rates, wrong params).
	*/
	bool update_range()
	{
		// Все проверки достаточно быстрые, поэтому можно на случай их провала заранее
		//   выставить время окончания последней работы.
		prev_work_end_time_ms_ = _time.tick_count_long();

		// calc work range
		datetime time_from, time_to;
		if (!get_range_mode_range(time_from, time_to))
		{
			delete_hg(prefix_);
			return(false);
		}

		// source data's horizon
		if (params_service_.show_horizon)
			vpvis_.draw_horizon(hz_line_name_, vpcalc_.get_horizon());


		// Calculate
		CVPHistogram hg;
		{
			hg.point = _Point * params_calc_.hg_point_scale;

#ifdef __MQL4__
			const int count = vpcalc_.get_hg(time_from, time_to - 1, hg.low_price, hg.volumes);
#else
			const int count = (params_data_.source == VP_SOURCE_TICKS)
				? vpcalc_.get_hg_by_ticks   (time_from, time_to - 1, hg.low_price, hg.volumes)
				: vpcalc_.get_hg            (time_from, time_to - 1, hg.low_price, hg.volumes);
#endif

			if (count <= 0)
			{
				prev_work_end_time_ms_ = _time.tick_count_long();
				delete_hg(prefix_);
				return(false);
			}
		}

		// Smooth
		if (params_calc_.smooth != 0)
			vpcalc_.smooth_hg(params_calc_.smooth, hg);

		// Levels
		{
			hg.mode_count  = vpvis_.show_modes()  ? hg_modes(hg.volumes, mode_step_, hg.modes)        : -1;
			hg.max_pos     = vpvis_.show_max()    ? _arr.max_index(hg.volumes)                        : -1;
			hg.vwap_pos    = vpvis_.show_vwap()   ? hg_vwap_index(hg.volumes, hg.low_price, hg.point) : -1;
			vpcalc_.quantiles_indexes(hg.volumes, hg.quantiles);

			// учесть нулевые объёмы всех баров источника
			hg.max_volume = _math.limit_below(_math.max(hg.volumes), 1.0);
		}

		// Границы диапазона
		int hg_width_in_bars;
		{
			if (!time_range_to_bars(time_from, time_to, hg.bar_from, hg.bar_to))
			{
				delete_hg(prefix_);
				return(false);
			}

			hg_width_in_bars = params_range_.hg_position_is_inside_range ? (hg.bar_from - hg.bar_to) : _chart.width_in_bars();
		}

		// если правая граница правее нулевого бара, то гистограмму обновлять на каждом тике
		update_on_tick_ = hg.bar_to < 0;

		// Определить масштаб. В Range Mode обе автоматики одинаковы, т.к. гг одна
		double zoom = params_period_.zoom_custom;
		{
			if (params_hg_.bar_style == VP_BAR_STYLE_COLOR)
				zoom = 1.0;
			else
				zoom = hg_width_in_bars / hg.max_volume;

			if (!params_range_.hg_position_is_inside_range)
				zoom *= 0.15;

			zoom *= hg_width_fraction_;
		}

		// Скорректировать диапазон баров отображения
		{
			const double range_size = (params_hg_.bar_style == VP_BAR_STYLE_COLOR) ? (hg_width_in_bars) : (zoom * hg.max_volume);

			if (params_range_.hg_position == VP_HG_POSITION_CHART_LEFT)
			{
				// левая граница окна [> ¦  ¦  ]
				hg.bar_from = _chart.leftmost_visible_bar();
				hg.bar_to = (int)(hg.bar_from - range_size);
			}
			else if (params_range_.hg_position == VP_HG_POSITION_CHART_RIGHT)
			{
				// правая граница окна [  ¦  ¦ <]
				hg.bar_from = _chart.rightmost_visible_bar();
				hg.bar_to = (int)(hg.bar_from + range_size);
				zoom = -zoom;
			}
			else if (params_range_.hg_position == VP_HG_POSITION_LEFT_OUTSIDE)
			{
				// левая граница диапазона влево наружу [  <¦  ¦  ]
				//hg.bar_from = hg.bar_from;
				hg.bar_to = (int)(hg.bar_from + range_size);
				zoom = -zoom;
			}
			else if (params_range_.hg_position == VP_HG_POSITION_RIGHT_OUTSIDE)
			{
				// правая граница диапазона наружу [   ¦  ¦>  ]
				swap(hg.bar_from, hg.bar_to);
				hg.bar_to = (int)(hg.bar_from - range_size);
			}
			else if (params_range_.hg_position == VP_HG_POSITION_LEFT_INSIDE)
			{
				// левая граница диапазона влево внутрь [   ¦>  ¦  ]
				//hg.bar_from = hg.bar_from;
				//hg.bar_to = hg.bar_from;
			}
			else //if (params_range_.hg_position() == VP_HG_POSITION_RIGHT_INSIDE)
			{
				// правая граница диапазона [   ¦ <¦  ]
				swap(hg.bar_from, hg.bar_to);
				zoom = -zoom;
			}
		}

		// Отображение
		{
			// Удаление должно быть непосредственно и только перед перерисовкой, иначе появляется мерцание (fxcoder-mql/vp#30)
			delete_hg(prefix_);
			hg.prefix = prefix_;
			vpvis_.draw_hg(hg, zoom, 0);
		}

		prev_work_end_time_ms_ = _time.tick_count_long();
		return(true);
	}

	void delete_hg(string prefix)
	{
		_chart.objects_delete_all(prefix);
	}

	// delete histograms that are not in the list (draw_history_)
	void delete_hg_unlisted(const datetime &ranges_starts[])
	{
		for (int i = ArraySize(draw_history_) - 1; i >= 0; --i)
		{
			if (!_arr.contains(ranges_starts, draw_history_[i]))
			{
				_chart.objects_delete_all(get_period_mode_hg_prefix(draw_history_[i]));
				_arr.remove(draw_history_, i);
			}
		}
	}

	/**
	Получить таймфрейм источника данных
	*/
	ENUM_TIMEFRAMES get_data_source_tf(const ENUM_VP_SOURCE data_source)
	{
#ifndef __MQL4__
		// без разницы
		if (data_source == VP_SOURCE_TICKS)
			return(PERIOD_CURRENT);
#endif

		return(_tf.find_closest((int)data_source));
	}

	// получить диапазон баров в текущем ТФ (для рисования)
	// bar_from: самый левый бар, bar_to: следующий за самым правым (bar_to < bar_from)
	bool time_range_to_bars(const datetime time_from, const datetime time_to, int &bar_from, int &bar_to)
	{
		bar_from = _series.bar_shift_right(time_from);
		bar_to = _series.bar_shift_right(time_to); // ..right для того, чтобы работали 1-баровые режимы
		return(true);
	}


private:

	int round_minutes_to_bars(int minutes)
	{
		return(_math.round_to_int((double)params_range_.size / _tf.current_minutes));
	}

};
