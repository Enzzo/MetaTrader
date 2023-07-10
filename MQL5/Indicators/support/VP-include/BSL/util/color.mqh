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

// Color functions for type `color` + general color functions. © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "arr.mqh"
#include "hsv.mqh"
#include "math.mqh"

class CBColorUtil: public CBUncopyable
{
public:

	static const color none;


public:

	static color create(uchar r, uchar g, uchar b)
	{
		// 0x00BBGGRR
		return(color(((b & 0xFF) << 16) | ((g & 0xFF) << 8) | (r & 0xFF)));
	}

	static color create_int(int r, int g, int b)
	{
		r = _math.limit_to_uchar(r);
		g = _math.limit_to_uchar(g);
		b = _math.limit_to_uchar(b);
		return(color(((b & 0xFF) << 16) | ((g & 0xFF) << 8) | (r & 0xFF)));
	}

	static color random()
	{
		return(create(uchar(::MathRand() & 0xFF), uchar(::MathRand() & 0xFF), uchar(::MathRand() & 0xFF)));
	}

	static uchar r_uchar(color c) { return(uchar( c & 0x0000FF       )); }
	static uchar g_uchar(color c) { return(uchar((c & 0x00FF00) >> 8 )); }
	static uchar b_uchar(color c) { return(uchar((c & 0xFF0000) >> 16)); }

	static int r(color c) { return( c & 0x0000FF       ); }
	static int g(color c) { return((c & 0x00FF00) >> 8 ); }
	static int b(color c) { return((c & 0xFF0000) >> 16); }

	static int brightness(color c)
	{
		return(_math.max(r(c), g(c), b(c)));
	}

	// Проверить, является ли цвет неопределенным.
	// @param c  Цвет для проверки
	// @return   true, если цвет не определен, false, если определен.
	static bool is_none(color c)
	{
		return((c >> 24) != 0);
	}

	// не none
	static bool is_valid(color c)
	{
		return((c >> 24) == 0);
	}

	// проверить, является ли цвет валидным. если нет, то вернуть fallback
	static color validate(color c, color fallback)
	{
		return(is_valid(c) ? c : fallback);
	}

	/*
	Инвертировать цвет.
	@param c  Исходный цвет.
	@return   Цвет - результат инверсии.
	*/
	static color invert(color c)
	{
		return(color(c ^ 0xFFFFFF));
	}

	/*
	Разложить цвет на компоненты.

	@param c  Исходный цвет
	@param r  Результат: красная составляющая
	@param g  Результат: зеленая составляющая
	@param b  Результат: синяя составляющая
	@return   Успех операции. Разложение не может быть осуществлено для неопределенного цвета, параметры r, g и b при
	          этом остаются без изменений.
	*/
	static bool to_rgb(color c, int &r, int &g, int &b)
	{
		// Если цвет задан неверный, либо задан как отсутствующий, вернуть false
		if (is_none(c))
			return(false);

		b = (c & 0xFF0000) >> 16;
		g = (c & 0x00FF00) >> 8;
		r = (c & 0x0000FF);
		return(true);
	}

	static bool to_rgb_uchar(color c, uchar &r, uchar &g, uchar &b)
	{
		// Если цвет задан неверный, либо задан как отсутствующий, вернуть false
		if (is_none(c))
			return(false);

		b = uchar((c & 0xFF0000) >> 16);
		g = uchar((c & 0x00FF00) >> 8);
		r = uchar((c & 0x0000FF));
		return(true);
	}

	// return hsv: 0x0HHHSSVV
	static uint to_hsv(color c)
	{
		return(_hsv.from_rgb_u(r_uchar(c), g_uchar(c), b_uchar(c)));
	}

