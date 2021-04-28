#include "pch.h"

#include <fstream>
#include <iostream>
#include <string>

struct some {
    int x, y;
};

#define _DLLAPI extern "C" __declspec(dllexport)

_DLLAPI void __stdcall ParseQuery(some& s) {
    s = { 1, 2 };
}