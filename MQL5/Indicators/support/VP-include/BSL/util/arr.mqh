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

// Array functions. © FXcoder
// It is assumed that the attribute “as a series” is not used at all anywhere.


#property strict

#include "../type/uncopyable.mqh"
#include "../debug.mqh"
#include "ring.mqh"

typedef int (*StringSortingComparer)(const string&, const string&);


class CBArrayUtil: public CBUncopyable
{
public:

	static const int default_reserve; // default array reserve size


public:

	// +1 если arr1 > arr2, -1 если arr1 < arr2, 0 если массивы равны.
	// Обход идёт в прямом порядке, остановка на первом различии.
	// Пустые массивы равны. Если массивы разной длины, то сначала
	// происходит сравнение по меньшей длине, затем, если всё ещё равны,
	// большим считается массив с большим числом элементов.
	template <typename T>
	static int compare(const T &arr1[], const T &arr2[])
	{
		const int size1 = ::ArraySize(arr1);
		const int size2 = ::ArraySize(arr2);

		for (int i = 0, min_size = _math.min(size1, size2); i < min_size; ++i)
		{
			if (arr1[i] > arr2[i])
				return(+1);

			if (arr1[i] < arr2[i])
				return(-1);
		}

		// здесь массивы равны по меньшей длине, далее сравнить только по длине

		if (size1 > size2)
			return(+1);

		if (size2 > size1)
			return(-1);

		return(0);
	}

	// empty arrays are equal
	template <typename T>
	static bool equal(const T &arr1[], const T &arr2[])
	{
		const int size1 = ::ArraySize(arr1);
		if (size1 != ::ArraySize(arr2))
			return(false);

		for (int i = 0; i < size1; ++i)
		{
			if (arr1[i] != arr2[i])
				return(false);
		}

		return(true);
	}

	/*
	Найти значение в массиве и вернуть индекс элемента.
	@param arr[]          Массив для поиска
	@param value          Искомое значение
	@param starting_from  Индекс начала поиска
	@return               Индекс найденного элемента или -1, если значение не найдено.
	*/
	template <typename T>
	static int index_of(const T &arr[], T value, int starting_from = 0)
	{
		for (int i = starting_from, size = ::ArraySize(arr); i < size; ++i)
		{
			if (arr[i] == value)
				return(i);
		}

		return(-1);
	}

	template <typename T>
	static int index_of(const T &arr[], T value, int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; ++i)
		{
			if (arr[i] == value)
				return(i);
		}

