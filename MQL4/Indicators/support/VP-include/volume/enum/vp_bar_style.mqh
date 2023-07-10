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

// Стиль отображения столбца (гистограммы). © FXcoder

#property strict

/*
	- линия
	- пустой прямоугольник
	- закрашенный прямоугольник
	- контур
	- цвет
*/

enum ENUM_VP_BAR_STYLE
{
	VP_BAR_STYLE_LINE = 0,     // Line
	VP_BAR_STYLE_BAR = 1,      // Empty bar
	VP_BAR_STYLE_FILLED = 2,   // Filled bar
	VP_BAR_STYLE_OUTLINE = 3,  // Outline
	VP_BAR_STYLE_COLOR = 4     // Color
};
