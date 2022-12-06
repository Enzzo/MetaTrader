//+------------------------------------------------------------------+
//|                                                       expert.mqh |
//|                                                           Sergey |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property strict

#include <custom\trade.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

typedef int (*SignalFunc)();

class Expert{
   CTrade      _trade;
   SignalFunc  _signals[];
   int         _magic;
   string      _symbol;
   string      _comment;
   
   
public:

   Expert(int magic = 0, const string symbol = Symbol(), const string comment = "") : _magic(magic), _symbol(symbol), _comment(comment)
   {
      
   }

   void SetSignal(SignalFunc Func){
      int size = ArraySize(_signals);
      ArrayResize(_signals, size + 1);
      _signals[size] = Func;
   }   
};