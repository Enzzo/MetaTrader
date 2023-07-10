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

#property strict


#include "../bsl.mqh"


/**
Таймер для для миллисекунд. © FXcoder

Для проверки срабатывания таймера необходимо проверять его состояние через метод check().
При срабатывании таймера происходит его перезапуск.

Важно! В тестере после создания объекта при необходимости вызвать reset явно, указав время.

@code
void OnStart()
{
	// Два таймера
    CTimer timer5sec(5 * 1000);
    CTimer timer1min(60 * 1000);

    while (!IsStopped())
    {
        if (timer5sec.check())
            Print("Сработал 5-секундный таймер");

        if (timer1min.check())
            Print("Сработал 1-минутный таймер");
    }
}
@endcode
*/
class CTimer: public CBUncopyable
{
private:

	uint milliseconds_;
	long last_tick_;
	bool is_stopped_;


public:

	uint   milliseconds () const { return(milliseconds_); }
	double seconds      () const { return(milliseconds_ / 1000.0); }

	/**
	Конструктор.
	В тестере желательно сразу вызвать reset с указанием времени (например, взять из последнего тика).
	@param milliseconds     Период таймера в миллисекундах.
	@param wait_first_time  Ждать первый раз. Если ждать, то первый раз таймер сработает через
	                        milliseconds мс, иначе - сразу при первой проверке.
	*/
	void CTimer(uint milliseconds, bool wait_first_time = true):
		milliseconds_(0),
		is_stopped_(true),
		last_tick_(0)
	{
		set(milliseconds, wait_first_time);
	}

	void CTimer():
		milliseconds_(0),
		is_stopped_(true),
		last_tick_(0)
	{
	}


	/**
	Проверить состояние таймера.
	@return  true, если таймер сработал. false, если нет.
	*/
	bool check(long time_msc = 0)
	{
		// признак отключения
		if (is_stopped_)
			return(false);

		// проверить ожидание
		const long now = time_msc == 0 ? _time.tick_count_long() : time_msc;
		const bool stop = now >= last_tick_ + milliseconds_;

		// сбросить таймер
		if (stop)
			last_tick_ = now;

		return(stop);
	}

	/**
	Проверить однократое срабатывание таймера. После первого срабатывания таймер будет остановлен
	до перезапуска функцией reset().
	@return  true, если таймер сработал. false, если нет.
	*/
	bool check_once(long time_msc = 0)
	{
		// признак отключения
		if (is_stopped_)
			return(false);

		// проверить ожидание
		const long now = time_msc == 0 ? _time.tick_count_long() : time_msc;
		const bool stop = now >= last_tick_ + milliseconds_;

		// сбросить и остановить таймер
		if (stop)
		{
			last_tick_ = now;
			this.stop();
		}

		return(stop);
	}


	/**
	Установить таймер.
	@param milliseconds  Период таймера в мс. Если указать 0, будет использоваться предыдущее значение.
	*/
	void set(uint milliseconds, bool wait_first_time = true)
	{
		milliseconds_ = milliseconds;
		last_tick_ = 0;

		if (milliseconds == 0)
		{
			is_stopped_ = true;
		}
		else
		{
			is_stopped_ = false;

			if (wait_first_time)
				this.reset();
		}
	}

	/**
	Сбросить таймер.
	@param milliseconds  Период таймера в мс. Если указать 0, будет использоваться предыдущее значение.
	*/
	void reset(uint milliseconds = 0)
	{
		last_tick_ = _time.tick_count_long();

		if (milliseconds > 0)
			milliseconds_ = milliseconds;

		is_stopped_ = milliseconds_ == 0;
	}

	// вариант для тестера с явным указанием времени
	void reset(uint milliseconds, long time_msc)
	{
		last_tick_ = time_msc;

		if (milliseconds > 0)
			milliseconds_ = milliseconds;

		is_stopped_ = milliseconds_ == 0;
	}

	void stop()
	{
		is_stopped_ = true;
	}

	uint elapsed(long time_msc = 0) const
	{
		if (is_stopped_)
			return(0);

		const long now = time_msc == 0 ? _time.tick_count_long() : time_msc;

		return((uint)(now - last_tick_));
	}

	bool is_stopped() const { return(is_stopped_); }

};
