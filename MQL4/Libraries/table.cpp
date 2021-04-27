#include "pch.h"

#include <fstream>
#include <iostream>
#include <string>

#define _DLLAPI extern "C" __declspec(dllexport)

_DLLAPI void __stdcall fn() {
    std::cout << __FILE__;
    std::ifstream ifs("table.csv");
    if (ifs.is_open()) {
        std::string line;
        while (std::getline(ifs, line)) {
            std::cout << __FILE__ << " " << line << std::endl;;
        }
        
    }
    std::system("pause");
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

