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

// Математические функции. © FXcoder

#property strict

#include "../type/uncopyable.mqh"

class CBMathUtil: public CBUncopyable
{
public:

	static const double   nan;       // not a number (double)
	static const float    nan_float; // not a number (float)
	static const double   phi1;      // 1.618...


public:

	static bool is_valid(double value) { return(::MathIsValidNumber(value)); }

	/*
	Получить число Фибоначчи по его порядковому номеру.
	https://en.wikipedia.org/wiki/Fibonacci_number
	Ограничение наступает при i=70, дальше результат не определён.
	@param i  Порядковый номер числа Фибоначчи, может быть отрицательным.
	@return   Число Фибоначчи(i=[-4..+4]): -3, 2, -1, 1, 0, 1, 1, 2, 3
	*/
	static long fibo(int i)
	{
		if (i >= 0)
			return(round_to_long(::pow(_math.phi1, i) / ::sqrt(5)));

		return((i % 2 == 0) ? -fibo(-i) : fibo(-i));
	}

	// Greatest common divisor
	static int gcd(int a, int b)
	{
		while (b != 0)
		{
			int r = a % b;
			a = b;
			b = r;
		}

		return a;
	}

	// Greatest common divisor
	static int gcd(const int &values[])
	{
		int size = ArraySize(values);
		if (size < 1)
			return(0);

		int res = values[0];

		for (int i = 1; i < size; i++)
			res = gcd(res, values[i]);

		return(res);
	}

	/*
	Сравнить два значения.
	@param a  Первое значение для сравнения.
	@param b  Второе значение для сравнения.
	@param e  Точность, выраженная в знаках после запятой.
	@return   1 (a>b), 0 (a=b), -1 (a<b).
	*/
	template <typename TA, typename TB>
	static int compare(TA a, TB b)
	{
		return(a < b ? -1 : (a > b ? 1 : 0));
	}

	static int compare(double a, double b, int digits)
	{
		return(compare(::NormalizeDouble(a - b, digits), 0.0));
	}

	// для совместимости
	static int compare_double(double a, double b = 0.0, int digits = 8)
	{
		return(compare(a, b, digits));
	}

	static bool is_zero(double a, int digits = 8)
	{
		return(::NormalizeDouble(a, digits) == 0.0);
	}

	template <typename T> static T limit_above(T value, T max_value) { return(value <= max_value ? value : max_value); }
	template <typename T> static T limit_below(T value, T min_value) { return(value >= min_value ? value : min_value); }

	/*
	Поместить значение в указанный диапазон.
	Предполагается использование с числовыми значениями, работа с другими типами не проверялась.
	@param value  Исходное значение.
	@param min    Нижняя граница диапазона.
	@param max    Верхняя граница диапазона.
	@return       Значение, помещенное в указанный диапазон. Например, для limit(5, 10, 20)
	              будет возвращено 10. Если параметр to меньше параметра from, значение value
	              будет возвращено без изменений.
	*/
	template <typename T> static T limit(T value, T min_value, T max_value)
	{
		if (max_value < min_value)
			return(value);

		if (value > max_value)
			value = max_value;
		else if (value < min_value)
			value = min_value;

		return(value);
	}

	template <typename T> static T max(T a, T b) { return(a > b ? a : b); }
	template <typename T> static T min(T a, T b) { return(a < b ? a : b); }

	template <typename T> static T max(T a, T b, T c) { return((a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c)); }
	template <typename T> static T min(T a, T b, T c) { return((a < b) ? ((a < c) ? a : c) : ((b < c) ? b : c)); }

	template <typename T> static T max(const T &arr[], int first, int count) { return(arr[_arr.max_index(arr, first, count)]); }
	template <typename T> static T min(const T &arr[], int first, int count) { return(arr[_arr.min_index(arr, first, count)]); }

	template <typename T> static T max(const T &arr[]) { return(max(arr, 0, ::ArraySize(arr))); }
	template <typename T> static T min(const T &arr[]) { return(min(arr, 0, ::ArraySize(arr))); }