		return(-1);
	}

	// Найти значение в массиве и вернуть индекс элемента. Вариант с компаратором.
	template <typename TArr, typename TValue, typename TEqComparer>
	static int index_of(const TArr &arr[], const TValue &value, const TEqComparer eq_comparer, int starting_from = 0)
	{
		for (int i = starting_from, size = ::ArraySize(arr); i < size; ++i)
		{
			if (eq_comparer(arr[i], value))
				return(i);
		}

		return(-1);
	}

	/*
	Определить, есть ли значение в массиве.
	Поиск производится, начиная с элемента с индексом starting_from. См. также ArrayIndexOf
	@param arr[]         Массив для поиска
	@param value         Искомое значение
	@param starting_from  Индекс начала поиска
	@return              true - значение есть в массиве, false - нет.
	*/
	template <typename T>
	static bool contains(const T &arr[], T value, int starting_from = 0)
	{
		return(index_of(arr, value, starting_from) >= 0);
	}


	/*
	Инициализировать (заполнить) массив указанным значением в заданных границах.

	@param arr    Массив для инициализации.
	@param value  Значение инициализации.
	@param first  Начало диапазона.
	@param count  Количество элементов диапазона.
	@return       Количество обновлённых элементов (=count).
	*/
	template <typename T>
	static int fill(T &arr[], T value, int first, int count)
	{
		for (int i = first, last = first + count - 1; i <= last; ++i)
			arr[i] = value;

		return(count);
	}

	template <typename T>
	static int fill(T &arr[], T value)
	{
		return(::ArrayInitialize(arr, value));
	}

	/*
	Инициализировать массив (string)
	@param a[]  Массив
	@param s    Значение, которым необходимо инициализировать массив
	@return     Количество элементов в массиве.
	*/
	static int fill(string &arr[], string s)
	{
		const int c = ::ArraySize(arr);

		for (int i = 0; i < c; ++i)
			arr[i] = s;

		// Вряд ли это где-то необходимо, добавлено для похожести со стандартными функциями
		return(c);
	}

	template <typename T>
	static void free(T &arr[])
	{
		::ArrayFree(arr);
	}

	template <typename T>
	static int clear(T &arr[])
	{
		return(::ArrayResize(arr, 0, _arr.default_reserve));
	}

	template <typename T>
	static int clear(T &arr[], int reserve)
	{
		return(::ArrayResize(arr, 0, reserve));
	}

	template <typename T>
	static int size(const T &arr[])
	{
		return(::ArraySize(arr));
	}

	template <typename T>
	static int resize(T &arr[], int size)
	{
		return(::ArrayResize(arr, size, _arr.default_reserve));
	}

	template <typename T>
	static int resize(T &arr[], int size, int reserve)
	{
		return(::ArrayResize(arr, size, reserve));
	}

	template <typename T>
	static int resize_fill(T &arr[], int size, int reserve, T value)
	{
		resize(arr, size, reserve);
		return(::ArrayInitialize(arr, value));
	}

	template <typename T>
	static int resize_fill(T &arr[], int size, T value)
	{
		return(resize_fill(arr, size, _arr.default_reserve, value));
	}

	static int resize_fill(string &arr[], int size, int reserve, string value)
	{
		resize(arr, size);
		for (int i = 0; i < size; ++i)
			arr[i] = value;

		return(size);
	}

	static int resize_fill(string &arr[], int size, string value)
	{
		return(resize_fill(arr, size, _arr.default_reserve, value));
	}

	/*
	Добавить в массив значение и вернуть его индекс.
	Не работает с void*.
	@param arr[]    Массив, в который нужно добавить новое значение
	@param value    Значение
	@param reserve  Резерв памяти, см. описание стандартной функции ArrayResize(). По умолчанию 100.
	@return         Индекс добавленного элемента. В случае ошибки возвращается -1.
	*/
	template <typename T>
	static int add(T &arr[], T value, int reserve)
	{
		// Добавить новый элемент в массив
		const int new_size = ::ArrayResize(arr, ::ArraySize(arr) + 1, reserve);

		if (new_size == -1)
			return(-1);

		arr[new_size - 1] = value;
		return(new_size - 1);
	}

	template <typename T>
	static int add(T &arr[], T value)
	{
		return(add(arr, value, _arr.default_reserve));
	}


	/*
	Добавить в массив значение, если его ещё нет в массиве.
	Возвращает индекс элемента. Будет возвращён индекс первого найденного, он же будет единственным, если
	все значения в массив добавлялись этой функцией. В случае ошибки (нет памяти?) вернётся -1.
	*/
	template <typename T>
	static int set(T &arr[], T value, int reserve)
	{
		// Найти существующий
		const int i = index_of(arr, value);

		if (i != -1)
			return(i);

		// Добавить новый элемент в массив
		return(add(arr, value, reserve));
	}

	template <typename T>
	static int set(T &arr[], T value)
	{
		return(set(arr, value, _arr.default_reserve));
	}


	// Добавить в массив по ссылке, например структуру
	template <typename T>
	static int add_ref(T &arr[], T &value, int reserve)
	{
		// Добавить новый элемент в массив
		const int new_size = ::ArrayResize(arr, ::ArraySize(arr) + 1, reserve);

		if (new_size == -1)
			return(-1);

		arr[new_size - 1] = value;
		return(new_size - 1);
	}

	template <typename T>
	static int add_ref(T &arr[], T &value)
	{
		return(add_ref(arr, value, _arr.default_reserve));
	}

	/*
	Добавить в массив массив значений и вернуть новый размер. См. также add.
	@param add_arr    Массв добавляемых значений
	@param reserve    Резерв памяти, см. описание стандартной функции ArrayResize(). По умолчанию 100.
	@param arr        Массив, в который нужно добавить новые значения
	@return           Размер массива, в который добавляются элементы.
	*/
	template <typename T>
	static int add_array(T &arr[], const T &add_arr[], int reserve)
	{
		for (int i = 0, size = ::ArraySize(add_arr); i < size; ++i)
			add(arr, add_arr[i], reserve);

		return(::ArraySize(arr));
	}

	template <typename T>
	static int add_array(T &arr[], const T &add_arr[])
	{
		return(add_array(arr, add_arr, _arr.default_reserve));
	}

	// вернуть новый размер массива
	template <typename T>
	static int insert(T &arr[], T value, int pos, int reserve)
	{
		const int new_size = ::ArraySize(arr) + 1;
		::ArrayResize(arr, new_size, reserve);

		for (int i = new_size - 1; i > pos; --i)
			arr[i] = arr[i - 1];

		arr[pos] = value;
		return(new_size);
	}

	template <typename T>
	static int insert(T &arr[], T value, int pos)
	{
		return(insert(arr, value, pos, _arr.default_reserve));
	}

	// вернуть новый размер массива
	template <typename T>
	static int insert_array(T &arr[], const T &add_arr[], int pos, int reserve)
	{
		const int add_size = ::ArraySize(add_arr);
		const int new_size = ::ArraySize(arr) + add_size;

		if (add_size == 0)
			return(new_size);

		::ArrayResize(arr, new_size, reserve);


		const int pos_last = pos + add_size - 1;

		// переместить вправо для расчистки места в нужной позиции
		for (int i = new_size - 1; i > pos_last; --i)
			arr[i] = arr[i - add_size];

		// добавить новые значения
		for (int i = 0; i < add_size; ++i)
			arr[pos + i] = add_arr[i];

		return(new_size);
	}

	template <typename T>
	static int insert_array(T &arr[], const T &add_arr[], int pos)
	{
		return(insert_array(arr, add_arr, pos, _arr.default_reserve));
	}

	template <typename T>
	static bool is_equal(const T &arr1[], const T &arr2[])
	{
		return(compare(arr1, arr2) == 0);
	}

	/*
	Добавить в массив массив уникальных значений и вернуть новый размер. См. также set.
	@param set_arr    Массв устанавливаемых добавляемых значений
	@param reserve    Резерв памяти, см. описание стандартной функции ArrayResize(). По умолчанию 100.
	@param arr        Массив, в который нужно добавить новые значения
	@return           Размер массива, в который добавляются элементы.
	*/
	template <typename T>
	static int set_array(T &arr[], const T &set_arr[], int reserve)
	{
		for (int i = 0, size = ::ArraySize(set_arr); i < size; ++i)
			set(arr, set_arr[i], reserve);

		return(::ArraySize(arr));
	}

	template <typename T>
	static int set_array(T &arr[], const T &set_arr[])
	{
		return(set_array(arr, set_arr, _arr.default_reserve));
	}

	/*
	Удалить часть массива. Без проверки корректности границ.
	@param arr[]      Массив
	@param first      Начало части
	@param length     Длина части
	@return           Количество элементов в результате
	*/
	template <typename T>
	static int remove(T &arr[], int first, int length)
	{
		const int size = ::ArraySize(arr);

		if (length <= 0)
		{
			if (length < 0)
				_debug.warning(VAR("length < 0"));

			return(size);
		}

		T tmp[];
		const int tmp_size = size - length;
		::ArrayResize(tmp, tmp_size);

		// левая часть
		if (first > 0)
			::ArrayCopy(tmp, arr, 0, 0, first);

		// правая часть
		if (first + length < size)
			::ArrayCopy(tmp, arr, first, first + length);

		::ArrayResize(arr, tmp_size);
		return(::ArrayCopy(arr, tmp));
	}

	// remove 1
	template <typename T>
	static int remove(T &arr[], int pos)
	{
		return(remove(arr, pos, 1));
	}

	// Параметр reverse для удобства.
	// Функцию можно заменить установкой или снятием признака as series, но для избежания путаницы иногда лучше
	// обратить массив явно, если это не приведёт к лишним затратам.
	template <typename T>
	static void reverse(T &arr[], bool rev)
	{
		if (rev == false)
			return;

		const int size = ::ArraySize(arr);

		for (int i = 0, half_size = size / 2, last = size - 1; i < half_size; ++i)
		{
			T tmp = arr[i];
			arr[i] = arr[last - i];
			arr[last - i] = tmp;
			//Swap(arr[i], arr[last - i]);
		}
	}

	template <typename T>
	static void reverse(T &arr[])
	{
		reverse(arr, true);
	}


	template <typename TSrc, typename TDst>
	static int copy(TDst &dst[], const TSrc &src[], int dst_start = 0, int src_start = 0, int count = WHOLE_ARRAY)
	{
		return(::ArrayCopy(dst, src, dst_start, src_start, count));
	}

	// Клонировать массив. В отличие от ArrayCopy, размер выходного массива всегда равен размеру входного.
	// Параметры и результат совместимы с ArrayCopy.
	template <typename TSrc, typename TDst>
	static int clone(TDst &dst[], const TSrc &src[])
	{
		if (resize(dst, ::ArraySize(src)) < 0)
			return(0);

		return(::ArrayCopy(dst, src));
	}

	/*
	Проверка и коррекция границ диапазона для указанного массива. Выходные параметры должны обеспечивать
	безопасность обхода массива по ним.
	@param arr        Массив.
	@param first      Начальный элемент в массиве для обработки. Может быть отрицательным.
	@param count      Количество элементов для обрабтоки, <0 - до конца массива.
	@return           true, если границы в норме, либо их удалось привести к норме. false, если границы
	                  не пересекаются с массивом. Если массив пустой, то пересечения нет.
	*/
	template <typename T>
	static bool check_range(const T &arr[], int &first, int &count)
	{
		if (count == 0)
			return(false);

		const int size = ::ArraySize(arr);
		if (size <= 0)
			return(false);

		if (count < 0)
			count = size - first;

		const int arr_last = size - 1;
		int last = first + count - 1;

		if (last < 0)
			return(false);

		if (first > arr_last)
			return(false);

		if (first < 0)
			first = 0;

		if (last > arr_last)
			last = arr_last;

		// здесь count уже не может быть <=0 из-за проверок выше
		count = last - first + 1;
		return(true);
	}


	// ArrayMaximum в 4 и 5 имеют разный порядок параметров
	template <typename T>
	static int max_index(const T &arr[], int first, int count)
	{
#ifdef __MQL4__
		return(::ArrayMaximum(arr, count, first));
#else
		return(::ArrayMaximum(arr, first, count));
#endif
	}

	// ArrayMinimum в 4 и 5 имеют разный порядок параметров
	template <typename T>
	static int min_index(const T &arr[], int first, int count)
	{
#ifdef __MQL4__
		return(::ArrayMinimum(arr, count, first));
#else
		return(::ArrayMinimum(arr, first, count));
#endif
	}


	template <typename T> static int max_index(const T &arr[]) { return(max_index(arr, 0, ::ArraySize(arr))); }
	template <typename T> static int min_index(const T &arr[]) { return(min_index(arr, 0, ::ArraySize(arr))); }

	/*
	Remove duplicates inplace.
	@param src[]   source array
	@param dest[]  result array
	@return        number of elements in the result array, -1 on error
	*/
	template <typename T>
	static int deduplicate(T &arr[])
	{
		const int arr_size = ::ArraySize(arr);

		// prepare temp array with result
		T res[];
		if (resize(res, arr_size) < 0)
			return(-1);

		// deduplicate
		int res_size = 0;
		{
			for (int i = 0; i < arr_size; ++i)
			{
				if (index_of(res, arr[i], 0, res_size) < 0)
					res[res_size++] = arr[i];
			}
		}

		// return the data to the original array
		{
			if (resize(arr, res_size) < 0)
				return(-1);

			if (::ArrayCopy(arr, res, 0, 0, res_size) != res_size)
				return(-1);
		}

		return(res_size);
	}

	/*
	Remove duplicates.
	@param src[]   source array
	@param dest[]  result array
	@return        number of elements in the result array, -1 on error
	*/
	template <typename T>
	static int unique(const T &src[], T &dest[])
	{
		const int src_size = ::ArraySize(src);
		if (resize(dest, src_size) < 0)
			return(-1);

		// reset result
		int dest_size = 0;

		for (int i = 0; i < src_size; ++i)
		{
			if (index_of(dest, src[i], 0, dest_size) < 0)
				dest[dest_size++] = src[i];
		}

		if (resize(dest, dest_size) < 0)
			return(-1);

		return(dest_size);
	}


