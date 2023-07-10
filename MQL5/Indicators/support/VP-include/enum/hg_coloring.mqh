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

// Histogram coloring. © FXcoder

#property strict

#include "../bsl.mqh"

enum ENUM_HG_COLORING
{
	HG_COLORING_NONE              = 0x0100,  // No histogram
	HG_COLORING_FIRST             = 0x0200,  // 1st color only
	HG_COLORING_SECOND            = 0x0300,  // 2nd color only

	HG_COLORING_MEAN              = 0x1100,  // Split by mean
	HG_COLORING_Q1                = 0x1200,  // Split by Q1 (25%)
	HG_COLORING_Q2                = 0x1300,  // Split by Q2 (50%, median)
	HG_COLORING_Q3                = 0x1400,  // Split by Q3 (75%)

	HG_COLORING_QUARTILES         = 0x2100,  // Quartile gradient
	HG_COLORING_GRADIENT10        = 0x2200,  // Gradient (10 levels)
	HG_COLORING_GRADIENT50        = 0x2300,  // Gradient (50 levels)
};

bool EnumHGColoringIsMulticolor(ENUM_HG_COLORING hg_coloring)
{
	return((hg_coloring != HG_COLORING_NONE) && (hg_coloring != HG_COLORING_FIRST) && (hg_coloring != HG_COLORING_SECOND));
}

int EnumHGColoringToLevels(ENUM_HG_COLORING hg_coloring, const double &values[], double &levels[])
{
	/*
	Идея в том, что все типы цветового оформления представлены как градиент. Есть вырожденные случаи
		NONE, FIRST и SECOND. В первом случае не рисуется вообще ничего, во втором и третьем -
		рисуются только начало и конец градиента. Остальные варианты предполагают разделение на
		уровни по указанному критерию. NONE не нужно пытаться подогнать под гридиент, т.к. уже есть
		флаг включения отображения гистограммы, достаточно добавить в условие проверку типа раскраски
		на NONE.

	Кажется, что есть отдельный класс - двухуровневые градиенты, они на самом деле полностью ложатся
		в концепт градиентов с любым числом уровней.

	Одноцветные варианты также можно привести к градиенту, указав уровни за границами значений.
		Для использования только первого цвета, уровень второго цвета можно указать выше максимума,
		тогда переключения на него не произойдёт. Для второго цвета уровень второго цвета указать как
		минимальное значение или чуть ниже в зависимости от способа выбора границ.

	Старый и единственный вариант с плавным градиентом можно просто представить как градиент с
		большим числом уровней. Использование ограниченного числа цветов (у каждого уровня только
		один цвет) будет даже полезно, т.к. в МТ при превышении числа цветов 256 начинаются всякие
		цветные глюки (по крайней мере в 4 в старых билдах, надо перепроверить).

	Медиана может быть понята по-разному. Например, медиана объёмов 99, 100 и 101 может быть взята
		как 100, а может быть и как 50. Со средней такого не происходит, т.к. средняя ассоциируется
		лишь со значениями, т.е. в данном случае это будет 100. Здесь только медиана по значению.

	При использовании значения будут сравниваться по очереди с каждым следующим уровнем. Если
		значение будет больше или равно уровню, то будет использован его цвет. Номер цвета из
		градиента будет взят по индексу уровня. Предполагается, что сравнение происходит по очереди,
		начиная с конца.
	*/

	switch (hg_coloring)
	{
		case HG_COLORING_NONE:
			ArrayResize(levels, 0);
			return(0);

		case HG_COLORING_FIRST:
			ArrayResize(levels, 2);
			levels[0] = _math.min(values) - 1; // совпадёт всегда
			levels[1] = _math.max(values) + 1; // никогда не совпадёт
			return(2);

		case HG_COLORING_SECOND:
			ArrayResize(levels, 2);
			levels[0] = _math.max(values) + 1; // никогда не совпадёт
			levels[1] = _math.min(values) - 1; // совпадёт всегда
			return(2);

		case HG_COLORING_MEAN:
			ArrayResize(levels, 2);
			levels[0] = _math.min(values);
			levels[1] = _math.mean(values);
			return(2);

		case HG_COLORING_Q1:
			{
				ArrayResize(levels, 2);
				double quartiles[];
				_math.quantiles(values, false, 0, ArraySize(values), quartiles);
				levels[0] = 0;
				levels[1] = quartiles[0];
				return(2);
			}

		case HG_COLORING_Q2:
			ArrayResize(levels, 2);
			levels[0] = _math.min(values);
			levels[1] = _math.median(values);
			return(2);

		case HG_COLORING_Q3:
			{
				ArrayResize(levels, 2);
				double quartiles[];
				_math.quantiles(values, false, 0, ArraySize(values), quartiles);
				levels[0] = 0;
				levels[1] = quartiles[2];
				return(2);
			}

		case HG_COLORING_QUARTILES:
			{
				ArrayResize(levels, 4);
				double quartiles[];
				_math.quantiles(values, false, 0, ArraySize(values), quartiles);
				levels[0] = 0;
				levels[1] = quartiles[0];
				levels[2] = quartiles[1];
				levels[3] = quartiles[2];
				return(4);
			}

		case HG_COLORING_GRADIENT10:
			{
				ArrayResize(levels, 10);
				const double step = (_math.max(values) - _math.min(values)) / 10.0;
				for (int i = 0; i < 10; ++i)
					levels[i] = i * step;

				return(10);
			}

		case HG_COLORING_GRADIENT50:
			{
				ArrayResize(levels, 50);
				const double step = (_math.max(values) - _math.min(values)) / 50.0;

				for (int i = 0; i < 50; ++i)
					levels[i] = i * step;

				return(50);
			}
	}

	return(-1);
}