	/*
	Смешать цвета в заданных пропорциях.
	Терминал поддерживает только ограниченное число цветов, поэтому использование всей палитры RGB приводит к ошибкам
	в отображении не только индикатора, но и самого графика. Для ограничения палитры введен параметр шага.

	@param color1  Цвет 1
	@param color2  Цвет 2
	@param mix     Пропорция смешивания (0..1). При mix=0 получается цвет 1, при mix=1 получается цвет 2. Если значение
	               выходит за рамки допустимого, оно будет соответственно скорректировано.
	@param step    Шаг цвета, огрубление (1..255). Если значение выходит за рамки допустимого, оно будет соответственно
	               скорректировано.
	@return        Цвет - результат смешения.
	*/
	static color mix(color color1, color color2, double mix, double step = 16.0)
	{
		// Коррекция неверных параметров
		step = _math.limit(step, 1.0, 255.0);
		mix = _math.limit(mix, 0.0, 1.0);

		// нужны типы со знаком
		int r1, g1, b1;
		int r2, g2, b2;

		// Разбить на компоненты
		to_rgb(color1, r1, g1, b1);
		to_rgb(color2, r2, g2, b2);

		// вычислить
		const uchar r = _math.limit_to_uchar(_math.round_err(r1 + mix * (r2 - r1), step));
		const uchar g = _math.limit_to_uchar(_math.round_err(g1 + mix * (g2 - g1), step));
		const uchar b = _math.limit_to_uchar(_math.round_err(b1 + mix * (b2 - b1), step));

		return(mix2(color1, color2, mix, step));
	}

	/*
	В отличие от mix здесь допустимы любые значения mix и step
	*/
	static color mix2(color color1, color color2, double mix, double step = 16.0)
	{
		int r1, g1, b1;
		to_rgb(color1, r1, g1, b1);

		int r2, g2, b2;
		to_rgb(color2, r2, g2, b2);

		// вычислить
		const uchar r = _math.limit_to_uchar(_math.round_err(r1 + mix * (r2 - r1), step));
		const uchar g = _math.limit_to_uchar(_math.round_err(g1 + mix * (g2 - g1), step));
		const uchar b = _math.limit_to_uchar(_math.round_err(b1 + mix * (b2 - b1), step));

		return(create(r, g, b));
	}


	// weights[*] >= 0
	// если сумма весов = 0, возвращается clrNONE
	static color mix(color &colors[], double &weights[])
	{
		const int count = ::ArraySize(colors);
		if (::ArraySize(weights) != count)
			return(clrNONE);

		double wsum = 0;
		double rw = 0;
		double gw = 0;
		double bw = 0;

		for (int i = 0; i < count; i++)
		{
			const double w = weights[i];
			wsum += w;

			const color c = colors[i];
			rw += r(c) * w;
			gw += g(c) * w;
			bw += b(c) * w;
		}

		if (wsum == 0)
			return(clrNONE);

		const int r = int(rw / wsum + 0.5);
		const int g = int(gw / wsum + 0.5);
		const int b = int(bw / wsum + 0.5);

		return(create_int(r, g, b));
	}

	static color mix(color &colors[])
	{
		double weights[];
		_arr.resize_fill(weights, ::ArraySize(colors), 1.0);
		return(mix(colors, weights));
	}

	// shift: -360..+360 (будет использован остаток от деления на 360)
	static color shift_hue(color c, int shift)
	{
		return(_hsv.to_color(_hsv.shift_hue(to_hsv(c), shift)));
	}


	/* Общие функции */

	// hue: 0..360
	// saturation, value: 0..255
	// r,g,b: 0..255
	// формулы из вики
	static void rgb_to_hsv(uchar red, uchar green, uchar blue, ushort &hue, uchar &saturation, uchar &value)
	{
		const double d = 1.0 / 255.0;

		const double r = d * red;
		const double g = d * green;
		const double b = d * blue;

		double max = _math.max(r, g, b);
		double min = _math.min(r, g, b);
		double range = max - min;

		int raw_hue;

		if (max == min)
		{
			raw_hue = 0;
		}
		else if (max == r)
		{
			raw_hue = _math.round_to_int(60.0 * (g - b) / range) + (g >= b ? 0 : 360);
		}
		else if (max == g)
		{
			raw_hue = _math.round_to_int(60.0 * (b - r) / range) + 120;
		}
		else // if (max == b)
		{
			raw_hue = _math.round_to_int(60.0 * (r - g) / range) + 240;
		}

		hue = _hsv.normalize_hue(raw_hue);
		saturation = max == 0 ? 0 : _math.limit_to_uchar(255.0 * range / max);
		value = _math.max(red, green, blue);
	}

	//deprecated: -> _hsv.to_rgb
	static void hsv_to_rgb(ushort hue, uchar saturation, uchar value, uchar &red, uchar &green, uchar &blue)
	{
		_hsv.to_rgb(hue, saturation, value, red, green, blue);
	}

};

const color CBColorUtil::none = clrNONE;

CBColorUtil _color;
