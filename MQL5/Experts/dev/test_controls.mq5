//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"

#define TOSTR(x) #x

void OnStart(){
   int variable = 1;
   PrintFormat("V-Name is %s equals %d", TOSTR(variable), variable);
}