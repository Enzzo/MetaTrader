//+------------------------------------------------------------------+
//|                                                       210312.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#import "table.dll"
void fn();
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
   fn();
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