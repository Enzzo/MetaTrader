//+------------------------------------------------------------------+
//|                                               open_on_h1.mqh.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property description "бот для выставления двух отложенных Stop ордеров от текущей цены Bid"
#property description "на открытии нового часа (Н1) на определенном расстоянии"
#property description "от цены +/- N пунктов. Уровни Т/Р и S/L, треллинг стоп не уходящий в минус."
#property description "При открытии одного ордера – второй удаляется."

#define DEBUG

#include <dev/freelance/open_on_h1.mqh>

input int MAGIC = 9999;
input int TP = 30;
input int SL = 10;
input int OFFSET = 20;

OpenOnH1Model h1_model;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
  h1_model.Init(MAGIC, Symbol(), OFFSET, TP, SL);

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
   h1_model.Proccessing();
}
//+------------------------------------------------------------------+
