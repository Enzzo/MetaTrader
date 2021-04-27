#include "pch.h"

#include <fstream>
#include <iostream>
#include <string>

#define _DLLAPI extern "C" __declspec(dllexport)

_DLLAPI void __stdcall fn() {
    std::cout << "DEBUG..." << __FILE__;
    std::ifstream ifs("D://table.csv");
    if (ifs.is_open()) {
        std::string line;
        while (std::getline(ifs, line)) {
            std::cout << __FILE__ << " " << line << std::endl;;
        }        
    }
    std::system("pause");
}