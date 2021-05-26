//+------------------------------------------------------------------+
//|                                        20210525_trade_by_dxy.mq4 |
//|                                                   Sergey_Vasilev |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey_Vasilev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <trade.mqh>

input int      MAGIC    = 981939;
input string   SYMBOLS  = "AUDUSD EURUSD GBPUSD";
input string   DELIM    = " ";
input string   BASE     = "_DXY";

CTrade trade;

string symbols[];

void SplitIntoSymbols(const string&, const string&[], const string&);

datetime current[];
datetime prev = 0;
//DEBUG
template <typename T>
void ShowArray(const T&[]);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.Set
   SplitIntoSymbols(SYMBOLS, symbols, DELIM);
   ShowArray(symbols);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---

   //КАЖДЫЙ ЧАС
   CopyTime(BASE, PERIOD_H1, 1, 1, current);
   if(current[0] == prev){
      return;
   }
   prev = current[0];
   /////////////////////////////////////////
   
   
      //ПРОВЕРЯЕМ НАЛИЧИЕ ОТКРЫТЫХ ОРДЕРОВ
      
      //ЕСЛИ ОРДЕР СУЩЕСТВУЕТ
         //СИГНАЛЫ НА ЗАКРЫТИЕ
      
      //ЕСЛИ ОРДЕРА НЕТ И СЕССИЯ ОТКРЫТА
         //СИГНАЛЫ НА ОТКРЫТИЕ
}
//+------------------------------------------------------------------+

//query - строка, которую надо разделить
//delim - символ разделителя
void SplitIntoSymbols(const string& query, string& to[], const string& delim){
   
   int begin = 0;
   int end;
   int step = StringLen(delim);
   
   while(true){
      end = StringFind(query, delim, begin);
      if(end != -1){
         ArrayResize(to, ArraySize(to) + 1);
         to[ArraySize(to)-1] = StringSubstr(query, begin, end - begin);
         begin = end + step;
      }
      else{
         //заполнить последний кусок строки (если он валидный) и выйти
         ArrayResize(to, ArraySize(to) + 1);
         to[ArraySize(to)-1] = StringSubstr(query, begin, StringLen(query));
         return;
      }
   }
}

//DEBUG
template <typename T>
void ShowArray(const T& array[]){
   for(int i = 0; i < ArraySize(array); ++i){
      Print(array[i]);
   }
}