	template <typename T> static bool min_max(const T &arr[], T &min, T &max)
	{
		return(min_max(arr, 0, ArraySize(arr), min, max));
	}

	template <typename T> static bool min_max(const T &arr[], int first, int count, T &min, T &max)
	{
		int min_index = _arr.min_index(arr, first, count);
		int max_index = _arr.max_index(arr, first, count);

		if ((min_index < 0) || (max_index < 0))
			return(false);

		min = arr[min_index];
		max = arr[max_index];
		return(true);
	}


	// max(|a|, |b|)
	template <typename T>
	static T max_abs(T a, T b)
	{
		return(max(max(a, b), -min(a, b)));
	}

	// max(|arr|)
	template <typename T>
	static T max_abs(const T &arr[], int first, int count)
	{
		double max = max(arr, first, count);
		double min = min(arr, first, count);
		return(_math.max(max, -min));
	}

	// max(|arr|)
	template <typename T>
	static T max_abs(const T &arr[])
	{
		return(max_abs(arr, 0, ::ArraySize(arr));
	}

	template <typename T> static int max_int(T a, T b) { return(round_to_int(max(a, b))); }
	template <typename T> static int min_int(T a, T b) { return(round_to_int(min(a, b))); }

	// предполагаются числовые типы
	template <typename T> static int sign    (T a) { return(    compare(a, (T)NULL));  }


	static uchar limit_to_uchar(int v)    { return(v < 0 ? 0 : (v > UCHAR_MAX ? UCHAR_MAX : uchar(v))); }
	static uchar limit_to_uchar(double v) { return(limit_to_uchar(round_to_int(v))); }

	template <typename T>
	static bool is_in_range(T value, T low, T high)
	{
		return((value >= low) && (value <= high));
	}

	static int  round_to_int  (double value) { return( int(value >= 0.0  ? (value + 0.5)  : (value - 0.5)));  }
	static int  round_to_int  (float  value) { return( int(value >= 0.0f ? (value + 0.5f) : (value - 0.5f))); }
	static long round_to_long (double value) { return(long(value >= 0.0  ? (value + 0.5)  : (value - 0.5)));  }
	static long round_to_long (float  value) { return(long(value >= 0.0f ? (value + 0.5f) : (value - 0.5f))); }

	static int floor_to_int(double value)
	{
		const int res = int(value);
		return(res > value ? (res - 1) : res);
	}

	static int ceil_to_int(double value)
	{
		const int res = int(value);
		return(res < value ? (res + 1) : res);
	}


	// округлить с указанной ошибкой
	static double round_err(double value, double error)
	{
		return((error == 0) ? value : (::round(value / error) * error));
	}

	/*
	Суммировать элементы массива. Проверка на переполнение результата не делается.
	@param &arr   Массив исходных чисел.
	@param first  Начальный элемент в массиве для обработки.
	@param count  Количество элементов для обрабтоки.
	@return       Сумма элементов массива.
	*/
	template <typename T>
	static T sum(const T &arr[], int first, int count)
	{
		T sum = (T)NULL;

		for (int i = first, last = first + count - 1; i <= last; i++)
			sum += arr[i];

		return(sum);
	}

	template <typename T>
	static T sum(const T &arr[])
	{
		return(sum(arr, 0, ::ArraySize(arr)));
	}


	/*
	Суммировать квадраты элементов массива. Проверка на переполнение результата не делается.
	@param &arr   Массив исходных чисел.
	@param first  Начальный элемент в массиве для обработки.
	@param count  Количество элементов для обрабтоки.
	@return       Сумма элементов массива.
	*/
	template <typename T>
	static T sq_sum(const T &arr[], int first, int count)
	{
		T sum = (T)NULL;

		for (int i = first, last = first + count - 1; i <= last; i++)
			sum += arr[i] * arr[i];

		return(sum);
	}

	template <typename T>
	static T sq_sum(const T &arr[])
	{
		return(sq_sum(arr, 0, ::ArraySize(arr)));
	}

	static double sqr(const double value)
	{
		return(value * value);
	}

	/*
	Вычислить арифметическое среднее.
	@param &arr[]    Массив исходных чисел.
	@param first     Стартовая позиция для расчета. Если не указано, расчет будет производиться с начала массива.
	@param count     Количество элементов массива для расчета, начиная с позиции first.
	@return          Среднее арифметическое.
	*/
	static double mean(const double &arr[], int first, int count)
	{
		return(sum(arr, first, count) / count);
	}

	static double mean(const double &arr[])
	{
		return(mean(arr, 0, ::ArraySize(arr)));
	}

	static double mean(double a, double b)           { return((a + b) / 2.0); }
	static double mean(double a, double b, double c) { return((a + b + c) / 3.0); }


	/*
	Рассчитать медиану и вернуть индекс элемента массива.
	@param values  Массив значений.
	@return        Индекс медианы в массиве. В случае неудачи (массив пуст) возвращается -1.
	*/
	static int median_index(const double &arr[], int first, int count)
	{
		double half_sum = sum(arr, first, count) / 2.0;
		double v = 0;

		// пройти по массиву и остановиться на середине суммы значений
		for (int i = first, last = first + count - 1; i <= last; i++)
		{
			v += arr[i];

			if (v >= half_sum)
				return(i);
		}

		return(-1);
	}

	static int median_index(const double &arr[])
	{
		return(median_index(arr, 0, ::ArraySize(arr)));
	}


	/*
	Вычислить медиану.
	Алгоритм отличается от median_index, в случае чётного числа элементов будет взято среднее значение около медианы.
	Без проверки диапазона.

	@param &arr[]    Массив чисел, для которых будет рассчитана медиана.
	@param first     Стартовая позиция для расчета. Если не указано, расчет будет производиться с начала массива.
	@param count     Количество элементов массива для расчета, начиная с позиции first.
	@return          Медиана.
	*/
	static double median(const double &arr[], int first, int count)
	{
		// Скопировать выбранные данные в отдельный массив, т.к. данные необходимо менять
		double selected[];
		::ArrayCopy(selected, arr, 0, first, count);

		// Медиана - середина отсортированного массива
		::ArraySort(selected);

		// При нечетном - центральный элемент, при четном - среднее двух центральных
		if (count % 2 == 1)
			return(selected[count / 2]);
		else
			return((selected[count / 2 - 1] + selected[count / 2]) / 2.0);
	}

	static double median(const double &arr[])
	{
		return(median(arr, 0, ::ArraySize(arr)));
	}

	// Без проверки входных данных.
	// @param odd_include_median  включить или нет медиану в расчёт Q1 и Q3 в случае нечётного числа
	//                            элементов, см. https://en.wikipedia.org/wiki/Quartile, методы 1 и 2.
	static void quantiles(const double &arr[], bool odd_include_median, int first, int count, double &quartiles[])
	{
		if (ArrayIsDynamic(quartiles))
			ArrayResize(quartiles, 3);

		// Скопировать выбранные данные в отдельный массив, т.к. данные необходимо менять
		double selected[];
		::ArrayCopy(selected, arr, 0, first, count);

		// Медиана - середина отсортированного массива
		::ArraySort(selected);

		const bool is_odd = (count % 2) != 0;
		const int last = count - 1;

		double q1 = 0.0;
		double q2 = 0.0;
		double q3 = 0.0;

		// Для лучшего понимания оставить все ветвления полностью, даже если почти совпадают по расчётам.

		if (is_odd)
		{
			q2 = selected[count / 2];

			if (odd_include_median)
			{
				const int q13_count = count / 2 + 1;
				const int q1i = q13_count / 2;
				const bool is_q13_odd = (q13_count % 2) != 0;

				if (is_q13_odd)
				{
					//  0  1  2   3  4   5  6   7  8
					// [ ][ ][Q1][ ][Q2][ ][Q3][ ][ ]
					q1 = selected[q1i];
					q3 = selected[last - q1i];
				}
				else
				{
					//  0  1      2  3   4      5  6
					// [ ][ ] Q1 [ ][Q2][ ] Q3 [ ][ ]
					q1 = (selected[q1i - 1] + selected[q1i]) / 2.0;
					q3 = (selected[last - (q1i - 1)] + selected[last - q1i]) / 2.0;
				}
			}
			else
			{
				const int q13_count = count / 2;
				const int q1i = q13_count / 2;
				const bool is_q13_odd = (q13_count % 2) != 0;

				if (is_q13_odd)
				{
					//  0  1  2   3  4   5    6  7  8   9  10
					// [ ][ ][Q1][ ][ ] [Q2] [ ][ ][Q3][ ][ ]
					q1 = selected[q1i];
					q3 = selected[last - q1i];
				}
				else
				{
					//  0  1      2  3   4    5  6      7  8
					// [ ][ ] Q1 [ ][ ] [Q2] [ ][ ] Q3 [ ][ ]
					q1 = (selected[q1i - 1] + selected[q1i]) / 2.0;
					q3 = (selected[last - (q1i - 1)] + selected[last - q1i]) / 2.0;
				}
			}
		}
		else
		{
			q2 = (selected[count / 2 - 1] + selected[count / 2]) / 2.0;

			const int q13_count = count / 2;
			const int q1i = q13_count / 2;
			const bool is_q13_odd = (q13_count % 2) != 0;

			if (is_q13_odd)
			{
				//  0  1   2      3  4   5
				// [ ][Q1][ ] Q2 [ ][Q3][ ]
				q1 = selected[q1i];
				q3 = selected[last - q1i];
			}
			else
			{
				//  0      1      2      3
				// [ ] Q1 [ ] Q2 [ ] Q3 [ ]
				q1 = (selected[q1i - 1] + selected[q1i]) / 2.0;
				q3 = (selected[last - (q1i - 1)] + selected[last - q1i]) / 2.0;
			}
		}

		quartiles[0] = q1;
		quartiles[1] = q2;
		quartiles[2] = q3;
	}


	// Прибавить значение ко всем указанным элементам массива.
	template <typename T>
	static void plus(T &arr[], T value, int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; ++i)
			arr[i] += value;
	}

