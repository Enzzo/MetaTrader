//+------------------------------------------------------------------+
//|                                                       210312.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
struct Signal{
   int x;
   int y;
};

#import "volume_stat.dll"
int fn(const int, const int);
Signal fn2(const Signal&, const double);
#import

#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   Signal s = {1, 2};
   Comment(fn2(s, 2).x);
   //ПОЛУЧАЕМ ИСТОРИЧЕСКУЮ СТАТИСТИКУ И ВНОСИМ ЕЁ В MAP, НАХОДЯЩИЙСЯ В DLL
   //КЛЮЧ MAP - ЭТО СИГНАЛ, ЗНАЧЕНИЕ - РЕЛЕВАНТНОСТЬ
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   Comment("");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+