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

// Статистические функции. © FXcoder
#property strict

#include "../bsl.mqh"

// Получить моды (локальные максимумы) гистограммы
int hg_modes(const double &values[], int mode_step, int &modes[])
{
	ArrayFree(modes);

	const int values_count = ArraySize(values);

	double values_ext[];
	ArrayResize(values_ext, values_count + mode_step * 2);
	ArrayInitialize(values_ext, 0.0);
	ArrayCopy(values_ext, values, mode_step, 0, values_count);

	// ищем максимумы по участкам
	for (int i = mode_step, last = values_count + mode_step - 1; i <= last; ++i)
	{
		const int k = _arr.max_index(values_ext, i - mode_step, 2 * mode_step + 1);

		if (k != i)
			continue;

		for (int j = i - mode_step; j <= i + mode_step; j++)
		{
			if (values_ext[j] == values_ext[k])
				_arr.add(modes, j - mode_step);
		}
	}

	return(ArraySize(modes));
}

// Вычислить VWAP и вернуть индекс элемента.
int hg_vwap_index(const double &volumes[], double low, double step)
{
	if (step == 0)
		return(-1);

	double vwap = 0;
	double total_volume = 0;

	for (int i = 0, size = ArraySize(volumes); i < size; ++i)
	{
		const double price = low + i * step;
		const double volume = volumes[i];

		vwap += price * volume;
		total_volume += volume;
	}

	if (total_volume == 0)
		return(-1);

	vwap /= total_volume;
	return(_math.round_to_int((vwap - low) / step));
}

// Вычислить VWAP и вернуть индекс элемента.
int hg_vwap_index(const double &prices[], const double &volumes[])
{
	double vwap = 0;
	double total_volume = 0;
	const int size = ArraySize(volumes);

	if (size != ArraySize(prices))
		return(-1);

	if (size == 0)
		return(-1);

	for (int i = 0; i < size; ++i)
	{
		const double price = prices[i];
		const double volume = volumes[i];

		vwap += price * volume;
		total_volume += volume;
	}

	if (total_volume == 0)
		return(-1);

	vwap /= total_volume;


	// Найти индекс ближайшей к VWAP цены

	double min_error = MathAbs(vwap - prices[0]);
	int min_error_index = 0;

	for (int i = 1; i < size; ++i)
	{
		double error = MathAbs(vwap - prices[i]);

		if (error < min_error)
		{
			min_error = error;
			min_error_index = i;
		}
	}

	return(min_error_index);
}

bool array_to_hg(const double &values[], int n, double &hg[])
{
	if (n < 1)
		return(false);

	const int count = ArraySize(values);
	if (count <= 0)
		return(false);

	// определить границы
	const double min = _math.min(values);
	const double max = _math.max(values);

	return(array_to_hg(values, n, min, max, hg));
}

// Преобразовать массив значений в гистограмму распределения с заданным числом разбиений
bool array_to_hg(const double &values[], int n, double min, double max, double &hg[])
{
	double bins[];
	int freqs[];

	if (!array_to_hg(values, n, min, max, bins, freqs))
		return(false);

	return(_arr.clone(hg, freqs) == n);
}

bool array_to_hg(const double &values[], int n, double min, double max, double &bins[], int &freqs[])
{
	if (n < 1)
		return(false);

	const int count = ArraySize(values);
	if (count <= 0)
		return(false);

	if (max == min)
		PRINT_RETURN("max == min" + VAR(max) + VAR(count), false);


	ArrayResize(bins, n);
	double step = double(n) / (max - min);

	for (int i = 0; i < n; i++)
		bins[i] = step * (0.5 + i); // для double указывать на центра бара


	ArrayResize(freqs, n);
	ArrayInitialize(freqs, 0);
	double n_per_range = n / (max - min);
	int last = n - 1;

	for (int i = 0; i < count; i++)
	{
		int pos = (int)floor((values[i] - min) * n_per_range);

		if (pos > last)
			pos = last;  // крайнее значение идёт в последнюю ячейку
		else if (pos < 0)
			pos = 0;     // не должно быть

		freqs[pos]++;
	}


	return(true);
}