	template <typename T>
	static void plus(T &arr[], T value)
	{
		plus(arr, value, 0, ::ArraySize(arr));
	}


	// Прибавить значение ко всем указанным элементам массива.
	template <typename T>
	static void mult(T &arr[], T value, int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; i++)
			arr[i] *= value;
	}

	template <typename T>
	static void mult(T &arr[], T value)
	{
		mult(arr, value, 0, ::ArraySize(arr));
	}


	// Прибавить значение ко всем указанным элементам массива.
	template <typename T>
	static void exp(T &arr[], int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; i++)
			arr[i] = ::exp(arr[i]);
	}

	template <typename T>
	static void exp(T &arr[])
	{
		exp(arr, 0, ::ArraySize(arr));
	}


	template <typename T>
	static void abs(T &arr[], int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; i++)
			arr[i] = ::fabs(arr[i]);
	}

	template <typename T>
	static void abs(T &arr[])
	{
		abs(arr, 0, ::ArraySize(arr));
	}

	/*
	Вычислить стандартное отклонение. Медленный алгоритм.

	@param &arr[]    Массив исходных чисел.
	@param first     Стартовая позиция для расчета. Если не указано, расчет будет производиться с начала массива.
	@param count     Количество элементов массива для расчета, начиная с позиции first. Если не указано, для расчета будет
	                 использованы все элементы массива, начиная с позиции first.
	@return          Стандартное отклонение.
	*/
	static double stdev_exact(const double &arr[], int first, int count)
	{
		double mean, dev;
		mean_stdev_exact(arr, first, count, mean, dev);
		return(dev);
	}

	static double stdev(const double &arr[], int first, int count)
	{
		double mean, dev;
		mean_stdev(arr, first, count, mean, dev);
		return(dev);
	}

	static double stdev(const double &arr[])
	{
		return(stdev(arr, 0, ::ArraySize(arr)));
	}

	static double stdev(double a, double b)
	{
		return(::fabs(a - b) * 0.5);
	}

	static double stdev(double a, double b, double c)
	{
		double avg = (a + b + c) / 3.0;
		double delta_sum = (a - avg) * (a - avg) + (b - avg) * (b - avg) + (c - avg) * (c - avg);
		return(::sqrt(delta_sum / 3.0));
	}

	static double stdev(double a, double b, double c, double d)
	{
		double avg = (a + b + c + d) / 4.0;
		double delta_sum = 0;
		delta_sum += (a - avg) * (a - avg);
		delta_sum += (b - avg) * (b - avg);
		delta_sum += (c - avg) * (c - avg);
		delta_sum += (d - avg) * (d - avg);
		return(::sqrt(delta_sum / 4.0));
	}


	static void mean_stdev_exact(const double &arr[], int first, int count, double &mean, double &dev)
	{
		mean = _math.mean(arr, first, count);
		dev = 0;

		for (int i = first, last = first + count - 1; i <= last; i++)
			dev += (arr[i] - mean) * (arr[i] - mean);

		dev = ::sqrt(dev / count);
	}

	static void mean_stdev_exact(const double &arr[], double &mean, double &dev)
	{
		mean_stdev(arr, 0, ::ArraySize(arr), mean, dev);
	}


	static void mean_stdev(const double &arr[], int first, int count, double &mean, double &dev)
	{
		mean = 0;
		double sq_sum = 0;

		for (int i = first, last = first + count - 1; i <= last; i++)
		{
			double v = arr[i];
			mean += v;
			sq_sum += v * v;
		}

		mean /= count;
		dev = ::sqrt(sq_sum / count - mean * mean);
	}

	static void mean_stdev(const double &arr[], double &mean, double &dev)
	{
		mean_stdev(arr, 0, ::ArraySize(arr), mean, dev);
	}


	static bool normalize(double &arr[], double mean, double dev, int first, int count)
	{
		if (dev == 0)
			return(false);

		for (int i = 0; i < count; i++)
			arr[i] = (arr[i] - mean) / dev;

		return(true);
	}

	static bool normalize(double &arr[], double mean, double dev)
	{
		return(normalize(arr, mean, dev, 0, ::ArraySize(arr)));
	}

	static bool normalize(double &arr[], int first, int count)
	{
		double mean, dev;
		mean_stdev(arr, first, count, mean, dev);
		return(normalize(arr, mean, dev, first, count));
	}

	static bool normalize(double &arr[])
	{
		return(normalize(arr, 0, ::ArraySize(arr)));
	}

	/*
	Вычислить стандартную оценку.

	@param &arr[]    Массив исходных чисел.
	@param value     Оцениваемое значение.
	@param first     Стартовая позиция для расчета.
	@param count     Количество элементов массива для расчета, начиная с позиции first.
	@return          Стандартная оценка (Standard Score). Если массив пуст, либо пуста его часть, заданная дополнительными параметрами, будет возвращено NaN.
	                 Значение NaN также будет возвращено, если вычисляемое в процессе стандартное отклонение будет равно 0.
	*/
	static double zscore(const double &arr[], double value, int first, int count)
	{
		double mean, dev;
		mean_stdev(arr, first, count, mean, dev);

		if (dev == 0)
			return(_math.nan);

		return((value - mean) / dev);
	}

	static double zscore(const double &arr[], double value)
	{
		return(zscore(arr, value, 0, ::ArraySize(arr)));
	}

};

const double  CBMathUtil::nan          = ::log(-1);               // NAN
const float   CBMathUtil::nan_float    = float(::log(-1));        // NAN, трюк с преобразованием типа работает только для float
const double  CBMathUtil::phi1         = (1.0 + ::sqrt(5)) / 2.0; // 1.618... (золотое сечение)

CBMathUtil _math;