//test: после изменений 2019-04-05
	/*
	Сгруппировать массив, получить число вхождений.
	@param src[]    Исходный массив
	@param dest[]   Результирующий массив
	@param count[]  Результирующий массив с числами вхождений
	@return         Количество элементов в результате (количество уникальных значений в исходном массиве).
	                В случае ошибки возвращается -1.
	*/
	template <typename T>
	static int unique(const T &src[], T &dest[], int &count[])
	{
		const int src_size = ::ArraySize(src);
		if ((resize(dest, src_size) < 0) || (resize(count, src_size) < 0))
			return(-1);

		// Сброс результата
		int dest_size = 0;

		for (int i = 0; i < src_size; ++i)
		{
			int si = index_of(dest, src[i], 0, dest_size);

			if (si >= 0)
			{
				// увеличить счетчик вхождений
				count[si]++;
			}
			else
			{
				// добавить новый элемент в результат
				dest[dest_size] = src[i];
				count[dest_size] = 1;
				dest_size++;
			}
		}

		if ((resize(dest, dest_size) < 0) || (resize(count, dest_size) < 0))
			return(-1);

		return(dest_size);
	}

	/*
	Сшить массив в одну строку, используя указанный разделитель.
	@param arr[]      Массив.
	@param first      Начальный элемент в массиве для обработки. Без проверки корректности.
	@param count      Количество элементов для обрабтоки. Без проверки корректности.
	@param separator  Разделитель.
	@return           Строка-результат.
	*/
	template <typename T>
	static string to_string(const T &arr[], int first, int count, string separator)
	{
		if (count == 0)
			return("");

		string result = (string)arr[first];

		for (int i = first + 1, last = first + count - 1; i <= last; i++)
			result += separator + (string)arr[i];

		return(result);
	}

	/*
	Сшить массив в одну строку, используя указанный разделитель.
	@param arr[]      Массив.
	@param separator  Разделитель.
	@return           Строка-результат.
	*/
	template <typename T>
	static string to_string(const T &arr[], string separator)
	{
		return(to_string(arr, 0, ::ArraySize(arr), separator));
	}


	/*
	Сшить массив (double) в одну строку, используя указанный разделитель.
	@param arr[]      Массив.
	@param separator  Разделитель.
	@param digits     Количество знаков после запятой при преобразовании дробного числа в строку.
	@param padding    Выравнивание до указанного размера (по возможности). Положительное - справа, отрицательное - слева, 0 - не выравнивать.
	@return           Строка-результат.
	*/
	static string to_string(const double &arr[], string separator, int digits, int padding)
	{
		return(_ring.to_string(arr, -1, separator, digits, padding));
	}

	static string to_string(const double &arr[], string separator, int digits)
	{
		return(_ring.to_string(arr, -1, separator, digits, 0));
	}

	/*
	Сшить массив (float) в одну строку, используя указанный разделитель.
	@param arr[]      Массив.
	@param separator  Разделитель.
	@param digits     Количество знаков после запятой при преобразовании дробного числа в строку.
	@param padding    Выравнивание до указанного размера (по возможности). Положительное - справа, отрицательное - слева, 0 - не выравнивать.
	@return           Строка-результат.
	*/
	static string to_string(const float &arr[], string separator, int digits, int padding)
	{
		return(_ring.to_string(arr, -1, separator, digits, padding));
	}

	static string to_string(const float &arr[], string separator, int digits)
	{
		return(_ring.to_string(arr, -1, separator, digits, 0));
	}


	/*
	Сшить массив (datetime) в одну строку, используя указанный разделитель.

	@param arr[]      Массив.
	@param separator  Разделитель.
	@param flags      Формат вывода, см. стандартную функцию TimeToString.
	@return           Строка-результат.
	*/
	static string to_string(const datetime &arr[], const string separator, int flags)
	{
		const int size = ::ArraySize(arr);

		if (size == 0)
			return("");

		string result = TimeToString(arr[0], flags);

		for (int i = 1; i < size; i++)
			result += separator + TimeToString(arr[i], flags);

		return(result);
	}


	/*
	Сортировать массив.
	Алгоритм - сортировка Хоара / quicksort.

	@param array  Массив для сортировки.
	*/
	template <typename T>
	static void sort(T &arr[])
	{
		const int MAXSTACK = 64;
		int size = ::ArraySize(arr);
		if (size <= 0)
			return;

	 	// указатели, участвующие в разделении границы сортируемого в цикле фрагмента
		int i, j;
		int lb, ub;

		// стек запросов
		int lbstack[], ubstack[];
		::ArrayResize(lbstack, MAXSTACK);
		::ArrayResize(ubstack, MAXSTACK);

		// каждый запрос задается парой значений, а именно: левой(lbstack) и правой(ubstack) границами промежутка
		int stackpos = 1;  // текущая позиция стека
		int ppos;          // середина массива
		T pivot;           // опорный элемент
		T temp;

		lbstack[1] = 0;
		ubstack[1] = size - 1;

		do
		{
			// Взять границы lb и ub текущего массива из стека.
			lb = lbstack[stackpos];
			ub = ubstack[stackpos];
			stackpos--;

			do
			{
				// Шаг 1. Разделение по элементу pivot
				ppos = (lb + ub) >> 1;
				i = lb;
				j = ub;
				pivot = arr[ppos];

				do
				{
					while (arr[i] < pivot)
						i++;

					while (pivot < arr[j])
						j--;

					if (i <= j)
					{
						temp = arr[i];
						arr[i] = arr[j];
						arr[j] = temp;

						i++;
						j--;
					}
				}
				while (i <= j);

				// Сейчас указатель i указывает на начало правого подмассива,
				// j - на конец левого (см. иллюстрацию выше), lb ? j ? i ? ub.
				// Возможен случай, когда указатель i или j выходит за границу массива

				// Шаги 2, 3. Отправляем большую часть в стек и двигаем lb,ub
				if (i < ppos) // правая часть больше
				{
					if (i < ub) // если в ней больше 1 элемента - нужно сортировать, запрос в стек
					{
						stackpos++;
						lbstack[stackpos] = i;
						ubstack[stackpos] = ub;
					}

					ub = j; // следующая итерация разделения будет работать с левой частью
				}
				else // левая часть больше
				{
					if (j > lb)
					{
						stackpos++;
						lbstack[stackpos] = lb;
						ubstack[stackpos] = j;
					}

					lb = i;
				}
			}
			while (lb < ub); // пока в меньшей части более 1 элемента

		}
		while (stackpos != 0); // пока есть запросы в стеке
	}

	/*
	Сортировать массив.
	Алгоритм - сортировка Хоара / quicksort.

	@param array     Массив для сортировки.
	@param comparer  Указатель на функцию сравнения.
	*/
	template <typename T, typename TComparer>
	static void sort(T &arr[], const TComparer comparer)
	{
		const int MAXSTACK = 64;
		int size = ::ArraySize(arr);
	 	if (size <= 0)
			return;

	 	// указатели, участвующие в разделении границы сортируемого в цикле фрагмента
		int i, j;
		int lb, ub;

		// стек запросов
		int lbstack[], ubstack[];
		::ArrayResize(lbstack, MAXSTACK);
		::ArrayResize(ubstack, MAXSTACK);

		// каждый запрос задается парой значений, а именно: левой(lbstack) и правой(ubstack) границами промежутка
		int stackpos = 1;  // текущая позиция стека
		int ppos;          // середина массива
		T pivot;           // опорный элемент
		T temp;

		lbstack[1] = 0;
		ubstack[1] = size - 1;

		do
		{
			// Взять границы lb и ub текущего массива из стека.
			lb = lbstack[stackpos];
			ub = ubstack[stackpos];
			stackpos--;

			do
			{
				// Шаг 1. Разделение по элементу pivot
				ppos = (lb + ub) >> 1;
				i = lb;
				j = ub;
				pivot = arr[ppos];

				do
				{
					//while (arr[i] < pivot)
					while (comparer(arr[i], pivot) < 0)
						i++;

					//while (pivot < arr[j])
					while (comparer(pivot, arr[j]) < 0)
						j--;

					if (i <= j)
					{
						temp = arr[i];
						arr[i] = arr[j];
						arr[j] = temp;

						i++;
						j--;
					}
				}
				while (i <= j);

				// Сейчас указатель i указывает на начало правого подмассива,
				// j - на конец левого (см. иллюстрацию выше), lb ? j ? i ? ub.
				// Возможен случай, когда указатель i или j выходит за границу массива

				// Шаги 2, 3. Отправляем большую часть в стек и двигаем lb,ub
				if (i < ppos) // правая часть больше
				{
					if (i < ub) // если в ней больше 1 элемента - нужно сортировать, запрос в стек
					{
						stackpos++;
						lbstack[stackpos] = i;
						ubstack[stackpos] = ub;
					}

					ub = j; // следующая итерация разделения будет работать с левой частью
				}
				else // левая часть больше
				{
					if (j > lb)
					{
						stackpos++;
						lbstack[stackpos] = lb;
						ubstack[stackpos] = j;
					}

					lb = i;
				}
			}
			while (lb < ub); // пока в меньшей части более 1 элемента

		}
		while (stackpos != 0); // пока есть запросы в стеке
	}

	// сортировать строки без учёта регистра
	static void sort_text(string &arr[])
	{
		sort(arr, text_sorting_comparer());
	}


protected:

	static StringSortingComparer text_sorting_comparer()
	{
		return(CBStringUtil::compare_sorting);
	}

};

const int CBArrayUtil::default_reserve = 100;

CBArrayUtil _arr;
