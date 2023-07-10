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

// Singleton helpers. © FXcoder

#property strict

#define SINGLE_CONSTRUCTOR(T) void T() { }
#define SINGLE_CONSTRUCTOR_WITH(T, C) void T() { C; }
#define SINGLE_INSTANCE(T) static T *instance() { static T instance; return &instance; }
#define SINGLE_GET(T, N) T *N = T::instance();
